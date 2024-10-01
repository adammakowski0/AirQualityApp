//
//  SensorDataChatr.swift
//  AirQuality
//
//  Created by Adam Makowski on 18/09/2024.
//

import SwiftUI
import Charts

struct SensorDataChart: View {
    
    @StateObject var vm: SensorDataViewModel
    
    var sensor: Sensor
    
    init(sensor: Sensor) {
        _vm = StateObject(wrappedValue: SensorDataViewModel(sensorID: sensor.id))
        self.sensor = sensor
    }
    
    let axisDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    let axisTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        Chart {
            if let data = vm.sensorData {
                ForEach(data.values.reversed()) { value in
                    if let chartValue = value.value{
                        LineMark(
                            x: .value("Date", value.date),
                            y: .value("Value", chartValue))
                        .interpolationMethod(.catmullRom)
                        
                        AreaMark(
                            x: .value("Date", value.date),
                            y: .value("Value", chartValue))
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(.blue.opacity(0.15).gradient)
                    }
                }
            }
        }
        .aspectRatio(1.5, contentMode: .fit)
        .chartXAxis {
            AxisMarks() { value in
                if value.index == value.count/6 ||
                    value.index == 2*value.count/6 ||
                    value.index == 3*value.count/6 ||
                    value.index == 4*value.count/6 ||
                    value.index == 5*value.count/6 {
                    
                    if let valueDate = value.as(String.self) {
                        let date = vm.stringToDate(dateString: valueDate) ?? Date()
                        let formatedDate = axisDateFormatter.string(from: date)
                        let formatedTime = axisTimeFormatter.string(from: date)
                        AxisValueLabel {
                            VStack {
                                Text("\(formatedDate)")
                                    .bold()
                                Text("\(formatedTime)")
                            }
                            .rotationEffect(Angle(degrees: -30))
                            .offset(y: 10)
                            .padding(.bottom)
                            
                        }
                        AxisGridLine(centered: true, stroke: StrokeStyle(lineWidth: 0.5)).foregroundStyle(.gray)
                    }
                }
            }
        }
    }
}

#Preview {
    SensorDataChart(sensor: Sensor(id: 644, stationId: 114, param: Param(paramName: "dwutlenek azotu", paramFormula: "NO2", paramCode: "NO2", idParam: 6)))
}
