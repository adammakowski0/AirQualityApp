//
//  SimpleEntry.swift
//  AirQualityWidgetExtension
//
//  Created by Adam Makowski on 25/09/2024.
//

import Foundation
import WidgetKit

struct AirQualityEntry: TimelineEntry {
    let date: Date
    let configuration: SelectStationIntent
    let airQualityResponse: AirQualityIndexResponse?
    let sensorDataResponse: SensorDataResponse?
}
