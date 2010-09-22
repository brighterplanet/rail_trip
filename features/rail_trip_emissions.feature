Feature: Rail Trip Emissions Calculations
  The rail trip model should generate correct emission calculations

  Scenario Outline: Standard Calculations for rail trip
    Given a rail trip has "rail_class.name" of "<rail_class>"
    And it has "distance_estimate" of "<distance>"
    When emissions are calculated
    Then the emission value should be within "0.1" kgs of "<emission>"
    Examples:
      | rail_class    | distance | emission |
      | commuter rail |       50 |     13.9 |
      |    light rail |       12 |      6.0 |
