//
//  PacketsData.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 06/03/22.
//

import Foundation

struct PacketsData {
    let balances: balances_data
    let connectedPackets: [connectedPackets_data]
    let smsAvailablePackets: [connectedPackets_data]
    let onnetAvailablePackets: [connectedPackets_data]
    let offnetAvailablePackets: [connectedPackets_data]
    let internetAvailablePackets: [connectedPackets_data]
    let subscriberBalance: Double
}

struct balances_data: Decodable {
    let mb: details_data
    let onnet: details_data
    let sms: details_data
    let offnet: details_data
}

struct details_data: Decodable {
    //let unitName: String
    let unitId: Int
    let now: Int
    let start: Int
    //let unlimConditions: unlimConditions_data
    let unlim: Bool
}

struct unlimConditions_data: Decodable {
    let hours: String
    let speed: String
}

struct connectedPackets_data: Decodable {
    let packetName: String
    //let iconUrl: String
    //let description: String
    let price: String
    //let period: String
    let unitType: Double
    let packetStatus: Double
    //let nextApplyDate: Date
    let id: Int
    //let discount: discount_data
}

struct discount_data: Decodable {
    let discountName: String
    let discountPercent: Int
    let discountServiceId: String
}

extension PacketsData: Decodable {
    
    private enum PacketsDataCodingKeys: String, CodingKey {
        case balances = "balances"
        case connectedPackets = "connectedPackets"
        case smsAvailablePackets = "smsAvailablePackets"
        case onnetAvailablePackets = "onnetAvailablePackets"
        case offnetAvailablePackets = "offnetAvailablePackets"
        case internetAvailablePackets = "internetAvailablePackets"
        case subscriberBalance = "subscriberBalance"
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PacketsDataCodingKeys.self)
        
        balances = try container.decode(balances_data.self, forKey: .balances)
        connectedPackets = try container.decode([connectedPackets_data].self, forKey: .connectedPackets)
        smsAvailablePackets = try container.decode([connectedPackets_data].self, forKey: .smsAvailablePackets)
        onnetAvailablePackets = try container.decode([connectedPackets_data].self, forKey: .onnetAvailablePackets)
        offnetAvailablePackets = try container.decode([connectedPackets_data].self, forKey: .offnetAvailablePackets)
        internetAvailablePackets = try container.decode([connectedPackets_data].self, forKey: .internetAvailablePackets)
        subscriberBalance = try container.decode(Double.self, forKey: .subscriberBalance)
    }
}


