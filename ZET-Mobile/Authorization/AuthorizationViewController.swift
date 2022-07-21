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
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    var auth_view = AuthorizationView()
    var nav = UINavigationController()
    let disposeBag = DisposeBag()
    var alert = UIAlertController()
    
    var minute = 01
    var seconds = 59
    var timer = Timer()
    
    var user_phone = ""
    var user_code = ""
    var secretCode = ""
    var hashString = ""
    var accessToken = ""
    var lang_id = 1
    
    var activeTextField : UITextField? = nil
    
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
        auth_view.backgroundColor = contentColor
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openCondition))
        auth_view.title_condition.isUserInteractionEnabled = true
        auth_view.title_condition.addGestureRecognizer(tapGestureRecognizer)
        
        let tapSendAgain = UITapGestureRecognizer(target: self, action: #selector(sendAgain))
        auth_view.send_again.isUserInteractionEnabled = true
        auth_view.send_again.addGestureRecognizer(tapSendAgain)
    
        
        self.view.addSubview(auth_view)
        
        
        //NotificationCenter.default.addObserver(self, selector: #selector(AuthorizationViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
            // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
       // NotificationCenter.default.addObserver(self, selector: #selector(AuthorizationViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        auth_view.numberField.resignFirstResponder()
        auth_view.code_field.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {

      guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {

        // if keyboard size is not available for some reason, dont do anything
        return
      }

      var shouldMoveViewUp = false

      // if active text field is not nil
      if let activeTextField = activeTextField {

        let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.auth_view).maxY;
        
        let topOfKeyboard = self.auth_view.frame.height  - keyboardSize.height

        // if the bottom of Textfield is below the top of keyboard, move up
        if bottomOfTextField > topOfKeyboard {
          shouldMoveViewUp = true
        }
      }

      if(shouldMoveViewUp) {
        self.auth_view.frame.origin.y = (self.view.frame.origin.y + self.view.frame.height) - keyboardSize.height
      }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
      // move back the root view origin to zero
      self.auth_view.frame.origin.y = self.view.frame.origin.y + self.view.frame.height
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            auth_view.numberField.text! = "+992 " + user_phone
            auth_view.numberField.textColor = colorBlackWhite
            auth_view.numberField.font = UIFont.systemFont(ofSize: 15)
        }
        else if textField.tag == 2 {
            auth_view.code_field.text! = user_code
            auth_view.code_field.textColor = colorBlackWhite
            auth_view.code_field.font = UIFont.systemFont(ofSize: 15)
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 && auth_view.code_field.isHidden == false {
            print("end")
            auth_view.numberField.text! = "992" + user_phone
            auth_view.numberField.textColor = colorBlackWhite
            auth_view.numberField.font = UIFont.systemFont(ofSize: 15)
        }
        else if textField.tag == 2 {
            auth_view.code_field.text! = user_code
            auth_view.code_field.textColor = colorBlackWhite
            auth_view.code_field.font = UIFont.systemFont(ofSize: 15)
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
            if tag == 1 && user_phone != "" {
                user_phone = (user_phone as String).substring(to: user_phone.index(before: user_phone.endIndex))
            }
            else if tag == 1 && user_phone == "" {
                return false
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
       /* let next = ConditionViewController()
        next.view.frame = (view.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)))
        self.halfModalTransitioningDelegate = HalfModalTransitioningDelegate(viewController: self, presentingViewController: next)
        next.modalPresentationStyle = .custom
        next.modalPresentationCapturesStatusBarAppearance = true
        
        next.transitioningDelegate = self.halfModalTransitioningDelegate
        present(next, animated: true, completion: nil)*/
        
        ConditionViewController().condition_view.close.addTarget(self, action: #selector(dismiss_view), for: .touchUpInside)
    
        nav = UINavigationController(rootViewController: ConditionViewController())
        nav.modalPresentationStyle = .pageSheet
        nav.view.backgroundColor = contentColor
        nav.isNavigationBarHidden = true
        ConditionViewController().view.backgroundColor = colorGrayWhite
        if #available(iOS 15.0, *) {
            if let sheet = nav.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.selectedDetentIdentifier = .medium
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false

            }
        } else {
            // Fallback on earlier versions
        }
            // 4
        present(nav, animated: true, completion: nil)
    }
    
    @objc func dismiss_view() {
        nav.dismiss(animated: true, completion: nil)
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
        auth_view.uz_but.addTarget(self, action: #selector(uz_choosed), for: .touchUpInside)
    }
    
    @objc func ru_choosed() {
        auth_view.lang_set.setTitle("RU 🇷🇺", for: .normal)
        auth_view.view_lang.isHidden = true
        lang_id = 1
    }
    
    @objc func en_choosed() {
        auth_view.lang_set.setTitle("EN 🇺🇸", for: .normal)
        auth_view.view_lang.isHidden = true
        lang_id = 2
    }
    
    @objc func tj_choosed() {
        auth_view.lang_set.setTitle("TJ 🇹🇯", for: .normal)
        auth_view.view_lang.isHidden = true
        lang_id = 3
    }
    
    @objc func uz_choosed() {
        auth_view.lang_set.setTitle("UZ 🇺🇿", for: .normal)
        auth_view.view_lang.isHidden = true
        lang_id = 4
    }
    
    @objc func buttonClick(_ sender: UIButton) {
        auth_view.numberField.resignFirstResponder()
        auth_view.code_field.resignFirstResponder()
        
        sender.showAnimation { [self] in
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
                    self.requestAnswer(message: "Введите номер Zet - Mobile")
                  //self.view.makeToast("Введите номер Zet - Mobile", duration: 3.0, position: .bottom, style: style); return
                }
            }
            else {
                checkCode()
            }
          }
        
    }
    
    @objc func get_Code_Request() {
        self.showActivityIndicator2(uiView: view)
        print(user_phone)
       
        let parametr: [String: Any] = ["ctn": "992\(user_phone)", "language": lang_id]
        
        let client = APIClient.shared
            do{
                try client.authPost(jsonBody: parametr).subscribe (
                onNext: { result in
                    self.hashString = result.hashString
                    
                    DispatchQueue.main.async { [self] in
                        auth_view.numberField.text = "992" + user_phone
                        auth_view.numberField.textColor = colorBlackWhite
                        auth_view.numberField.font = UIFont.systemFont(ofSize: 15)
                        
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
                        
                        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
                        print("llll")
                    }
                },
                onError: { error in
                    DispatchQueue.main.async {
                        self.requestAnswer(message: error.localizedDescription)
                        print(error.localizedDescription)
                        self.hideActivityIndicator2(uiView: self.view)
                    }
                   
                },
                onCompleted: {
                   print("Completed event.")
                    DispatchQueue.main.async {
                        self.hideActivityIndicator2(uiView: self.view)
                    }
                }).disposed(by: disposeBag)
              }
              catch{
            }
         
     }
    
    func checkCode() {
        
        print(user_code)
        print(user_phone)
        print(hashString)
        
        self.showActivityIndicator2(uiView: view)
        
        let parametr: [String: Any] = ["ctn": "992\(user_phone)", "secretCode": String(auth_view.code_field.text ?? ""), "hashString" : hashString, "fbaseToken": UserDefaults.standard.string(forKey: "fbaseToken"), "language" : lang_id]
        
        let client = APIClient.shared
            do{
                
                try client.checkSmsCode(jsonBody: parametr).subscribe (
                onNext: { result in
                    print("hello")
                    self.accessToken = String(result.accessToken!)
                    DispatchQueue.main.async {
                        UserDefaults.standard.set("Bearer \(self.accessToken)", forKey: "token")
                        UserDefaults.standard.set("Bearer \(String(result.refreshToken))", forKey: "refresh_token")
                        UserDefaults.standard.set("\(self.user_phone)", forKey: "mobPhone")
                        self.setPass()
                    }
                },
                onError: { error in
                    DispatchQueue.main.async {
                        self.requestAnswer(message: error.localizedDescription)
                        print(error.localizedDescription)
                        self.hideActivityIndicator2(uiView: self.view)
                    }
                },
                onCompleted: {
                   print("Completed event.")
                    DispatchQueue.main.async {
                        self.hideActivityIndicator2(uiView: self.view)
                    }
                }).disposed(by: disposeBag)
              }
              catch{
                  
            }
       
    }
    
    @objc func updateTimer() {
        print("hi")
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
        
        let parametr: [String: Any] = ["ctn": "992\(user_phone)", "language": lang_id]
        
        let client = APIClient.shared
            do{
                try client.authPost(jsonBody: parametr).subscribe(
                    onNext: { [self] result in
                    print("hello")
                    hashString = result.hashString
                    DispatchQueue.main.async { [self] in
                        auth_view.timer_label.text = "01"
                        auth_view.second_label.text = "59"
                        auth_view.send_again.isHidden = true
                        timer.invalidate()
                        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
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
    
    func setPass() {
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(ChangeCodeController(), animated: false)
    }
    
    @objc func requestAnswer(message: String) {
        print("kkkkkkkk")
        alert = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n", message: "", preferredStyle: .alert)
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

        view.backgroundColor = contentColor
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 40, height: 330)
        view.layer.cornerRadius = 20
        view.name.text = "Что-то пошло не так"
        view.image_icon.image = UIImage(named: "uncorrect_alert")
        
        view.name_content.text = "\(message)"
        view.ok.setTitle("OK", for: .normal)
        
        view.cancel.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
        view.ok.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
        
        alert.view.backgroundColor = .clear
        alert.view.addSubview(view)
        //alert.view.sendSubviewToBack(view)
        
        present(alert, animated: true, completion: nil)

        
    }
    
    @objc func dismissDialog(_ sender: UIButton) {
        print("hello")
        sender.showAnimation { [self] in
            alert.dismiss(animated: true, completion: nil)
            hideActivityIndicator(uiView: view)
        }
    }
    
}
