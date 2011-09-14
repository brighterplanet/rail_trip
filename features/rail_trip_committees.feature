Feature: Rail Trip Committee Calculations
  The rail trip model should generate correct committee calculations

  Scenario: Date committee from timeframe
    Given a rail trip emitter
    And a characteristic "timeframe" of "2010-07-12/2010-11-28"
    When the "date" committee is calculated
    Then the conclusion of the committee should be "2010-07-12"

  Scenario Outline: Origin location from geocodeable origin
    Given a rail trip emitter
    And a characteristic "origin" of address value "<origin>"
    And the geocoder will encode the origin as "<geocode>"
    When the "origin_location" committee is calculated
    Then the committee should have used quorum "from origin"
    And the conclusion of the committee should be "<location>"
    Examples:
      | origin                               | geocode                 | location                |
      | 05753                                | 43.9968185,-73.1491165  | 43.9968185,-73.1491165  |
      | San Francisco, CA                    | 37.7749295,-122.4194155 | 37.7749295,-122.4194155 |
      | 488 Haight Street, San Francisco, CA | 37.7722302,-122.4303328 | 37.7722302,-122.4303328 |
      | Grenoble, France                     | 45.188,5.725            | 45.188,5.725            |
      | Brive-la-Gaillarde, France           | 45.159,1.534            | 45.159,1.534            |

  Scenario: Origin location from non-geocodeable origin
    Given a automobile_trip emitter
    And a characteristic "origin" of "Bag End, Hobbiton, Westfarthing, The Shire, Eriador, Middle Earth"
    And the geocoder will encode the origin as ","
    When the "origin_location" committee is calculated
    Then the conclusion of the committee should be nil

  Scenario Outline: Destination location from geocodeable destination
    Given a automobile_trip emitter
    And a characteristic "destination" of address value "<destination>"
    And the geocoder will encode the destination as "<geocode>"
    When the "destination_location" committee is calculated
    Then the committee should have used quorum "from destination"
    And the conclusion of the committee should be "<location>"
    Examples:
      | origin                               | geocode                 | location                |
      | 05753                                | 43.9968185,-73.1491165  | 43.9968185,-73.1491165  |
      | San Francisco, CA                    | 37.7749295,-122.4194155 | 37.7749295,-122.4194155 |
      | 488 Haight Street, San Francisco, CA | 37.7722302,-122.4303328 | 37.7722302,-122.4303328 |
      | Grenoble, France                     | 45.188,5.725            | 45.188,5.725            |
      | Brive-la-Gaillarde, France           | 45.159,1.534            | 45.159,1.534            |

  Scenario: Destination location from non-geocodeable destination
    Given a automobile_trip emitter
    And a characteristic "destination" of "Bag End, Hobbiton, Westfarthing, The Shire, Eriador, Middle Earth"
    And the geocoder will encode the destination as ","
    When the "destination_location" committee is calculated
    Then the conclusion of the committee should be nil

  Scenario: Country from default
    Given a rail trip emitter
    When the "country" committee is calculated
    Then the committee should have used quorum "default"
    And the conclusion of the committee should have "name" of "fallback"

  Scenario Outline: Country from rail company
    Given a rail trip emitter
    And a characteristic "rail_company.name" of "<company>"
    When the "country" committee is calculated
    Then the committee should have used quorum "from rail company"
    And the conclusion of the committee should have "name" of "<country>"
    Examples:
      | company | country       |
      | Amtrak  | UNITED STATES |
      | SNCF    | FRANCE        |

  Scenario: Country from zip code
    Given a rail trip emitter
    And a characteristic "zip_code.name" of "94122"
    When the "country" committee is calculated
    Then the committee should have used quorum "from zip code"
    And the conclusion of the committee should have "name" of "UNITED STATES"

  Scenario: Country from origin and destination locations in same country
    Given a rail trip emitter
    And a characteristic "origin" of "San Francisco, CA"
    And a characteristic "destination" of "Los Angeles, CA"
    When the "origin_location" committee is calculated
    And the "destination_location" committee is calculated
    And the "country" committee is calculated
    Then the committee should have used quorum "from origin and destination locations"
    And the conclusion of the committee should have "name" of "UNITED STATES"

  Scenario: Country from origin and destination locations in different countries
    Given a rail trip emitter
    And a characteristic "origin" of "San Francisco, CA"
    And a characteristic "destination" of "Grenoble, France"
    When the "origin_location" committee is calculated
    And the "destination_location" committee is calculated
    And the "country" committee is calculated
    Then the committee should have used quorum "default"
    And the conclusion of the committee should have "name" of "fallback"

  Scenario Outline: Country rail traction committee from country and rail traction
    Given a rail trip emitter
    And a characteristic "country.iso_3166_code" of "<country>"
    And a characteristic "rail_traction.name" of "<traction>"
    When the "country_rail_traction" committee is calculated
    Then the committee should have used quorum "from country and rail traction"
    And the conclusion of the committee should have "name" of "<country_traction>"
    Examples:
      | country | traction | country_traction |
      | US      | diesel   | US diesel        |
      | FR      | electric | FR electric      |

  Scenario: Country rail traction committee from default country and rail traction
    Given a rail trip emitter
    And a characteristic "rail_traction.name" of "electric"
    When the "country" committee is calculated
    And the "country_rail_traction" committee is calculated
    Then the conclusion of the committee should be nil

  Scenario Outline: Country rail class committee from country and rail class
    Given a rail trip emitter
    And a characteristic "country.iso_3166_code" of "<country>"
    And a characteristic "rail_class.name" of "<class>"
    When the "country_rail_class" committee is calculated
    Then the committee should have used quorum "from country and raill class"
    And the conclusion of the committee should have "name" of "<country_class>"
    Examples:
      | country | class     | country_class |
      | US      | intercity | US intercity  |
      | FR      | highspeed | FR highspeed  |

  Scenario: Country rail class committee from default country and rail class
    Given a rail trip emitter
    And a characteristic "rail_class.name" of "intercity"
    When the "country" committee is calculated
    And the "country_rail_class" committee is calculated
    Then the conclusion of the committee should be nil

  Scenario Outline: Country rail traction rail class comittee from country, rail traction, and rail class
    Given a rail trip emitter
    And a characteristic "country.iso_3166_code" of "<country>"
    And a characteristic "rail_traction.name" of "<traction>"
    And a characteristic "rail_class.name" of "<class>"
    When the "country_rail_traction_rail_class" committee is calculated
    Then the committee should have used quorum "from country, rail traction, and rail class"
    And the conclusion of the committee should have "name" of "<country_traction_class>"
    Examples:
      | country | traction | class     | country traction class |
      | US      | diesel   | intercity | US diesel intercity    |
      | FR      | electric | highspeed | FR electric highspeed  |

  Scenario: Country rail traction rail class comittee from default country, rail traction, and rail class
    Given a rail trip emitter
    And a characteristic "rail_traction.name" of "<traction>"
    And a characteristic "rail_class.name" of "<class>"
    When the "country" committee is calculated
    And the "country_rail_traction_rail_class" committee is calculated
    Then the conclusion of the committee should be nil

  Scenario Outline: Rail company rail traction committee from rail company and rail traction
    Given a rail trip emitter
    And a characteristic "rail_company.name" of "<company>"
    And a characteristic "rail_traction.name" of "<traction>"
    When the "rail_company_rail_traction" committee is calculated
    Then the committee should have used quorum "from rail company and rail traction"
    And the conclusion of the committee should have "name" of "<company_traction>"
    Examples:
      | company | traction | country_traction |
      | Amtrak  | diesel   | Amtrak diesel    |
      | SNCF    | electric | SNCF electric    |

  Scenario Outline: Rail company rail traction rail class committee from rail company, rail traction, and rail class
    Given a rail trip emitter
    And a characteristic "rail_company.name" of "<company>"
    And a characteristic "rail_traction.name" of "<traction>"
    And a characteristic "rail_class.name" of "<class>"
    When the "rail_company_rail_traction" committee is calculated
    Then the committee should have used quorum "from rail company, rail traction, and rail class"
    And the conclusion of the committee should have "name" of "<company_traction_class>"
    Examples:
      | company | traction | class     | company_traction_class  |
      | Amtrak  | diesel   | intercity | Amtrak diesel intercity |
      | SNCF    | electric | highspeed | SNCF electric highspeed |

  Scenario: Speed committee from default country
    Given a rail trip emitter
    When the "country" committee is calculated
    And the "speed" committee is calculated
    Then the committee should have used quorum "default"
    And the conclusion of the committee should be "25.0"

  Scenario Outline: Speed committee from country
    Given a rail trip emitter
    And a characteristic "country.iso_3166_code" of "<country>"
    When the "speed" committee is calculated
    Then the committee should have used quorum "from country"
    And the conclusion of the committee should be "<speed>"
    Examples:
      | country | speed |
      | US      | 50.0  |
      | FR      | 100.0 |

  Scenario Outline: Speed committee from country rail class
    Given a rail trip emitter
    And a characteristic "country.iso_3166_code" of "<country>"
    And a characteristic "rail_class.name" of "<class>"
    When the "speed" committee is calculated
    Then the committee should have used quorum "from country rail class"
    And the conclusion of the committee should be "<speed>"
    Examples:
      | country | class     | speed |
      | US      | intercity | 75.0  |
      | FR      | highspeed | 200.0 |

  Scenario: Distance committee from default country
    Given a rail trip emitter
    When the "country" committee is calculated
    And the "distance" committee is calculated
    Then the committee should have used quorum "from country"
    And the conclusion of the committee should be "50.0"

  Scenario Outline: Distance committee from country
    Given a rail trip emitter
    And a characteristic "country.iso_3166_code" of "<country>"
    When the "distance" committee is calculated
    Then the committee should have used quorum "from country"
    And the conclusion of the committee should be "<distance>"
    Examples:
      | country | distance |
      | US      | 15.0     |
      | FR      | 50.0     |

  Scenario: Distance committee from country rail class
    Given a rail trip emitter
    And a characteristic "country_rail_class.name" of "US intercity"
    When the "distance" committee is calculated
    Then the committee should have used quorum "from country rail class"
    And the conclusion of the committee should be "150.0"

  Scenario: Distance committee from country rail class missing distance
    Given a rail trip emitter
    And a characteristic "country_rail_class.name" of "FR highspeed"
    When the "distance" committee is calculated
    Then the committee should have used quorum "from country"
    And the conclusion of the committee should be "50.0"

  Scenario Outline: Distance committee from duration and speed
    Given a rail trip emitter
    And a characteristic "duration" of "2.0"
    And a characteristic "speed" of "10.0"
    When the "distance" committee is calculated
    Then the committee should have used quorum "from duration and speed"
    And the conclusion of the committee should be "20.0"

  Scenario Outline: Distance committee from origin and destination locations
    Given a rail trip emitter
    And a characteristic "origin" of "<origin>"
    And a characteristic "destination" of "<destination>"
    When the "origin_location" committee is calculated
    And the "destination_location" committee is calculated
    And the "distance" committee is calculated
    Then the committee should have used quorum "from origin and destination locations"
    And the conclusion of the committee should be "<distance>"
    Examples:
      | origin       | destination  | distance |
      | 43,-73       | 43,-73       | 0.0      |
      | 43,-73       | 43.1,-73     | 57.93638 |
      | 45.188,5.725 | 45.159,1.534 | 490.0    |

  Scenario: Distance commitee from undriveable origin and destination locations
    Given an automobile_trip emitter
    And a characteristic "origin" of "Lansing, MI"
    And a characteristic "destination" of "Canterbury, Kent, UK"
    When the "origin_location" committee is calculated
    And the "destination_location" committee is calculated
    And the "distance" committee is calculated
    Then the committee should have used quorum "default"
    And the conclusion of the committee should be "50.0"

  Scenario: Electricity consumption committee from distance and default country
    Given a rail trip emitter
    When the "country" committee is calculated
    And the "distance" committee is calculated
    And the "electricity_consumption" committee is calculated
    Then the committee should have used quorum "from distance and country"
    And the conclusion of the committee should be "250.0"

  Scenario Outline: Electricity consumption committee from distance and country
    Given a rail trip emitter
    And a characteristic "country.iso_3166_code" of "<country>"
    When the "distance" committee is calculated
    And the "electricity_consumption" committee is calculated
    Then the committee should have used quorum "from distance and country"
    And the conclusion of the committee should be "<electricity>"
    Examples:
      | country | electricity |
      | US      | 15.0        |
      | FR      | 250.0       |

  Scenario Outline: Electricity consumption committee from distance and country rail traction
    Given a rail trip emitter
    And a characteristic "country.iso_3166_code" of "<country>"
    And a characteristic "country_rail_traction.name" of "<country_rail_traction>"
    When the "distance" committee is calculated
    And the "electricity_consumption" committee is calculated
    Then the committee should have used quorum "from distance and country rail traction"
    And the conclusion of the committee should be "<electricity>"
    Examples:
      | country_rail_traction | electricity |
      | US diesel             | 0.0         |
      | FR electric           | 500.0       |

  Scenario Outline: Electricity consumption committee from distance and country rail class
    Given a rail trip emitter
    And a characteristic "country.iso_3166_code" of "<country>"
    And a characteristic "country_rail_class.name" of "<country_rail_class>"
    When the "distance" committee is calculated
    And the "electricity_consumption" committee is calculated
    Then the committee should have used quorum "from distance and country rail class"
    And the conclusion of the committee should be "<electricity>"
    Examples:
      | country_rail_class | electricity |
      | US intercity       | 75.0        |
      | FR highspeed       | 750.0       |

  Scenario Outline: Electricity consumption committee from distance and rail company
    Given a rail trip emitter
    And a characteristic "country_rail_company.name" of "<country_rail_company>"
    When the "country" committee is calculated
    And the "distance" committee is calculated
    And the "electricity_consumption" committee is calculated
    Then the committee should have used quorum "from distance and rail company"
    And the conclusion of the committee should be "<electricity>"
    Examples:
      | rail_company | electricity |
      | Amtrak       | 30.0        |
      | SNCF         | 250.0       |

  Scenario Outline: Electricity consumption committee from distance and country rail traction rail class
    Given a rail trip emitter
    And a characteristic "country_rail_traction_rail_class.name" of "<country_traction_class>"
    And the "distance" committee is calculated
    And the "electricity_consumption" committee is calculated
    Then the committee should have used quorum "from distance and country rail traction rail class"
    And the conclusion of the committee should be "<electricity>"
    Examples:
      | country_traction_class | electricity |
      | US diesel intercity    | 0.0         |
      | FR electric highspeed  | 1000.0      |

  Scenario Outline: Electricity consumption committee from distance and rail company rail traction
    Given a rail trip emitter
    And a characteristic "rail_company_rail_traction.name" of "<company_traction>"
    And the "country" committee is calculated
    And the "distance" committee is calculated
    And the "electricity_consumption" committee is calculated
    Then the committee should have used quorum "from distance and rail company rail traction"
    And the conclusion of the committee should be "<electricity>"
    Examples:
      | company_traction | electricity |
      | Amtrak diesel    | 0.0         |
      | SNCF electric    | 750.0       |

  Scenario Outline: Electricity consumption committee from distance and rail company rail traction rail class
    Given a rail trip emitter
    And a characteristic "rail_company_rail_traction_rail_class.name" of "<company_traction_class>"
    And the "country" committee is calculated
    And the "distance" committee is calculated
    And the "electricity_consumption" committee is calculated
    Then the committee should have used quorum "from distance and rail company rail traction rail class"
    And the conclusion of the committee should be "<electricity>"
    Examples:
      | company_traction_class  | electricity |
      | Amtrak diesel intercity | 0.0         |
      | SNCF electric highspeed | 1000.0      |

  Outline: Diesel consumption committee from distance and default country
    Given a rail trip emitter
    When the "country" committee is calculated
    And the "distance" committee is calculated
    And the "diesel_consumption" committee is calculated
    Then the committee should have used quorum "from distance and country"
    And the conclusion of the committee should be "100.0"

  Scenario Outline: Diesel consumption committee from distance and country
    Given a rail trip emitter
    And a characteristic "country.iso_3166_code" of "<country>"
    When the "distance" committee is calculated
    And the "diesel_consumption" committee is calculated
    Then the committee should have used quorum "from distance and country"
    And the conclusion of the committee should be "<diesel>"
    Examples:
      | country | diesel |
      | US      | 60.0   |
      | FR      | 50.0   |

  Scenario Outline: Diesel consumption committee from distance and country rail traction
    Given a rail trip emitter
    And a characteristic "country.iso_3166_code" of "<country>"
    And a characteristic "country_rail_traction.name" of "<country_rail_traction>"
    When the "distance" committee is calculated
    And the "diesel_consumption" committee is calculated
    Then the committee should have used quorum "from distance and country rail traction"
    And the conclusion of the committee should be "<diesel>"
    Examples:
      | country_rail_traction | diesel |
      | US diesel             | 150.0  |
      | FR electric           | 0.0    |

  Scenario Outline: Diesel consumption committee from distance and country rail class
    Given a rail trip emitter
    And a characteristic "country.iso_3166_code" of "<country>"
    And a characteristic "country_rail_class.name" of "<country_rail_class>"
    When the "distance" committee is calculated
    And the "diesel_consumption" committee is calculated
    Then the committee should have used quorum "from distance and country rail class"
    And the conclusion of the committee should be "<diesel>"
    Examples:
      | country_rail_class | diesel |
      | US intercity       | 75.0   |
      | FR highspeed       | 0.0    |

  Scenario Outline: Diesel consumption committee from distance and rail company
    Given a rail trip emitter
    And a characteristic "country_rail_company.name" of "<country_rail_company>"
    When the "country" committee is calculated
    And the "distance" committee is calculated
    And the "diesel_consumption" committee is calculated
    Then the committee should have used quorum "from distance and rail company"
    And the conclusion of the committee should be "<diesel>"
    Examples:
      | rail_company | diesel |
      | Amtrak       | 60.0   |
      | SNCF         | 50.0   |

  Scenario Outline: Diesel consumption committee from distance and country rail traction rail class
    Given a rail trip emitter
    And a characteristic "country_rail_traction_rail_class.name" of "<country_traction_class>"
    And the "distance" committee is calculated
    And the "diesel_consumption" committee is calculated
    Then the committee should have used quorum "from distance and country rail traction rail class"
    And the conclusion of the committee should be "<diesel>"
    Examples:
      | country_traction_class | diesel |
      | US diesel intercity    | 300.0  |
      | FR electric highspeed  | 0.0    |

  Scenario Outline: Diesel consumption committee from distance and rail company rail traction
    Given a rail trip emitter
    And a characteristic "rail_company_rail_traction.name" of "<company_traction>"
    And the "country" committee is calculated
    And the "distance" committee is calculated
    And the "diesel_consumption" committee is calculated
    Then the committee should have used quorum "from distance and rail company rail traction"
    And the conclusion of the committee should be "<diesel>"
    Examples:
      | company_traction | diesel |
      | Amtrak diesel    | 300.0  |
      | SNCF electric    | 0.0    |

  Scenario Outline: Diesel consumption committee from distance and rail company rail traction rail class
    Given a rail trip emitter
    And a characteristic "rail_company_rail_traction_rail_class.name" of "<company_traction_class>"
    And the "country" committee is calculated
    And the "distance" committee is calculated
    And the "diesel_consumption" committee is calculated
    Then the committee should have used quorum "from distance and rail company rail traction rail class"
    And the conclusion of the committee should be "<diesel>"
    Examples:
      | company_traction_class  | diesel |
      | Amtrak diesel intercity | 300.0  |
      | SNCF electric highspeed | 0.0    |

  Scenario: Emission from distance and default country
    Given a rail trip emitter
    When the "country" committee is calculated
    And the "distance" committee is calculated
    And the "emission" committee is calculated
    Then the committee should have used quorum "distance and country"
    And the conclusion of the committee should be "69.0"

  Scenario Outline: Emission from distance and country
    Given a rail trip emitter
    And a characteristic "country.iso_3166_code" of "<country>"
    And a characteristic "distance" of "100.0"
    When the "emission" committee is calculated
    Then the committee should have used quorum "distance and country"
    And the conclusion of the committee should be "<emission>"
    Example:
      | country | emission |
      | US      | 100.0    |
      | FR      | 100.0    |

  Scenario Outline: Emission from distance and country rail traction
    Given a rail trip emitter
    And a characteristic "country_rail_traction.name" of "<country_traction>"
    And a characteristic "distance" of "100.0"
    When the "emission" committee is calculated
    Then the committee should have used quorum "distance and country rail traction"
    And the conclusion of the committee should be "<emission>"
    Example:
      | country_traction | emission |
      | US diesel        | 100.0    |
      | FR electric      | 100.0    |

  Scenario Outline: Emission from distance and country rail class
    Given a rail trip emitter
    And a characteristic "country_rail_class.name" of "<country_class>"
    And a characteristic "distance" of "100.0"
    When the "emission" committee is calculated
    Then the committee should have used quorum "distance and country rail class"
    And the conclusion of the committee should be "<emission>"
    Example:
      | country_class | emission |
      | US intercity  | 100.0    |
      | FR highspeed  | 100.0    |

  Scenario Outline: Emission from distance and rail company
    Given a rail trip emitter
    And a characteristic "country_rail_company.name" of "<company>"
    And a characteristic "distance" of "100.0"
    When the "emission" committee is calculated
    Then the committee should have used quorum "distance and rail company"
    And the conclusion of the committee should be "<emission>"
    Example:
      | company | emission |
      | Amtrak  | 100.0    |
      | SNCF    | 100.0    |

  Scenario Outline: Emission from distance and country rail traction rail class
    Given a rail trip emitter
    And a characteristic "country_rail_traction_rail_class.name" of "<country_traction_class>"
    And a characteristic "distance" of "100.0"
    When the "emission" committee is calculated
    Then the committee should have used quorum "distance and country rail traction rail class"
    And the conclusion of the committee should be "<emission>"
    Example:
      | country_traction_class | emission |
      | US diesel intercity    | 100.0    |
      | FR electric highspeed  | 100.0    |

  Scenario Outline: Emission from distance and rail company rail traction
    Given a rail trip emitter
    And a characteristic "rail_company_rail_traction.name" of "<company_traction>"
    And a characteristic "distance" of "100.0"
    When the "emission" committee is calculated
    Then the committee should have used quorum "distance and rail company rail traction"
    And the conclusion of the committee should be "<emission>"
    Example:
      | company_traction | emission |
      | Amtrak diesel    | 100.0    |
      | SNCF electric    | 100.0    |

  Scenario Outline: Emission from distance and rail company rail traction rail class
    Given a rail trip emitter
    And a characteristic "rail_company_rail_traction_rail_class.name" of "<company_traction_class>"
    And a characteristic "distance" of "100.0"
    When the "emission" committee is calculated
    Then the committee should have used quorum "distance and rail company rail traction rail class"
    And the conclusion of the committee should be "<emission>"
    Example:
      | company_traction_class  | emission |
      | Amtrak diesel intercity | 100.0    |
      | SNCF electric highspeed | 100.0    |
