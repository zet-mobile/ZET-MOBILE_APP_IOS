//
//  RoumingData.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/03/22.
//

import Foundation

struct RoumingData: Decodable {
    let questions: [questions_data]
    let countries: [countries_data]
}

struct questions_data: Decodable {
    let id: Int
    let question: String
    let answer: String
}

struct countries_data: Decodable {
    let id: Int
    let countryName: String
    let iconUrl: String
}
