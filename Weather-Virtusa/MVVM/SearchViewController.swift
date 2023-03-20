//
//  ViewController.swift
//  Weather-Virtusa
//
//  Created by Godwin A on 20/03/2023.
//

import UIKit
import CoreLocation

class SearchViewController: UIViewController {
    
    // MARK: - variables
    var viewModel:SearchViewModel?
    private let locationManager = CLLocationManager()
    var hasAuthorized:Bool?
    var hasStartedUpdatingLocation = false
    
    // MARK: - Initialization
    init(_ vm: SearchViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = vm
        self.initializeUI()
        
    }
    
    func initializeUI() {
        self.view.backgroundColor = .white
        self.setupSearchBar()
        self.view.addSubview(spinnerView)
        self.view.addSubview(errorLabel)
        self.view.addSubview(cityNameLabel)
        self.view.addSubview(temperatureLabel)
        self.view.addSubview(descritionLabel)
        self.view.addSubview(highTempLabel)
        self.view.addSubview(lowTempLabel)
        self.view.addSubview(cloudCoverLabel)
        self.view.addSubview(coordLabel)
        self.view.addSubview(longLabel)
        self.view.addSubview(latLabel)
        self.view.addSubview(searchAgainButton)
        self.spinnerView.addSubview(spinnerViewLabel)
        self.errorLabel.alpha = 0
        self.searchAgainButton.alpha = 0
        self.errorLabel.text = ""
        self.hideLabels()
        
        errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        spinnerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinnerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        spinnerView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        spinnerView.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        
        
        cityNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cityNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55).isActive = true
        
        temperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        temperatureLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: 35).isActive = true
        
        descritionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descritionLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 25).isActive = true
        descritionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        descritionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        highTempLabel.topAnchor.constraint(equalTo: descritionLabel.bottomAnchor, constant: 25).isActive = true
        highTempLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 225).isActive = true
        
        lowTempLabel.topAnchor.constraint(equalTo: descritionLabel.bottomAnchor, constant: 25).isActive = true
        lowTempLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 125).isActive = true
        
        cloudCoverLabel.topAnchor.constraint(equalTo: lowTempLabel.bottomAnchor, constant: 25).isActive = true
        cloudCoverLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        coordLabel.topAnchor.constraint(equalTo: cloudCoverLabel.bottomAnchor, constant: 25).isActive = true
        coordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        longLabel.topAnchor.constraint(equalTo: coordLabel.bottomAnchor, constant: 25).isActive = true
        longLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 225).isActive = true
        
        latLabel.topAnchor.constraint(equalTo: coordLabel.bottomAnchor, constant: 25).isActive = true
        latLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100).isActive = true
        
        searchAgainButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchAgainButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        searchAgainButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        searchAgainButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        searchAgainButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setupSearchBar() {
       searchBar.delegate = self // Set the delegate for the search bar
       
       self.view.addSubview(searchBar) // Add the search bar to the view hierarchy
       
       // Set up Auto Layout constraints
       NSLayoutConstraint.activate([
           searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
           searchBar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
           searchBar.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
       ])
   }
    
    // MARK: - De-initialization
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life-cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.distanceFilter = 500
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        if let sharing = UserDefaults.standard.value(forKey: "sharingLocation") as? Bool {
            self.hasAuthorized = sharing
            if sharing {
                if !hasStartedUpdatingLocation {
                    locationManager.startUpdatingLocation()
                    hasStartedUpdatingLocation = true
                }
            } else {
                self.fetchLastSearchCity()
            }
        } else {
          
            locationManager.requestAlwaysAuthorization()
        }
    }

    
    // MARK: - UI Components
    var cityNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        return label
    }()
    
    var temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 32, weight: .thin)
        return label
    }()
    
    var descritionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    var highTempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    var lowTempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    var cloudCoverLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    var coordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Coordinates"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    var longLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    var latLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search"
        if let searchTextField = searchBar.value(forKey: "searchField") as? UITextField {
            let borderImage = UIImage() // Create an empty UIImage
            searchTextField.borderStyle = .none // Remove the border
            searchTextField.background = borderImage // Set the background image to the empty UIImage
        }
        return searchBar
    }()
    
    var errorLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        lb.textColor = UIColor.systemRed.withAlphaComponent(0.7)
        lb.numberOfLines = 0
        lb.textAlignment = .center
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    var spinnerViewLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 20, y:55, width: 100, height: 30))
        label.text = "Searching"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    var spinnerView: UIActivityIndicatorView = {
       let atv = UIActivityIndicatorView()
        atv.translatesAutoresizingMaskIntoConstraints = false
        atv.backgroundColor = .systemTeal.withAlphaComponent(0.7)
        atv.tintColor = .white
        atv.layer.cornerRadius  = 10
       return atv
    }()
    
    var searchAgainButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.5)
        let attributedTitle = NSAttributedString(string: "Search Again", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor(red: 255, green: 255, blue: 255, alpha: 100)])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.isEnabled = true
        button.addTarget(SearchViewController.self, action: #selector(searchAgainButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Action
    
    @objc private func searchButtonTapped() {
        searchBar.resignFirstResponder() // Dismiss the keyboard
        self.fetchWeatherData()
    }
    
    @objc private func searchAgainButtonTapped() {
        searchBar.resignFirstResponder() // Dismiss the keyboard
        self.searchBar.alpha = 1
        self.searchAgainButton.alpha = 0
        self.hideLabels()
    }
    
    // MARK: - Business Logic
    
    func kelvinToFahrenheit(kelvin: Double) -> Double {
        let fahrenheit = (kelvin - 273.15) * 9 / 5 + 32
        return (fahrenheit * 100).rounded() / 100
    }
    
    func showLabels() {
        self.cityNameLabel.alpha = 1
        self.temperatureLabel.alpha = 1
        self.descritionLabel.alpha = 1
        self.highTempLabel.alpha = 1
        self.lowTempLabel.alpha = 1
        self.cloudCoverLabel.alpha = 1
        self.coordLabel.alpha = 1
        self.longLabel.alpha = 1
        self.latLabel.alpha = 1
    }
    
    func hideLabels() {
        self.cityNameLabel.alpha = 0
        self.temperatureLabel.alpha = 0
        self.descritionLabel.alpha = 0
        self.highTempLabel.alpha = 0
        self.lowTempLabel.alpha = 0
        self.cloudCoverLabel.alpha = 0
        self.coordLabel.alpha = 0
        self.longLabel.alpha = 0
        self.latLabel.alpha = 0
    }
    
    func fetchLastSearchCity() {
        if let vm = self.viewModel, let manager = vm.weatherManager, let currCitySaved = manager.lastSearchCity {
            if currCitySaved != "" {
                self.errorLabel.alpha = 0
                
                self.spinnerView.startAnimating()
                vm.handleFetchWeatherLastCity { cityData, error  in
                    if let error = error {
                        // Change label in the main thread
                        DispatchQueue.main.async {
                            self.spinnerView.stopAnimating()
                            self.errorLabel.alpha = 1
                            self.searchBar.alpha = 1
                            self.searchAgainButton.alpha = 1
                            self.errorLabel.text = error.localizedDescription.description
                        }
                    } else {
                        DispatchQueue.main.async {
                            // display data
                            if let newCityData = cityData, let main = newCityData.main, let weather = newCityData.weather, let clouds = newCityData.clouds, let coord = newCityData.coord {
                                self.spinnerView.stopAnimating()
                                self.searchAgainButton.alpha = 1
                                self.searchBar.alpha = 0
                                self.showLabels()
                                self.cityNameLabel.text = newCityData.name
                                self.temperatureLabel.text = "\(String(describing: self.kelvinToFahrenheit(kelvin: main.temp))) F"
                                self.descritionLabel.text = weather[0].description
                                self.highTempLabel.text = "H:\(String(describing: self.kelvinToFahrenheit(kelvin: main.temp_max)))"
                                self.lowTempLabel.text = "L:\(String(describing: self.kelvinToFahrenheit(kelvin: main.temp_min)))"
                                self.cloudCoverLabel.text = "Cloud cover is \(String(describing: clouds.all))%"
                                self.longLabel.text = "Lon:\(String(describing: coord.lon))"
                                self.latLabel.text = "Lat:\(String(describing: coord.lat))"
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    func fetchDefaultWeather() {
        let defaultCity = "Miami"
        if let vm = self.viewModel, let manager = vm.weatherManager, let currCitySaved = manager.lastSearchCity {
            // if currCitySaved != "" -> this is the first time load with denied
            // if currCitySaved != "" && currCitySaved == defaultCity -> User already searched
            // a city but denied sharing location with us
            if currCitySaved == "" || (currCitySaved != "" && currCitySaved == defaultCity) {
                self.errorLabel.alpha = 0
                self.searchAgainButton.alpha = 1
                self.spinnerView.startAnimating()
                vm.handleFetchWeatherByCity(defaultCity) { cityData, error  in
                    if let error = error {
                        // Change label in the main thread
                        DispatchQueue.main.async {
                            self.spinnerView.stopAnimating()
                            self.errorLabel.alpha = 1
                            self.searchBar.alpha = 1
                            self.errorLabel.text = error.localizedDescription.description
                        }
                    } else {
                        DispatchQueue.main.async {
                            // display data
                            if let newCityData = cityData, let main = newCityData.main, let weather = newCityData.weather, let clouds = newCityData.clouds, let coord = newCityData.coord {
                                self.spinnerView.stopAnimating()
                                self.searchAgainButton.alpha = 1
                                self.searchBar.alpha = 0
                                self.showLabels()
                                self.cityNameLabel.text = newCityData.name
                                self.temperatureLabel.text = "\(String(describing: self.kelvinToFahrenheit(kelvin: main.temp))) F"
                                self.descritionLabel.text = weather[0].description
                                self.highTempLabel.text = "H:\(String(describing: self.kelvinToFahrenheit(kelvin: main.temp_max)))"
                                self.lowTempLabel.text = "L:\(String(describing: self.kelvinToFahrenheit(kelvin: main.temp_min)))"
                                self.cloudCoverLabel.text = "Cloud cover is \(String(describing: clouds.all))%"
                                self.longLabel.text = "Lon:\(String(describing: coord.lon))"
                                self.latLabel.text = "Lat:\(String(describing: coord.lat))"
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    func fetchCurrentWeatherData(_ long: Double, _ lat: Double) {
        if let vm = self.viewModel {
            self.errorLabel.alpha = 0
            self.searchAgainButton.alpha = 1
            self.spinnerView.startAnimating()
            vm.handleFetchWeatherInCurrentLocation(long, lat) { cityData, error  in
                if let error = error {
                    // Change label in the main thread
                    DispatchQueue.main.async {
                        self.spinnerView.stopAnimating()
                        self.errorLabel.alpha = 1
                        self.searchBar.alpha = 1
                        self.errorLabel.text = error.localizedDescription.description
                    }
                } else {
                    DispatchQueue.main.async {
                        // display data
                        if let newCityData = cityData {
                            let main = newCityData.main
                            let weather = newCityData.weather
                            let clouds = newCityData.clouds
                            let coord = newCityData.coord
                            self.spinnerView.stopAnimating()
                            self.searchAgainButton.alpha = 1
                            self.searchBar.alpha = 0
                            self.showLabels()
                            self.cityNameLabel.text = newCityData.name
                            self.temperatureLabel.text = "\(String(describing: self.kelvinToFahrenheit(kelvin: main.temp))) F"
                            self.descritionLabel.text = weather[0].description
                            self.highTempLabel.text = "H:\(String(describing: self.kelvinToFahrenheit(kelvin: main.tempMax)))"
                            self.lowTempLabel.text = "L:\(String(describing: self.kelvinToFahrenheit(kelvin: main.tempMin)))"
                            self.cloudCoverLabel.text = "Cloud cover is \(String(describing: clouds.all))%"
                            self.longLabel.text = "Lon:\(String(describing: coord.lon))"
                            self.latLabel.text = "Lat:\(String(describing: coord.lat))"
                            
                        }
                    }
                }
            }
        }
    }

    
    func fetchWeatherData() {
        if let searchText = self.searchBar.text, let vm = self.viewModel {
            if searchText != "" {
                self.errorLabel.alpha = 0
                self.searchAgainButton.alpha = 1
                self.spinnerView.startAnimating()
                vm.handleFetchWeatherByCity(searchText) { cityData, error  in
                    if let error = error {
                        // Change label in the main thread
                        DispatchQueue.main.async {
                            self.spinnerView.stopAnimating()
                            self.errorLabel.alpha = 1
                            self.searchBar.alpha = 1
                            self.errorLabel.text = error.localizedDescription.description
                        }
                    } else {
                        DispatchQueue.main.async {
                            // display data
                            if let newCityData = cityData, let main = newCityData.main, let weather = newCityData.weather, let clouds = newCityData.clouds, let coord = newCityData.coord {
                                self.spinnerView.stopAnimating()
                                self.searchAgainButton.alpha = 1
                                self.searchBar.alpha = 0
                                self.showLabels()
                                self.cityNameLabel.text = newCityData.name
                                self.temperatureLabel.text = "\(String(describing: self.kelvinToFahrenheit(kelvin: main.temp))) F"
                                self.descritionLabel.text = weather[0].description
                                self.highTempLabel.text = "H:\(String(describing: self.kelvinToFahrenheit(kelvin: main.temp_max)))"
                                self.lowTempLabel.text = "L:\(String(describing: self.kelvinToFahrenheit(kelvin: main.temp_min)))"
                                self.cloudCoverLabel.text = "Cloud cover is \(String(describing: clouds.all))%"
                                self.longLabel.text = "Lon:\(String(describing: coord.lon))"
                                self.latLabel.text = "Lat:\(String(describing: coord.lat))"
                                
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // Dismiss the keyboard
        // Perform search action here
        self.fetchWeatherData()
    }
}

// MARK: - CLLocationManagerDelegate
extension SearchViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            UserDefaults.standard.setValue(true, forKey: "sharingLocation")
            if !hasStartedUpdatingLocation {
                locationManager.startUpdatingLocation()
                hasStartedUpdatingLocation = true
            }
            return
        case .notDetermined, .restricted, .denied:
            // Handle cases where the app does not have the required permissions
            // Default to Miami
            UserDefaults.standard.setValue(false, forKey: "sharingLocation")
            self.fetchDefaultWeather()
            return
        @unknown default:
            // Handle any future cases that may be added to the CLAuthorizationStatus enumeration
            // Default to Miami
            UserDefaults.standard.setValue(false, forKey: "sharingLocation")
            self.fetchDefaultWeather()
            return
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.fetchCurrentWeatherData(location.coordinate.longitude, location.coordinate.latitude)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.errorLabel.alpha = 1
        // Allow user to research in case there is an error
        self.searchBar.alpha = 1
        self.hideLabels()
        
        if let clError = error as? CLError {
            switch clError.code {
            case .denied:
                self.errorLabel.text = "Location access denied. Please allow location access in Settings."
                self.fetchDefaultWeather()
            case .network:
                self.errorLabel.text = "Network error. Please check your internet connection."
            default:
                self.errorLabel.text = "Error determining location: \(error.localizedDescription)"
            }
        } else {
            self.errorLabel.text = "Error determining location: \(error.localizedDescription)"
        }
    }


}
