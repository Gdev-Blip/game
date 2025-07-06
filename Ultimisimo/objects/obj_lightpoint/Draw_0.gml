// Iluminación 2D UltraSuave con Fix Anti-Cutre para Rayos Rectos
// Pega en el Draw Event de obj_lightpoint

// Ajustes
var ox = x, oy = y;
var rays_length = 600;
var num_rays = 512;   // Más rayos = menos "polígono cutre"
var grad_steps = 128; // Blur más soft todavía
var color_centro = make_color_rgb(80, 150, 80);

// 1. Calcular rayos con anti-borde-cutre (suaviza los "ángulos" duros)
var rays = array_create(num_rays);
for (var i = 0; i < num_rays; i++) {
    var angle = i * (360 / num_rays);
    var dx = lengthdir_x(rays_length, angle);
    var dy = lengthdir_y(rays_length, angle);
    var hit = collision_line(ox, oy, ox + dx, oy + dy, obj_suelo, false, true);
    var endx, endy;
    if (hit != noone) {
        // Precisión por pasos
        var found = false;
        for (var s = 0; s <= rays_length; s += 1) { // Paso de a 1 pixel para suavizar más
            var px = ox + lengthdir_x(s, angle);
            var py = oy + lengthdir_y(s, angle);
            if (position_meeting(px, py, obj_suelo)) {
                endx = px;
                endy = py;
                found = true;
                break;
            }
        }
        if (!found) {
            endx = hit.x;
            endy = hit.y;
        }
    } else {
        endx = ox + dx;
        endy = oy + dy;
    }
    rays[i] = [endx, endy];
}

// 2. Blur ultra soft
for (var step = grad_steps; step > 0; step--) {
    var ratio = step / grad_steps;
    var alpha = 0.027 * power(ratio, 0.8); // Ajusta para más o menos brillo
    draw_set_alpha(alpha);
    var col = merge_color(color_centro, c_black, 1 - power(ratio, 0.6));
    draw_set_color(col);
    draw_primitive_begin(pr_trianglefan);
    draw_vertex(ox, oy);
    for (var i = 0; i < num_rays; i++) {
        var pt = rays[i];
        var sx = ox + (pt[0] - ox) * ratio;
        var sy = oy + (pt[1] - oy) * ratio;
        draw_vertex(sx, sy);
    }
    draw_primitive_end();
}
draw_set_alpha(1);

// Fixes:
// - Más rayos y pasos pequeños = bordes curvos suaves (no "polígonos cutres").
// - Blur más soft (no escalonado).
// - Si sigue notándose "recto", el problema puede ser que tu obj_suelo es muy cuadrado y los rayos tangenciales lo destacan.
//   En ese caso, debes aumentar AÚN MÁS num_rays o usar un filtro suavizador post-process (surface blur/gaussian en surface, nivel pro).