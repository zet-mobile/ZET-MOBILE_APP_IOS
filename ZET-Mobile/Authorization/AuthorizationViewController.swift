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
    
    var timer = Timer()
    var totalTime = 118
    
    var timerCounting: Bool = false
    var startTime: Date?
    var stopTime: Date?
    
    let userDefaults = UserDefaults.standard
    let START_TIME_KEY = "startTimeA"
    let COUNTING_KEY = "countingKeyA"
    let TOTAL_TIME_KEY = "totalTimeA"
    
    var user_phone = ""
    var user_code = ""
    var secretCode = ""
    var hashString = ""
    var accessToken = ""
    var lang_id = 1
    
    var activeTextField : UITextField? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(appWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(appDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil)
        
        
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
    
        auth_view.code_field.placeholder = defaultLocalizer.stringForKey(key: "Enter_SMS")
        
       /* if user_phone != "" {
            auth_view.numberField.text! = "+992 " + user_phone
            auth_view.numberField.textColor = colorBlackWhite
            auth_view.numberField.font = UIFont.systemFont(ofSize: 15)
        }
        */
        
        if auth_view.code_field.isHidden == false {
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
            auth_view.get_sms.setTitle(defaultLocalizer.stringForKey(key: "Confirm"), for: .normal)
            auth_view.numberField.isEnabled = false
        }
        
        switch UserDefaults.standard.integer(forKey: "language") {
        case 1:
            auth_view.lang_set.setTitle("RU 🇷🇺", for: .normal)
            break
        case 2:
            auth_view.lang_set.setTitle("ENG 🇺🇸", for: .normal)
            break
        case 3:
            auth_view.lang_set.setTitle("TJK 🇹🇯", for: .normal)
            break
        case 4:
            auth_view.lang_set.setTitle("UZB 🇺🇿", for: .normal)
            break
        default:
            auth_view.lang_set.setTitle("RU 🇷🇺", for: .normal)
            break
       }
        
        if UIScreen.main.bounds.size.height < 812 {
            auth_view.numberField.frame.origin.y = (UIScreen.main.bounds.size.height * 360) / 926
            auth_view.title_number_info.frame.origin.y = (UIScreen.main.bounds.size.height * 430) / 926
            auth_view.title_info.frame.origin.y = (UIScreen.main.bounds.size.height * 420) / 926
            auth_view.check_condition.frame.origin.y = (UIScreen.main.bounds.size.height * 490) / 926
            auth_view.get_sms.frame.origin.y = (UIScreen.main.bounds.size.height * 560) / 926
            auth_view.code_field.frame.origin.y = (UIScreen.main.bounds.size.height * 460) / 926
            auth_view.title_code_info.frame.origin.y = (UIScreen.main.bounds.size.height * 540) / 926
            auth_view.time_symbol.frame.origin.y = (UIScreen.main.bounds.size.height * 465) / 926
            auth_view.timer_label.frame.origin.y = (UIScreen.main.bounds.size.height * 465) / 926
            auth_view.symbol_label.frame.origin.y = (UIScreen.main.bounds.size.height * 465) / 926
            auth_view.second_label.frame.origin.y = (UIScreen.main.bounds.size.height * 465) / 926
            auth_view.send_again.frame.origin.y = (UIScreen.main.bounds.size.height * 489) / 926
            auth_view.title_condition.frame.origin.y = (UIScreen.main.bounds.size.height * 489) / 926
        }
        
        self.view.addSubview(auth_view)
        
    }

    @objc func appWillEnterForeground() {
        startTime = userDefaults.object(forKey: START_TIME_KEY) as? Date
        timerCounting = userDefaults.bool(forKey: COUNTING_KEY)
        totalTime = userDefaults.integer(forKey: TOTAL_TIME_KEY)
       
        print("auth")
        print(startTime as Any)
        print(timerCounting)
        print(totalTime)
        
        if timerCounting == true {
            let diff = Date().timeIntervalSince(startTime!)
            totalTime -= Int(diff)
            let time = secondsToHoursMinutesSeconds(totalTime)
            let timeString = makeTimeString(min: time.0, sec: time.1)
            if totalTime >= 0 {
                auth_view.timer_label.text = timeString
                totalTime -= 1
                timer.invalidate()
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            }
            else {
                timer.invalidate()
                setTimerCounting(false)
                auth_view.timer_label.text = "00:00"
                auth_view.send_again.isHidden = false
                auth_view.get_sms.backgroundColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
                auth_view.get_sms.isEnabled = false
            }
            
            
        }
        else {
            timer.invalidate()
            setTimerCounting(false)
        }
    }
    
    @objc func appDidEnterBackground() {
        setStartTime(date: Date())
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
            auth_view.title_number_info.isHidden = true
            
            if UIScreen.main.bounds.size.height < 812 {
                auth_view.title_info.frame.origin.y = (UIScreen.main.bounds.size.height * 420) / 926
                auth_view.check_condition.frame.origin.y = (UIScreen.main.bounds.size.height * 490) / 926
                auth_view.title_condition.frame.origin.y = (UIScreen.main.bounds.size.height * 490) / 926
                auth_view.get_sms.frame.origin.y = (UIScreen.main.bounds.size.height * 560) / 926
            }
            else {
                auth_view.title_info.frame.origin.y = (UIScreen.main.bounds.size.height * 410) / 926
                auth_view.check_condition.frame.origin.y = (UIScreen.main.bounds.size.height * 470) / 926
                auth_view.title_condition.frame.origin.y = (UIScreen.main.bounds.size.height * 470) / 926
                auth_view.get_sms.frame.origin.y = (UIScreen.main.bounds.size.height * 520) / 926
            }
            
            auth_view.numberField.layer.borderColor = colorLightDarkGray.cgColor
        }
        else if textField.tag == 2 {
           // auth_view.code_field.text! = user_code
            auth_view.code_field.textColor = colorBlackWhite
            auth_view.code_field.font = UIFont.systemFont(ofSize: 15)
            
            auth_view.title_code_info.isHidden = true
            auth_view.code_field.layer.borderColor = colorLightDarkGray.cgColor
            
            if UIScreen.main.bounds.size.height < 812 {
                auth_view.get_sms.frame.origin.y = ((UIScreen.main.bounds.size.height * 560) / 926)
            }
            else {
                auth_view.get_sms.frame.origin.y = ((UIScreen.main.bounds.size.height * 520) / 926)
            }
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 && auth_view.code_field.isHidden == false {
        
            auth_view.numberField.text! = "992" + user_phone
            auth_view.numberField.textColor = colorBlackWhite
            auth_view.numberField.font = UIFont.systemFont(ofSize: 15)
        }
        else if textField.tag == 2 {
          //  auth_view.code_field.text! = user_code
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
        
        let cursorPosition2 = auth_view.numberField.offset(from: auth_view.numberField.beginningOfDocument, to: auth_view.numberField.selectedTextRange!.start)
        print("cursorPosition2")
        print(cursorPosition2)
        
        if string  == "" {
            if cursorPosition2 <= 5 && textField == auth_view.numberField {
                return false
            }
            else if tag == 1 && user_phone != "" {
               // user_phone = (user_phone as String).substring(to: user_phone.index(before: user_phone.endIndex))
                let i = user_phone.index(user_phone.startIndex, offsetBy: cursorPosition2 - 6)
                user_phone.remove(at: i)
            }
            else if tag == 1 && user_phone == "" {
                return false
            }
            else {
             //   user_code = (user_code as String).substring(to: user_code.index(before: user_code.endIndex))
            }
        }
        
        if tag == 1 && string != "" && auth_view.numberField.text!.count == 14 {
            return false
        }
        else if tag == 1 && string != "" {
            let i = user_phone.index(user_phone.startIndex, offsetBy: cursorPosition2 - 5)
            user_phone.insert(contentsOf: string, at: i)
            //user_phone = user_phone + string
            print(user_phone)
        }
        
        
        if tag == 2 && string != "" && auth_view.code_field.text!.count == 6 {
            return false
        }
        else if tag == 2 {
          //  user_code = user_code + string
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
        
        let detailViewController = ConditionViewController()
        detailViewController.close.addTarget(self, action: #selector(dismiss_view), for: .touchUpInside)
    
        nav = UINavigationController(rootViewController: detailViewController)
        nav.modalPresentationStyle = .pageSheet
        nav.view.backgroundColor = contentColor
        nav.isNavigationBarHidden = true
        detailViewController.view.backgroundColor = colorGrayWhite
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
        
        if auth_view.lang_set.titleLabel?.text == "RU 🇷🇺" {
            auth_view.ru_button.isHidden = true
            auth_view.eng_but.isHidden = false
            auth_view.tj_but.isHidden = false
            auth_view.uz_but.isHidden = false
            auth_view.ru_button.frame.origin.y = 0
            auth_view.eng_but.frame.origin.y = (UIScreen.main.bounds.size.height * 50) / 926
            auth_view.tj_but.frame.origin.y = (UIScreen.main.bounds.size.height * 100) / 926
            auth_view.uz_but.frame.origin.y = (UIScreen.main.bounds.size.height * 150) / 926
        }
        else if auth_view.lang_set.titleLabel?.text == "ENG 🇺🇸" {
            auth_view.ru_button.isHidden = false
            auth_view.eng_but.isHidden = true
            auth_view.tj_but.isHidden = false
            auth_view.uz_but.isHidden = false
            
            auth_view.ru_button.frame.origin.y = (UIScreen.main.bounds.size.height * 50) / 926
            auth_view.tj_but.frame.origin.y = (UIScreen.main.bounds.size.height * 100) / 926
            auth_view.uz_but.frame.origin.y = (UIScreen.main.bounds.size.height * 150) / 926
        }
        else if auth_view.lang_set.titleLabel?.text == "TJK 🇹🇯" {
            auth_view.ru_button.isHidden = false
            auth_view.eng_but.isHidden = false
            auth_view.tj_but.isHidden = true
            auth_view.uz_but.isHidden = false
            
            auth_view.ru_button.frame.origin.y = (UIScreen.main.bounds.size.height * 50) / 926
            auth_view.eng_but.frame.origin.y = (UIScreen.main.bounds.size.height * 100) / 926
            auth_view.uz_but.frame.origin.y = (UIScreen.main.bounds.size.height * 150) / 926
            
        }
        else if auth_view.lang_set.titleLabel?.text == "UZB 🇺🇿" {
            auth_view.ru_button.isHidden = false
            auth_view.eng_but.isHidden = false
            auth_view.tj_but.isHidden = false
            auth_view.uz_but.isHidden = true
            
            auth_view.ru_button.frame.origin.y = (UIScreen.main.bounds.size.height * 50) / 926
            auth_view.eng_but.frame.origin.y = (UIScreen.main.bounds.size.height * 100) / 926
            auth_view.tj_but.frame.origin.y = (UIScreen.main.bounds.size.height * 150) / 926
            
        }
        
        auth_view.ru_button.addTarget(self, action: #selector(ru_choosed), for: .touchUpInside)
        auth_view.eng_but.addTarget(self, action: #selector(en_choosed), for: .touchUpInside)
        auth_view.tj_but.addTarget(self, action: #selector(tj_choosed), for: .touchUpInside)
        auth_view.uz_but.addTarget(self, action: #selector(uz_choosed), for: .touchUpInside)
    }
    
    @objc func ru_choosed() {
        user_phone = ""
        user_code = ""
        totalTime = 118
        timer.invalidate()
        auth_view.lang_set.setTitle("RU 🇷🇺", for: .normal)
        auth_view.view_lang.isHidden = true
        lang_id = 1
        updateView()
    }
    
    @objc func en_choosed() {
        user_phone = ""
        user_code = ""
        totalTime = 118
        timer.invalidate()
        auth_view.lang_set.setTitle("ENG 🇺🇸", for: .normal)
        auth_view.view_lang.isHidden = true
        lang_id = 2
        updateView()
    }
    
    @objc func tj_choosed() {
        user_phone = ""
        user_code = ""
        totalTime = 118
        timer.invalidate()
        auth_view.lang_set.setTitle("TJK 🇹🇯", for: .normal)
        auth_view.view_lang.isHidden = true
        lang_id = 3
        updateView()
    }
    
    @objc func uz_choosed() {
        user_phone = ""
        user_code = ""
        totalTime = 118
        timer.invalidate()
        auth_view.lang_set.setTitle("UZB 🇺🇿", for: .normal)
        auth_view.view_lang.isHidden = true
        lang_id = 4
        updateView()
    }
    
    func updateView() {
        switch lang_id {
        case 1:
            UserDefaults.standard.set(1, forKey: "language")
            UserDefaults.standard.set(LanguageType.ru.rawValue, forKey: "language_string")
            defaultLocalizer.setSelectedLanguage(lang: .ru)
            break
        case 2:
            UserDefaults.standard.set(2, forKey: "language")
            UserDefaults.standard.set(LanguageType.en.rawValue, forKey: "language_string")
            defaultLocalizer.setSelectedLanguage(lang: .en)
            break
        case 3:
            UserDefaults.standard.set(3, forKey: "language")
            UserDefaults.standard.set(LanguageType.tj.rawValue, forKey: "language_string")
            defaultLocalizer.setSelectedLanguage(lang: .tj)
            break
        case 4:
            UserDefaults.standard.set(4, forKey: "language")
            UserDefaults.standard.set(LanguageType.uz.rawValue, forKey: "language_string")
            defaultLocalizer.setSelectedLanguage(lang: .uz)
            break
        default:
            UserDefaults.standard.set(1, forKey: "language")
            UserDefaults.standard.set(LanguageType.ru.rawValue, forKey: "language_string")
            defaultLocalizer.setSelectedLanguage(lang: .ru)
            break
       }
        
        viewDidLoad()
    }
    
    @objc func buttonClick(_ sender: UIButton) {
        auth_view.numberField.resignFirstResponder()
        auth_view.code_field.resignFirstResponder()
        
        sender.showAnimation { [self] in
            if auth_view.code_field.text == "" && auth_view.code_field.isHidden == true {
                print(user_phone)
                let length = user_phone.count
                let str = user_phone.prefix(3)
                let str2 = user_phone.prefix(2)
                
                if user_phone == "" || length < 9 {
                    auth_view.title_number_info.isHidden = false
                    auth_view.numberField.layer.borderColor = UIColor.red.cgColor
                    
                    if UIScreen.main.bounds.size.height < 812 {
                        auth_view.title_info.frame.origin.y = ((UIScreen.main.bounds.size.height * 420) / 926) + 20
                        auth_view.check_condition.frame.origin.y = ((UIScreen.main.bounds.size.height * 500) / 926) + 20
                        auth_view.title_condition.frame.origin.y = ((UIScreen.main.bounds.size.height * 500) / 926) + 20
                        auth_view.get_sms.frame.origin.y = ((UIScreen.main.bounds.size.height * 570) / 926) + 20
                    }
                    else {
                        auth_view.title_info.frame.origin.y = ((UIScreen.main.bounds.size.height * 420) / 926) + 20
                        auth_view.check_condition.frame.origin.y = ((UIScreen.main.bounds.size.height * 480) / 926) + 20
                        auth_view.title_condition.frame.origin.y = ((UIScreen.main.bounds.size.height * 480) / 926) + 20
                        auth_view.get_sms.frame.origin.y = ((UIScreen.main.bounds.size.height * 530) / 926) + 20
                    }
                }
                else if str == "910" || str == "911" || str == "915" || str == "917" || str == "919" || str2 == "80" || str2 == "40" {
                     
                  get_Code_Request()
                }
                else {
                    self.requestAnswer(message: defaultLocalizer.stringForKey(key: "Enter_phone_zet"))
                  //self.view.makeToast("Введите номер Zet - Mobile", duration: 3.0, position: .bottom, style: style); return
                }
            }
            else {
                if auth_view.code_field.text == "" || auth_view.code_field.text!.count < 6 {
                    auth_view.title_code_info.isHidden = false
                    auth_view.code_field.layer.borderColor = UIColor.red.cgColor
                    
                    if UIScreen.main.bounds.size.height < 812 {
                        auth_view.get_sms.frame.origin.y = ((UIScreen.main.bounds.size.height * 560) / 926) + 20
                    }
                    else {
                        auth_view.get_sms.frame.origin.y = ((UIScreen.main.bounds.size.height * 520) / 926) + 20
                    }
                    
                }
                else {
                    checkCode()
                }
               //
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
                    self.hashString = result.hashString ?? ""
                    
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
                        auth_view.get_sms.setTitle(defaultLocalizer.stringForKey(key: "Confirm"), for: .normal)
                        auth_view.numberField.isEnabled = false
                        auth_view.lang_set.isHidden = true
                        auth_view.view_lang.isHidden = true
                        
                        totalTime = 118
                        timer.invalidate()
                        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
                    }
                    
                },
                onError: { error in
                    DispatchQueue.main.async {
                        self.requestAnswer(message: self.defaultLocalizer.stringForKey(key: "service is temporarily unavailable"))
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
        
        self.showActivityIndicator2(uiView: view)
        
        let parametr: [String: Any] = ["ctn": "992\(user_phone)", "secretCode": String(auth_view.code_field.text ?? ""), "hashString" : hashString, "fbaseToken": UserDefaults.standard.string(forKey: "fbaseToken"), "language" : lang_id]
        
        let client = APIClient.shared
            do{
                
                try client.checkSmsCode(jsonBody: parametr).subscribe (
                onNext: { result in
                    if result.success == true {
                        self.accessToken = String(result.accessToken ?? "")
                        DispatchQueue.main.async { [self] in
                            UserDefaults.standard.set("Bearer \(self.accessToken ?? "")", forKey: "token")
                            UserDefaults.standard.set("Bearer \(String(result.refreshToken ?? ""))", forKey: "refresh_token")
                            UserDefaults.standard.set("\(self.user_phone)", forKey: "mobPhone")
                            timer.invalidate()
                            setTimerCounting(false)
                            self.setPass()
                            
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            self.requestAnswer(message: String(result.message ?? ""))
                            self.hideActivityIndicator2(uiView: self.view)
                        }
                    }
                    
                },
                onError: { error in
                    DispatchQueue.main.async { [self] in
                        self.requestAnswer(message: defaultLocalizer.stringForKey(key: "service is temporarily unavailable"))
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
        
        if totalTime >= 0 {
            print(totalTime)
            let time = secondsToHoursMinutesSeconds(totalTime)
            let timeString = makeTimeString(min: time.0, sec: time.1)
            auth_view.timer_label.text = timeString
            totalTime -= 1  // decrease counter timer
            setTimerCounting(true)
            setTotalTime(totalTime)
        } else {
            timer.invalidate()
            setTimerCounting(false)
            auth_view.timer_label.text = "00:00"
            auth_view.send_again.isHidden = false
            auth_view.get_sms.backgroundColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
            auth_view.get_sms.isEnabled = false
        }
    }
    
    func secondsToHoursMinutesSeconds(_ ms: Int) -> (Int, Int) {
        let min = (ms % 3600) / 60
        let sec = (ms % 3600) % 60
        return (min, sec)
    }
        
    func makeTimeString(min: Int, sec: Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d", min)
        timeString += ":"
        timeString += String(format: "%02d", sec)
        return timeString
    }
    
    func setStartTime(date: Date?) {
        startTime = date
        userDefaults.set(startTime, forKey: START_TIME_KEY)
    }
        
    func setTimerCounting(_ val: Bool) {
        timerCounting = val
        userDefaults.set(timerCounting, forKey: COUNTING_KEY)
    }
    
    func setTotalTime(_ val: Int) {
        totalTime = val
        userDefaults.set(totalTime, forKey: TOTAL_TIME_KEY)
    }
    
    @objc func sendAgain() {
        
        auth_view.numberField.isEnabled = false
        auth_view.get_sms.isEnabled = true
        auth_view.get_sms.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
        
        auth_view.title_code_info.isHidden = true
        auth_view.code_field.layer.borderColor = colorLightDarkGray.cgColor
        
        if UIScreen.main.bounds.size.height < 812 {
            auth_view.get_sms.frame.origin.y = ((UIScreen.main.bounds.size.height * 560) / 926)
        }
        else {
            auth_view.get_sms.frame.origin.y = ((UIScreen.main.bounds.size.height * 520) / 926)
        }
        
        let parametr: [String: Any] = ["ctn": "992\(user_phone)", "language": lang_id]
        
        let client = APIClient.shared
            do{
                try client.authPost(jsonBody: parametr).subscribe(
                    onNext: { [self] result in
                    
                        hashString = result.hashString ?? ""
                    DispatchQueue.main.async { [self] in
                        auth_view.timer_label.text = "01:59"
                        auth_view.send_again.isHidden = true
                        
                        totalTime = 118
                        timer.invalidate()
                        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
                    }
                    
                },
                onError: { error in
                   print(error.localizedDescription)
                    self.hideActivityIndicator(uiView: self.view)
                },
                onCompleted: {
                   print("Completed event.")
                }).disposed(by: disposeBag)
              }
              catch{
            }
    }
    
    func setPass() {
        setTimerCounting(false)
        UserDefaults.standard.set(false, forKey: "timer_start")
        UserDefaults.standard.set(0, forKey: "seconds")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(ChangeCodeController(), animated: false)
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

        view.backgroundColor = contentColor
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 40, height: 350)
        view.layer.cornerRadius = 20
        view.name.text = defaultLocalizer.stringForKey(key: "error_title")
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
        
        sender.showAnimation { [self] in
            alert.dismiss(animated: true, completion: nil)
            hideActivityIndicator(uiView: view)
        }
    }
}
