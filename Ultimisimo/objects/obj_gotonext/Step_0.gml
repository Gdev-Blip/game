if (!ya_cambie && place_meeting(x, y, oplayer) && !instance_exists(ofade)) {
    ya_cambie = true;
    with (oplayer) {
        vx = 0;
        vspeed = 0;
    }
    var _targetRoom = room_next(room);
    fadetoroom(_targetRoom, 60, c_black);
}
