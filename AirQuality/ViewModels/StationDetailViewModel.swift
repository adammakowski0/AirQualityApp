//
//  StationDetailViewModel.swift
//  AirQuality
//
//  Created by Adam Makowski on 17/09/2024.
//

import Foundation
import Combine
import SwiftUI

class StationDetailViewModel: ObservableObject {
    
    @Published var sensors: [Sensor] = []
    
    @Published var sensorData: SensorData? = nil
    
    @Published var airQualityIndex: AirQualityIndex? = nil
    
    @Published var isFavourite: Bool = false
    
    var cancelables = Set<AnyCancellable>()
    
    var station: Station
    
    init(station: Station) {
        self.station = station
        downloadSensors(stationID: station.id)
        downloadAirQualityIndex(stationID: station.id)
    }
    
    func downloadSensors(stationID: Int) {
        
        guard let url = URL(string: "https://api.gios.gov.pl/pjp-api/rest/station/sensors/\(stationID)") else { return }
        
        NetworkManager.download(url: url)
            .decode(type: [Sensor].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] returnedSensors in
                self?.sensors = returnedSensors
            })
            .store(in: &cancelables)
    }
    
    func downloadAirQualityIndex(stationID: Int) {
        guard let url = URL(string: "https://api.gios.gov.pl/pjp-api/rest/aqindex/getIndex/\(stationID)") else { return }
        
        NetworkManager.download(url: url)
            .decode(type: AirQualityIndex.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] airQuality in
                self?.airQualityIndex = airQuality
            })
            .store(in: &cancelables)
    }
    
    func addToFavourites() {
        isFavourite.toggle()
        if var favourite = station.isFavourite {
            favourite.toggle()
            station.isFavourite = favourite
        }
        else {
            station.isFavourite = true
        }
        print(station)
        
    }
    
    func getColor(forAirQuality quality: String) -> Color {
        switch quality {
        case "Bardzo dobry":
            return Color(red: 0.1, green: 0.9, blue: 0.0)
        case "Dobry":
            return Color(red: 0.2, green: 0.8, blue: 0.0)
        case "Umiarkowany":
            return Color(red: 0.5, green: 0.5, blue: 0.0)
        case "Zły":
            return Color(red: 0.8, green: 0.2, blue: 0.0)
        case "Bardzo zły":
            return Color(red: 1.0, green: 0.0, blue: 0.0)
        default:
            return .gray
        }
    }
}
