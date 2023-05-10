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

struct notification_data {
    let id: Int
    let notificationId: Int
    let title: String?
    let body: String?
    let shortDescription: String?
    let image: String?
    let icon: String?
    let statusId: Int
    let service: service_data?
}

struct service_data {
    let serviceName: String?
    let iconUrl: String?
    let description: String?
    let priceAndPeriod: String?
    let price: String?
    let period: String?
    let id: Int
    let discount: discount_data?
}

extension NotificationData: Decodable {
    
    private enum NotificationDataCodingKeys: String, CodingKey {
        case notifications = "notifications"
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: NotificationDataCodingKeys.self)
        
        do {
            notifications = try container.decode([notification_data].self, forKey: .notifications)
        }
        catch {
            notifications = nil
        }
       
    }
}

extension notification_data: Decodable {
    
    private enum notification_dataCodingKeys: String, CodingKey {
        case id = "id"
        case notificationId = "notificationId"
        case title = "title"
        case body = "body"
        case shortDescription  = "shortDescription"
        case image = "image"
        case icon = "icon"
        case statusId = "statusId"
        case service = "service"
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: notification_dataCodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        notificationId = try container.decode(Int.self, forKey: .notificationId)
        
        do {
            title = try container.decode(String.self, forKey: .title)
        }
        catch {
            title = nil
        }
       
        do {
            body = try container.decode(String.self, forKey: .body)
        }
        catch {
            body = nil
        }
        
        do {
            shortDescription = try container.decode(String.self, forKey: .shortDescription)
        }
        catch {
            shortDescription = nil
        }
        
        do {
            image = try container.decode(String.self, forKey: .image)
        }
        catch {
            image = nil
        }
        
        do {
            icon = try container.decode(String.self, forKey: .icon)
        }
        catch {
            icon = nil
        }
        
        statusId = try container.decode(Int.self, forKey: .statusId)
        
        do {
            service = try container.decode(service_data.self, forKey: .service)
        }
        catch {
            service = nil
        }
        
    }
}

extension service_data: Decodable {
    
    private enum service_dataCodingKeys: String, CodingKey {
        case serviceName = "serviceName"
        case iconUrl = "iconUrl"
        case description = "description"
        case priceAndPeriod  = "priceAndPeriod"
        case price = "price"
        case period = "period"
        case id = "id"
        case discount = "discount"
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: service_dataCodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        
        do {
            serviceName = try container.decode(String.self, forKey: .serviceName)
        }
        catch {
            serviceName = nil
        }
       
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
            priceAndPeriod = try container.decode(String.self, forKey: .priceAndPeriod)
        }
        catch {
            priceAndPeriod = nil
        }
        
        do {
            price = try container.decode(String.self, forKey: .price)
        }
        catch {
            price = nil
        }
        
        do {
            period = try container.decode(String.self, forKey: .period)
        }
        catch {
            period = nil
        }
        do {
            discount = try container.decode(discount_data.self, forKey: .discount)
        }
        catch {
            discount = nil
        }

    }
}
