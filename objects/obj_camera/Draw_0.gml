surface_set_target(self.gbuff_diffuse);
surface_set_target_ext(1, self.gbuff_normal);
surface_set_target_ext(2, self.gbuff_vs_position);
shader_set(shd_deferred_gbuff);

draw_clear(c_black);

var xto = self.player.x;
var yto = self.player.y;
var zto = self.player.z + 16;
var xfrom = xto + self.player.distance * dcos(self.player.direction) * dcos(self.player.pitch);
var yfrom = yto - self.player.distance * dsin(self.player.direction) * dcos(self.player.pitch);
var zfrom = zto - self.player.distance * dsin(self.player.pitch);

self.mat_view = matrix_build_lookat(xfrom, yfrom, zfrom, xto, yto, zto, 0, 0, 1);

draw_3d_world();