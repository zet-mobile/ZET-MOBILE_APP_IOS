//
//  CharhiIqbolMainDate.swift
//  ZET-Mobile
//
//  Created by iDev on 30/08/23.
//

import Foundation

struct MainData: Codable {
    let bannerURL: String
    let images: [Image]
    let presentCount: Double
    let present, presentTitle, presentDescription: String
    let price: Double
    let faqs: [FAQ]

    enum CodingKeys: String, CodingKey {
        case bannerURL = "bannerUrl"
        case images, presentCount, present, presentTitle, presentDescription, price, faqs
    }
}

// MARK: - FAQ
struct FAQ: Codable {
    let id: Int
    let question, answer: String
}

// MARK: - Image
struct Image: Codable {
    let name: String
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case name
        case imageURL = "imageUrl"
    }
}
