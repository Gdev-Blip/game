global.hover_id = noone;
if instance_exists(obj_volver) {
	instance_create_layer(obj_volver.x+30,obj_volver.y+10, "Instances", obj_volverspr)	
} else {
	instance_destroy(obj_volverspr)	
}
if (global.mouse_gui_delay > 0) {
    global.mouse_gui_delay--;
}
if (room = selecChar1) {
    layer_set_visible("menu", false);
}