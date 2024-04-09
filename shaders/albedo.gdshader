shader_type spatial;

// Expose the albedo color as a parameter
uniform vec4 albedo_color: source_color;

void fragment() {
    // Set the shading mode to unshaded
    ALBEDO = albedo_color.rgb;
    ALPHA = albedo_color.a;
}