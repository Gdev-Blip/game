draw_sprite_ext(sprite_index, image_index, x, y, scale, scale, 0, image_blend, image_alpha);
if (clicked) {
    var texto = "Estadísticas";
    var tx = x + 680;
    var ty = y - 300
    var tw = string_width(texto);
    var th = string_height(texto);
    
    draw_set_color(c_black);
    draw_rectangle(tx - 4, ty - 2, tx + tw + 4, ty + th + 2, false);
    
    draw_set_color(c_white);
    draw_text(tx, ty, texto);
}
