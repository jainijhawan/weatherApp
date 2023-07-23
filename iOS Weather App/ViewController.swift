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

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
    }
    
    @IBAction func segmantControlValueChanged(_ sender: Any) {
    }
    
    @IBAction func citiesButtonTapped(_ sender: Any) {
    }
    
    @IBAction func currentLocationButtonTapped(_ sender: Any) {
        guard let lat = locationManager?.location?.coordinate.latitude,
              let lon = locationManager?.location?.coordinate.longitude else { return }
        
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            print(manager.location?.coordinate)
        }
    }
}
