//
//  AuthorizationViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 2/20/22.
//

import UIKit
import RxSwift
import RxCocoa
import Toast_Swift

var style = ToastStyle()

class AuthorizationViewController: UIViewController, UITextFieldDelegate {

    var halfModalTransitioningDelegate: HalfModalTransitioningDelegate?

    var auth_view = AuthorizationView()
    let disposeBag = DisposeBag()
    
    var user_phone = ""
    
    var minute = 01
    var seconds = 59
    
    var timer = Timer()
    var user_code = ""
    var secretCode = ""
    var hashString = ""
    var accessToken = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        auth_view = AuthorizationView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        auth_view.get_sms.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
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

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
        else if textField.tag == 2 {
            auth_view.code_field.text! = ""
            auth_view.code_field.textColor = .black
            auth_view.code_field.font = UIFont.systemFont(ofSize: 15)
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField.tag == 1 {
            auth_view.numberField.text! = "992" + user_phone
            auth_view.numberField.textColor = .black
            auth_view.numberField.font = UIFont.systemFont(ofSize: 15)
        }
        else if textField.tag == 2 {
           // auth_view.code_field.text! = user_code
            //auth_view.code_field.textColor = .black
            //auth_view.code_field.font = UIFont.systemFont(ofSize: 15)
        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        auth_view.numberField.resignFirstResponder()
        auth_view.code_field.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let tag = textField.tag
        
        if string  == "" {
            if tag == 1 {
                user_phone = (user_phone as String).substring(to: user_phone.index(before: user_phone.endIndex))
            }
            else {
                user_code = (user_code as String).substring(to: user_code.index(before: user_code.endIndex))
            }
        }
        
        if tag == 1 && string != "" && auth_view.numberField.text!.count == 14 {
            return false
        }
        else if tag == 1 {
            user_phone = user_phone + string
            print(user_phone)
        }
        
        
        if tag == 2 && string != "" && auth_view.code_field.text!.count == 6 {
            return false
        }
        else if tag == 2 {
            user_code = user_code + string
            print(user_code)
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
    
    @objc func buttonClick() {
        if user_code == "" {
            print(user_phone)
            let length = user_phone.count
            let str = user_phone.prefix(3)
            let str2 = user_phone.prefix(2)
            
            if Int(user_phone) == nil || length < 9 {
              self.view.makeToast("Ошибка, введите номер", duration: 5.0, position: .bottom, style: style); return
             }
            else
             if str == "911" || str == "915" || str == "917" || str == "919" || str2 == "80" || str2 == "40" {
                 print("i am here")
              get_Code_Request()
            }
            else {
              self.view.makeToast("Введите номер Zet - Mobile", duration: 3.0, position: .bottom, style: style); return
            }
        }
        else {
            checkCode()
        }
    }
    
    @objc func get_Code_Request() {
        
        print(user_phone)
       
        let parametr: [String: Any] = ["ctn": "992\(user_phone)"]
        
        let client = APIClient.shared
            do{
                try client.authPost(jsonBody: parametr).subscribe (
                onNext: { result in
                    self.secretCode = String(result.code)
                    self.hashString = result.hashString
                    
                    DispatchQueue.main.async {
                        self.auth_view.title_info.isHidden = true
                        self.auth_view.check_condition.isHidden = true
                        self.auth_view.title_condition.isHidden = true
                        
                        self.auth_view.title_code_info.isHidden = true
                        self.auth_view.send_again.isHidden = true
                        
                        self.auth_view.code_field.isHidden = false
                        self.auth_view.time_symbol.isHidden = false
                        self.auth_view.timer_label.isHidden = false
                        self.auth_view.second_label.isHidden = false
                        self.auth_view.symbol_label.isHidden = false
                        self.auth_view.get_sms.setTitle("Подтвердить", for: .normal)
                        self.auth_view.numberField.isEnabled = false
                        
                        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
                    }
                },
                onError: { error in
                   print(error.localizedDescription)
                   
                },
                onCompleted: {
                   print("Completed event.")
                }).disposed(by: disposeBag)
              }
              catch{
            }
         
     }
    
    func checkCode() {
        
        print(user_code)
        print(user_phone)
        print(hashString)
     
        let parametr: [String: Any] = ["ctn": "992\(user_phone)", "secretCode": user_code, "hashString" : hashString]
        
        let client = APIClient.shared
            do{
                try client.checkSmsCode(jsonBody: parametr).subscribe (
                onNext: { result in
                    print("hello")
                    self.accessToken = String(result.accessToken!)
                    DispatchQueue.main.async {
                        UserDefaults.standard.set("Bearer \(self.accessToken)", forKey: "token")
                        UserDefaults.standard.set("\(self.user_phone)", forKey: "mobPhone")
                        self.goHome()
                    }
                },
                onError: { error in
                   print(error.localizedDescription)
                },
                onCompleted: {
                   print("Completed event.")
                }).disposed(by: disposeBag)
              }
              catch{
                  
            }
       
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
        
        auth_view.numberField.isEnabled = false
        
        minute = 01
        seconds = 59
        
        let parametr: [String: Any] = ["ctn": "992\(user_phone)"]
        
        let client = APIClient.shared
            do{
                try client.authPost(jsonBody: parametr).subscribe(
                onNext: { result in
                    print("hello")
                    self.secretCode = String(result.code)
                    self.hashString = result.hashString
                    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
                },
                onError: { error in
                   print(error.localizedDescription)
                },
                onCompleted: {
                   print("Completed event.")
                }).disposed(by: disposeBag)
              }
              catch{
            }
    }
    
    func goHome() {
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
