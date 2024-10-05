//
//  FavouritesView.swift
//  AirQuality
//
//  Created by Adam Makowski on 05/10/2024.
//

import SwiftUI

struct FavouritesView: View {
    
    @EnvironmentObject var vm: HomeViewModel
    
    var body: some View {
        VStack{
            HStack {
                Button {
                    withAnimation {
                        vm.showFavourites = false
                        
                    }
                } label: {
                    Image(systemName: "xmark")
                        .tint(.primary)
                        .fontWeight(.semibold)
                        .padding()
                        .background()
                        .clipShape(Circle())
                        .shadow(radius: 5)
                    
                }
                .padding()
                Text("Ulubione stacje")
                    .font(.title)
                    .fontWeight(.heavy)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            if vm.savedEntities.isEmpty {
                Text("Brak ulubionych stacji")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            else{
                ScrollView{
                    ForEach(vm.savedEntities) { entity in
                        VStack {
                            Text(entity.stationName ?? "")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background()
                                .cornerRadius(10)
                                .onTapGesture {
                                    for station in vm.allStations {
                                        if station.stationName == entity.stationName {
                                            withAnimation {
                                                vm.updateRegion(currentStation: station)
                                                vm.showFavourites = false
                                            }
                                        }
                                    }
                                }
                        }
                        .padding(.horizontal)
                        
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(.thinMaterial)
    }
}

#Preview {
    FavouritesView()
        .environmentObject(HomeViewModel())
}
