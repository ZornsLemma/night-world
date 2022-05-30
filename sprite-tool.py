from PIL import Image

sprite_sheet_x_spacing = 96
sprite_sheet_y_spacing = 32
sprite_image_width = 48
sprite_image_height = 32

def get_sprite_frames(sprite_sheet, n):
    frames = []
    for i in range(4):
        left = i*sprite_sheet_x_spacing
        right = left+sprite_image_width
        top = n*sprite_image_height
        bottom = top+sprite_image_height
        frames.append(sprite_sheet.crop((left, top, right, bottom)))
        assert frames[-1].size == (sprite_image_width, sprite_image_height)
    return frames

def save_sprite_frames(sprite_frames, basename):
    assert len(sprite_frames) == 4
    for i, frame in enumerate(sprite_frames):
        frame.save(basename + "-%d.png" % i, "PNG")

sprite_sheet = Image.open("sprites-1.png")
assert sprite_sheet.size == (640, 512)
sprite_frames = get_sprite_frames(sprite_sheet, 0)
save_sprite_frames(sprite_frames, "sprite-00")
