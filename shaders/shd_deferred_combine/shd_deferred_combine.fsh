varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform sampler2D samp_depth;
uniform sampler2D samp_normal;

uniform float u_znear;
uniform float u_zfar;
uniform vec2 u_fov_scale;

float LinearizeDepth(float depth, float znear, float zfar) {
    depth = depth * 2.0 - 1.0;
	return (2.0 * znear) / (zfar + znear - depth * (zfar - znear));
}

vec3 GetVSPosition(float fragment_depth, vec2 screen_position, vec2 fov_scale) {
#if !(defined(_YY_HLSL11_) || defined(_YY_PSSL_))
    fov_scale.y *= -1.0;
#endif
    return vec3(fov_scale * (screen_position - 0.5) * 2.0 * fragment_depth, fragment_depth);
}

uniform vec3 u_light_direction;
uniform vec3 u_light_point;

void main()
{
    vec4 color_diffuse = texture2D(gm_BaseTexture, v_vTexcoord);
    float color_depth = texture2D(samp_depth, v_vTexcoord).r;
    vec3 color_normal = texture2D(samp_normal, v_vTexcoord).rgb;
    
    vec3 fragment_normal = (color_normal - 0.5) * 2.0;
    float linear_depth = LinearizeDepth(color_depth, u_znear, u_zfar);
    float fragment_depth = linear_depth * (u_zfar - u_znear) + u_znear;
    
    vec3 fragment_position = GetVSPosition(fragment_depth, v_vTexcoord, u_fov_scale);
    
    
    
    vec3 ambient_light = vec3(0.1);
    vec3 light_total = ambient_light;
    
    vec3 dir_light_color = vec3(0.8);
    float NdotL = max(0.0, dot(fragment_normal, -normalize(u_light_direction)));
    
    light_total += dir_light_color * NdotL;
    
    
    
    
    vec3 point_light_color = vec3(0.8, 0.9, 0.1);
    float point_radius = 500.0;
    vec3 L = normalize(u_light_point - fragment_position);
    NdotL = max(0.0, dot(fragment_normal, L));
    float dist = distance(u_light_point, fragment_position);
    float att = clamp((point_radius - dist) / point_radius, 0.0, 1.0);
    
    light_total += point_light_color * NdotL * att;
    
    
    
    //gl_FragColor = vec4(linear_depth, linear_depth, linear_depth, 1);
    //gl_FragColor = vec4(view_position / 100.0, 1);
    
    light_total = min(vec3(1), light_total);
    
    vec3 final_color = color_diffuse.rgb * light_total;
    
    
    vec3 fog_color = vec3(0, 0.8, 1);
    float fog_start = 600.0;
    float fog_end = 3000.0;
    
    float fraction = clamp((fragment_depth - fog_start) / (fog_end - fog_start), 0.0, 1.0);
    final_color = mix(final_color, fog_color, fraction);
    
    
    gl_FragColor = vec4(final_color, 1);
}
