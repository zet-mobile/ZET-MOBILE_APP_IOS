//
//  NotificationsData.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 10/06/22.
//

import Foundation

struct NotificationData {
    let notifications: [notification_data]?
}

struct notification_data: Decodable {
    let id: Int
    let title: String
    // body: String
    let image: String
    let icon: String
    let statusId: Int
    //let service: service_data
}

struct service_data: Decodable {
    let serviceName: String
    let iconUrl: String
    let description: String
    let priceAndPeriod: String
    let price: String
    let period: String
    let id: Int
    let discount: discount_data
}

extension NotificationData: Decodable {
    
    private enum offices_dataCodingKeys: String, CodingKey {
        case notifications = "notifications"
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: offices_dataCodingKeys.self)
        
        do {
            notifications = try container.decode([notification_data].self, forKey: .notifications)
        }
        catch {
            notifications = nil
        }
       
    }
}
