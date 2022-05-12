//
//  ZeroButtonViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 05/05/22.
//

import UIKit
import RxSwift
import RxCocoa

class ZeroButtonViewController: UIViewController {
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    let disposeBag = DisposeBag()
    
    var alert = UIAlertController()
    let scrollView = UIScrollView()
    
    let zero_button_view = ZeroButtonView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 200, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height / 5))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        modalPresentationCapturesStatusBarAppearance = true
       
        view.addSubview(zero_button_view)
        
        zero_button_view.sendButton.addTarget(self, action: #selector(translateTrafic), for: .touchUpInside)
        
    }
    
    @objc func translateTrafic(_ sender: UIButton) {
        let indexPath = IndexPath(row: 0, section: 0)
       // let cell = table.cellForRow(at: indexPath) as! MobileTableViewCell
        
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
        view.backgroundColor = contentColor
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 80, height: 380)
        view.layer.cornerRadius = 20
        view.name.text = defaultLocalizer.stringForKey(key: "Mobile_transfer")
        view.image_icon.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "sms_transfer_w") : UIImage(named: "sms_transfer"))
        
        let cost: NSString = defaultLocalizer.stringForKey(key: "Transfer") as NSString
        let range = (cost).range(of: cost as String)
        let costString = NSMutableAttributedString.init(string: cost as String)
        costString.addAttribute(NSAttributedString.Key.foregroundColor, value: colorBlackWhite , range: range)
        costString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], range: range)
        
        var title_cost = "" + defaultLocalizer.stringForKey(key: "somoni") as NSString
            
        let titleString = NSMutableAttributedString.init(string: title_cost as String)
        let range2 = (title_cost).range(of: title_cost as String)
        titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange , range: range2)
        titleString.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], range: range2)
        
        costString.append(titleString)
        view.value_title.attributedText = costString
        
        let cost2: NSString = defaultLocalizer.stringForKey(key: "to_number") as NSString
        let range2_1 = (cost2).range(of: cost2 as String)
        let costString2 = NSMutableAttributedString.init(string: cost2 as String)
        costString2.addAttribute(NSAttributedString.Key.foregroundColor, value: colorBlackWhite , range: range2_1)
        costString2.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], range: range2_1)
        
        let title_cost2 = " +992 " as NSString
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
        
        
        let cost3: NSString = "\(defaultLocalizer.stringForKey(key: "Service_cost")): " as NSString
        let range3 = (cost3).range(of: cost3 as String)
        let costString3 = NSMutableAttributedString.init(string: cost3 as String)
        costString3.addAttribute(NSAttributedString.Key.foregroundColor, value: darkGrayLight , range: range3)
        costString3.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], range: range3)
        
        var title_cost3 = " " as NSString
            
        let titleString3 = NSMutableAttributedString.init(string: title_cost3 as String)
        let range3_1 = (title_cost3).range(of: title_cost3 as String)
        titleString3.addAttribute(NSAttributedString.Key.foregroundColor, value: darkGrayLight , range: range3_1)
        titleString3.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], range: range3_1)
        
        costString3.append(titleString3)
        view.cost_title.attributedText = costString3
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissDialog))
        view.name.isUserInteractionEnabled = true
        view.name.addGestureRecognizer(tapGestureRecognizer)
        
        view.cancel.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
        view.ok.addTarget(self, action: #selector(okClickDialog(_:)), for: .allTouchEvents)
        alert.view.backgroundColor = .clear
        alert.view.addSubview(view)
        
        sender.showAnimation {
            self.present(self.alert, animated: true, completion: nil)
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
    }
    
    @objc func okClickDialog(_ sender: UIButton) {
        
        sender.showAnimation {
            self.alert.dismiss(animated: true, completion: nil)
        }
        showActivityIndicator(uiView: view)
        
        print(sender.tag)
        let parametr: [String: Any] = ["inPhoneNumber": "992", "value": "Int(value_transfer)!"]
         let client = APIClient.shared
             do{
               try client.exchangePutRequest(jsonBody: parametr).subscribe(
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
                 onError: { [self] error in
                     DispatchQueue.main.async {
                         requestAnswer(status: false, message: error.localizedDescription)
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

class ZeroButtonView: UIView {
    
    lazy var type_paket: UILabel = {
         let title = UILabel()
         title.text = "Пакет 3 сомони"
         title.numberOfLines = 0
         title.textColor = colorBlackWhite
         title.font = UIFont.boldSystemFont(ofSize: 20)
         title.lineBreakMode = NSLineBreakMode.byWordWrapping
         title.textAlignment = .left
         title.frame = CGRect(x: 20, y: 20, width: 300, height: 20)
         title.autoresizesSubviews = true
         title.autoresizingMask = [.flexibleHeight, .flexibleWidth]
         return title
     }()
     
     lazy var title_commission: UILabel = {
         let title = UILabel()
         title.text = "Стоимость услуги: 0.2 сомони"
         title.numberOfLines = 0
         title.textColor = .orange
         title.font = UIFont(name: "", size: 9)
         title.lineBreakMode = NSLineBreakMode.byWordWrapping
         title.textAlignment = .left
         title.frame = CGRect(x: 20, y: 45, width: 300, height: 20)
         title.autoresizesSubviews = true
         title.autoresizingMask = [.flexibleHeight, .flexibleWidth]
         return title
     }()
     
     lazy var summa: UILabel = {
         let title = UILabel()
         title.text = "Итого:: 0.2 сомони"
         title.numberOfLines = 0
         title.textColor = .orange
         title.font = UIFont(name: "", size: 9)
         title.lineBreakMode = NSLineBreakMode.byWordWrapping
         title.textAlignment = .left
         title.frame = CGRect(x: 20, y: 70, width: 300, height: 20)
         title.autoresizesSubviews = true
         title.autoresizingMask = [.flexibleHeight, .flexibleWidth]
         return title
     }()
     
     lazy var sendButton: UIButton = {
         let button = UIButton(frame: CGRect(x: 40, y: 110, width: Int(UIScreen.main.bounds.size.width) - 80, height: 40))
         //ReconnectBut.setImage(#imageLiteral(resourceName: "connect"), for: UIControl.State.normal)
         //openmenu.addTarget(self, action: #selector(goback), for: UIControl.Event.touchUpInside)
         button.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
         button.setTitle(defaultLocalizer.stringForKey(key: "Purchase_package"), for: .normal)
         button.setTitleColor(.white, for: .normal)
         button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
         button.layer.cornerRadius = button.frame.height / 2
         return button
     }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        
    }
    
    private func setupView() {
        backgroundColor = contentColor
    
        addSubview(type_paket)
        addSubview(title_commission)
        addSubview(summa)
        addSubview(sendButton)

    }
}
