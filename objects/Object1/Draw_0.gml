if (!ds_queue_empty(self.file_list)) {
    var filename = ds_queue_dequeue(self.file_list);
    var sprite = sprite_add(filename, 0, false, false, 0, 0);
    
    var timestamp = self.GetTimestampFromFilename(filename);
    var label = self.GetStringFromTimestamp(timestamp);
    
    self.surface = self.ValidateSurface(self.surface, sprite_get_width(sprite), sprite_get_height(sprite));
    
    surface_set_target(self.surface);
    draw_clear(c_black);
    
    draw_sprite(sprite, 0, 0, 0);
    
    scribble(label)
        .align(fa_left, fa_top)
        .draw(32, 32);
    
    surface_reset_target();
    sprite_delete(sprite);
}

if (surface_exists(self.surface)) {
    draw_surface(self.surface, 0, 0);
}