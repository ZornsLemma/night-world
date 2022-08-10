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

    if (!have_jumped_or_fallen) {
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

// TEMP NOTE: Suppose we are at X=512. We see there's black at X=508, so we allow a move left to X=504. In order to move right, we need black at 504+64=568 - this is not guaranteed, but maybe that's OK. We then move back to X=512. Two superficially odd things here - we don't test for black at the same offset we move by, and there's no *local* guarantee (it might be an emergent property) that we can move right just because we just moved left.
// - "logically" we should not be allowed to be at a location in the first place if we can't move left-then-right or right-then-left from that location (although this ignores jumping) - which would seem to imply a requirement that at all times (modulo jumping) X-8+64 and X+8-4 are always black (arguably, in game logic, *if* you aren't allowed to move in one direction, that restriction shouldn't apply - but I am not sure it's terribly unreasonable)
//
// Just as a possibly-relevant observation, ignoring (as I think we have to for now) moving enemies, the game's walls are pretty chunky and solid (although glancing collisions with corners *might* be a potential concern; still, my gut feeling is these don't typically play a key part in the player getting stuck), so there's probably a fairly clear-cut point at which the player transitions from "not stuck" to "stuck" - it's not as if (purely intuition, not proven) the player falls "into" a wall, is stuck at time T but at time T+1 has moved on and is in a non-stuck position.
//
// I might *guess* that it's nearly always an active jump rather than a fall which is in play when the player gets stuck. (It just might be a very brief fall at the end of the jump, but my current guess is that even this isn't the case.)
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
    // 480 TODO: MAYBE THIS SHOULD BE EXTENDED TO ALSO STOP THE JUMP IF THE 490... STUFF BELOW *WOULD* GET THE PLAYER STUCK??? I AM NOT TOO CONFIDENT ABOUT THIS, AS BARRING OUTRIGHT BUGS, MY PREVIOUS ANTI-STICK CODE SHOULD HAVE HANDLED THIS BY SIMPLY "BACKTRACKING" THE PLAYER TO THE POINT BEFORE THE 490... CODE BELOW CHANGED ANYTHING, WOULDN'T IT? IF THAT'S THE, I START TO WONDER IF THE POINT() IN 491... FOR STOPPING JUMPS IS MAYBE THE KEY
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
