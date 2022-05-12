//
//  DetalizationData.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 07/04/22.
//

import Foundation

struct Detailing: Decodable {
    let minDaysCount: Int
    let maxDaysCount: Int
    let pricePerDay: Double
    let description: String
    let quantityLimit: Int
    let discountPercent: Double
}

struct DetailingHistory {
    let history: [history_detailing_data]?
}

struct history_detailing_data: Decodable {
    let date: String
    let histories: [histories_detailing_data]
}

struct histories_detailing_data: Decodable {
    let phoneNumber: String
    let status: String
    let email: String
    let dateFrom: String
    let dateTo: String
    let date: String
    let id: Int
    let price: Double
    let statusId: Int
}

extension DetailingHistory: Decodable {
    
    private enum DetailingHistoryCodingKeys: String, CodingKey {
        case history = "history"
        
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DetailingHistoryCodingKeys.self)
      
        do {
            history = try container.decode([history_detailing_data].self, forKey: .history)
        }
        catch {
            history = nil
        }
  
    
    }
}
