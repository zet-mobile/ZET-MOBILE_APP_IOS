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

class SettingsViewController: UIViewController, UIScrollViewDelegate {
    
    let disposeBag = DisposeBag()
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    let scrollView = UIScrollView()
    
    var toolbar = TarifToolbarView()
    var settings_view = SettingsView()
    
    var lang_data = [[String]]()
    var appearance_data = [[String]]()
    
    var lang_choosed = "Русский"
    var theme_choosed = "Светлая"
    
    var langId_choosed = 0
    var themeID_choosed = 0
    
    var smsNotification = false
    var emailNotification = false
    var pushNotification = false
    var promotionNotification = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.backgroundColor = .white
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 850)
        view.addSubview(scrollView)
        
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
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupView() {
        view.backgroundColor = .white
  
        toolbar = TarifToolbarView(frame: CGRect(x: 0, y: 44, width: UIScreen.main.bounds.size.width, height: 60))
        settings_view = SettingsView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 896))
        
        toolbar.icon_back.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(changeCodeTap))
        settings_view.code_change_t.isUserInteractionEnabled = true
        settings_view.code_change_t.addGestureRecognizer(tap)
        
        self.view.addSubview(toolbar)
        scrollView.addSubview(settings_view)
        
        toolbar.icon_back.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        toolbar.number_user_name.text = "Настройки"
        toolbar.backgroundColor = .white
      
        scrollView.frame = CGRect(x: 0, y: 104, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 104)
        
        // setup language field
        settings_view.lang.text = lang_choosed
        settings_view.lang.isSearchEnable = false
        settings_view.lang.selectedRowColor = .lightGray
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
        settings_view.lang.leftView = paddingView
        settings_view.lang.leftViewMode = .always
        settings_view.lang.didSelect { [self] (selectedText, index, id) in
            self.lang_choosed = selectedText
            self.langId_choosed = Int(lang_data[index][0])!
            putRequest()
        }
        
        for i in 0 ..< lang_data.count {
            settings_view.lang.optionArray.append(lang_data[i][2])
            settings_view.lang.optionIds?.append(Int(lang_data[i][0])!)
            putRequest()
        }
        
        // setup theme field
        settings_view.app_theme.text = theme_choosed
        settings_view.app_theme.isSearchEnable = false
        settings_view.app_theme.selectedRowColor = .lightGray
        let paddingView2: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
        settings_view.app_theme.leftView = paddingView2
        settings_view.app_theme.leftViewMode = .always
        settings_view.app_theme.didSelect { [self] (selectedText, index, id) in
            self.theme_choosed = selectedText
            self.themeID_choosed = Int(appearance_data[index][0])!
        }
        
        
        for i in 0 ..< appearance_data.count {
            settings_view.app_theme.optionArray.append(appearance_data[i][1])
            settings_view.app_theme.optionIds?.append(Int(appearance_data[i][0])!)
        }
        
        
        settings_view.switch_push.isOn = pushNotification
        settings_view.switch_sales.isOn = promotionNotification
        settings_view.switch_email.isOn = emailNotification
        settings_view.switch_sms.isOn = smsNotification
        
        settings_view.switch_push.addTarget(self, action: #selector(switchChange), for: .touchUpInside)
        settings_view.switch_sales.addTarget(self, action: #selector(switchChange), for: .touchUpInside)
        settings_view.switch_email.addTarget(self, action: #selector(switchChange), for: .touchUpInside)
        settings_view.switch_sms.addTarget(self, action: #selector(switchChange), for: .touchUpInside)
    }

    @objc func changeCodeTap() {
        print("hello")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.pushViewController(ChangeCodeController(), animated: true)
    }
    
    @objc func switchChange(_ sender: Any) {
        
            pushNotification = settings_view.switch_push.isOn
            promotionNotification = settings_view.switch_sales.isOn
            emailNotification = settings_view.switch_email.isOn
            smsNotification = settings_view.switch_sms.isOn
       putRequest()
    }
    
    func sendRequest() {
        let client = APIClient.shared
            do{
              try client.settingsGetRequest().subscribe(
                onNext: { result in
                  print(result)
                    DispatchQueue.main.async { [self] in
                        
                        appearance_data.append([String(result.appearance.themeId), String(result.appearance.themeDescription)])
                        
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
                },
                onCompleted: {
                    DispatchQueue.main.async {
                        self.setupView()
                    }
                   print("Completed event.")
                    
                }).disposed(by: disposeBag)
              }
              catch{
            }
    }
    
    @objc func putRequest() {
        
        let parametr: [String: Any] = ["promotionNotification": promotionNotification, "pushNotification": pushNotification, "emailNotification" : emailNotification, "smsNotification" : smsNotification, "languageId": langId_choosed, "themeId" : themeID_choosed]
        
        let client = APIClient.shared
            do{
                try client.settingsPutRequest(jsonBody: parametr).subscribe (
                onNext: { result in
                    print("hello")
                    DispatchQueue.main.async {
                      
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

}


