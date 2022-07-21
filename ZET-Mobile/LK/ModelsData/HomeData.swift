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
    let priceplanName: String?
    let nextApplyDate: String?
}

struct microServices_data {
    let id: Int
    let iconUrl: String
    let microServiceName: String?
}

extension microServices_data: Decodable {
    
    private enum microServices_dataCodingKeys: String, CodingKey {
        case id = "id"
        case iconUrl = "iconUrl"
        case microServiceName = "microServiceName"
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: microServices_dataCodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        iconUrl = try container.decode(String.self, forKey: .iconUrl)
        do {
            microServiceName = try container.decode(String.self, forKey: .microServiceName)
        }
        catch {
            microServiceName = nil
        }
       
    }
}

extension priceplan_data: Decodable {
    
    private enum priceplan_dataCodingKeys: String, CodingKey {
        case priceplanName = "priceplanName"
        case nextApplyDate = "nextApplyDate"
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: priceplan_dataCodingKeys.self)
        do {
            priceplanName = try container.decode(String.self, forKey: .priceplanName)
        }
        catch {
            priceplanName = nil
        }
        do {
            nextApplyDate = try container.decode(String.self, forKey: .nextApplyDate)
        }
        catch {
            nextApplyDate = nil
        }
       
    }
}
