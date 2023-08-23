//
//  ChangeTransferViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/29/21.
//

import UIKit
import RxSwift
import RxCocoa
import MultiSlider
import iOSDropDown
import Alamofire
import AlamofireImage

struct exchangeData {
    let date_header: String
    let phoneNumber: [String]
    let status: [String]
    let date: [String]
    let id: [String]
    let volumeA: [String]
    let volumeB: [String]
    let unitA: [String]
    let unitB: [String]
    let price: [String]
    let exchangeType: [String]
    let statusId: [String]
    let transactionId: [String]
}

struct unitsData {
    let unitName: String
    let unitB_unitName: [String]
    let exchangeType: [String]
}

@available(iOS 15.0, *)
class ChangeTransferViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {
    
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    let disposeBag = DisposeBag()
    let detailViewController = MoreDetailViewController()
    var nav = UINavigationController()
    var alert = UIAlertController()
    
    let scrollView = UIScrollView()
    
    var toolbar = TarifToolbarView()
    var changeView = ChangeTransferView()
    let table = UITableView()
    var table2 = UITableView(frame: .zero, style: .grouped)
    
    var x_pozition = 20
    var y_pozition = 380
    
    let TabCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(TabChangeCollectionViewCell.self, forCellWithReuseIdentifier: "tabs")
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        return cv
    }()
    
    var balances_data = [[String]]()
    var settings_data = [[String]]()
    
    var units_data = [unitsData(unitName: String(), unitB_unitName: [String](), exchangeType: [String]())]
    
    var HistoryData = [exchangeData(date_header: String(), phoneNumber: [String](), status: [String](), date: [String](), id: [String](), volumeA: [String](), volumeB: [String](), unitA: [String](), unitB: [String](), price: [String](), exchangeType: [String](), statusId: [String](), transactionId: [String]())]
    
    var balance = ""
    var trasfer_type_choosed = ""
    var trasfer_type_choosed_id = 0
    
    var to_trasfer_type_choosed = ""
    var to_trasfer_type_choosed_id = 0
    
    var exchangeType = "0"
    var value = ""
    var countTransfer = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showActivityIndicator(uiView: self.view)
        view.backgroundColor = toolbarColor
        
        toolbar = TarifToolbarView(frame: CGRect(x: 0, y: topPadding ?? 0, width: UIScreen.main.bounds.size.width, height: 60))
        
        self.view.addSubview(toolbar)
        
        toolbar.icon_back.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goBack))
        toolbar.isUserInteractionEnabled = true
        toolbar.addGestureRecognizer(tapGestureRecognizer)
        
        toolbar.number_user_name.text = defaultLocalizer.stringForKey(key: "Traffic_exchange")
        
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
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 850)
        view.addSubview(scrollView)
        
        //toolbar = TarifToolbarView(frame: CGRect(x: 0, y: topPadding ?? 0, width: UIScreen.main.bounds.size.width, height: 60))
        changeView = ChangeTransferView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 896))
        
        
        scrollView.addSubview(changeView)
        
        /*toolbar.icon_back.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goBack))
        toolbar.isUserInteractionEnabled = true
        toolbar.addGestureRecognizer(tapGestureRecognizer)
        
        toolbar.number_user_name.text = defaultLocalizer.stringForKey(key: "Traffic_exchange")*/
        
        for i in 0 ..< hot_services_data.count {
            if hot_services_data[i][0] == "3" {
                changeView.image_banner.af_setImage(withURL: URL(string: hot_services_data[i][3])!)
            }
        }
        self.changeView.balance.text = balance
        
        if balances_data.count != 0 {
            changeView.rez1.text = balances_data[0][0]
            changeView.rez2.text = balances_data[0][1]
            changeView.rez3.text = balances_data[0][2]
            changeView.rez4.text = balances_data[0][3]
        }
        
        changeView.rez1.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (changeView.rez1.text!.count * 15) - 50, y: 0, width: (changeView.rez1.text!.count * 15), height: 45)
        changeView.rez2.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (changeView.rez2.text!.count * 15) - 50, y: 47, width: (changeView.rez2.text!.count * 15), height: 45)
        changeView.rez3.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (changeView.rez3.text!.count * 15) - 50, y: 94, width: (changeView.rez3.text!.count * 15), height: 45)
        changeView.rez4.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (changeView.rez4.text!.count * 15) - 50, y: 141, width: (changeView.rez4.text!.count * 15), height: 45)
        
        scrollView.frame = CGRect(x: 0, y: 60 + (topPadding ?? 0), width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 60 + (topPadding ?? 0) + (bottomPadding ?? 0)))
    }

    func setupTabCollectionView() {
        y_pozition = y_pozition + 55
        
        changeView.tab1.frame = CGRect(x: 10, y: y_pozition, width: Int(UIScreen.main.bounds.size.width - 20) / 2, height: 40)
        changeView.tab2.frame = CGRect(x: ((UIScreen.main.bounds.size.width - 20) / 2) + 10, y: CGFloat(y_pozition), width: (UIScreen.main.bounds.size.width - 20) / 2, height: 40)
        
        changeView.tab1Line.frame = CGRect(x: 10, y: y_pozition + 40, width: Int(UIScreen.main.bounds.size.width - 20) / 2, height: 2)
        changeView.tab2Line.frame = CGRect(x: ((UIScreen.main.bounds.size.width - 20) / 2) + 10, y: CGFloat(y_pozition + 40), width: (UIScreen.main.bounds.size.width - 20) / 2, height: 2)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tab1Click))
        changeView.tab1.isUserInteractionEnabled = true
        changeView.tab1.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(tab2Click))
        changeView.tab2.isUserInteractionEnabled = true
        changeView.tab2.addGestureRecognizer(tapGestureRecognizer2)
        
        scrollView.addSubview(TabCollectionView)
        TabCollectionView.backgroundColor = contentColor
        TabCollectionView.frame = CGRect(x: 0, y: y_pozition + 45, width: Int(UIScreen.main.bounds.size.width), height: Int(UIScreen.main.bounds.size.height - 150))
        TabCollectionView.delegate = self
        TabCollectionView.dataSource = self
        TabCollectionView.alwaysBounceVertical = false
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.scrollView == scrollView || table == scrollView || table2 == scrollView  {
            if scrollView.contentOffset.y > changeView.tab1.frame.origin.y {
                changeView.titleOne.isHidden = true
                changeView.balance.isHidden = true
                changeView.image_banner.isHidden = true
                changeView.white_view_back.isHidden = true
                self.scrollView.contentOffset.y = 0
                changeView.tab1.frame.origin.y = 0
                changeView.tab2.frame.origin.y = 0
                changeView.tab1Line.frame.origin.y = 40
                changeView.tab2Line.frame.origin.y = 40
                TabCollectionView.frame.origin.y = 45
            }
            if scrollView.contentOffset.y < -10 && changeView.white_view_back.isHidden == true {
                changeView.titleOne.isHidden = false
                changeView.balance.isHidden = false
                changeView.image_banner.isHidden = false
                changeView.white_view_back.isHidden = false
                changeView.tab1.frame.origin.y = CGFloat(y_pozition)
                changeView.tab2.frame.origin.y = CGFloat(y_pozition)
                changeView.tab1Line.frame.origin.y = CGFloat(y_pozition + 40)
                changeView.tab2Line.frame.origin.y = CGFloat(y_pozition + 40)
                TabCollectionView.frame.origin.y = CGFloat(y_pozition + 45)
               
            }
        }
        
        
    }
    
    @objc func tab1Click() {
        changeView.tab1.textColor = colorBlackWhite
        changeView.tab2.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        changeView.tab1Line.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
        changeView.tab2Line.backgroundColor = .clear
        TabCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionView.ScrollPosition.right, animated: true)
    }
    
    @objc func tab2Click() {
        changeView.tab1.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        changeView.tab2.textColor = colorBlackWhite
        changeView.tab1Line.backgroundColor = .clear
        changeView.tab2Line.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
        TabCollectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: UICollectionView.ScrollPosition.left, animated: true)
    }
    
    func sendRequest() {
        units_data.removeAll()
        
        let client = APIClient.shared
            do{
              try client.getExchangeRequest().subscribe(
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
                        
                      //  self.balance = String(result.subscriberBalance) + " " + self.defaultLocalizer.stringForKey(key: "tjs")
                        
                        if result.settings.count != 0 {
                            for i in 0 ..< result.settings.count {
                                self.settings_data.append([String(result.settings[i].minValue), String(result.settings[i].maxValue), String(result.settings[i].midValue), String(result.settings[i].midPrice), String(result.settings[i].price), String(result.settings[i].costPrice), String(result.settings[i].quantityLimit), String(result.settings[i].volumeLimitA), String(result.settings[i].volumeLimitB), String(result.settings[i].conversationRateTrafficA), String(result.settings[i].conversationRateTrafficB), String(result.settings[i].discountPercent), String(result.settings[i].exchangeRate), String(result.settings[i].exchangeType), String(result.settings[i].exchangeTypeId), String(result.settings[i].description)])
                            }
                        }
                        
                        if result.units.count != 0 {
                            for i in 0 ..< result.units.count {
                                var tableData = [String]()
                                var tableData2 = [String]()
                                
                                for j in 0 ..< result.units[i].unitB.count {
                                    
                                    tableData.append(String(result.units[i].unitB[j].unitName))
                                    tableData2.append(String(result.units[i].unitB[j].exchangeType))
                                    
                                }
                                self.units_data.append(unitsData(unitName: result.units[i].unitName, unitB_unitName: tableData, exchangeType: tableData2))
                            }
                            
                            
                        }
                        print(self.units_data)
                        
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
              try client.exchangeHistoryRequest().subscribe(
                onNext: { result in
                  print(result)
                    DispatchQueue.main.async { [self] in
                        
                        if result.history?.count != nil {
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
                                var tableData10 = [String]()
                                var tableData11 = [String]()
                                var tableData12 = [String]()
                                
                                for j in 0 ..< result.history![i].histories.count {
                                    
                                    tableData.append(String(result.history![i].histories[j].phoneNumber))
                                    tableData2.append(String(result.history![i].histories[j].status))
                                    tableData3.append(String(result.history![i].histories[j].date))
                                    tableData4.append(String(result.history![i].histories[j].id))
                                    
                                    if (result.history![i].histories[j].volumeA as? Int) != nil {
                                        tableData5.append(String(result.history![i].histories[j].volumeA as! Int))
                                    } else {
                                        tableData5.append(String(result.history![i].histories[j].volumeA as! Double))
                                    }
                                        
                                    if (result.history![i].histories[j].volumeB as? Int) != nil {
                                        tableData6.append(String(result.history![i].histories[j].volumeB as! Int))
                                    } else {
                                        tableData6.append(String(result.history![i].histories[j].volumeB as! Double))
                                    }
                                        
                                    tableData7.append(String(result.history![i].histories[j].unitA))
                                    tableData8.append(String(result.history![i].histories[j].unitB))
                                    tableData9.append(String(result.history![i].histories[j].price))
                                    tableData10.append(String(result.history![i].histories[j].exchangeType))
                                    tableData11.append(String(result.history![i].histories[j].statusId))
                                    tableData12.append(String(result.history![i].histories[j].transactionId))
                                }
                                
                                if String(result.history![i].date) != "" {
                                    
                                    HistoryData.append(exchangeData(date_header: String(result.history![i].date), phoneNumber: tableData, status: tableData2, date: tableData3, id: tableData4, volumeA: tableData5, volumeB: tableData6, unitA: tableData7, unitB: tableData8, price: tableData9, exchangeType: tableData10, statusId: tableData11, transactionId: tableData12))
                                }
                            }
                        }
                        
                        else {
                            print("empty history")
                            DispatchQueue.main.async {
                            emptyView = EmptyView(frame: CGRect(x: 0, y: 30, width: self.table2.frame.width, height: self.table2.frame.height), text: self.defaultLocalizer.stringForKey(key: "not_used_exchange"))
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
                    }
                    client.requestObservable.tabIndicator = "0"
                },
                onCompleted: {
                    client.requestObservable.tabIndicator = "0"
                    
                    DispatchQueue.main.async { [self] in
                        print(HistoryData.count)
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
        let cell = table.cellForRow(at: indexPath) as! ChangeTransferTableViewCell
        
        //value = String(cell.count_transfer.text ?? "")
        
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
        
        let view = AlertView3()
        view.backgroundColor = contentColor
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 80, height: 380)
        view.layer.cornerRadius = 20
        view.name.text = defaultLocalizer.stringForKey(key: "Traffic_exchange")
        
       if exchangeType == "1" {
           view.image_icon.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "sms_black") : UIImage(named: "sms_white"))
           view.image_icon2.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "internet_transfer_w") : UIImage(named: "internet_transfer"))
        }
        else if exchangeType == "2" {
            view.image_icon.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "min_transfer_w") : UIImage(named: "min_transfer"))
            view.image_icon2.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "internet_transfer_w") : UIImage(named: "internet_transfer"))
        }
        else if exchangeType == "3" {
            view.image_icon.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "internet_transfer_w") : UIImage(named: "internet_transfer"))
            view.image_icon2.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "min_transfer_w") : UIImage(named: "min_transfer"))
        }
        
        let cost: NSString = defaultLocalizer.stringForKey(key: "Exchange") as NSString
        let range = (cost).range(of: cost as String)
        let costString = NSMutableAttributedString.init(string: cost as String)
        costString.addAttribute(NSAttributedString.Key.foregroundColor, value: colorBlackWhite , range: range)
        costString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], range: range)
        
        var title_cost = " \(String(value)) " as NSString
        
        if exchangeType == "1" {
            title_cost = " \(String(cell.count_transfer.text ?? "")) \(defaultLocalizer.stringForKey(key: "SMS"))" as NSString
        }
        else if exchangeType == "2" {
            title_cost = " \(String(cell.count_transfer.text ?? ""))" + defaultLocalizer.stringForKey(key: "minutes") as NSString
        }
        else if exchangeType == "3" {
            title_cost = " \(String(cell.count_transfer.text ?? ""))" + defaultLocalizer.stringForKey(key: "megabyte") as NSString
        }
        let titleString = NSMutableAttributedString.init(string: title_cost as String)
        let range2 = (title_cost).range(of: title_cost as String)
        titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange , range: range2)
        titleString.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], range: range2)
        costString.append(titleString)
        view.value_title.attributedText = costString
        
        
        let cost2: NSString = defaultLocalizer.stringForKey(key: "on_the") as NSString
        let range2_1 = (cost2).range(of: cost2 as String)
        let costString2 = NSMutableAttributedString.init(string: cost2 as String)
        costString2.addAttribute(NSAttributedString.Key.foregroundColor, value: colorBlackWhite , range: range2_1)
        costString2.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], range: range2_1)
        
        cell.count_transfer.text = String(Int(cell.count_transfer.text ?? "1") ?? 1)
        
        var title_cost2 = " \(String(cell.count_to_transfer.text ?? "")) " as NSString
        if exchangeType == "1" {
            title_cost2 = " \(String(cell.count_to_transfer.text ?? ""))" + defaultLocalizer.stringForKey(key: "megabyte") as NSString
        }
        else if exchangeType == "2" {
            title_cost2 = " \(String(cell.count_to_transfer.text ?? ""))"  + defaultLocalizer.stringForKey(key: "megabyte") as NSString
        }
        else if exchangeType == "3" {
            title_cost2 = " \(String(cell.count_to_transfer.text ?? ""))"  + defaultLocalizer.stringForKey(key: "minutes") as NSString
        }
        let titleString2 = NSMutableAttributedString.init(string: title_cost2 as String)
        let range2_2 = (title_cost2).range(of: title_cost2 as String)
        titleString2.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange , range: range2_2)
        titleString2.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], range: range2_2)
        
        let title_cost2_1 = " ?" as NSString
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
        var title_cost3 = " \(String(value)) " as NSString
        let titleString3 = NSMutableAttributedString.init(string: title_cost3 as String)
        let range3_1 = (title_cost3).range(of: title_cost3 as String)
        titleString3.addAttribute(NSAttributedString.Key.foregroundColor, value: darkGrayLight , range: range3_1)
        titleString3.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], range: range3_1)
        costString3.append(titleString3)
        view.cost_title.attributedText = costString3
        
        view.ok.setTitle(defaultLocalizer.stringForKey(key: "Exchange"), for: .normal)
        view.cancel.addTarget(self, action: #selector(cancelDialog), for: .touchUpInside)
        view.ok.addTarget(self, action: #selector(okClickDialog), for: .touchUpInside)
        alert.view.backgroundColor = .clear
        alert.view.addSubview(view)
        
       if cell.count_transfer.text == "" {
            cell.titleRed.text = defaultLocalizer.stringForKey(key: "error_trafic_count")
            cell.titleRed.isHidden = false
            cell.count_transfer.layer.borderColor = UIColor.red.cgColor
            cell.sendButton.isEnabled = false
            cell.sendButton.backgroundColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        }
        else if cell.count_transfer.text != ""{
            if Double(cell.count_transfer.text ?? "0")! < Double(settings_data[trasfer_type_choosed_id][0])! {
                cell.titleRed.text = defaultLocalizer.stringForKey(key: "minimum_limit:") + " " + settings_data[trasfer_type_choosed_id][0]
                cell.titleRed.isHidden = false
                cell.count_transfer.layer.borderColor = UIColor.red.cgColor
                cell.sendButton.isEnabled = false
                cell.sendButton.backgroundColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
             
            }
            else if Double(cell.count_transfer.text ?? "0")! > Double(settings_data[trasfer_type_choosed_id][1])!  {
                cell.titleRed.text = defaultLocalizer.stringForKey(key: "maximum_limit:") + " " + String(Int(settings_data[trasfer_type_choosed_id][1])!)
                cell.titleRed.isHidden = false
                cell.count_transfer.layer.borderColor = UIColor.red.cgColor
                cell.sendButton.isEnabled = false
                cell.sendButton.backgroundColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
            }
            else {
                present(alert, animated: true, completion: nil)
            }
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
        
        let view = AlertView3()

        view.backgroundColor = contentColor
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 40, height: 360)
        view.layer.cornerRadius = 20
        
        
        
        if status == true {
            view.name.text = defaultLocalizer.stringForKey(key: "Traffic_exchange_completed")
            view.cancel.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
            view.ok.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
            
            if exchangeType == "1" {
                view.image_icon.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "sms_black") : UIImage(named: "sms_white"))
                view.image_icon2.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "internet_transfer_w") : UIImage(named: "internet_transfer"))
             }
             else if exchangeType == "2" {
                 view.image_icon.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "min_transfer_w") : UIImage(named: "min_transfer"))
                 view.image_icon2.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "internet_transfer_w") : UIImage(named: "internet_transfer"))
             }
             else if exchangeType == "3" {
                 view.image_icon.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "internet_transfer_w") : UIImage(named: "internet_transfer"))
                 view.image_icon2.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "min_transfer_w") : UIImage(named: "min_transfer"))
             }
        }
        else {
            view.name.text = defaultLocalizer.stringForKey(key: "error_title")
            view.image_icon.image = UIImage(named: "uncorrect_alert")
            view.cancel.addTarget(self, action: #selector(cancelDialog), for: .touchUpInside)
            view.ok.addTarget(self, action: #selector(cancelDialog), for: .touchUpInside)
        }
        
        view.value_title.text = "\(message)"
        view.value_title.numberOfLines = 4
        view.value_title.textColor = colorBlackWhite
        view.value_title.font = UIFont.systemFont(ofSize: 17)
        view.value_title.lineBreakMode = NSLineBreakMode.byWordWrapping
        view.value_title.textAlignment = .center
        view.value_title.frame = CGRect(x: 20, y: 188, width: UIScreen.main.bounds.size.width - 80, height: 60)
        
        
        view.ok.frame = CGRect(x: 20, y: 275, width: UIScreen.main.bounds.size.width - 80, height: 45)
        view.ok.setTitle("OK", for: .normal)
        
        view.cancel.frame.origin.x = UIScreen.main.bounds.size.width - 80
        view.name.frame.size.width = UIScreen.main.bounds.size.width - 80
        alert.view.backgroundColor = .clear
        alert.view.addSubview(view)
        //alert.view.sendSubviewToBack(view)
        
        self.present(alert, animated: true, completion: nil)

        
    }
    
    @objc func cancelDialog() {
        alert.dismiss(animated: true, completion: nil)
        hideActivityIndicator(uiView: view)
    }
    
    @objc func dismissDialog(_ sender: UIButton) {
        
        sender.showAnimation { [self] in
            alert.dismiss(animated: true, completion: nil)
        }
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(ChangeTransferViewController(), animated: false)
    }
    
    @objc func okClickDialog(_ sender: UIButton) {
        
        alert.dismiss(animated: true, completion: nil)
        showActivityIndicator(uiView: view)
        
        print(sender.tag)
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = table.cellForRow(at: indexPath) as! ChangeTransferTableViewCell
        
        let parametr: [String: Any] = ["exchangeType": exchangeType, "value": String(cell.count_transfer.text ?? "")]
        
         let client = APIClient.shared
             do{
               try client.exchangePutRequest(jsonBody: parametr).subscribe(
                 onNext: { [self] result in
                   print(result)
                     print("here")
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
                     print("and here")
                     DispatchQueue.main.async {
                         requestAnswer(status: false, message: defaultLocalizer.stringForKey(key: "service is temporarily unavailable"))
                         print(error.localizedDescription)
                         self.hideActivityIndicator(uiView: self.view)
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
        print(trasfer_type_choosed_id)
        print(settings_data[trasfer_type_choosed_id][11])
        
        detailViewController.more_view.content.text = settings_data[trasfer_type_choosed_id][15]
        detailViewController.more_view.title_top.text = defaultLocalizer.stringForKey(key: "Traffic_exchange")
       
        detailViewController.more_view.close_banner.addTarget(self, action: #selector(dismiss_view), for: .touchUpInside)
        detailViewController.more_view.close.addTarget(self, action: #selector(dismiss_view), for: .touchUpInside)
        
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
        let cell = table.cellForRow(at: indexPath) as! ChangeTransferTableViewCell
        cell.count_transfer.resignFirstResponder()
        cell.count_to_transfer.resignFirstResponder()
    }
}

@available(iOS 15.0, *)
extension ChangeTransferViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tabs", for: indexPath) as! TabChangeCollectionViewCell
        if indexPath.row == 0 {
            table.register(ChangeTransferTableViewCell.self, forCellReuseIdentifier: "cell_transfer")
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
            table2.rowHeight = 150
            table2.estimatedRowHeight = 150
            table2.alwaysBounceVertical = false
            table2.separatorStyle = .none
            table2.showsVerticalScrollIndicator = false
            table2.backgroundColor = contentColor
            
           /* if HistoryData.count == 0 {
                emptyView = EmptyView(frame: CGRect(x: 0, y: 30, width: table2.frame.width, height: table2.frame.height), text: self.defaultLocalizer.stringForKey(key: "not_used_exchange"))
                table2.separatorStyle = .none
                table2.backgroundView = emptyView
            }*/
            
            cell.addSubview(table2)
            
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == TabCollectionView {
            if indexPath.row == 0 {
                changeView.tab1.textColor = colorBlackWhite
                changeView.tab2.textColor = .gray
                changeView.tab1Line.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
                changeView.tab2Line.backgroundColor = .clear
                
            } else {
                changeView.tab1.textColor = .gray
                changeView.tab2.textColor = colorBlackWhite
                changeView.tab1Line.backgroundColor = .clear
                changeView.tab2Line.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
          }
       }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(indexPath.row)
        if collectionView == TabCollectionView {
            if indexPath.row == 0 {
                changeView.tab1.textColor = .gray
                changeView.tab2.textColor = colorBlackWhite
                changeView.tab1Line.backgroundColor = .clear
                changeView.tab2Line.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
          }
         else {
             changeView.tab1.textColor = colorBlackWhite
             changeView.tab2.textColor = .gray
             changeView.tab1Line.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
             changeView.tab2Line.backgroundColor = .clear
          }
       }
    }
}

@available(iOS 15.0, *)
extension ChangeTransferViewController: UITableViewDataSource, UITableViewDelegate {
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_transfer", for: indexPath) as! ChangeTransferTableViewCell
            cell.count_to_transfer.delegate = self
            cell.count_transfer.delegate = self
           // cell.count_to_transfer.isUserInteractionEnabled = false
            
            if  units_data.count != 0 {
                trasfer_type_choosed = units_data[0].unitName
                to_trasfer_type_choosed = units_data[0].unitB_unitName[0]
                exchangeType = units_data[0].exchangeType[0]
                trasfer_type_choosed_id = 0
                value = "1 " + defaultLocalizer.stringForKey(key: "tjs")
                countTransfer = String(Int(Double(settings_data[0][0])!))
                
                cell.slider.value = [CGFloat(Double(settings_data[0][0])!)]
                cell.slider.minimumValue = CGFloat(Double(settings_data[0][0])!)
                cell.slider.maximumValue = CGFloat(Double(settings_data[0][1])!)
                cell.user_to_number.text = trasfer_type_choosed
                cell.type_transfer.text = to_trasfer_type_choosed
                cell.count_transfer.text = String(Int(Double(settings_data[0][0])!))
                cell.count_to_transfer.text = String(Int(Double(cell.slider.value[0]) * Double(settings_data[0][12])!))
                cell.title_info.text = settings_data[0][15]
                
                
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openCondition))
                cell.icon_more.isUserInteractionEnabled = true
                cell.icon_more.addGestureRecognizer(tapGestureRecognizer)
            
                cell.sendButton.addTarget(self, action:  #selector(translateTrafic), for: .touchUpInside)
            }
            
            for i in 0 ..< units_data.count {
                cell.user_to_number.optionArray.append(units_data[i].unitName)
                cell.user_to_number.optionIds?.append(i)
            }
            
            cell.user_to_number.didSelect { [self] (selectedText, index, id) in
                print(id)
                print(index)
                trasfer_type_choosed = selectedText
                trasfer_type_choosed_id = index
                to_trasfer_type_choosed = units_data[index].unitB_unitName[0]
                exchangeType = units_data[index].exchangeType[0]
                value = "1 " + defaultLocalizer.stringForKey(key: "tjs")
                
                for i in 0 ..< settings_data.count {
                    if exchangeType == settings_data[i][14] {
                        cell.slider.minimumValue = CGFloat(Double(settings_data[i][0])!)
                        cell.slider.maximumValue = CGFloat(Double(settings_data[i][1])!)
                        cell.slider.value = [CGFloat(Double(settings_data[i][0])!)]
                        cell.count_transfer.text = String(Int((cell.slider.value[0])))
                        cell.count_to_transfer.text = String(Int(Double(settings_data[index][0])! * Double(settings_data[index][12])!))
                        
                        cell.titleRed.isHidden = true
                        cell.count_transfer.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
                        cell.sendButton.isEnabled = true
                        cell.sendButton.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
                        break
                    }
                
                    
                }
                
                cell.type_transfer.optionArray.removeAll()
                cell.type_transfer.optionIds?.removeAll()
                cell.type_transfer.text = units_data[trasfer_type_choosed_id].unitB_unitName[0]
                
                print(units_data[trasfer_type_choosed_id].unitB_unitName[0])
                for j in 0 ..< units_data[trasfer_type_choosed_id].unitB_unitName.count {
                    cell.type_transfer.optionArray.append(units_data[trasfer_type_choosed_id].unitB_unitName[j])
                    cell.type_transfer.optionIds?.append(Int(units_data[trasfer_type_choosed_id].exchangeType[j])!)
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
            }
            
            cell.type_transfer.didSelect { [self] (selectedText, index, id) in
                to_trasfer_type_choosed = units_data[trasfer_type_choosed_id].unitB_unitName[index]
                exchangeType = units_data[trasfer_type_choosed_id].exchangeType[index]
                
                for i in 0 ..< settings_data.count {
                    if exchangeType == settings_data[i][14] {
                        cell.slider.minimumValue = CGFloat(Double(settings_data[i][0])!)
                        cell.slider.maximumValue = CGFloat(Double(settings_data[i][1])!)
                        cell.slider.value = [CGFloat(Double(settings_data[i][0])!)]
                        cell.count_transfer.text = String(Int((cell.slider.value[0])))
                        cell.count_to_transfer.text = String(Int(cell.slider.value[0]) * Int(Double(settings_data[i][12])!))
                        
                        cell.titleRed.isHidden = true
                        cell.count_transfer.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
                        cell.sendButton.isEnabled = true
                        cell.sendButton.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
                        break
                    }
                }
            }
            
            let cost: NSString = defaultLocalizer.stringForKey(key: "Commission") as NSString
            let range = (cost).range(of: cost as String)
            let costString = NSMutableAttributedString.init(string: cost as String)
            costString.addAttribute(NSAttributedString.Key.foregroundColor, value: colorBlackWhite , range: range)
            costString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)], range: range)
            
            var title_cost = value as NSString
            
            let titleString = NSMutableAttributedString.init(string: title_cost as String)
            let range2 = (title_cost).range(of: title_cost as String)
            titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange , range: range2)
            titleString.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)], range: range2)
            costString.append(titleString)
            cell.title_commission.attributedText = costString
            
            cell.slider.addTarget(self, action: #selector(self.sliderChanged), for: .valueChanged)
            
            let bgColorView = UIView()
            bgColorView.backgroundColor = .clear
            cell.selectedBackgroundView = bgColorView
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "history_transfer", for: indexPath) as! TraficHistoryViewCell
         
            cell.titleOne.text = HistoryData[indexPath.section].volumeA[indexPath.row] + " " + HistoryData[indexPath.section].unitA[indexPath.row] + " " + defaultLocalizer.stringForKey(key: "on_the") + " " + HistoryData[indexPath.section].volumeB[indexPath.row] + " " + HistoryData[indexPath.section].unitB[indexPath.row]
            
            cell.titleThree.text = String(format: "%g", Double(String(format: "%.2f", Double(HistoryData[indexPath.section].price[indexPath.row])!))!) + " " + defaultLocalizer.stringForKey(key: "tjs")
            
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
            let date = dateFormatter1.date(from: String(HistoryData[indexPath.section].date[indexPath.row]))
            dateFormatter1.dateFormat = "HH:mm"
            
            cell.titleFour.text = dateFormatter1.string(from: date!)
            
            cell.titleOne.frame = CGRect(x: 80, y: 10, width: Int(UIScreen.main.bounds.size.width) - (cell.titleFour.text!.count * 10) - 130, height: 50)
            
            cell.titleTwo.frame = CGRect(x: 80, y: 60, width: Int(UIScreen.main.bounds.size.width) - (cell.titleFour.text!.count * 10) - 120, height: 60)
            
            cell.titleThree.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (cell.titleThree.text!.count * 15) - 30, y: 10, width: (cell.titleThree.text!.count * 15), height: 50)
            
            cell.titleFour.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (cell.titleFour.text!.count * 10) - 30, y: 60, width: (cell.titleFour.text!.count * 10), height: 60)
            
            if HistoryData[indexPath.section].statusId[indexPath.row] != "45" {
                cell.titleTwo.textColor = .red
                cell.titleTwo.text = "✖︎ " + HistoryData[indexPath.section].status[indexPath.row]
                cell.ico_image.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "Transer_Traffic_Default_dark") : UIImage(named: "Transer_Traffic_Default"))
            }
            else {
                cell.titleTwo.textColor = UIColor(red: 0.153, green: 0.682, blue: 0.376, alpha: 1)
                cell.titleTwo.text = "✓ " + HistoryData[indexPath.section].status[indexPath.row]
                cell.ico_image.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "Tranfer_Traffic_Active_1_dark") : UIImage(named: "Tranfer_Traffic_Active_1"))
            }
            
            cell.titleTwo.frame.size.height = CGFloat.greatestFiniteMagnitude
            cell.titleTwo.numberOfLines = 0
            cell.titleTwo.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.titleTwo.sizeToFit()
          
            cell.titleTwo.frame.origin.y = 60
            
            cell.contentView.frame.size = CGSize(width: view.frame.width, height: cell.titleTwo.frame.height + 70)
            
            cell.titleFour.frame.size.height =  cell.titleTwo.frame.size.height
            
            cell.frame.size.height = cell.titleTwo.frame.height + 70
            table2.rowHeight = cell.titleTwo.frame.height + 70
            
           /* if HistoryData[indexPath.section].exchangeType[indexPath.row] == "1" {
                cell.ico_image.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "sms_transfer_w") : UIImage(named: "sms_transfer"))
             }
             else if HistoryData[indexPath.section].exchangeType[indexPath.row] == "2" {
                 cell.ico_image.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "min_transfer_w") : UIImage(named: "min_transfer"))
             }
             else if HistoryData[indexPath.section].exchangeType[indexPath.row] == "3" {
                 cell.ico_image.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "internet_transfer_w") : UIImage(named: "internet_transfer"))
             }*/
            
            let bgColorView = UIView()
            bgColorView.backgroundColor = .clear
            cell.selectedBackgroundView = bgColorView
            
            return cell
        }
    }
    
    @objc func sliderChanged(_ slider: MultiSlider) {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = table.cellForRow(at: indexPath) as! ChangeTransferTableViewCell
        
        cell.sendButton.isEnabled = true
        cell.sendButton.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
        cell.titleRed.isHidden = true
        cell.count_transfer.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        
        var index = 0
        
        for i in 0 ..< settings_data.count {
            if Int(exchangeType) == i {
                index = i
                break
            }
        }
        
        cell.count_transfer.text = String(Int(slider.value[0]))
        cell.count_to_transfer.text = String(format: "%g", Double(String(format: "%.2f", Double(slider.value[0]) * Double(settings_data[trasfer_type_choosed_id][12])!))!)
        
        countTransfer = String(Int(slider.value[0]))
        
        if Double(slider.value[0]) >= Double(settings_data[trasfer_type_choosed_id][0])! && Double(slider.value[0]) <= Double(settings_data[trasfer_type_choosed_id][2])! {
            
            if Double(settings_data[index][11])! > 0
            {
                let discountPrice = (Double(settings_data[trasfer_type_choosed_id][4])! * Double(settings_data[index][11])!) / 100
                
                let finallCost = (Double(settings_data[trasfer_type_choosed_id][4])! - discountPrice)
            
                value = String(format: "%g", Double(String(format: "%.2f", finallCost))!) + " " + defaultLocalizer.stringForKey(key: "tjs")
            }
            else
            {
                value = String(format: "%g", Double(String(format: "%.2f", Double(settings_data[trasfer_type_choosed_id][3])!))!) + " " + defaultLocalizer.stringForKey(key: "tjs")
            }

        }
        else if Double(slider.value[0]) > Double(settings_data[trasfer_type_choosed_id][2])! && Double(slider.value[0]) <= Double(settings_data[trasfer_type_choosed_id][1])! {

            if Double(settings_data[trasfer_type_choosed_id][11])! > 0
            {
                let firstPrice = Double(slider.value[0]) * Double(settings_data[trasfer_type_choosed_id][4])! * Double(settings_data[trasfer_type_choosed_id][5])!
                let discountPrice = (firstPrice * Double(settings_data[trasfer_type_choosed_id][11])!) / 100
                let finallCost = (firstPrice - discountPrice)
                
                value = String(format: "%g", Double(String(format: "%.2f", finallCost))!) + " "  + defaultLocalizer.stringForKey(key: "tjs")
               
            }
            else
            {
                value = String(format: "%g", Double(String(format: "%.2f", Double(slider.value[0]) * Double(settings_data[trasfer_type_choosed_id][4])! * Double(settings_data[trasfer_type_choosed_id][5])!))!) + " "  + defaultLocalizer.stringForKey(key: "tjs")
            }
        }
        
        let cost: NSString = defaultLocalizer.stringForKey(key: "Commission") as NSString
        let range = (cost).range(of: cost as String)
        let costString = NSMutableAttributedString.init(string: cost as String)
        costString.addAttribute(NSAttributedString.Key.foregroundColor, value: colorBlackWhite , range: range)
        costString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)], range: range)
        
        var title_cost = value as NSString
        
        let titleString = NSMutableAttributedString.init(string: title_cost as String)
        let range2 = (title_cost).range(of: title_cost as String)
        titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange , range: range2)
        titleString.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)], range: range2)
        costString.append(titleString)
        cell.title_commission.attributedText = costString
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = table.cellForRow(at: indexPath) as! ChangeTransferTableViewCell
        
        cell.sendButton.isEnabled = true
        cell.sendButton.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
        cell.titleRed.isHidden = true
        cell.count_transfer.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        
        if textField == cell.count_to_transfer {
            print("hello san francisco")
            cell.count_to_transfer.resignFirstResponder()
        }
        
        if units_data.count == 0 {
            cell.count_transfer.resignFirstResponder()
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = table.cellForRow(at: indexPath) as! ChangeTransferTableViewCell
        
        cell.sendButton.isEnabled = true
        cell.sendButton.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
        cell.titleRed.isHidden = true
        cell.count_transfer.text = String(Int(cell.count_transfer.text ?? "1") ?? 1)
        cell.count_transfer.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = table.cellForRow(at: indexPath) as! ChangeTransferTableViewCell
        
        cell.sendButton.isEnabled = true
        cell.sendButton.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
        cell.titleRed.isHidden = true
        cell.count_transfer.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
         
         return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var return_status = true
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = table.cellForRow(at: indexPath) as! ChangeTransferTableViewCell
        var amount = ""
        var index = 0
        
        for i in 0 ..< settings_data.count {
            if Int(exchangeType) == i {
                index = i
                break
            }
        }
        
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
        
        print("cursorPosition")
        print(cursorPosition)
        
        if string  == "" {
            var i = amount.index(amount.startIndex, offsetBy: cursorPosition - 1)
            amount.remove(at: i)
            amount = String(Int(amount ?? "1") ?? 1)
        }
        
        if amount != "" {
            print(amount)
            if Double(amount)! < Double(settings_data[trasfer_type_choosed_id][0])! {
                cell.titleRed.text = defaultLocalizer.stringForKey(key: "minimum_limit:") + " " + settings_data[trasfer_type_choosed_id][0]
                cell.titleRed.isHidden = false
                cell.count_transfer.layer.borderColor = UIColor.red.cgColor
                cell.sendButton.isEnabled = false
                cell.sendButton.backgroundColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
                return_status = true
            }
            else if string != "" && Double(amount)! > Double(settings_data[trasfer_type_choosed_id][1])!  {
                cell.titleRed.text = defaultLocalizer.stringForKey(key: "maximum_limit:") + " " + String(Int(settings_data[trasfer_type_choosed_id][1])!)
                cell.titleRed.isHidden = false
                cell.count_transfer.layer.borderColor = UIColor.red.cgColor
                cell.sendButton.isEnabled = false
                cell.sendButton.backgroundColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
               return_status = false
            }
            else {
                cell.titleRed.isHidden = true
                cell.count_transfer.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
                cell.sendButton.isEnabled = true
                cell.sendButton.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
                return_status = true
            }
        }
        
        if amount != "" {
            cell.slider.value[0] = CGFloat(Double(amount)!)
            cell.count_to_transfer.text = String(format: "%g", Double(String(format: "%.2f", Double(cell.slider.value[0]) * Double(settings_data[trasfer_type_choosed_id][12])!))!)
            
            if Double(amount)! >= Double(settings_data[trasfer_type_choosed_id][0])! && Double(amount)! <= Double(settings_data[trasfer_type_choosed_id][2])! {
                
                if Double(settings_data[trasfer_type_choosed_id][11])! > 0
                {
                    let discountPrice = (Double(settings_data[trasfer_type_choosed_id][4])! * Double(settings_data[trasfer_type_choosed_id][11])!) / 100
                    
                    let finallCost = (Double(settings_data[trasfer_type_choosed_id][4])! - discountPrice)
                
                    value = String(format: "%g", Double(String(format: "%.2f", finallCost))!) + " " + defaultLocalizer.stringForKey(key: "tjs")
                }
                else
                {
                    value = String(format: "%g", Double(String(format: "%.2f", Double(settings_data[index][3])!))!) + " " + defaultLocalizer.stringForKey(key: "tjs")
                }

            }
            else if Double(amount)! > Double(settings_data[trasfer_type_choosed_id][2])! && Double(amount)! <= Double(settings_data[trasfer_type_choosed_id][1])! {

                if Double(settings_data[trasfer_type_choosed_id][11])! > 0
                {
                    let firstPrice = Double(cell.slider.value[0]) * Double(settings_data[trasfer_type_choosed_id][4])! * Double(settings_data[trasfer_type_choosed_id][5])!
                    let discountPrice = (firstPrice * Double(settings_data[trasfer_type_choosed_id][11])!) / 100
                    let finallCost = (firstPrice - discountPrice)
                    
                    value = String(format: "%g", Double(String(format: "%.2f", finallCost))!) + " " + defaultLocalizer.stringForKey(key: "tjs")
                   
                }
                else
                {
                    value = String(format: "%g", Double(String(format: "%.2f", Double(amount)! * Double(settings_data[trasfer_type_choosed_id][4])! * Double(settings_data[trasfer_type_choosed_id][5])!))!) + " " + defaultLocalizer.stringForKey(key: "tjs")
                }
            }
            
            let cost: NSString = defaultLocalizer.stringForKey(key: "Commission") as NSString
            let range = (cost).range(of: cost as String)
            let costString = NSMutableAttributedString.init(string: cost as String)
            costString.addAttribute(NSAttributedString.Key.foregroundColor, value: colorBlackWhite , range: range)
            costString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)], range: range)
            
            var title_cost = value as NSString
            
            let titleString = NSMutableAttributedString.init(string: title_cost as String)
            let range2 = (title_cost).range(of: title_cost as String)
            titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange , range: range2)
            titleString.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)], range: range2)
            costString.append(titleString)
            cell.title_commission.attributedText = costString
        }
        
        
        return return_status
    }
}
