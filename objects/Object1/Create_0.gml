scribble_font_bake_outline_8dir_2px("fnt_timestamp", "fnt_timestamp_outlined", c_black, true);
scribble_font_set_default("fnt_timestamp_outlined");

var source = get_open_filename("Image files|*.jpg;*.png;*.bmp", "image.png");
var path = filename_path(source);
var output_path = path + "output/";
var ext = filename_ext(source);

directory_create(output_path);

self.file_list = ds_queue_create();
self.surface = -1;

var file = file_find_first(path + "*" + ext, fa_none);
while (file != "") {
    ds_queue_enqueue(self.file_list, {
        input: path + file,
        output: output_path + filename_change_ext(file, ".png")         // would be nice if we could write out a jpeg, but whatever
    });
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

self.GetStringFromTimestamp = function(timestamp) {
    static months = [
        "",
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December"
    ];
    
    var era = timestamp.hour < 12 ? "AM" : "PM";
    
    if (timestamp.hour < 1) {
        timestamp.hour += 12;
    } else if (timestamp.hour >= 13) {
        timestamp.hour -= 12;
    }
    
    var hh = string(floor(timestamp.hour));
    if (string_length(hh) < 2) {
        hh = "0" + hh;
    }
    var mm = string(floor(timestamp.minute));
    if (string_length(mm) < 2) {
        mm = "0" + mm;
    }
    var ss = string(floor(timestamp.second));
    if (string_length(ss) < 2) {
        ss = "0" + ss;
    }
    
    return $"{hh}:{mm}:{ss} {era} - {timestamp.day} {months[timestamp.month]} {timestamp.year}";
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