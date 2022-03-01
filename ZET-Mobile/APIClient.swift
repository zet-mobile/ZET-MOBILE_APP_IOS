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
    
  func getRecipes() throws -> Observable<[AuthData]> {
    var request = URLRequest(url:
          URL(string:"https://jsonplaceholder.typicode.com/posts")!)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField:
              "Content-Type")
    return requestObservable.callAPI(request: request)
  }
  
  func sendPost() -> Observable<AuthData> {
    /*let queryItems = [URLQueryItem(name: "ctn", value: "992919110474")]
    var urlComps = URLComponents(string: "http://app.zet-mobile.com:1481/v1/auth/from/outside")!
    urlComps.queryItems = queryItems
    let result = urlComps.url!
    let url = result*/
    
     var request = URLRequest(url: URL(string: "http://app.zet-mobile.com:1481/v1/auth/from/outside")!)
     request.httpMethod = "POST"
     request.addValue("application/json", forHTTPHeaderField:
      "Content-Type")
     request.addValue("application/json", forHTTPHeaderField:
     "Accept")
     //let body: [String: AnyHashable] = ["ctn" = "992919000944"]
     //request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
     return requestObservable.callAPI(request: request)
   }
}
