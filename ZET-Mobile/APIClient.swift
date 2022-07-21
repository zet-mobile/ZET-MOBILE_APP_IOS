//
//  APIClient.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 2/21/22.
//

import Foundation
import RxCocoa
import RxSwift
import Alamofire

struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = "imagefile.jpg"
        guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
        self.data = data
    }
}

//MARK: extension for converting out RecipeModel to jsonObject
fileprivate extension Encodable {
  var dictionaryValue:[String: Any?]? {
      guard let data = try? JSONEncoder().encode(self),
      let dictionary = try? JSONSerialization.jsonObject(with: data,
        options: .allowFragments) as? [String: Any] else {
      return nil
    }
    return dictionary
  }
}

class APIClient {
  static var shared = APIClient()
  lazy var requestObservable = RequestObservable(config: .default)
    
    func authPost(jsonBody: [String: Any]) -> Observable<AuthData> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/auth/from/outside")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
     return requestObservable.callAPI(request: request)
    }

    func checkSmsCode(jsonBody: [String: Any]) -> Observable<CheckCodeData> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/auth/login")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody)
        request.httpMethod = "POST"
        request.httpBody = jsonData
     return requestObservable.callAPI(request: request)
    }
    
    func refreshToken() -> Observable<RefreshData> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/auth/get/refresh")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "refresh_token")!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return requestObservable.callAPI(request: request)
    }
    
    func logout() -> Observable<PostData> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/auth/logout")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
     return requestObservable.callAPI(request: request)
    }
    
    //  Get information about main page.
    func homeGetRequest() throws -> Observable<HomeData> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/main")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
     return requestObservable.callAPI(request: request)
    }
    
    // Get information about subscriber consumptions and last 5 charges from main balance.
    func usageGetRequest() throws -> Observable<UsageData> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/consumptions/")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
     return requestObservable.callAPI(request: request)
    }
    
    // Get information about packets
    func packetsGetRequest() throws -> Observable<PacketsData> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/packets/")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
     return requestObservable.callAPI(request: request)
    }
    
    // Connect packet
    func packetConnect(jsonBody: [String: Any]) -> Observable<PostData> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/packets/connect")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody)
        request.httpMethod = "POST"
        request.httpBody = jsonData
     return requestObservable.callAPI(request: request)
    }
    
    // Disable packet
    func disableConnect(parametr: String) -> Observable<PostData> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/packets/\(parametr)")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "DELETE"
     return requestObservable.callAPI(request: request)
    }
    
    // Get information about subscriber priceplana nd available priceplans.
    func pricePlansGetRequest() throws -> Observable<PricePlansData> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/priceplans")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
     return requestObservable.callAPI(request: request)
    }
    
    // Get information about subscriber priceplana nd available priceplans.
    func pricePlanIDGetRequest(parametr: String) throws -> Observable<PricePlansIDData> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/priceplans/" + "\(parametr)")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
     return requestObservable.callAPI(request: request)
    }
    
    // Change subscriber priceplan
    func changePricepPlan(jsonBody: [String: Any]) -> Observable<PostData> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/priceplans/change")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody)
        request.httpMethod = "POST"
        request.httpBody = jsonData
     return requestObservable.callAPI(request: request)
    }
    
    // Connect any service to subscriber.
    func connectService(jsonBody: [String: Any]) -> Observable<PostData> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/services/connect")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody)
        request.httpMethod = "POST"
        request.httpBody = jsonData
     return requestObservable.callAPI(request: request)
    }
    
    // Disable any service to subscriber.
    func disableService(parametr: String) -> Observable<PostData> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/services/" + "\(parametr)")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "DELETE"
     return requestObservable.callAPI(request: request)
    }
    
    // Get information about services.
    func servicesGetRequest() throws -> Observable<ServicesData> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/services")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
     return requestObservable.callAPI(request: request)
    }
    
    // Get information about application.
    func aboutGetRequest() throws -> Observable<AboutAppData> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/about")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("IOS", forHTTPHeaderField: "Device")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
     return requestObservable.callAPI(request: request)
    }
    
    // Get information about roaming.
    func roumingGetRequest() throws -> Observable<RoumingData> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/roaming")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
     return requestObservable.callAPI(request: request)
    }
    
    // Get information about roaming country operators and charges.
    func roamingCountriesGetRequest(parametr: String) throws -> Observable<RoumingCountryData> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/roaming/countries" + "&\(parametr)")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
     return requestObservable.callAPI(request: request)
    }
    
    // Get information about our support
    func supportGetRequest() throws -> Observable<SupportData> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/support")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
     return requestObservable.callAPI(request: request)
    }
    
    // Get settings information
    func settingsGetRequest() throws -> Observable<SettingsData> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/settings")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
     return requestObservable.callAPI(request: request)
    }
    
    // Change settings information
    func settingsPutRequest(jsonBody: [String: Any]) -> Observable<PostData> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/settings/")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody)
        request.httpMethod = "PUT"
        request.httpBody = jsonData
     return requestObservable.callAPI(request: request)
    }
    
    // get history of traffic transfer transactions.
    func transferHistoryRequest() -> Observable<TransferDataHistory> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/transfer/history")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
     return requestObservable.callAPI(request: request)
    }
    
    //  get settings of traffic transfer system.
    func getTransferRequest() -> Observable<TransferData> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/transfer/")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
     return requestObservable.callAPI(request: request)
    }
    
    //for detail information history.
    func transferHistoryIdRequest(parametr: String) -> Observable<histories_data> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/transfer/history/" + "\(parametr)")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
     return requestObservable.callAPI(request: request)
    }
    
    // for translate traffic.
    func transferPostRequest(jsonBody: [String: Any]) -> Observable<PostData> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/transfer/")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody)
        request.httpMethod = "POST"
        request.httpBody = jsonData
     return requestObservable.callAPI(request: request)
    }
    
    // get history of traffic exchange transactions.
    func exchangeHistoryRequest() -> Observable<ExchangeDataHistory> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/exchange/history")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
     return requestObservable.callAPI(request: request)
    }
    
    //  get settings of exchange transfer system.
    func getExchangeRequest() -> Observable<ExchangeData> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/exchange/")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
     return requestObservable.callAPI(request: request)
    }
    
    //for detail information history.
    func exchangeHistoryIdRequest(parametr: String) -> Observable<histories_exchange_data> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/exchange/history/" + "\(parametr)")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
     return requestObservable.callAPI(request: request)
    }
    
    // for translate exchange.
    func exchangePutRequest(jsonBody: [String: Any]) -> Observable<PostData> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/exchange")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody)
        request.httpMethod = "POST"
        request.httpBody = jsonData
     return requestObservable.callAPI(request: request)
    }
    
    // for get history of money transfer transactions.
    func moneyHistoryRequest() -> Observable<MoneyTransferDataHistory> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/money/transfer/history")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
     return requestObservable.callAPI(request: request)
    }
    
    //  get settings of exchange transfer system.
    func getMoneyRequest() -> Observable<MoneyTransferData> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/money/transfer/")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
     return requestObservable.callAPI(request: request)
    }
    
    //for detail information history.
    func moneyHistoryIdRequest(parametr: String) -> Observable<histories_money_data> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/money/transfer/history/" + "\(parametr)")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
     return requestObservable.callAPI(request: request)
    }
    
    // for translate exchange.
    func moneyPutRequest(jsonBody: [String: Any]) -> Observable<PostData> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/money/transfer")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody)
        request.httpMethod = "POST"
        request.httpBody = jsonData
     return requestObservable.callAPI(request: request)
    }
    
    //  get history of detailing order transactions.
    func detailingHistoryRequest() -> Observable<DetailingHistory> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/detailing/history")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
     return requestObservable.callAPI(request: request)
    }
    
    //  get settings of exchange transfer system.
    func getDetailingyRequest() -> Observable<Detailing> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/detailing/")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
     return requestObservable.callAPI(request: request)
    }
    
    // for translate detailing.
    func detailingPutRequest(jsonBody: [String: Any]) -> Observable<PostData> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/detailing")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody)
        request.httpMethod = "PUT"
        request.httpBody = jsonData
     return requestObservable.callAPI(request: request)
    }
    
    //  get ask money
    func getAskMoneyRequest() -> Observable<AskMoneyData> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/money/ask/")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
     return requestObservable.callAPI(request: request)
    }
    
    //  post money ask
    func postMoneyAskRequest(jsonBody: [String: Any]) -> Observable<PostData> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/money/ask/")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody)
        request.httpBody = jsonData
     return requestObservable.callAPI(request: request)
    }
    
    //  This is api for get info about available credit packets.
    func getCreditRequest() -> Observable<HelpAtZeroData> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/credit/")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
     return requestObservable.callAPI(request: request)
    }
    
    //  This is api for get info about available credit packets.
    func getCreditHistoryRequest() -> Observable<HelpAtZeroHistoryData> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/credit/history/")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
     return requestObservable.callAPI(request: request)
    }
    
    //  post money ask
    func postCreditRequestID(parametr: String) -> Observable<HelpAtZeroPostData> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/credit/" + "\(parametr)")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
     return requestObservable.callAPI(request: request)
    }
    
    //  post money ask
    func postCreditRequest() -> Observable<HelpAtZeroPostData> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/credit/refusal/")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
     return requestObservable.callAPI(request: request)
    }
    
    //  This is api for get info about notifications
    func getNotificationRequest() -> Observable<NotificationData> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/notifications/")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
     return requestObservable.callAPI(request: request)
    }
    
    //  This is api for post notification
    func postNotificationRequest(parametr: String) -> Observable<PostData> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/notifications/" + "\(parametr)")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
     return requestObservable.callAPI(request: request)
    }
    
    //  This is api for delete notification
    func deleteNotificationRequest(parametr: String) -> Observable<PostData> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/notifications/" + "\(parametr)")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "DELETE"
     return requestObservable.callAPI(request: request)
    }
    
    //  get feedbackData
    func getFeedBackRequest() -> Observable<FeedbackData> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/feedback/")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
     return requestObservable.callAPI(request: request)
    }
    
    //  post feedbackData
    func postFeedBackRequest(jsonBody: [String: Any], mediaImage: [Media]) -> Observable<PostData> {
        
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/feedback/")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        let boundary = generateBoundary()
           //set content type
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
           //call createDataBody method
        let dataBody = createDataBody(withParameters: jsonBody, media: mediaImage, boundary: boundary)
        request.httpBody = dataBody

     return requestObservable.callAPI(request: request)
    }
    
    func createDataBody(withParameters params: Parameters?, media: [Media]?, boundary: String) -> Data {
       let lineBreak = "\r\n"
       var body = Data()
       if let parameters = params {
          for (key, value) in parameters {
             body.append("--\(boundary + lineBreak)")
             body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
             body.append("\(value)")
             body.append(lineBreak)
          }
       }
       if let media = media {
          for photo in media {
             body.append("--\(boundary + lineBreak)")
             body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
             body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
             body.append(photo.data)
             body.append(lineBreak)
          }
       }
       body.append("--\(boundary)--\(lineBreak)")
       return body
    }
    
    func generateBoundary() -> String {
       return "Boundary-\(NSUUID().uuidString)"
    }
    

}

extension Data {
   mutating func append(_ string: String) {
      if let data = string.data(using: .utf8) {
         append(data)
         print("data======>>>",data)
      }
   }
}

let disposeBag = DisposeBag()

extension UIViewController {
    func open(scheme: String) {
        if let url = URL(string: scheme) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                                            
                })
            } else {
                let success = UIApplication.shared.openURL(url)
            }
        }
    }
    
}
