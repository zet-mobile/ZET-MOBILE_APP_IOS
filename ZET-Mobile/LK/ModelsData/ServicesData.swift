//
//  ServicesData.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/03/22.
//

import Foundation

struct ServicesData: Decodable {
    let connected: [services_data]
    let available: [services_data]
    let offers: [offers_data]
}

struct services_data: Decodable {
    let serviceName: String
    //let iconUrl: String
    //let description: String
    let priceAndPeriod: String
    let price: String
    let period: String
    let id: Int
    //let discount: discount_data
}

struct offers_data: Decodable {
    let iconUrl: String
    let url: String
    let name: String
    let id: Int
}
