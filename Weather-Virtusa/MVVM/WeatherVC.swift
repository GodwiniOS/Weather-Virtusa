//
//  ViewController.swift
//  Weather-Virtusa
//
//  Created by Godwin A on 20/03/2023.
//

import UIKit
import CoreLocation

class SearchViewController: UIViewController{
    
    // MARK: - variables
    var viewModel:WeatherViewModel?
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
    let latLabel = UILabel()
    let errorLabel = UILabel()
    var spinnerViewLabel = UILabel()

    let searchBar = UISearchBar()
    let spinnerView = UIActivityIndicatorView()

    let searchAgainButton = UIButton(type: .system)




    // MARK: - Initialization
    init(_ vm: WeatherViewModel) {
        
        super.init(nibName: nil, bundle: nil)
        viewModel = vm
        vm.delegate = self
        initializeUI()
    }
    
    // MARK: - De-initialization
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life-cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        prepareLocation()
    }
    
    private func initializeUI() {
        
        
        view.backgroundColor = .lightGray
        
        errorLabel.alpha = 0
        searchAgainButton.alpha = 0
        errorLabel.text = ""
        changelabelsState(hide: true)
        
        
        view.addSubview(errorLabel)
        errorLabel.prepareLayout(.centerX)
        errorLabel.prepareLayout(.centerY)
        errorLabel.prepareLayout(.leading,constant: 30)
        errorLabel.prepareLayout(.trailing,constant: -30)

        errorLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        errorLabel.textColor = UIColor.systemRed.withAlphaComponent(0.7)
        errorLabel.numberOfLines = 0
        errorLabel.textAlignment = .center
        


        view.addSubview(spinnerView)
        spinnerView.prepareLayout(.centerX)
        spinnerView.prepareLayout(.centerY)
        spinnerView.prepareLayout(.height,constant: 100)
        spinnerView.prepareLayout(.width,constant: 100)

        spinnerView.backgroundColor = .systemTeal.withAlphaComponent(0.7)
        spinnerView.tintColor = .white
        spinnerView.layer.cornerRadius  = 10

        
        spinnerView.addSubview(spinnerViewLabel)
        spinnerViewLabel = UILabel(frame: CGRect(x: 20, y:55, width: 100, height: 30))
        spinnerViewLabel.text = "Searching"
        spinnerViewLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        
        view.addSubview(cityNameLabel)
        cityNameLabel.prepareLayout(.centerX)
        cityNameLabel.prepareLayout(.top,constant: 55)
        cityNameLabel.font = UIFont.systemFont(ofSize: 28, weight: .semibold)


        view.addSubview(temperatureLabel)
        temperatureLabel.prepareLayout(.centerX)
        temperatureLabel.prepareLayout(.top,toItem: cityNameLabel,
                                       toAttribute: .bottom,constant: 10)
        temperatureLabel.font = UIFont.systemFont(ofSize: 32, weight: .thin)


        
        view.addSubview(descritionLabel)
        descritionLabel.prepareLayout(.centerX)
        descritionLabel.prepareLayout(.top,toItem: temperatureLabel,
                                      toAttribute: .bottom,constant: 10)
        descritionLabel.prepareLayout(.leading,constant: 30)
        descritionLabel.prepareLayout(.trailing,constant: -30)
        descritionLabel.textAlignment = .center
        descritionLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)

        
        view.addSubview(highTempLabel)
        highTempLabel.prepareLayout(.top,toItem: descritionLabel,
                                      toAttribute: .bottom,constant: 10)
        highTempLabel.prepareLayout(.centerX)
        highTempLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)


        
        view.addSubview(lowTempLabel)
        lowTempLabel.prepareLayout(.top,toItem: highTempLabel,
                                      toAttribute: .bottom,constant: 10)
        lowTempLabel.prepareLayout(.centerX)
        lowTempLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)



        
        view.addSubview(cloudCoverLabel)
        cloudCoverLabel.prepareLayout(.top,toItem: lowTempLabel,
                                      toAttribute: .bottom,constant: 10)
        cloudCoverLabel.prepareLayout(.centerX)
        cloudCoverLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)


        
        view.addSubview(coordLabel)
        coordLabel.prepareLayout(.top,toItem: cloudCoverLabel,
                                      toAttribute: .bottom,constant: 10)
        coordLabel.prepareLayout(.centerX)
        coordLabel.text = "Coordinates"
        coordLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)

        
        view.addSubview(longLabel)
        longLabel.prepareLayout(.top,toItem: coordLabel,
                                      toAttribute: .bottom,constant: 10)
        longLabel.prepareLayout(.centerX)
        longLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)



        
        view.addSubview(latLabel)
        latLabel.prepareLayout(.top,toItem: longLabel,
                                      toAttribute: .bottom,constant: 10)
        latLabel.prepareLayout(.centerX)
        latLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)

        
        view.addSubview(searchAgainButton)
        searchAgainButton.prepareLayout(.bottom,constant: -8)
        searchAgainButton.prepareLayout(.trailing,constant: -50)
        searchAgainButton.prepareLayout(.leading,constant: 50)
        searchAgainButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        searchAgainButton.backgroundColor = .black
            
        let attributedTitle = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)])
        searchAgainButton.setAttributedTitle(attributedTitle, for: .normal)
        searchAgainButton.isEnabled = true
        searchAgainButton.addTarget(self, action: #selector(searchAgainButtonTapped), for: .touchUpInside)
        
        
        
        view.addSubview(searchBar)
        searchBar.prepareLayout(.top,constant: 100)
        searchBar.prepareLayout(.leading)
        searchBar.prepareLayout(.trailing)
        
        searchBar.delegate = self
        searchBar.placeholder = "Search By city, zipcode"
//        if let searchTextField = searchBar.value(forKey: "searchField")
//            as? UITextField {
//            let borderImage = UIImage() // Create an empty UIImage
//            searchTextField.borderStyle = .none // Remove the border
//            searchTextField.background = borderImage // Set the background image to the empty UIImage
//        }
        
    }
    
    private func prepareLocation(){
        
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
                getLastSearchCity()
            }
        } else {
          
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    private func getLastSearchCity(){
        
        DispatchQueue.main.async {
            self.errorLabel.alpha = 0
            self.spinnerView.startAnimating()
        }
        viewModel?.fetchLastSearchCity()
    }
    
    private func getWeatherData(){
        
        DispatchQueue.main.async {
         
            self.errorLabel.alpha = 0
            self.searchAgainButton.alpha = 1
            self.spinnerView.startAnimating()
        }
        
        viewModel?.fetchWeatherData(searchText: searchBar.text!)
    }
    
    private func getDefaultWeather(){
        
        DispatchQueue.main.async {
        }
        viewModel?.fetchDefaultWeather()
    }
    
    private func getCurrentWeatherData(location: CLLocation){
        
        DispatchQueue.main.async {
            self.errorLabel.alpha = 0
            self.searchAgainButton.alpha = 1
            self.spinnerView.startAnimating()
        }
        viewModel?.fetchCurrentWeatherData(location.coordinate.longitude,
                                           location.coordinate.latitude)
    }
    
    // MARK: - Action
    
    @objc private func searchButtonTapped() {
        searchBar.resignFirstResponder() // Dismiss the keyboard
        getWeatherData()
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
    
}


extension SearchViewController: WeatherViewModelDelegate {

    
    
    func responseCurrentWeatherData(error: String?,
                                    deatails: WeatherCoodResponse?) {
        
        
        if error != nil {
            
            DispatchQueue.main.async {
                self.spinnerView.stopAnimating()
                self.errorLabel.alpha = 1
                self.searchBar.alpha = 1
                self.searchAgainButton.alpha = 1
                self.errorLabel.text = error
            }
                                        
        } else
        if let newCityData = deatails {
            let main = newCityData.main
            let weather = newCityData.weather
            let clouds = newCityData.clouds
            let coord = newCityData.coord

            self.spinnerView.stopAnimating()
            self.searchAgainButton.alpha = 1
            self.searchBar.alpha = 0
            self.changelabelsState(hide: false)
                self.cityNameLabel.text = "City Name: \(newCityData.name.description)"
            self.temperatureLabel.text = "\(String(describing: self.kelvinToFahrenheit(kelvin: main.temp))) F"
            self.descritionLabel.text = weather[0].description
            self.highTempLabel.text = "High Temperature: \(String(describing: self.kelvinToFahrenheit(kelvin: main.tempMax))) F"
            self.lowTempLabel.text = "Low Temperature: \(String(describing: self.kelvinToFahrenheit(kelvin: main.tempMin))) F"
            self.cloudCoverLabel.text = "Cloud cover is \(String(describing: clouds.all))%"
            self.longLabel.text = "Longitude :\(String(describing: coord.lon))"
            self.latLabel.text = "Latitude :\(String(describing: coord.lat))"

        }
    }
    
    
    
    func responseAPIRequest(error: String?, deatails: WeatherResponse?, type: WeatherViewModel.APIRequestType) {
    

        DispatchQueue.main.async {

        if error != nil {
            
                self.spinnerView.stopAnimating()
                self.errorLabel.alpha = 1
                self.searchBar.alpha = 1
                self.searchAgainButton.alpha = 1
                self.errorLabel.text = error
                                        
        } else if let newCityData = deatails,
                    let main = newCityData.main,
                    let weather = newCityData.weather,
                    let clouds = newCityData.clouds,
                  let coord = newCityData.coord {
            
                
                self.spinnerView.stopAnimating()
                self.searchAgainButton.alpha = 1
                self.searchBar.alpha = 0
                self.changelabelsState(hide: false)
            if let name = newCityData.name {
                self.cityNameLabel.text = "City Name: \(name)"
            }
            self.temperatureLabel.text = "\(String(describing: self.kelvinToFahrenheit(kelvin: main.temp))) F"
                self.descritionLabel.text = weather[0].description
                self.highTempLabel.text = "High Temperature: \(String(describing: self.kelvinToFahrenheit(kelvin: main.temp_max))) F"
                self.lowTempLabel.text = "Low Temperature: \(String(describing: self.kelvinToFahrenheit(kelvin: main.temp_min))) F"
                self.cloudCoverLabel.text = "Cloud cover is \(String(describing: clouds.all))%"
                self.longLabel.text = "Longitude: \(String(describing: coord.lon))"
                self.latLabel.text = "Latitude: \(String(describing: coord.lat))"
            }
        }

        
//        switch type {
//        case .DefaultWeather: break
//        case .LastSearchCity: break
//        case .WeatherData: break
//        }
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        getWeatherData()
    }
}





// MARK: - CLLocationManagerDelegate
extension SearchViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
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
            getDefaultWeather()
            return
        @unknown default:
            // Handle any future cases that may be added to the CLAuthorizationStatus enumeration
            // Default to Miami
            UserDefaults.standard.setValue(false, forKey: "sharingLocation")
            getDefaultWeather()
            return
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            getCurrentWeatherData(location: location)
        }
    }

    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        
        errorLabel.alpha = 1
        // Allow user to research in case there is an error
        searchBar.alpha = 1
        changelabelsState(hide: false)
        
        if let clError = error as? CLError {
            switch clError.code {
            case .denied:
                errorLabel.text = "Location access denied. Please allow location access in Settings."
                getDefaultWeather()
            case .network:
                errorLabel.text = "Network error. Please check your internet connection."
            default:
                errorLabel.text = "Error determining location: \(error.localizedDescription)"
            }
        } else {
            self.errorLabel.text = "Error determining location: \(error.localizedDescription)"
        }
    }
}
