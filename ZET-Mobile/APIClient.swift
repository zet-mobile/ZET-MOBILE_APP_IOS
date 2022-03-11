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
    
    func usageGetRequest() throws -> Observable<UsageData> {
        var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/consumptions/")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
     return requestObservable.callAPI(request: request)
   }
}
