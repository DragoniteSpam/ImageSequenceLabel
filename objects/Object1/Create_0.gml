var source = get_open_filename("Image files|*.jpg;*.png;*.bmp", "image.png");
var path = filename_path(source);
var ext = filename_ext(source);

self.file_list = ds_queue_create();

var file = file_find_first(path + "*" + ext, fa_none);
while (file != "") {
    show_debug_message(path + file);
    ds_queue_enqueue(self.file_list, path + file);
    file = file_find_next();
}
file_find_close();