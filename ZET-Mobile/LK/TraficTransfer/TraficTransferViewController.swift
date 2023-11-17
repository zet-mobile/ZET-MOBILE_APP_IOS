//
//  TraficTransferViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/22/21.
//

import UIKit
import RxCocoa
import RxSwift
import MultiSlider
import Contacts
import ContactsUI
import Alamofire
import AlamofireImage

struct historyData {
    let date_header: String
    let phoneNumber: [String]
    let status: [String]
    let date: [String]
    let id: [String]
    let volume: [String]
    let price: [String]
    let type: [String]
    let transferType: [String]
    let statusId: [String]
    let transactionId: [String]
}

class TraficTransferViewController: UIViewController, UIScrollViewDelegate {

    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    let disposeBag = DisposeBag()
    var halfModalTransitioningDelegate: HalfModalTransitioningDelegate?
    let detailViewController = MoreDetailViewController()
    
    var nav = UINavigationController()
    var alert = UIAlertController()
    
    let scrollView = UIScrollView()
    
    var toolbar = TarifToolbarView()
    var traficView = TraficTransferView()
    let table = UITableView()
    var table2 = UITableView(frame: .zero, style: .grouped)
    
    var x_pozition = 20
    var y_pozition = 360
    
    let TabCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(TabTraficCollectionViewCell.self, forCellWithReuseIdentifier: "tabs")
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        return cv
    }()
    
    
    var balances_data = [[String]]()
    var settings_data = [[String]]()
    
    var balance = ""
    var trasfer_type_choosed = ""
    var trasfer_type_choosed_id = 0
    
    var type_index = 0
    var value_transfer = ""
    var inPhoneNumber = ""
    
    var HistoryData = [historyData(date_header: String(), phoneNumber: [String](), status: [String](), date: [String](), id: [String](), volume: [String](), price: [String](), type: [String](), transferType: [String](), statusId: [String](), transactionId: [String]())]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        to_phone = ""
        value_transfer = "1 " + defaultLocalizer.stringForKey(key: "tjs")
        showActivityIndicator(uiView: self.view)
        view.backgroundColor = toolbarColor
        
        toolbar = TarifToolbarView(frame: CGRect(x: 0, y: topPadding ?? 0, width: UIScreen.main.bounds.size.width, height: 60))
        self.view.addSubview(toolbar)
        
        toolbar.icon_back.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goBack))
        toolbar.isUserInteractionEnabled = true
        toolbar.addGestureRecognizer(tapGestureRecognizer)
        
        toolbar.number_user_name.text = defaultLocalizer.stringForKey(key: "Traffic_transfer")
        
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
       
        if settings_data.count != 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            let cell = table.cellForRow(at: indexPath) as! TraficTableViewCell
            
            if to_phone != "" {
                cell.user_to_number.text = to_phone
            }
        }
    
        print("jjjjj")
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? .lightContent : .darkContent)
    }
    
    @objc func goBack() {
        if let destinationViewController = navigationController?.viewControllers
                                                                .filter(
                                              {$0 is HomeViewController})
                                                                .first {
            navigationController?.popToViewController(destinationViewController, animated: true)
        }
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
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 950)
        view.addSubview(scrollView)
        
        traficView = TraficTransferView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 896))
        
        scrollView.addSubview(traficView)
        
        for i in 0 ..< hot_services_data.count {
            if hot_services_data[i][0] == "2" {
                traficView.image_banner.af_setImage(withURL: URL(string: hot_services_data[i][3])!)
            }
        }
        
        self.traficView.balance.text = balance
        
        if balances_data.count != 0 {
            traficView.rez1.text = balances_data[0][0]
            traficView.rez2.text = balances_data[0][1]
            traficView.rez3.text = balances_data[0][2]
            traficView.rez4.text = balances_data[0][3]
        }
        
        traficView.rez1.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - ((traficView.rez1.text!.count) * 15) - 50, y: 0, width: ((traficView.rez1.text!.count) * 15), height: 45)
        traficView.rez2.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (traficView.rez2.text!.count * 15) - 50, y: 47, width: (traficView.rez2.text!.count * 15), height: 45)
        traficView.rez3.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (traficView.rez3.text!.count * 15) - 50, y: 94, width: (traficView.rez3.text!.count * 15), height: 45)
        traficView.rez4.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (traficView.rez4.text!.count * 15) - 50, y: 141, width: (traficView.rez4.text!.count * 15), height: 45)
        
        scrollView.frame = CGRect(x: 0, y: 60 + (topPadding ?? 0), width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 60 + (topPadding ?? 0) + (bottomPadding ?? 0)))
    }

    func setupTabCollectionView() {
        y_pozition = y_pozition + 55
        
        traficView.tab1.frame = CGRect(x: 10, y: y_pozition, width: Int(UIScreen.main.bounds.size.width - 20) / 2, height: 40)
        traficView.tab2.frame = CGRect(x: ((UIScreen.main.bounds.size.width - 20) / 2) + 10, y: CGFloat(y_pozition), width: (UIScreen.main.bounds.size.width - 20) / 2, height: 40)
        
        traficView.tab1Line.frame = CGRect(x: 10, y: y_pozition + 40, width: Int(UIScreen.main.bounds.size.width - 20) / 2, height: 2)
        traficView.tab2Line.frame = CGRect(x: ((UIScreen.main.bounds.size.width - 20) / 2) + 10, y: CGFloat(y_pozition + 40), width: (UIScreen.main.bounds.size.width - 20) / 2, height: 2)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tab1Click))
        traficView.tab1.isUserInteractionEnabled = true
        traficView.tab1.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(tab2Click))
        traficView.tab2.isUserInteractionEnabled = true
        traficView.tab2.addGestureRecognizer(tapGestureRecognizer2)
        
        scrollView.addSubview(TabCollectionView)
        TabCollectionView.backgroundColor = contentColor
        TabCollectionView.frame = CGRect(x: 0, y: y_pozition + 45, width: Int(UIScreen.main.bounds.size.width), height: Int(UIScreen.main.bounds.size.height - 104))
        TabCollectionView.delegate = self
        TabCollectionView.dataSource = self
        TabCollectionView.alwaysBounceVertical = false
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.scrollView == scrollView || table == scrollView || table2 == scrollView {
            if scrollView.contentOffset.y > traficView.tab1.frame.origin.y {
                traficView.titleOne.isHidden = true
                traficView.balance.isHidden = true
                traficView.image_banner.isHidden = true
                traficView.white_view_back.isHidden = true
                self.scrollView.contentOffset.y = 0
                traficView.tab1.frame.origin.y = 0
                traficView.tab2.frame.origin.y = 0
                traficView.tab1Line.frame.origin.y = 40
                traficView.tab2Line.frame.origin.y = 40
                TabCollectionView.frame.origin.y = 45
            }
            if scrollView.contentOffset.y < -10 && traficView.white_view_back.isHidden == true {
                traficView.titleOne.isHidden = false
                traficView.balance.isHidden = false
                traficView.image_banner.isHidden = false
                traficView.white_view_back.isHidden = false
                traficView.tab1.frame.origin.y = CGFloat(y_pozition)
                traficView.tab2.frame.origin.y = CGFloat(y_pozition)
                traficView.tab1Line.frame.origin.y = CGFloat(y_pozition + 40)
                traficView.tab2Line.frame.origin.y = CGFloat(y_pozition + 40)
                TabCollectionView.frame.origin.y = CGFloat(y_pozition + 45)
               
            }
        }
        
    }
    
    @objc func tab1Click() {
        traficView.tab1.textColor = colorBlackWhite
        traficView.tab2.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        traficView.tab1Line.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
        traficView.tab2Line.backgroundColor = .clear
        TabCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionView.ScrollPosition.right, animated: true)
    }
    
    @objc func tab2Click() {
        traficView.tab1.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        traficView.tab2.textColor = colorBlackWhite
        traficView.tab1Line.backgroundColor = .clear
        traficView.tab2Line.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
        TabCollectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: UICollectionView.ScrollPosition.left, animated: true)
    }
    
    func sendRequest() {
        settings_data.removeAll()
        let client = APIClient.shared
            do{
              try client.getTransferRequest().subscribe(
                onNext: { result in
                  print(result)
                    DispatchQueue.main.async {
                        
                        self.balances_data.append([String(result.balances.offnet.now) , String(result.balances.onnet.now), String(result.balances.mb.now), String(result.balances.sms.now)])
                        
                        if String(result.subscriberBalance) != "" {
                            self.balance = String(format: "%g", Double(String(format: "%.2f", Double(String(result.subscriberBalance))!))!) + " " + self.defaultLocalizer.stringForKey(key: "tjs")
                        }
                        else {
                            self.balance = String(result.subscriberBalance) + " " + self.defaultLocalizer.stringForKey(key: "tjs")
                        }
                        
                        if result.settings.count != 0 {
                            for i in 0 ..< result.settings.count {
                                self.settings_data.append([String(result.settings[i].minValue), String(result.settings[i].maxValue), String(result.settings[i].midValue), String(result.settings[i].midPrice), String(result.settings[i].price), String(result.settings[i].quantityLimit), String(result.settings[i].volumeLimit), String(result.settings[i].conversationRate), String(result.settings[i].discountPercent), String(result.settings[i].transferType), String(result.settings[i].transferTypeId), String(result.settings[i].description)])
                            }
                        }
                        
                    }
                },
                onError: { error in
                   print(error.localizedDescription)
                    DispatchQueue.main.async { [self] in
                        setupView()
                        setupTabCollectionView()
                        hideActivityIndicator(uiView: self.view)
                        requestAnswer(status: false, message: defaultLocalizer.stringForKey(key: "service is temporarily unavailable"))
                    }
                },
                onCompleted: {
                    client.requestObservable.tabIndicator = "1"
                    DispatchQueue.main.async { [self] in
                        sendHistoryRequest()
                    }
                   print("Completed event.")
                    
                }).disposed(by: disposeBag)
              }
              catch{
            }
      }
    
    func sendHistoryRequest() {
        HistoryData.removeAll()
        let client = APIClient.shared
            do{
              try client.transferHistoryRequest().subscribe(
                onNext: { result in
                  print(result)
                    DispatchQueue.main.async { [self] in
                        
                        if result.history != nil {
                            print(result.history!.count)
                            for i in 0 ..< result.history!.count {
                                var tableData = [String]()
                                var tableData1 = [String]()
                                var tableData2 = [String]()
                                var tableData3 = [String]()
                                var tableData4 = [String]()
                                var tableData5 = [String]()
                                var tableData6 = [String]()
                                var tableData7 = [String]()
                                var tableData8 = [String]()
                                var tableData9 = [String]()
                                
                                for j in 0 ..< result.history![i].histories.count {
                                    
                                    tableData.append(String(result.history![i].histories[j].phoneNumber))
                                    tableData1.append(String(result.history![i].histories[j].status))
                                    tableData2.append(String(result.history![i].histories[j].date))
                                    tableData3.append(String(result.history![i].histories[j].id))
                                    tableData4.append(String(result.history![i].histories[j].volume))
                                    tableData5.append(String(result.history![i].histories[j].price))
                                    tableData6.append(String(result.history![i].histories[j].type))
                                    tableData7.append(String(result.history![i].histories[j].transferType))
                                    tableData8.append(String(result.history![i].histories[j].statusId))
                                    tableData9.append(String(result.history![i].histories[j].transactionId))
                                }
                                
                                if String(result.history![i].date) != "" {
                                    HistoryData.append(historyData(date_header: String(result.history![i].date), phoneNumber: tableData, status: tableData1, date: tableData2, id: tableData3, volume: tableData4, price: tableData5, type: tableData6, transferType: tableData7, statusId: tableData8, transactionId: tableData9))
                                }
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                emptyView = EmptyView(frame: CGRect(x: 0, y: 30, width: self.table2.frame.width, height: self.table.frame.height), text: self.defaultLocalizer.stringForKey(key: "not_used_transfer"))
                            self.table2.separatorStyle = .none
                            self.table2.backgroundView = emptyView
                            }
                        }
                        
                    }
                },
                onError: { error in
                   print(error.localizedDescription)
                    DispatchQueue.main.async { [self] in
                        hideActivityIndicator(uiView: self.view)
                        requestAnswer(status: false, message: defaultLocalizer.stringForKey(key: "service is temporarily unavailable"))
                        client.requestObservable.tabIndicator = "0"
                    }
                },
                onCompleted: {
                    client.requestObservable.tabIndicator = "0"
                    DispatchQueue.main.async { [self] in
                        setupView()
                        setupTabCollectionView()
                        hideActivityIndicator(uiView: self.view)
                    }
                   print("Completed event.")
                    
                }).disposed(by: disposeBag)
              }
              catch{
            }
    }
    
    @objc func translateTrafic() {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = table.cellForRow(at: indexPath) as! TraficTableViewCell
       // cell.user_to_number.resignFirstResponder()
        
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
        view.name.text = defaultLocalizer.stringForKey(key: "Traffic_transfer")
        
        if trasfer_type_choosed_id == 3 {
            view.image_icon.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "sms_black") : UIImage(named: "sms_white"))
         }
         else if trasfer_type_choosed_id == 2 {
             view.image_icon.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "min_transfer_w") : UIImage(named: "min_transfer"))
         }
         else if trasfer_type_choosed_id == 1 {
             view.image_icon.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "internet_transfer_w") : UIImage(named: "internet_transfer"))
         }
        
        let cost: NSString = defaultLocalizer.stringForKey(key: "Transfer") as NSString
        let range = (cost).range(of: cost as String)
        let costString = NSMutableAttributedString.init(string: cost as String)
        costString.addAttribute(NSAttributedString.Key.foregroundColor, value: colorBlackWhite , range: range)
        costString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], range: range)
        
        cell.count_transfer.text = String(Int(cell.count_transfer.text ?? "1") ?? 1)
        
        var title_cost = " \(String(cell.count_transfer.text ?? "")) " as NSString
        if trasfer_type_choosed_id == 1 {
            title_cost = " \(String(cell.count_transfer.text ?? "")) \(defaultLocalizer.stringForKey(key: "megabyte"))" as NSString
        }
        else if trasfer_type_choosed_id == 2 {
            title_cost = " \(String(cell.count_transfer.text ?? "")) \(defaultLocalizer.stringForKey(key: "minutes"))" as NSString
        }
        else if trasfer_type_choosed_id == 3 {
            title_cost = " \(String(cell.count_transfer.text ?? "")) \(defaultLocalizer.stringForKey(key: "SMS"))" as NSString
        }
            
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
        
        let title_cost2 = String(cell.user_to_number.text!) as NSString
        let titleString2 = NSMutableAttributedString.init(string: title_cost2 as String)
        let range2_2 = (title_cost2).range(of: title_cost2 as String)
        titleString2.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange , range: range2_2)
        titleString2.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], range: range2_2)
        
        let title_cost2_1 = "?" as NSString
        let titleString2_1 = NSMutableAttributedString.init(string: title_cost2_1 as String)
        let range2_3 = (title_cost2_1).range(of: title_cost2_1 as String)
        titleString2_1.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange , range: range2_3)
        titleString2_1.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], range: range2_3)
        
        titleString2.append(titleString2_1)
        costString2.append(titleString2)
        
        view.number_title.attributedText = costString2
        
        
        let cost3: NSString = "\(defaultLocalizer.stringForKey(key: "Service_cost")): " as NSString
        let range3 = (cost3).range(of: cost3 as String)
        let costString3 = NSMutableAttributedString.init(string: cost3 as String)
        costString3.addAttribute(NSAttributedString.Key.foregroundColor, value: darkGrayLight , range: range3)
        costString3.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], range: range3)
        
        var title_cost3 = " " + value_transfer as NSString
            
        let titleString3 = NSMutableAttributedString.init(string: title_cost3 as String)
        let range3_1 = (title_cost3).range(of: title_cost3 as String)
        titleString3.addAttribute(NSAttributedString.Key.foregroundColor, value: darkGrayLight , range: range3_1)
        titleString3.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], range: range3_1)
        
        costString3.append(titleString3)
        view.cost_title.attributedText = costString3
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissDialog))
        view.name.isUserInteractionEnabled = true
        view.name.addGestureRecognizer(tapGestureRecognizer)
        
        view.cancel.addTarget(self, action: #selector(cancelDialog), for: .touchUpInside)
        view.ok.addTarget(self, action: #selector(okClickDialog(_:)), for: .touchUpInside)
        alert.view.backgroundColor = .clear
        alert.view.addSubview(view)
        
        if to_phone != "" && cell.user_to_number.text?.count == 14 && cell.count_transfer.text != "" {
            if to_phone == UserDefaults.standard.string(forKey: "mobPhone") {
                cell.titleRed.isHidden = false
                cell.user_to_number.layer.borderColor = UIColor.red.cgColor
                cell.sendButton.isEnabled = false
                cell.sendButton.backgroundColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
            }
            else {
                cell.titleRed.isHidden = true
                cell.user_to_number.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
                cell.sendButton.isEnabled = true
                cell.sendButton.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
                cell.sendButton.showAnimation {
                    self.present(self.alert, animated: true, completion: nil)
                }
            }
            
        }
        else if to_phone == ""  {
            cell.titleRed.isHidden = false
            cell.user_to_number.layer.borderColor = UIColor.red.cgColor
            cell.sendButton.isEnabled = false
            cell.sendButton.backgroundColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        }
        else if cell.user_to_number.text?.count != 14 {
            cell.titleRed.isHidden = false
            cell.user_to_number.layer.borderColor = UIColor.red.cgColor
            cell.sendButton.isEnabled = false
            cell.sendButton.backgroundColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        }
        else if cell.count_transfer.text == "" {
            cell.titleRed2.text = defaultLocalizer.stringForKey(key: "error_trafic_count")
            cell.titleRed2.isHidden = false
            cell.count_transfer.layer.borderColor = UIColor.red.cgColor
            cell.sendButton.isEnabled = false
            cell.sendButton.backgroundColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
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
            view.name.text = defaultLocalizer.stringForKey(key: "Translation_successfully")
            view.image_icon.image = UIImage(named: "correct_alert")
            view.cancel.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
            view.ok.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
        }
        else {
            view.name.text = defaultLocalizer.stringForKey(key: "error_title")
            view.image_icon.image = UIImage(named: "uncorrect_alert")
            view.cancel.addTarget(self, action: #selector(cancelDialog), for: .touchUpInside)
            view.ok.addTarget(self, action: #selector(cancelDialog), for: .touchUpInside)
        }
        
        view.name_content.text = "\(message)"
        view.ok.setTitle("OK", for: .normal)
        
        alert.view.backgroundColor = .clear
        alert.view.addSubview(view)
        //alert.view.sendSubviewToBack(view)
        
        present(alert, animated: true, completion: nil)

        
    }
    
    @objc func cancelDialog() {
        print("hello")
        alert.dismiss(animated: true, completion: nil)
        hideActivityIndicator(uiView: view)
    }
    
    @objc func dismissDialog() {
        print("hello")
        alert.dismiss(animated: true, completion: nil)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(TraficTransferViewController(), animated: false)
        hideActivityIndicator(uiView: view)
    }
    
    @objc func okClickDialog(_ sender: UIButton) {
        
        alert.dismiss(animated: true, completion: nil)
        showActivityIndicator(uiView: view)
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = table.cellForRow(at: indexPath) as! TraficTableViewCell
        
        to_phone = String(cell.user_to_number.text ?? "")
        print(trasfer_type_choosed_id)
        
        print(to_phone)
        print(value_transfer)
        print(trasfer_type_choosed_id)
        
        to_phone = to_phone.replacingOccurrences(of: "+", with: "")
        to_phone = to_phone.replacingOccurrences(of: " ", with: "")
        
        let parametr: [String: Any] = ["inPhoneNumber": to_phone, "transferType":  trasfer_type_choosed_id, "value": Int(cell.count_transfer.text ?? "0")]
        print(parametr)
        
        let client = APIClient.shared
            do{
              try client.transferPostRequest(jsonBody: parametr).subscribe(
                onNext: { [self] result in
                  print(result)
                    //sendRequest()
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
                        requestAnswer(status: false, message: defaultLocalizer.stringForKey(key: "service is temporarily unavailable"))
                    }
                },
                onCompleted: { [self] in
                    
                   print("Completed event.")
                    
                }).disposed(by: disposeBag)
              }
              catch{
            }
    }
    
    @objc func openCondition() {
        
        detailViewController.more_view.content.text = settings_data[type_index][11]
        detailViewController.more_view.close_banner.addTarget(self, action: #selector(dismiss_view), for: .touchUpInside)
        detailViewController.more_view.close.addTarget(self, action: #selector(dismiss_view), for: .touchUpInside)
        detailViewController.more_view.title_top.text = defaultLocalizer.stringForKey(key: "Traffic_transfer")
    
        nav = UINavigationController(rootViewController: detailViewController)
        nav.modalPresentationStyle = .pageSheet
        nav.view.backgroundColor = contentColor
        nav.isNavigationBarHidden = true
        detailViewController.view.backgroundColor = colorGrayWhite
        if #available(iOS 15.0, *) {
            if let sheet = nav.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.selectedDetentIdentifier = .medium
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false

            }
        } else {
            // Fallback on earlier versions
        }
            // 4
        present(nav, animated: true, completion: nil)
    }
    
    @objc func dismiss_view() {
        print("jlllllll")
        nav.dismiss(animated: true, completion: nil)
    }
    
    @objc func tableTouch() {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = table.cellForRow(at: indexPath) as! TraficTableViewCell
        cell.count_transfer.resignFirstResponder()
        cell.user_to_number.resignFirstResponder()
    }
}

extension TraficTransferViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tabs", for: indexPath) as! TabTraficCollectionViewCell
        if indexPath.row == 0 {
            table.register(TraficTableViewCell.self, forCellReuseIdentifier: "cell_transfer")
            table.register(HistoryHeaderCell.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")
            table.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 150)
            table.delegate = self
            table.dataSource = self
            table.rowHeight = 750
            table.estimatedRowHeight = 750
            table.alwaysBounceVertical = false
            table.separatorStyle = .none
            table.showsVerticalScrollIndicator = false
            table.backgroundColor = contentColor
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tableTouch))
            table.isUserInteractionEnabled = true
            table.addGestureRecognizer(tapGestureRecognizer)
            cell.addSubview(table)
        }
        else {
            table2.register(TraficHistoryViewCell.self, forCellReuseIdentifier: "history_transfer")
            table2.register(HistoryHeaderCell.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")
            table2.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 120 + (topPadding ?? 0) + (bottomPadding ?? 0)))
            table2.delegate = self
            table2.dataSource = self
            table2.rowHeight = 90
            table2.estimatedRowHeight = 90
            table2.alwaysBounceVertical = false
            table2.separatorStyle = .none
            table2.showsVerticalScrollIndicator = false
            table2.backgroundColor = contentColor
            
            if HistoryData.count == 0 {
                emptyView = EmptyView(frame: CGRect(x: 0, y: 30, width: table2.frame.width, height: table2.frame.height), text: self.defaultLocalizer.stringForKey(key: "not_used_transfer"))
                table2.separatorStyle = .none
                table2.backgroundView = emptyView
            }
            cell.addSubview(table2)
            
        }
        return cell
    }
 
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == TabCollectionView {
            if indexPath.row == 0 {
                traficView.tab1.textColor = colorBlackWhite
                traficView.tab2.textColor = .gray
                traficView.tab1Line.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
                traficView.tab2Line.backgroundColor = .clear
                
            } else {
                traficView.tab1.textColor = .gray
                traficView.tab2.textColor = colorBlackWhite
                traficView.tab1Line.backgroundColor = .clear
                traficView.tab2Line.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
          }
       }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(indexPath.row)
        if collectionView == TabCollectionView {
            if indexPath.row == 0 {
                traficView.tab1.textColor = .gray
                traficView.tab2.textColor = colorBlackWhite
                traficView.tab1Line.backgroundColor = .clear
                traficView.tab2Line.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
          }
         else {
             traficView.tab1.textColor = colorBlackWhite
             traficView.tab2.textColor = .gray
             traficView.tab1Line.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
             traficView.tab2Line.backgroundColor = .clear
          }
       }
    }
    
}

extension TraficTransferViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == table {
            return 1
        }
        else {
            if HistoryData.count != 0 {
                return HistoryData.count
            }
            else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == table {
            return 0
        }
        else {
            if HistoryData.count != 0 {
                return 44
            }
            else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as! HistoryHeaderCell
        print(HistoryData[section].date_header)
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = DateFormatter.Style.long
        dateFormatter1.dateFormat = "yyyy-MM-dd "
        let date = dateFormatter1.date(from: HistoryData[section].date_header)
        dateFormatter1.dateFormat = "dd-MM-yyyy"
        view.title.text = HistoryData[section].date_header
        
        
       return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == table {
            return 1
        }
        else {
            return HistoryData[section].phoneNumber.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == table {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_transfer", for: indexPath) as! TraficTableViewCell
            cell.user_to_number.delegate = self
            cell.count_transfer.delegate = self
           
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: "user_field_icon"), for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
            button.frame = CGRect(x: CGFloat(cell.user_to_number.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
            
            cell.user_to_number.rightView = button
            cell.user_to_number.rightViewMode = .always
            
            
            if to_phone != "" {
                cell.user_to_number.text = "+992 " + to_phone
            }
            else {
                cell.user_to_number.text = "+992 "
            }
            
            if settings_data.count != 0  {
                button.addTarget(self, action: #selector(openContacts), for: .touchUpInside)
                
                trasfer_type_choosed = settings_data[0][9]
                trasfer_type_choosed_id = Int(settings_data[0][10])!
                cell.slider.value = [CGFloat(Double(settings_data[0][0])!)]
                cell.slider.minimumValue = CGFloat(Double(settings_data[0][0])!)
                cell.slider.maximumValue = CGFloat(Double(settings_data[0][1])!)
                cell.count_transfer.text = String(Int((cell.slider.value[0])))
                cell.title_info.text = settings_data[0][11]
                
                cell.type_transfer.text = trasfer_type_choosed
                
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openCondition))
                cell.icon_more.isUserInteractionEnabled = true
                cell.icon_more.addGestureRecognizer(tapGestureRecognizer)
                
                cell.slider.addTarget(self, action: #selector(self.sliderChanged), for: .valueChanged)
                cell.sendButton.addTarget(self, action:  #selector(self.translateTrafic), for: .touchUpInside)
            }
            
            cell.type_transfer.didSelect { [self] (selectedText, index, id) in
                self.trasfer_type_choosed = selectedText
                self.trasfer_type_choosed_id = Int(settings_data[index][10])!
                self.type_index = index
                //putRequest()
                cell.slider.minimumValue = CGFloat(Double(settings_data[index][0])!)
                cell.slider.maximumValue = CGFloat(Double(settings_data[index][1])!)
                cell.slider.value = [CGFloat(Double(settings_data[index][0])!)]
                cell.count_transfer.text = String(Int((cell.slider.value[0])))
            }
            
            cell.type_transfer.optionArray.removeAll()
            cell.type_transfer.optionIds?.removeAll()
            
            for i in 0 ..< settings_data.count {
                cell.type_transfer.optionArray.append(settings_data[i][9])
                cell.type_transfer.optionIds?.append(i)
               // putRequest()
                
            }
            
            let cost: NSString = defaultLocalizer.stringForKey(key: "Commission") as NSString
            let range = (cost).range(of: cost as String)
            let costString = NSMutableAttributedString.init(string: cost as String)
            costString.addAttribute(NSAttributedString.Key.foregroundColor, value: colorBlackWhite , range: range)
            costString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)], range: range)
            
            var title_cost = "1 " + defaultLocalizer.stringForKey(key: "tjs") as NSString
            
            let titleString = NSMutableAttributedString.init(string: title_cost as String)
            let range2 = (title_cost).range(of: title_cost as String)
            titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange , range: range2)
            titleString.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)], range: range2)
            costString.append(titleString)
            cell.title_commission.attributedText = costString
            
            let bgColorView = UIView()
            bgColorView.backgroundColor = .clear
            cell.selectedBackgroundView = bgColorView
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "history_transfer", for: indexPath) as! TraficHistoryViewCell
         
            cell.titleOne.text = HistoryData[indexPath.section].phoneNumber[indexPath.row]
            cell.titleOne.numberOfLines = 1
            cell.ico_image.frame.origin.y = 15
            
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
            let date = dateFormatter1.date(from: String(HistoryData[indexPath.section].date[indexPath.row]))
            dateFormatter1.dateFormat = "HH:mm"
            
            cell.titleFour.text = dateFormatter1.string(from: date!)
            
            if HistoryData[indexPath.section].statusId[indexPath.row] != "45" {
                cell.titleTwo.textColor = .red
                cell.titleTwo.text = "✖︎ " + HistoryData[indexPath.section].status[indexPath.row]
            }
            else {
                cell.titleTwo.textColor = UIColor(red: 0.153, green: 0.682, blue: 0.376, alpha: 1)
                cell.titleTwo.text = "✓ " + HistoryData[indexPath.section].status[indexPath.row]
            }
            
            if HistoryData[indexPath.section].type[indexPath.row] == "1" {
                if HistoryData[indexPath.section].transferType[indexPath.row] == "3" {
                    cell.ico_image.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "sms_black") : UIImage(named: "sms_white"))
                    cell.titleThree.text = "- " + HistoryData[indexPath.section].volume[indexPath.row] + defaultLocalizer.stringForKey(key: "SMS")
                 }
                 else if HistoryData[indexPath.section].transferType[indexPath.row] == "2" {
                     cell.ico_image.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "min_transfer_w") : UIImage(named: "min_transfer"))
                     cell.titleThree.text = "- " + HistoryData[indexPath.section].volume[indexPath.row]  +  defaultLocalizer.stringForKey(key: "minutes")
                 }
                 else if HistoryData[indexPath.section].transferType[indexPath.row] == "1" {
                     cell.ico_image.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "internet_transfer_w") : UIImage(named: "internet_transfer"))
                     cell.titleThree.text = "- " + HistoryData[indexPath.section].volume[indexPath.row] + defaultLocalizer.stringForKey(key: "megabyte")
                 }
            }
            else {
                if HistoryData[indexPath.section].transferType[indexPath.row] == "3" {
                    cell.ico_image.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "sms_black") : UIImage(named: "sms_white"))
                    cell.titleThree.text = "+ " + HistoryData[indexPath.section].volume[indexPath.row] + defaultLocalizer.stringForKey(key: "SMS")
                 }
                 else if HistoryData[indexPath.section].transferType[indexPath.row] == "2" {
                     cell.ico_image.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "min_transfer_w") : UIImage(named: "min_transfer"))
                     cell.titleThree.text = "+ " + HistoryData[indexPath.section].volume[indexPath.row]  +  defaultLocalizer.stringForKey(key: "minutes")
                 }
                 else if HistoryData[indexPath.section].transferType[indexPath.row] == "1" {
                     cell.ico_image.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "internet_transfer_w") : UIImage(named: "internet_transfer"))
                     cell.titleThree.text = "+ " + HistoryData[indexPath.section].volume[indexPath.row] + defaultLocalizer.stringForKey(key: "megabyte")
                 }
            }
            
            cell.titleTwo.frame = CGRect(x: 80, y: 40, width: Int(UIScreen.main.bounds.size.width) - (cell.titleFour.text!.count * 10) - 110, height: 50)
            
            cell.titleThree.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (cell.titleThree.text!.count * 15) - 30, y: 10, width: (cell.titleThree.text!.count * 15), height: 30)
            
            cell.titleFour.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (cell.titleFour.text!.count * 10) - 30, y: 40, width: (cell.titleFour.text!.count * 10), height: 50)
            
            cell.titleTwo.frame.size.height = CGFloat.greatestFiniteMagnitude
            cell.titleTwo.numberOfLines = 0
            cell.titleTwo.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.titleTwo.sizeToFit()
          
            cell.titleTwo.frame.origin.y = 40
            
            cell.contentView.frame.size = CGSize(width: view.frame.width, height: cell.titleTwo.frame.height + 50)
            
            cell.titleFour.frame.size.height =  cell.titleTwo.frame.size.height
            
            cell.frame.size.height = cell.titleTwo.frame.height + 50
            table2.rowHeight = cell.titleTwo.frame.height + 50
            
           /* cell.titleTwo.frame.size.height = CGFloat.greatestFiniteMagnitude
            cell.titleTwo.numberOfLines = 0
            cell.titleTwo.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.titleTwo.sizeToFit()
          
            cell.titleTwo.frame.origin.y = 60
            
            cell.contentView.frame.size = CGSize(width: view.frame.width, height: cell.titleTwo.frame.height + 70)
            
            cell.titleFour.frame.size.height =  cell.titleTwo.frame.size.height
            
            cell.frame.size.height = cell.titleTwo.frame.height + 70
            table2.rowHeight = cell.titleTwo.frame.height + 70*/
            
            
            let bgColorView = UIView()
            bgColorView.backgroundColor = .clear
            cell.selectedBackgroundView = bgColorView
            
            return cell
        }
       
    }
    
    @objc func sliderChanged(_ slider: MultiSlider) {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = table.cellForRow(at: indexPath) as! TraficTableViewCell
        
        cell.sendButton.isEnabled = true
        cell.sendButton.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
        cell.titleRed2.isHidden = true
        cell.count_transfer.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        
        cell.count_transfer.text = String(Int(slider.value[0]))
        
        var index = 0
        
        for i in 0 ..< settings_data.count {
            if Int(trasfer_type_choosed_id) == i {
                index = i
                break
            }
        }
        
        if Double(slider.value[0]) >= Double(settings_data[type_index][0])! && Double(slider.value[0])  <= Double(settings_data[type_index][2])! {

            if Double(settings_data[index][8])! > 0 {
                let discountPrice = (Double(settings_data[type_index][3])! * Double(settings_data[type_index][8])!) / 100
                let finallCost = (Double(settings_data[type_index][3])! - discountPrice)
                
                value_transfer = String(format: "%g", Double(String(format: "%.2f", finallCost))!) + " " + defaultLocalizer.stringForKey(key: "tjs")
            }
            else {
                value_transfer = String(format: "%g", Double(String(format: "%.2f", Double(settings_data[type_index][3])!))!) + " " + defaultLocalizer.stringForKey(key: "tjs")
            }

        }
        else if Double(slider.value[0]) > Double(settings_data[type_index][2])! && Double(slider.value[0]) <= Double(settings_data[type_index][1])! {

            if Double(settings_data[index][8])! > 0{
                let firstPrice = Double(slider.value[0]) * Double(settings_data[type_index][4])!
                let discountPrice = (firstPrice * Double(settings_data[type_index][8])!) / 100
                let finallCost = firstPrice - discountPrice
                value_transfer = String(format: "%g", Double(String(format: "%.2f", finallCost))!) + " " + defaultLocalizer.stringForKey(key: "tjs")
            }
            else {
                value_transfer = String(format: "%g", Double(String(format: "%.2f", Double(slider.value[0]) * Double(settings_data[type_index][4])!))!) + " " + defaultLocalizer.stringForKey(key: "tjs")
            }
        }
        
        let cost: NSString = defaultLocalizer.stringForKey(key: "Commission") as NSString
        let range = (cost).range(of: cost as String)
        let costString = NSMutableAttributedString.init(string: cost as String)
        costString.addAttribute(NSAttributedString.Key.foregroundColor, value: colorBlackWhite , range: range)
        costString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)], range: range)
        
        let title_cost = value_transfer as NSString
        
        let titleString = NSMutableAttributedString.init(string: title_cost as String)
        let range2 = (title_cost).range(of: title_cost as String)
        titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange , range: range2)
        titleString.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)], range: range2)
        costString.append(titleString)
        cell.title_commission.attributedText = costString
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let indexPath = IndexPath(item: 0, section: 0);
        let cell = table.cellForRow(at: indexPath) as! TraficTableViewCell
        
        cell.user_to_number.resignFirstResponder()
        cell.count_transfer.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let indexPath = IndexPath(item: 0, section: 0);
        let cell = table.cellForRow(at: indexPath) as! TraficTableViewCell
        
        if settings_data.count == 0 {
            cell.count_transfer.resignFirstResponder()
            cell.user_to_number.resignFirstResponder()
        }
        
        if textField.tag == 1 {
            cell.user_to_number.textColor = colorBlackWhite
            cell.titleRed.isHidden = true
            cell.titleRed2.isHidden = true
            cell.user_to_number.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
            cell.count_transfer.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
            cell.sendButton.isEnabled = true
            cell.sendButton.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
        }
        else if textField.tag == 2 {
            cell.count_transfer.textColor = colorBlackWhite
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        let indexPath = IndexPath(item: 0, section: 0);
        let cell = table.cellForRow(at: indexPath) as! TraficTableViewCell
        if textField.tag == 1 {
            cell.user_to_number.textColor = colorBlackWhite
        }
        cell.count_transfer.text = String(Int(cell.count_transfer.text ?? "1") ?? 1)
        cell.count_transfer.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var return_status = true
        var amount = ""
        let indexPath = IndexPath(item: 0, section: 0);
        let cell = table.cellForRow(at: indexPath) as! TraficTableViewCell
        to_phone = cell.user_to_number.text! + string
        cell.titleRed.isHidden = true
        cell.titleRed2.isHidden = true
        cell.user_to_number.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        cell.count_transfer.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        
        let tag = textField.tag
        
        let cursorPosition2 = cell.user_to_number.offset(from: cell.user_to_number.beginningOfDocument, to: cell.user_to_number.selectedTextRange!.start)
        let cursorPosition = cell.count_transfer.offset(from: cell.count_transfer.beginningOfDocument, to: cell.count_transfer.selectedTextRange!.start)
        
        if textField == cell.count_transfer && string == "0" {
           
            if textField.text!.count == 0 || cursorPosition == 0 {
                return false
            }
        }
        
        if cursorPosition == 0 && textField == cell.count_transfer {
            amount = string + cell.count_transfer.text!
        }
        else {
            amount = cell.count_transfer.text! + string
        }
        
        if string  == "" {
            if cursorPosition2 <= 5 && textField == cell.user_to_number {
                return false
            }
            else if textField == cell.user_to_number && cell.user_to_number.text == "+992 " {
                return false
            }
            else if textField == cell.user_to_number && cell.user_to_number.text != "+992 " {
                to_phone = (to_phone as String).substring(to: to_phone.index(before: to_phone.endIndex))
            }
            else {
                print("amount")
                print(cell.count_transfer.text)
                print(textField.text)
                print(amount)
                
                var i = amount.index(amount.startIndex, offsetBy: cursorPosition - 1)
                amount.remove(at: i)
                
                
                print("amount2")
                print(cell.count_transfer.text)
                print(textField.text)
                print(amount)
                
                amount = String(Int(amount ?? "1") ?? 1)
                print("amount3")
                print(amount)
            }
            
        }
        
        if textField == cell.user_to_number && string != "" && cell.user_to_number.text!.count == 14 {
            return false
        }
        
        var index = 0
        
        for i in 0 ..< settings_data.count {
            if Int(trasfer_type_choosed_id) == i {
                index = i
                break
            }
        }
        
        if amount != "" && textField == cell.count_transfer  {
            if Double(amount)! < Double(settings_data[type_index][0])! {
                cell.titleRed2.text = defaultLocalizer.stringForKey(key: "minimum_limit:") + " " + settings_data[index][0]
                cell.titleRed2.isHidden = false
                cell.count_transfer.layer.borderColor = UIColor.red.cgColor
                cell.sendButton.isEnabled = false
                cell.sendButton.backgroundColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
                return_status = true
            }
            else if string != "" && Double(amount)! > Double(settings_data[type_index][1])! && textField == cell.count_transfer {
                cell.titleRed2.text = defaultLocalizer.stringForKey(key: "maximum_limit:") + " " + settings_data[type_index][1]
                cell.titleRed2.isHidden = false
                cell.count_transfer.layer.borderColor = UIColor.red.cgColor
                cell.sendButton.isEnabled = false
                cell.sendButton.backgroundColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
               return_status = false
            }
            else {
                cell.titleRed2.isHidden = true
                cell.count_transfer.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
                cell.sendButton.isEnabled = true
                cell.sendButton.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
                return_status = true
            }
        }
        
        if amount != "" && textField == cell.count_transfer {
            cell.slider.value[0] = CGFloat(Double(amount)!)
            if Double(cell.slider.value[0]) >= Double(settings_data[type_index][0])! && Double(cell.slider.value[0])  <= Double(settings_data[type_index][2])! {

                if Double(settings_data[type_index][8])! > 0 {
                    let discountPrice = (Double(settings_data[type_index][3])! * Double(settings_data[type_index][8])!) / 100
                    let finallCost = (Double(settings_data[type_index][3])! - discountPrice)
                    
                    value_transfer = String(format: "%g", Double(String(format: "%.2f", finallCost))!) + " "  + defaultLocalizer.stringForKey(key: "tjs")
                }
                else {
                    value_transfer = String(format: "%g", Double(String(format: "%.2f", Double(settings_data[type_index][3])!))!) + " " + defaultLocalizer.stringForKey(key: "tjs")
                }

            }
            else if Double(cell.slider.value[0]) > Double(settings_data[type_index][2])! && Double(cell.slider.value[0]) <= Double(settings_data[type_index][1])! && textField == cell.count_transfer{

                if Double(settings_data[type_index][8])! > 0{
                    let firstPrice = Double(cell.slider.value[0]) * Double(settings_data[type_index][4])!
                    let discountPrice = (firstPrice * Double(settings_data[type_index][8])!) / 100
                    let finallCost = firstPrice - discountPrice
                    value_transfer = String(format: "%g", Double(String(format: "%.2f", finallCost))!) + " " + defaultLocalizer.stringForKey(key: "tjs")
                }
                else {
                    value_transfer = String(format: "%g", Double(String(format: "%.2f", Double(cell.slider.value[0]) * Double(settings_data[type_index][4])!))!) + " " + defaultLocalizer.stringForKey(key: "tjs")
                }
            }
            
            let cost: NSString = defaultLocalizer.stringForKey(key: "Commission") as NSString
            let range = (cost).range(of: cost as String)
            let costString = NSMutableAttributedString.init(string: cost as String)
            costString.addAttribute(NSAttributedString.Key.foregroundColor, value: colorBlackWhite , range: range)
            costString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)], range: range)
            
            let title_cost = value_transfer as NSString
            
            let titleString = NSMutableAttributedString.init(string: title_cost as String)
            let range2 = (title_cost).range(of: title_cost as String)
            titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange , range: range2)
            titleString.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)], range: range2)
            costString.append(titleString)
            cell.title_commission.attributedText = costString
            
        }
        
        return return_status
    }
    
    @objc func openContacts() {
        let indexPath = IndexPath(item: 0, section: 0);
        let cell = table.cellForRow(at: indexPath) as! TraficTableViewCell
        
        cell.titleRed.isHidden = true
        cell.titleRed2.isHidden = true
        cell.user_to_number.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        cell.count_transfer.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        cell.sendButton.isEnabled = true
        cell.sendButton.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
        
        cell.count_transfer.resignFirstResponder()
        cell.user_to_number.resignFirstResponder()
        
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
}
