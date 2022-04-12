//
//  HomeData.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 14/03/22.
//

import Foundation

struct HomeData: Decodable {
    
    let currentVersion: String
   // let subscriberName: String
    let subscriberBalance: Double
    let subscriberCredit: Double
    let notificationsCount: Int
    let balances: balances_data
    let priceplan: priceplan_data
    let microServices: [microServices_data]
    let offers: [offers_data]
    let services: [services_data]
}

struct priceplan_data {
    let priceplanName: String
    let nextApplyDate: String?
}

struct microServices_data: Decodable {
    let id: Int
    let iconUrl: String
    let microServiceName: String
}

extension priceplan_data: Decodable {
    
    private enum priceplan_dataCodingKeys: String, CodingKey {
        case priceplanName = "priceplanName"
        case nextApplyDate = "nextApplyDate"
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: priceplan_dataCodingKeys.self)
        priceplanName = try container.decode(String.self, forKey: .priceplanName)
        do {
            nextApplyDate = try container.decode(String.self, forKey: .nextApplyDate)
        }
        catch {
            nextApplyDate = nil
        }
       
    }
}
