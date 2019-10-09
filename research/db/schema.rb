# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_10_09_164755) do

  create_table "areas", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "e_name", null: false
  end

  create_table "cities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "area_id"
    t.string "name", null: false
    t.integer "area_code", null: false
    t.integer "day_population", null: false
    t.integer "resident_population", null: false
    t.float "day_night_ratio", null: false
    t.float "area", null: false
    t.float "day_density", null: false
    t.float "resident_density", null: false
    t.boolean "tour_spot", default: false, null: false
    t.index ["area_id"], name: "index_cities_on_area_id"
  end

  create_table "line_stations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "line_id"
    t.bigint "station_id"
    t.string "line_name"
    t.string "station_name"
    t.integer "number"
    t.index ["line_id"], name: "index_line_stations_on_line_id"
    t.index ["station_id"], name: "index_line_stations_on_station_id"
  end

  create_table "lines", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "corporation", null: false
  end

  create_table "people", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "record_id", null: false
    t.integer "age", null: false
    t.boolean "passport", null: false
    t.integer "magnification", null: false
    t.time "s_time"
    t.time "s_arriving_time"
    t.string "r1_st1", null: false
    t.string "r1_st2"
    t.time "r1_time2"
    t.string "r1_st3"
    t.time "r1_time3"
    t.string "r1_st4"
    t.time "r1_time4"
    t.string "r1_st5"
    t.time "r1_time5"
    t.string "r1_st6"
    t.time "r1_time6"
    t.string "r1_st7"
    t.time "r1_time7"
    t.string "r1_st8"
    t.time "r1_time8"
  end

  create_table "stations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "city_id"
    t.string "name", null: false
    t.string "lon", null: false
    t.string "lat", null: false
    t.index ["city_id"], name: "index_stations_on_city_id"
  end

  create_table "weathers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "area_id"
    t.date "date", null: false
    t.time "time", null: false
    t.float "temperture"
    t.integer "temp_quality"
    t.float "precipitation"
    t.boolean "is_occurrence"
    t.integer "precip_quality"
    t.integer "weather_state"
    t.integer "weather_quality"
    t.index ["area_id"], name: "index_weathers_on_area_id"
  end

end
