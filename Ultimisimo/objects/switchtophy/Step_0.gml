// Create Event
global.phy = false;

// Step Event
if (room == rm2) {
    if (place_meeting(x, y, obj_player)) {
        global.phy = true;
        instance_destroy();
        show_debug_message("PRENDI BRO");
        // Solo crear una instancia, sin with
        instance_create_layer(3230, 287, "Instances", obj_enemy_fisicas);
		 instance_create_layer(3245, 293, "Instances", obj_enemy_fisicas);
		  instance_create_layer(3254, 299, "Instances", obj_enemy_fisicas);
    }
}

if (global.phy && alarm[0] == -1) {  // Asigno alarma solo si no está activa
    alarm[0] = 60;
}

// Alarm 0 Event