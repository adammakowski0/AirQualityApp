//
//  AppIntent.swift
//  AirQualityWidget
//
//  Created by Adam Makowski on 24/09/2024.
//

import WidgetKit
import AppIntents
import SwiftUI

struct SelectStationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Wybierz stację pomiarową"
    static var description = IntentDescription("Wyświetla dane o jakości powietrza z wybranej stacji pomiarowej.")

    @Parameter(title: "Stacja pomiarowa")
    var station: StationDetail?
    
    @Parameter(title: "Czujnik")
    var sensor: SensorDetail?

    init(station: StationDetail, sensor: SensorDetail) {
        self.station = station
        self.sensor = sensor
    }
    
    init() {
    }
}

