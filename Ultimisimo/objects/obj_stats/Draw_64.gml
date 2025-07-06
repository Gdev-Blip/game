if (personaje == noone) exit;

var x_base = 400; // X derecha de pantalla (ajustá si tu GUI es más ancha)
var y_base = 100;

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);

draw_text(x_base, y_base, "Nombre: " + string(nombre));
draw_text(x_base, y_base + 30, "Fuerza: " + string(fuerza));
draw_text(x_base, y_base + 60, "Velocidad: " + string(velocidad));
draw_text(x_base, y_base + 90, "Inteligencia: " + string(inteligencia));
