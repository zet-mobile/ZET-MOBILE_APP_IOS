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
import LocalAuthentication

var langId_choosed = 1
var themeID_choosed = 1
var smsNotification = false
var emailNotification = false
var pushNotification = false
var promotionNotification = false

class SettingsViewController: UIViewController, UIScrollViewDelegate, UITextDropDelegate {
    
    let disposeBag = DisposeBag()
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    let scrollView = UIScrollView()
    
    var alert = UIAlertController()
    var toolbar = TarifToolbarView()
    var settingsView = SettingsView()
    
    var langData = [[String]]()
    var appearanceData = [[String]]()
    
    var langChoosed = ""
    var themeChoosed = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showActivityIndicator(uiView: self.view)
        view.backgroundColor = toolbarColor
        
        putRequest2()
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
        
       // toolbar = TarifToolbarView(frame: CGRect(x: 0, y: topPadding ?? 0, width: UIScreen.main.bounds.size.width, height: 60))
        
      
        
        settingsView = SettingsView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 896))
        
       
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(changeCodeTap))
        settingsView.changePinTitle.isUserInteractionEnabled = true
        settingsView.changePinTitle.addGestureRecognizer(tap)
        
        let tapButton = UITapGestureRecognizer(target: self, action: #selector(changeCodeTap))
        settingsView.changePinButton.isUserInteractionEnabled = true
        settingsView.changePinButton.addGestureRecognizer(tapButton)
        
        self.view.addSubview(toolbar)
        scrollView.addSubview(settingsView)
        
        
        toolbar.icon_back.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        
        let back = UITapGestureRecognizer(target: self, action: #selector(goBack))
        toolbar.isUserInteractionEnabled = true
        toolbar.addGestureRecognizer(back)
        
        toolbar.icon_back.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        toolbar.number_user_name.text = defaultLocalizer.stringForKey(key: "Settings")
        toolbar.backgroundColor = contentColor
        
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            toolbar.topAnchor.constraint(equalTo: view.topAnchor),
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        settingsView.chooseLang.text = langChoosed
        settingsView.chooseLang.isSearchEnable = false
        settingsView.chooseLang.selectedRowColor = .lightGray
        settingsView.chooseLang.textColor = colorBlackWhite
        settingsView.chooseLang.textDropDelegate = self
      
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
        settingsView.chooseLang.leftView = paddingView
        settingsView.chooseLang.leftViewMode = .always
        settingsView.chooseLang.didSelect { [self] (selectedText, index, id) in
            self.langChoosed = selectedText
            langId_choosed = Int(langData[index][0])!
            putRequest(type: "lang")
        }
        
        for i in 0 ..< langData.count {
            settingsView.chooseLang.optionArray.append(langData[i][2])
            settingsView.chooseLang.optionIds?.append(Int(langData[i][0])!)
            
        }
        
        // setup theme field
        settingsView.chooseTheme.text = themeChoosed
        settingsView.chooseTheme.isSearchEnable = false
        settingsView.chooseTheme.selectedRowColor = .lightGray
        settingsView.chooseTheme.textColor = colorBlackWhite
        
        let paddingView2: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
        settingsView.chooseTheme.leftView = paddingView2
        settingsView.chooseTheme.leftViewMode = .always
        
        settingsView.chooseTheme.didSelect { [self] (selectedText, index, id) in
            self.themeChoosed = selectedText
            print(Int(appearanceData[index][0])!)
            themeID_choosed = Int(appearanceData[index][0])!
            if Int(appearanceData[index][0])! == 1 {
                UserDefaults.standard.set("light", forKey: "ThemeAppereance")
            }
            else {
                UserDefaults.standard.set("dark", forKey: "ThemeAppereance")
            }
            
            darkGrayLight = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00) : UIColor.darkGray)

            colorLine = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00) : UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00))

            colorGrayWhite = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.00) : UIColor.white)

            contentColor = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor(red: 0.19, green: 0.19, blue: 0.20, alpha: 1.00) : UIColor.white)

            alertColor = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1) : UIColor.white)

            toolbarColor = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor(red: 0.20, green: 0.20, blue: 0.21, alpha: 1.00) : UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00))

            colorBlackWhite = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor.white : UIColor.black)

            colorLightDarkGray = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.00) : UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00))

            colorLightDarkGray2 = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 1.00) : UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00))

            colorGrayandDark = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 1.00) : UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00))
            
            putRequest(type: "theme")
        }
        
        
        for i in 0 ..< appearanceData.count {
            settingsView.chooseTheme.optionArray.append(appearanceData[i][1])
            settingsView.chooseTheme.optionIds?.append(Int(appearanceData[i][0])!)
        }
        
        
        settingsView.pushSwitch.isOn = pushNotification
        settingsView.promotionsSwitch.isOn = promotionNotification
        settingsView.smsSwitch.isOn = smsNotification
        settingsView.bioSwitch.isOn = UserDefaults.standard.bool(forKey: "BiometricEnter")
        
        settingsView.pushSwitch.addTarget(self, action: #selector(switchChange), for: .touchUpInside)
        settingsView.promotionsSwitch.addTarget(self, action: #selector(switchChange), for: .touchUpInside)
        settingsView.smsSwitch.addTarget(self, action: #selector(switchChange), for: .touchUpInside)
        settingsView.bioSwitch.addTarget(self, action: #selector(switchEnterChange), for: .touchUpInside)
        
        scrollView.frame = CGRect(x: 0, y: 60 + (topPadding ?? 0), width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 60 + (topPadding ?? 0) + (bottomPadding ?? 0)))
    }

    
    @objc func changeCodeTap() {
        print("hello")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.pushViewController(ChangeCodeController(), animated: true)
    }
    
    @objc func switchChange(_ sender: Any) {
        
        pushNotification = settingsView.pushSwitch.isOn
        promotionNotification = settingsView.promotionsSwitch.isOn
        smsNotification = settingsView.smsSwitch.isOn
        putRequest(type: "switch")
    }
    
    @objc func switchEnterChange(_ sender: Any) {
        UserDefaults.standard.set(settingsView.bioSwitch.isOn, forKey: "BiometricEnter")
     
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
                                appearanceData.append([String(result.appearance[i].themeId), String(result.appearance[i].themeDescription)])
                                if result.appearance[i].selected == true {
                                    themeChoosed = String(result.appearance[i].themeDescription)
                                }
                            }
                        }
                        
                        if result.languages.count != 0 {
                            for i in 0 ..< result.languages.count {
                                langData.append([String(result.languages[i].id), String(result.languages[i].selected), String(result.languages[i].description)])
                                if result.languages[i].selected == true {
                                    langChoosed = String(result.languages[i].description)
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
                    DispatchQueue.main.async { [self] in
                        hideActivityIndicator(uiView: self.view)
                        requestAnswer(message: defaultLocalizer.stringForKey(key: "service is temporarily unavailable"))
                    }
                },
                onCompleted: {
                    DispatchQueue.main.async {
                        self.hideActivityIndicator(uiView: self.view)
                        self.setupView()
                    }
                   print("Completed event.")
                    
                }).disposed(by: disposeBag)
              }
              catch{
            }
    }
    
    @objc func putRequest(type: String) {
        
        //self.showActivityIndicator(uiView: self.view)
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
                    DispatchQueue.main.async { [self] in
                      //  hideActivityIndicator(uiView: self.view)
                        requestAnswer(message: defaultLocalizer.stringForKey(key: "service is temporarily unavailable"))
                    }
                },
                onCompleted: {
                   print("Completed event.")
                    DispatchQueue.main.async {
                        //self.hideActivityIndicator(uiView: self.view)
                    }
                }).disposed(by: disposeBag)
              }
              catch{
                  
            }
    }
    
    @objc func putRequest2() {
        
        if UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" {
            themeID_choosed = 2
        }
        else {
            themeID_choosed = 1
        }
        langId_choosed = UserDefaults.standard.integer(forKey: "language")
        
        let parametr: [String: Any] = ["promotionNotification": promotionNotification, "pushNotification": pushNotification, "emailNotification" : emailNotification, "smsNotification" : smsNotification, "languageId": langId_choosed, "themeId" : themeID_choosed]
        print(parametr)
        let client = APIClient.shared
            do{
                try client.settingsPutRequest(jsonBody: parametr).subscribe (
                onNext: { result in
                    print("hello")
                    DispatchQueue.main.async { [self] in
                        sendRequest()
                    }
                },
                onError: { error in
                   print(error.localizedDescription)
                    DispatchQueue.main.async { [self] in
                        hideActivityIndicator(uiView: self.view)
                        requestAnswer(message: defaultLocalizer.stringForKey(key: "service is temporarily unavailable"))
                    }
                },
                onCompleted: {
                   print("Completed event.")
                    DispatchQueue.main.async {
                       // self.hideActivityIndicator(uiView: self.view)
                    }
                }).disposed(by: disposeBag)
              }
              catch{
                  
            }
    }
    
    func restartApp() {
        
        switch langId_choosed {
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
        
        print("themeId = \(themeID_choosed)")
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
        
        present(alert, animated: true, completion: nil)

    }
    
    @objc func dismissDialog() {
        alert.dismiss(animated: true, completion: nil)
    }
}


