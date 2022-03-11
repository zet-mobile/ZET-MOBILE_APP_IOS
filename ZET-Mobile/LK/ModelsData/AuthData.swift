//
//  AuthData.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 2/21/22.
//

import Foundation

struct AuthData {
    let hashString: String
    let code: Int
    let message: String
}

extension AuthData: Decodable {
    
    private enum AuthDataCodingKeys: String, CodingKey {
        case hashString = "hashString"
        case code = "code"
        case message = "message"
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AuthDataCodingKeys.self)
        hashString = try container.decode(String.self, forKey: .hashString)
        code = try container.decode(Int.self, forKey: .code)
        message = try container.decode(String.self, forKey: .message)
    }
}
