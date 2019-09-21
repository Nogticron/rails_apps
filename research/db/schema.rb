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

ActiveRecord::Schema.define(version: 2019_09_17_162330) do

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

  create_table "stations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "lon", null: false
    t.string "lat", null: false
  end

  create_table "weathers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "area_id"
    t.date "date", null: false
    t.float "max_temp", null: false
    t.float "min_temp", null: false
    t.string "weather_9", null: false
    t.string "weather_12", null: false
    t.string "weather_15", null: false
    t.string "amount", null: false
    t.index ["area_id"], name: "index_weathers_on_area_id"
  end

end
