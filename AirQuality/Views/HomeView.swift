//
//  ContentView.swift
//  AirQuality
//
//  Created by Adam Makowski on 17/09/2024.
//

import SwiftUI
import MapKit


struct HomeView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    
    @AppStorage("isFirstTime") private var isNewUser: Bool = true
    
    @State var showNewUserView: Bool = false
    
    var body: some View {
        ZStack {
            mapView
                .overlay(alignment: .bottom) {
                    if let station = vm.currentStation {
                        StationInfoView(station: station)
                        
                    }
                    else {
                        selectStationView
                    }
                }
                .ignoresSafeArea()
                .sheet(item: $vm.showStationDetails) { station in
                    StationDetailView(station: station)
                        .presentationDetents([.fraction(0.99)])
                        .presentationBackground(.thinMaterial)
                        .presentationCornerRadius(30)
                }
            
            if showNewUserView {
                newUserView
            }
        }
        .onAppear{
            if isNewUser {
                withAnimation(.easeInOut.delay(0.5)) {
                    showNewUserView = true
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(HomeViewModel())
}

extension HomeView {
    
    private var mapView: some View {
        Map(coordinateRegion: $vm.region, annotationItems: vm.allStations)
        { station in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: Double(station.gegrLat)!, longitude: Double(station.gegrLon)!)) {
                Image(systemName: "location.fill")
                    .padding(6)
                    .background()
                    .clipShape(Circle())
                    .shadow(radius: 10)
                    .scaleEffect(x: annotationScale ? 0.6 : 1.0,
                                 y: annotationScale ? 0.6 : 1.0)
                    .scaleEffect(x: vm.currentStation == station ? 1.0 : 0.8,
                                 y: vm.currentStation == station ? 1.0 : 0.8)
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            vm.updateRegion(currentStation: station)
                        }
                    }
            }
        }
    }
    
    private var annotationScale: Bool {
        if vm.region.span.latitudeDelta > 2.0 {
            return true
        }
        return false
    }
    
    private var selectStationView: some View {
        VStack {
            Text("Wybierz stację pomiarową")
                .font(.headline)
                .fontWeight(.bold)
            Text("Kliknij w jedną z lokalizacji na mapie")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.thinMaterial)
        .cornerRadius(15)
        .padding()
        .padding(.bottom)
    }
    
    private var newUserView: some View {
        VStack{
            Text("Aplikacja do sprawdzania jakości powietrza")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()
            
            apiInfoView
            
            Spacer()
            
            Button {
                withAnimation {
                    showNewUserView = false
                    isNewUser = false
                }
            } label: {
                Text("Kontynuuj")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.thinMaterial)
                    .cornerRadius(15)
                    .padding(.horizontal)
                    .shadow(radius: 10)
            }
            
        }
        .transition(.asymmetric(
            insertion: .move(edge: .bottom),
            removal: .move(edge: .top)))
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .background(.ultraThinMaterial.opacity(0.7))
    }
    
    private var apiInfoView: some View {
        VStack{
            HStack{
                Image(systemName: "icloud.and.arrow.up.fill")
                    .font(.largeTitle)
                    .padding(.leading, 40)
                    .frame(width: 45)
                
                Text("Dane pozyskane są z serwisu Głównego Inspektoratu Ochrony Środowiska GIOŚ")
                    .fontWeight(.semibold)
                    .padding()
                    .padding(.horizontal)
            }
            Divider()
            if let url = URL(string: "https://powietrze.gios.gov.pl/pjp/content/api") {
                Link("Więcej informacji", destination: url)
                    .font(.callout)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 10)
                    .padding(.bottom, 5)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.regularMaterial)
                .padding(.horizontal, 10)
                .shadow(radius: 10)
        )
    }
}
