//
//  RoumingData.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/03/22.
//

import Foundation

struct RoumingData: Decodable {
    let questions: [questions_data]
    let countries: [countries_data]
}

struct questions_data: Decodable {
    let id: Int
    let question: String
    let answer: String
}

struct countries_data {
    let id: Int
    let countryName: String?
    let iconUrl: String?
}


extension countries_data: Decodable {
    
    private enum connected_dataCodingKeys: String, CodingKey {
        case id = "id"
        case iconUrl = "iconUrl"
        case countryName = "countryName"
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: connected_dataCodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        do {
            iconUrl = try container.decode(String.self, forKey: .iconUrl)
        }
        catch {
            iconUrl = nil
        }
       
        do {
            countryName = try container.decode(String.self, forKey: .countryName)
        }
        catch {
            countryName = nil
        }
    
    }
}

