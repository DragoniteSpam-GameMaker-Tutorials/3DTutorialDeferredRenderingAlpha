shader_set(shd_deferred_combine);
surface_set_target(self.surf_combine);

var sampler_depth = shader_get_sampler_index(shd_deferred_combine, "samp_depth");
var sampler_normal = shader_get_sampler_index(shd_deferred_combine, "samp_normal");
texture_set_stage(sampler_depth, surface_get_texture_depth(self.gbuff_diffuse));
texture_set_stage(sampler_normal, surface_get_texture(self.gbuff_normal));

var u_znear = shader_get_uniform(shd_deferred_combine, "u_znear");
var u_zfar = shader_get_uniform(shd_deferred_combine, "u_zfar");
shader_set_uniform_f(u_znear, 1);
shader_set_uniform_f(u_zfar, 8_000);
var u_fov_scale = shader_get_uniform(shd_deferred_combine, "u_fov_scale");
var fov = 60;
var aspect = 16 / 9;
shader_set_uniform_f(u_fov_scale, dtan(fov / 2) * aspect, dtan(-fov / 2));


var u_light_direction = shader_get_uniform(shd_deferred_combine, "u_light_direction");
var light_dx = -1;
var light_dy = -1;
var light_dz = -1;
var transformed = matrix_transform_vertex(self.mat_view, light_dx, light_dy, light_dz, 0);
shader_set_uniform_f(u_light_direction, transformed[0], transformed[1], transformed[2]);


var u_light_point = shader_get_uniform(shd_deferred_combine, "u_light_point");
var light_x = 100;
var light_y = 150;
var light_z = 200;
transformed = matrix_transform_vertex(self.mat_view, light_x, light_y, light_z);
shader_set_uniform_f(u_light_point, transformed[0], transformed[1], transformed[2]);

draw_surface_stretched(self.gbuff_diffuse, 0, 0, window_get_width(), window_get_height());
shader_reset();

surface_reset_target();


draw_3d_transparency();


draw_surface(self.surf_combine, 0, 0);

draw_surface_ext(self.gbuff_diffuse, 0, 0, 0.25, 0.25, 0, c_white, 1);
draw_surface_ext(self.gbuff_normal, 0, 180, 0.25, 0.25, 0, c_white, 1);
draw_surface_ext(self.gbuff_vs_position, 0, 360, 0.25, 0.25, 0, c_white, 1);