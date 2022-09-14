//
//  ChangeCodeController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 1/15/22.
//

import UIKit

class ChangeCodeController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {
    
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    var toolbar = TarifToolbarView()
    var change_code_view = ChangeView()
    
    var new_code = ""
    var old_code = ""
    var confirm_code = ""
    
    var activeTextField : UITextField? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
       // NotificationCenter.default.addObserver(self, selector: #selector(ChangeCodeController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
            // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
       // NotificationCenter.default.addObserver(self, selector: #selector(ChangeCodeController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? .lightContent : .darkContent)
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {

      guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {

        // if keyboard size is not available for some reason, dont do anything
        return
      }

      var shouldMoveViewUp = false

      // if active text field is not nil
      if let activeTextField = activeTextField {

        let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.change_code_view).maxY;
        
        let topOfKeyboard = self.change_code_view.frame.height  - keyboardSize.height

        // if the bottom of Textfield is below the top of keyboard, move up
        if bottomOfTextField > topOfKeyboard {
          shouldMoveViewUp = true
        }
      }

      if(shouldMoveViewUp) {
        self.change_code_view.frame.origin.y = (self.toolbar.frame.origin.y + self.toolbar.frame.height) - keyboardSize.height
      }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
      // move back the root view origin to zero
      self.change_code_view.frame.origin.y = self.toolbar.frame.origin.y + self.toolbar.frame.height
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        change_code_view.old_code.resignFirstResponder()
        change_code_view.new_code.resignFirstResponder()
        change_code_view.confirm_code.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        change_code_view.old_code.resignFirstResponder()
        change_code_view.new_code.resignFirstResponder()
        change_code_view.confirm_code.resignFirstResponder()
        return true
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let tag = textField.tag
        print("tag")
        print(tag)
        
        if string  == "" {
            if tag == 1 {
                old_code = (old_code as String).substring(to: old_code.index(before: old_code.endIndex))
            }
            else if tag == 2 {
                new_code = (new_code as String).substring(to: new_code.index(before: new_code.endIndex))
            }
            else if tag == 3 {
                confirm_code = (confirm_code as String).substring(to: confirm_code.index(before: confirm_code.endIndex))
            }
        }
        
        if tag == 1 && string != "" && change_code_view.old_code.text!.count == 4 {
            return false
        }
        else if tag == 1 {
            old_code = old_code + string
            print(old_code)
        }
        
        if tag == 2 && string != "" && change_code_view.new_code.text!.count == 4 {
            return false
        }
        else if tag == 2 {
            new_code = new_code + string
            print(new_code)
        }
        
        if tag == 3 && string != "" && change_code_view.confirm_code.text!.count == 4 {
            return false
        }
        else if tag == 3 {
            confirm_code = confirm_code + string
            print(confirm_code)
        }
        
        
        return true
    }
    
    func setupView() {
        
        view.backgroundColor = contentColor
  
        toolbar = TarifToolbarView(frame: CGRect(x: 0, y: (topPadding ?? 0), width: UIScreen.main.bounds.size.width, height: 60))

        toolbar.backgroundColor = contentColor
        
        
        change_code_view = ChangeView(frame: CGRect(x: 0, y: 60 + (topPadding ?? 0), width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        
        change_code_view.button.addTarget(self, action: #selector(setPassword), for: .touchUpInside)
        
        change_code_view.new_code.delegate = self
        change_code_view.old_code.delegate = self
        change_code_view.confirm_code.delegate = self
        change_code_view.old_code.tag = 1
        change_code_view.new_code.tag = 2
        change_code_view.confirm_code.tag = 3
        
        view.addSubview(toolbar)
        view.addSubview(change_code_view)
        
        print(UserDefaults.standard.string(forKey: "PinCode"))
        if UserDefaults.standard.string(forKey: "PinCode") == "" || UserDefaults.standard.string(forKey: "PinCode") == nil {
            toolbar.number_user_name.text = defaultLocalizer.stringForKey(key: "Set_password")
            toolbar.icon_back.isHidden = true
            
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
            change_code_view.frame = CGRect(x: 0, y: 60 + (topPadding ?? 0), width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        }
        else {
            toolbar.number_user_name.text = defaultLocalizer.stringForKey(key: "Change_PIN")
            toolbar.icon_back.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
            let back = UITapGestureRecognizer(target: self, action: #selector(goBack))
            toolbar.isUserInteractionEnabled = true
            toolbar.addGestureRecognizer(back)
            toolbar.icon_back.isHidden = false
            
            change_code_view.titleOne.text = defaultLocalizer.stringForKey(key: "current_PIN")
            change_code_view.titleTwo.text = defaultLocalizer.stringForKey(key: "New_PIN")
            change_code_view.titleThree.text = defaultLocalizer.stringForKey(key: "Re-enter_PIN")
            change_code_view.titleTwo.frame.origin.y = 110
            change_code_view.new_code.frame.origin.y = 140
            change_code_view.gray_back.frame.origin.y = 360
            change_code_view.gray_back.frame.size.height = 60
            change_code_view.titleThree.isHidden = false
            change_code_view.confirm_code.isHidden = false
            change_code_view.button.setTitle(defaultLocalizer.stringForKey(key: "Change_PIN"), for: .normal)
            change_code_view.button.frame.origin.y = UIScreen.main.bounds.size.height - ContainerViewController().tabBar.frame.size.height - (bottomPadding ?? 0) - 150
            change_code_view.frame = CGRect(x: 0, y: 60 + (topPadding ?? 0), width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 60 + (topPadding ?? 0) + (bottomPadding ?? 0)))
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
            
            change_code_view.old_code.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
            change_code_view.new_code.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
            change_code_view.confirm_code.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
            
            if change_code_view.old_code.text != change_code_view.new_code.text {
                
                change_code_view.title2.text = "✖︎  " + defaultLocalizer.stringForKey(key: "Error_password_again")
                change_code_view.new_code.layer.borderColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00).cgColor
                change_code_view.old_code.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
            }
            else
            if change_code_view.new_code.text == "" && change_code_view.old_code.text != "" {
                change_code_view.title2.text = "✖︎  " + defaultLocalizer.stringForKey(key: "Error_confirmation_password")
                change_code_view.new_code.layer.borderColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00).cgColor
                change_code_view.old_code.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
            }
            else
            if change_code_view.old_code.text?.count != 4 {
                change_code_view.title2.text = "✖︎  " + defaultLocalizer.stringForKey(key: "Error_four-digit_password")
                change_code_view.old_code.layer.borderColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00).cgColor
                change_code_view.new_code.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
            }
            else
            if change_code_view.old_code.text == change_code_view.new_code.text && change_code_view.new_code.text != "" && change_code_view.old_code.text != "" {
                change_code_view.title2.text = "✓  " + defaultLocalizer.stringForKey(key: "Password_saved!")
                change_code_view.title2.textColor = UIColor(red: 0.37, green: 0.76, blue: 0.36, alpha: 1.00)
                UserDefaults.standard.set(String(change_code_view.new_code.text!), forKey: "PinCode")
                UserDefaults.standard.set(true, forKey: "BiometricEnter")
                goHome()
            }
            
            
        }
        else {
            change_code_view.old_code.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
            change_code_view.new_code.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
            change_code_view.confirm_code.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
            
            if change_code_view.old_code.text?.count != 4 {
                change_code_view.title2.text = "✖︎  " + defaultLocalizer.stringForKey(key: "Error_four-digit_password")
                change_code_view.old_code.layer.borderColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00).cgColor
                change_code_view.new_code.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
            }
            else
                if change_code_view.old_code.text != UserDefaults.standard.string(forKey: "PinCode") {
                    change_code_view.title2.text = "✖︎  " + defaultLocalizer.stringForKey(key: "Incorrect_code")
                    change_code_view.old_code.layer.borderColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00).cgColor
                }
            else
                if change_code_view.new_code.text?.count != 4 {
                    change_code_view.title2.text = "✖︎  " + defaultLocalizer.stringForKey(key: "Error_four-digit_password")
                    change_code_view.new_code.layer.borderColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00).cgColor
                }
            else
                if change_code_view.confirm_code
                    .text?.count != 4 {
                    change_code_view.title2.text = "✖︎  " + defaultLocalizer.stringForKey(key: "Error_four-digit_password")
                    change_code_view.new_code.layer.borderColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00).cgColor
                }
            else
                if change_code_view.new_code.text != change_code_view.confirm_code.text {
                    change_code_view.title2.text = "✖︎  " + defaultLocalizer.stringForKey(key: "Error_password_again")
                    change_code_view.new_code.layer.borderColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00).cgColor
                }
            else
                if change_code_view.confirm_code.text == "" {
                    change_code_view.title2.text = "✖︎  " + defaultLocalizer.stringForKey(key: "Error_confirmation_password")
                    change_code_view.confirm_code.layer.borderColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00).cgColor
                }
            else
                if change_code_view.old_code.text == change_code_view.new_code.text{
                    change_code_view.title2.text = "✖︎  " + defaultLocalizer.stringForKey(key: "Error_password_again")
                    change_code_view.new_code.layer.borderColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00).cgColor
                }
            else
            if change_code_view.old_code.text == UserDefaults.standard.string(forKey: "PinCode") && change_code_view.new_code.text == change_code_view.confirm_code.text && change_code_view.new_code.text != "" && change_code_view.old_code.text != "" && change_code_view.confirm_code.text != "" &&  change_code_view.new_code.text?.count == 4 &&  change_code_view.confirm_code.text?.count == 4 {
                
                change_code_view.title2.text = "✓  " + defaultLocalizer.stringForKey(key: "Password_saved!")
                change_code_view.title2.textColor = UIColor(red: 0.37, green: 0.76, blue: 0.36, alpha: 1.00)
               
                DispatchQueue.main.asyncAfter(deadline: .now() + 01.0) { [self] in
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
                        UserDefaults.standard.set(String(self.change_code_view.new_code.text!), forKey: "PinCode")
                    })
                }
            }
        }
    }
    
    func goHome() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 01.0) { [self] in
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

}
