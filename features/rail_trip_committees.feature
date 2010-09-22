Feature: Rail Trip Committee Calculations
  The rail trip model should generate correct committee calculations

  Scenario Outline: Distance committee
    Given a rail trip emitter
    And a characteristic "rail_class.name" of "<rail_class>"
    And a characteristic "duration" of "<duration>"
    When the "speed" committee is calculated
    And the "distance" committee is calculated
    Then the conclusion of the committee should be "<distance>"
    Examples:
      | rail_class    | duration | distance |
      | commuter rail |       50 |     2542 |
      |    light rail |       12 |      296 |
