//
//  SettingsViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 1/9/22.
//

import UIKit
import RxCocoa
import RxSwift
import iOSDropDown

class SettingsViewController: UIViewController, UIScrollViewDelegate, UITextDropDelegate {
    
    let disposeBag = DisposeBag()
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    let scrollView = UIScrollView()
    
    var alert = UIAlertController()
    var toolbar = TarifToolbarView()
    var settings_view = SettingsView()
    
    var lang_data = [[String]]()
    var appearance_data = [[String]]()
    
    var lang_choosed = ""
    var theme_choosed = ""
    
    var langId_choosed = 0
    var themeID_choosed = 0
    
    var smsNotification = false
    var emailNotification = false
    var pushNotification = false
    var promotionNotification = false
    override func viewDidLoad() {
        super.viewDidLoad()

        showActivityIndicator(uiView: self.view)
        view.backgroundColor = toolbarColor
        
        sendRequest()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 11.0, *) {
            scrollView.scrollIndicatorInsets = view.safeAreaInsets
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.safeAreaInsets.bottom, right: 0)
        } else {
            // Fallback on earlier versions
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? .lightContent : .darkContent)
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupView() {
        view.backgroundColor = contentColor
  
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.backgroundColor = contentColor
        scrollView.contentSize = CGSize(width: view.frame.width, height: 650)
        view.addSubview(scrollView)
        
        toolbar = TarifToolbarView(frame: CGRect(x: 0, y: topPadding ?? 0, width: UIScreen.main.bounds.size.width, height: 60))
        
        settings_view = SettingsView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 896))
        
        toolbar.icon_back.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        
        let back = UITapGestureRecognizer(target: self, action: #selector(goBack))
        toolbar.isUserInteractionEnabled = true
        toolbar.addGestureRecognizer(back)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(changeCodeTap))
        settings_view.code_change_t.isUserInteractionEnabled = true
        settings_view.code_change_t.addGestureRecognizer(tap)
        
        self.view.addSubview(toolbar)
        scrollView.addSubview(settings_view)
        
        toolbar.icon_back.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        toolbar.number_user_name.text = "Настройки"
        toolbar.backgroundColor = contentColor
        
        // setup language field
        settings_view.lang.text = lang_choosed
        settings_view.lang.isSearchEnable = false
        settings_view.lang.selectedRowColor = .lightGray
        settings_view.lang.textColor = colorBlackWhite
        //settings_view.lang.rowBackgroundColor = contentColor
        settings_view.lang.textDropDelegate = self
      
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
        settings_view.lang.leftView = paddingView
        settings_view.lang.leftViewMode = .always
        settings_view.lang.didSelect { [self] (selectedText, index, id) in
            self.lang_choosed = selectedText
            self.langId_choosed = Int(lang_data[index][0])!
            putRequest(type: "lang")
        }
        
        for i in 0 ..< lang_data.count {
            settings_view.lang.optionArray.append(lang_data[i][2])
            settings_view.lang.optionIds?.append(Int(lang_data[i][0])!)
            
        }
        
        // setup theme field
        settings_view.app_theme.text = theme_choosed
        settings_view.app_theme.isSearchEnable = false
        settings_view.app_theme.selectedRowColor = .lightGray
        settings_view.app_theme.textColor = colorBlackWhite
        
        let paddingView2: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
        settings_view.app_theme.leftView = paddingView2
        settings_view.app_theme.leftViewMode = .always
        
        settings_view.app_theme.didSelect { [self] (selectedText, index, id) in
            self.theme_choosed = selectedText
            print(Int(appearance_data[index][0])!)
            self.themeID_choosed = Int(appearance_data[index][0])!
            if Int(appearance_data[index][0])! == 1 {
                UserDefaults.standard.set("light", forKey: "ThemeAppereance")
            }
            else {
                UserDefaults.standard.set("dark", forKey: "ThemeAppereance")
            }
            
            colorLine = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00) : UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00))

            colorGrayWhite = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.00) : UIColor.white)

            contentColor = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor(red: 0.19, green: 0.19, blue: 0.20, alpha: 1.00) : UIColor.white)
            
            toolbarColor = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor(red: 0.19, green: 0.19, blue: 0.20, alpha: 1.00) : UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00))
            
            colorBlackWhite = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor.white : UIColor.black)

            colorLightDarkGray = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.00) : UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00))

            colorLightDarkGray2 = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 1.00) : UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00))
            
            darkGrayLight = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00) : UIColor.darkGray)
            
            putRequest(type: "theme")
        }
        
        
        for i in 0 ..< appearance_data.count {
            settings_view.app_theme.optionArray.append(appearance_data[i][1])
            settings_view.app_theme.optionIds?.append(Int(appearance_data[i][0])!)
        }
        
        
        settings_view.switch_push.isOn = pushNotification
        settings_view.switch_sales.isOn = promotionNotification
        settings_view.switch_sms.isOn = smsNotification
        settings_view.switch_enter.isOn = UserDefaults.standard.bool(forKey: "BiometricEnter")
        
        settings_view.switch_push.addTarget(self, action: #selector(switchChange), for: .touchUpInside)
        settings_view.switch_sales.addTarget(self, action: #selector(switchChange), for: .touchUpInside)
        settings_view.switch_sms.addTarget(self, action: #selector(switchChange), for: .touchUpInside)
        settings_view.switch_enter.addTarget(self, action: #selector(switchEnterChange), for: .touchUpInside)
        
        scrollView.frame = CGRect(x: 0, y: 60 + (topPadding ?? 0), width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 60 + (topPadding ?? 0) + (bottomPadding ?? 0)))
    }

    
    @objc func changeCodeTap() {
        print("hello")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.pushViewController(ChangeCodeController(), animated: true)
    }
    
    @objc func switchChange(_ sender: Any) {
        
        pushNotification = settings_view.switch_push.isOn
        promotionNotification = settings_view.switch_sales.isOn
        smsNotification = settings_view.switch_sms.isOn
        putRequest(type: "switch")
    }
    
    @objc func switchEnterChange(_ sender: Any) {
        
        UserDefaults.standard.set(settings_view.switch_enter.isOn, forKey: "BiometricEnter")
    }
    
    
    func sendRequest() {
        let client = APIClient.shared
            do{
              try client.settingsGetRequest().subscribe(
                onNext: { result in
                  print(result)
                    DispatchQueue.main.async { [self] in
                        if result.appearance.count != 0 {
                            for i in 0 ..< result.appearance.count {
                                appearance_data.append([String(result.appearance[i].themeId), String(result.appearance[i].themeDescription)])
                                if result.appearance[i].selected == true {
                                    theme_choosed = String(result.appearance[i].themeDescription)
                                }
                            }
                        }
                        
                        if result.languages.count != 0 {
                            for i in 0 ..< result.languages.count {
                                lang_data.append([String(result.languages[i].id), String(result.languages[i].selected), String(result.languages[i].description)])
                                if result.languages[i].selected == true {
                                    lang_choosed = String(result.languages[i].description)
                                }
                            }
                        }
                        
                        smsNotification = result.notifications.smsNotification
                        emailNotification = result.notifications.emailNotification
                        pushNotification = result.notifications.pushNotification
                        promotionNotification = result.notifications.promotionNotification
                        
                    }
                },
                onError: { error in
                   print(error.localizedDescription)
                    self.requestAnswer(message: error.localizedDescription)
                },
                onCompleted: {
                    DispatchQueue.main.async {
                        self.setupView()
                        self.hideActivityIndicator(uiView: self.view)
                    }
                   print("Completed event.")
                    
                }).disposed(by: disposeBag)
              }
              catch{
            }
    }
    
    @objc func putRequest(type: String) {
        
        self.showActivityIndicator(uiView: self.view)
        let parametr: [String: Any] = ["promotionNotification": promotionNotification, "pushNotification": pushNotification, "emailNotification" : emailNotification, "smsNotification" : smsNotification, "languageId": langId_choosed, "themeId" : themeID_choosed]
        print(parametr)
        let client = APIClient.shared
            do{
                try client.settingsPutRequest(jsonBody: parametr).subscribe (
                onNext: { result in
                    print("hello")
                    DispatchQueue.main.async { [self] in
                        if type != "switch" {
                            restartApp()
                        }
                    }
                },
                onError: { error in
                   print(error.localizedDescription)
                    self.requestAnswer(message: error.localizedDescription)
                },
                onCompleted: {
                   print("Completed event.")
                    DispatchQueue.main.async {
                        self.hideActivityIndicator(uiView: self.view)
                    }
                }).disposed(by: disposeBag)
              }
              catch{
                  
            }
    }
    
    func restartApp() {
        
        UserDefaults.standard.set(3, forKey: "language")
        UserDefaults.standard.set(LanguageType.tj.rawValue, forKey: "language_string")
       
        if langId_choosed == 1 {
            self.defaultLocalizer.setSelectedLanguage(lang: .ru)
        }
        else if langId_choosed == 2 {
            self.defaultLocalizer.setSelectedLanguage(lang: .en)
        }
        else if langId_choosed == 3 {
            self.defaultLocalizer.setSelectedLanguage(lang: .tj)
        }
        else {
            self.defaultLocalizer.setSelectedLanguage(lang: .uz)
        }
        
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

    @objc func requestAnswer(message: String) {
        
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
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissDialog))
        view.name.isUserInteractionEnabled = true
        view.name.addGestureRecognizer(tapGestureRecognizer)
        
        view.cancel.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
        view.ok.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
        
        alert.view.backgroundColor = .clear
        alert.view.addSubview(view)
        //alert.view.sendSubviewToBack(view)
        
        present(alert, animated: true, completion: nil)

    }
    
    @objc func dismissDialog() {
        alert.dismiss(animated: true, completion: nil)
    }
}


