//
//  SensorDataViewModel.swift
//  AirQuality
//
//  Created by Adam Makowski on 18/09/2024.
//

import Foundation
import Combine

class SensorDataViewModel: ObservableObject {
    
    @Published var sensorData: [SensorData]?
    
    var cancelables = Set<AnyCancellable>()
    
    init(sensorID: Int) {
        downloadSensorData(sensorID: sensorID)
    }

    func downloadSensorData(sensorID: Int) {
        
        guard let url = URL(string: "https://api.gios.gov.pl/pjp-api/v1/rest/data/getData/\(sensorID)?size=500") else { return }
        NetworkManager.download(url: url)
            .decode(type: SensorDataResponse.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] returnedData in
                self?.sensorData = returnedData.sensorData
            })
            .store(in: &cancelables)
    }

    func stringToDate(dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from: dateString)
    }
}
