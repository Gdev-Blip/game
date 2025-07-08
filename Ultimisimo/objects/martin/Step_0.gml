// Inicialización defensiva (por si GameMaker se adelanta)
if (!variable_instance_exists(id, "original_x")) {
    original_x = x;
    target_x = x;
    clicked = false;
    scale_x = 1;
}

// Hover
var esta_hover = point_in_rectangle(mouse_x, mouse_y, x - sprite_width / 2, y - sprite_height / 2, x + sprite_width / 2, y + sprite_height / 2);

// Solo uno puede tener el hover activo
if (esta_hover && global.hover_id == noone) {
    hovered = true;
    global.hover_id = id;
} else if (global.hover_id != id) {
    hovered = false;
}

// Si clickeo uno
if (mouse_check_button_pressed(mb_left) && hovered && !clicked) {
    clicked = true;
    target_x = 100;
    scale_x = -1;
 layer_set_visible("selectM", true);

    with (all) {
        if (id != other.id && object_index != obj_volver) {
            visible = false;
        }
    }

    var volver = instance_create_layer(20, 20, "ui_layer", obj_volver);
    volver.original_x = volver.x;
    volver.target_x = volver.x;
    volver.texto = "VOLVER";
    volver.spr_instanciado = false;
} else if (!clicked) {
    layer_set_visible("selectM", false);
}

// Movimiento suave
x = lerp(x, target_x, 0.1);

// Hover visual
var target_scale = hovered && !clicked ? 1.2 : 1;
scale = lerp(scale, target_scale, 0.1);
global.hover_id = noone;
