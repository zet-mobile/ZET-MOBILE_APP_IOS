//
//  SettingsData.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/03/22.
//

import Foundation

struct SettingsData: Decodable {
    let appearance: [appearance_data]
    let languages: [languages_data]
    let notifications: notifications_data
}

struct appearance_data: Decodable {
    let themeId: Int
    let themeDescription: String
    let selected: Bool
}

struct languages_data: Decodable {
    let id: Int
    let selected: Bool
   // let title: String
    let description: String
}

struct notifications_data: Decodable {
    let promotionNotification: Bool
    let pushNotification: Bool
    let emailNotification: Bool
    let smsNotification: Bool
}
