//
//  RoumingCountryData.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/03/22.
//

import Foundation

struct RoumingCountryData: Decodable {
    let countryId: Int
    let countryName: String
    let iconUrl: String
    let roamingOperators: [roamingOperators_data]
}

struct roamingOperators_data: Decodable {
    let operatorId: Int
    let operatorName: String
    let iconUrl: String
    let operatorCharges: [operatorCharges_data]
}

struct operatorCharges_data: Decodable {
    let price: Int
    let description: String
}
