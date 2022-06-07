//
//  RequestObservable.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 2/21/22.
//

import Foundation
import RxSwift
import RxCocoa

//MARK: RequestObservable class
public class RequestObservable {
  private lazy var jsonDecoder = JSONDecoder()
  private var urlSession: URLSession
  public init(config:URLSessionConfiguration) {
      urlSession = URLSession(configuration:
                URLSessionConfiguration.default)
  }
//MARK: function for URLSession takes
  public func callAPI<ItemModel: Decodable>(request: URLRequest)
    -> Observable<ItemModel> {
  //MARK: creating our observable
  return Observable.create { observer in
  //MARK: create URLSession dataTask
  let task = self.urlSession.dataTask(with: request) { [self] (data,
                response, error) in
  if let httpResponse = response as? HTTPURLResponse{
  let statusCode = httpResponse.statusCode
  do {
    let _data = data ?? Data()
    if (200...399).contains(statusCode) {
      let objs = try self.jsonDecoder.decode(ItemModel.self, from:
                          _data)
      //MARK: observer onNext event
      observer.onNext(objs)
    }
      else if statusCode == 401 {
          refreshGetToken()
          print("new get token")
      }
    else {
      //observer.onError(error!)
    }
  } catch {
      
      //MARK: observer onNext event
      observer.onError(error)
     }
   }
     //MARK: observer onCompleted event
     observer.onCompleted()
   }
     task.resume()
     //MARK: return our disposable
     return Disposables.create {
       task.cancel()
     }
   }
  }
    
    func refreshGetToken() {
        print("i am here")
        let client = APIClient.shared
            do{
                try client.refreshToken().subscribe (
                onNext: { result in
                    print("hello")
                    DispatchQueue.main.async {
                        UserDefaults.standard.set("Bearer \(String(result.accessToken))", forKey: "token")
                        UserDefaults.standard.set("Bearer \(String(result.refreshToken))", forKey: "refresh_token")
                        
                    }
                },
                onError: { error in
                   
                   print(error.localizedDescription)
                },
                onCompleted: {
                   print("Completed event.")
                    DispatchQueue.main.async {
                        
                        
                        
                    }
                }).disposed(by: disposeBag)
              }
              catch{
                  
            }
       
    }
}
