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
    var value_transfer = "0"
    var inPhoneNumber = ""
    
    var HistoryData = [historyData(date_header: String(), phoneNumber: [String](), status: [String](), date: [String](), id: [String](), volume: [String](), price: [String](), type: [String](), transferType: [String](), statusId: [String](), transactionId: [String]())]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        to_phone = ""
        showActivityIndicator(uiView: self.view)
        view.backgroundColor = toolbarColor
        print("yyyyyyy")
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
            table.reloadData()
        }
        print("jjjjj")
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? .lightContent : .darkContent)
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
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 950)
        view.addSubview(scrollView)
        
        toolbar = TarifToolbarView(frame: CGRect(x: 0, y: topPadding ?? 0, width: UIScreen.main.bounds.size.width, height: 60))
        traficView = TraficTransferView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 896))
        
        self.view.addSubview(toolbar)
        scrollView.addSubview(traficView)
        
        toolbar.icon_back.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goBack))
        toolbar.isUserInteractionEnabled = true
        toolbar.addGestureRecognizer(tapGestureRecognizer)
        
        toolbar.number_user_name.text = defaultLocalizer.stringForKey(key: "Traffic_transfer")
        
        self.traficView.balance.text = balance
        
        if balances_data.count != 0 {
            traficView.rez1.text = balances_data[0][0]
            traficView.rez2.text = balances_data[0][1]
            traficView.rez3.text = balances_data[0][2]
            traficView.rez4.text = balances_data[0][3]
        }
        
        traficView.rez1.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (traficView.rez1.text!.count * 15) - 50, y: 0, width: (traficView.rez1.text!.count * 15), height: 45)
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
        if self.scrollView == scrollView {
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
                self.scrollView.contentOffset.y = 104
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
                        
                        self.balance = String(result.subscriberBalance) + " с."
                        
                        if result.settings.count != 0 {
                            for i in 0 ..< result.settings.count {
                                self.settings_data.append([String(result.settings[i].minValue), String(result.settings[i].maxValue), String(result.settings[i].midValue), String(result.settings[i].midPrice), String(result.settings[i].price), String(result.settings[i].quantityLimit), String(result.settings[i].volumeLimit), String(result.settings[i].conversationRate), String(result.settings[i].discountPercent), String(result.settings[i].transferType), String(result.settings[i].transferTypeId), String(result.settings[i].description)])
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
                                HistoryData.append(historyData(date_header: String(result.history![i].date), phoneNumber: tableData, status: tableData1, date: tableData2, id: tableData3, volume: tableData4, price: tableData5, type: tableData6, transferType: tableData7, statusId: tableData8, transactionId: tableData9))
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                            emptyView = EmptyView(frame: CGRect(x: 0, y: 30, width: self.table2.frame.width, height: self.table.frame.height), text: """
                                Вы еще не воспользовались услугой "Трафик трансфер"
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
                        setupView()
                        setupTabCollectionView()
                        hideActivityIndicator(uiView: self.view)
                        print(HistoryData.count)
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
        cell.user_to_number.resignFirstResponder()
        
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
            view.image_icon.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "sms_transfer_w") : UIImage(named: "sms_transfer"))
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
        
        let title_cost2 = " +992 \(to_phone) " as NSString
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
        
        var title_cost3 = " \(value_transfer) " as NSString
            
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
        view.ok.addTarget(self, action: #selector(okClickDialog(_:)), for: .touchUpInside)
        alert.view.backgroundColor = .clear
        alert.view.addSubview(view)
        
        if to_phone != "" {
            if to_phone == UserDefaults.standard.string(forKey: "mobPhone") {
                cell.titleRed.isHidden = false
                cell.user_to_number.layer.borderColor = UIColor.red.cgColor
            }
            else {
                cell.titleRed.isHidden = true
                cell.user_to_number.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
                cell.sendButton.showAnimation {
                    self.present(self.alert, animated: true, completion: nil)
                }
            }
            
        }
        else if to_phone == ""  {
            cell.titleRed.isHidden = false
            cell.user_to_number.layer.borderColor = UIColor.red.cgColor
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
            view.name.text = defaultLocalizer.stringForKey(key: "Your message successfully was sent")
            view.image_icon.image = UIImage(named: "correct_alert")
        }
        else {
            view.name.text = defaultLocalizer.stringForKey(key: "Something went wrong")
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
    
    @objc func dismissDialog() {
        print("hello")
        alert.dismiss(animated: true, completion: nil)
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
        
        cell.sendButton.isEnabled = true
        cell.sendButton.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
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
            table.frame = CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width - 20, height: UIScreen.main.bounds.size.height - 150)
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
            table2.frame = CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width - 20, height: UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 120 + (topPadding ?? 0) + (bottomPadding ?? 0)))
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
                Вы еще не воспользовались услугой "Трафик трансфер"
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
        dateFormatter1.dateFormat = "dd MMMM"
        dateFormatter1.locale = Locale(identifier: "ru_RU")
        
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
            DispatchQueue.main.async { [self] in
                let contacts = cell.user_to_number.setView(.right, image: UIImage(named: "user_field_icon"))
                contacts.addTarget(self, action: #selector(openContacts), for: .touchUpInside)
            }
            
            if to_phone != "" {
                cell.user_to_number.text = "+992 " + to_phone
            }
            else {
                cell.user_to_number.text = "+992 "
            }
            
            trasfer_type_choosed = settings_data[0][9]
            trasfer_type_choosed_id = Int(settings_data[0][10])!
            cell.slider.value = [CGFloat(Double(settings_data[0][0])!)]
            cell.slider.minimumValue = CGFloat(Double(settings_data[0][0])!)
            cell.slider.maximumValue = CGFloat(Double(settings_data[0][1])!)
            cell.count_transfer.text = String(Int((cell.slider.value[0])))
            
            cell.type_transfer.text = trasfer_type_choosed
            
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
            
            var title_cost = "1 c." as NSString
            
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
            
            let bgColorView = UIView()
            bgColorView.backgroundColor = .clear
            cell.selectedBackgroundView = bgColorView
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "history_transfer", for: indexPath) as! TraficHistoryViewCell
         
            cell.titleOne.text = HistoryData[indexPath.section].phoneNumber[indexPath.row]
            cell.titleTwo.text = "" + HistoryData[indexPath.section].status[indexPath.row]
            cell.titleThree.text = HistoryData[indexPath.section].price[indexPath.row]
            
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
            let date = dateFormatter1.date(from: String(HistoryData[indexPath.section].date[indexPath.row]))
            dateFormatter1.dateFormat = "HH:mm"
            
            cell.titleFour.text = dateFormatter1.string(from: date!)
            
            cell.titleTwo.frame = CGRect(x: 80, y: 40, width: Int(UIScreen.main.bounds.size.width) - (cell.titleFour.text!.count * 10) - 110, height: 50)
            
            print(cell.titleTwo.frame.size.width)
            cell.titleThree.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (cell.titleThree.text!.count * 15) - 30, y: 10, width: (cell.titleThree.text!.count * 15), height: 30)
            
            cell.titleFour.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (cell.titleFour.text!.count * 10) - 30, y: 40, width: (cell.titleFour.text!.count * 10), height: 50)
            
            let bgColorView = UIView()
            bgColorView.backgroundColor = .clear
            cell.selectedBackgroundView = bgColorView
            
            return cell
        }
       
    }
    
    @objc func sliderChanged(_ slider: MultiSlider) {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = table.cellForRow(at: indexPath) as! TraficTableViewCell
        cell.count_transfer.text = String(Int(slider.value[0]))
        
        var index = 0
        
        for i in 0 ..< settings_data.count {
            if Int(trasfer_type_choosed_id) == i {
                index = i
                break
            }
        }
        
        if Double(slider.value[0]) >= Double(settings_data[index][0])! && Double(slider.value[0])  <= Double(settings_data[index][2])! {

            if Double(settings_data[index][8])! > 0 {
                let discountPrice = (Double(settings_data[index][3])! * Double(settings_data[index][8])!) / 100
                let finallCost = (Double(settings_data[index][3])! - discountPrice)
                
                value_transfer = String(format: "%g", Double(String(format: "%.2f", finallCost))!) + " c."
            }
            else {
                value_transfer = String(format: "%g", Double(String(format: "%.2f", Double(settings_data[index][3])!))!) + " c."
            }

        }
        else if Double(slider.value[0]) > Double(settings_data[index][2])! && Double(slider.value[0]) <= Double(settings_data[index][1])! {

            if Double(settings_data[index][8])! > 0{
                let firstPrice = Double(slider.value[0]) * Double(settings_data[index][4])!
                let discountPrice = (firstPrice * Double(settings_data[index][8])!) / 100
                let finallCost = firstPrice - discountPrice
                value_transfer = String(format: "%g", Double(String(format: "%.2f", finallCost))!) + " c."
            }
            else {
                value_transfer = String(format: "%g", Double(String(format: "%.2f", Double(slider.value[0]) * Double(settings_data[index][4])!))!) + " c."
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
      
        if textField.tag == 1 {
            cell.user_to_number.text! = "+992 "
            cell.user_to_number.textColor = colorBlackWhite
            cell.user_to_number.font = UIFont.systemFont(ofSize: 15)
            cell.titleRed.isHidden = true
            cell.titleRed2.isHidden = true
            cell.user_to_number.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        }
        else if textField.tag == 2 {
            cell.count_transfer.text! = ""
            cell.count_transfer.textColor = colorBlackWhite
            cell.count_transfer.font = UIFont.systemFont(ofSize: 15)
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        let indexPath = IndexPath(item: 0, section: 0);
        let cell = table.cellForRow(at: indexPath) as! TraficTableViewCell
        if textField.tag == 1 {
            cell.user_to_number.text! = "+992 " + to_phone
            cell.user_to_number.textColor = colorBlackWhite
            cell.user_to_number.font = UIFont.systemFont(ofSize: 15)
        }
        else if textField.tag == 2 {
           // auth_view.code_field.text! = user_code
            //auth_view.code_field.textColor = .black
            //auth_view.code_field.font = UIFont.systemFont(ofSize: 15)
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var return_status = true
        let indexPath = IndexPath(item: 0, section: 0);
        let cell = table.cellForRow(at: indexPath) as! TraficTableViewCell
        var amount = cell.count_transfer.text! + string
        
        let tag = textField.tag
        
        if string  == "" {
            if tag == 1 && cell.user_to_number.text != "+992 " {
                to_phone = (to_phone as String).substring(to: to_phone.index(before: to_phone.endIndex))
            }
            else if tag == 1 && cell.user_to_number.text == "+992 " {
                return false
            }
            else {
                amount = (amount as String).substring(to: amount.index(before: amount.endIndex))
            }
        }
        
        if tag == 1 && string != "" && cell.user_to_number.text!.count == 14 {
            return false
        }
        else if tag == 1 {
            to_phone = to_phone + string
            print(to_phone)
        }
        
        var index = 0
        
        for i in 0 ..< settings_data.count {
            if Int(trasfer_type_choosed_id) == i {
                index = i
                break
            }
        }
        
        if amount != "" {
            if Double(amount)! < Double(settings_data[index][0])! {
                cell.titleRed2.text = defaultLocalizer.stringForKey(key: "minimum_limit:") + " " + settings_data[index][0]
                cell.titleRed2.isHidden = false
                cell.count_transfer.layer.borderColor = UIColor.red.cgColor
                cell.sendButton.isEnabled = false
                cell.sendButton.backgroundColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
                return_status = true
            }
            else if string != "" && Double(amount)! > Double(settings_data[index][1])!  {
                cell.titleRed2.text = defaultLocalizer.stringForKey(key: "maximum_limit:") + " " + settings_data[index][1]
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
        
        if amount != "" {
            cell.slider.value[0] = CGFloat(Double(amount)!)
            if Double(cell.slider.value[0]) >= Double(settings_data[index][0])! && Double(cell.slider.value[0])  <= Double(settings_data[index][2])! {

                if Double(settings_data[index][8])! > 0 {
                    let discountPrice = (Double(settings_data[index][3])! * Double(settings_data[index][8])!) / 100
                    let finallCost = (Double(settings_data[index][3])! - discountPrice)
                    
                    value_transfer = String(format: "%g", Double(String(format: "%.2f", finallCost))!) + " c."
                }
                else {
                    value_transfer = String(format: "%g", Double(String(format: "%.2f", Double(settings_data[index][3])!))!) + " c."
                }

            }
            else if Double(cell.slider.value[0]) > Double(settings_data[index][2])! && Double(cell.slider.value[0]) <= Double(settings_data[index][1])! {

                if Double(settings_data[index][8])! > 0{
                    let firstPrice = Double(cell.slider.value[0]) * Double(settings_data[index][4])!
                    let discountPrice = (firstPrice * Double(settings_data[index][8])!) / 100
                    let finallCost = firstPrice - discountPrice
                    value_transfer = String(format: "%g", Double(String(format: "%.2f", finallCost))!) + " c."
                }
                else {
                    value_transfer = String(format: "%g", Double(String(format: "%.2f", Double(cell.slider.value[0]) * Double(settings_data[index][4])!))!) + " c."
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
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(ContactsViewController(), animated: false)
        
    }
}
