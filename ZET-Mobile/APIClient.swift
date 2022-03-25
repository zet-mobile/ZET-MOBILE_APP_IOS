//
//  APIClient.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 2/21/22.
//

import Foundation
import RxCocoa
import RxSwift

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
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/packets/")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody)
        request.httpMethod = "POST"
        request.httpBody = jsonData
     return requestObservable.callAPI(request: request)
    }
    
    // Disable packet
    func disableConnect(jsonBody: [String: Any]) -> Observable<PostData> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/packets/")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody)
        request.httpMethod = "DELETE"
        request.httpBody = jsonData
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
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/services" + "&\(parametr)")!)
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
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/roiming")!)
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
    
}


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
