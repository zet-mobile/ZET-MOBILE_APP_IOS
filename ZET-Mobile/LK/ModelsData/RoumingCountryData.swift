//
//  RoumingCountryData.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/03/22.
//

import Foundation

struct RoumingCountryData {
    let countryId: Int
    let countryName: String?
    let iconUrl: String?
    let roamingOperators: [roamingOperators_data]?
}

struct roamingOperators_data: Decodable {
    let operatorId: Int
    let operatorName: String
    let iconUrl: String
    let operatorCharges: [operatorCharges_data]
}

struct operatorCharges_data {
    let price: Double
    let description: String?
}

extension RoumingCountryData: Decodable {
    
    private enum  RoumingCountryDataCodingKeys: String, CodingKey {
        case countryId = "countryId"
        case iconUrl = "iconUrl"
        case countryName = "countryName"
        case roamingOperators = "roamingOperators"
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy:  RoumingCountryDataCodingKeys.self)
        countryId = try container.decode(Int.self, forKey: .countryId)
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
    
        do {
            roamingOperators = try container.decode([roamingOperators_data].self, forKey: .roamingOperators)
        }
        catch {
            roamingOperators = nil
        }
    }
}

extension operatorCharges_data: Decodable {
    
    private enum  operatorCharges_dataCodingKeys: String, CodingKey {
        case price = "price"
        case description = "description"
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy:  operatorCharges_dataCodingKeys.self)
        price = try container.decode(Double.self, forKey: .price)
        do {
            description = try container.decode(String.self, forKey: .description)
        }
        catch {
            description = nil
        }
       
    }
}

