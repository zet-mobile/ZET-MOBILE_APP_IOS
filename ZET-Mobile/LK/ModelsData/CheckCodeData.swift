//
//  CheckCodeData.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 06/03/22.
//

import Foundation

struct CheckCodeData {
    let ctn: String
    let accessToken: String?
    let refreshToken: String
}

extension CheckCodeData: Decodable {
    
    private enum CheckCodeDataCodingKeys: String, CodingKey {
        case ctn = "ctn"
        case accessToken = "accessToken"
        case refreshToken = "refreshToken"
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CheckCodeDataCodingKeys.self)
        ctn = try container.decode(String.self, forKey: .ctn)
        do {
            accessToken = try container.decode(String.self, forKey: .accessToken)
        } catch {
            accessToken = nil
        }
        refreshToken = try container.decode(String.self, forKey: .refreshToken)
    }
}
