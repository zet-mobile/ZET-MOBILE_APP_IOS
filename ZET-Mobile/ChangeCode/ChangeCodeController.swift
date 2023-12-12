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
        //because boarder changes color , set is prog-lly
        change_code_view.old_code.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        change_code_view.new_code.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        change_code_view.confirm_code.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        change_code_view.errorInfo.text = ""
        //gray backgroundView is out of NSLayout
        change_code_view.gray_back.frame.size.height = 60
        
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
  
        view.backgroundColor = contentColor
  
        toolbar = TarifToolbarView(frame: CGRect(x: 0, y: (topPadding ?? 0), width: UIScreen.main.bounds.size.width, height: 60))
        toolbar.backgroundColor = contentColor
        change_code_view = ChangeView(frame: CGRect(x: 0, y: 60 + (topPadding ?? 0), width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
       
        // Создание UIView для заднего фона
        //    let backgroundView = UIView()
        //    backgroundView.backgroundColor = UIColor.green
        //    backgroundView.layer.cornerRadius = 20 // Задаем радиус закругления углов
        //     backgroundView.translatesAutoresizingMaskIntoConstraints = false
        //  change_code_view.addSubview(backgroundView)
        //
        // Добавление констрейнтов для backgroundView
        //   NSLayoutConstraint.activate([
        //        backgroundView.leadingAnchor.constraint(equalTo: change_code_view.leadingAnchor, constant: 20), // Отступ слева
        //        backgroundView.trailingAnchor.constraint(equalTo: change_code_view.trailingAnchor, constant: -20), // Отступ справа
        //       backgroundView.topAnchor.constraint(equalTo: change_code_view.confirm_code.bottomAnchor, constant: 30), // Отступ сверху
        //       backgroundView.heightAnchor.constraint(equalToConstant: 110) // Отступ снизу
        //    ])
    
        
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
        
        //this part for showing up afer autorisation
        if UserDefaults.standard.string(forKey: "PinCode") == "" || UserDefaults.standard.string(forKey: "PinCode") == nil {
           
            toolbar.number_user_name.text = defaultLocalizer.stringForKey(key: "Set_password")
            toolbar.icon_back.isHidden = true
            
            change_code_view.oldCodeLabel.text =  defaultLocalizer.stringForKey(key: "password_code")
            change_code_view.newCodeLabel.text =  defaultLocalizer.stringForKey(key: "Re-enter_password")
            // out of NSLayout
            change_code_view.gray_back.frame.origin.y = 220
            change_code_view.gray_back.frame.size.height = 60
            change_code_view.codeConfirmLabel.isHidden = true
            change_code_view.confirm_code.isHidden = true
            change_code_view.button.setTitle(defaultLocalizer.stringForKey(key: "Set_password"), for: .normal)
            // out of NSLayout
            change_code_view.button.frame.origin.y = UIScreen.main.bounds.size.height - (bottomPadding ?? 0) - (topPadding ?? 0) - 130
            change_code_view.frame = CGRect(x: 0, y: 60 + (topPadding ?? 0), width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        }
        else
        {
         //this part for showing up in "Settings"
            toolbar.number_user_name.text = defaultLocalizer.stringForKey(key: "Change_PIN")
            toolbar.icon_back.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
            let back = UITapGestureRecognizer(target: self, action: #selector(goBack))
            toolbar.isUserInteractionEnabled = true
            toolbar.addGestureRecognizer(back)
            toolbar.icon_back.isHidden = false
            
            change_code_view.oldCodeLabel.text = defaultLocalizer.stringForKey(key: "current_PIN")
            change_code_view.newCodeLabel.text = defaultLocalizer.stringForKey(key: "New_PIN")
            change_code_view.codeConfirmLabel.text = defaultLocalizer.stringForKey(key: "Re-enter_PIN")
            // out of NSLayout
            change_code_view.gray_back.frame.origin.y = 330
            change_code_view.gray_back.frame.size.height = 60
            change_code_view.codeConfirmLabel.isHidden = false
            change_code_view.confirm_code.isHidden = false
            change_code_view.button.setTitle(defaultLocalizer.stringForKey(key: "Change_PIN"), for: .normal)
            // out of NSLayout
            change_code_view.button.frame.origin.y = UIScreen.main.bounds.size.height - ContainerViewController().tabBar.frame.size.height - (bottomPadding ?? 0) - (topPadding ?? 0) - 130
            change_code_view.frame = CGRect(x: 0, y: 60 + (topPadding ?? 0), width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 60 + (topPadding ?? 0) + (bottomPadding ?? 0)))
        }
        
    }
    
    @objc func setPassword(_ sender: UIButton) {
        
        sender.showAnimation { [self] in
            
        }
        print(change_code_view.old_code.text)
        print(change_code_view.new_code.text)
        
        // out of NSLayout
        change_code_view.gray_back.frame.size.height = 100
        
        if UserDefaults.standard.string(forKey: "PinCode") == "" || UserDefaults.standard.string(forKey: "PinCode") == nil {
            //this part for showing up afer autorisation
            change_code_view.old_code.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
            change_code_view.new_code.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
            change_code_view.confirm_code.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
            
            if change_code_view.old_code.text?.count != 4 {
                change_code_view.errorInfo.text = "✖︎  " + defaultLocalizer.stringForKey(key: "Error_four-digit_password")
                change_code_view.old_code.layer.borderColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00).cgColor
                change_code_view.new_code.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
            }
            else
            if change_code_view.new_code.text?.count != 4 && change_code_view.old_code.text != "" {
                change_code_view.errorInfo.text = "✖︎  " + defaultLocalizer.stringForKey(key: "Error_confirmation_password")
                change_code_view.new_code.layer.borderColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00).cgColor
                change_code_view.old_code.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
            }
            else
            if change_code_view.old_code.text != change_code_view.new_code.text {
                change_code_view.errorInfo.text = "✖︎  " + defaultLocalizer.stringForKey(key: "Error_password_again")
                change_code_view.new_code.layer.borderColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00).cgColor
                change_code_view.old_code.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
            }
            else
            if change_code_view.old_code.text == change_code_view.new_code.text && change_code_view.new_code.text != "" && change_code_view.old_code.text != "" {
                change_code_view.errorInfo.text = "✓  " + defaultLocalizer.stringForKey(key: "Password_saved!")
                change_code_view.errorInfo.textColor = UIColor(red: 0.37, green: 0.76, blue: 0.36, alpha: 1.00)
                UserDefaults.standard.set(String(change_code_view.new_code.text!), forKey: "PinCode")
                //UserDefaults.standard.set(true, forKey: "BiometricEnter")
                goHome()
            }
        }
        else
        { //this part for showing up in "Settings"
            change_code_view.old_code.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
            change_code_view.new_code.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
            change_code_view.confirm_code.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
            
            if change_code_view.old_code.text?.count != 4 || change_code_view.old_code.text != UserDefaults.standard.string(forKey: "PinCode") {
                change_code_view.errorInfo.text = "✖︎  " + defaultLocalizer.stringForKey(key: "enter_current_passcode")
                change_code_view.old_code.layer.borderColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00).cgColor
                change_code_view.new_code.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
            }
            else
            if change_code_view.new_code.text?.count != 4 {
                change_code_view.errorInfo.text = "✖︎  " + defaultLocalizer.stringForKey(key: "Error_four-digit_password")
                change_code_view.new_code.layer.borderColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00).cgColor
            }
            else
            if change_code_view.old_code.text == change_code_view.new_code.text {
                change_code_view.errorInfo.text = "✖︎  " + defaultLocalizer.stringForKey(key: "Error_password_again")
                change_code_view.new_code.layer.borderColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00).cgColor
            }
            else
            if change_code_view.confirm_code.text?.count != 4  && change_code_view.new_code.text != "" {
                change_code_view.errorInfo.text = "✖︎  " + defaultLocalizer.stringForKey(key: "Error_four-digit_password")
                change_code_view.confirm_code.layer.borderColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00).cgColor
                change_code_view.new_code.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
                change_code_view.old_code.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
            }
            else
            if change_code_view.new_code.text != change_code_view.confirm_code.text {
                change_code_view.errorInfo.text = "✖︎  " + defaultLocalizer.stringForKey(key: "Error_password_again")
                change_code_view.new_code.layer.borderColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00).cgColor
            }
            else
            if change_code_view.old_code.text == UserDefaults.standard.string(forKey: "PinCode") && change_code_view.new_code.text == change_code_view.confirm_code.text && change_code_view.new_code.text != "" && change_code_view.old_code.text != "" && change_code_view.confirm_code.text != "" &&  change_code_view.new_code.text?.count == 4 &&  change_code_view.confirm_code.text?.count == 4 {
                
                change_code_view.errorInfo.text = "✓  " + defaultLocalizer.stringForKey(key: "Password_saved!")
                change_code_view.errorInfo.textColor = UIColor(red: 0.37, green: 0.76, blue: 0.36, alpha: 1.00)
               
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
