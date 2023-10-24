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
    var alert = UIAlertController()
      var tabIndicator = "0"
    
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
//          if tabIndicator == "0"
//           {
//              refreshGetToken()
//           }
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
                //UserDefaults.standard.set(true, forKey: "BiometricEnter")
                UserDefaults.standard.set("", forKey: "token")
                UserDefaults.standard.set("", forKey: "refresh_token")
            })
            
        }
      //observer.onError(error!)
    }
      else {
          self.requestAnswer(message: defaultLocalizer.stringForKey(key: "service is temporarily unavailable"))
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
         if task.error?.localizedDescription != nil {
             self.requestAnswer(message: defaultLocalizer.stringForKey(key: "service is temporarily unavailable"))
         }
       
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
                            defaultLocalizer.setSelectedLanguage(lang: .ru)
                            
                            UserDefaults.standard.set("", forKey: "PinCode")
                            //UserDefaults.standard.set(true, forKey: "BiometricEnter")
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
    
    @objc func requestAnswer(message: String) {
       
        alert = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n\n", message: "", preferredStyle: .alert)
        let widthConstraints = alert.view.constraints.filter({ return $0.firstAttribute == .width })
        alert.view.removeConstraints(widthConstraints)
        // Here you can enter any width that you want
        let newWidth = UIScreen.main.bounds.width * 0.90
        // Adding constraint for alert base view
        let widthConstraint = NSLayoutConstraint(item: alert.view,
                                                     attribute: .width,
                                                     relatedBy: .equal,
                                                     toItem: nil,
                                                     attribute: .notAnAttribute,
                                                     multiplier: 1,
                                                     constant: newWidth)
        alert.view.addConstraint(widthConstraint)
        
        let view = AlertView()

        view.backgroundColor = alertColor
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 40, height: 350)
        view.layer.cornerRadius = 20
        view.name.text = defaultLocalizer.stringForKey(key: "error_title")
        view.image_icon.image = UIImage(named: "uncorrect_alert")
      
        view.name_content.text = "\(message)"
        view.ok.setTitle("OK", for: .normal)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissDialog))
        view.name.isUserInteractionEnabled = true
        view.name.addGestureRecognizer(tapGestureRecognizer)
        
        view.cancel.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
        view.ok.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
        
        alert.view.backgroundColor = .clear
        alert.view.addSubview(view)
        //alert.view.sendSubviewToBack(view)
        
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        guard let rootViewController = window.rootViewController else {
            return
        }
        
        DispatchQueue.main.async { [self] in
            rootViewController.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @objc func dismissDialog() {
        print("hellojljljjjl")
        //alert.dismiss(animated: true, completion: nil)
        
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        guard let rootViewController = window.rootViewController else {
            return
        }
        DispatchQueue.main.async { [self] in
            rootViewController.dismiss(animated: true)
            
        }
    }
}

