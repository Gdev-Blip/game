// Evento Draw
draw_self()
draw_set_font(fnt_ui);
var texto = "Vida: ";
var valor = string(global.vidaplayer);

// Parte 1: el texto fijo
draw_set_color(c_white);
draw_text(x - 110, y - 90, texto);

// Parte 2: el valor, justo después del texto
var ancho = string_width(texto); // mide el ancho de la parte 1
draw_set_color(c_red);
draw_text(x - 110 + ancho, y - 90, valor);
