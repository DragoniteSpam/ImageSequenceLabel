var source = get_open_filename("Image files|*.jpg;*.png;*.bmp", "image.png");
var path = filename_path(source);
var ext = filename_ext(source);

self.file_list = ds_queue_create();
self.surface = -1;

var file = file_find_first(path + "*" + ext, fa_none);
while (file != "") {
    ds_queue_enqueue(self.file_list, path + file);
    file = file_find_next();
}
file_find_close();

self.GetTimestampFromFilename = function(filename) {
    filename = filename_name(filename);
    // pic_[YEAR]-[MONTH]-[DAY] [HH]_[MM]_[SS].[fraction].jpg
    filename = filename_change_ext(filename, "");
    // pic_[YEAR]-[MONTH]-[DAY] [HH]_[MM]_[SS].[fraction]
    filename = filename_change_ext(filename, "");
    // pic_[YEAR]-[MONTH]-[DAY] [HH]_[MM]_[SS]
    filename = string_replace(filename, "pic_", "");
    // [YEAR]-[MONTH]-[DAY] [HH]_[MM]_[SS]
    
    var partition = string_split(filename, " ");
    var date_partition = string_split(partition[0], "-");
    // [YEAR], [MONTH], [DAY]
    var time_partition = string_split(partition[1], "_");
    // [HH], [MM], [SS]
    
    return {
        year: real(date_partition[0]),
        month: real(date_partition[1]),
        day: real(date_partition[2]),
        
        hour: real(time_partition[0]),
        minute: real(time_partition[1]),
        second: real(time_partition[2])
    };
};

self.ValidateSurface = function(surface, w, h) {
    if (surface_exists(surface)) {
        if (surface_get_height(surface) != h) {
            surface_free(surface);
        } else if (surface_get_width(surface) != w) {
            surface_free(surface);
        }
    }
    
    if (!surface_exists(surface)) {
        surface = surface_create(w, h);
    }
    
    return surface;
};