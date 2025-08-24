//
//  SwiftUIView.swift
//  AirQuality
//
//  Created by Adam Makowski on 24/08/2025.
//

import SwiftUI
import MapKit

struct MapMarkerView: View {
    
    @StateObject var vm: StationDetailViewModel
    
    var station: Station
    
    init(station: Station) {
        _vm = StateObject(wrappedValue: StationDetailViewModel(station: station))
        self.station = station
    }
    
    var body: some View {
        Image(systemName: "location.fill")
            .foregroundStyle(vm.getColor(forAirQuality: "\(vm.airQualityIndex?.indexLevelName ?? "Brak danych")"))
            .padding(6)
            .background()
            .clipShape(Circle())
            .shadow(radius: 10)
    }

}

#Preview {
    MapMarkerView(station: Station(id: 52, code: "", stationName: "", gegrLat: "", gegrLon: "", cityId: 1, cityName: "", commune: "", district: "", voivodeship: "", street: ""))
}
