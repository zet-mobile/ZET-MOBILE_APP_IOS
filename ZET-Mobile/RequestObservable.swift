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
      else if statusCode == 401 && ItemModel.self != RefreshData.self {
         refreshGetToken()
      
          print("new get token")
      }
    else if statusCode == 401 && ItemModel.self == RefreshData.self {
        DispatchQueue.main.async {
            
            guard let window = UIApplication.shared.keyWindow else {
                return
            }
            guard let rootViewController = window.rootViewController else {
                return
            }
            let vc = UINavigationController(rootViewController: SplashViewController())
            vc.view.frame = rootViewController.view.frame
            vc.view.layoutIfNeeded()
            UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromLeft, animations: {
                window.rootViewController = vc
            }, completion: { completed in
                UserDefaults.standard.set("", forKey: "mobPhone")
                UserDefaults.standard.set(1, forKey: "language")
                UserDefaults.standard.set(LanguageType.ru.rawValue, forKey: "language_string")
                UserDefaults.standard.set("", forKey: "PinCode")
                UserDefaults.standard.set(true, forKey: "BiometricEnter")
                UserDefaults.standard.set("", forKey: "token")
                UserDefaults.standard.set("", forKey: "refresh_token")
            })
            
        }
      //observer.onError(error!)
    }
      else {
          
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
                        guard let window = UIApplication.shared.keyWindow else {
                           return
                        }

                        guard let rootViewController = window.rootViewController else {
                           return
                        }
                        let vc = ContainerViewController()
                        vc.view.frame = rootViewController.view.frame
                        vc.view.layoutIfNeeded()
                        UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromLeft, animations: {
                               window.rootViewController = vc
                         }, completion: nil)
                        
                    }
                },
                onError: { error in
                    
                    DispatchQueue.main.async {
                        
                        guard let window = UIApplication.shared.keyWindow else {
                            return
                        }
                        guard let rootViewController = window.rootViewController else {
                            return
                        }
                        let vc = UINavigationController(rootViewController: SplashViewController())
                        vc.view.frame = rootViewController.view.frame
                        vc.view.layoutIfNeeded()
                        UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromLeft, animations: {
                            window.rootViewController = vc
                        }, completion: { completed in
                            UserDefaults.standard.set("", forKey: "mobPhone")
                            UserDefaults.standard.set(1, forKey: "language")
                            UserDefaults.standard.set(LanguageType.ru.rawValue, forKey: "language_string")
                            UserDefaults.standard.set("", forKey: "PinCode")
                            UserDefaults.standard.set(true, forKey: "BiometricEnter")
                            UserDefaults.standard.set("", forKey: "token")
                            UserDefaults.standard.set("", forKey: "refresh_token")
                        })
                        
                    }
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
