//
//  Network.swift
//  iOS Weather App
//
//  Created by Jai Nijhawan on 23/07/23.
//

import Foundation

class Network {
    
    private init() { }
    
    static let shared = Network()
    private static let APIKEY = "e0c4b1cdfc844e66a38203457232207"
    
    let baseURL = "https://api.weatherapi.com/v1/"
    
    func getWeatherDataFor(lat: Double, lon: Double, completion: @escaping (WeatherResponse?, Error?) -> () ) {
        guard var url = URLComponents(string: baseURL + "current.json") else { return }
        url.queryItems = [
            URLQueryItem(name: "key", value: Network.APIKEY),
            URLQueryItem(name: "q", value: "\(lat),\(lon)")
        ]
        guard let finalURL = url.url?.absoluteURL else { return }
        URLSession.shared.dataTask(with: finalURL, completionHandler: { data, response, error in
            guard let jsonData = data else { return }
            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: jsonData)
                completion(weatherResponse, nil)
            } catch let parseErr {
                print("JSON Parsing Error", parseErr)
                completion(nil, parseErr)
            }
        }).resume()
    }
    
    func getCityAutoComplete(name: String, completion: @escaping (CityResponse?, Error?) -> () ) {
        guard var url = URLComponents(string: baseURL + "search.json") else { return }
        url.queryItems = [
            URLQueryItem(name: "key", value: Network.APIKEY),
            URLQueryItem(name: "q", value: "\(name)")
        ]
        guard let finalURL = url.url?.absoluteURL else { return }
        URLSession.shared.dataTask(with: finalURL, completionHandler: { data, response, error in
            guard let jsonData = data else { return }
            do {
                let cityResponse = try JSONDecoder().decode(CityResponse.self, from: jsonData)
                completion(cityResponse, nil)
            } catch let parseErr {
                print("JSON Parsing Error", parseErr)
                completion(nil, parseErr)
            }
        }).resume()
    }
}
