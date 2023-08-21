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
    
    var timer = Timer()
    var tryTimer = 1
    var totalTime = 59
    
    var timerCounting: Bool = false
    var startTime: Date?
    var stopTime: Date?
    
    let userDefaults = UserDefaults.standard
    let START_TIME_KEY = "startTime"
    let COUNTING_KEY = "countingKey"
    let TOTAL_TIME_KEY = "totalTime"
    let TRY_TIMER_KEY = "tryTimer"
    
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
        
        setupView()
        
        startTime = userDefaults.object(forKey: START_TIME_KEY) as? Date
        timerCounting = userDefaults.bool(forKey: COUNTING_KEY)
        totalTime = userDefaults.integer(forKey: TOTAL_TIME_KEY)
        tryTimer = userDefaults.integer(forKey: TRY_TIMER_KEY)
        
        if timerCounting == true {
            let diff = Date().timeIntervalSince(startTime!)
            totalTime -= Int(diff)
            let time = secondsToHoursMinutesSeconds(totalTime)
            let timeString = makeTimeString(min: time.0, sec: time.1)
            
            if totalTime >= 0 {
                pincode_view.titleTryies.text = defaultLocalizer.stringForKey(key: "block_code")  +  " " + timeString
                pincode_view.titleTryies.isHidden = false
                let buttons = getButtonsInView(view: pincode_view)
                for button in buttons {
                    button.isUserInteractionEnabled = false
                    button.isEnabled = false
                }
            }
            else {
                timer.invalidate()
                setTimerCounting(false)
                pincode_view.titleTryies.text = defaultLocalizer.stringForKey(key: "block_code")  + "00:00"
                pincode_view.titleTryies.isHidden = true
                
                let buttons = getButtonsInView(view: pincode_view)
                for button in buttons {
                    button.isUserInteractionEnabled = true
                    button.isEnabled = true
                }
                
            }
            
            print(startTime)
            print(Int(diff))
            print("totalTime")
            print(totalTime)
            totalTime -= 1
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }
        else {
            if timer != nil
            {
                timer.invalidate()
            }
            setTimerCounting(false)
            
        }
        
        print("timerCounting")
        print(timerCounting)
    }
    
    @objc func appWillEnterForeground() {
        startTime = userDefaults.object(forKey: START_TIME_KEY) as? Date
        timerCounting = userDefaults.bool(forKey: COUNTING_KEY)
        totalTime = userDefaults.integer(forKey: TOTAL_TIME_KEY)
       
        if timerCounting == true {
            let diff = Date().timeIntervalSince(startTime!)
            totalTime -= Int(diff)
            let time = secondsToHoursMinutesSeconds(totalTime)
            let timeString = makeTimeString(min: time.0, sec: time.1)
            
            if totalTime >= 0 {
                pincode_view.titleTryies.text = defaultLocalizer.stringForKey(key: "block_code")  +  " " + timeString
                pincode_view.titleTryies.isHidden = false
                
                let buttons = getButtonsInView(view: pincode_view)
                for button in buttons {
                    button.isUserInteractionEnabled = false
                    button.isEnabled = false
                }
            }
            else {
                timer.invalidate()
                setTimerCounting(false)
                pincode_view.titleTryies.text = defaultLocalizer.stringForKey(key: "block_code")  + "00:00"
                pincode_view.titleTryies.isHidden = true
                let buttons = getButtonsInView(view: pincode_view)
                for button in buttons {
                    button.isUserInteractionEnabled = true
                    button.isEnabled = true
                }
            }
            
            print(startTime)
            print(Int(diff))
            print("totalTime")
            print(totalTime)
            
            totalTime -= 1
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }
        else {
            if timer != nil
            {
                timer.invalidate()
            }
            setTimerCounting(false)
        }
    }
    
    @objc func appDidEnterBackground() {
       setStartTime(date: Date())
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
            button.isUserInteractionEnabled =  true
            if button.titleLabel?.text != "" {
                if button.titleLabel?.text?.count == 1 {
                    button.addTarget(self, action: #selector(clickButton(sender:)), for: .touchUpInside)
                }
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
        print("vvvvv")

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = defaultLocalizer.stringForKey(key: "touch_ask")
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
                        print("jjjjj")
                        print(authenticationError!._code)
                    }
                }
            }
        } else {
            print("fegregre")
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
        let d = Date()
        let df = DateFormatter()
        df.dateFormat = "y-MM-dd H:mm:ss.SSSS"
        sender.showAnimation { [self] in
        }
        print("433333 : \(df.string(from: d))")

         if enterPlace[2].backgroundColor == UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00) &&
            enterPlace[3].backgroundColor == UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00) &&
            enterPlace[4].backgroundColor == UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00)

        {
             //enterPlace[clickTime + 1].backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)

             
           // enterPlace[2].backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
         //   enterPlace[3].backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
         //   enterPlace[4].backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
             print("43433334 : \(df.string(from: d))")

        }
        enterPlace[clickTime].backgroundColor = UIColor.orange
        clickTime = clickTime + 1
        pincode_view.titleTryies.isHidden = true
        pas = pas + String(sender.titleLabel!.text!)
        print("999999 : \(df.string(from: d))")
        if (clickTime == 5) {
            print("101010 : \(df.string(from: d))")

            if (pas == UserDefaults.standard.string(forKey: "PinCode")) {
                print("aaaaaa : \(df.string(from: d))")

                clickTime = 1
                pas = ""
                print("dd")
                enterPlace[1].backgroundColor = UIColor(red: 0.37, green: 0.76, blue: 0.36, alpha: 1.00)
                enterPlace[2].backgroundColor = UIColor(red: 0.37, green: 0.76, blue: 0.36, alpha: 1.00)
                enterPlace[3].backgroundColor = UIColor(red: 0.37, green: 0.76, blue: 0.36, alpha: 1.00)
                enterPlace[4].backgroundColor = UIColor(red: 0.37, green: 0.76, blue: 0.36, alpha: 1.00)
                print("bbbbbb : \(df.string(from: d))")

                let buttons = getButtonsInView(view: pincode_view)
                for button in buttons {
                    button.isUserInteractionEnabled = false
                    button.isEnabled = false
                    print("ccccccc : \(df.string(from: d))")

                }
                
                print("dddddd : \(df.string(from: d))")

                timer.invalidate()
                setTimerCounting(false)
                totalTime = 59
                userDefaults.set(1, forKey: TRY_TIMER_KEY)
                print("eeeeeee : \(df.string(from: d))")

                DispatchQueue.main.asyncAfter(deadline: .now() + 01.0) { [self] in
                    print("ffffff : \(df.string(from: d))")

                    guard let window = UIApplication.shared.keyWindow else {
                       return
                    }
                    print("ggggggg : \(df.string(from: d))")

                    guard let rootViewController = window.rootViewController else {
                       return
                    }
                    print("hhhhhhhh : \(df.string(from: d))")

                    let vc = ContainerViewController()
                    print("jjjjjjjj : \(df.string(from: d))")

                    vc.view.frame = rootViewController.view.frame
                    print("kkkkkkkkk : \(df.string(from: d))")

                    vc.view.layoutIfNeeded()
                    print("LLLLLLLL : \(df.string(from: d))")

                    UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromLeft, animations: {
                           window.rootViewController = vc
                     }, completion: nil)
                    print("zzzzzzzzzz : \(df.string(from: d))")

                }
                
            }
            else if (tryCode != 0) {
                print("xxxxxxxxx : \(df.string(from: d))")

                enterPlace[1].backgroundColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00)
                enterPlace[2].backgroundColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00)
                enterPlace[3].backgroundColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00)
                enterPlace[4].backgroundColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00)
                print("vvvvvvv : \(df.string(from: d))")

                pincode_view.titleTryies.isHidden = false
                pincode_view.titleTryies.text = defaultLocalizer.stringForKey(key: "wrong_code_try_count") + String(tryCode)
                tryCode = tryCode - 1
                clickTime = 1
                pas = ""
                print("nnnnnnnnnnnn : \(df.string(from: d))")

                DispatchQueue.main.asyncAfter(deadline: .now() + 01.0) { [self] in
                    if enterPlace[2].backgroundColor == UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00) && enterPlace[3].backgroundColor == UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00) && enterPlace[4].backgroundColor == UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00) {
                        print("mmmmmmmmmm : \(df.string(from: d))")

                        enterPlace[1].backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
                        enterPlace[2].backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
                        enterPlace[3].backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
                        enterPlace[4].backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
                    }
                    
                    print(">>>>>>>>> : \(df.string(from: d))")

                    pincode_view.titleTryies.isHidden = true
                    pincode_view.titleTryies.text = ""
                }
       }
            else {
                print("qqqqqqqq : \(df.string(from: d))")
                enterPlace[1].backgroundColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00)
                enterPlace[2].backgroundColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00)
                enterPlace[3].backgroundColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00)
                enterPlace[4].backgroundColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00)
                pincode_view.titleTryies.isHidden = false
                print("wwwwwwwwww : \(df.string(from: d))")
                switch tryTimer {
                case 1:
                    pincode_view.titleTryies.text = defaultLocalizer.stringForKey(key: "block_code")  +  " " + "01:00"
                    totalTime = 59
                    break
                case 2:
                    pincode_view.titleTryies.text = defaultLocalizer.stringForKey(key: "block_code")  +  " " + "10:00"
                    totalTime = 599
                    break
                case 3:
                    pincode_view.titleTryies.text = defaultLocalizer.stringForKey(key: "block_code")  +  " " + "20:00"
                    totalTime = 1199
                    break
                default:
                    tryTimer = 1
                    totalTime = 59
                    break
               }
                print("eeeeeeeee : \(df.string(from: d))")
                let buttons = getButtonsInView(view: pincode_view)
                for button in buttons {
                    button.isUserInteractionEnabled = false
                    button.isEnabled = false
                }
                print("rrrrrrrrrrrr : \(df.string(from: d))")
                clickTime = 1
                pas = ""
                tryCode = 2
                tryTimer += 1
                userDefaults.set(tryTimer, forKey: TRY_TIMER_KEY)
                timer.invalidate()
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
                print("ttttttttttt : \(df.string(from: d))")

            }
        }
    }
    
    @objc func updateTimer() {
        
        if totalTime > 0 {
            print(totalTime)
            let time = secondsToHoursMinutesSeconds(totalTime)
            let timeString = makeTimeString(min: time.0, sec: time.1)
            pincode_view.titleTryies.text = defaultLocalizer.stringForKey(key: "block_code")  +  " " + timeString
            totalTime -= 1  // decrease counter timer
            setTimerCounting(true)
            setTotalTime(totalTime)
        } else {
            timer.invalidate()
            setTimerCounting(false)
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
    
    @objc func deleteSymbol() {
        if pas.count == 0 {
          print("delete symbol : ")
        }
        else if pas.count > 1 && pas.count != 0 {
            enterPlace[clickTime - 1].backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
            clickTime = clickTime - 1
            pas.removeLast()
              print("delete symbol 3 : ")

        } else {
                  print("delete symbol : 4")

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

        view.backgroundColor = alertColor
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
        timer.invalidate()
        setTimerCounting(false)
        totalTime = 59
        userDefaults.set(1, forKey: TRY_TIMER_KEY)
        
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
        }, completion: { [self] completed in
            UserDefaults.standard.set("", forKey: "mobPhone")
            UserDefaults.standard.set("", forKey: "PinCode")
            
            UserDefaults.standard.set(1, forKey: "language")
            UserDefaults.standard.set(LanguageType.ru.rawValue, forKey: "language_string")
            self.setTimerCounting(false)
            self.defaultLocalizer.setSelectedLanguage(lang: .ru)
           // UserDefaults.standard.set(true, forKey: "BiometricEnter")
        })
    }
}
