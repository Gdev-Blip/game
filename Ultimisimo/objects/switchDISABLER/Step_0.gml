if place_meeting(x,y,oplayer) {
   with(oplayer) {
	  limite        = 3;
            salto_fuerza  = -11;
            aceleracion   = 0.4;
            puede_dashear = false;
            puede_tp      = false;
			
	if limite > 3 {
	limite = 3;	
	}
	if xspd > 3 {
		xspd = 3
	}
   }   
   } else {
	   with(oplayer) {
		  
	  limite = originlimite;
            salto_fuerza =  originfuerzasalto
            aceleracion   = originaccel
			puede_tp = true

   } }
       




     