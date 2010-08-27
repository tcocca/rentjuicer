def valid_listing_rash
  Hashie::Rash.new({
    "rentjuice_id" => 200306,
    "title" => "HUGE 3BR ACROSS FROM BEACH AVAIL 9/15, PARKING AVAILABLE TOO",
    "description" => "Columbia Rd 2nd floor unit available for rent 9/15 or 10/1.  Across from M street beach!  Spacious unit with 2 decks, dining room, living room, 3 good sized BRs, all new kitchen appliances, dishwasher and stove, brand new w/d in unit, large pantry, rental parking avail (2 spots), newly painted, hardwoods were just refinished.  Owner occupied (no college students), easy to show, email to set up today.",
    "agent_name" => "Lindsay Guittarr",
    "agent_email" => "lguittarr@bradvisors.com",
    "agent_phone" => "603-512-3263",
    "featured" => 0,
    "address" => "1744 Columbia Rd, Unit 2",
    "street_number" => 1744,
    "street" => "Columbia Rd",
    "unit_number" => 2,
    "cross_street" => nil,
    "latitude" => 42.3304,
    "longitude" => -71.0327,
    "neighborhoods" => [
      "South Boston", "South End"
    ],
    "floor_number" => 2,
    "property_type" => "Multi-Family House",
    "rent" => 2500,
    "fee" => 0,
    "bedrooms" => 3,
    "bathrooms" => 1,
    "square_footage" => nil,
    "features" => [
      "Dining room",
      "Dishwasher",
      "Hardwood floors",
      "Patio or deck",
      "Refrigerator",
      "Washer/dryer in unit"
    ],
    "rental_terms" => nil,
    "date_available" => "2010-09-15",
    "last_updated" => "2010-08-25 15 =>45 =>56",
    "photos" => [
      {
        "thumbnail" => "http://static.rentjuice.com/frames/2010/08/25/3008823.jpg",
        "sort_order" => 2,
        "main_photo" => false,
        "fullsize" => "http://static.rentjuice.com/frames/2010/08/25/3008825.jpg"
      },
      {
        "thumbnail" => "http://static.rentjuice.com/frames/2010/08/25/3008806.jpg",
        "sort_order" => 3,
        "main_photo" => false,
        "fullsize" => "http://static.rentjuice.com/frames/2010/08/25/3008803.jpg"
      },
      {
        "thumbnail" => "http://static.rentjuice.com/frames/2010/08/25/3008804.jpg",
        "sort_order" => 6,
        "main_photo" => false,
        "fullsize" => "http://static.rentjuice.com/frames/2010/08/25/3008799.jpg"
      },
      {
        "thumbnail" => "http://static.rentjuice.com/frames/2010/08/25/3008802.jpg",
        "sort_order" => 5,
        "main_photo" => false,
        "fullsize" => "http://static.rentjuice.com/frames/2010/08/25/3008810.jpg"
      },
      {
        "thumbnail" => "http://static.rentjuice.com/frames/2010/08/25/3008797.jpg",
        "sort_order" => 4,
        "main_photo" => false,
        "fullsize" => "http://static.rentjuice.com/frames/2010/08/25/3008821.jpg"
      },
      {
        "thumbnail" => "http://static.rentjuice.com/frames/2010/08/25/3008760.jpg",
        "sort_order" => 1,
        "main_photo" => true,
        "fullsize" => "http://static.rentjuice.com/frames/2010/08/25/3008757.jpg"
      }
    ],
    "custom_fields" => [
      {
        "name" => "Virtual Tour",
        "type" => "text",
        "value" => nil
      }
    ],
    "url" => "http://app.rentjuice.com/listings/200306"
  })
end

def sorted_photos_array
  [
    Hashie::Rash.new({
      "thumbnail" => "http://static.rentjuice.com/frames/2010/08/25/3008760.jpg",
      "sort_order" => 1,
      "main_photo" => true,
      "fullsize" => "http://static.rentjuice.com/frames/2010/08/25/3008757.jpg"
    }),
    Hashie::Rash.new({
      "thumbnail" => "http://static.rentjuice.com/frames/2010/08/25/3008823.jpg",
      "sort_order" => 2,
      "main_photo" => false,
      "fullsize" => "http://static.rentjuice.com/frames/2010/08/25/3008825.jpg"
    }),
    Hashie::Rash.new({
      "thumbnail" => "http://static.rentjuice.com/frames/2010/08/25/3008806.jpg",
      "sort_order" => 3,
      "main_photo" => false,
      "fullsize" => "http://static.rentjuice.com/frames/2010/08/25/3008803.jpg"
    }),
    Hashie::Rash.new({
      "thumbnail" => "http://static.rentjuice.com/frames/2010/08/25/3008797.jpg",
      "sort_order" => 4,
      "main_photo" => false,
      "fullsize" => "http://static.rentjuice.com/frames/2010/08/25/3008821.jpg"
    }),
    Hashie::Rash.new({
      "thumbnail" => "http://static.rentjuice.com/frames/2010/08/25/3008802.jpg",
      "sort_order" => 5,
      "main_photo" => false,
      "fullsize" => "http://static.rentjuice.com/frames/2010/08/25/3008810.jpg"
    }),
     Hashie::Rash.new({
      "thumbnail" => "http://static.rentjuice.com/frames/2010/08/25/3008804.jpg",
      "sort_order" => 6,
      "main_photo" => false,
      "fullsize" => "http://static.rentjuice.com/frames/2010/08/25/3008799.jpg"
    })
  ]
end
