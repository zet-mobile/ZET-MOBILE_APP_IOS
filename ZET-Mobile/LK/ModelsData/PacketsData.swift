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

struct details_data {
    //let unitName: String
    let unitId: Int
    let now: Int
    let start: Int
    let unlimConditions: unlimConditions_data?
    let unlim: Bool
}

struct unlimConditions_data: Decodable {
    let hours: String
    let speed: String
}

struct connectedPackets_data {
    let packetName: String
    let iconUrl: String?
    let description: String?
    let price: String
    let period: String?
    let unitType: Double
    let packetStatus: Double
    let nextApplyDate: String?
    let id: Int
    let discount: discount_data?
}

struct discount_data: Decodable {
    //let discountName: String
    let discountPercent: Int
    let discountServiceId: Int
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

extension connectedPackets_data: Decodable {
    
    private enum connectedPackets_dataCodingKeys: String, CodingKey {
        
        case packetName = "packetName"
        case iconUrl = "iconUrl"
        case description = "description"
        case price = "price"
        case period = "period"
        case unitType = "unitType"
        case packetStatus = "packetStatus"
        case id = "id"
        case nextApplyDate = "nextApplyDate"
        case discount = "discount"
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: connectedPackets_dataCodingKeys.self)
        
        packetName = try container.decode(String.self, forKey: .packetName)
        price = try container.decode(String.self, forKey: .price)
        unitType = try container.decode(Double.self, forKey: .unitType)
        packetStatus = try container.decode(Double.self, forKey: .packetStatus)
        id = try container.decode(Int.self, forKey: .id)
        
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
            period = try container.decode(String.self, forKey: .period)
        }
        catch {
            period = nil
        }
        
        do {
            nextApplyDate = try container.decode(String.self, forKey: .nextApplyDate)
        }
        catch {
            nextApplyDate = nil
        }
        
        do {
            discount = try container.decode(discount_data.self, forKey: .discount)
        }
        catch {
            discount = nil
        }
        
     
    }
}

extension details_data: Decodable {
    
    private enum details_dataCodingKeys: String, CodingKey {
        
        case unitId = "unitId"
        case now = "now"
        case start = "start"
        case unlimConditions = "unlimConditions"
        case unlim = "unlim"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: details_dataCodingKeys.self)
        
        unitId = try container.decode(Int.self, forKey: .unitId)
        now = try container.decode(Int.self, forKey: .now)
        start = try container.decode(Int.self, forKey: .start)
        unlim = try container.decode(Bool.self, forKey: .unlim)
        
        do {
            unlimConditions = try container.decode(unlimConditions_data.self, forKey: .unlimConditions)
        }
        catch {
            unlimConditions = nil
        }
    
        
     
    }
}
