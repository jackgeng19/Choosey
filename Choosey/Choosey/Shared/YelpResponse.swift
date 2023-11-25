//
//  YelpResponse.swift
//  Choosey
//
//  Created by Qicheng Geng on 10/4/23.
//

import Foundation

struct YelpResponse: Codable {
    let businesses: [Business]
    let region: Region
}

// MARK: BUSINESS

struct Business: Codable, CustomStringConvertible, Identifiable {
    var description: String{
        return "CustomStringConvertible works!"
    }
//    var verbalPricing: String{
//        guard let unwrapped = self.price else{
//            return "NO PRICE!"
//        }
//        if unwrapped == "$$" || unwrapped == "$"{
//           return "cheap"
//        }
//        return "expensive"
//    }
    let categories: [Category]
    let coordinates: Coordinate
    let distance: Double
    let id: String
    let alias: String
    let location: Location
    let name: String
    let phone: String
    let price: String
    let rating: Double
    let reviewCount: Int
    let url: String
    let transactions: [String]
}

struct Category: Codable {
    let alias: String
    let title: String
}

struct Location: Codable {
    let address1: String
    let address2: String?
    let address3: String?
    let city: String
    let country: String
    let state: String
    
    var displayAddress: String {
        var parts: [String] = [address1]
        
        if let address2 = address2, !address2.isEmpty {
            parts.append(address2)
        }
        
        if let address3 = address3, !address3.isEmpty {
            parts.append(address3)
        }
        
        return parts.joined(separator: ", ")
    }
}

// MARK: REGION

struct Region: Codable {
    let center: Coordinate
}

// MARK: COORDINATE

struct Coordinate: Codable {
    let latitude: Double
    let longitude: Double
}

extension Business {
    static let example = Business(categories: [],
                                  coordinates: Coordinate(latitude: 37, longitude: -79),
                                  distance: 1.12,
                                  id: "1234",
                                  alias: "",
                                  location: Location(address1: "600 Martin Luther King Jr. Blvd",
                                                     address2: nil,
                                                     address3: nil,
                                                     city: "Chapel Hill",
                                                     country: "United States",
                                                     state: "North Carolina"),
                                  name: "Starbucks",
                                  phone: "9192801610",
                                  price: "$$",
                                  rating: 4.5,
                                  reviewCount: 33,
                                  url: "https://www.starbucks.com",
                                  transactions: [])
}
