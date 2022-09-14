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

struct DetailingHistory: Decodable {
    let history: [history_detailing_data]
}

struct history_detailing_data: Decodable {
    let date: String
    let histories: [histories_detailing_data]
}

struct histories_detailing_data {
    let phoneNumber: String
    let status: String
    let email: String
    let dateFrom: String?
    let dateTo: String?
    let date: String
    let id: Int
    let price: Double
    let statusId: Int
}

extension histories_detailing_data: Decodable {
    
    private enum DetailingHistoryCodingKeys: String, CodingKey {
        case dateFrom = "dateFrom"
        case dateTo = "dateTo"
        case phoneNumber = "phoneNumber"
        case status = "status"
        case email = "email"
        case date = "date"
        case id = "id"
        case price = "price"
        case statusId = "statusId"
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DetailingHistoryCodingKeys.self)
      
        
        do {
            dateFrom = try container.decode(String.self, forKey: .dateFrom)
        }
        catch {
            dateFrom = nil
        }
        
        do {
            dateTo = try container.decode(String.self, forKey: .dateTo)
        }
        catch {
            dateTo = nil
        }
  
        phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        status = try container.decode(String.self, forKey: .status)
        email = try container.decode(String.self, forKey: .email)
        date = try container.decode(String.self, forKey: .date)
        id = try container.decode(Int.self, forKey: .id)
        price = try container.decode(Double.self, forKey: .price)
        statusId = try container.decode(Int.self, forKey: .statusId)
    
    }
}
