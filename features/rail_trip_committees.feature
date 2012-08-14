Feature: Rail Trip Committee Calculations
  The rail trip model should generate correct committee calculations

  Background:
    Given a rail_trip

  Scenario: Date committee from timeframe
    And a characteristic "timeframe" of "2010-07-12/2010-11-28"
    When the "date" committee reports
    Then the conclusion of the committee should be "2010-07-12"

  Scenario Outline: Origin location from geocodeable origin
    And a characteristic "origin" of address value "<origin>"
    And the geocoder will encode the origin as "<geocode>" in "country"
    When the "origin_location" committee reports
    Then the committee should have used quorum "from origin"
    And the conclusion of the committee should have "ll" of "<location>"
    Examples:
      | origin            | geocode                 | location                |
      | San Francisco, CA | 37.7749295,-122.4194155 | 37.7749295,-122.4194155 |
      | Los Angeles, CA   | 34.0522342,-118.2436849 | 34.0522342,-118.2436849 |
      | London, UK        | 51.5001524,-0.1262362   | 51.5001524,-0.1262362   |
      | Sheffield, UK     | 53.3830548,-1.4647953   | 53.3830548,-1.4647953   |
      | Paris, France     | 48.856614,2.3522219     | 48.856614,2.3522219     |
      | Grenoble, France  | 45.188529,5.724524      | 45.188529,5.724524      |

  Scenario: Origin location from non-geocodeable origin
    And a characteristic "origin" of "Bag End, Hobbiton, Westfarthing, The Shire, Eriador, Middle Earth"
    And the geocoder will fail to encode the origin
    When the "origin_location" committee reports
    Then the conclusion of the committee should be nil

  Scenario Outline: Destination location from geocodeable destination
    And a characteristic "destination" of address value "<destination>"
    And the geocoder will encode the destination as "<geocode>" in "country"
    When the "destination_location" committee reports
    Then the committee should have used quorum "from destination"
    And the conclusion of the committee should have "ll" of "<location>"
    Examples:
      | destination       | geocode                 | location                |
      | San Francisco, CA | 37.7749295,-122.4194155 | 37.7749295,-122.4194155 |
      | Los Angeles, CA   | 34.0522342,-118.2436849 | 34.0522342,-118.2436849 |
      | London, UK        | 51.5001524,-0.1262362   | 51.5001524,-0.1262362   |
      | Sheffield, UK     | 53.3830548,-1.4647953   | 53.3830548,-1.4647953   |
      | Paris, France     | 48.856614,2.3522219     | 48.856614,2.3522219     |
      | Grenoble, France  | 45.188529,5.724524      | 45.188529,5.724524      |

  Scenario: Destination location from non-geocodeable destination
    And a characteristic "destination" of "Bag End, Hobbiton, Westfarthing, The Shire, Eriador, Middle Earth"
    And the geocoder will fail to encode the destination
    When the "destination_location" committee reports
    Then the conclusion of the committee should be nil

  Scenario Outline: Country from rail company
    And a characteristic "rail_company.name" of "<company>"
    When the "country" committee reports
    Then the committee should have used quorum "from rail company"
    And the conclusion of the committee should have "name" of "<country>"
    Examples:
      | company | country       |
      | Amtrak  | UNITED STATES |
      | SNCF    | FRANCE        |

  Scenario Outline: Country from origin and destination locations in same country
    And a characteristic "origin" of address value "<origin>"
    And the geocoder will encode the origin as "origin" in "<origin_country>"
    And a characteristic "destination" of address value "<destination>"
    And the geocoder will encode the destination as "destination" in "<dest_country>"
    When the "origin_location" committee reports
    When the "destination_location" committee reports
    And the "country" committee reports
    Then the committee should have used quorum "from origin and destination locations"
    And the conclusion of the committee should have "name" of "<country>"
    Examples:
      | origin            | origin_country | destination      | dest_country | country        |
      | San Francisco, CA | US             | Los Angeles, CA  | US           | UNITED STATES  |
      | Paris, France     | FR             | Grenoble, France | FR           | FRANCE         |
      | London, UK        | GB             | Sheffield, UK    | GB           | UNITED KINGDOM |

  Scenario: Country from origin and destination locations in different countries
    And a characteristic "origin" of address value "San Francisco, CA"
    And the geocoder will encode the origin as "origin" in "US"
    And a characteristic "destination" of address value "Paris, France"
    And the geocoder will encode the destination as "destination" in "FR"
    When the "origin_location" committee reports
    When the "destination_location" committee reports
    And the "country" committee reports
    Then the conclusion of the committee should be nil

  Scenario Outline: Country rail traction committee from country and rail traction
    And a characteristic "country.iso_3166_code" of "<country>"
    And a characteristic "rail_traction.name" of "<traction>"
    When the "country_rail_traction" committee reports
    Then the committee should have used quorum "from country and rail traction"
    And the conclusion of the committee should have "name" of "<country_traction>"
    Examples:
      | country | traction | country_traction |
      | US      | diesel   | US diesel        |
      | FR      | electric | FR electric      |

  Scenario Outline: Country rail class committee from country and rail class
    And a characteristic "country.iso_3166_code" of "<country>"
    And a characteristic "rail_class.name" of "<class>"
    When the "country_rail_class" committee reports
    Then the committee should have used quorum "from country and rail class"
    And the conclusion of the committee should have "name" of "<country_class>"
    Examples:
      | country | class     | country_class |
      | US      | intercity | US intercity  |
      | FR      | highspeed | FR highspeed  |

  Scenario Outline: Country rail traction rail class comittee from country, rail traction, and rail class
    And a characteristic "country.iso_3166_code" of "<country>"
    And a characteristic "rail_traction.name" of "<traction>"
    And a characteristic "rail_class.name" of "<class>"
    When the "country_rail_traction_class" committee reports
    Then the committee should have used quorum "from country, rail traction, and rail class"
    And the conclusion of the committee should have "name" of "<country_traction_class>"
    Examples:
      | country | traction | class     | country_traction_class |
      | US      | diesel   | intercity | US diesel intercity    |
      | FR      | electric | highspeed | FR electric highspeed  |

  Scenario: Speed committee from default
    When the "speed" committee reports
    Then the committee should have used quorum "default"
    And the conclusion of the committee should be "97.5"

  Scenario Outline: Speed committee from country
    And a characteristic "country.iso_3166_code" of "<country>"
    When the "speed" committee reports
    Then the committee should have used quorum "from country"
    And the conclusion of the committee should be "<speed>"
    Examples:
      | country | speed |
      | US      | 50.0  |
      | FR      | 100.0 |

  Scenario: Speed committee from country rail class
    And a characteristic "country.iso_3166_code" of "US"
    And a characteristic "rail_class.name" of "intercity"
    When the "country_rail_class" committee reports
    And the "speed" committee reports
    Then the committee should have used quorum "from country rail class"
    And the conclusion of the committee should be "75.0"

  Scenario: Distance committee from default
    When the "distance" committee reports
    Then the committee should have used quorum "default"
    And the conclusion of the committee should be "48.25"

  Scenario Outline: Distance committee from country
    And a characteristic "country.iso_3166_code" of "<country>"
    When the "distance" committee reports
    Then the committee should have used quorum "from country"
    And the conclusion of the committee should be "<distance>"
    Examples:
      | country | distance |
      | US      | 15.0     |
      | FR      | 50.0     |

  Scenario: Distance committee from country rail class
    And a characteristic "country.iso_3166_code" of "US"
    And a characteristic "rail_class.name" of "intercity"
    When the "country_rail_class" committee reports
    And the "distance" committee reports
    Then the committee should have used quorum "from country rail class"
    And the conclusion of the committee should be "150.0"

  Scenario: Distance committee from country rail class missing distance
    And a characteristic "country.iso_3166_code" of "FR"
    And a characteristic "rail_class.name" of "highspeed"
    When the "country_rail_class" committee reports
    And the "distance" committee reports
    Then the committee should have used quorum "from country"
    And the conclusion of the committee should be "50.0"

  Scenario: Distance committee from duration and speed
    And a characteristic "duration" of "7200"
    And a characteristic "speed" of "10.0"
    When the "distance" committee reports
    Then the committee should have used quorum "from duration and speed"
    And the conclusion of the committee should be "20.0"

  Scenario Outline: Distance committee from origin and destination locations
    And a characteristic "origin" of address value "<origin>"
    And the geocoder will encode the origin as "origin" in "origin_country"
    And a characteristic "destination" of address value "<destination>"
    And the geocoder will encode the destination as "destination" in "destination_country"
    And mapquest determines the distance in miles to be "<mapquest_distance>"
    When the "origin_location" committee reports
    And the "destination_location" committee reports
    And the "distance" committee reports
    Then the committee should have used quorum "from origin and destination locations"
    And the conclusion of the committee should be "<distance>"
    Examples:
      | origin       | destination  | mapquest_distance | distance  |
      | 44.0,-73.15  | 44.0,-73.15  | 0.0               | 0.0       |
      | 44.0,-73.15  | 44.1,-73.15  | 8.142             | 13.10328  |

  Scenario: Distance commitee from undriveable origin and destination locations
    And a characteristic "origin" of "Lansing, MI"
    And the geocoder will encode the origin as "Lansing, MI" in "US"
    And a characteristic "destination" of "London, UK"
    And the geocoder will encode the destination as "London, UK" in "UK"
    And mapquest determines the route to be undriveable
    When the "origin_location" committee reports
    And the "destination_location" committee reports
    And the "distance" committee reports
    Then the committee should have used quorum "default"
    And the conclusion of the committee should be "48.25"

  Scenario: Electricity intensity committee from default
    When the "electricity_intensity" committee reports
    Then the committee should have used quorum "default"
    And the conclusion of the committee should be "4.8"

  Scenario Outline: Electricity intensity committee from country
    And a characteristic "country.iso_3166_code" of "<country>"
    When the "electricity_intensity" committee reports
    Then the committee should have used quorum "from country"
    And the conclusion of the committee should be "<electricity>"
    Examples:
      | country | electricity |
      | US      | 1.0         |
      | FR      | 5.0         |

  Scenario Outline: Electricity intensity committee from country rail traction
    And a characteristic "country.iso_3166_code" of "<country>"
    And a characteristic "rail_traction.name" of "<traction>"
    When the "country_rail_traction" committee reports
    And the "electricity_intensity" committee reports
    Then the committee should have used quorum "from country rail traction"
    And the conclusion of the committee should be "<electricity>"
    Examples:
      | country | traction | electricity |
      | US      | diesel   | 0.0         |
      | FR      | electric | 10.0        |

  Scenario: Electricity intensity committee from country rail class
    And a characteristic "country.iso_3166_code" of "US"
    And a characteristic "rail_class.name" of "intercity"
    When the "country_rail_class" committee reports
    And the "electricity_intensity" committee reports
    Then the committee should have used quorum "from country rail class"
    And the conclusion of the committee should be "5.0"

  Scenario: Electricity intensity committee from country rail class with no electricity intensity
    And a characteristic "country.iso_3166_code" of "FR"
    And a characteristic "rail_class.name" of "highspeed"
    When the "country_rail_class" committee reports
    And the "electricity_intensity" committee reports
    Then the committee should have used quorum "from country"
    And the conclusion of the committee should be "5.0"

  Scenario Outline: Electricity intensity committee from rail company
    And a characteristic "rail_company.name" of "<company>"
    When the "electricity_intensity" committee reports
    Then the committee should have used quorum "from rail company"
    And the conclusion of the committee should be "<electricity>"
    Examples:
      | company | electricity |
      | Amtrak  | 2.0         |
      | SNCF    | 4.0         |

  Scenario Outline: Electricity intensity committee from country rail traction rail class
    And a characteristic "country.iso_3166_code" of "<country>"
    And a characteristic "rail_traction.name" of "<traction>"
    And a characteristic "rail_class.name" of "<class>"
    When the "country_rail_traction_class" committee reports
    And the "electricity_intensity" committee reports
    Then the committee should have used quorum "from country rail traction rail class"
    And the conclusion of the committee should be "<electricity>"
    Examples:
      | country | traction | class     | electricity |
      | US      | diesel   | intercity | 0.0         |
      | FR      | electric | highspeed | 20.0        |

  Scenario: Diesel intensity committee from default
    When the "diesel_intensity" committee reports
    Then the committee should have used quorum "default"
    And the conclusion of the committee should be "1.2"

  Scenario Outline: Diesel intensity committee from country
    And a characteristic "country.iso_3166_code" of "<country>"
    When the "diesel_intensity" committee reports
    Then the committee should have used quorum "from country"
    And the conclusion of the committee should be "<diesel>"
    Examples:
      | country | diesel |
      | US      | 5.0    |
      | FR      | 1.0    |

  Scenario Outline: Diesel intensity committee from country rail traction
    And a characteristic "country.iso_3166_code" of "<country>"
    And a characteristic "rail_traction.name" of "<traction>"
    When the "country_rail_traction" committee reports
    And the "diesel_intensity" committee reports
    Then the committee should have used quorum "from country rail traction"
    And the conclusion of the committee should be "<diesel>"
    Examples:
      | country | traction | diesel |
      | US      | diesel   | 10.0   |
      | FR      | electric | 0.0    |

  Scenario: Diesel intensity committee from country rail class
    And a characteristic "country.iso_3166_code" of "US"
    And a characteristic "rail_class.name" of "intercity"
    When the "country_rail_class" committee reports
    And the "diesel_intensity" committee reports
    Then the committee should have used quorum "from country rail class"
    And the conclusion of the committee should be "5.0"

  Scenario: Diesel intensity committee from country rail class with no diesel intensity
    And a characteristic "country.iso_3166_code" of "FR"
    And a characteristic "rail_class.name" of "highspeed"
    When the "country_rail_class" committee reports
    And the "diesel_intensity" committee reports
    Then the committee should have used quorum "from country"
    And the conclusion of the committee should be "1.0"

  Scenario Outline: Diesel intensity committee from rail company
    And a characteristic "rail_company.name" of "<company>"
    When the "diesel_intensity" committee reports
    Then the committee should have used quorum "from rail company"
    And the conclusion of the committee should be "<diesel>"
    Examples:
      | company | diesel |
      | Amtrak  | 4.0    |
      | SNCF    | 2.0    |

  Scenario Outline: Diesel intensity committee from country rail traction rail class
    And a characteristic "country.iso_3166_code" of "<country>"
    And a characteristic "rail_traction.name" of "<traction>"
    And a characteristic "rail_class.name" of "<class>"
    When the "country_rail_traction_class" committee reports
    And the "diesel_intensity" committee reports
    Then the committee should have used quorum "from country rail traction rail class"
    And the conclusion of the committee should be "<diesel>"
    Examples:
      | country | traction | class     | diesel |
      | US      | diesel   | intercity | 20.0   |
      | FR      | electric | highspeed | 0.0    |

  Scenario: Electricity consumption committee from distance and electricity intensity
    And a characteristic "distance" of "10.0"
    And a characteristic "electricity_intensity" of "2.0"
    When the "electricity_consumption" committee reports
    Then the committee should have used quorum "from distance and electricity intensity"
    And the conclusion of the committee should be "20.0"

  Scenario: Diesel consumption committee from distance and diesel intensity
    And a characteristic "distance" of "10.0"
    And a characteristic "diesel_intensity" of "2.0"
    When the "diesel_consumption" committee reports
    Then the committee should have used quorum "from distance and diesel intensity"
    And the conclusion of the committee should be "20.0"

  Scenario: CO2 emission factor from default
    When the "co2_emission_factor" committee reports
    Then the committee should have used quorum "default"
    And the conclusion of the committee should be "8.4"

  Scenario Outline: CO2 emission factor from country
    And a characteristic "country.iso_3166_code" of "<country>"
    When the "co2_emission_factor" committee reports
    Then the committee should have used quorum "from country"
    And the conclusion of the committee should be "<ef>"
    Examples:
      | country | ef   |
      | US      | 16.0 |
      | FR      | 8.0  |

  Scenario Outline: CO2 emission factor from country rail traction
    And a characteristic "country.iso_3166_code" of "<country>"
    And a characteristic "rail_traction.name" of "<traction>"
    When the "country_rail_traction" committee reports
    And the "co2_emission_factor" committee reports
    Then the committee should have used quorum "from country rail traction"
    And the conclusion of the committee should be "<ef>"
    Examples:
      | country | traction | ef   |
      | US      | diesel   | 30.0 |
      | FR      | electric | 10.0 |

  Scenario: CO2 emission factor from country rail class
    And a characteristic "country.iso_3166_code" of "US"
    And a characteristic "rail_class.name" of "intercity"
    When the "country_rail_class" committee reports
    And the "co2_emission_factor" committee reports
    Then the committee should have used quorum "from country rail class"
    And the conclusion of the committee should be "20.0"

  Scenario Outline: CO2 emission factor from rail company
    And a characteristic "rail_company.name" of "<company>"
    When the "co2_emission_factor" committee reports
    Then the committee should have used quorum "from rail company"
    And the conclusion of the committee should be "<ef>"
    Examples:
      | company | ef   |
      | Amtrak  | 14.0 |
      | SNCF    | 10.0 |

  Scenario Outline: CO2 emission factor from country rail traction rail class
    And a characteristic "country.iso_3166_code" of "<country>"
    And a characteristic "rail_traction.name" of "<traction>"
    And a characteristic "rail_class.name" of "<class>"
    When the "country_rail_traction_class" committee reports
    And the "co2_emission_factor" committee reports
    Then the committee should have used quorum "from country rail traction rail class"
    And the conclusion of the committee should be "<ef>"
    Examples:
      | country | traction | class     | ef   |
      | US      | diesel   | intercity | 60.0 |
      | FR      | electric | highspeed | 20.0 |

  Scenario: Carbon from, co2 emission factor, date, and timeframe
    And a characteristic "date" of "2010-06-01"
    And a characteristic "timeframe" of "2010-01-01/2011-01-01"
    And a characteristic "distance" of "10.0"
    And a characteristic "co2_emission_factor" of "2.0"
    When the "carbon" committee reports
    Then the committee should have used quorum "from distance, co2 emission factor, date, and timeframe"
    And the conclusion of the committee should be "20.0"
