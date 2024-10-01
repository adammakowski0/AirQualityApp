//
//  StationDetailView.swift
//  AirQuality
//
//  Created by Adam Makowski on 17/09/2024.
//

import SwiftUI
import MapKit

struct StationDetailView: View {
    
    @StateObject var vm: StationDetailViewModel
    
    var station: Station
    
    init(station: Station) {
        _vm = StateObject(wrappedValue: StationDetailViewModel(station: station))
        self.station = station
    }
    
    var body: some View {
        
        headerView
        ScrollView{
            sensorsDataView
            
            airQualityView
            
            mapView
        }
    }
}

extension StationDetailView {
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(station.stationName)
                    .font(.title)
                    .fontWeight(.bold)
                Text(station.city.name)
                Text(station.city.commune.provinceName)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                Divider()
            }
            Button {
                vm.addToFavourites()
                
            } label: {
                Image(systemName: "star.fill")
                    .tint(vm.isFavourite ? .yellow : .primary)
                    .padding(10)
                    .background()
                    .clipShape(Circle())
                    .shadow(radius: 10)
                    .padding([.bottom, .trailing])
            }
        }
        .padding(.horizontal)
        .padding(.top)
    }
    
    private var sensorsDataView: some View {
        
        VStack {
            Text("Dane z sensorów")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            Text("Kliknij na dane, aby zobaczyć wykres")
                .font(.callout)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
                .padding(.bottom,5)
            ForEach(vm.sensors) { sensor in
                SensorDataRowView(sensor: sensor)
            }
            Divider()
        }
    }
    
    private var airQualityView: some View {
        VStack {
            Text("Wskaźnik jakości powietrza")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
                .padding(.bottom, 5)
            
            Text("\(vm.airQualityIndex?.stIndexLevel.indexLevelName ?? "Brak danych")")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(vm.getColor(forAirQuality: "\(vm.airQualityIndex?.stIndexLevel.indexLevelName ?? "Brak danych")"))
            
            Divider()
        }
    }
    
    private var mapView: some View {
        Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: Double(station.gegrLat) ?? 0, longitude: Double(station.gegrLon) ?? 0), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))), annotationItems: [station]) { station in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: Double(station.gegrLat)!, longitude: Double(station.gegrLon)!)) {
                Image(systemName: "location.fill")
                    .padding(6)
                    .background()
                    .clipShape(Circle())
                    .shadow(radius: 10)
            }
        }
        .allowsHitTesting(false)
        .aspectRatio(1, contentMode: .fit)
        .cornerRadius(25)
    }
}

#Preview {
    let station = Station(id: 114, stationName: "Wrocław, ul. Bartnicza", gegrLat: "51.115933", gegrLon: "17.141125", city: City(id: 100, name: "Wrocław", commune: Commune(communeName: "TEST", districtName: "Testttsts", provinceName: "MAZOWIECKIE")))
    StationDetailView(station: station)
        .environmentObject(StationDetailViewModel(station: station))
}
