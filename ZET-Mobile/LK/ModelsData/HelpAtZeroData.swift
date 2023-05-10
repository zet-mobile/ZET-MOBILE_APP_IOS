//
//  HelpAtZeroData.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 31/05/22.
//

import Foundation

struct HelpAtZeroData {
    let message: String
    let balance: Double
    let lifetime: Int
    let description: String
    let arpu: Double
    let code: Int
    let success: Bool
    let packets: [packets_data]?
    let remainders: remainders_data?
}

struct packets_data: Decodable {
    let packet_tax: Double
    let packet_sum: Double
    let packet_amount: Double
    let packet_name: String
    let packet_id: Int
}

struct remainders_data: Decodable {
    let remaind_sum_amount: Double
    let remaind_credit_amount: Double
    let remaind_tax_amount: Double
    let packet_name: String
    let created_at: String
}

struct HelpAtZeroPostData {
    let message: String?
    let description: String?
    let code: Int
    let success: Bool
 
}

struct HelpAtZeroHistoryData {
    let history: [history_help_data]?
}

struct history_help_data: Decodable {
    let date: String
    let histories: [histories_help_data]
}

struct histories_help_data: Decodable {
    let packet_tax: Double
    let packet_sum: Double
    let packet_amount: Double
    let credit_id: Int
    let remaind_sum_amount: Double
    let remaind_tax_amount: Double
    let remaind_credit_amount: Double
    let is_repayment: Bool
    let packet_name: String
    let created_at: String
}


struct HelpAtZeroHistoryDataD {
    let history: [history_help_dataD]?
}

struct history_help_dataD: Decodable {
    let date: String
    let histories: [histories_help_dataD]
}

struct histories_help_dataD: Decodable {
    let repayment_sum_amount: Double
    let repayment_tax_amount: Double
    let repayment_credit_amount: Double
    let remaind_sum_amount: Double
    let remaind_tax_amount: Double
    let remaind_credit_amount: Double
    let created_at: String
}


extension HelpAtZeroData: Decodable {
    
    private enum HelpAtZeroDataCodingKeys: String, CodingKey {
        case message = "message"
        case balance = "balance"
        case lifetime = "lifetime"
        case description = "description"
        case arpu = "arpu"
        case code = "code"
        case success = "success"
        case packets = "packets"
        case remainders = "remainders"
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: HelpAtZeroDataCodingKeys.self)
      
        message = try container.decode(String.self, forKey: .message)
        balance = try container.decode(Double.self, forKey: .balance)
        lifetime = try container.decode(Int.self, forKey: .lifetime)
        description = try container.decode(String.self, forKey: .description)
        arpu = try container.decode(Double.self, forKey: .arpu)
        code = try container.decode(Int.self, forKey: .code)
        success = try container.decode(Bool.self, forKey: .success)
        
        do {
            packets = try container.decode([packets_data].self, forKey: .packets)
        }
        catch {
            packets = nil
        }
  
        do {
            remainders = try container.decode(remainders_data.self, forKey: .remainders)
        }
        catch {
            remainders = nil
        }
        
    }
}

extension HelpAtZeroHistoryData: Decodable {
    
    private enum HelpAtZeroHistoryDataCodingKeys: String, CodingKey {
        case history = "history"
        
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: HelpAtZeroHistoryDataCodingKeys.self)
      
        do {
            history = try container.decode([history_help_data].self, forKey: .history)
        }
        catch {
            history = nil
        }
  
    
    }
}

extension HelpAtZeroHistoryDataD: Decodable {
    
    private enum HelpAtZeroHistoryDataCodingKeys: String, CodingKey {
        case history = "history"
        
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: HelpAtZeroHistoryDataCodingKeys.self)
      
        do {
            history = try container.decode([history_help_dataD].self, forKey: .history)
        }
        catch {
            history = nil
        }
  
    
    }
}


extension HelpAtZeroPostData: Decodable {
    
    private enum HelpAtZeroPostDataCodingKeys: String, CodingKey {
        case message = "message"
        case description = "description"
        case code = "code"
        case success = "success"
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: HelpAtZeroPostDataCodingKeys.self)
      
        do {
            message = try container.decode(String.self, forKey: .message)
        }
        catch {
            message = nil
        }
        
        do {
            description = try container.decode(String.self, forKey: .description)
        }
        catch {
            description = nil
        }
        
        code = try container.decode(Int.self, forKey: .code)
        success = try container.decode(Bool.self, forKey: .success)
        
    }
}
