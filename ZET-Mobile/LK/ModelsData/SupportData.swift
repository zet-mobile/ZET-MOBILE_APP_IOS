//
//  SupportData.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/03/22.
//

import Foundation

struct SupportData: Decodable {
    let support: [support_data]
    let offices: [offices_data]
}

struct support_data {
    let id: Int
    let description: String?
    let url: String
    let iconUrl: String
}

struct offices_data {
    let information: String?
    let title: String?
    let iconUrl: String
    let officeType: String?
    let latitude: String
    let longitude: String
    let officeTypeId: Int
}

extension offices_data: Decodable {
    
    private enum offices_dataCodingKeys: String, CodingKey {
        case information = "information"
        case title = "title"
        case iconUrl = "iconUrl"
        case officeType = "officeType"
        case latitude = "latitude"
        case longitude = "longitude"
        case officeTypeId = "officeTypeId"
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: offices_dataCodingKeys.self)
        
        do {
            information = try container.decode(String.self, forKey: .information)
        }
        catch {
            information = nil
        }
        do {
            title = try container.decode(String.self, forKey: .title)
        }
        catch {
            title = nil
        }
        do {
            officeType = try container.decode(String.self, forKey: .officeType)
        }
        catch {
            officeType = nil
        }
        iconUrl = try container.decode(String.self, forKey: .iconUrl)
        latitude = try container.decode(String.self, forKey: .latitude)
        longitude = try container.decode(String.self, forKey: .longitude)
        officeTypeId = try container.decode(Int.self, forKey: .officeTypeId)
    }
}

extension support_data: Decodable {
    
    private enum support_dataCodingKeys: String, CodingKey {
        case id = "id"
        case url = "url"
        case iconUrl = "iconUrl"
        case description = "description"
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy:support_dataCodingKeys.self)
     
        do {
            description = try container.decode(String.self, forKey: .description)
        }
        catch {
            description = nil
        }
        iconUrl = try container.decode(String.self, forKey: .iconUrl)
        url = try container.decode(String.self, forKey: .url)
        id = try container.decode(Int.self, forKey: .id)
    }
}
