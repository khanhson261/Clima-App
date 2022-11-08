//
//  WeatherManager.swift
//  Clima
//
//  Created by Tran Son on 6/19/22.
// 
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate: AnyObject {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(_ weatherManager: WeatherManager, error: Error)
}

struct WeatherManager {
    let URLs = "https://api.openweathermap.org/data/2.5/weather?appid=80ad5f54ace66bdab3756c387c884656&units=metric"
    var delegate: WeatherManagerDelegate?
    func fetchWeatherData(_ cityName: String) {
        let cityURL = "\(URLs)&q=\(cityName)"
        performRequest(cityURL)
    }
    func fetchWeatherData(_ lat: CLLocationDegrees, _ lon: CLLocationDegrees) {
        let latitude = String(lat)
        let longtitude = String(lon)
        let cityURL = "\(URLs)&lat=\(latitude)&lon=\(longtitude)"
        performRequest(cityURL)
    }
    func performRequest(_ URLString: String) {
        if let url = URL(string: URLString) {
            let section = URLSession(configuration: .default)
            let task = section.dataTask(with: url) { data, _, error in
                if error != nil {
                    delegate?.didFailWithError(self, error: error!)
                    return
                } else {
                    if let safeData = data {
                        let dataString = String(data: safeData, encoding: .utf8)
                        if let safeData = dataString {
                            if let safeWeatherModel = parseJSON(safeData) {
                                self.delegate?.didUpdateWeather(self, weather: safeWeatherModel)
                        }
                    }
                }
            }
            }
            task.resume()
        }
    }
    func parseJSON(_ data: String) -> WeatherModel? {
        let decoder = JSONDecoder()
        let JSONData = data.data(using: .utf8)!
            do {
                let dataDecode =  try decoder.decode(WeatherData.self, from: JSONData)
                let name = dataDecode.name
                let id = dataDecode.weather[0].id
                let temp = dataDecode.main.temp
                let weather = WeatherModel(cityName: name, id: id, temp: temp)
                return weather
            } catch {
                delegate?.didFailWithError(self, error: error)
                return nil
            }
    }
}
