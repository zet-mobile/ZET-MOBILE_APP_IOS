//
//  FeedbackData.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 14/05/22.
//

import Foundation

struct FeedbackData: Decodable {
    let feedback: [feedback_data]
}

struct feedback_data: Decodable {
    let id: Int
    let supportEmail: String
    let messageSubject: String
}
