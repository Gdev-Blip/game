if (instance_exists(global.selected_char)) {
    var p = global.selected_char;
    
    draw_text(600, 100, "Nombre: " + p.nombre);
    draw_text(600, 130, "Ataque: " + string(p.ataque));
    draw_text(600, 160, "Defensa: " + string(p.defensa));
    draw_text(600, 190, "Velocidad: " + string(p.velocidad));
}
