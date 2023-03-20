//
//  APIInteractor.swift
//  Weather-Virtusa
//
//  Created by Anto Jero on 21/03/2023.
//

import Foundation


class APIInteractor {
    
    let weatherManager:WeatherManager?
    
    init() {
        weatherManager = WeatherManager.shared
    }
    
    
    
    // MARK: - Handle Current Location
    func handleFetchWeatherInCurrentLocation(_ long:Double, _ lat:Double ,completion: @escaping (WeatherCoodResponse?, Error?) -> Void){
        if let manager = self.weatherManager {
            manager.fetchWeatherData(latitude: lat, longitude: long) { result in
            switch result {
            case .success(let weatherData):
                completion(weatherData, nil)
            case .failure(let error):
                completion(nil, error)
             }
          }
       }
    }
    
    // MARK: - Handle fetch last city
    func handleFetchWeatherLastCity(completion: @escaping (WeatherResponse?, Error?) -> Void) {
        if let manager = self.weatherManager, let city = manager.lastSearchCity {
            manager.fetchWeatherData(forCity: city) { result in
                switch result {
                case .success(let data):
                    // Handle the weather data
                    completion(data, nil)
                case .failure(let error):
                    // Handle the error
                    completion(nil, error)
                }
            }
        }
    }
    
    // MARK: - Handle fetch call
    func handleFetchWeatherByCity(_ city: String, completion: @escaping (WeatherResponse?, Error?) -> Void) {
        if let manager = self.weatherManager {
            manager.fetchWeatherData(forCity: city) { result in
                switch result {
                case .success(let data):
                    // Handle the weather data
                    if let searchCity = data.name {
                        // Store searchCity in UserDefaults
                        manager.setLastSearchCity(searchCity)
                    }
                    completion(data, nil)
                case .failure(let error):
                    // Handle the error
                    completion(nil, error)
                }
            }
        }
    }
}
