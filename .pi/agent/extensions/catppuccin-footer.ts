import { appendFileSync } from "node:fs";
import { homedir } from "node:os";
import { basename, join } from "node:path";
import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { truncateToWidth, visibleWidth } from "@mariozechner/pi-tui";

function formatCompact(n: number): string {
	if (n >= 1_000_000) return `${(n / 1_000_000).toFixed(1)}M`;
	if (n >= 1_000) return `${Math.round(n / 100) / 10}k`;
	return `${n}`;
}

function formatContext(tokens?: number, maxTokens?: number): string {
	if (!tokens) return "ctx --";
	if (!maxTokens) return `ctx ${formatCompact(tokens)}`;
	return `ctx ${formatCompact(tokens)}/${formatCompact(maxTokens)}`;
}

type GitState = {
	initialized: boolean;
	stagedCount: number;
	unstagedCount: number;
};

type UsageQuotaState = {
	fiveHourUsage?: string;
	fiveHourLimit?: string;
	weeklyUsage?: string;
	weeklyLimit?: string;
};

function firstHeader(headers: Record<string, string>, ...names: string[]): string | undefined {
	for (const name of names) {
		const value = headers[name.toLowerCase()];
		if (value) return value;
	}
	return undefined;
}

function formatQuotaValue(value?: string): string {
	if (!value) return "--";
	const n = Number(value);
	if (Number.isFinite(n)) return `${n}%`;
	return value;
}

function formatRemainingQuotaValue(value?: string): string {
	if (!value) return "--";
	const n = Number(value);
	if (Number.isFinite(n)) return `${Math.max(0, 100 - n)}%`;
	return value;
}

function pickInterestingHeaders(headers: Record<string, string>): Record<string, string> {
	return Object.fromEntries(
		Object.entries(headers).filter(([key]) =>
			/(usage|limit|week|weekly|hour|5h|rate|claude|anthropic|x-)/i.test(key),
		),
	);
}

export default function (pi: ExtensionAPI) {
	const headerLogPath = join(homedir(), ".pi", "provider-response-headers.log");
	let enabled = true;
	let gitState: GitState = {
		initialized: false,
		stagedCount: 0,
		unstagedCount: 0,
	};
	let usageQuotaState: UsageQuotaState = {};

	const refreshGitState = async (ctx: any) => {
		const insideWorkTree = await pi
			.exec("git", ["rev-parse", "--is-inside-work-tree"], { cwd: ctx.cwd })
			.catch(() => null);
		if (!insideWorkTree || insideWorkTree.code !== 0 || insideWorkTree.stdout.trim() !== "true") {
			gitState = {
				initialized: false,
				stagedCount: 0,
				unstagedCount: 0,
			};
			return;
		}

		const status = await pi.exec("git", ["status", "--porcelain"], { cwd: ctx.cwd }).catch(() => null);
		if (!status || status.code !== 0) {
			gitState = {
				initialized: true,
				stagedCount: 0,
				unstagedCount: 0,
			};
			return;
		}

		let stagedCount = 0;
		let unstagedCount = 0;
		for (const line of status.stdout.split("\n")) {
			if (!line) continue;
			const x = line[0] ?? " ";
			const y = line[1] ?? " ";
			if (x !== " " && x !== "?") stagedCount++;
			if (y !== " " || x === "?") unstagedCount++;
		}

		gitState = {
			initialized: true,
			stagedCount,
			unstagedCount,
		};
	};

	const refreshUsageQuotaState = (headers: Record<string, string>) => {
		usageQuotaState = {
			fiveHourUsage: firstHeader(
				headers,
				"x-codex-primary-used-percent",
				"anthropic-ratelimit-5-hour-usage",
				"anthropic-ratelimit-5h-usage",
				"x-claude-code-5-hour-usage",
				"x-claude-code-5h-usage",
				"claude-code-5-hour-usage",
				"claude-code-5h-usage",
			),
			fiveHourLimit: firstHeader(
				headers,
				"x-codex-primary-limit-percent",
				"anthropic-ratelimit-5-hour-limit",
				"anthropic-ratelimit-5h-limit",
				"x-claude-code-5-hour-limit",
				"x-claude-code-5h-limit",
				"claude-code-5-hour-limit",
				"claude-code-5h-limit",
			),
			weeklyUsage: firstHeader(
				headers,
				"x-codex-secondary-used-percent",
				"anthropic-ratelimit-weekly-usage",
				"x-claude-code-weekly-usage",
				"claude-code-weekly-usage",
			),
			weeklyLimit: firstHeader(
				headers,
				"x-codex-secondary-limit-percent",
				"anthropic-ratelimit-weekly-limit",
				"x-claude-code-weekly-limit",
				"claude-code-weekly-limit",
			),
		};
	};

	const applyFooter = (ctx: any) => {
		if (!enabled) {
			ctx.ui.setFooter(undefined);
			return;
		}

		ctx.ui.setFooter((tui, theme, footerData) => {
			const unsub = footerData.onBranchChange(() => tui.requestRender());

			return {
				dispose: unsub,
				invalidate() {},
				render(width: number): string[] {
					const project = basename(ctx.cwd);
					const baseBranch = footerData.getGitBranch();
					const branchMarkers = [
						gitState.stagedCount > 0 ? theme.fg("success", `+${gitState.stagedCount}`) : "",
						gitState.unstagedCount > 0 ? theme.fg("warning", `~${gitState.unstagedCount}`) : "",
					]
						.filter(Boolean)
						.join(" ");
					const branch = baseBranch
						? branchMarkers
							? `${baseBranch} ${branchMarkers}`
							: baseBranch
						: "";
					const thinking = pi.getThinkingLevel();
					const model = ctx.model?.id ?? "no-model";
					const usage = ctx.getContextUsage?.();
					const statuses = [...footerData.getExtensionStatuses().values()].filter(Boolean);
					const mode = statuses[0] ? `  •  ${statuses[0]}` : "";

					const sep = theme.fg("dim", "  •  ");
					const leftParts = [theme.fg("accent", project)];
					if (gitState.initialized && branch) {
						leftParts.push(theme.fg("borderAccent", branch));
					}
					const left = leftParts.join(sep);

					const thinkingBadge = theme.bg("selectedBg", ` ${theme.fg("accent", thinking)} `);
					const fiveHourQuota = theme.fg("muted", `5h ${formatRemainingQuotaValue(usageQuotaState.fiveHourUsage)}`);
					const weeklyQuota = theme.fg("muted", `wk ${formatRemainingQuotaValue(usageQuotaState.weeklyUsage)}`);
					const right = [
						thinkingBadge,
						theme.fg("text", model),
						theme.fg("muted", formatContext(usage?.tokens, ctx.model?.contextWindow)),
						fiveHourQuota,
						weeklyQuota,
					].join(sep);

					const rightWidth = visibleWidth(right);
					const availableLeft = Math.max(0, width - rightWidth - visibleWidth(mode) - 1);
					const leftTruncated = truncateToWidth(left, availableLeft, "");
					const pad = " ".repeat(
						Math.max(1, width - visibleWidth(leftTruncated) - visibleWidth(mode) - rightWidth),
					);

					return [truncateToWidth(leftTruncated + mode + pad + right, width, "")];
				},
			};
		});
	};

	pi.on("session_start", async (_event, ctx) => {
		await refreshGitState(ctx);
		applyFooter(ctx);
	});

	pi.on("turn_end", async (_event, ctx) => {
		await refreshGitState(ctx);
		applyFooter(ctx);
	});

	pi.on("after_provider_response", async (event, ctx) => {
		const interestingHeaders = pickInterestingHeaders(event.headers);
		appendFileSync(
			headerLogPath,
			`${new Date().toISOString()} [${event.status}] ${JSON.stringify(interestingHeaders, null, 2)}\n\n`,
			"utf8",
		);
		refreshUsageQuotaState(event.headers);
		applyFooter(ctx);
	});

	pi.registerCommand("catfooter", {
		description: "Toggle the Catppuccin custom footer",
		handler: async (args, ctx) => {
			const value = args.trim().toLowerCase();
			if (value === "refresh") {
				await refreshGitState(ctx);
				applyFooter(ctx);
				ctx.ui.notify("Catppuccin footer refreshed", "info");
				return;
			}
			if (value === "headers") {
				ctx.ui.notify(`Header log: ${headerLogPath}`, "info");
				return;
			}
			if (value === "debug") {
				ctx.ui.notify(
					`5h ${formatRemainingQuotaValue(usageQuotaState.fiveHourUsage)} • wk ${formatRemainingQuotaValue(usageQuotaState.weeklyUsage)}`,
					"info",
				);
				return;
			}
			if (value === "on") enabled = true;
			else if (value === "off") enabled = false;
			else enabled = !enabled;

			await refreshGitState(ctx);
			applyFooter(ctx);
			ctx.ui.notify(enabled ? "Catppuccin footer enabled" : "Default footer restored", "info");
		},
	});
}
