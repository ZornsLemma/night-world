from PIL import Image, ImageColor, ImageDraw

# It looks like the screen dumps are not quite properly aligned, so work
# around that.
x_fudge = 1

sprite_sheet_x_spacing = 96
sprite_sheet_y_spacing = 32
sprite_image_width = 48
sprite_image_height = 32
enlarge_factor = 4
grid_colour = ImageColor.getrgb("grey")

def get_sprite_frames(sprite_sheet, n):
    frames = []
    for i in range(4):
        left = i*sprite_sheet_x_spacing
        right = left+sprite_image_width
        top = n*sprite_image_height
        bottom = top+sprite_image_height
        frames.append(sprite_sheet.crop((left+x_fudge, top, right+x_fudge, bottom)))
        assert frames[-1].size == (sprite_image_width, sprite_image_height)
    return frames

def save_sprite_frames(sprite_frames, basename):
    for i, frame in enumerate(sprite_frames):
        frame.save(basename + "-%d.png" % i, "PNG")

def enlarge_frame(frame):
    assert frame.size == (sprite_image_width, sprite_image_height)
    enlarged = frame.resize((frame.size[0] * enlarge_factor, frame.size[1] * enlarge_factor), Image.NEAREST)
    pixel_width = enlarged.size[0] / 12
    pixel_height = enlarged.size[1] / 16
    draw = ImageDraw.Draw(enlarged)
    for pixel_x in range(1, 12):
        draw.line((pixel_x * pixel_width, 0, pixel_x * pixel_width, enlarged.size[1]),
                  fill=grid_colour)
    for pixel_y in range(1, 16):
        draw.line((0, pixel_y * pixel_height, enlarged.size[0], pixel_y * pixel_height),
                  fill=grid_colour)
    return enlarged

def save_sprite_frames_large(sprite_frames, basename):
    for i, frame in enumerate(sprite_frames):
        enlarge_frame(frame).save(basename + "-%d-large.png" % i, "PNG")

def save_sprite_animation(sprite_frames, basename):
    assert len(sprite_frames) == 4
    animation_frames = []
    for x, frame in enumerate(sprite_frames):
        size = list(frame.size)
        size[0] += 12
        animation_frame = Image.new(frame.mode, size, ImageColor.getrgb("black"))
        animation_frame.paste(frame, ((3-x)*4, 0))
        animation_frames.append(animation_frame)
    # TODO: Would be good to set the duration to something approximating the
    # actual animation speed in the game, perhaps. Although maybe shwoing it
    # slower is good.
    animation_frames[0].save(
        basename + "-anim.gif", save_all=True, append_images=animation_frames[1:],
        loop=0, duration=200)

def save_sprite(sprite_frames, n):
    assert len(sprite_frames) == 4
    basename = "img/sprite-%02d" % n
    save_sprite_frames(sprite_frames, basename)
    save_sprite_frames_large(sprite_frames, basename)
    save_sprite_animation(sprite_frames, basename)

for n in range(19):
    if n == 0:
        sprite_sheet = Image.open("img/sprites-1.png")
        sprite_offset = 0
    elif n == 16:
        sprite_sheet = Image.open("img/sprites-2.png")
        sprite_offset = 16
    assert sprite_sheet.size == (640, 512)
    sprite_frames = get_sprite_frames(sprite_sheet, n-sprite_offset)
    save_sprite(sprite_frames, n)
