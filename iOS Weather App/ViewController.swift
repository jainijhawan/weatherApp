//
//  ViewController.swift
//  iOS Weather App
//
//  Created by Jai Nijhawan on 22/07/23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var currentLoactionButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var searchResultsTableView: UITableView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherTempratureLabel: UILabel!
    
    var locationManager: CLLocationManager?
    var weatherData: WeatherResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        currentLocationButtonTapped(self)
    }
    
    @IBAction func segmantControlValueChanged(_ sender: Any) {
        guard let segmentContol = sender as? UISegmentedControl,
              let weatherData = weatherData else { return }
        if segmentContol.selectedSegmentIndex == 0 {
            self.weatherTempratureLabel.text = "\(weatherData.current?.tempC ?? 0)"
        } else {
            self.weatherTempratureLabel.text = "\(weatherData.current?.tempF ?? 0)"
        }
    }
    
    @IBAction func citiesButtonTapped(_ sender: Any) {
        
    }
    
    
    
    @IBAction func currentLocationButtonTapped(_ sender: Any) {
        guard let lat = locationManager?.location?.coordinate.latitude,
              let lon = locationManager?.location?.coordinate.longitude else { return }
        Network.shared.getWeatherDataFor(lat: lat, lon: lon) { [weak self] weatherData, error in
            guard error == nil,
                  let weatherData = weatherData else { return }
            self?.weatherData = weatherData
            self?.updateUI(weatherData)
        }
    }
    
    func updateUI(_ weatherData: WeatherResponse) {
        DispatchQueue.main.async { [weak self] in
            self?.weatherDescriptionLabel.text = weatherData.current?.condition?.text ?? ""
            self?.weatherTempratureLabel.text = "\(weatherData.current?.tempC ?? 0)"
            self?.cityNameLabel.text = weatherData.location?.region ?? ""
            self?.weatherImageView.image = getWeatherImageFor(code: weatherData.current?.condition?.code ?? 0)
        }
    }
}



extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            print(manager.location?.coordinate)
        }
    }
}
