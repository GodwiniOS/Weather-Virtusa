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
    
    // MARK: - UI Components
    let cityNameLabel = UILabel()
    let temperatureLabel = UILabel()
    let descritionLabel = UILabel()
    let highTempLabel = UILabel()
    let lowTempLabel = UILabel()
    let cloudCoverLabel = UILabel()
    let coordLabel = UILabel()
    let longLabel = UILabel()
    var latLabel = UILabel()



    // MARK: - Initialization
    init(_ vm: SearchViewModel) {
        super.init(nibName: nil, bundle: nil)
        viewModel = vm
        initializeUI()
        
    }
    
    func initializeUI() {
        view.backgroundColor = .white
        setupSearchBar()

        errorLabel.alpha = 0
        searchAgainButton.alpha = 0
        errorLabel.text = ""
        changelabelsState(hide: true)
        
        
        view.addSubview(errorLabel)
        errorLabel.prepareLayout(.centerX)
        errorLabel.prepareLayout(.centerY)
        errorLabel.prepareLayout(.leading,constant: 30)
        errorLabel.prepareLayout(.trailing,constant: -30)

        
        


        view.addSubview(spinnerView)
        spinnerView.addSubview(spinnerViewLabel)
        spinnerView.prepareLayout(.centerX)
        spinnerView.prepareLayout(.centerY)
        spinnerView.prepareLayout(.height,constant: 100)
        spinnerView.prepareLayout(.width,constant: 100)

        
        view.addSubview(cityNameLabel)
        cityNameLabel.prepareLayout(.centerX)
        cityNameLabel.prepareLayout(.top,constant: 55)
        cityNameLabel.font = UIFont.systemFont(ofSize: 28, weight: .semibold)



        
        view.addSubview(temperatureLabel)
        temperatureLabel.prepareLayout(.centerX)
        temperatureLabel.prepareLayout(.top,toItem: cityNameLabel,
                                       toAttribute: .bottom,constant: 35)
        temperatureLabel.font = UIFont.systemFont(ofSize: 32, weight: .thin)


        
        view.addSubview(descritionLabel)
        descritionLabel.prepareLayout(.centerX)
        descritionLabel.prepareLayout(.top,toItem: temperatureLabel,
                                      toAttribute: .bottom,constant: 25)
        descritionLabel.prepareLayout(.leading,constant: 30)
        descritionLabel.prepareLayout(.trailing,constant: -30)
        descritionLabel.textAlignment = .center
        descritionLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)

        
        view.addSubview(highTempLabel)
        highTempLabel.prepareLayout(.top,toItem: descritionLabel,
                                      toAttribute: .bottom,constant: 25)
        highTempLabel.prepareLayout(.trailing,constant: -25)
        highTempLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)


        
        view.addSubview(lowTempLabel)
        lowTempLabel.prepareLayout(.top,toItem: descritionLabel,
                                      toAttribute: .bottom,constant: 25)
        lowTempLabel.prepareLayout(.leading,constant: 25)
        lowTempLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)



        
        view.addSubview(cloudCoverLabel)
        cloudCoverLabel.prepareLayout(.top,toItem: lowTempLabel,
                                      toAttribute: .bottom,constant: 25)
        cloudCoverLabel.prepareLayout(.centerX)
        cloudCoverLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)


        
        view.addSubview(coordLabel)
        coordLabel.prepareLayout(.top,toItem: cloudCoverLabel,
                                      toAttribute: .bottom,constant: 25)
        coordLabel.prepareLayout(.centerX)
        coordLabel.text = "Coordinates"
        coordLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)

        
        view.addSubview(longLabel)
        longLabel.prepareLayout(.top,toItem: coordLabel,
                                      toAttribute: .bottom,constant: 25)
        longLabel.prepareLayout(.leading,constant: 225)
        longLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)



        
        view.addSubview(latLabel)
        latLabel.prepareLayout(.top,toItem: coordLabel,
                                      toAttribute: .bottom,constant: 25)
        latLabel.prepareLayout(.leading,constant: 100)
        latLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)

        
        view.addSubview(searchAgainButton)
        searchAgainButton.prepareLayout(.bottom,constant: -50)
        searchAgainButton.prepareLayout(.trailing,constant: -50)
        searchAgainButton.prepareLayout(.leading,constant: 50)
        searchAgainButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    private func setupSearchBar() {
       searchBar.delegate = self // Set the delegate for the search bar
       
       view.addSubview(searchBar) // Add the search bar to the view hierarchy
       
       // Set up Auto Layout constraints
       NSLayoutConstraint.activate([
           searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
           searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
           searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
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
            hasAuthorized = sharing
            if sharing {
                if !hasStartedUpdatingLocation {
                    locationManager.startUpdatingLocation()
                    hasStartedUpdatingLocation = true
                }
            } else {
                fetchLastSearchCity()
            }
        } else {
          
            locationManager.requestAlwaysAuthorization()
        }
    }

    

    
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
        let attributedTitle = NSAttributedString(string: "Search Again", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)])
        button.setAttributedTitle(attributedTitle, for: .normal)
//        button.setTitle("Search Again", for: .normal)
        button.isEnabled = true
        button.addTarget(self, action: #selector(searchAgainButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Action
    
    @objc private func searchButtonTapped() {
        searchBar.resignFirstResponder() // Dismiss the keyboard
        fetchWeatherData()
    }
    
    @objc private func searchAgainButtonTapped() {
        searchBar.resignFirstResponder() // Dismiss the keyboard
        searchBar.alpha = 1
        searchAgainButton.alpha = 0
        changelabelsState(hide: true)
    }
    
    // MARK: - Business Logic
    
    func kelvinToFahrenheit(kelvin: Double) -> Double {
        let fahrenheit = (kelvin - 273.15) * 9 / 5 + 32
        return (fahrenheit * 100).rounded() / 100
    }
    

    
    func changelabelsState(hide: Bool) {
        
        cityNameLabel.alpha = hide ? 0 : 1
        temperatureLabel.alpha = hide ? 0 : 1
        descritionLabel.alpha = hide ? 0 : 1
        highTempLabel.alpha = hide ? 0 : 1
        lowTempLabel.alpha = hide ? 0 : 1
        cloudCoverLabel.alpha = hide ? 0 : 1
        coordLabel.alpha = hide ? 0 : 1
        longLabel.alpha = hide ? 0 : 1
        latLabel.alpha = hide ? 0 : 1
    }
    
    func fetchLastSearchCity() {
        if let vm = viewModel, let manager = vm.weatherManager, let currCitySaved = manager.lastSearchCity {
            if currCitySaved != "" {
                errorLabel.alpha = 0
                
                spinnerView.startAnimating()
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
                                self.changelabelsState(hide: false)
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
                                self.changelabelsState(hide: false)
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
                            self.changelabelsState(hide: false)
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
                                self.changelabelsState(hide: false)
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
        self.changelabelsState(hide: false)
        
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
