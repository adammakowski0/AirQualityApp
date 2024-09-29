//
//  SimpleEntry.swift
//  AirQualityWidgetExtension
//
//  Created by Adam Makowski on 25/09/2024.
//

import Foundation
import WidgetKit

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: SelectCharacterIntent
    let airQuality: AirQualityIndex?
}
