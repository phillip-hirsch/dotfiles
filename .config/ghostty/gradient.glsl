vec3 rgb(float r, float g, float b) {
    return vec3(r/255.0, g/255.0, b/255.0); // Input RGB values in the range 0-255
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) 
{
    // Normalize pixel coordinates (range from 0 to 1)
    vec2 uv = fragCoord.xy / iResolution.xy;

    // Create a gradient from bottom right to top left as a function (x + y)/2
    float gradientFactor = (uv.x + uv.y) / 2.0;

    // Define gradient colors (adjust to your preference)
    // vec3 gradientStartColor = vec3(0.1, 0.1, 0.5); // Start color (e.g., dark blue)
    // vec3 gradientEndColor = vec3(0.5, 0.1, 0.1); //      End color (e.g., dark red)
    vec3 gradientStartColor = rgb(30, 30, 46);
    vec3 gradientEndColor = rgb(49, 50, 68);

    vec3 gradientColor = mix(gradientStartColor, gradientEndColor, gradientFactor);

    // Sample the terminal screen texture including alpha channel
    vec4 terminalColor = texture(iChannel0, uv);

    // Make a mask that is 1.0 where the terminal content is not black
    float mask = 1 - step(0.5, dot(terminalColor.rgb, vec3(1.0)));
    vec3 blendedColor = mix(terminalColor.rgb, gradientColor, mask);

    // Apply terminal's alpha to control overall opacity
    fragColor = vec4(blendedColor, terminalColor.a);
}
