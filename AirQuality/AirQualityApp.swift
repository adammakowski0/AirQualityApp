//
//  AirQualityApp.swift
//  AirQuality
//
//  Created by Adam Makowski on 17/09/2024.
//

import SwiftUI

@main
struct AirQualityApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(HomeViewModel())
        }
    }
}
