//
//  UsadeData.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 07/03/22.
//

import Foundation

struct UsageData {
    let lastDay: last_data?
    let lastWeek: last_data?
    let lastMonth: last_data?
    let history: [history_data]?
}

struct last_data {
    let offnetMin: Double?
    let onnetMin: Double?
    let internetMb: Double?
    let sms: Double?
    let tjs: Double?
}

struct history_data {
    let serviceName: String?
    let balanceChange: String?
    let transactionDate: String?
}

extension UsageData: Decodable {
    
    private enum UsageDataCodingKeys: String, CodingKey {
        case lastDay = "lastDay"
        case lastWeek = "lastWeek"
        case lastMonth = "lastMonth"
        case history = "history"
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UsageDataCodingKeys.self)

        do {
            lastDay = try container.decode(last_data.self, forKey: .lastDay)
        } catch {
            lastDay = nil
        }
        
        do {
            lastWeek = try container.decode(last_data.self, forKey: .lastWeek)
        } catch {
            lastWeek = nil
        }
        
        do {
            lastMonth = try container.decode(last_data.self, forKey: .lastMonth)
        } catch {
            lastMonth = nil
        }
        
        do {
            history = try container.decode([history_data].self, forKey: .history)
        } catch {
            history = nil
        }
    }
}

extension last_data: Decodable {
    
    private enum last_dataCodingKeys: String, CodingKey {
        case offnetMin = "offnetMin"
        case onnetMin = "onnetMin"
        case internetMb = "internetMb"
        case sms = "sms"
        case tjs = "tjs"
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: last_dataCodingKeys.self)
        do {
            offnetMin = try container.decode(Double.self, forKey: .offnetMin)
        } catch {
            offnetMin = nil
        }
        
        do {
            onnetMin = try container.decode(Double.self, forKey: .onnetMin)
        } catch {
            onnetMin = nil
        }
        
        do {
            internetMb = try container.decode(Double.self, forKey: .internetMb)
        } catch {
            internetMb = nil
        }
        
        do {
            sms = try container.decode(Double.self, forKey: .sms)
        } catch {
            sms = nil
        }
        
        do {
            tjs = try container.decode(Double.self, forKey: .tjs)
        } catch {
            tjs = nil
        }
    }
}

extension history_data: Decodable {
    
    private enum history_dataCodingKeys: String, CodingKey {
        case serviceName = "serviceName"
        case balanceChange = "balanceChange"
        case transactionDate = "transactionDate"
       
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: history_dataCodingKeys.self)
        do {
            serviceName = try container.decode(String.self, forKey: .serviceName)
        } catch {
            serviceName = nil
        }
        
        do {
            balanceChange = try container.decode(String.self, forKey: .balanceChange)
        } catch {
            balanceChange = nil
        }
        
        do {
            transactionDate = try container.decode(String.self, forKey: .transactionDate)
        } catch {
            transactionDate = nil
        }
    }
}
