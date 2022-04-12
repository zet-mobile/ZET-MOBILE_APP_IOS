//
//  TransferData.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 22/03/22.
//

import Foundation

struct TransferData: Decodable {
    let subscriberBalance: Double
    let balances: balances_data
    let settings: [settings_data]
}

struct settings_data: Decodable {
    let minValue: Double
    let maxValue: Double
    let midValue: Double
    let midPrice: Double
    let price: Double
    let quantityLimit: Double
    let volumeLimit: Double
    let conversationRate: Double
    let discountPercent: Double
    let transferType: String
    let transferTypeId: Int
    let description: String
}

struct TransferDataHistory {
    let history: [history_datas]?
}

struct history_datas: Decodable {
    let date:  String
    let histories: [histories_data]
}

struct histories_data: Decodable {
    let phoneNumber: String
    let status: String
    let date: String
    let id: Int
    let volume: Double
    let price: Double
    let type: Int
    let transferType: Int
    let statusId: Int
    let transactionId: Int
}

extension TransferDataHistory: Decodable {
    
    private enum TransferDataHistoryCodingKeys: String, CodingKey {
        case history = "history"
        
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TransferDataHistoryCodingKeys.self)
      
        do {
            history = try container.decode([history_datas].self, forKey: .history)
        }
        catch {
            history = nil
        }
  
    
    }
}


