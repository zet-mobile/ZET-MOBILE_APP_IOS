//
//  PacketsConnectData.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/03/22.
//

import Foundation

struct PostData {
    let success: Bool
    let message: String?
}

extension PostData: Decodable {
    
    private enum PostDataCodingKeys: String, CodingKey {
        case success = "success"
        case message = "message"
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PostDataCodingKeys.self)

        success = try container.decode(Bool.self, forKey: .success)
        do {
            message = try container.decode(String.self, forKey: .message)
        }
        catch {
            message = nil
        }
       
    }
}
