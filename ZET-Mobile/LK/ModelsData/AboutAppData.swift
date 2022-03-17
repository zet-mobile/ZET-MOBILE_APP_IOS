//
//  AboutAppData.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/03/22.
//

import Foundation

struct AboutAppData: Decodable {
    let id: Int
    let title: String
    let description: String
    let url: String
    let iconUrl: String
}
