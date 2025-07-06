/// obj_dialogue — Create Event

// Marcamos este objeto como persistente para que sobreviva al cambio de room
persistent = true;

// 1) Inicialización de variables de estado
is_active        = true;
first_done       = false;
second_done      = false;
start_second     = false;
dialogue_locked  = false;
current_line     = 0;
letter_index     = 0;
letter_timer     = 0;
letter_speed     = 4;
line_delay_timer = 0;
line_delay_max   = room_speed * 1.5; // 1.5 segundos antes de avanzar sola

// 2) Variables para “guardar” el estado del jugador
saved_limite        = 0;
saved_salto_fuerza  = 0;
saved_aceleracion   = 0;
saved_puede_dashear = false;
saved_puede_tp      = false;

// 3) Referencias y sprites
player_ref      = instance_find(obj_player, 0);
portrait_sprite = spr_imagegerr;
portrait_w      = sprite_get_width(portrait_sprite);
portrait_h      = sprite_get_height(portrait_sprite);
portrait_x      = 50;
portrait_y      = 50;
box_x           = portrait_x;
box_y           = portrait_y + portrait_h + 10;
box_w           = 600;
box_h           = 150;
text_margin_x   = 16;
text_margin_y   = 16;
font_dialog     = font_futurista;

// 4) Crear y cargar el primer diálogo (esto sólo ocurre la primera vez que se instancia)
dialogues = ds_list_create();
ds_list_add(dialogues,
    "WoW esa caída estuvo potente, me dejó todo chueco, apenas puedo caminar.",
    "Ash, ahora la verdadera pregunta es: ¿Qué es este lugar?",
    "No tengo la mínima idea, pero ya es hora de que averigüe cómo salir."
);

// 5) Preparar texto actual
txt_full   = ds_list_find_value(dialogues, current_line);
txt_length = string_length(txt_full);

// 6) Preparo en paralelo el diálogo de room2, pero sin cargarlo todavía
dialogues_room2 = ds_list_create();
ds_list_add(dialogues_room2,
    "¡Llegaste a roomnext! Aquí arranca el segundo diálogo.",
    "Cada frase se revela con sonido de disparo bajito.",
    "Cuando termines esta tanda, se ocultará todo."
);

// Si necesitas version global:
global.is_active = is_active;
