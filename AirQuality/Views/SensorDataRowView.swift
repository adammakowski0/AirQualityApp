//
//  SensorDataView.swift
//  AirQuality
//
//  Created by Adam Makowski on 18/09/2024.
//

import SwiftUI
import Charts

struct SensorDataRowView: View {
    
    @StateObject var vm: SensorDataViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    var sensor: Sensor
    
    init(sensor: Sensor) {
        _vm = StateObject(wrappedValue: SensorDataViewModel(sensorID: sensor.id))
        self.sensor = sensor
    }
    
    @State var showChart: Bool = false
    
    var body: some View {
        Divider()
        HStack {
            VStack (alignment: .leading){
                Text("\(sensor.paramName)".capitalized)
                Text("\(sensor.paramCode)")
                    .font(.caption)
                    .bold()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.black.opacity(0.0000001))
            
            if let data = vm.sensorData,
               
               let value = data.first?.value {
                Text("\(value, specifier: "%.2f") μg/m3")
            }
            else{
                Text("Brak aktualnych danych")
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
        .onTapGesture {
            withAnimation(.default) {
                showChart.toggle()
            }
        }
        if showChart{
            SensorDataChart(sensor: sensor)
                .padding(5)
        }
    }
}

#Preview {
    SensorDataRowView(sensor: Sensor(id: 644, stationId: 114, paramName: "dwutlenek azotu", paramFormula: "NO2", paramCode: "NO2", idParam: 6))
}
