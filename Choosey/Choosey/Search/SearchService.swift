//
//  SearchService.swift
//  Choosey
//
//  Created by Qicheng Geng on 10/4/23.
//

//Client ID
//beONRhW_sFfC67W1Kam9dA


//API Key
//WcG9yxY_vjsizLaI4wEiQkaRBIFmFiU-lhWwNBBM6_3DYvtdgTIMgxP3Rglu1Q4N4wiT5kXjpiGfofV4gKmlc-PPXf5_bfX2XnGenqx5rHQ2uvyB39xKcK_mXNQdZXYx

import Foundation

struct SearchService {
    private static let apiKey = "WcG9yxY_vjsizLaI4wEiQkaRBIFmFiU-lhWwNBBM6_3DYvtdgTIMgxP3Rglu1Q4N4wiT5kXjpiGfofV4gKmlc-PPXf5_bfX2XnGenqx5rHQ2uvyB39xKcK_mXNQdZXYx"
    private static let session = URLSession.shared
    private static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }

    /// Returns an array of businesses located within `radius` miles of the
    /// location specified by `latitude` and `longitude`, filtering to only
    /// include those that match the provided `searchTerm`.
    ///
    /// - Parameters:
    ///   - latitude: Latitude of the location to search from.
    ///   - longitude: Longitude of the location to search from.
    ///   - radius: A suggested search radius in miles. The max value is 24 miles.
    ///   - searchTerm: Search term, e.g. "burgers" or "sushi". The term
    ///     may also be the business's name, such as "Bonchon".
    ///
    /// - Returns: An array of businesses matching the specified parameters.
    public static func findBusinesses(
        latitude: Double,
        longitude: Double,
        radius: Int,
        searchTerm: String,
        priceOption: Int?,
        sortOption: String?
        
    ) async throws -> [Business] {
        // TODO: Convert radius from miles to meters
        //   - hint: use the Measurement type
        // TODO: Construct the url with URLComponents with these query params
        //   - latitude
        //   - longitude
        //   - radius (should be an Int and in meters)
        //   - term
        // TODO: Construct the URLRequest
        //   - http method: "GET"
        //   - "Authorization" header: apiKey
        //   - "accept" header: "application/json"
        // TODO: Make the request with URLSession
        //   - be sure to use the `data(for: request)` method
        // TODO: Decode the response using the decoder instantiated above
        // TODO: Return the businesses array from the YelpResponse
        // Convert radius from miles to meters
//        let milesMeasurement = Measurement(value: Double(radius), unit: UnitLength.miles)
//        let metersMeasurement = milesMeasurement.converted(to: .meters)
//        let radiusInMeters = Int(metersMeasurement.value)

        // Construct the URL with URLComponents
        var urlComponents = URLComponents(string: "https://api.yelp.com/v3/businesses/search")!
        urlComponents.queryItems = [
           URLQueryItem(name: "latitude", value: "\(latitude)"),
           URLQueryItem(name: "longitude", value: "\(longitude)"),
           URLQueryItem(name: "radius", value: "\(radius.converted(from: .miles, to: .meters))"),
           URLQueryItem(name: "term", value: searchTerm)
        ]
        
        if let price = priceOption {
            urlComponents.queryItems?.append(URLQueryItem(name: "price", value: "\(price)"))
        }
        
        if let sort = sortOption {
            urlComponents.queryItems?.append(URLQueryItem(name: "sort_by", value: sort))
        }
        
        guard let url = urlComponents.url else {
           throw NSError(domain: "Invalid URL", code: 400, userInfo: nil)
        }
        
        // Construct the URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//        request.setValue("application/json", forHTTPHeaderField: "accept")
        // Make the request with URLSession
        let (data, _) = try await URLSession.shared.data(for: request)
        print(data)
        // Decode the response
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let yelpResponse = try decoder.decode(YelpResponse.self, from: data)
//        print(yelpResponse)
        // Return the businesses array from the YelpResponse
        return yelpResponse.businesses
    }
    
        /// Helper method to print the JSON data without decoding
        /// Very helpful when debugging
    /// How to use this?
    private static func printData(data: Data) {
        let string = String(data: data, encoding: .utf8)!
        print(string)
    }
}

extension SearchService {
    struct PriceOption {
        let title: String
        let value: Int?
    }

    struct SortOption {
        let title: String
        let value: String
    }
    
    public static let priceOptions: [PriceOption] = [
        .init(title: "Any", value: nil),
        .init(title: "💰", value: 1),
        .init(title: "💰💰", value: 2),
        .init(title: "💰💰💰", value: 3),
        .init(title: "💰💰💰💰", value: 4)
    ]
    
    public static let sortOptions: [SortOption] = [
        .init(title: "🎯 Best Match", value: "best_match"),
        .init(title: "⭐️ Rating", value: "rating"),
        .init(title: "✍️ Review Count", value: "review_count"),
        .init(title: "📏 Distance", value: "distance")

    ]
    
}
