//
//  AuthorizationViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 2/20/22.
//

import UIKit
import RxSwift
import RxCocoa

class AuthorizationViewController: UIViewController, UITextFieldDelegate {

    var halfModalTransitioningDelegate: HalfModalTransitioningDelegate?

    var auth_view = AuthorizationView()
    let disposeBag = DisposeBag()
    
    var user_phone = ""
    
    var minute = 01
    var seconds = 59
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        auth_view = AuthorizationView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        auth_view.get_sms.addTarget(self, action: #selector(get_Code_Request), for: .touchUpInside)
        auth_view.check_condition.addTarget(self, action: #selector(check_Condition), for: .touchUpInside)
        auth_view.lang_set.addTarget(self, action: #selector(chooseLanguage), for: .touchUpInside)
        auth_view.numberField.delegate = self
        auth_view.code_field.delegate = self
        auth_view.numberField.tag = 1
        auth_view.code_field.tag = 2
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openCondition))
        auth_view.title_condition.isUserInteractionEnabled = true
        auth_view.title_condition.addGestureRecognizer(tapGestureRecognizer)
        
        let tapSendAgain = UITapGestureRecognizer(target: self, action: #selector(sendAgain))
        auth_view.send_again.isUserInteractionEnabled = true
        auth_view.send_again.addGestureRecognizer(tapSendAgain)
    
        
        self.view.addSubview(auth_view)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            auth_view.numberField.text! = "+992 "
            auth_view.numberField.textColor = .black
            auth_view.numberField.font = UIFont.systemFont(ofSize: 15)
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField.tag == 1 {
            auth_view.numberField.text! = "992" + user_phone
            auth_view.numberField.textColor = .black
            auth_view.numberField.font = UIFont.systemFont(ofSize: 15)
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let tag = textField.tag
        
        user_phone = user_phone + string
        if string  == "" {
            if textField.tag == 1 {
                user_phone = (user_phone as String).substring(to: user_phone.index(before: user_phone.endIndex))
            }
        }
        
        if tag == 1 && string != "" && auth_view.numberField.text!.count == 14 {
            return false
        }
        
        
        if tag == 2 && string != "" && auth_view.code_field.text!.count == 6 {
            return false
        }
        
        
        return true
    }

    @objc func check_Condition() {
        
        if auth_view.get_sms.isEnabled == false {
          
            auth_view.check_condition.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
            auth_view.check_condition.setTitle("✓", for: .normal)
            auth_view.get_sms.isEnabled = true
            auth_view.get_sms.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
        }
        else {
            auth_view.check_condition.backgroundColor = .clear
            auth_view.check_condition.setTitle("", for: .normal)
            auth_view.get_sms.isEnabled = false
            auth_view.get_sms.backgroundColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
       }
    }
    
    @objc func openCondition() {
        let next = ConditionViewController()
        next.view.frame = (view.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)))
        self.halfModalTransitioningDelegate = HalfModalTransitioningDelegate(viewController: self, presentingViewController: next)
        next.modalPresentationStyle = .custom
        next.modalPresentationCapturesStatusBarAppearance = true
        
        next.transitioningDelegate = self.halfModalTransitioningDelegate
        present(next, animated: true, completion: nil)
    }
    
    @objc func chooseLanguage() {
        if auth_view.view_lang.isHidden == true {
            auth_view.view_lang.isHidden = false
        }
        else {
            auth_view.view_lang.isHidden = true
        }
        
        auth_view.ru_button.addTarget(self, action: #selector(ru_choosed), for: .touchUpInside)
        auth_view.eng_but.addTarget(self, action: #selector(en_choosed), for: .touchUpInside)
        auth_view.tj_but.addTarget(self, action: #selector(tj_choosed), for: .touchUpInside)
    }
    
    @objc func ru_choosed() {
        auth_view.lang_set.setTitle("RU 🇷🇺", for: .normal)
        auth_view.view_lang.isHidden = true
    }
    
    @objc func en_choosed() {
        auth_view.lang_set.setTitle("EN 🇺🇸", for: .normal)
        auth_view.view_lang.isHidden = true
    }
    
    @objc func tj_choosed() {
        auth_view.lang_set.setTitle("TJ 🇹🇯", for: .normal)
        auth_view.view_lang.isHidden = true
    }
    
    @objc func get_Code_Request() {
        
        print(user_phone)
        auth_view.title_info.isHidden = true
        auth_view.check_condition.isHidden = true
        auth_view.title_condition.isHidden = true
        
        auth_view.title_code_info.isHidden = true
        auth_view.send_again.isHidden = true
        
        auth_view.code_field.isHidden = false
        auth_view.time_symbol.isHidden = false
        auth_view.timer_label.isHidden = false
        auth_view.second_label.isHidden = false
        auth_view.symbol_label.isHidden = false
        auth_view.get_sms.setTitle("Подтвердить", for: .normal)
        auth_view.numberField.isEnabled = false
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
      
        let queryItems = [URLQueryItem(name: "ctn", value: "992919000944")]
        var urlComps = URLComponents(string: "http://app.zet-mobile.com:1481/v1/auth/from/outside")!
        urlComps.queryItems = queryItems
        let result = urlComps.url!
        
        var request = URLRequest(url: result)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField:
         "Content-Type")
        request.addValue("application/json", forHTTPHeaderField:
        "Accept")
        
        request.httpMethod = "POST"
                 
        let session = URLSession(configuration: URLSessionConfiguration.default)
           
        let task = session.dataTask(with: request) { (data, response, error) in
               
        if let data = data {
            do {
                   
            }  catch let error as NSError {
             
                print(error.localizedDescription)
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
            if let response = response {
                
                let httpStatus = response as! HTTPURLResponse
                   
                if httpStatus.statusCode == 200  {
                    DispatchQueue.main.async {

                    }
                }
                else {
                }
            }
        }
        task.resume()
        
      /*  let client = APIClient.shared
            do{
              try client.sendPost().subscribe(
                onNext: { result in
                    print("hello")
                   //MARK: display in UITableView
                },
                onError: { error in
                   print(error.localizedDescription)
                },
                onCompleted: {
                   print("Completed event.")
                }).disposed(by: disposeBag)
              }
              catch{
            }*/
        
        
        /*guard let window = UIApplication.shared.keyWindow else {
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
         */
     }
    
    @objc func updateTimer() {
        if seconds < 1 && minute != 0{
            minute -= 1
            seconds = 59
            auth_view.second_label.text = String(format: "%02d", seconds)
            auth_view.timer_label.text = "0" + String(minute)
        }
        else if seconds < 1 && minute < 1 {
            timer.invalidate()
            auth_view.send_again.isHidden = false
        } else {
            seconds -= 1
            auth_view.second_label.text = String(format: "%02d", seconds)
            }
        }
    
    
    @objc func sendAgain() {
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
}
