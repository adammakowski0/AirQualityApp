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
    
    var cancelables = Set<AnyCancellable>()
    
    init() {
        downloadStations()
    }
    
    func downloadStations() {
        guard let url = URL(string: "https://api.gios.gov.pl/pjp-api/rest/station/findAll") else { return }
        
        NetworkManager.download(url: url)
            .decode(type: [Station].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] returnedStations in
                self?.allStations = returnedStations
            })
            .store(in: &cancelables)
    }

    func updateRegion(currentStation: Station) {
        region.center = CLLocationCoordinate2D(latitude: Double(currentStation.gegrLat) ?? region.center.latitude, longitude: Double(currentStation.gegrLon) ?? region.center.longitude)
        
        self.currentStation = currentStation
    }
}
