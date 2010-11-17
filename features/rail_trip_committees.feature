Feature: Rail Trip Committee Calculations
  The rail trip model should generate correct committee calculations

  Scenario: Date committee from timeframe
    Given a rail trip emitter
    And a characteristic "timeframe" of "2010-07-12/2010-11-28"
    When the "date" committee is calculated
    Then the conclusion of the committee should be "2010-07-12"

  Scenario: Rail class committee from default
    Given a rail trip emitter
    When the "rail_class" committee is calculated
    Then the conclusion of the committee should have "name" of "US average"

  Scenario: Passengers committee from rail class
    Given a rail trip emitter
    And a characteristic "rail_class.name" of "commuter rail"
    When the "passengers" committee is calculated
    Then the conclusion of the committee should be "25.0"

  Scenario: Speed committee from rail class
    Given a rail trip emitter
    And a characteristic "rail_class.name" of "commuter rail"
    When the "speed" committee is calculated
    Then the conclusion of the committee should be "50.0"

  Scenario: Electricity intensity committee from rail class
    Given a rail trip emitter
    And a characteristic "rail_class.name" of "commuter rail"
    When the "electricity_intensity" committee is calculated
    Then the conclusion of the committee should be "12.0"

  Scenario: Diesel intensity committee from rail class
    Given a rail trip emitter
    And a characteristic "rail_class.name" of "commuter rail"
    When the "diesel_intensity" committee is calculated
    Then the conclusion of the committee should be "0.75"

  Scenario: Distance committee from duration and speed
    Given a rail trip emitter
    And a characteristic "duration" of "2"
    And a characteristic "speed" of "50"
    When the "distance" committee is calculated
    Then the committee should have used quorum "from duration and speed"
    And the conclusion of the committee should be "100.0"

  Scenario: Distance committee from rail class
    Given a rail trip emitter
    And a characteristic "rail_class.name" of "commuter rail"
    When the "distance" committee is calculated
    Then the committee should have used quorum "from rail class"
    And the conclusion of the committee should be "10.0"

  Scenario: Electricity consumed committee from distance and electricity intensity
    Given a rail trip emitter
    And a characteristic "distance" of "100"
    And a characteristic "electricity_intensity" of "2"
    When the "electricity_consumed" committee is calculated
    Then the conclusion of the committee should be "200.0"

  Scenario: Diesel consumed committee from distance and diesel intensity
    Given a rail trip emitter
    And a characteristic "distance" of "100"
    And a characteristic "diesel_intensity" of "2"
    When the "diesel_consumed" committee is calculated
    Then the conclusion of the committee should be "200.0"

  Scenario: Electricity emission factor from default
    Given a rail trip emitter
    When the "electricity_emission_factor" committee is calculated
    Then the conclusion of the committee should be "1.0"

  Scenario: Diesel emission factor from default
    Given a rail trip emitter
    When the "diesel_emission_factor" committee is calculated
    Then the conclusion of the committee should be "2.0"
