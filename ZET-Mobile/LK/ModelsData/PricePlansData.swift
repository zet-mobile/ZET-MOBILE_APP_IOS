//
//  PricePlansData.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/03/22.
//

import Foundation

struct PricePlansData: Decodable {
    let connected: connected_data
    let available: [available_data]
}

struct PricePlansIDData: Decodable {
    let selected: selected_data
    let available: [available_data]
}

struct connected_data {
    let id: Int
    let priceplanName: String
    let nextApplyDate: String?
    let description: String?
    let price: String?
    let period: String?
    let balances: [details_data]
    let discount: discount_data?
    let overCharging: [overCharging_data]
    let unlimOptions: [unlimOptions_data]
}

struct selected_data: Decodable {
    let id: Int
    let priceplanName: String
    //let nextApplyDate: String
    //let description: String
    let price: String
    let period: String
    let balances: [details_data]
    //let discount: discount_data
    let overCharging: [overCharging_data]
    let unlimOptions: [unlimOptions_data]
}

struct available_data: Decodable{
    let id: Int
    let priceplanName: String
  //  let description: String
    let price: String
    let period: String
    let currencyAndPeriod: String
    //let discount: discount_data
}

struct overCharging_data: Decodable {
    let description: String
    let directionPrice: Double
    let priceAndUnit: String
}

struct unlimOptions_data: Decodable {
    let optionName: String
    let dpiUnlimElements: [dpiUnlimElements_data]
}

struct dpiUnlimElements_data: Decodable {
    let elementName: String
    let iconUrl: String
}

extension connected_data: Decodable {
    
    private enum connected_dataCodingKeys: String, CodingKey {
        case id = "id"
        case priceplanName = "priceplanName"
        case nextApplyDate = "nextApplyDate"
        case description = "description"
        case price = "price"
        case period = "period"
        case balances = "balances"
        case discount = "discount"
        case overCharging = "overCharging"
        case unlimOptions = "unlimOptions"
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: connected_dataCodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        priceplanName = try container.decode(String.self, forKey: .priceplanName)
        do {
            nextApplyDate = try container.decode(String.self, forKey: .nextApplyDate)
        }
        catch {
            nextApplyDate = nil
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
        
        balances = try container.decode([details_data].self, forKey: .balances)
        
        do {
            discount = try container.decode(discount_data.self, forKey: .discount)
        }
        catch {
            discount = nil
        }
        
        overCharging = try container.decode([overCharging_data].self, forKey: .overCharging)
        unlimOptions = try container.decode([unlimOptions_data].self, forKey: .unlimOptions)
    }
}
