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
    let settings: [settings_money_data]
}

struct settings_money_data: Decodable {
    let minValue: Double
    let maxValue: Double
    let price: Double
    let costPrice: Double
    let quantityLimitA: Double
    let volumeLimitA: Double
    let quantityLimitB: Double
    let volumeLimitB: Double
    let minBalanceAfterTransfer: Double
    let discountPercent: Double
    let daysSinceRegistration: Double
    let minExpenses: Double
    let description: String
    let title: String
    let unit: String
}

struct MoneyTransferDataHistory: Decodable {
    let history: [history_money_datas]
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
