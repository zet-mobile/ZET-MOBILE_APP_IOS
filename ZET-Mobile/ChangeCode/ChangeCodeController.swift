//
//  ChangeCodeController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 1/15/22.
//

import UIKit

class ChangeCodeController: UIViewController, UIScrollViewDelegate {
    
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    let scrollView = UIScrollView()
    
    var toolbar = TarifToolbarView()
    var change_code_view = ChangeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.backgroundColor = contentColor
       // scrollView.isScrollEnabled = false
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 850)
        view.addSubview(scrollView)
        
        setupView()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupView() {
        
        view.backgroundColor = contentColor
  
        
        toolbar = TarifToolbarView(frame: CGRect(x: 0, y: (topPadding ?? 0), width: UIScreen.main.bounds.size.width, height: 60))
        change_code_view = ChangeView(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        
        change_code_view.button.addTarget(self, action: #selector(setPassword), for: .touchUpInside)
        toolbar.icon_back.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        let back = UITapGestureRecognizer(target: self, action: #selector(goBack))
        toolbar.isUserInteractionEnabled = true
        toolbar.addGestureRecognizer(back)
        
        toolbar.backgroundColor = contentColor
        
        self.view.addSubview(toolbar)
        scrollView.addSubview(change_code_view)
        
        toolbar.icon_back.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        
        print(UserDefaults.standard.string(forKey: "PinCode"))
        if UserDefaults.standard.string(forKey: "PinCode") == "" || UserDefaults.standard.string(forKey: "PinCode") == nil {
            toolbar.number_user_name.text = defaultLocalizer.stringForKey(key: "Set_password")
            change_code_view.titleOne.text =  defaultLocalizer.stringForKey(key: "password_code")
            change_code_view.titleTwo.text =  defaultLocalizer.stringForKey(key: "Re-enter_password")
            change_code_view.titleTwo.frame.origin.y = 110
            change_code_view.new_code.frame.origin.y = 140
            change_code_view.gray_back.frame.origin.y = 220
            change_code_view.gray_back.frame.size.height = 60
            change_code_view.titleThree.isHidden = true
            change_code_view.confirm_code.isHidden = true
            change_code_view.button.setTitle(defaultLocalizer.stringForKey(key: "Set_password"), for: .normal)
            change_code_view.button.frame.origin.y = UIScreen.main.bounds.size.height - (bottomPadding ?? 0) - (topPadding ?? 0) - 130
            scrollView.frame = CGRect(x: 0, y: 60 + (topPadding ?? 0), width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        }
        else {
            toolbar.number_user_name.text = defaultLocalizer.stringForKey(key: "Change_PIN")
            change_code_view.titleOne.text = "Введите старый пароль"
            change_code_view.titleTwo.text = "Новый пароль"
            change_code_view.titleThree.text = "Повторите новый пароль"
            change_code_view.titleTwo.frame.origin.y = 120
            change_code_view.new_code.frame.origin.y = 150
            change_code_view.gray_back.frame.origin.y = 360
            change_code_view.gray_back.frame.size.height = 60
            change_code_view.titleThree.isHidden = false
            change_code_view.confirm_code.isHidden = false
            change_code_view.button.setTitle(defaultLocalizer.stringForKey(key: "Change_PIN"), for: .normal)
            change_code_view.button.frame.origin.y = UIScreen.main.bounds.size.height - ContainerViewController().tabBar.frame.size.height - (bottomPadding ?? 0) - (topPadding ?? 0) - 150
            scrollView.frame = CGRect(x: 0, y: 60 + (topPadding ?? 0), width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 60 + (topPadding ?? 0) + (bottomPadding ?? 0)))
        }
        
    }
    
    @objc func setPassword(_ sender: UIButton) {
        
        sender.showAnimation { [self] in
            
        }
        print(change_code_view.old_code.text)
        print(change_code_view.new_code.text)
        change_code_view.gray_back.frame.size.height = 100
        change_code_view.title1.frame.origin.y = 10
        
        if UserDefaults.standard.string(forKey: "PinCode") == "" || UserDefaults.standard.string(forKey: "PinCode") == nil {
            
            if change_code_view.old_code.text != change_code_view.new_code.text {
                change_code_view.title2.text = "✖︎  " + defaultLocalizer.stringForKey(key: "Error_password_again")
                change_code_view.new_code.layer.borderColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00).cgColor
            }
            else {
                change_code_view.new_code.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
            }
            
            if change_code_view.new_code.text == "" {
                change_code_view.title2.text = "✖︎  " + defaultLocalizer.stringForKey(key: "Error_confirmation_password")
                change_code_view.new_code.layer.borderColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00).cgColor
            }
            else {
                change_code_view.new_code.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
            }
            
            if change_code_view.old_code.text?.count != 4 {
                change_code_view.title2.text = "✖︎  " + defaultLocalizer.stringForKey(key: "Error_four-digit_password")
                change_code_view.old_code.layer.borderColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00).cgColor
            }
            else {
                change_code_view.old_code.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
            }
            
            
            
            if change_code_view.old_code.text == change_code_view.new_code.text && change_code_view.new_code.text != "" && change_code_view.old_code.text != "" {
                change_code_view.title2.text = "✓  " + defaultLocalizer.stringForKey(key: "Password_saved!")
                change_code_view.title2.textColor = UIColor(red: 0.37, green: 0.76, blue: 0.36, alpha: 1.00)
                UserDefaults.standard.set(String(change_code_view.new_code.text!), forKey: "PinCode")
                UserDefaults.standard.set(true, forKey: "BiometricEnter")
                goHome()
            }
            
            
        }
        else {
            if change_code_view.old_code.text?.count != 4 {
                change_code_view.title2.text = "✖︎  " + defaultLocalizer.stringForKey(key: "Error_four-digit_password")
                change_code_view.old_code.layer.borderColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00).cgColor
            }
            else {
                change_code_view.old_code.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
            }
            
            
            if change_code_view.old_code.text != UserDefaults.standard.string(forKey: "PinCode") {
                change_code_view.title2.text = "✖︎  " + defaultLocalizer.stringForKey(key: "Incorrect_code")
                change_code_view.old_code.layer.borderColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00).cgColor
            }
            else {
                change_code_view.old_code.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
            }
            
            if change_code_view.new_code.text != change_code_view.confirm_code.text {
                change_code_view.title2.text = "✖︎  " + defaultLocalizer.stringForKey(key: "Error_password_again")
                change_code_view.new_code.layer.borderColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00).cgColor
            }
            else {
                change_code_view.new_code.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
            }
            
            if change_code_view.confirm_code.text == "" {
                change_code_view.title2.text = "✖︎  " + defaultLocalizer.stringForKey(key: "Error_confirmation_password")
                change_code_view.confirm_code.layer.borderColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00).cgColor
            }
            else {
                change_code_view.confirm_code.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
            }
            
            
            if change_code_view.old_code.text == UserDefaults.standard.string(forKey: "PinCode") && change_code_view.new_code.text == change_code_view.confirm_code.text && change_code_view.new_code.text != "" && change_code_view.old_code.text != "" && change_code_view.confirm_code.text != "" {
                
                change_code_view.title2.text = "✓  " + defaultLocalizer.stringForKey(key: "Password_saved!")
                change_code_view.title2.textColor = UIColor(red: 0.37, green: 0.76, blue: 0.36, alpha: 1.00)
                UserDefaults.standard.set(String(change_code_view.new_code.text!), forKey: "PinCode")
                
            }
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
