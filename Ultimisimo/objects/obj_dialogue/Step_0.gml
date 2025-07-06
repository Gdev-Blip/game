/// obj_dialogue — Step Event

// 1) Si NO hay diálogo activo: restaurar jugador si acaba de terminar
if (!is_active) {
    if (dialogue_locked) {
        if (instance_exists(obj_player)) {
            with (obj_player) {
                limite        = saved_limite;
                salto_fuerza  = saved_salto_fuerza;
                aceleracion   = saved_aceleracion;
                puede_dashear = saved_puede_dashear;
                puede_tp      = saved_puede_tp;
            }
        }
        dialogue_locked = false;
    }
}
else {
    // 2) Diálogo activo: guardar estado y bloquear habilidades la primera vez
    if (!dialogue_locked) {
        if (instance_exists(obj_player)) {
            saved_limite        = player_ref.limite;
            saved_salto_fuerza  = player_ref.salto_fuerza;
            saved_aceleracion   = player_ref.aceleracion;
            saved_puede_dashear = player_ref.puede_dashear;
            saved_puede_tp      = player_ref.puede_tp;
        }
        dialogue_locked = true;
    }

    // 3) Mientras is_active, deshabilitar siempre dash/teleporte
    if (instance_exists(obj_player)) {
        with (obj_player) {
            limite        = 1;
            salto_fuerza  = -11;
            aceleracion   = 0.17;
            puede_dashear = false;
            puede_tp      = false;
        }
    }

    // 4) Control de avance con ENTER
    if (keyboard_check_pressed(vk_enter)) {
        if (letter_index < txt_length) {
            // Revelar todo de golpe
            letter_index = txt_length;
        } else {
            // Avanzar línea
            current_line += 1;
            line_delay_timer = 0;

            if (current_line >= ds_list_size(dialogues)) {
                is_active = false;
                if (!first_done) first_done = true;
            } else {
                txt_full      = ds_list_find_value(dialogues, current_line);
                txt_length    = string_length(txt_full);
                letter_index  = 0;
                letter_timer  = 0;
            }
        }
    }
    else {
        // 5) Mostrar letra por letra
        if (letter_index < txt_length) {
            letter_timer += 1;
            if (letter_timer >= letter_speed) {
                letter_index += 1;
                letter_timer = 0;
                var snd_id = audio_play_sound(shooting, 1, false);
                audio_sound_gain(snd_id, 0.08, false);
                audio_sound_pitch(snd_id, random_range(0.6, 1.4));
            }
        }
        else {
            // 6) Esperar y avanzar solo
            line_delay_timer += 1;
            if (line_delay_timer >= line_delay_max) {
                current_line += 1;
                line_delay_timer = 0;
                if (current_line >= ds_list_size(dialogues)) {
                    is_active = false;
                    if (!first_done) first_done = true;
                } else {
                    txt_full      = ds_list_find_value(dialogues, current_line);
                    txt_length    = string_length(txt_full);
                    letter_index  = 0;
                    letter_timer  = 0;
                }
            }
        }
    }
}

// 7) Detectar colisión con el objeto que cambia room (obj_gotonext).  
//    Esto ocurre en la habitación previa a la transición, justo antes de cambiar.
if (!start_second && instance_exists(obj_gotonext) && instance_exists(obj_player)) {
    if (place_meeting(obj_player.x, obj_player.y, obj_gotonext)) {
        start_second = true;
    }
}

// 8) Iniciar segundo diálogo en el momento que corresponda (incluso si ya cambió la room)
//    first_done debe ser true (primer diálogo completado) y start_second true.
if (!is_active && first_done && start_second && !second_done) {
    // Cargo lista de frases de room2
    ds_list_clear(dialogues);
    for (var i = 0; i < ds_list_size(dialogues_room2); i++) {
        ds_list_add(dialogues, ds_list_find_value(dialogues_room2, i));
    }
    current_line     = 0;
    txt_full         = ds_list_find_value(dialogues, current_line);
    txt_length       = string_length(txt_full);
    letter_index     = 0;
    letter_timer     = 0;
    line_delay_timer = 0;
    is_active        = true;

    second_done  = true;
    start_second = false;
}

global.is_active = is_active;
