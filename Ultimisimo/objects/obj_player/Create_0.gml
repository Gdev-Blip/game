// ===================
// CREATE EVENT (obj_player)
// ===================
// --- FÍSICA & MOVIMIENTO ---
xspd               = 0;
yspd               = 0;
limite             = 6;
aceleracion        = 4;
originaccel = aceleracion;
frenado            = 0.4;
originlimite = limite;
gravedad           = 1;
salto_fuerza       = -14;
puede_doble_salto  = true;
originfuerzasalto = salto_fuerza;
vida               = 120;
max_vida = vida;

// --- COMBO & ATAQUE ---
combo              = 0;
combo_max          = 8;
ataque_cooldown    = 1.25;
ataque_anim_timer  = 1.6;
esta_atacando      = false;

sprite_idle        = spr_jugador;
sprite_atk         = spr_ataque_completo;

// --- RETROCESO DE ATAQUE ---
retroceso_1        = 1;
retroceso_2        = 3;
retroceso_3        = 5;
retroceso_4        = 8;

// --- DASH ---
puede_dashear      = true;

dash_en_proceso    = false;
dash_timer         = 0;
dash_cooldown      = 0;
dash_vel           = 25;
dash_duracion      = room_speed * 0.33;  // 0.25 segundos de dash
dash_cooldown_max  = room_speed * 1;
dash_sfx_played    = false; // inicializamos la flag para el audio
orig_puede_dashear   = puede_dashear;
orig_dash_cooldown   = dash_cooldown_max;
orig_dash_timer      = dash_timer;

// --- FOOTSTEPS ---
footstep_timer     = 0;

// --- SONIDOS ---
snd_ataque         = shooting;
snd_salto          = jump;
snd_footsteps      = footsteps;
snd_doble_salto    = jump;

// --- ECO (activar en Room Start) ---
echo_enabled       = false;

// --- SHAKE & FLASH ---
shake_time         = 1;
shake_intensity    = 0;
shake_offset_x     = 0;
shake_offset_y     = 0;
flash_alpha        = 0;

// --- SUPER ATAQUE (click derecho) ---
super_cooldown     = 0;

// --- INVULNERABILIDAD & DAÑO ---
invul_timer        = 0;
dano_recibido      = 10;
invulnera = false;
// --- CONTROL DE FRAME-ATTACK ---
atk_frame_speed    = 0.15;                // sub-imágenes por step
ataque_duracion    = 0.15;                // duración total del ataque en segundos
ataque_frame_count = sprite_get_number(sprite_atk);

// --- MANTENER CÓDIGO ORIGINAL PARA CREAR BALAS CON TECLA J (izq) ---
// (no hace falta declarar nada extra aquí)

// === BLOQUE NUEVO: VARIABLES DE RÁFAGA CLICK DERECHO ===
is_bursting        = false;                       // flag para saber si estamos disparando ráfaga
burst_shots        = 5;                           // cuántas balas suelta la ráfaga
burst_shots_fired  = 0;                           // contador interno
burst_interval     = round(room_speed * 0.1);      // intervalo (en steps) entre cada bala
burst_timer        = 0;                           // timer para controlar cuándo disparar la próxima
retroceso_burst    = 10;                          // magnitud del retroceso de la ráfaga

// --- VARIABLES DE TP (Mini Teleport) ---
puede_tp = true;
tp_active       = false;                 // ¿Estás en “modo aim”? (false = no)
tp_timer        = 0;                     // Contador interno de 2 s mientras apuntas
tp_duration     = room_speed * 2;        // 2 s = 2 * room_speed (steps)
tp_target_x     = x;                     // Destino X (inicial = tu posición)
tp_target_y     = y;                     // Destino Y (inicial = tu posición)
tp_filter_alpha = 0.5;                   // Opacidad del filtro gris

// --- COOLDOWN DE TP ---
tp_cooldown      = 0;                    // Contador que irá bajando
tp_cooldown_max  = room_speed * 10;      // 10 s = 10 * room_speed (steps)
saved_limite        = limite;
saved_salto_fuerza  = salto_fuerza;
saved_aceleracion   = aceleracion;
saved_puede_dashear = puede_dashear;
saved_puede_tp      = puede_tp;

// Variables del shake por pasos
footstep_count = 0;
footstep_timer = room_speed * 0.5; // o el valor que quieras usar como intervalo
global.invulnera = invulnera