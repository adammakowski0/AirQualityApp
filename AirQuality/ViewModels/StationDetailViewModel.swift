//
//  StationDetailViewModel.swift
//  AirQuality
//
//  Created by Adam Makowski on 17/09/2024.
//

import Foundation
import Combine
import SwiftUI
import CoreData

class StationDetailViewModel: ObservableObject {
    
    @Published var sensors: [Sensor] = []
    
    @Published var sensorData: SensorData? = nil
    
    @Published var airQualityIndex: AirQualityIndex? = nil
    
    @Published var isFavourite: Bool = false
    
    @Published var savedEntities: [FavouritesEntity] = []
    
    var cancelables = Set<AnyCancellable>()
    
    var station: Station
    
    var favouritesDataManager = FavouritesCoreDataManager()
    
    init(station: Station) {
        self.station = station
        downloadSensors(stationID: station.id)
        downloadAirQualityIndex(stationID: station.id)
        getFavouriteStationData()
    }
    
    func getFavouriteStationData(){
        
        savedEntities = favouritesDataManager.fetchData()
            for entity in savedEntities{
                if entity.stationName == station.stationName{
                    station.isFavourite = true
                    isFavourite = true
                }
            }
        favouritesDataManager.saveData()
        
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
        
        if var favourite = station.isFavourite {
            favourite.toggle()
            station.isFavourite = favourite
            isFavourite = favourite
        }
        else {
            station.isFavourite = true
            isFavourite = true
        }
        if isFavourite{
            let favourite = favouritesDataManager.getEntity()
            favourite.stationID = Int32(station.id)
            favourite.stationName = station.stationName
            if !savedEntities.contains(where: { $0 == favourite }) {
                savedEntities.append(favourite)
            }
            favouritesDataManager.saveData()
        }
        else {
            deleteFromFavourites()
        }
    }
    
    func deleteFromFavourites() {
        for entity in savedEntities {
            if entity.stationName == station.stationName {
                
                favouritesDataManager.deleteEntity(entity: entity)
            }
        }
        favouritesDataManager.saveData()
    }
    
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
