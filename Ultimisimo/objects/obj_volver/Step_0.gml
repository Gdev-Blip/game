if (!variable_instance_exists(id, "original_x")) exit;

x = lerp(x, target_x, 0.1);

// Si se clickea el botón volver
if (mouse_check_button_pressed(mb_left)) {
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);

    // Asumimos que el botón mide 100x40 (ajustá si es necesario)
    if (point_in_rectangle(mx, my, x - 50, y - 20, x + 50, y + 20)) {

        // Restaurar cada personaje
        if (instance_exists(guille)) {
            with (guille) {
                if (variable_instance_exists(id, "original_x")) {
                    target_x = original_x;
                    clicked = false;
                    visible = true;
                    image_xscale = 1;
                    scale_x = 1;
                }
            }
        }

        if (instance_exists(martin)) {
            with (martin) {
                if (variable_instance_exists(id, "original_x")) {
                    target_x = original_x;
                    clicked = false;
                    visible = true;
                    image_xscale = 1;
                    scale_x = 1;
                }
            }
        }

        if (instance_exists(sofiE)) {
            with (sofiE) {
                if (variable_instance_exists(id, "original_x")) {
                    target_x = original_x;
                    clicked = false;
                    visible = true;
                    image_xscale = 1;
                    scale_x = 1;
                }
            }
        }

        // Destruir visual del botón (si lo hay)
        with (obj_volverspr) instance_destroy();

        // Destruir el botón
        instance_destroy();
    }
}
