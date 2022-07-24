// Sketch in pseudo-C of the movement logic to try to make it easier to reason
// about. The BASIC suffers from being unstructured and "nested" if-else chains
// being convoluted, while the assembly language version is sort of better
// structured but convoluted and verbose.
//
// Code which isn't relevant to movement is omitted.

while (true) {
    // 291
    if (jumping) {
        PROCjump;
        goto 330; // TODO!
    } else {
        delta_x = 0;
        if ((point(player_x +  4, player_y - 66) == 0) &&
            (point(player_x + 60, player_6 - 66) == 0)) {
            player_x += falling_delta_x;
            player_y -= 8;
            ++falling_time;
            goto 330; // TODO!
        }
    }

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

    // 330
    eor_player_sprite(); // TODO: in practice, is this unplot or plot?

    // 360 TODO: Is this relevant? If it *just* applies damage it isn't, but it may alter movement related vars - need to check.
    if (player_touching_enemy() || (falling_time > 12)) {
        update_energy_and_items();
    }
}

// TODO: Need to fill in the missing functions called above and check I've captured everything - then I can start making non-functional changes to this pseudo-code to improve the readability
