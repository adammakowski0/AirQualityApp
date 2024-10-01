//
//  WidgetViewModel.swift
//  AirQualityWidgetExtension
//
//  Created by Adam Makowski on 25/09/2024.
//

import Foundation
import SwiftUI
import WidgetKit

class WidgetViewModel {

    func getColor(forAirQuality quality: String) -> Color {
        switch quality {
        case "Bardzo dobry":
            return Color(red: 0.1, green: 0.9, blue: 0.0)
        case "Dobry":
            return Color(red: 0.2, green: 0.8, blue: 0.0)
        case "Umiarkowany":
            return Color(red: 0.4, green: 0.6, blue: 0.0)
        case "Dostateczny":
            return Color(red: 0.7, green: 0.4, blue: 0.0)
        case "Zły":
            return Color(red: 0.8, green: 0.2, blue: 0.0)
        case "Bardzo zły":
            return Color(red: 1.0, green: 0.0, blue: 0.0)
        default:
            return .gray
        }
    }
}
