//
//  ViewController.swift
//  Clima
//
//  Created by Tran Son on 6/20/22.
//
//

import UIKit
import CoreLocation

final class WeatherViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherSearchField: UITextField!
    // MARK: - Properties
    var weaManager = WeatherManager()
    var locaManager = CLLocationManager()
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        locaManager.delegate = self
        locaManager.requestWhenInUseAuthorization()
        locaManager.requestLocation()
        weatherSearchField.delegate = self
        weaManager.delegate = self
        // Do any additional setup after loading the view.
    }
    // MARK: - IBActions
    @IBAction func getLocationButtonTapped(_ sender: Any) {
        locaManager.requestLocation()
    }
}
 // MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        if let cityName = weatherSearchField.text {
            weaManager.fetchWeatherData(cityName)
        }
        weatherSearchField.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let cityName = weatherSearchField.text {
            weaManager.fetchWeatherData(cityName)
        }
        weatherSearchField.endEditing(true)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if weatherSearchField.text == "" {
            weatherSearchField.placeholder = "Input the location!"
            return false
        } else {
            return true
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        weatherSearchField.text = ""
    }
}

// MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
       DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureStr
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.weatherCondition)
        }
    }
    func didFailWithError(_ weatherManager: WeatherManager, error: Error) {
        print(error)
    }
}
// MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locaManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weaManager.fetchWeatherData(lat, lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
