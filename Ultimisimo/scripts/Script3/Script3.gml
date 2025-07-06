// structs.gml

Vec2 = function(_x, _y) constructor {
    x = _x;
    y = _y;
};

Line = function(_a, _b) constructor {
    a = _a;
    b = _b;

    Hit = function() {
        var closest_wall = undefined;
        var closest_t = -1;
        var closest_u = -1;

        for (var i = 0; i < ds_list_size(global.walls); i++) {
            var wall = global.walls[| i];

            var wall_dx = wall.b.x - wall.a.x;
            var wall_dy = wall.b.y - wall.a.y;
            var ray_dx = b.x - a.x;
            var ray_dy = b.y - a.y;

            var den = wall_dx * ray_dy - wall_dy * ray_dx;
            if (den == 0) return b;

            var t = ((a.x - wall.a.x) * ray_dy - (a.y - wall.a.y) * ray_dx) / den;
            var u = -((wall_dx) * (a.y - wall.a.y) - (wall_dy) * (a.x - wall.a.x)) / den;

            if (t >= 0 && t <= 1 && u >= 0) {
                if (closest_u == -1 || u < closest_u) {
                    closest_u = u;
                    closest_t = t;
                    closest_wall = wall;
                }
            }
        }

        if (closest_wall != undefined) {
            return new Vec2(
                closest_wall.a.x + closest_t * (closest_wall.b.x - closest_wall.a.x),
                closest_wall.a.y + closest_t * (closest_wall.b.y - closest_wall.a.y)
            );
        }
        return b;
    };
};
