//
//  BuyTicketsViewController.swift
//  ZET-Mobile
//
//  Created by iDev on 06/09/23.
//

import UIKit
import RxCocoa
import RxSwift


class BuyTicketsViewController: UIViewController, UIScrollViewDelegate, UITextViewDelegate {
    
    var toolbar = TarifToolbarView()
    let scrollView = UIScrollView()
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer

    var bannerUrl = ""

    var alert = UIAlertController()

    var oneTicketPrice = Double()
    var presentMb = Double()
    var totalSum = Double()
    
    var buyTicketView = BuyTicketsView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = toolbarColor
        toolbar = TarifToolbarView(frame: CGRect(x: 0, y: topPadding ?? 0, width: UIScreen.main.bounds.size.width, height: 60))
        self.view.addSubview(toolbar)
        
        toolbar.icon_back.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goBack))
        toolbar.isUserInteractionEnabled = true
        toolbar.addGestureRecognizer(tapGestureRecognizer)
        
        toolbar.number_user_name.text = defaultLocalizer.stringForKey(key: "Charkhi Ikbol")
        
        
        sendRequest()
      //  setupView() // перенести в реквест
    }
    
    
    func sendRequest()
    {
        let client = APIClient.shared
            do{
                try client.charhiIqbolMain().subscribe(
                onNext: { [weak self] result in
                    DispatchQueue.main.async {
                        self!.oneTicketPrice = result.price
                        self!.bannerUrl = result.bannerURL
                        self!.presentMb = result.presentCount
                        self!.totalSum = result.price
                    }

                },
                onError: {
                    error in
                     DispatchQueue.main.async { [self] in
                         print(error)

                         setupView()
                        
                         self.requestAnswer(status: false, message: self.defaultLocalizer.stringForKey(key: "service is temporarily unavailable"))
                         self.hideActivityIndicator(uiView: self.view)
                     }
                },
                onCompleted: {DispatchQueue
                    
                    .main
                    .async { [self] in
                        setupView()
                       
                    }
                }).disposed(by: disposeBag)

              }
              catch{
            }
    }
    
    @objc func buyTicketAlert() {
        
        alert = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n\n\n", message: "", preferredStyle: .alert)
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
        view.backgroundColor = alertColor
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 80, height: 380)
        view.layer.cornerRadius = 20
        view.name.text = defaultLocalizer.stringForKey(key: "Charkhi Ikbol")
        view.image_icon.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "money_w") : UIImage(named: "detail")) // заменить на чархи икбол иконку картинку когда будет
        
        let cost: NSString = defaultLocalizer.stringForKey(key: "WantToBuy") as NSString
        let range = (cost).range(of: cost as String)
        let costString = NSMutableAttributedString.init(string: cost as String)
        costString.addAttribute(NSAttributedString.Key.foregroundColor, value: colorBlackWhite , range: range)
        costString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], range: range)
        
        var ticketNumber = "\(buyTicketView.ticketCount)" + " ID" as NSString
            
        let questionSign = defaultLocalizer.stringForKey(key: "WANT_TO_BUY2") as NSString

        
        let titleString = NSMutableAttributedString.init(string: ticketNumber as String)
        let range2 = (ticketNumber).range(of: ticketNumber as String)

        titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange , range: range2)
        titleString.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], range: range2)
        
        let signString = NSMutableAttributedString.init(string: questionSign as String)

        let range2_4 = (questionSign).range(of: questionSign as String)

        signString.addAttribute(NSAttributedString.Key.foregroundColor, value: colorBlackWhite , range: range2_4)
        signString.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], range: range2_4)
       
        
        
        costString.append(titleString)
        costString.append(signString)

        view.value_title.attributedText = costString
        view.value_title.numberOfLines = 2
        view.value_title.frame.size.height = view.value_title.frame.size.height + 30
  
        let title_cost2 = " " + packet_sum + " " + defaultLocalizer.stringForKey(key: "tjs")  as NSString
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
        
        view.number_title.frame.origin.y = view.number_title.frame.origin.y + 20
        
        let cost3: NSString = "\(defaultLocalizer.stringForKey(key: "Service_cost")): " as NSString
        let range3 = (cost3).range(of: cost3 as String)
        let costString3 = NSMutableAttributedString.init(string: cost3 as String)
        costString3.addAttribute(NSAttributedString.Key.foregroundColor, value: darkGrayLight , range: range3)
        costString3.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], range: range3)
               
        var title_cost3 = " " + "\(Double(buyTicketView.ticketCount) * oneTicketPrice)" + " " + defaultLocalizer.stringForKey(key: "tjs") as NSString
            
        let titleString3 = NSMutableAttributedString.init(string: title_cost3 as String)
        let range3_1 = (title_cost3).range(of: title_cost3 as String)
        titleString3.addAttribute(NSAttributedString.Key.foregroundColor, value: darkGrayLight , range: range3_1)
        titleString3.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], range: range3_1)
        
        costString3.append(titleString3)
        view.cost_title.attributedText = costString3
        view.cost_title.frame.origin.y = view.cost_title.frame.origin.y
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissDialog))
        view.name.isUserInteractionEnabled = true
        view.name.addGestureRecognizer(tapGestureRecognizer)
        
        view.ok.setTitle(defaultLocalizer.stringForKey(key: "ButtonBuyTickets"), for: .normal)
        
        view.cancel.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
        view.ok.addTarget(self, action: #selector(okClickDialog2), for: .touchUpInside)
        alert.view.backgroundColor = .clear
        alert.view.addSubview(view)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    
    @objc func okClickDialog2(_ sender: UIButton) {
        
    //    zero_but_open = true
        alert.dismiss(animated: true, completion: nil)
        showActivityIndicator(uiView: view)
        print(sender.tag)
        
         let client = APIClient.shared
             do{
                 try client.buyDrawTickets(parametr: buyTicketView.ticketCount).subscribe(
                 onNext: { [self] result in
                   print(result)
                     DispatchQueue.main.async {
                         if result.success == true {
                             requestAnswer2(status: true, message: String(result.message ?? ""))
                         }
                         else {
                             requestAnswer2(status: false, message: String(result.message ?? ""))
                         }
                     }
                    
                 },
                 onError: { [self] error in
                     DispatchQueue.main.async { [self] in
                         hideActivityIndicator(uiView: self.view)
                         requestAnswer2(status: false, message: defaultLocalizer.stringForKey(key: "service is temporarily unavailable"))
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
    
    
    @objc func requestAnswer2(status: Bool, message: String) {
        
        hideActivityIndicator(uiView: view)
        
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
        if status == true {
            view.name.text = defaultLocalizer.stringForKey(key: "SuccessBuy")
            view.image_icon.image = UIImage(named: "correct_alert")
            view.ok.addTarget(self, action: #selector(okTrueDialog), for: .touchUpInside)
            view.cancel.addTarget(self, action: #selector(okTrueDialog), for: .touchUpInside)
        }
        else {
            view.name.text = defaultLocalizer.stringForKey(key: "error_title")
            view.image_icon.image = UIImage(named: "uncorrect_alert")
            view.ok.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
            view.cancel.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
        }
        
        view.name_content.text = "\(message)"
        view.ok.setTitle("OK", for: .normal)
        
        alert.view.backgroundColor = .clear
        alert.view.addSubview(view)
        //alert.view.sendSubviewToBack(view)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func okTrueDialog(_ sender: UIButton) {
        alert.dismiss(animated: true, completion: nil)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(CompetitionViewController(), animated: false)
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
            view.name.text = defaultLocalizer.stringForKey(key: "service_connected")
            view.image_icon.image = UIImage(named: "correct_alert")
        }
        else {
            view.name.text = defaultLocalizer.stringForKey(key: "error_title")
            view.image_icon.image = UIImage(named: "uncorrect_alert")
        }
        
        view.name_content.text = "\(message)"
        view.ok.setTitle("OK", for: .normal)
        
        view.cancel.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
        view.ok.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
        
        alert.view.backgroundColor = .clear
        alert.view.addSubview(view)
        //alert.view.sendSubviewToBack(view)
        
        present(alert, animated: true, completion: nil)

        
    }
    
    @objc func dismissDialog(_ sender: UIButton) {
        sender.showAnimation { [self] in
            alert.dismiss(animated: true, completion: nil)
            hideActivityIndicator(uiView: view)
        }
    }

    
    func setupView() {
        
        
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.backgroundColor = contentColor
        buyTicketView = BuyTicketsView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 600))
        //competitionView.sendButton.addTarget(self, action: #selector(openMyTicket), for: .touchUpInside)
        
        buyTicketView.oneTicketPriceCount.text = "\(oneTicketPrice)" + " \(defaultLocalizer.stringForKey(key: "tjs"))"
        let roundedResult = Double(buyTicketView.ticketCount) * presentMb
        let formattedResult = String(format: "%.0f", roundedResult)
        buyTicketView.totalMbCount.text = formattedResult + " \(defaultLocalizer.stringForKey(key: "megabyte"))"
        buyTicketView.totalCount.text = "\(Double(buyTicketView.ticketCount) * oneTicketPrice) \(defaultLocalizer.stringForKey(key: "tjs"))"
        
        buyTicketView.image_banner.af_setImage(withURL: URL(string: bannerUrl)!)
        scrollView.addSubview(buyTicketView)
        scrollView.frame = CGRect(x: 0, y: 60 + (topPadding ?? 0), width: UIScreen.main.bounds.size.width , height: UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 20 + (topPadding ?? 0) + (bottomPadding ?? 0)))
        scrollView.isScrollEnabled = true
        // Устанавливаем высоту scrollView.contentSize равной высоте содержимого
        scrollView.contentSize = CGSize(width: view.frame.width, height: 640 + 42)
        
        // Назначьте делегата для обработки нажатий на кнопки
        buyTicketView.plusButton.addTarget(self, action: #selector(plusButtonTapped), for: UIControl.Event.touchUpInside)
        buyTicketView.minusButton.addTarget(self, action: #selector(minusButtonTapped), for: UIControl.Event.touchUpInside)
        buyTicketView.buyTicketButton.addTarget(self, action: #selector(buyTicketAlert), for: UIControl.Event.touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ticketCountLabelTapped))


        buyTicketView.ticketCountLabel.delegate = self
        buyTicketView.ticketCountLabel.keyboardType = .numberPad
        buyTicketView.ticketCountLabel.addGestureRecognizer(tapGesture)
        
        let tapGestures = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped))
        scrollView.addGestureRecognizer(tapGestures)
        view.addSubview(scrollView)
        
        view.backgroundColor = toolbarColor
        print( "10 : \(buyTicketView.ticketCount)")
        
        
    }
    
    @objc private func ticketCountLabelTapped() {
        buyTicketView.ticketCountLabel.text = "" // Очищаем текстовое поле
        buyTicketView.plusButton.isUserInteractionEnabled = false
        buyTicketView.minusButton.isUserInteractionEnabled = false
        buyTicketView.ticketCountLabel.becomeFirstResponder()
        print( "9 : \(buyTicketView.ticketCount)")
        
    }
    
    
    // Обработчик нажатия на кнопку plusButton
    @objc func plusButtonTapped() {
        if buyTicketView.ticketCount < 999999 { // Проверка на максимальное значение
            buyTicketView.ticketCount += 1
            let roundedResult = Double(buyTicketView.ticketCount) * presentMb
            let formattedResult = String(format: "%.0f", roundedResult)
            buyTicketView.totalMbCount.text = formattedResult + " \(defaultLocalizer.stringForKey(key: "megabyte"))"
            buyTicketView.totalCount.text = "\(Double(buyTicketView.ticketCount) * oneTicketPrice) \(defaultLocalizer.stringForKey(key: "tjs"))"

            print( "8 : \(buyTicketView.ticketCount)")
            
        }
    }
    
    // Обработчик нажатия на кнопку minusButton
    @objc func minusButtonTapped() {
        if buyTicketView.ticketCount > 1 {
            
            buyTicketView.ticketCount -= 1 // Уменьшаем числовое значение на 1 megabyte
            let roundedResult = Double(buyTicketView.ticketCount) * presentMb
            let formattedResult = String(format: "%.0f", roundedResult)
            buyTicketView.totalMbCount.text = formattedResult + " \(defaultLocalizer.stringForKey(key: "megabyte"))"
            buyTicketView.totalCount.text = "\(Double(buyTicketView.ticketCount) * oneTicketPrice) \(defaultLocalizer.stringForKey(key: "tjs"))"
            print( "7 : \(buyTicketView.ticketCount)")

        }
        
    }
    
    @objc private func scrollViewTapped() {
        buyTicketView.ticketCountLabel.resignFirstResponder()
        buyTicketView.plusButton.isUserInteractionEnabled = true
        buyTicketView.minusButton.isUserInteractionEnabled = true
        if let text = buyTicketView.ticketCountLabel.text, let number = Int(text) {
            
            buyTicketView.ticketCount = number
        } else {
            
            buyTicketView.ticketCount = 1
        }
        let roundedResult = Double(buyTicketView.ticketCount) * presentMb
        let formattedResult = String(format: "%.0f", roundedResult)
        buyTicketView.totalMbCount.text = formattedResult + " \(defaultLocalizer.stringForKey(key: "megabyte"))"
        //buyTicketView.totalMbCount.text = "\(Double(buyTicketView.ticketCount) * presentMb) \(defaultLocalizer.stringForKey(key: "megabyte"))"
        buyTicketView.totalCount.text = "\(Double(buyTicketView.ticketCount) * oneTicketPrice) \(defaultLocalizer.stringForKey(key: "tjs"))"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationController?.tabBarController?.tabBar.isHidden = false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? .lightContent : .darkContent)
    }
    
    @objc func goBack() {
        if let destinationViewController = navigationController?.viewControllers
            .filter(
                {$0 is CompetitionViewController})
                .first {
            navigationController?.popToViewController(destinationViewController, animated: true)
        }
    }
    
}


extension BuyTicketsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Проверяем, если текстовое поле ticketCountTextField
        if textField == buyTicketView.ticketCountLabel {
            var updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
            updatedText = updatedText.trimmingCharacters(in: .whitespacesAndNewlines) // Удаляем пробелы и символы новой строки

            if updatedText.count > 6{
                if let updatedText = textField.text, let ticketCount = Int(updatedText) {
                    buyTicketView.ticketCount = ticketCount
                    buyTicketView.ticketCountLabel.resignFirstResponder()
                    
                   
                }
            }

            // Проверяем, если новый символ - ноль и поле пустое или первый символ уже ноль
            if string == "0" && (textField.text?.isEmpty ?? true || textField.text?.first == "0") {
                print( "2 : \(buyTicketView.ticketCount)")
                
                return false // Запрещаем ввод нуля
            }
            print( "3 : \(buyTicketView.ticketCount)")
            
        }
        print( "4 : \(buyTicketView.ticketCount)")
     
        buyTicketView.totalCount.text = "\(Double(buyTicketView.ticketCount) * oneTicketPrice) \(defaultLocalizer.stringForKey(key: "tjs"))"
        print("total count size y : \(buyTicketView.totalCount.bounds.maxY)")

        return true // Разрешаем остальные символы
    }
}



