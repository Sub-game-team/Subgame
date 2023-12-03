shader_type canvas_item;

uniform vec4 tint_color : source_color = vec4(0.1, 0.69, 0.33, 0.3);
uniform float glow_amount : hint_range(0.0, 1.0) = 0.1;
uniform float glow_threshold : hint_range(0.0, 1.0) = 0.8;
uniform float outline_width : hint_range(0.0, 0.1) = 0.1;

void vertex() {
    // No need to modify UV coordinates for a 2D shader
}

void fragment() {
    // Use the UV coordinates directly without modification
    vec4 original_color = texture(TEXTURE, UV);

    // Apply tint color
    vec4 tinted_color = original_color * tint_color;

    // Calculate glow color
    vec4 glow_color = vec4(tint_color.rgb, 1.0) * glow_amount;

    // Apply threshold to limit the glow
    vec4 glow = mix(vec4(0.0, 0.0, 0.0, 0.0), glow_color, smoothstep(glow_threshold, 1.0, original_color.a));

    // Calculate outline
    vec4 outline = smoothstep(1.0 - outline_width, 1.0, original_color.a) * vec4(tint_color.rgb, 1.0) * (1.0 - tint_color.a);

    // Combine the original color, glow, and outline
    vec4 final_color = tinted_color + glow + outline;

    COLOR = final_color;
}
