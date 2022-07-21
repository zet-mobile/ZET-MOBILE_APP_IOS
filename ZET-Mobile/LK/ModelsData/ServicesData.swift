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

struct services_data {
    let serviceName: String?
    let iconUrl: String?
    let description: String?
    let priceAndPeriod: String?
    let nextChargeDate: String?
    let price: String?
    let period: String?
    let id: Int
    let discount: discount_data?
}

struct offers_data {
    let iconUrl: String
    let url: String
    let name: String?
    let id: Int
}

extension offers_data: Decodable {
    
    private enum offers_dataCodingKeys: String, CodingKey {
        case id = "id"
        case iconUrl = "iconUrl"
        case name = "name"
        case url = "url"
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: offers_dataCodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        iconUrl = try container.decode(String.self, forKey: .iconUrl)
        url = try container.decode(String.self, forKey: .url)
        do {
            name = try container.decode(String.self, forKey: .name)
        }
        catch {
            name = nil
        }
       
    }
}


extension services_data: Decodable {
    
    private enum connected_dataCodingKeys: String, CodingKey {
        case serviceName = "serviceName"
        case id = "id"
        case iconUrl = "iconUrl"
        case description = "description"
        case price = "price"
        case period = "period"
        case priceAndPeriod = "priceAndPeriod"
        case discount = "discount"
        case nextChargeDate = "nextChargeDate"
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: connected_dataCodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        do {
            serviceName = try container.decode(String.self, forKey: .serviceName)
        }
        catch {
            serviceName = nil
        }
        
        do {
            iconUrl = try container.decode(String.self, forKey: .iconUrl)
        }
        catch {
            iconUrl = nil
        }
       
        do {
            description = try container.decode(String.self, forKey: .description)
        }
        catch {
            description = nil
        }
        
        do {
            price = try container.decode(String.self, forKey: .price)
        }
        catch {
            price = nil
        }
        
        do {
            period = try container.decode(String.self, forKey: .period)
        }
        catch {
            period = nil
        }
        
        do {
            priceAndPeriod = try container.decode(String.self, forKey: .priceAndPeriod)
        }
        catch {
            priceAndPeriod = nil
        }
        
        do {
            discount = try container.decode(discount_data.self, forKey: .discount)
        }
        catch {
            discount = nil
        }
        
        do {
            nextChargeDate = try container.decode(String.self, forKey: .nextChargeDate)
        }
        catch {
            nextChargeDate = nil
        }
    }
}

