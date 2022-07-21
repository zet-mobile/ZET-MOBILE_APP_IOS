//
//  PinCodeInputController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 1/9/22.
//

import UIKit
import LocalAuthentication

class PinCodeInputController: UIViewController , UIScrollViewDelegate {
    
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    var alert = UIAlertController()
    var pincode_view = PinCodeView()
    
    var enterPlace = [UIView()]
    var clickTime = 1
    var pas = ""
    var tryCode = 2
    
    var minute = 00
    var seconds = 20
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func setupView() {
        view.backgroundColor = contentColor
  
        pincode_view = PinCodeView(frame: CGRect(x: 0, y: 104, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        
        enterPlace.append(pincode_view.number1)
        enterPlace.append(pincode_view.number2)
        enterPlace.append(pincode_view.number3)
        enterPlace.append(pincode_view.number4)
        
        let buttons = getButtonsInView(view: pincode_view)
        for button in buttons {
            if Int((button.titleLabel?.text)!) != nil {
                button.addTarget(self, action: #selector(clickButton(sender:)), for: .touchUpInside)
            }
        }
        pincode_view.forget_but.addTarget(self, action: #selector(forgetPass), for: .touchUpInside)
        pincode_view.delete.addTarget(self, action: #selector(deleteSymbol), for: .touchUpInside)
        
        self.view.addSubview(pincode_view)
      
        showTouchId(uiView: self.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? .lightContent : .darkContent)
    }
    
    func checkTouch() {
        let context = LAContext()
        
        //context.localizedCancelTitle = "Ввести пин-код"
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Приложите палец к сканеру"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        
                        print("dd")
                        
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
                       
                    } else {
                        switch authenticationError!._code {
                            
                        case LAError.systemCancel.rawValue:
                            print("Authentication was cancelled by the system")
                            self.hideTouchID(uiView: self.view)
                            //exit(0)
                            
                        case LAError.userCancel.rawValue:
                            print("Authentication was cancelled by the user")
                            self.hideTouchID(uiView: self.view)
                            
                        case LAError.userFallback.rawValue:
                            print("User selected to enter custom password")
                            self.hideTouchID(uiView: self.view)
                            
                        default:
                            print("Authentication failed")
                            self.hideTouchID(uiView: self.view)
                        }
                        
                        print(authenticationError!._code)
                    }
                }
            }
        } else {
            print(error?.localizedDescription as Any)
            hideTouchID(uiView: self.view)
        }
        
    }
    
    func showTouchId(uiView: UIView) {
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColor.clear
        uiView.addSubview(container)
        
        if UserDefaults.standard.bool(forKey: "BiometricEnter") == true {
            checkTouch()
        }
        else {
            self.hideTouchID(uiView: self.view)
        }
        
    }
    
    func hideTouchID(uiView: UIView) {
        container.removeFromSuperview()

    }
    
    @objc func clickButton(sender: UIButton) {
        print(sender.titleLabel?.text)
        
        sender.showAnimation {
            print("hi")
        }
        
        enterPlace[clickTime].backgroundColor = UIColor.orange
      
        clickTime = clickTime + 1
        pas = pas + String(sender.titleLabel!.text!)
        print(pas)
        
        if (clickTime == 5) {
            if (pas == UserDefaults.standard.string(forKey: "PinCode")) {
                clickTime = 1
                pas = ""
                print("dd")
                enterPlace[1].backgroundColor = UIColor(red: 0.37, green: 0.76, blue: 0.36, alpha: 1.00)
                enterPlace[2].backgroundColor = UIColor(red: 0.37, green: 0.76, blue: 0.36, alpha: 1.00)
                enterPlace[3].backgroundColor = UIColor(red: 0.37, green: 0.76, blue: 0.36, alpha: 1.00)
                enterPlace[4].backgroundColor = UIColor(red: 0.37, green: 0.76, blue: 0.36, alpha: 1.00)
                
                let buttons = getButtonsInView(view: pincode_view)
                for button in buttons {
                    button.isUserInteractionEnabled = false
                    button.isEnabled = false
                }
                
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
            else if (tryCode != 0) {
                
                enterPlace[1].backgroundColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00)
                enterPlace[2].backgroundColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00)
                enterPlace[3].backgroundColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00)
                enterPlace[4].backgroundColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00)
                
                pincode_view.titleTryies.isHidden = false
                pincode_view.titleTryies.text = "Код неверный. Попыток осталось " + String(tryCode)
                tryCode = tryCode - 1
                clickTime = 1
                pas = ""
               
                DispatchQueue.main.asyncAfter(deadline: .now() + 01.0) { [self] in
                    enterPlace[1].backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
                    enterPlace[2].backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
                    enterPlace[3].backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
                    enterPlace[4].backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
                    
                    pincode_view.titleTryies.isHidden = true
                }
       }
            else {
                enterPlace[1].backgroundColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00)
                enterPlace[2].backgroundColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00)
                enterPlace[3].backgroundColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00)
                enterPlace[4].backgroundColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00)
                pincode_view.titleTryies.isHidden = false
                pincode_view.titleTryies.text = "Вы заблокированы. \n Пожалуйста подождите 20:00"
                
                let buttons = getButtonsInView(view: pincode_view)
                for button in buttons {
                    button.isUserInteractionEnabled = false
                    button.isEnabled = false
                }
                clickTime = 1
                pas = ""
                tryCode = 2
                
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
               }
        }

    }
    
    @objc func updateTimer() {
        if seconds < 1 && minute != 0{
            minute -= 1
            seconds = 59
            pincode_view.titleTryies.text = "Вы заблокированы. \n Пожалуйста подождите \(String(format: "%02d", minute)):\(String(format: "%02d", seconds))"
        }
        else if seconds < 1 && minute < 1 {
            timer.invalidate()
            let buttons = getButtonsInView(view: pincode_view)
            for button in buttons {
                button.isUserInteractionEnabled = true
                button.isEnabled = true
            }
            pincode_view.titleTryies.isHidden = true
            
            enterPlace[1].backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
            enterPlace[2].backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
            enterPlace[3].backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
            enterPlace[4].backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
            
        } else {
            seconds -= 1
            pincode_view.titleTryies.text = "Вы заблокированы. \n Пожалуйста подождите \(String(format: "%02d", minute)):\(String(format: "%02d", seconds))"
            }
        }
    
    @objc func deleteSymbol() {
        if pas.count == 0 {
          
        }
        else if pas.count > 1 && pas.count != 0 {
            enterPlace[clickTime - 1].backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
            clickTime = clickTime - 1
            pas.removeLast()
        } else {
            enterPlace[1].backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
            clickTime = 1
            pas = ""
        }
    }
    
    @objc func forgetPass() {
        alert = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n", message: "", preferredStyle: .alert)
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
        
        let view = AlertView4()

        view.backgroundColor = contentColor
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 40, height: 280)
        view.layer.cornerRadius = 20
        view.cancel.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
        view.ok.addTarget(self, action: #selector(okClickDialog), for: .touchUpInside)
        
        alert.view.backgroundColor = .clear
        alert.view.addSubview(view)
        //alert.view.sendSubviewToBack(view)
        
        present(alert, animated: true, completion: nil)
    
    }
    
    @objc func dismissDialog(_ sender: UIButton) {
        print("hello")
        sender.showAnimation { [self] in
            alert.dismiss(animated: true, completion: nil)
            
        }
    }
    
    @objc func okClickDialog(_ sender: UIButton) {
        
        sender.showAnimation { [self] in
            alert.dismiss(animated: true, completion: nil)
            
        }
        
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
            UserDefaults.standard.set("", forKey: "mobPhone")
            UserDefaults.standard.set("", forKey: "PinCode")
            UserDefaults.standard.set(true, forKey: "BiometricEnter")
        })
    }
}
