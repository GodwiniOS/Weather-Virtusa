//
//  WeatherViewModel.swift
//  Weather-Virtusa
//
//  Created by Godwin A on 20/03/2023.
//

import Foundation


protocol WeatherViewModelDelegate:AnyObject{
    
    func responseAPIRequest(error: String?,deatails: WeatherResponse?,
                            type: WeatherViewModel.APIRequestType)
    func responseCurrentWeatherData(error: String?,
                                    deatails: WeatherCoodResponse?)

}

class WeatherViewModel {
    
    enum APIRequestType {
        case DefaultWeather
        case LastSearchCity
        case WeatherData
    }
    
    let interactor = APIInteractor()
    weak var delegate: WeatherViewModelDelegate?
    
    func fetchLastSearchCity() {
        
        if let manager = interactor.weatherManager,
            let currCitySaved = manager.lastSearchCity {
            if currCitySaved != "" {
//                errorLabel.alpha = 0
//                spinnerView.startAnimating()
                interactor.handleFetchWeatherLastCity { cityData, error  in
                    if let error = error {
//
                        // Change label in the main thread
//                        DispatchQueue.main.async {
//                            self.spinnerView.stopAnimating()
//                            self.errorLabel.alpha = 1
//                            self.searchBar.alpha = 1
//                            self.searchAgainButton.alpha = 1
//                            self.errorLabel.text =
                            
                            let errorDetil = error.localizedDescription.description
                        self.delegate?.responseAPIRequest(error: errorDetil, deatails: nil,type: .LastSearchCity)
                    } else {
                        self.delegate?.responseAPIRequest(error: nil, deatails: cityData,type: .LastSearchCity)

                    }
                }
            }
        }
    }
    
    func fetchDefaultWeather() {
        
        let defaultCity = "Miami"
        if let manager = interactor.weatherManager,
           let currCitySaved = manager.lastSearchCity {
            // if currCitySaved != "" -> this is the first time load with denied
            // if currCitySaved != "" && currCitySaved == defaultCity -> User already searched
            // a city but denied sharing location with us
            if currCitySaved == "" || (currCitySaved != "" && currCitySaved == defaultCity) {
//                self.errorLabel.alpha = 0
//                self.searchAgainButton.alpha = 1
//                self.spinnerView.startAnimating()
                interactor.handleFetchWeatherByCity(defaultCity) { cityData, error  in
                    if let error = error {
                        // Change label in the main thread
                        let errorDetails = error.localizedDescription.description
                        self.delegate?.responseAPIRequest(error: errorDetails, deatails: nil,type: .DefaultWeather)
                    } else {
                        self.delegate?.responseAPIRequest(error: nil, deatails: newCityData,type: .DefaultWeather)
                    }
                }
            }
        }
    }
    
    func fetchCurrentWeatherData(_ long: Double, _ lat: Double) {
        
//        if let vm = self.viewModel {
//            self.errorLabel.alpha = 0
//            self.searchAgainButton.alpha = 1
//            self.spinnerView.startAnimating()
            interactor.handleFetchWeatherInCurrentLocation(long, lat) { cityData, error  in

                if let error = error {
                    let errorDetails = error.localizedDescription.description
                    self.delegate?.responseCurrentWeatherData(error: errorDetails, deatails: nil)
                } else {
                    self.delegate?.responseCurrentWeatherData(error: nil, deatails: cityData)

                }
            }
    }

    
    func fetchWeatherData(searchText: String) {

        if searchText != "" {
//                self.errorLabel.alpha = 0
//                self.searchAgainButton.alpha = 1
//                self.spinnerView.startAnimating()
                interactor.handleFetchWeatherByCity(searchText) { cityData, error  in
                    if let error = error {
                       let errorDetails = error.localizedDescription.description
                        self.delegate?.responseAPIRequest(error: errorDetails, deatails: nil,type: .WeatherData)

                    } else {
                        self.delegate?.responseAPIRequest(error: nil, deatails: cityData,type: .WeatherData)
                    }
                }
            }
    }
}
