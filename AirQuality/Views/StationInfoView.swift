//
//  StationInfoView.swift
//  AirQuality
//
//  Created by Adam Makowski on 17/09/2024.
//

import SwiftUI

struct StationInfoView: View {
    
    @EnvironmentObject var vm: HomeViewModel
    
    var station: Station
    
    var body: some View {
        HStack {
            stationNameView
            
            Spacer()
            
            detailsButton
        }
        .padding()
        .background(.thinMaterial)
        .cornerRadius(15)
        .padding()
        .padding(.bottom)
    }
}

extension StationInfoView {
    private var stationNameView: some View {
        HStack {
            if station.isFavourite ?? false {
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
            }
            
            Text(station.stationName)
                .font(.headline)
                .fontWeight(.bold)
                .padding(station.isFavourite ?? false ? [] : .leading)
        }
    }
    
    private var detailsButton: some View {
        Button {
            vm.showStationDetails = station
        } label: {
            Text("Szczegóły")
                .foregroundStyle(.white)
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
        }
    }
}

#Preview {
    StationInfoView(station: Station(id: 114, stationName: "Wrocław, ul. Bartnicza", gegrLat: "51.115933", gegrLon: "17.141125", city: City(id: 100, name: "Wrocław", commune: Commune(communeName: "TEST", districtName: "aaaaa", provinceName: "Mazowieckie")), isFavourite: true))
        .environmentObject(HomeViewModel())
}
