//
//  MoneyTransferData.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 07/04/22.
//

import Foundation

struct MoneyTransferData: Decodable {
    let subscriberBalance: Double
    let balances: balances_data
    let minValue: Int
    let maxValue: Int
    let price: Double
    let monthlyQuantityLimitA: Double
    let quantityLimitA: Double
    let volumeLimitA: Double
    let monthlyQuantityLimitB: Double
    let quantityLimitB: Double
    let volumeLimitB: Double
    let discountPercent: Double
    let minBalanceAfterTransfer: Double
    let daysSinceRegistration: Double
    let minExpenses: Double
    let description: String
    let title: String
    let unit: String
}

struct MoneyTransferDataHistory {
    let history: [history_money_datas]?
}

struct history_money_datas: Decodable {
    let date:  String
    let histories: [histories_money_data]
}

struct histories_money_data: Decodable {
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

extension MoneyTransferDataHistory: Decodable {
    
    private enum MoneyTransferDataHistoryCodingKeys: String, CodingKey {
        case history = "history"
        
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MoneyTransferDataHistoryCodingKeys.self)
      
        do {
            history = try container.decode([history_money_datas].self, forKey: .history)
        }
        catch {
            history = nil
        }
  
    
    }
}
