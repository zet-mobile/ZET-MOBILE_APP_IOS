//
//  AskFriendViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 17/05/22.
//

import UIKit
import RxSwift
import RxCocoa
import Contacts
import ContactsUI

class AskFriendViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {

    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    let disposeBag = DisposeBag()
    
    var alert = UIAlertController()
    
    let scrollView = UIScrollView()
    
    var toolbar = TarifToolbarView()
    var askFriendView = AskFriendView()
    
    var balance = ""
    
    var activeTextField : UITextField? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        to_phone = ""
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationController?.tabBarController?.tabBar.isHidden = false
        if to_phone != "" {
            askFriendView.user_to_number.text = to_phone
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? .lightContent : .darkContent)
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        askFriendView.user_to_number.resignFirstResponder()
        askFriendView.count_transfer.resignFirstResponder()
    }
    
    @objc func touchesScroll() {
        askFriendView.user_to_number.resignFirstResponder()
        askFriendView.count_transfer.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {

      guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {

        // if keyboard size is not available for some reason, dont do anything
        return
      }

      var shouldMoveViewUp = false

      // if active text field is not nil
      if let activeTextField = activeTextField {

        let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.askFriendView).maxY;
        
        let topOfKeyboard = self.askFriendView.frame.height  - keyboardSize.height

        // if the bottom of Textfield is below the top of keyboard, move up
        if bottomOfTextField > topOfKeyboard {
          shouldMoveViewUp = true
        }
      }

      if(shouldMoveViewUp) {
        self.askFriendView.frame.origin.y = (self.view.frame.origin.y + self.view.frame.height) - keyboardSize.height
      }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
      // move back the root view origin to zero
      self.askFriendView.frame.origin.y = self.view.frame.origin.y + self.view.frame.height
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        askFriendView.user_to_number.resignFirstResponder()
        askFriendView.count_transfer.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            askFriendView.titleRed.isHidden = true
            askFriendView.user_to_number.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
            askFriendView.titleCount.frame.origin.y = 320
            askFriendView.count_transfer.frame.origin.y = 350
            if askFriendView.titleRed2.isHidden == false {
                askFriendView.titleRed2.frame.origin.y = 410
                askFriendView.titleGray.frame.origin.y = 440
                askFriendView.sendButton.frame.origin.y = 480
            }
            else {
                askFriendView.titleRed2.frame.origin.y = 410
                askFriendView.titleGray.frame.origin.y = 410
                askFriendView.sendButton.frame.origin.y = 450
            }
        }
        else if textField.tag == 2 {
            askFriendView.titleRed2.isHidden = true
            askFriendView.count_transfer.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
            if askFriendView.titleRed.isHidden == true {
                askFriendView.titleGray.frame.origin.y = 410
                askFriendView.sendButton.frame.origin.y = 450
            }
            else {
                askFriendView.titleGray.frame.origin.y = 440
                askFriendView.sendButton.frame.origin.y = 480
            }
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField.tag == 1 {
            askFriendView.user_to_number.textColor = colorBlackWhite
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        askFriendView.titleRed.isHidden = true
        askFriendView.user_to_number.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        askFriendView.titleCount.frame.origin.y = 320
        askFriendView.count_transfer.frame.origin.y = 350
        if askFriendView.titleRed2.isHidden == false {
            askFriendView.titleRed2.frame.origin.y = 410
            askFriendView.titleGray.frame.origin.y = 440
            askFriendView.sendButton.frame.origin.y = 480
        }
        else {
            askFriendView.titleRed2.frame.origin.y = 410
            askFriendView.titleGray.frame.origin.y = 410
            askFriendView.sendButton.frame.origin.y = 450
        }
        
        askFriendView.titleRed2.isHidden = true
        askFriendView.count_transfer.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        if askFriendView.titleRed.isHidden == true {
            askFriendView.titleGray.frame.origin.y = 410
            askFriendView.sendButton.frame.origin.y = 450
        }
        else {
            askFriendView.titleGray.frame.origin.y = 440
            askFriendView.sendButton.frame.origin.y = 480
        }
        
        let tag = textField.tag
        var amount = ""
        
        let cursorPosition = askFriendView.count_transfer.offset(from: askFriendView.count_transfer.beginningOfDocument, to: askFriendView.count_transfer.selectedTextRange!.start)
        
        let cursorPosition2 = askFriendView.user_to_number.offset(from: askFriendView.user_to_number.beginningOfDocument, to: askFriendView.user_to_number.selectedTextRange!.start)
        
        if textField == askFriendView.count_transfer && string == "0" {
           
            if textField.text!.count == 0 || cursorPosition == 0 {
                return false
            }
        }
        
        if cursorPosition == 0 && textField == askFriendView.count_transfer {
            amount = string + askFriendView.count_transfer.text!
        }
        else {
            amount = askFriendView.count_transfer.text! + string
        }
        
        if tag == 1 {
            to_phone = askFriendView.user_to_number.text! + string
        }
        else {
            amount = askFriendView.count_transfer.text! + string
        }
        
        if string  == "" {
            if cursorPosition2 <= 5 && textField == askFriendView.user_to_number {
                return false
            }
            else if textField == askFriendView.user_to_number && askFriendView.user_to_number.text == "+992 " {
                return false
            }
            else if textField == askFriendView.user_to_number && askFriendView.user_to_number.text != "+992 " {
                to_phone = (to_phone as String).substring(to: to_phone.index(before: to_phone.endIndex))
            }
            else {
                amount = (amount as String).substring(to: amount.index(before: amount.endIndex))
            }
        }
        
        if tag == 1 && string != "" && askFriendView.user_to_number.text!.count == 14 {
            return false
        }
        
        if tag == 2 && string != "" && askFriendView.count_transfer.text!.count == 9 {
            return false
        }
        
        return true
    }
    
    func setupView() {
        view.backgroundColor = toolbarColor
  
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.backgroundColor = .clear
        scrollView.contentSize = CGSize(width: view.frame.width, height: 550)
        
        view.addSubview(scrollView)
        
        toolbar = TarifToolbarView(frame: CGRect(x: 0, y: topPadding ?? 0, width: UIScreen.main.bounds.size.width, height: 60))
        askFriendView = AskFriendView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        
        self.view.addSubview(toolbar)
        scrollView.addSubview(askFriendView)
        
        toolbar.icon_back.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goBack))
        toolbar.isUserInteractionEnabled = true
        toolbar.addGestureRecognizer(tapGestureRecognizer)
        
        toolbar.number_user_name.text = defaultLocalizer.stringForKey(key: "Ask_friend")
        
        self.askFriendView.balance.text = balance
        self.askFriendView.balance.frame.size.width = CGFloat(balance.count * 12)
        self.askFriendView.balance.frame.origin.x = CGFloat(UIScreen.main.bounds.size.width) -  CGFloat(balance.count * 12) - 20
        
        askFriendView.user_to_number.delegate = self
        askFriendView.count_transfer.delegate = self
        print(to_phone)
        DispatchQueue.main.async { [self] in
            let contacts = askFriendView.user_to_number.setView(.right, image: UIImage(named: "user_field_icon"))
            contacts.addTarget(self, action: #selector(openContacts), for: .touchUpInside)
        }
        
        self.askFriendView.sendButton.addTarget(self, action:  #selector(translateTrafic), for: .touchUpInside)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(touchesScroll))
        scrollView.isUserInteractionEnabled = true
        scrollView.addGestureRecognizer(tapGestureRecognizer2)
        
        scrollView.frame = CGRect(x: 0, y: 60 + (topPadding ?? 0), width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 60 + (topPadding ?? 0) + (bottomPadding ?? 0)))
        
    }


    func sendRequest() {
        let client = APIClient.shared
            do{
              try client.getAskMoneyRequest().subscribe(
                onNext: { result in
                  print(result)
                    DispatchQueue.main.async {
                        
                        self.balance = String(result.subscriberBalance) + " " + self.defaultLocalizer.stringForKey(key: "tjs")
                    }
                },
                onError: { error in
                   print(error.localizedDescription)
                    DispatchQueue.main.async { [self] in
                        hideActivityIndicator(uiView: self.view)
                        setupView()
                        requestAnswer(status: false, message: defaultLocalizer.stringForKey(key: "service is temporarily unavailable"))
                    }
                },
                onCompleted: {
                    DispatchQueue.main.async { [self] in
                       setupView()
                       hideActivityIndicator(uiView: view)
                    }
                   print("Completed event.")
                    
                }).disposed(by: disposeBag)
              }
              catch{
            }
    }
    
    @objc func openContacts() {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
               self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
               navigationController?.pushViewController(ContactsViewController(), animated: false)
            
        case .notDetermined:
            CNContactStore().requestAccess(for: .contacts){succeeded, err in
                guard err == nil && succeeded else{
                  return
                }
                DispatchQueue.main.async {
                    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                    self.navigationController?.pushViewController(ContactsViewController(), animated: false)
                }
              }
            default:
            let alertController = UIAlertController (title: "Title", message: "Go to Settings?", preferredStyle: .alert)

                let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }

                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    }
                }
                alertController.addAction(settingsAction)
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                alertController.addAction(cancelAction)

                present(alertController, animated: true, completion: nil)
            
              print("Not handled")
            }
        
    }
    
    @objc func translateTrafic() {
        alert = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n", message: "", preferredStyle: .alert)
        let widthConstraints = alert.view.constraints.filter({ return $0.firstAttribute == .width })
        alert.view.removeConstraints(widthConstraints)
        // Here you can enter any width that you want
        let newWidth = UIScreen.main.bounds.width * 0.80
        // Adding constraint for alert base view
        let widthConstraint = NSLayoutConstraint(item: alert.view,
                                                     attribute: .width,
                                                     relatedBy: .equal,
                                                     toItem: nil,
                                                     attribute: .notAnAttribute,
                                                     multiplier: 1,
                                                     constant: newWidth)
        alert.view.addConstraint(widthConstraint)
        
        let view = AlertView2()
        view.backgroundColor = contentColor
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 80, height: 350)
        view.layer.cornerRadius = 20
        view.name.text = defaultLocalizer.stringForKey(key: "Ask_friend")
        view.image_icon.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "sms_transfer_w") : UIImage(named: "sms_transfer"))
        
        let cost: NSString = defaultLocalizer.stringForKey(key: "Ask_for") as NSString
        let range = (cost).range(of: cost as String)
        let costString = NSMutableAttributedString.init(string: cost as String)
        costString.addAttribute(NSAttributedString.Key.foregroundColor, value: colorBlackWhite , range: range)
        costString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], range: range)
        
        var title_cost = " \(String(askFriendView.count_transfer.text ?? "")) " + defaultLocalizer.stringForKey(key: "tjs") as NSString
            
        let titleString = NSMutableAttributedString.init(string: title_cost as String)
        let range2 = (title_cost).range(of: title_cost as String)
        titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange , range: range2)
        titleString.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], range: range2)
        
        costString.append(titleString)
        view.value_title.attributedText = costString
        
        let cost2: NSString = defaultLocalizer.stringForKey(key: "Subscriber") as NSString
        let range2_1 = (cost2).range(of: cost2 as String)
        let costString2 = NSMutableAttributedString.init(string: cost2 as String)
        costString2.addAttribute(NSAttributedString.Key.foregroundColor, value: colorBlackWhite , range: range2_1)
        costString2.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], range: range2_1)
        
        let title_cost2 = " \(askFriendView.user_to_number.text ?? "") " as NSString
        let titleString2 = NSMutableAttributedString.init(string: title_cost2 as String)
        let range2_2 = (title_cost2).range(of: title_cost2 as String)
        titleString2.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange , range: range2_2)
        titleString2.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], range: range2_2)
        
        let title_cost2_1 = "?" as NSString
        let titleString2_1 = NSMutableAttributedString.init(string: title_cost2_1 as String)
        let range2_3 = (title_cost2_1).range(of: title_cost2_1 as String)
        titleString2_1.addAttribute(NSAttributedString.Key.foregroundColor, value: colorBlackWhite , range: range2_3)
        titleString2_1.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], range: range2_3)
        
        titleString2.append(titleString2_1)
        costString2.append(titleString2)
        
        view.number_title.attributedText = costString2
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissDialog))
        view.name.isUserInteractionEnabled = true
        view.name.addGestureRecognizer(tapGestureRecognizer)
        
        view.ok.frame.origin.y = view.ok.frame.origin.y - 30
        view.ok.setTitle(defaultLocalizer.stringForKey(key: "Proceed"), for: .normal)
        view.cancel.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
        view.ok.addTarget(self, action: #selector(okClickDialog(_:)), for: .touchUpInside)
        alert.view.backgroundColor = .clear
        alert.view.addSubview(view)
        
        if askFriendView.user_to_number.text != "+992 " && askFriendView.count_transfer.text != "" {
            if askFriendView.user_to_number.text!.count != 14 {
                askFriendView.titleRed.isHidden = false
                askFriendView.user_to_number.layer.borderColor = UIColor.red.cgColor
                askFriendView.titleCount.frame.origin.y = 350
                askFriendView.count_transfer.frame.origin.y = 380
                askFriendView.titleGray.frame.origin.y = 440
                askFriendView.sendButton.frame.origin.y = 480
            }
            else if Int(askFriendView.count_transfer.text!) ?? 0 > 5 {
                askFriendView.titleRed2.isHidden = false
                askFriendView.titleRed2.text = defaultLocalizer.stringForKey(key: "Error_maximum_limit")
                askFriendView.count_transfer.layer.borderColor = UIColor.red.cgColor
                if askFriendView.titleRed.isHidden == true {
                    askFriendView.titleRed2.frame.origin.y = 410
                    askFriendView.titleGray.frame.origin.y = 440
                    askFriendView.sendButton.frame.origin.y = 480
                }
                else {
                    askFriendView.titleRed2.frame.origin.y = 440
                    askFriendView.titleGray.frame.origin.y = 480
                    askFriendView.sendButton.frame.origin.y = 520
                }
            }
            else if Int(askFriendView.count_transfer.text!) ?? 0 == 0 {
                askFriendView.titleRed2.isHidden = false
                askFriendView.titleRed2.text = defaultLocalizer.stringForKey(key: "input_correct_summa")
                askFriendView.count_transfer.layer.borderColor = UIColor.red.cgColor
                if askFriendView.titleRed.isHidden == true {
                    askFriendView.titleRed2.frame.origin.y = 410
                    askFriendView.titleGray.frame.origin.y = 440
                    askFriendView.sendButton.frame.origin.y = 480
                }
                else {
                    askFriendView.titleRed2.frame.origin.y = 440
                    askFriendView.titleGray.frame.origin.y = 480
                    askFriendView.sendButton.frame.origin.y = 520
                }
            }
            else {
                if askFriendView.user_to_number.text == UserDefaults.standard.string(forKey: "mobPhone") {
                    askFriendView.titleRed.isHidden = false
                    askFriendView.user_to_number.layer.borderColor = UIColor.red.cgColor
                    askFriendView.titleCount.frame.origin.y = 350
                    askFriendView.count_transfer.frame.origin.y = 380
                    askFriendView.titleGray.frame.origin.y = 440
                    askFriendView.sendButton.frame.origin.y = 480
                }
                else {
                    askFriendView.titleRed.isHidden = true
                    askFriendView.user_to_number.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
                    askFriendView.titleRed2.isHidden = true
                    askFriendView.count_transfer.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
                    present(alert, animated: true, completion: nil)
                    
                }
            }
            
        }
        
        if askFriendView.user_to_number.text == "+992 " {
            askFriendView.titleRed.isHidden = false
            askFriendView.user_to_number.layer.borderColor = UIColor.red.cgColor
            askFriendView.titleCount.frame.origin.y = 350
            askFriendView.count_transfer.frame.origin.y = 380
            askFriendView.titleGray.frame.origin.y = 440
            askFriendView.sendButton.frame.origin.y = 480
        }
       
        if askFriendView.count_transfer.text == "" {
            if askFriendView.titleRed.isHidden == true {
                askFriendView.titleRed2.frame.origin.y = 410
                askFriendView.titleGray.frame.origin.y = 440
                askFriendView.sendButton.frame.origin.y = 480
            }
            else {
                askFriendView.titleRed2.frame.origin.y = 440
                askFriendView.titleGray.frame.origin.y = 480
                askFriendView.sendButton.frame.origin.y = 520
            }
            askFriendView.titleRed2.isHidden = false
            askFriendView.count_transfer.layer.borderColor = UIColor.red.cgColor
            
        }
        
    }
    
    @objc func requestAnswer(status: Bool, message: String) {
        
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
        if status == true {
            view.name.text = defaultLocalizer.stringForKey(key: "Traffic_exchange_completed")
            view.image_icon.image = UIImage(named: "correct_alert")
        }
        else {
            view.name.text = defaultLocalizer.stringForKey(key: "error_title")
            view.image_icon.image = UIImage(named: "uncorrect_alert")
        }
        
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
        print("hello")
        alert.dismiss(animated: true, completion: nil)
        hideActivityIndicator(uiView: view)
    }
    
    @objc func okClickDialog(_ sender: UIButton) {
        
        alert.dismiss(animated: true, completion: nil)
        
        showActivityIndicator(uiView: view)
    
        to_phone = to_phone.replacingOccurrences(of: "+", with: "")
        to_phone = to_phone.replacingOccurrences(of: " ", with: "")
        
        let parametr: [String: Any] = ["inPhoneNumber": to_phone, "value": Int(askFriendView.count_transfer.text ?? "0")]
        
        let client = APIClient.shared
            do{
              try client.postMoneyAskRequest(jsonBody: parametr).subscribe(
                onNext: { [self] result in
                  print(result)
                    DispatchQueue.main.async {
                        if result.success == true {
                            requestAnswer(status: true, message: String(result.message ?? ""))
                        }
                        else {
                            requestAnswer(status: false, message: String(result.message ?? ""))
                        }
                    }
                },
                onError: { error in
                   print(error.localizedDescription)
                    DispatchQueue.main.async { [self] in
                        hideActivityIndicator(uiView: self.view)
                    }
                },
                onCompleted: { [self] in
                    DispatchQueue.main.async {
                        hideActivityIndicator(uiView: view)
                    }
                   print("Completed event.")
                    
                }).disposed(by: disposeBag)
              }
              catch{
            }
    }
}
