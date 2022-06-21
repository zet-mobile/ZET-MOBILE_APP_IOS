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
    let type: [String]
    let transferType: [String]
    let statusId: [String]
    let transactionId: [String]
}

struct unitsData {
    let unitName: String
    let unitB_unitName: [String]
    let exchangeType: [String]
}

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
    let table2 = UITableView()
    
    var x_pozition = 20
    var y_pozition = 390
    
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
    
    var HistoryData = [exchangeData(date_header: String(), phoneNumber: [String](), status: [String](), date: [String](), id: [String](), volumeA: [String](), volumeB: [String](), unitA: [String](), unitB: [String](), price: [String](), type: [String](), transferType: [String](), statusId: [String](), transactionId: [String]())]
    
    var balance = ""
    var trasfer_type_choosed = ""
    var trasfer_type_choosed_id = 0
    
    var to_trasfer_type_choosed = ""
    var to_trasfer_type_choosed_id = 0
    
    var exchangeType = "0"
    var value = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
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
        
        toolbar = TarifToolbarView(frame: CGRect(x: 0, y: 44, width: UIScreen.main.bounds.size.width, height: 60))
        changeView = ChangeTransferView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 896))
        
        self.view.addSubview(toolbar)
        scrollView.addSubview(changeView)
        
        toolbar.icon_back.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        toolbar.number_user_name.text = defaultLocalizer.stringForKey(key: "Traffic_exchange")
        
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
        
        changeView.tab1.frame = CGRect(x: 0, y: y_pozition, width: Int(UIScreen.main.bounds.size.width) / 2, height: 40)
        changeView.tab2.frame = CGRect(x: UIScreen.main.bounds.size.width / 2, y: CGFloat(y_pozition), width: UIScreen.main.bounds.size.width / 2, height: 40)
        
        changeView.tab1Line.frame = CGRect(x: 10, y: y_pozition + 40, width: (Int(UIScreen.main.bounds.size.width) / 2) - 20, height: 3)
        changeView.tab2Line.frame = CGRect(x: (UIScreen.main.bounds.size.width / 2) + 10, y: CGFloat(y_pozition + 40), width: (UIScreen.main.bounds.size.width / 2) - 20, height: 3)
        
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
        if self.scrollView == scrollView {
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
                self.scrollView.contentOffset.y = 104
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
        changeView.tab1Line.backgroundColor = .orange
        changeView.tab2Line.backgroundColor = .clear
        TabCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionView.ScrollPosition.right, animated: true)
    }
    
    @objc func tab2Click() {
        changeView.tab1.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        changeView.tab2.textColor = colorBlackWhite
        changeView.tab1Line.backgroundColor = .clear
        changeView.tab2Line.backgroundColor = .orange
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
                        
                        self.balance = String(result.subscriberBalance) + " с."
                        
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
                    self.requestAnswer(status: false, message: error.localizedDescription)
                },
                onCompleted: {
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
                        
                        if result.history?.count != 0 {
                            
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
                                var tableData10 = [String]()
                                var tableData11 = [String]()
                                var tableData12 = [String]()
                               
                                for j in 0 ..< result.history![i].histories.count {
                                    
                                    tableData.append(String(result.history![i].histories[j].phoneNumber))
                                    tableData1.append(String(result.history![i].histories[j].status))
                                    tableData2.append(String(result.history![i].histories[j].date))
                                    tableData3.append(String(result.history![i].histories[j].id))
                                    tableData4.append(String(result.history![i].histories[j].volumeA))
                                    tableData5.append(String(result.history![i].histories[j].volumeB))
                                    tableData6.append(String(result.history![i].histories[j].unitA))
                                    tableData7.append(String(result.history![i].histories[j].unitB))
                                    tableData8.append(String(result.history![i].histories[j].price))
                                    tableData9.append(String(result.history![i].histories[j].exchangeType))
                                    tableData10.append(String(result.history![i].histories[j].exchangeType))
                                    tableData11.append(String(result.history![i].histories[j].statusId))
                                    tableData12.append(String(result.history![i].histories[j].transactionId))
                                }
                                
                                HistoryData.append(exchangeData(date_header: String(result.history![i].date), phoneNumber: tableData, status: tableData1, date: tableData2, id: tableData3, volumeA: tableData4,volumeB: tableData5, unitA: tableData6, unitB: tableData7, price: tableData8, type: tableData9, transferType: tableData10, statusId: tableData11, transactionId: tableData12))
                            }
                            
                        }
                        else {
                            print("empty history")
                            DispatchQueue.main.async {
                            emptyView = EmptyView(frame: CGRect(x: 0, y: 30, width: self.table2.frame.width, height: self.table2.frame.height), text: """
                                Вы еще не воспользовались услугой "Обмен трафика"
                                """)
                            self.table2.separatorStyle = .none
                            self.table2.backgroundView = emptyView
                            }
                        }
                        
                    }
                },
                onError: { error in
                   print(error.localizedDescription)
                    self.requestAnswer(status: false, message: error.localizedDescription)
                },
                onCompleted: {
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
           view.image_icon.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "sms_transfer_w") : UIImage(named: "sms_transfer"))
           view.image_icon2.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "min_transfer_w") : UIImage(named: "min_transfer"))
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
            title_cost = " \(String(cell.count_transfer.text ?? "")) мин" as NSString
        }
        else if exchangeType == "3" {
            title_cost = " \(String(cell.count_transfer.text ?? "")) мб" as NSString
        }
        let titleString = NSMutableAttributedString.init(string: title_cost as String)
        let range2 = (title_cost).range(of: title_cost as String)
        titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange , range: range2)
        titleString.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], range: range2)
        costString.append(titleString)
        view.value_title.attributedText = costString
        
        
        let cost2: NSString = "на" as NSString
        let range2_1 = (cost2).range(of: cost2 as String)
        let costString2 = NSMutableAttributedString.init(string: cost2 as String)
        costString2.addAttribute(NSAttributedString.Key.foregroundColor, value: colorBlackWhite , range: range2_1)
        costString2.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], range: range2_1)
        
        var title_cost2 = " \(String(cell.count_to_transfer.text ?? "")) " as NSString
        if exchangeType == "1" {
            title_cost2 = " \(String(cell.count_to_transfer.text ?? "")) мб" as NSString
        }
        else if exchangeType == "2" {
            title_cost2 = " \(String(cell.count_to_transfer.text ?? "")) мб" as NSString
        }
        else if exchangeType == "3" {
            title_cost2 = " \(String(cell.count_to_transfer.text ?? "")) мин" as NSString
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
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissDialog))
        view.name.isUserInteractionEnabled = true
        view.name.addGestureRecognizer(tapGestureRecognizer)
        
        view.cancel.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
        view.ok.addTarget(self, action: #selector(okClickDialog(_:)), for: .allTouchEvents)
        alert.view.backgroundColor = .clear
        alert.view.addSubview(view)
        
        cell.sendButton.showAnimation {
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
        hideActivityIndicator(uiView: view)
    }
    
    @objc func okClickDialog(_ sender: UIButton) {
        
        sender.showAnimation {
            self.alert.dismiss(animated: true, completion: nil)
        }
        showActivityIndicator(uiView: view)
        
        print(sender.tag)
        let parametr: [String: Any] = ["exchangeType": "", "value": ""]
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
    
    @objc func openCondition() {
        print(trasfer_type_choosed_id)
        print(settings_data[trasfer_type_choosed_id][11])
        
        detailViewController.more_view.content.text = settings_data[trasfer_type_choosed_id][15]
        detailViewController.more_view.image.image = UIImage(named: "transfer")
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
}

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
            table.frame = CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width - 20, height: UIScreen.main.bounds.size.height - 150)
            table.delegate = self
            table.dataSource = self
            table.rowHeight = 750
            table.estimatedRowHeight = 750
            table.alwaysBounceVertical = false
            table.separatorStyle = .none
            table.showsVerticalScrollIndicator = false
            table.backgroundColor = contentColor
            table.allowsSelection = false
            cell.addSubview(table)
        }
        else {
            table2.register(TraficHistoryViewCell.self, forCellReuseIdentifier: "history_transfer")
            table2.register(HistoryHeaderCell.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")
            table2.frame = CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width - 20, height: UIScreen.main.bounds.size.height - 150)
            table2.delegate = self
            table2.dataSource = self
            table2.rowHeight = 90
            table2.estimatedRowHeight = 90
            table2.alwaysBounceVertical = false
            table2.separatorStyle = .none
            table2.showsVerticalScrollIndicator = false
            table2.backgroundColor = contentColor
            
            if HistoryData.count == 1 {
                emptyView = EmptyView(frame: CGRect(x: 0, y: 30, width: table2.frame.width, height: table2.frame.height), text: """
                Вы еще не воспользовались услугой "Обмен трафика"
                """)
                table2.separatorStyle = .none
                table2.backgroundView = emptyView
            }
            
            cell.addSubview(table2)
            
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
 
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == TabCollectionView {
            if indexPath.row == 0 {
                changeView.tab1.textColor = colorBlackWhite
                changeView.tab2.textColor = .gray
                changeView.tab1Line.backgroundColor = .orange
                changeView.tab2Line.backgroundColor = .clear
                
            } else {
                changeView.tab1.textColor = .gray
                changeView.tab2.textColor = colorBlackWhite
                changeView.tab1Line.backgroundColor = .clear
                changeView.tab2Line.backgroundColor = .orange
          }
       }
    }
}

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
            
            trasfer_type_choosed = units_data[0].unitName
            to_trasfer_type_choosed = units_data[0].unitB_unitName[0]
            exchangeType = units_data[0].exchangeType[0]
            trasfer_type_choosed_id = 0
            value = "1 " +  defaultLocalizer.stringForKey(key: "somoni")
            
            cell.slider.value = [CGFloat(Double(settings_data[0][0])!)]
            cell.slider.minimumValue = CGFloat(Double(settings_data[0][0])!)
            cell.slider.maximumValue = CGFloat(Double(settings_data[0][1])!)
            cell.user_to_number.text = trasfer_type_choosed
            cell.type_transfer.text = to_trasfer_type_choosed
            cell.count_transfer.text = String(Int(Double(settings_data[0][0])!))
            cell.count_to_transfer.text = String(Int(Double(cell.slider.value[0]) * Double(settings_data[0][12])!))
            
            
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
                
                for i in 0 ..< settings_data.count {
                    if exchangeType == settings_data[i][14] {
                        cell.slider.minimumValue = CGFloat(Double(settings_data[i][0])!)
                        cell.slider.maximumValue = CGFloat(Double(settings_data[i][1])!)
                        cell.slider.value = [CGFloat(Double(settings_data[i][0])!)]
                        cell.count_transfer.text = String(Int((cell.slider.value[0])))
                        cell.count_to_transfer.text = String(Int(cell.slider.value[0]) * Int(Double(settings_data[i][12])!))
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
                        break
                    }
                }
            }
            
            let cost: NSString = defaultLocalizer.stringForKey(key: "Commission") as NSString
            let range = (cost).range(of: cost as String)
            let costString = NSMutableAttributedString.init(string: cost as String)
            costString.addAttribute(NSAttributedString.Key.foregroundColor, value: colorBlackWhite , range: range)
            costString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)], range: range)
            
            var title_cost = "1" + " " +  defaultLocalizer.stringForKey(key: "somoni") as NSString
            
            let titleString = NSMutableAttributedString.init(string: title_cost as String)
            let range2 = (title_cost).range(of: title_cost as String)
            titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange , range: range2)
            titleString.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)], range: range2)
            costString.append(titleString)
            cell.title_commission.attributedText = costString
            
        
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openCondition))
            cell.icon_more.isUserInteractionEnabled = true
            cell.icon_more.addGestureRecognizer(tapGestureRecognizer)
            
            cell.slider.addTarget(self, action: #selector(self.sliderChanged), for: .valueChanged)
            cell.sendButton.addTarget(self, action:  #selector(self.translateTrafic), for: .touchUpInside)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "history_transfer", for: indexPath) as! TraficHistoryViewCell
         
            cell.titleOne.text = HistoryData[indexPath.section].unitA[indexPath.row] + " в " + HistoryData[indexPath.section].unitB[indexPath.row]
            cell.titleTwo.text = "" + HistoryData[indexPath.section].status[indexPath.row]
            cell.titleThree.text = HistoryData[indexPath.section].price[indexPath.row]
            
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
            let date = dateFormatter1.date(from: String(HistoryData[indexPath.section].date[indexPath.row]))
            dateFormatter1.dateFormat = "HH:mm"
            
            cell.titleFour.text = dateFormatter1.string(from: date!)
            
            print(Int(UIScreen.main.bounds.size.width))
            print((cell.titleFour.text!.count * 15) - 30)
            
            cell.titleTwo.frame = CGRect(x: 80, y: 40, width: Int(UIScreen.main.bounds.size.width) - (cell.titleFour.text!.count * 10) - 110, height: 50)
            
            print(cell.titleTwo.frame.size.width)
            cell.titleThree.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (cell.titleThree.text!.count * 15) - 30, y: 10, width: (cell.titleThree.text!.count * 15), height: 30)
            
            cell.titleFour.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (cell.titleFour.text!.count * 10) - 30, y: 40, width: (cell.titleFour.text!.count * 10), height: 50)
            return cell
        }
    }
    
    @objc func sliderChanged(_ slider: MultiSlider) {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = table.cellForRow(at: indexPath) as! ChangeTransferTableViewCell
        var index = 0
        
        for i in 0 ..< settings_data.count {
            if Int(exchangeType) == i {
                index = i
                break
            }
        }
        
        cell.count_transfer.text = String(Int(slider.value[0]))
        cell.count_to_transfer.text = String(Int(slider.value[0]) * Int(Double(settings_data[index][12])!))
        
        
        if Double(slider.value[0]) >= Double(settings_data[index][0])! && Double(slider.value[0]) <= Double(settings_data[index][2])! {
            
            if Double(settings_data[index][11])! > 0
            {
                var discountPrice = (Double(settings_data[index][4])! * Double(settings_data[index][11])!) / 100
                
                var finallCost = (Double(settings_data[index][4])! - discountPrice)
            
                value = String(format: "%.2f", finallCost) + " " +  defaultLocalizer.stringForKey(key: "somoni")
            }
            else
            {
                value = settings_data[index][3] + " "  + defaultLocalizer.stringForKey(key: "somoni")
            }

        }
        else if Double(slider.value[0]) > Double(settings_data[index][2])! && Double(slider.value[0]) <= Double(settings_data[index][1])! {

            if Double(settings_data[index][11])! > 0
            {
                var firstPrice = Double(slider.value[0]) * Double(settings_data[index][4])! * Double(settings_data[index][5])!
                var discountPrice = (firstPrice * Double(settings_data[index][11])!) / 100
                var finallCost = (firstPrice - discountPrice)
                
                value = String(format: "%.2f", finallCost) + " " +  defaultLocalizer.stringForKey(key: "somoni")
            }
            else
            {
                value = String(format: "%.2f", Double(slider.value[0]) * Double(settings_data[index][4])! * Double(settings_data[index][5])!) + " " +  defaultLocalizer.stringForKey(key: "somoni")
               
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
    
}
