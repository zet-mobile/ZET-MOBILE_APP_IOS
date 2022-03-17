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

struct connected_data: Decodable {
    let id: Int
    let priceplanName: String
    let nextApplyDate: String
    //let description: String
    let price: String
    let period: String
    let balances: [details_data]
    //let discount: discount_data
    //let overCharging: [overCharging_data]
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
    let directionPrice: Int
}

struct unlimOptions_data: Decodable {
    let optionName: String
    let dpiUnlimElements: [dpiUnlimElements_data]
}

struct dpiUnlimElements_data: Decodable {
    let elementName: String
    let iconUrl: String
}
