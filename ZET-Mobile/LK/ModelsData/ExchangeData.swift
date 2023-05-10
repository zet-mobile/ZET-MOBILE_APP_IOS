//
//  ExchangeData.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 07/04/22.
//

import Foundation

struct ExchangeData: Decodable {
    let subscriberBalance: Double
    let balances: balances_data
    let settings: [settings_exchange_data]
    let units: [units_data]
}

struct settings_exchange_data: Decodable {
    let minValue: Int
    let maxValue: Int
    let midValue: Double
    let midPrice: Double
    let price: Double
    let costPrice: Double
    let quantityLimit: Double
    let volumeLimitA: Double
    let volumeLimitB: Double
    let conversationRateTrafficA: Double
    let conversationRateTrafficB: Double
    let discountPercent: Double
    let exchangeRate: Double
    let exchangeType: String
    let exchangeTypeId: Int
    let description: String
    let unitA: String
    let unitB: String
}
struct units_data: Decodable {
    let unitName: String
    let unitB: [unitB_data]
}

struct unitB_data: Decodable {
    let unitName: String
    let exchangeType: Int
}

struct ExchangeDataHistory {
    let history: [history_exchange_datas]?
}

struct history_exchange_datas: Decodable {
    let date: String
    let histories: [histories_exchange_data]
}

struct histories_exchange_data {
    let phoneNumber: String
    let status: String
    let date: String
    let id: Int
    let volumeA: Any?
    let volumeB: Any?
    let unitA: String
    let unitB: String
    let price: Double
    let exchangeType: Int
    let statusId: Int
    let transactionId: Int
}

extension ExchangeDataHistory: Decodable {
    
    private enum ExchangeDataHistoryCodingKeys: String, CodingKey {
        case history = "history"
        
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ExchangeDataHistoryCodingKeys.self)
      
        do {
            history = try container.decode([history_exchange_datas].self, forKey: .history)
        }
        catch {
            history = nil
        }
  
    
    }
}

extension histories_exchange_data: Decodable {
    
    private enum histories_exchange_dataCodingKeys: String, CodingKey {
        case phoneNumber = "phoneNumber"
        case status = "status"
        case date = "date"
        case id = "id"
        case volumeA = "volumeA"
        case volumeB = "volumeB"
        case unitA = "unitA"
        case unitB = "unitB"
        case price = "price"
        case exchangeType = "exchangeType"
        case statusId = "statusId"
        case transactionId = "transactionId"
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: histories_exchange_dataCodingKeys.self)
      
        phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        status = try container.decode(String.self, forKey: .status)
        date = try container.decode(String.self, forKey: .date)
        id = try container.decode(Int.self, forKey: .id)
        
        do {
            volumeA = try container.decode(Int.self, forKey: .volumeA)
        }
        catch {
            volumeA = try container.decode(Double?.self, forKey: .volumeA)
        }
  
        do {
            volumeB = try container.decode(Int.self, forKey: .volumeB)
        }
        catch {
            volumeB = try container.decode(Double?.self, forKey: .volumeB)
        }
        
        unitA = try container.decode(String.self, forKey: .unitA)
        unitB = try container.decode(String.self, forKey: .unitB)
        price = try container.decode(Double.self, forKey: .price)
        exchangeType = try container.decode(Int.self, forKey: .exchangeType)
        statusId = try container.decode(Int.self, forKey: .statusId)
        transactionId = try container.decode(Int.self, forKey: .transactionId)
    }
}


