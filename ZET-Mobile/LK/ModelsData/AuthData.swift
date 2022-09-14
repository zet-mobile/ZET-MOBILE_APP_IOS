//
//  AuthData.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 2/21/22.
//

import Foundation

struct AuthData {
    let hashString: String?
    let success: Bool
    let message: String?
}

extension AuthData: Decodable {
    
    private enum AuthDataCodingKeys: String, CodingKey {
        case hashString = "hashString"
        case success = "success"
        case message = "message"
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AuthDataCodingKeys.self)
        do {
            hashString = try container.decode(String.self, forKey: .hashString)
        } catch {
            hashString = nil
        }
        
        success = try container.decode(Bool.self, forKey: .success)
        do {
            message = try container.decode(String.self, forKey: .message)
        } catch {
            message = nil
        }
    }
}

struct RefreshData: Decodable {
    let message: String
    let accessToken: String
    let refreshToken: String
    let success: Bool
}
