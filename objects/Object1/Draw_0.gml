if (self.error_report != "") {
    draw_clear(c_black);
    scribble(self.error_report)
        .align(fa_left, fa_top)
        .scale(0.25)
        .draw(32, 32);
    return;
}

var sprite = -1;

try {
    if (!ds_queue_empty(self.file_list)) {
        var filename = ds_queue_dequeue(self.file_list);
        //sprite = sprite_add(filename.input, 0, false, false, 0, 0);
        
        var timestamp = self.GetTimestampFromFilename(filename);
        var label = self.GetStringFromTimestamp(timestamp);
        
        //self.surface = self.ValidateSurface(self.surface, sprite_get_width(sprite), sprite_get_height(sprite));
        self.surface = self.ValidateSurface(self.surface, 1280, 360);
        
        surface_set_target(self.surface);
        //draw_clear(c_black);
        draw_clear_alpha(c_black, 0);
        
        //draw_sprite(sprite, 0, 0, 0);
        
        draw_set_font(fnt_timestamp);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_text(32, 32, label);
        
        surface_reset_target();
        //sprite_delete(sprite);
        
        surface_save(self.surface, filename.output);
    }
} catch (e) {
    self.error_report = e.message + "\n\n" + e.longMessage;
}

if (surface_exists(self.surface)) {
    if (sprite_exists(sprite)) {
        var f = window_get_height() / sprite_get_height(sprite);
        draw_sprite_ext(sprite, 0, 0, 0, f, f, 0, c_white, 1);
    }
    draw_surface(self.surface, 0, 0);
}

if (sprite_exists(sprite)) {
    sprite_delete(sprite);
}