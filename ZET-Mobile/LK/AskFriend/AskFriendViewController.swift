//
//  AskFriendViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 17/05/22.
//

import UIKit
import RxSwift
import RxCocoa

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
            askFriendView.user_to_number.text = "+992 " + to_phone
        }
        else {
            askFriendView.user_to_number.text = "+992 "
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
            askFriendView.user_to_number.text! = "+992 "
            askFriendView.titleRed.isHidden = true
            askFriendView.user_to_number.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
            askFriendView.titleCount.frame.origin.y = 320
            askFriendView.count_transfer.frame.origin.y = 350
            askFriendView.titleGray.frame.origin.y = 410
            askFriendView.sendButton.frame.origin.y = 450
        }
        else if textField.tag == 2 {
            askFriendView.titleRed2.isHidden = true
            askFriendView.count_transfer.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
            askFriendView.titleGray.frame.origin.y = 410
            askFriendView.sendButton.frame.origin.y = 450
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField.tag == 1 {
            askFriendView.user_to_number.text! = "+992 " + to_phone
            askFriendView.user_to_number.textColor = colorBlackWhite
            askFriendView.user_to_number.font = UIFont.systemFont(ofSize: 15)
        }
        else if textField.tag == 2 {
           // auth_view.code_field.text! = user_code
            //auth_view.code_field.textColor = .black
            //auth_view.code_field.font = UIFont.systemFont(ofSize: 15)
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var amount = askFriendView.count_transfer.text! + string
        
        let tag = textField.tag
        
        if string  == "" {
            if tag == 1 && askFriendView.user_to_number.text != "+992 " {
                to_phone = (to_phone as String).substring(to: to_phone.index(before: to_phone.endIndex))
            }
            else if tag == 1 && askFriendView.user_to_number.text == "+992 " {
                return false
            }
            else {
                amount = (amount as String).substring(to: amount.index(before: amount.endIndex))
            }
        }
        
        if tag == 1 && string != "" && askFriendView.user_to_number.text!.count == 14 {
            return false
        }
        else if tag == 1 {
            to_phone = to_phone + string
            print(to_phone)
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
        let contacts = askFriendView.user_to_number.setView(.right, image: UIImage(named: "user_field_icon"))
        contacts.addTarget(self, action: #selector(openContacts), for: .touchUpInside)
        
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
                        
                        self.balance = String(result.subscriberBalance) + " с."
                    }
                },
                onError: { error in
                   print(error.localizedDescription)
                    self.requestAnswer(status: false, message: error.localizedDescription)
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
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(ContactsViewController(), animated: false)
        
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
        
        var title_cost = " \(String(askFriendView.count_transfer.text ?? "")) с."  as NSString
            
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
            if Int(askFriendView.count_transfer.text!) ?? 0 > 5 {
                askFriendView.titleRed2.isHidden = false
                askFriendView.titleRed2.text = defaultLocalizer.stringForKey(key: "Error_maximum_limit")
                askFriendView.count_transfer.layer.borderColor = UIColor.red.cgColor
                askFriendView.titleGray.frame.origin.y = 440
                askFriendView.sendButton.frame.origin.y = 480
            }
            else if Int(askFriendView.count_transfer.text!) ?? 0 == 0 {
                askFriendView.titleRed2.isHidden = false
                askFriendView.titleRed2.text = defaultLocalizer.stringForKey(key: "input_correct_summa")
                askFriendView.count_transfer.layer.borderColor = UIColor.red.cgColor
                askFriendView.titleGray.frame.origin.y = 440
                askFriendView.sendButton.frame.origin.y = 480
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
        else if askFriendView.user_to_number.text == "+992 " {
            askFriendView.titleRed.isHidden = false
            askFriendView.user_to_number.layer.borderColor = UIColor.red.cgColor
            askFriendView.titleCount.frame.origin.y = 350
            askFriendView.count_transfer.frame.origin.y = 380
            askFriendView.titleGray.frame.origin.y = 440
            askFriendView.sendButton.frame.origin.y = 480
        }
        else if askFriendView.count_transfer.text == "" {
            askFriendView.titleRed2.isHidden = false
            askFriendView.count_transfer.layer.borderColor = UIColor.red.cgColor
            askFriendView.titleGray.frame.origin.y = 440
            askFriendView.sendButton.frame.origin.y = 480
        }
        
    }
    
    @objc func requestAnswer(status: Bool, message: String) {
        
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
        if status == true {
            view.name.text = defaultLocalizer.stringForKey(key: "Traffic_exchange_completed")
            view.image_icon.image = UIImage(named: "correct_alert")
        }
        else {
            view.name.text = "Что-то пошло не так"
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
    
        let parametr: [String: Any] = ["inPhoneNumber": String(askFriendView.user_to_number.text ?? ""), "value": Int(askFriendView.count_transfer.text ?? "0")]
        
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
                        //requestAnswer(status: false, message: error.localizedDescription)
                        print(error.localizedDescription)
                        
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
