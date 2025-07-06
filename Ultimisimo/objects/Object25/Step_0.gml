// STEP EVENT
var x_gui = 10;
var y_gui = 10;
var ancho = sprite_width;
var alto  = sprite_height;

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

if keyboard_check_pressed(vk_escape) || 
   (mouse_check_button_pressed(mb_left) &&
    point_in_rectangle(mx, my, x_gui, y_gui, x_gui + ancho, y_gui + alto)) {
    
    paused = !paused;
    update_pause();
}
