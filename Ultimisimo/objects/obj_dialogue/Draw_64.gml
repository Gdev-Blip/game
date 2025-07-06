

/// obj_dialogue — Draw GUI Event

if (!is_active) return;

// 1) Dibujo de retrato
draw_set_color(c_white);
draw_sprite_ext(
    portrait_sprite,
    0,
    portrait_x,
    portrait_y,
    1, 1,
    0,
    c_white,
    1
);

// 2) Fondo semitransparente
draw_set_color(make_color_rgb(0, 0, 0));
draw_set_alpha(0.6);
draw_roundrect(box_x, box_y, box_x + box_w, box_y + box_h, false);
draw_set_alpha(1);

// 3) Borde blanco
draw_set_color(c_white);
draw_roundrect(box_x, box_y, box_x + box_w, box_y + box_h, true);

// 4) Texto con efecto typewriter
var visible_text = "";
if (letter_index > 0) {
    visible_text = string_copy(txt_full, 1, letter_index);
}
var max_text_w = box_w - 2 * text_margin_x;
draw_set_font(font_dialog);
draw_set_color(c_white);
draw_text_ext(
    box_x + text_margin_x,
    box_y + text_margin_y,
    visible_text,
    0,
    max_text_w
);

// 5) Hint de avance
if (letter_index >= txt_length) {
    var hint = "(ENTER → siguiente)";
    var hint_w = string_width(hint);
    draw_set_color(c_white);
    draw_text(
        (box_x + box_w) - hint_w - 8,
        box_y + box_h - 24,
        hint
    );
}
