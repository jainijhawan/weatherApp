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
    private var lastSearchTxt = ""
    var cityListDataSource: CityResponse?
    
    var selectedCityLatLon = [(lat: Double, lon: Double)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        searchResultsTableView.backgroundColor = .clear
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCities" {
            guard let vc = segue.destination as? CitiesViewController else { return }
            vc.selectedCityLatLon = selectedCityLatLon
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
            self?.selectedCityLatLon.append((lat: lat, lon: lon))
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
            print(manager.location?.coordinate ?? "")
        }
    }
}

extension ViewController: UISearchBarDelegate {
  
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchResultsTableView.isHidden = searchText.isEmpty
        if lastSearchTxt.isEmpty {
            lastSearchTxt = searchText
        }
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.makeNetworkCall), object: lastSearchTxt)
        lastSearchTxt = searchText
        self.perform(#selector(self.makeNetworkCall), with: searchText, afterDelay: 0.9)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    @objc private func makeNetworkCall(sender: String) {
        Network.shared.getCityAutoComplete(name: lastSearchTxt) { cityList, error in
            guard error == nil,
                  let cityList = cityList else { return }
            DispatchQueue.main.async {
                self.cityListDataSource?.removeAll()
                self.cityListDataSource = cityList
                self.searchResultsTableView.isHidden = cityList.count == 0
                self.searchResultsTableView.reloadData()
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cityListDataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultsTableViewCell", for: indexPath) as? SearchResultsTableViewCell else { return UITableViewCell() }
        let city = cityListDataSource?[indexPath.row].name ?? ""
        let country = cityListDataSource?[indexPath.row].country ?? ""
        cell.cityNameLabel.text =  city + " " + country
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = cityListDataSource?[indexPath.row]
        let cityName = selectedCity?.name
        
        selectedCityLatLon.append((lat: selectedCity?.lat ?? 0, lon: selectedCity?.lon ?? 0))
        alert(message: "\(cityName ?? "") Added to City List")
    }
    
}
