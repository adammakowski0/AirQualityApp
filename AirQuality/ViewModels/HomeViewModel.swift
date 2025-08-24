//
//  StationViewModel.swift
//  AirQuality
//
//  Created by Adam Makowski on 17/09/2024.
//

import Foundation
import Combine
import MapKit
import SwiftUI

class HomeViewModel: ObservableObject {
    
    @Published var allStations: [Station] = []
    
    @Published var showStationDetails: Station? = nil
    
    @Published var currentStation: Station?
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 52.0, longitude: 19.0), span: MKCoordinateSpan(latitudeDelta: 10.0, longitudeDelta: 10.0))
    
    @Published var savedEntities: [FavouritesEntity] = []
    
    @Published var showFavourites: Bool = false
    
    @Published var dataLoaded: Bool = false
    
    @Published var loading: Bool = false
    
    var cancelables = Set<AnyCancellable>()
    
    var favouritesDataManager = FavouritesCoreDataManager()
    
    var timer: Timer?
    var totalPages: Int?
    
    init() {
        downloadStations()
        getFavouriteStationData()
    }
    
    func getFavouriteStationData(){
        
        savedEntities = favouritesDataManager.fetchData()
        
        favouritesDataManager.saveData()
        
    }
    
    func downloadStations() {
        dataLoaded = false
        loading = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block: { timer in
            self.loading = false
            return
        })
        
        guard let firstURL = URL(string: "https://api.gios.gov.pl/pjp-api/v1/rest/station/findAll?page=0&size=20") else { return }

        NetworkManager.download(url: firstURL)
            .decode(type: StationsResponse.self, decoder: JSONDecoder())
            .flatMap { [weak self] firstResponse -> AnyPublisher<[Station], Error> in
                guard let self = self else {
                    return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
                }

                self.totalPages = firstResponse.totalPages ?? 1
                var allStations = firstResponse.stations

                // Jeśli tylko 1 strona → zwróć od razu
                guard self.totalPages ?? 1 > 1 else {
                    return Just(allStations).setFailureType(to: Error.self).eraseToAnyPublisher()
                }

                // Tworzymy publisher dla pozostałych stron
                let publishers = (1..<(self.totalPages ?? 1)).compactMap { page -> AnyPublisher<[Station], Error>? in
                    guard let url = URL(string: "https://api.gios.gov.pl/pjp-api/v1/rest/station/findAll?page=\(page)&size=20") else {
                        return nil
                    }
                    return NetworkManager.download(url: url)
                        .decode(type: StationsResponse.self, decoder: JSONDecoder())
                        .map { $0.stations }
                        .eraseToAnyPublisher()
                }

                return Publishers.MergeMany(publishers)
                    .collect()
                    .map { moreStations -> [Station] in
                        allStations.append(contentsOf: moreStations.flatMap { $0 })
                        return allStations
                    }
                    .eraseToAnyPublisher()
            }
            .sink(receiveCompletion: NetworkManager.handleCompletion,
                  receiveValue: { [weak self] stations in
                      self?.allStations = stations
                      self?.dataLoaded = true
                      self?.timer?.invalidate()
                  })
            .store(in: &cancelables)
    }

    func updateRegion(currentStation: Station) {
        region.center = CLLocationCoordinate2D(latitude: Double(currentStation.gegrLat) ?? region.center.latitude, longitude: Double(currentStation.gegrLon) ?? region.center.longitude)
        
        self.currentStation = currentStation
    }
}
