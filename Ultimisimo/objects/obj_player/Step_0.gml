/// STEP EVENT de obj_player
// --- INPUTS ---
var izq    = keyboard_check(vk_left) || keyboard_check(ord("A"));
var der    = keyboard_check(vk_right)|| keyboard_check(ord("D"));
var saltar = keyboard_check_pressed(vk_space);

if (keyboard_check_pressed(ord("R")) && !tp_active && tp_cooldown <= 0 and puede_tp) {
    tp_active  = true;
    tp_timer   = tp_duration;
}

if (tp_active) {

    var mx = mouse_x;
    var my = mouse_y;

    image_angle = point_direction(x, y, mx, my);

    tp_target_x = mx;
    tp_target_y = my;

    if (mouse_check_button_pressed(mb_left)) {
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

if (vida <= 0) {
    instance_destroy();
}

if (tp_cooldown > 0) tp_cooldown--;

if (vida <= 0) instance_destroy();
if (keyboard_check(ord("G"))) room_restart();

if (tp_cooldown > 0) {
    tp_cooldown--;
}

var izq    = keyboard_check(vk_left) || keyboard_check(ord("A"));
var der    = keyboard_check(vk_right)|| keyboard_check(ord("D"));
var saltar = keyboard_check_pressed(vk_space);

if (vida <= 0) instance_destroy();
if (keyboard_check(ord("G"))) room_restart();

if (tp_active) {
    var mx = mouse_x;
    var my = mouse_y;
    var dir = point_direction(x, y, mx, my);
    image_angle = dir;

    tp_target_y = my;
    tp_timer--;
    if (tp_timer <= 0) {
        x = tp_target_x;
        y = tp_target_y;
        tp_active = false;
        // Opcional: reseteá image_angle o image_xscale si querés que vuelva al default
    }

    exit;
}
// ====================
// Si llegás acá, tp_active == false → seguí con LÓGICA NORMAL

// --- DETECCIÓN DE SUELO ---
var en_suelo = place_meeting(x, y + 1, obj_suelo) || place_meeting(x, y + 1, obj_sueloDESTRUIBLE);

// --- GRAVEDAD & SALTO ---
if (!en_suelo) {
    yspd += gravedad;
} else {
    yspd = 0;
    puede_doble_salto = true;
}
if (en_suelo && saltar) {
    yspd = salto_fuerza;
    if (echo_enabled) scr_play_echo(snd_salto, 1, false);
    else {
        var s = audio_play_sound(snd_salto, 1, false);
        audio_sound_pitch(s, random_range(0.9, 1.3));
    }
} else if (!en_suelo && saltar && puede_doble_salto) {
    yspd = salto_fuerza;
    puede_doble_salto = false;
    if (echo_enabled) scr_play_echo(snd_doble_salto, 1, false);
    else {
        var s = audio_play_sound(snd_doble_salto, 1, false);
        audio_sound_pitch(s, random_range(0.9, 1.3));
    }
}

// --- MOVIMIENTO HORIZONTAL CON INERCIA ---
if (!esta_atacando && !dash_en_proceso) {
    if (izq && xspd > -limite) xspd -= aceleracion;
    if (der && xspd <  limite) xspd += aceleracion;
    if (!izq && xspd < 0) { xspd += frenado; if (xspd > 0) xspd = 0; }
    if (!der && xspd > 0) { xspd -= frenado; if (xspd < 0) xspd = 0; }
}

// --- SONIDO FOOTSTEPS ---
if (en_suelo && abs(xspd) > 0.5 && (izq || der) && !esta_atacando && !dash_en_proceso) {
    var dir = sign(xspd); // +1 derecha, -1 izquierda

    if (!place_meeting(x + dir, y, obj_suelo) && !place_meeting(x + dir, y, obj_sueloDESTRUIBLE)) {
        footstep_timer--;
        if (footstep_timer <= 0) {
            if (xspd >= 1 || xspd <= -1) {
                if (echo_enabled) {
                    scr_play_echo(snd_footsteps, 1, false);
                } else {
                    var paso = audio_play_sound(snd_footsteps, 1, false);
                    audio_sound_pitch(paso, random_range(0.8, 1.2));
                }
            }
            footstep_timer = room_speed * 0.5;
        }
    } else {
        footstep_timer = 0;
    }
} else {
    footstep_timer = 0;
}

// --- APLICAR MOVIMIENTO X & COLISIONES ---
if (!dash_en_proceso) {
    var dx = sign(xspd);
    repeat(abs(xspd)) {
        if (place_free(x+dx, y)) x += dx;
        else { xspd = 0; break; }
    }
}

// --- APLICAR MOVIMIENTO Y & COLISIONES ---
var dy = sign(yspd);
repeat(abs(yspd)) {
    if (place_free(x, y+dy)) y += dy;
    else { yspd = 0; break; }
}

// --- FLIP SPRITE ---
if (!esta_atacando && !dash_en_proceso) {
    if (der) image_xscale = 1;
    if (izq) image_xscale = -1;
}

// --- ATAQUE NORMAL (CLICK IZQ) ---
if (mouse_check_button_pressed(mb_left) 
    && ataque_cooldown <= 0 
    && !esta_atacando 
    && !dash_en_proceso) 
{
    var dir = (image_xscale == -1) ? 180 : 0;
    var b = instance_create_layer(x, y, "Instances", bullet);
    b._direccion = dir;
    b.image_angle = dir;

    esta_atacando     = true;
    ataque_anim_timer = round(room_speed * ataque_duracion);
    ataque_cooldown   = room_speed * 0.15;

    sprite_index = sprite_atk;
    image_speed  = atk_frame_speed;
    image_index  = combo;

    if (en_suelo) {
        switch(combo) {
            case 0: xspd -= retroceso_1 * image_xscale; break;
            case 1: xspd -= retroceso_2 * image_xscale; break;
            case 2: xspd -= retroceso_3 * image_xscale; break;
            case 3: xspd -= retroceso_4 * image_xscale; break;
        }
    }

    if (echo_enabled) {
        scr_play_echo(snd_ataque, 1, false);
    } else {
        var a = audio_play_sound(snd_ataque, 1, false);
        audio_sound_pitch(a, random_range(0.9, 1.15));
    }

    shake_time      = 4;
    shake_intensity = 6;

    combo += 1;
    if (combo >= combo_max) {
        combo = 0;
        ataque_cooldown += room_speed * 1;
    }
}

// --- BLOQUE NUEVO: RÁFAGA (CLICK DER) ---
if (mouse_check_button_pressed(mb_right) && super_cooldown <= 0 && !dash_en_proceso) {
    super_cooldown  = room_speed * 5;
    flash_alpha     = 1;
    shake_time      = 18;
    shake_intensity = 22;

    is_bursting       = true;
    burst_shots_fired = 0;
    burst_timer       = 0;
	sprite_index = spr_gerruzi;
}

// --- TIMER & RESET DE ANIMACIÓN DE ATAQUE ---
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

// --- LÓGICA DE RÁFAGA EN PROCESO ---
if (is_bursting) {
    if (burst_timer <= 0 && burst_shots_fired < burst_shots) {
        var dir2 = (image_xscale == -1) ? 180 : 0;
        var bb   = instance_create_layer(x, y, "Instances", bullet);
        bb._direccion = dir2;
        bb.image_angle = dir2;

        xspd -= retroceso_burst * image_xscale;

        for (var i = 0; i < 5; i++) {
            var s2 = audio_play_sound(snd_ataque, 1, false);
            audio_sound_pitch(s2, random_range(0.9, 1.15));
        }

        burst_shots_fired += 1;
        burst_timer = burst_interval; 
    } else if (burst_shots_fired >= burst_shots) {
        is_bursting = false;
    }
    burst_timer--;
}

// --- LÓGICA DE DASH ---
if (puede_dashear && !dash_en_proceso && keyboard_check_pressed(ord("Q"))) {
    dash_en_proceso = true;
    puede_dashear   = false;
    dash_timer      = dash_duracion;
}

// --- STEP EVENT DEL DASH ---
if (dash_en_proceso) {
    var ddir = image_xscale;
    sprite_index = spr_dash;
    image_speed  = 1.4;

    if (!dash_sfx_played) {
        var dashe = audio_play_sound(dash, 1, false);
        audio_sound_pitch(dashe, random_range(0.9, 1.15));
        dash_sfx_played = true;
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

// --- ANIMACIÓN IDLE ---
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

// --- DAÑO & KNOCKBACK ---
if invulnera != true {
if (invul_timer > 0) invul_timer--;
if (place_meeting(x, y, obj_enemy) && invul_timer <= 0) {
    vida -= dano_recibido;
    invul_timer = 1;
	invulnera = true
    xspd += 8 * -image_xscale;
    yspd  = -10;
    shake_time      = 7;
    shake_intensity = 10;
}
if (invul_timer > 0) invul_timer--;
if (place_meeting(x, y, obj_enemy_fisicas) && invul_timer <= 0) {
    vida -= (dano_recibido/4);
	invulnera = true
	alarm[0] = 30 // 3 segundos
    invul_timer = 2;
    xspd += 13 * -image_xscale;
    yspd  = -13;
    shake_time      = 7;
    shake_intensity = 10;
}
}
// --- FLASH FADE OUT ---
if (flash_alpha > 0) {
    flash_alpha -= 0.1;
    if (flash_alpha < 0) flash_alpha = 0;
}

// --- SCREEN SHAKE & CÁMARA ---
if (shake_time > 0) {
    shake_time--;
    shake_offset_x = irandom_range(-shake_intensity, shake_intensity);
    shake_offset_y = irandom_range(-shake_intensity, shake_intensity);
} else {
    shake_offset_x = 0;
    shake_offset_y = 0;
}
var target_x = x - (camera_get_view_width(view_camera[0]) / 2) + shake_offset_x;
var target_y = y - (camera_get_view_height(view_camera[0]) / 2) + shake_offset_y;
camera_set_view_pos(view_camera[0], target_x, target_y);

// --- MUERTE & REINICIO ---

if (keyboard_check(ord("G"))) room_restart();

// --- MANTENER CÓDIGO ORIGINAL PARA CREAR BALAS CON TECLA J ---
if (esta_atacando && keyboard_check_pressed(ord("J"))) {
    var dir = (image_xscale == -1) ? 180 : 0;
    var b = instance_create_layer(x, y, "Instances", bullet);
    b._direccion = dir;
}
global.vidaplayer = vida
