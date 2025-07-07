// === VARIABLES TEMPORALES ===
var izq    = keyboard_check(vk_left) || keyboard_check(ord("A"));
var der    = keyboard_check(vk_right)|| keyboard_check(ord("D"));
var saltar = keyboard_check_pressed(vk_space);

// === TELEPORT ===
if (keyboard_check_pressed(ord("R")) && !tp_active && tp_cooldown <= 0 and puede_tp) {
    tp_active  = true;
    tp_timer   = tp_duration;
}

if (tp_active) {
    var mx = mouse_x;
    var my = mouse_y;

    image_angle  = point_direction(x, y, mx, my);
    tp_target_x  = mx;
    tp_target_y  = my;

    if (mouse_check_button_pressed(mb_left) && !global.mouse_clicked_gui) {
        var nf = searchFree2(tp_target_x, tp_target_y);
        x = nf[0];
        y = nf[1];
        tp_active   = false;
        image_angle = 0;
        tp_cooldown = tp_cooldown_max;
        exit;
    }

    tp_timer--;
    if (tp_timer <= 0) {
        var nf = searchFree2(tp_target_x, tp_target_y);
        x = nf[0];
        y = nf[1];
        tp_active   = false;
        image_angle = 0;
        tp_cooldown = tp_cooldown_max;
        exit;
    }

    exit;
}

if (tp_cooldown > 0) tp_cooldown--;

// === REINICIO Y MUERTE ===
if (vida <= 0 || keyboard_check(ord("G"))) {
    room_restart();
}
if (vida <= 0) instance_destroy();

// === DETECCIÓN DE SUELO ===
var en_suelo = place_meeting(x, y + 1, obj_suelo) || place_meeting(x, y + 1, obj_sueloDESTRUIBLE);

// === GRAVEDAD & SALTO ===
if (!en_suelo) {
    yspd += gravedad;
} else {
    yspd = 0;
    puede_doble_salto = true;
}

if (en_suelo && saltar) {
    yspd = salto_fuerza;
} else if (!en_suelo && saltar && puede_doble_salto) {
    yspd = salto_fuerza;
    puede_doble_salto = false;
}

// === MOVIMIENTO HORIZONTAL ===
if (!esta_atacando && !dash_en_proceso) {
    if (izq && xspd > -limite) xspd -= aceleracion;
    if (der && xspd <  limite) xspd += aceleracion;
    if (!izq && xspd < 0) { xspd += frenado; if (xspd > 0) xspd = 0; }
    if (!der && xspd > 0) { xspd -= frenado; if (xspd < 0) xspd = 0; }
}

// === FOOTSTEPS ===
if (en_suelo && abs(xspd) > 0.5 && (izq || der)) {
    var dir = sign(xspd);
    if (!place_meeting(x + dir, y, obj_suelo) && !place_meeting(x + dir, y, obj_sueloDESTRUIBLE)) {
        footstep_timer--;
        if (footstep_timer <= 0) {
            audio_play_sound(snd_footsteps, 1, false);
            footstep_timer = room_speed * 0.5;
        }
    } else footstep_timer = 0;
} else footstep_timer = 0;

// === MOVIMIENTO CON COLISIONES ===
if (!dash_en_proceso) {
    var dx = sign(xspd);
    repeat(abs(xspd)) {
        if (place_free(x+dx, y)) x += dx; else { xspd = 0; break; }
    }
}

var dy = sign(yspd);
repeat(abs(yspd)) {
    if (place_free(x, y+dy)) y += dy; else { yspd = 0; break; }
}

// === FLIP SPRITE ===
if (!esta_atacando && !dash_en_proceso) {
    if (der) image_xscale = 1;
    if (izq) image_xscale = -1;
}

// === ATAQUE NORMAL ===
if (mouse_check_button_pressed(mb_left) && !global.mouse_clicked_gui && ataque_cooldown <= 0 && !esta_atacando && !dash_en_proceso) {
    alarm[1] = 1;
}

// === RÁFAGA (CLICK DER) ===
// === RÁFAGA (CLICK DER) ===
if (mouse_check_button_pressed(mb_right) && super_cooldown <= 0 && !dash_en_proceso) {
    super_cooldown    = room_speed * 5;
    flash_alpha       = 1;
    shake_time        = 18;
    shake_intensity   = 22;
    is_bursting       = true;
    burst_shots_fired = 0;
    burst_timer       = 0;
    sprite_index      = spr_gerruzi;
}

// === RÁFAGA EN CURSO ===
if (is_bursting) {
    if (burst_timer <= 0 && burst_shots_fired < burst_shots) {
        var dir2 = (image_xscale == -1) ? 180 : 0;
        var bb   = instance_create_layer(x, y, "Instances", bullet);
        bb._direccion = dir2;
        bb.image_angle = dir2;

        // Reproduce el sonido aquí, por cada disparo
        audio_play_sound(shooting, 1, false);

        xspd -= retroceso_burst * image_xscale;
        burst_shots_fired++;
        burst_timer = burst_interval;
    } else if (burst_shots_fired >= burst_shots) {
        is_bursting = false;
    }
    burst_timer--;
}

// === ATAQUE COOL — DASH COOL ===
if (esta_atacando) {
    ataque_anim_timer--;
    if (ataque_anim_timer <= 0) {
        esta_atacando = false;
        sprite_index  = sprite_idle;
        image_speed   = 0;
        image_index   = 1;
    }
}
if (ataque_cooldown > 0) ataque_cooldown--;
if (super_cooldown > 0) super_cooldown--;

// === DASH ===
if (puede_dashear && !dash_en_proceso && keyboard_check_pressed(ord("Q"))) {
    dash_en_proceso = true;
    puede_dashear   = false;
    dash_timer      = dash_duracion;
}

if (dash_en_proceso) {
    var ddir = image_xscale;
    sprite_index = spr_dash;
    image_speed  = 1.4;

    if (!dash_sfx_played) {
        dash_sfx_played = true;
        audio_play_sound(dash, 1, false);
    }

    if (place_free(x + dash_vel * ddir, y)) {
        x += dash_vel * ddir;
    }

    dash_timer--;
    if (dash_timer <= 0) {
        dash_en_proceso = false;
        dash_cooldown   = dash_cooldown_max;
        dash_sfx_played = false;
    }
}

if (!puede_dashear && !dash_en_proceso) {
    dash_cooldown--;
    if (dash_cooldown <= 0) puede_dashear = true;
}

// === IDLE SPRITE ===
if (!esta_atacando && !dash_en_proceso && !is_bursting) {
    if (xspd == 0 && yspd == 0) {
        sprite_index = sprite_idle;
        image_speed  = 0;
        image_index  = 1;
    } else {
        sprite_index = sprite_idle;
        image_speed  = 5;
    }
}

// === SISTEMA DE DAÑO CON TINTE ROJO ===
// === SISTEMA DE DAÑO CON TINTE ROJO (ambos tipos de enemigos) ===
if (dano_cooldown <= 0) {
    if (place_meeting(x, y, obj_enemy)) {
        vida -= dano_recibido;
        xspd += 8 * -image_xscale;
        yspd  = -10;
        tinte_rojo = 1;
        dano_cooldown = room_speed * 0.4;
        shake_time = 7;
        shake_intensity = 10;
    }
    else if (place_meeting(x, y, obj_enemy_fisicas)) {
        vida -= (dano_recibido / 4);
        xspd += 13 * -image_xscale;
        yspd  = -13;
        tinte_rojo = 1;
        dano_cooldown = room_speed * 0.4;
        shake_time = 7;
        shake_intensity = 10;
    }
}

if (dano_cooldown > 0) dano_cooldown--;

// === EFECTO ROJO SUAVE ===
if (tinte_rojo > 0) {
    tinte_rojo -= 0.05;
    if (tinte_rojo < 0) tinte_rojo = 0;
}

// === FLASH SCREEN ===
if (flash_alpha > 0) {
    flash_alpha -= 0.1;
    if (flash_alpha < 0) flash_alpha = 0;
}

// === CÁMARA SHAKE ===
if (shake_time > 0) {
    shake_time--;
    shake_offset_x = irandom_range(-shake_intensity, shake_intensity);
    shake_offset_y = irandom_range(-shake_intensity, shake_intensity);
} else {
    shake_offset_x = 0;
    shake_offset_y = 0;
}
// Cámara con retraso suave
if (!variable_global_exists("cam_x")) {
    global.cam_x = x;
    global.cam_y = y;
}

var follow_x = x - (camera_get_view_width(view_camera[0]) / 2) + shake_offset_x;
var follow_y = y - (camera_get_view_height(view_camera[0]) / 2) + shake_offset_y;

// Lerp hacia el objetivo, entre 0 (no se mueve) y 1 (se mueve instantáneo)
global.cam_x = lerp(global.cam_x, follow_x, 0.1);
global.cam_y = lerp(global.cam_y, follow_y, 0.1);

camera_set_view_pos(view_camera[0], global.cam_x, global.cam_y);


// === SYNC VIDA GLOBAL ===
global.vidaplayer = vida;
