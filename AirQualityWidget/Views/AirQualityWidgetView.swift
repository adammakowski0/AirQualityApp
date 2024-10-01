//
//  AirQualityWidgetSmallView.swift
//  AirQualityWidgetExtension
//
//  Created by Adam Makowski on 25/09/2024.
//

import Foundation
import SwiftUI
import WidgetKit
import Charts

struct AirQualityWidgetView : View {
    
    @Environment(\.widgetFamily) var widgetFamily
    
    var entry: Provider.Entry
    
    var widgetVM = WidgetViewModel()
    
    var body: some View {
        
        switch widgetFamily {
        case .systemSmall:
            VStack {
                HStack(spacing: 5) {
                    Image(systemName: "location.fill")
                    
                    Text("\(entry.configuration.station?.stationName ?? "")")
                        .fontDesign(.rounded)
                }
                .font(.system(size: 10))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.top, .horizontal], 10)
                .padding(.bottom, 5)
                .background(.gray.opacity(0.1).gradient)
                
                Spacer()
                
                Text("Wskaźnik jakości powietrza:")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .fontDesign(.rounded)
                let airIndex = entry.airQuality?.stIndexLevel.indexLevelName ?? "Brak danych"
                Text(airIndex)
                    .foregroundStyle(widgetVM.getColor(forAirQuality: airIndex))
                    .font(.title)
                    .fontWeight(.heavy)
                    .fontDesign(.rounded)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(.gray.opacity(0.2).gradient)
            
        case .systemMedium:
            let airIndex = entry.airQuality?.stIndexLevel.indexLevelName ?? "Brak danych"
            let sensorData = entry.configuration.sensor
            VStack{
                HStack {
                    Image(systemName: "location.fill")
                    
                    Text("\(entry.configuration.station?.stationName ?? "")")
                        .fontDesign(.rounded)
                }
                .font(.system(size: 10))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.top, .horizontal], 10)
                .padding(.bottom, 5)
                .background(.gray.opacity(0.1).gradient)
                
                GeometryReader { proxy in
                    HStack{
                        VStack(spacing: 10) {
                            Text("Wskaźnik jakości powietrza:")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .fontDesign(.rounded)
                            Text(airIndex)
                                .foregroundStyle(widgetVM.getColor(forAirQuality: airIndex))
                                .font(.title)
                                .fontWeight(.heavy)
                                .fontDesign(.rounded)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: proxy.size.width/2, maxHeight: proxy.size.height, alignment: .top)
                        VStack{
                            if let data = entry.sensorData{
                                if let value = data.values.first{
                                    Text("\(sensorData?.param.paramName.capitalized ?? "")")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .multilineTextAlignment(.center)
                                        .fontDesign(.rounded)
                                    if let sensorValue = value.value{
                                        Text("\(sensorValue, specifier: "%.2f") μg/m3")
                                            .font(.caption2)
                                            .fontWeight(.medium)
                                            .multilineTextAlignment(.center)
                                            .fontDesign(.rounded)
                                    }
                                    else{
                                        Text("Brak aktualnych danych")
                                            .font(.system(size: 10))
                                            .fontWeight(.medium)
                                            .multilineTextAlignment(.center)
                                            .fontDesign(.rounded)
                                    }
                                }
                            }
                            Chart {
                                if let data = entry.sensorData {
                                    ForEach(data.values.reversed()) { value in
                                        if let chartValue = value.value{
                                            LineMark(
                                                x: .value("Date", value.date),
                                                y: .value("Value", chartValue))
                                            .interpolationMethod(.catmullRom)
                                            .foregroundStyle(widgetVM.getColor(forAirQuality: airIndex))
                                            
                                            AreaMark(
                                                x: .value("Date", value.date),
                                                y: .value("Value", chartValue))
                                            .interpolationMethod(.catmullRom)
                                            .foregroundStyle(widgetVM.getColor(forAirQuality: airIndex).opacity(0.2).gradient)
                                        }
                                    }
                                }
                            }
                            .chartYAxis(.hidden)
                            .chartXAxis(.hidden)
                            .padding([.horizontal, .bottom], 10)

                        }
                    }
                }
            }
            .background(.gray.opacity(0.2).gradient)
            
        default:
            Text("Brak danych")
                .foregroundStyle(.gray)
                .font(.title2)
                .fontWeight(.heavy)
                .fontDesign(.rounded)
        }
    }
}

#Preview(as: .systemMedium) {
    AirQualityWidget()
} timeline: {
    AirQualityEntry(date: .now, configuration: SelectStationIntent(), airQuality: nil, sensorData: nil)
}
