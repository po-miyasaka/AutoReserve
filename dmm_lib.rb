# frozen_string_literal: true

# TODO: You can use class that more like ruby style.

ALLOWTIMES = [
  "22:00",
  "22:30",
  "23:00",
  "23:30",
  "24:00",
  "24:30"
].freeze

TAB_1 = "&data[tab1]"

def generate_url_string(date, time)
  sort = 6
  native = 1
  favorite = "on"

  [
    "https://eikaiwa.dmm.com/",
    "list/?",
    TAB_1,
    "[start_time]=",
    time,
    TAB_1,
    "[end_time]=",
    time,
    TAB_1,
    "[native]=",
    native,
    TAB_1,
    "[favorite]=",
    favorite,
    "&date=",
    date,
    "&sort=",
    sort
  ].join
end
