//
//  CitiesViewController.swift
//  iOS Weather App
//
//  Created by Jai Nijhawan on 25/07/23.
//

import UIKit

class CitiesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var citiesTableView: UITableView!
    
    var selectedCityLatLon = [(lat: Double, lon: Double)]()
    var cityWeatherDataSource = [WeatherResponse]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        citiesTableView.delegate = self
        citiesTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getWeatherForAllCities()
    }
    
    func getWeatherForAllCities() {
        for city in selectedCityLatLon {
            Network.shared.getWeatherDataFor(lat: city.lat, lon: city.lon) { [weak self] weatherData, error in
                DispatchQueue.main.async { [weak self] in
                    guard error == nil,
                          let weatherData = weatherData else { return }
                    self?.cityWeatherDataSource.append(weatherData)
                    if self?.cityWeatherDataSource.count == self?.selectedCityLatLon.count {
                        self?.citiesTableView.reloadData()
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cityWeatherDataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CityDataTableViewCell", for: indexPath) as? CityDataTableViewCell else { return UITableViewCell() }
        let weatherData = cityWeatherDataSource[indexPath.row]
        cell.cityDataLabel.text = (weatherData.location?.name ?? "") + " " + "\(weatherData.current?.tempC ?? 0) °C"
        cell.cityDataImage.image = getWeatherImageFor(code: weatherData.current?.condition?.code ?? 0)
        return cell
    }
}
