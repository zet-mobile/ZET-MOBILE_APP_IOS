//
//  DetalizationViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/30/21.
//

import UIKit
import RxCocoa
import RxSwift

struct detailData {
    let date_header: String
    let phoneNumber: [String]
    let status: [String]
    let email: [String]
    let dateFrom: [String]
    let dateTo: [String]
    let date: [String]
    let id: [String]
    let price: [String]
    let statusId: [String]
}

class DetalizationViewController: UIViewController , UIScrollViewDelegate {
    
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    let disposeBag = DisposeBag()
    var halfModalTransitioningDelegate: HalfModalTransitioningDelegate?
    let detailViewController = MoreDetailViewController()
    
    var nav = UINavigationController()
    var alert = UIAlertController()
    
    let calendarViewController = CalendarViewController()
    let scrollView = UIScrollView()
    
    var toolbar = TarifToolbarView()
    var detalizationView = DetalizationView()
    let table = UITableView()
    let table2 = UITableView()
    
    var x_pozition = 20
    var y_pozition = 100
    
    var choosedPeriod = 0
    
    let TabPeriodCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(TabPeriodCollectionViewCell.self, forCellWithReuseIdentifier: "tabs_period")
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        return cv
    }()
    
    let TabCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(TapDetalizationCollectionCell.self, forCellWithReuseIdentifier: "tabs")
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        return cv
    }()
    
    var HistoryData = [detailData(date_header: String(), phoneNumber: [String](), status: [String](), email: [String](), dateFrom: [String](), dateTo: [String](), date: [String](), id: [String](), price: [String](), statusId: [String]())]
    
    var value_transfer = "0"
    var inMail = ""
    var settings_data = [[String]]()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
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
        detalizationView = DetalizationView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 896))
        
        self.view.addSubview(toolbar)
        scrollView.addSubview(detalizationView)
        
        toolbar.icon_back.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        toolbar.number_user_name.text = defaultLocalizer.stringForKey(key: "History")
        
        scrollView.frame = CGRect(x: 0, y: 60 + (topPadding ?? 0), width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 60 + (topPadding ?? 0) + (bottomPadding ?? 0)))
        
    }

    func setupTabCollectionView() {
        y_pozition = y_pozition + 55
        
        detalizationView.tab1.frame = CGRect(x: 0, y: y_pozition, width: Int(UIScreen.main.bounds.size.width) / 2, height: 40)
        detalizationView.tab2.frame = CGRect(x: UIScreen.main.bounds.size.width / 2, y: CGFloat(y_pozition), width: UIScreen.main.bounds.size.width / 2, height: 40)
        
        detalizationView.tab1Line.frame = CGRect(x: 10, y: y_pozition + 40, width: (Int(UIScreen.main.bounds.size.width) / 2) - 20, height: 3)
        detalizationView.tab2Line.frame = CGRect(x: (UIScreen.main.bounds.size.width / 2) + 10, y: CGFloat(y_pozition + 40), width: (UIScreen.main.bounds.size.width / 2) - 20, height: 3)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tab1Click))
        detalizationView.tab1.isUserInteractionEnabled = true
        detalizationView.tab1.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(tab2Click))
        detalizationView.tab2.isUserInteractionEnabled = true
        detalizationView.tab2.addGestureRecognizer(tapGestureRecognizer2)
        
        scrollView.addSubview(TabCollectionView)
        TabCollectionView.backgroundColor = contentColor
        TabCollectionView.frame = CGRect(x: 0, y: y_pozition + 45, width: Int(UIScreen.main.bounds.size.width), height: Int(UIScreen.main.bounds.size.height - 104))
        TabCollectionView.delegate = self
        TabCollectionView.dataSource = self
        TabCollectionView.alwaysBounceVertical = false
        
        scrollView.addSubview(TabPeriodCollectionView)
        TabPeriodCollectionView.backgroundColor = .clear
        TabPeriodCollectionView.frame = CGRect(x: 0, y: 80, width: Int(UIScreen.main.bounds.size.width), height: 50)
        TabPeriodCollectionView.delegate = self
        TabPeriodCollectionView.dataSource = self
        TabPeriodCollectionView.alwaysBounceVertical = false
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.scrollView == scrollView {
            if scrollView.contentOffset.y > detalizationView.tab1.frame.origin.y {
                detalizationView.email_text.isHidden = true
                TabPeriodCollectionView.isHidden = true
                detalizationView.white_view_back.isHidden = true
                self.scrollView.contentOffset.y = 0
                detalizationView.tab1.frame.origin.y = 0
                detalizationView.tab2.frame.origin.y = 0
                detalizationView.tab1Line.frame.origin.y = 40
                detalizationView.tab2Line.frame.origin.y = 40
                TabCollectionView.frame.origin.y = 45
            }
            if scrollView.contentOffset.y < -10 && detalizationView.white_view_back.isHidden == true {
                detalizationView.email_text.isHidden = false
                TabPeriodCollectionView.isHidden = false
                detalizationView.white_view_back.isHidden = false
                self.scrollView.contentOffset.y = 104
                detalizationView.tab1.frame.origin.y = CGFloat(y_pozition)
                detalizationView.tab2.frame.origin.y = CGFloat(y_pozition)
                detalizationView.tab1Line.frame.origin.y = CGFloat(y_pozition + 40)
                detalizationView.tab2Line.frame.origin.y = CGFloat(y_pozition + 40)
                TabCollectionView.frame.origin.y = CGFloat(y_pozition + 45)
               
            }
        }
    }
    
    @objc func tab1Click() {
        detalizationView.tab1.textColor = colorBlackWhite
        detalizationView.tab2.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        detalizationView.tab1Line.backgroundColor = .orange
        detalizationView.tab2Line.backgroundColor = .clear
        TabCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionView.ScrollPosition.right, animated: true)
    }
    
    @objc func tab2Click() {
        detalizationView.tab1.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        detalizationView.tab2.textColor = colorBlackWhite
        detalizationView.tab1Line.backgroundColor = .clear
        detalizationView.tab2Line.backgroundColor = .orange
        TabCollectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: UICollectionView.ScrollPosition.left, animated: true)
    }
    
    func sendRequest() {
        let client = APIClient.shared
            do{
              try client.getDetailingyRequest().subscribe(
                onNext: { result in
                  print(result)
                    DispatchQueue.main.async {
                        
                        self.settings_data.append([String(result.minDaysCount), String(result.maxDaysCount), String(result.pricePerDay), String(result.description),  String(result.quantityLimit), String(result.discountPercent)])
                            
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
              try client.detailingHistoryRequest().subscribe(
                onNext: { result in
                  print(result)
                    DispatchQueue.main.async { [self] in
                        
                        if result.history != nil {
                            
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
                                    tableData2.append(String(result.history![i].histories[j].email))
                                    tableData3.append(String(result.history![i].histories[j].dateFrom))
                                    tableData4.append(String(result.history![i].histories[j].dateTo))
                                    tableData5.append(String(result.history![i].histories[j].date))
                                    tableData6.append(String(result.history![i].histories[j].id))
                                    tableData7.append(String(result.history![i].histories[j].price))
                                    tableData8.append(String(result.history![i].histories[j].statusId))
                                }
                                
                                HistoryData.append(detailData(date_header: String(result.history![i].date), phoneNumber: tableData, status: tableData1, email: tableData2, dateFrom: tableData3, dateTo: tableData4, date: tableData5, id: tableData6, price: tableData7, statusId: tableData8))
                            }
                            
                        }
                        else {
                            DispatchQueue.main.async {
                            emptyView = EmptyView(frame: CGRect(x: 0, y: 30, width: self.table2.frame.width, height: self.table.frame.height), text: """
                                Вы еще не воспользовались услугой "Детализация"
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
                    }
                   print("Completed event.")
                    
                }).disposed(by: disposeBag)
              }
              catch{
            }
    }
    
    @objc func translateTrafic() {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = table.cellForRow(at: indexPath) as! DetalizationViewCell
        
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
        view.name.text = defaultLocalizer.stringForKey(key: "History")
        view.image_icon.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "money_w") : UIImage(named: "detail"))
        
        let cost: NSString = defaultLocalizer.stringForKey(key: "Send_history") as NSString
        let range = (cost).range(of: cost as String)
        let costString = NSMutableAttributedString.init(string: cost as String)
        costString.addAttribute(NSAttributedString.Key.foregroundColor, value: colorBlackWhite , range: range)
        costString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], range: range)
        
        var title_cost = " \(fromDate) - \(to_Date)" as NSString
            
        let titleString = NSMutableAttributedString.init(string: title_cost as String)
        let range2 = (title_cost).range(of: title_cost as String)
        titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: colorBlackWhite , range: range2)
        titleString.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], range: range2)
        
        costString.append(titleString)
        view.value_title.attributedText = costString
        view.value_title.frame.size.height = 60
        view.value_title.frame.origin.y = view.value_title.frame.origin.y - 10
        
        let cost2: NSString = defaultLocalizer.stringForKey(key: "to") as NSString
        let range2_1 = (cost2).range(of: cost2 as String)
        let costString2 = NSMutableAttributedString.init(string: cost2 as String)
        costString2.addAttribute(NSAttributedString.Key.foregroundColor, value: colorBlackWhite , range: range2_1)
        costString2.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], range: range2_1)
        
        let title_cost2 = " \(detalizationView.email_text.text) " as NSString
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
        
        view.number_title.frame.origin.y = view.number_title.frame.origin.y + 20
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
        view.cost_title.frame.origin.y = view.cost_title.frame.origin.y + 20
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissDialog))
        view.name.isUserInteractionEnabled = true
        view.name.addGestureRecognizer(tapGestureRecognizer)
        
        view.ok.setTitle(defaultLocalizer.stringForKey(key: "Send"), for: .normal)
        view.cancel.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
        view.ok.addTarget(self, action: #selector(okClickDialog(_:)), for: .allTouchEvents)
        alert.view.backgroundColor = .clear
        alert.view.addSubview(view)
        
        if detalizationView.email_text.text != "" && isValidEmail(detalizationView.email_text.text!) == true {
           // cell.titleRed.isHidden = true
            detalizationView.email_text.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
            cell.sendButton.showAnimation {
                self.present(self.alert, animated: true, completion: nil)
              }
        }
        else {
            detalizationView.email_text.layer.borderColor = UIColor.red.cgColor
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
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = table.cellForRow(at: indexPath) as! DetalizationViewCell
        
        inMail = String(detalizationView.email_text.text ?? "")
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "dd.MM.yyyy"
        let date1 = dateFormatter2.date(from: fromDate)
        let date2 = dateFormatter2.date(from: to_Date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        fromDate = dateFormatter2.string(from: date1!)
        to_Date = dateFormatter2.string(from: date2!)
        
        let parametr: [String: Any] = ["dateFrom": fromDate, "dateTo": to_Date, "email": inMail]
        
        let client = APIClient.shared
            do{
              try client.detailingPutRequest(jsonBody: parametr).subscribe(
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
        detailViewController.more_view.content.text = settings_data[0][3]
        detailViewController.more_view.title_top.text = defaultLocalizer.stringForKey(key: "History")
        detailViewController.more_view.image.image = UIImage(named: "mobile.png")
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
    
    @objc func dismissCalendar(_ sender: UIButton) {
        print("jlllllll")
        nav.dismiss(animated: true) { [self] in
            let indexPath = IndexPath(row: 0, section: 0)
            let cell = table.cellForRow(at: indexPath) as! DetalizationViewCell
            cell.period.text = fromDate + " - " + to_Date
        }
    }
}

extension DetalizationViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if collectionView == TabPeriodCollectionView {
            if indexPath.row == 0 {
                return CGSize(width: 150, height: collectionView.frame.height)
            }
            else {
                return CGSize(width: 100, height: collectionView.frame.height)
            }
            
        }
        else {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == TabPeriodCollectionView {
            return 4
        }
        else {
            return 2
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == TabPeriodCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tabs_period", for: indexPath) as! TabPeriodCollectionViewCell
            
            if indexPath.row == 0 {
                cell.myPeriod.text = defaultLocalizer.stringForKey(key: "Own perious")
                cell.myPeriod.frame = CGRect(x: 10, y: 10, width: 150, height: 30)
            }
            
            else if indexPath.row == 1 {
                cell.myPeriod.text = defaultLocalizer.stringForKey(key: "Day")
                cell.myPeriod.frame = CGRect(x: 0, y: 10, width: 100, height: 30)
            }
            
            else if indexPath.row == 2 {
                cell.myPeriod.text = defaultLocalizer.stringForKey(key: "Aweek")
                cell.myPeriod.frame = CGRect(x: 0, y: 10, width: 100, height: 30)
            }
            
            else if indexPath.row == 3 {
                cell.myPeriod.text = defaultLocalizer.stringForKey(key: "Month")
                cell.myPeriod.frame = CGRect(x: 0, y: 10, width: 100, height: 30)
            }
            
            if indexPath.row == choosedPeriod {
                cell.myPeriod.backgroundColor = .orange
                cell.myPeriod.textColor = .white
                cell.myPeriod.layer.masksToBounds = true
                cell.myPeriod.layer.cornerRadius = cell.myPeriod.frame.height / 2
            }
            
            else {
                cell.myPeriod.backgroundColor = .clear
                cell.myPeriod.textColor = .gray
            }
            
            cell.actionDelegate = (self as CellTapPeriodActionDelegate)
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tabs", for: indexPath) as! TapDetalizationCollectionCell
            if indexPath.row == 0 {
                table.register(DetalizationViewCell.self, forCellReuseIdentifier: "detail_cell")
                table.register(HistoryHeaderCell.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")
                table.frame = CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width - 20, height: UIScreen.main.bounds.size.height - 150)
                table.delegate = self
                table.dataSource = self
                table.rowHeight = 500
                table.estimatedRowHeight = 500
                table.alwaysBounceVertical = false
                table.separatorStyle = .none
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
                table2.backgroundColor = contentColor
                cell.addSubview(table2)
                
            }
            return cell
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
 
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == TabCollectionView {
            if indexPath.row == 0 {
                detalizationView.tab1.textColor = colorBlackWhite
                detalizationView.tab2.textColor = .gray
                detalizationView.tab1Line.backgroundColor = .orange
                detalizationView.tab2Line.backgroundColor = .clear
                
            } else {
                detalizationView.tab1.textColor = .gray
                detalizationView.tab2.textColor = colorBlackWhite
                detalizationView.tab1Line.backgroundColor = .clear
                detalizationView.tab2Line.backgroundColor = .orange
          }
       }
        else {
            print(indexPath.row)
        }
    }
}

extension DetalizationViewController: CellTapPeriodActionDelegate {
    func didTapped(for cell: TabPeriodCollectionViewCell) {
        print("hi")
        if let indexPath = TabPeriodCollectionView.indexPath(for: cell) {
            choosedPeriod = indexPath.row
            TabPeriodCollectionView.reloadData()
            
            switch choosedPeriod {
            case 0:
                let dateFormatter2 = DateFormatter()
                dateFormatter2.dateFormat = "dd.MM.yyyy"
                let lastDaysAgo = Calendar.current.date(byAdding: .day, value: -1, to: Date())
                fromDate = dateFormatter2.string(from: lastDaysAgo!)
                to_Date = dateFormatter2.string(from: lastDaysAgo!)
                let indexPath = IndexPath(row: 0, section: 0)
                let cell = table.cellForRow(at: indexPath) as! DetalizationViewCell
                cell.period.text = fromDate + " - " + to_Date
                
            case 1:
                let dateFormatter2 = DateFormatter()
                dateFormatter2.dateFormat = "dd.MM.yyyy"
                let lastDaysAgo = Calendar.current.date(byAdding: .day, value: -1, to: Date())
                fromDate = dateFormatter2.string(from: lastDaysAgo!)
                to_Date = dateFormatter2.string(from: lastDaysAgo!)
                let indexPath = IndexPath(row: 0, section: 0)
                let cell = table.cellForRow(at: indexPath) as! DetalizationViewCell
                cell.period.text = fromDate + " - " + to_Date

            case 2:
                let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())
                let lastDaysAgo = Calendar.current.date(byAdding: .day, value: -1, to: Date())
                let dateFormatter2 = DateFormatter()
                dateFormatter2.dateFormat = "dd.MM.yyyy"
                fromDate = dateFormatter2.string(from: sevenDaysAgo!)
                to_Date = dateFormatter2.string(from: lastDaysAgo!)
                
                let indexPath = IndexPath(row: 0, section: 0)
                let cell = table.cellForRow(at: indexPath) as! DetalizationViewCell
                cell.period.text = fromDate + " - " + to_Date
                
            case 3:
                let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date())
                let lastDaysAgo = Calendar.current.date(byAdding: .day, value: -1, to: Date())
                let dateFormatter2 = DateFormatter()
                dateFormatter2.dateFormat = "dd.MM.yyyy"
                fromDate = dateFormatter2.string(from: sevenDaysAgo!)
                to_Date = dateFormatter2.string(from: lastDaysAgo!)
                
                let indexPath = IndexPath(row: 0, section: 0)
                let cell = table.cellForRow(at: indexPath) as! DetalizationViewCell
                cell.period.text = fromDate + " - " + to_Date

            default: break;
            }
            
        }
    }
    
    
}

extension DetalizationViewController: UITableViewDataSource, UITableViewDelegate {
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "detail_cell", for: indexPath) as! DetalizationViewCell
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "dd.MM.yyyy"
            let lastDaysAgo = Calendar.current.date(byAdding: .day, value: -1, to: Date())
            fromDate = dateFormatter2.string(from: lastDaysAgo!)
            to_Date = dateFormatter2.string(from: lastDaysAgo!)
            
            cell.period.text = fromDate + " - " + to_Date
            value_transfer = "0.10 " +  defaultLocalizer.stringForKey(key: "somoni")
            
            let open_calendar = cell.period.setView(.right, image: UIImage(named: "calendar"))
            open_calendar.addTarget(self, action: #selector(openCalendar), for: .touchUpInside)
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openCondition))
            cell.icon_more.isUserInteractionEnabled = true
            cell.icon_more.addGestureRecognizer(tapGestureRecognizer)
            
            let cost: NSString = defaultLocalizer.stringForKey(key: "Commission") as NSString
            let range = (cost).range(of: cost as String)
            let costString = NSMutableAttributedString.init(string: cost as String)
            costString.addAttribute(NSAttributedString.Key.foregroundColor, value: colorBlackWhite , range: range)
            costString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)], range: range)
            
            var title_cost = "0.10" + " " +  defaultLocalizer.stringForKey(key: "somoni") as NSString
            
            let titleString = NSMutableAttributedString.init(string: title_cost as String)
            let range2 = (title_cost).range(of: title_cost as String)
            titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange , range: range2)
            titleString.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)], range: range2)
            costString.append(titleString)
            cell.title_commission.attributedText = costString
            
            cell.sendButton.addTarget(self, action:  #selector(self.translateTrafic), for: .touchUpInside)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "history_transfer", for: indexPath) as! TraficHistoryViewCell
         
            cell.titleOne.text = HistoryData[indexPath.section].phoneNumber[indexPath.row]
            cell.titleTwo.text = "" + HistoryData[indexPath.section].status[indexPath.row]
            cell.titleThree.text = HistoryData[indexPath.section].price[indexPath.row] + " c"
            
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
            let date = dateFormatter1.date(from: String(HistoryData[indexPath.section].date[indexPath.row]))
            dateFormatter1.dateFormat = "HH:mm"
            
            cell.titleFour.text = dateFormatter1.string(from: date!)
            
            cell.titleTwo.frame = CGRect(x: 80, y: 40, width: Int(UIScreen.main.bounds.size.width) - (cell.titleFour.text!.count * 10) - 110, height: 50)
            
            cell.titleThree.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (cell.titleThree.text!.count * 15) - 30, y: 10, width: (cell.titleThree.text!.count * 15), height: 30)
            
            cell.titleFour.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (cell.titleFour.text!.count * 10) - 30, y: 40, width: (cell.titleFour.text!.count * 10), height: 50)
            return cell
        }
       
    }
    
    @objc func openCalendar(_ sender: UIButton) {
        
        calendarViewController.calendar_view.close.addTarget(self, action: #selector(dismiss_view), for: .touchUpInside)
        calendarViewController.calendar_view.cancel.addTarget(self, action: #selector(dismiss_view), for: .touchUpInside)
        calendarViewController.calendar_view.ok.addTarget(self, action: #selector(dismissCalendar), for: .touchUpInside)
        
        nav = UINavigationController(rootViewController: calendarViewController)
        nav.modalPresentationStyle = .pageSheet
        nav.view.backgroundColor = contentColor
        nav.isNavigationBarHidden = true
        calendarViewController.view.backgroundColor = colorGrayWhite
        if #available(iOS 15.0, *) {
            if let sheet = nav.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.selectedDetentIdentifier = .medium
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false

            }
        } else {
            // Fallback on earlier versions
        }
            
        sender.showAnimation { [self] in
            present(nav, animated: true, completion: nil)
        }
        
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
}

