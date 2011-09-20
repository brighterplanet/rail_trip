Feature: Rail Trip Emissions Calculations
  The rail trip model should generate correct emission calculations

  Scenario: Calculations for rail trip with nothing
    Given a rail trip has nothing
    When emissions are calculated
    Then the emission value should be within "0.1" kgs of "600.0"

  Scenario Outline: Calculations for rail trip from date and timeframe
    Given a rail trip has "date" of "<date>"
    And it has "timeframe" of "<timeframe>"
    When emissions are calculated
    Then the emission value should be within "0.1" kgs of "<emission>"
    Examples:
      | date       | timeframe             | emission |
      | 2010-07-12 | 2010-07-01/2010-07-10 | 0.0      |
      | 2010-07-12 | 2010-07-01/2010-07-30 | 600.0    |
      | 2010-07-12 | 2010-07-15/2010-07-30 | 0.0      |

  Scenario Outline: Calculation for rail trip from country
    Given a rail trip has "country.iso_3166_code" of "<country>"
    When emissions are calculated
    Then the emission value should be within "0.1" kgs of "<emission>"
    Examples:
      | country | emission |
      | US      | 240.0    |
      | FR      | 400.0    |
      | UK      | 600.0    |

  Scenario Outline: Calculation for rail trip from rail company
    Given a rail trip has "rail_company.name" of "<company>"
    When emissions are calculated
    Then the emission value should be within "0.1" kgs of "<emission>"
    Examples:
      | company  | emission |
      | Amtrak   | 210.0    |
      | SNCF     | 500.0    |
      | Eurostar | 500.0    |

  Scenario Outline: Calculation for rail trip from locations
    Given a rail trip has "origin" of "<origin>"
    And the geocoder will encode the origin as "origin" in "<origin_country>"
    And it has "destination" of "<destination>"
    And the geocoder will encode the destination as "destination" in "<destination_country>"
    And mapquest determines the distance in miles to be "<distance>"
    When emissions are calculated
    Then the emission value should be within "0.1" kgs of "<emission>"
    Examples:
      | origin      | origin_country | destination | destination_country | distance | emission | comment |
      | 37.8,-122.4 | US             | 34.1,-118.2 | US                  | 382.2    | 9841.5   | SF to LA |
      | 48.9,2.4    | FR             | 45.2,5.7    | FR                  | 360.3    | 4638.8   | Paris to Grenoble |
      | 51.5,-0.1   | UK             | 48.9,2.4    | FR                  | 278.8    | 5384.2   | London to Paris |

  Scenario: Calculation for rail trip from undriveable locations
    Given a rail trip has "origin" of "37.8,-122.4"
    And the geocoder will encode the origin as "origin" in "US"
    And it has "destination" of "destination"
    And the geocoder will encode the destination as "48.9,2.4" in "FR"
    And mapquest determines the route to be undriveable
    When emissions are calculated
    Then the emission value should be within "0.1" kgs of "600.0"

  Scenario: Calculations for rail trip from duration
    Given a rail trip has "duration" of "3.0"
    When emissions are calculated
    Then the emission value should be within "0.1" kgs of "900.0"

  Scenario: Calculations for rail trip from distance
    Given a rail trip has "distance" of "100.0"
    When emissions are calculated
    Then the emission value should be within "0.1" kgs of "1200.0"

  Scenario Outline: Calculation for rail trip from country traction
    Given a rail trip has "country.iso_3166_code" of "<country>"
    And it has "rail_traction.name" of "<traction>"
    When emissions are calculated
    Then the emission value should be within "0.1" kgs of "<emission>"
    Examples:
      | country | traction | emission |
      | US      | diesel   | 450.0    |
      | FR      | electric | 500.0    |

  Scenario: Calculation for rail trip from country class
    Given a rail trip has "country.iso_3166_code" of "US"
    And it has "rail_class.name" of "intercity"
    When emissions are calculated
    Then the emission value should be within "0.1" kgs of "3000.0"

  Scenario Outline: Calculation for rail trip from country traction class
    Given a rail trip has "country.iso_3166_code" of "<country>"
    And it has "rail_traction.name" of "<traction>"
    And it has "rail_class.name" of "<class>"
    When emissions are calculated
    Then the emission value should be within "0.1" kgs of "<emission>"
    Examples:
      | country | traction | class     | emission |
      | US      | diesel   | intercity | 9000.0   |
      | FR      | electric | highspeed | 1000.0   |

  Scenario Outline: Calculation for rail trip from company traction
    Given a rail trip has "rail_company.name" of "<company>"
    And it has "rail_traction.name" of "<traction>"
    When emissions are calculated
    Then the emission value should be within "0.1" kgs of "<emission>"
    Examples:
      | company | traction | emission |
      | Amtrak  | diesel   | 675.0    |
      | SNCF    | electric | 750.0    |

  Scenario Outline: Calculation for rail trip from company traction class
    Given a rail trip has "rail_company.name" of "<company>"
    And it has "rail_traction.name" of "<traction>"
    And it has "rail_class.name" of "<class>"
    When emissions are calculated
    Then the emission value should be within "0.1" kgs of "<emission>"
    Examples:
      | company | traction | class     | emission |
      | Amtrak  | diesel   | intercity | 9000.0   |
      | SNCF    | electric | highspeed | 1000.0   |

  Scenario: Calculation for rail trip from locations and rail company
    Given a rail trip has "rail_company.name" of "Eurostar"
    And it has "origin" of "London, UK"
    And the geocoder will encode the origin as "origin" in "UK"
    And it has "destination" of "Paris, France"
    And the geocoder will encode the destination as "destination" in "FR"
    And mapquest determines the distance in miles to be "278.8"
    When emissions are calculated
    Then the emission value should be within "0.1" kgs of "4486.9"

  Scenario: Calculation for rail trip from locations and country class
    Given a rail trip has "country.iso_3166_code" of "US"
    And it has "rail_class.name" of "intercity"
    And it has "origin" of "San Francisco, CA"
    And the geocoder will encode the origin as "origin" in "US"
    And it has "destination" of "Los Angeles, CA"
    And the geocoder will encode the destination as "destination" in "US"
    And mapquest determines the distance in miles to be "382.2"
    When emissions are calculated
    Then the emission value should be within "0.1" kgs of "12301.8"

  Scenario: Calculation for rail trip from locations and company traction class
    Given a rail trip has "rail_company.name" of "SNCF"
    And it has "rail_traction.name" of "electric"
    And it has "rail_class.name" of "highspeed"
    And it has "origin" of "Paris, France"
    And the geocoder will encode the origin as "origin" in "FR"
    And it has "destination" of "Grenoble, France"
    And the geocoder will encode the destination as "destination" in "FR"
    And mapquest determines the distance in miles to be "360.3"
    When emissions are calculated
    Then the emission value should be within "0.1" kgs of "11596.9"
