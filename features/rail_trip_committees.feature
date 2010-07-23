Feature: Rail Trip Committee Calculations
  The rail trip model should generate correct committee calculations

  Scenario Outline: Distance committee
    Given a rail trip has "rail_class.name" of "<rail_class>"
    And it has "duration" of "<duration>"
    When emissions are calculated
    Then the distance committee should be close to <distance>, +/-1
    Examples:
      | rail_class    | duration | distance |
      | commuter rail |       50 |     2542 |
      |    light rail |       12 |      296 |
