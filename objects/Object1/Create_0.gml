var source = get_open_filename("Image files|*.jpg;*.png;*.bmp", "image.png");
var path = filename_path(source);
var output_path = path + "output/";
var ext = filename_ext(source);

directory_create(output_path);

self.file_list = ds_queue_create();
self.surface = -1;
self.error_report = "";

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
    
    static first_datetime = undefined;
    
    var current_datetime = date_create_datetime(timestamp.year, timestamp.month, timestamp.day, timestamp.hour, timestamp.minute, timestamp.second);
    first_datetime ??= current_datetime;
    
    var days_elapsed = floor(date_day_span(first_datetime, current_datetime)) + 1;
    
    var era = timestamp.hour < 12 ? "AM" : "PM";
    
    if (timestamp.hour < 1) {
        timestamp.hour += 12;
    } else if (timestamp.hour >= 13) {
        timestamp.hour -= 12;
    }
    
    var hh = string(floor(timestamp.hour));
    
    var mm = string(floor(timestamp.minute));
    if (string_length(mm) < 2) {
        mm = "0" + mm;
    }
    var ss = string(floor(timestamp.second));
    if (string_length(ss) < 2) {
        ss = "0" + ss;
    }
    
    // put the date stamp first because it doesn't change as quickly and the
    // string width doesn't jump around as much
    return $"{timestamp.day} {months[timestamp.month]} {timestamp.year} - {hh}:{mm}:{ss} {era}\nDay {days_elapsed}";
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

font_enable_effects(fnt_timestamp, true, {
    outlineEnable: true,
    outlineDistance: 6,
    outlineColour: c_black,
    outlineAlpha: 1,
    /*
    glowEnable: true,
    glowStart: 0,
    glowEnd: 20,
    glowAlpha: 1*/
});