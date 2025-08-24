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
        
        let airIndex = entry.airQualityResponse?.AirQualityIndex.indexLevelName ?? "Brak danych"
        let sensorData = entry.configuration.sensor
        
        switch widgetFamily {
            
        case .systemSmall:
            smallWidgetView(airIndex: airIndex)
            
        case .systemMedium:
            mediumWidgetView(airIndex: airIndex, sensorData: sensorData)
            
        default:
            Text("Brak danych")
                .foregroundStyle(.gray)
                .font(.title2)
                .fontWeight(.heavy)
                .fontDesign(.rounded)
        }
    }
}

extension AirQualityWidgetView {
    private func smallWidgetView(airIndex: String) -> some View {
        VStack {
            widgetHeaderView

            airQualityInfoView(airIndex: airIndex)
                .padding([.top, .horizontal], 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(.gray.opacity(0.2).gradient)
    }
    
    private func mediumWidgetView(airIndex: String, sensorData: SensorDetail?) -> some View {
        VStack{
            widgetHeaderView
            
            GeometryReader { proxy in
                HStack{
                    airQualityInfoView(airIndex: airIndex)
                    .frame(maxWidth: proxy.size.width/2, maxHeight: proxy.size.height, alignment: .top)
                    sensorInfoView(airIndex: airIndex, sensorData: sensorData)
                }
                .padding(.horizontal, 10)
            }
        }
        .background(.gray.opacity(0.2).gradient)
    }
    
    private var widgetHeaderView: some View {
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
    }

    
    private func airQualityInfoView(airIndex: String) -> some View {
        VStack(spacing: 15) {
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
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
    }
    
    private func sensorInfoView(airIndex: String, sensorData: SensorDetail?) -> some View {
        VStack{
            if let data = entry.sensorDataResponse?.sensorData.first{
                Text("\(sensorData?.paramName.capitalized ?? "")")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .fontDesign(.rounded)
                if let value = data.value{
                    Text("\(value, specifier: "%.2f") μg/m3")
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
            widgetChartView(airIndex: airIndex)
                .padding(.bottom, 10)
        }
    }
    
    private func widgetChartView(airIndex: String) -> some View {
        Chart {
            if let data = entry.sensorDataResponse {
                ForEach(data.sensorData.reversed()) { value in
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
    }
    
}


#Preview(as: .systemMedium) {
    AirQualityWidget()
} timeline: {
    AirQualityEntry(date: .now, configuration: SelectStationIntent(), airQualityResponse: nil, sensorDataResponse: nil)
}
