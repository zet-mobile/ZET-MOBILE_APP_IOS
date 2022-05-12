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
    let minValue: Double
    let maxValue: Double
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

struct histories_exchange_data: Decodable {
    let phoneNumber: String
    let status: String
    let date: String
    let id: Int
    let volumeA: Double
    let volumeB: Double
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


