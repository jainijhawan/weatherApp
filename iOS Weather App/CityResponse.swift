//
//  CityResponse.swift
//  iOS Weather App
//
//  Created by Jai Nijhawan on 25/07/23.
//

import Foundation

// MARK: - CityResponseElement
struct CityResponseElement: Codable {
    let id: Int?
    let name, region, country: String?
    let lat, lon: Double?
    let url: String?
}

typealias CityResponse = [CityResponseElement]
