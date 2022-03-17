//
//  HomeData.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 14/03/22.
//

import Foundation

struct HomeData: Decodable {
    
    let currentVersion: String
    //let subscriberName: String
    let subscriberBalance: Int
    let subscriberCredit: Int
    let notificationsCount: Int
    let balances: balances_data
    let priceplan: priceplan_data
    let microServices: [microServices_data]
    let offers: [offers_data]
    let services: [services_data]
}

struct priceplan_data: Decodable {
    let priceplanName: String
    let nextApplyDate: String
}

struct microServices_data: Decodable {
    let id: Int
    let iconUrl: String
    let microServiceName: String
}
