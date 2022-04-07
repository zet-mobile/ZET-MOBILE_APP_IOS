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

struct support_data: Decodable {
    let id: Int
    let description: String
    let url: String
    let iconUrl: String
}

struct offices_data: Decodable {
    let information: String
    let title: String
    let iconUrl: String
    let officeType: String
    let latitude: String
    let longitude: String
    let officeTypeId: Int
}
