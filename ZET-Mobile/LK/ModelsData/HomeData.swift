//
//  HomeData.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 14/03/22.
//

import Foundation

struct HomeData {
    
    let prereg: Bool?
    let currentVersion: String?
    let welcomePhrase: String?
    let subscriberName: String?
    let mainBannerUrl: String?
    let subscriberBalance: Double?
    let subscriberCredit: Double?
    let notificationsCount: Int?
    let languageId: Int?
    let themeId: Int?
    let balances: balances_data?
    let priceplan: priceplan_data?
    let microServices: [microServices_data]?
    let offers: [offers_data]?
    let services: [services_data]?
}

struct priceplan_data {
    let priceplanName: String?
    let nextApplyDate: String?
}

struct microServices_data {
    let id: Int
    let iconUrl: String
    let microServiceName: String?
    let bannerUrl: String?
}

extension HomeData: Decodable {
    
    private enum HomeDataCodingKeys: String, CodingKey {
        
        case prereg = "prereg"
        case currentVersion = "currentVersion"
        case welcomePhrase = "welcomePhrase"
        case subscriberName = "subscriberName"
        case mainBannerUrl = "mainBannerUrl"
        case subscriberBalance = "subscriberBalance"
        case subscriberCredit = "subscriberCredit"
        case notificationsCount = "notificationsCount"
        case languageId = "languageId"
        case themeId = "themeId"
        case balances = "balances"
        case priceplan = "priceplan"
        case microServices = "microServices"
        case offers = "offers"
        case services = "services"
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: HomeDataCodingKeys.self)
        do {
            prereg = try container.decode(Bool.self, forKey: .prereg)
        }
        catch {
            prereg = nil
        }
        
        do {
            currentVersion = try container.decode(String.self, forKey: .currentVersion)
        }
        catch {
            currentVersion = nil
        }
       
        do {
            welcomePhrase = try container.decode(String.self, forKey: .welcomePhrase)
        }
        catch {
            welcomePhrase = nil
        }
        
        do {
            subscriberName = try container.decode(String.self, forKey: .subscriberName)
        }
        catch {
            subscriberName = nil
        }
        
        do {
            mainBannerUrl = try container.decode(String.self, forKey: .mainBannerUrl)
        }
        catch {
            mainBannerUrl = nil
        }
        
        do {
            subscriberBalance = try container.decode(Double.self, forKey: .subscriberBalance)
        }
        catch {
            subscriberBalance = nil
        }
        
        do {
            subscriberCredit = try container.decode(Double.self, forKey: .subscriberCredit)
        }
        catch {
            subscriberCredit = nil
        }
        
        do {
            notificationsCount = try container.decode(Int.self, forKey: .notificationsCount)
        }
        catch {
            notificationsCount = nil
        }
        
        do {
            languageId = try container.decode(Int.self, forKey: .languageId)
        }
        catch {
            languageId = nil
        }
        
        do {
            themeId = try container.decode(Int.self, forKey: .themeId)
        }
        catch {
            themeId = nil
        }
        
        do {
            balances = try container.decode(balances_data.self, forKey: .balances)
        }
        catch {
            balances = nil
        }
        
        do {
            priceplan = try container.decode(priceplan_data.self, forKey: .priceplan)
        }
        catch {
            priceplan = nil
        }
        
        do {
            microServices = try container.decode([microServices_data].self, forKey: .microServices)
        }
        catch {
            microServices = nil
        }
        
        do {
            offers = try container.decode([offers_data].self, forKey: .offers)
        }
        catch {
            offers = nil
        }
        
        do {
            services = try container.decode([services_data].self, forKey: .services)
        }
        catch {
            services = nil
        }
    }
}

extension microServices_data: Decodable {
    
    private enum microServices_dataCodingKeys: String, CodingKey {
        case id = "id"
        case iconUrl = "iconUrl"
        case microServiceName = "microServiceName"
        case bannerUrl = "bannerUrl"
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: microServices_dataCodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        iconUrl = try container.decode(String.self, forKey: .iconUrl)
        do {
            microServiceName = try container.decode(String.self, forKey: .microServiceName)
        }
        catch {
            microServiceName = nil
        }
        do {
            bannerUrl = try container.decode(String.self, forKey: .bannerUrl)
        }
        catch {
            bannerUrl = nil
        }
    }
}

extension priceplan_data: Decodable {
    
    private enum priceplan_dataCodingKeys: String, CodingKey {
        case priceplanName = "priceplanName"
        case nextApplyDate = "nextApplyDate"
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: priceplan_dataCodingKeys.self)
        do {
            priceplanName = try container.decode(String.self, forKey: .priceplanName)
        }
        catch {
            priceplanName = nil
        }
        do {
            nextApplyDate = try container.decode(String.self, forKey: .nextApplyDate)
        }
        catch {
            nextApplyDate = nil
        }
       
    }
}
