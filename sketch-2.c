// Sketch in pseudo-C of the movement logic to try to make it easier to reason
// about. The BASIC suffers from being unstructured and "nested" if-else chains
// being convoluted, while the assembly language version is sort of better
// structured but convoluted and verbose.
//
// Code which isn't relevant to movement is omitted. This version has been
// tweaked so it no longer matches the original code so closely but should have
// the same behaviour, just expressed a bit more "intuitively".

int player_x, player_y;
int delta_x;
int falling_time;
int falling_delta_x;
bool jumping;
int jump_time;
int jump_delta_y;

while (true) {
    bool have_jumped_or_fallen = false;

    // 291
    if (jumping) {
        jump(); // may set jumping to false...
        have_jumped_or_fallen = true; // ... but we still *jumped* this cycle
    } else {
        delta_x = 0;
        if ((point(player_x +  4, player_y - 66) == 0) &&
            (point(player_x + 60, player_y - 66) == 0)) {
            player_x += falling_delta_x;
            player_y -= 8;
            ++falling_time;
            have_jumped_or_fallen = true;
        }
    }

    if (!jumping_or_failling) {
        // 300
        falling_delta_x = 0;
        if (z_pressed()) {
            move_left();
        } else if (x_pressed()) {
            move_right();
        }

        // 310
        falling_time = 0;
        if (shift_pressed()) {
            jumping = true;
            jump_time = 0;
            jump_delta_y = 8;
            falling_delta_x = delta_x;
        }
    }

    // 330
    move_player_sprite();
}

void move_left()
{
    // 420
    if (point(player_x - 4, player_y - 8) != 0) {
        return;
    }
    // 440
    delta_x = -8;
    player_x -= 8;
}

void move_right() 
{
    // 450
    if (point(player_x + 64, player_y - 8) != 0) {
        return;
    }
    // 470
    delta_x = 8;
    player_x += 8;
}

void jump()
{
    // 480
    if ((point(player_x +  8, player_y + 4) != 0) ||
        (point(player_x + 56, player_y + 4) != 0)) {
        jumping = false;
        return;
    }

    // 490
    jump_time += 2;
    player_y += jump_delta_y;
    player_x += delta_x;

    // 491
    if (jump_time > full_speed_jump_time_limit) {
        jump_delta_y = -4;
        if ((jump_time == max_jump_time) ||
            (point(player_x + 32, player_y - 66) != 0)) {
            jumping = false;
            return;
        }
    }
}
