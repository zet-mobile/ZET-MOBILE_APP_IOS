//
//  CheckCodeData.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 06/03/22.
//

import Foundation

struct CheckCodeData {
    let message: String?
    let accessToken: String?
    let refreshToken: String?
    let success: Bool
}

extension CheckCodeData: Decodable {
    
    private enum CheckCodeDataCodingKeys: String, CodingKey {
        case message = "message"
        case accessToken = "accessToken"
        case refreshToken = "refreshToken"
        case success = "success"
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CheckCodeDataCodingKeys.self)
        do {
            message = try container.decode(String.self, forKey: .message)
        } catch {
            message = nil
        }
        
        do {
            accessToken = try container.decode(String.self, forKey: .accessToken)
        } catch {
            accessToken = nil
        }
        
        do {
            refreshToken = try container.decode(String.self, forKey: .refreshToken)
        } catch {
            refreshToken = nil
        }
        
        success = try container.decode(Bool.self, forKey: .success)
    }
}
