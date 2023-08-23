//
//  AddionalTraficsViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/12/21.
//

import UIKit
import RxCocoa
import RxSwift

var color1 = colorLightDarkGray
var color2 = colorBlackWhite
var emptyView: EmptyView?

class AddionalTraficsViewController: UIViewController, UIScrollViewDelegate {
    

    let disposeBag = DisposeBag()
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    let scrollView = UIScrollView()
    var alert = UIAlertController()
    
    var toolbar = TarifToolbarView()
    var addional_view = AddionalTraficsView()
    let remainderView = RemainderStackView()
    
    var x_pozition = 20
    var y_pozition = 150
    
    let table = UITableView()
    let table2 = UITableView()
    let table3 = UITableView()
    
    let TabCollectionServiceView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(TabCollectionServiceViewCell.self, forCellWithReuseIdentifier: "tabs")
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        return cv
    }()
    
    var discount_id = ""
    var packetId = ""
    var balance_credit = ""
    var remainders_data = [[String]]()
    
    var internet_data = [[String]]()
    var minuti_data = [[String]]()
    var sms_data = [[String]]()
    
    var activePage = 0
    
    var whichTab = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        showActivityIndicator(uiView: self.view)
        view.backgroundColor = toolbarColor
        
        color1 = toolbarColor
        color2 = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.00) : UIColor.white)
        
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
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 600)
        view.addSubview(scrollView)
        
        toolbar = TarifToolbarView(frame: CGRect(x: 0, y: topPadding ?? 0, width: UIScreen.main.bounds.size.width, height: 60))
        addional_view = AddionalTraficsView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        
        toolbar.number_user_name.text = defaultLocalizer.stringForKey(key: "Connect_package")
        addional_view.balance.text = balance_credit + " " + defaultLocalizer.stringForKey(key: "tjs")
        self.view.addSubview(toolbar)
        scrollView.addSubview(addional_view)
        
        toolbar.icon_back.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goBack))
        toolbar.isUserInteractionEnabled = true
        toolbar.addGestureRecognizer(tapGestureRecognizer)
        
        scrollView.frame = CGRect(x: 0, y: 60 + (topPadding ?? 0), width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 60 + (topPadding ?? 0) + (bottomPadding ?? 0)))
    }


    func setupRemaindersSection(){
        scrollView.addSubview(remainderView)
        remainderView.frame = CGRect(x: 0, y: 10, width: UIScreen.main.bounds.size.width, height: 145)
        
        var textColor = UIColor.black
        var textColor2 = UIColor.lightGray
        var number_data = ""
        var size = 18
        
        if remainders_data.count != 0 {
            if remainders_data[0][1] == "0" {
                textColor = .red
                textColor2 = .red
            }
            else {
                textColor = colorBlackWhite
                textColor2 = .lightGray
            }
            
            if remainders_data[0][2] == "true" {
                number_data = "∞"
                size = 22
                textColor = .orange
                textColor2 = .lightGray
            }
            else {
                size = 18
                number_data = remainders_data[0][1]
            }
            
            var number_label: NSString = number_data as NSString
            var range = (number_label).range(of: number_label as String)
            var number_label_String = NSMutableAttributedString.init(string: number_label as String)
            number_label_String.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor , range: range)
            number_label_String.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: CGFloat(size))], range: range)
            
            var title_label = "\n \(defaultLocalizer.stringForKey(key: "minutes")) \(defaultLocalizer.stringForKey(key: "from")) \(remainders_data[0][0])" as NSString
            var titleString = NSMutableAttributedString.init(string: title_label as String)
            var range2 = (title_label).range(of: title_label as String)
            titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor2, range: range2)
            titleString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11)], range: range2)
            
            number_label_String.append(titleString)
            
            if number_data == "∞" {
                remainderView.minutesRemainder.text2.attributedText = number_label_String
            }
            else {
                remainderView.minutesRemainder.text.attributedText = number_label_String
            }
           
            if remainders_data[1][1] == "0" {
                textColor = .red
                textColor2 = .red
            }
            else {
                textColor = colorBlackWhite
                textColor2 = .lightGray
            }
            
            if remainders_data[1][2] == "true" {
                number_data = "∞"
                size = 30
                textColor = .orange
                textColor2 = .lightGray
            }
            else {
                size = 18
                number_data = remainders_data[1][1]
            }
            number_label = number_data as NSString
            range = (number_label).range(of: number_label as String)
            number_label_String = NSMutableAttributedString.init(string: number_label as String)
            number_label_String.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: range)
            number_label_String.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: CGFloat(size))], range: range)
            
            number_label = "7060" as NSString
            
            title_label = "\n \(defaultLocalizer.stringForKey(key: "megabyte")) \(defaultLocalizer.stringForKey(key: "from")) \(remainders_data[1][0])" as NSString
            titleString = NSMutableAttributedString.init(string: title_label as String)
            range2 = (title_label).range(of: title_label as String)
            titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor2, range: range2)
            titleString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11)], range: range2)
            
            number_label_String.append(titleString)
            
            if number_data == "∞" {
                remainderView.internetRemainder.text2.attributedText = number_label_String
            }
            else {
                remainderView.internetRemainder.text.attributedText = number_label_String
            }
            
            if remainders_data[2][1] == "0" {
                textColor = .red
                textColor2 = .red
            }
            else {
                textColor = colorBlackWhite
                textColor2 = .lightGray
            }
            
            if remainders_data[2][2] == "true" {
                number_data = "∞"
                size = 30
                textColor = .orange
                textColor2 = .lightGray
            }
            else {
                size = 18
                number_data = remainders_data[2][1]
            }
            number_label = number_data as NSString
            range = (number_label).range(of: number_label as String)
            number_label_String = NSMutableAttributedString.init(string: number_label as String)
            number_label_String.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: range)
            number_label_String.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: CGFloat(size))], range: range)
            
            title_label = "\n \(defaultLocalizer.stringForKey(key: "SMS")) \(defaultLocalizer.stringForKey(key: "from")) \(remainders_data[2][0])" as NSString
            titleString = NSMutableAttributedString.init(string: title_label as String)
            range2 = (title_label).range(of: title_label as String)
            titleString.addAttribute(NSAttributedString.Key.foregroundColor, value:textColor2, range: range2)
            titleString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11)], range: range2)
            
            number_label_String.append(titleString)
            if number_data == "∞" {
                remainderView.messagesRemainder.text2.attributedText = number_label_String
            }
            else {
                remainderView.messagesRemainder.text.attributedText = number_label_String
            }
            
            remainderView.internetRemainder.clickActionEffect.isHidden = true
            remainderView.messagesRemainder.clickActionEffect.isHidden = true
            remainderView.minutesRemainder.clickActionEffect.isHidden = true
            
            remainderView.messagesRemainder.plusText.isHidden = true
            remainderView.messagesRemainder.backgroundColor = .clear
            
            
            if remainders_data[0][2] == "true" || Double(remainders_data[0][0])! < Double(remainders_data[0][1])! {
                remainderView.minutesRemainder.spentProgress = CGFloat(1)
            }
            else {
                remainderView.minutesRemainder.spentProgress = CGFloat(Double(remainders_data[0][1])! / Double(remainders_data[0][0])!)
            }
            
            if remainders_data[1][2] == "true" || Double(remainders_data[1][0])! < Double(remainders_data[1][1])! {
                remainderView.internetRemainder.spentProgress = CGFloat(1)
            }
            else {
                remainderView.internetRemainder.spentProgress = CGFloat(Double(remainders_data[1][1])! / Double(remainders_data[1][0])!)
            }
            
            if remainders_data[2][2] == "true" || Double(remainders_data[2][0])! < Double(remainders_data[2][1])! {
                remainderView.messagesRemainder.spentProgress = CGFloat(1)
            }
            else {
                remainderView.messagesRemainder.spentProgress = CGFloat(Double(remainders_data[2][1])! / Double(remainders_data[2][0])!)
            }
            
            
        }
        
    }

    func setupTabCollectionView() {
        y_pozition = y_pozition + 55
        
        addional_view.tab1.frame = CGRect(x: 10, y: y_pozition, width: (Int(UIScreen.main.bounds.size.width - 20) / 3), height: 40)
        addional_view.tab2.frame = CGRect(x: addional_view.tab1.frame.width + 10, y: CGFloat(y_pozition), width: (UIScreen.main.bounds.size.width - 20) / 3, height: 40)
        addional_view.tab3.frame = CGRect(x: (Int(addional_view.tab1.frame.width) * 2) + 10, y: y_pozition, width: (Int(UIScreen.main.bounds.size.width - 20) / 3), height: 40)
     
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tab1Click))
        addional_view.tab1.isUserInteractionEnabled = true
        addional_view.tab1.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(tab2Click))
        addional_view.tab2.isUserInteractionEnabled = true
        addional_view.tab2.addGestureRecognizer(tapGestureRecognizer2)
        
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(tab3Click))
        addional_view.tab3.isUserInteractionEnabled = true
        addional_view.tab3.addGestureRecognizer(tapGestureRecognizer3)
        
        addional_view.tab1Line.frame = CGRect(x: 10, y: y_pozition + 40, width: (Int(UIScreen.main.bounds.size.width - 20) / 3), height: 2)
        addional_view.tab2Line.frame = CGRect(x: addional_view.tab1.frame.width + 10, y: CGFloat(y_pozition + 40), width: (UIScreen.main.bounds.size.width - 20) / 3, height: 2)
        addional_view.tab3Line.frame = CGRect(x: CGFloat(Int(addional_view.tab1.frame.width) * 2) + 10, y: CGFloat(y_pozition + 40), width: (UIScreen.main.bounds.size.width - 20) / 3, height: 2)
        
        scrollView.addSubview(TabCollectionServiceView)
        TabCollectionServiceView.backgroundColor = contentColor
        TabCollectionServiceView.frame = CGRect(x: 0, y: y_pozition + 45, width: Int(UIScreen.main.bounds.size.width), height: Int(UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 60 + (topPadding ?? 0) + (bottomPadding ?? 0))))
        TabCollectionServiceView.delegate = self
        TabCollectionServiceView.dataSource = self
        TabCollectionServiceView.alwaysBounceVertical = false
        
     //clickAction
        if(whichTab == "1")
        {
            tab1Click()
            whichTab = ""
        }
        else if (whichTab == "2")
        {
            tab2Click()
            whichTab = ""
        }
        else if (whichTab == "3")
        {
            tab3Click()
            whichTab = ""
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.scrollView == scrollView || table == scrollView || table2 == scrollView || table3 == scrollView {
            if scrollView.contentOffset.y > addional_view.tab1.frame.origin.y {
                remainderView.isHidden = true
                //servicesView.searchField.isHidden = true
                self.scrollView.contentOffset.y = 0
                addional_view.tab1.frame.origin.y = 0
                addional_view.tab2.frame.origin.y = 0
                addional_view.tab1Line.frame.origin.y = 40
                addional_view.tab2Line.frame.origin.y = 40
                addional_view.tab3.frame.origin.y = 0
                addional_view.tab3Line.frame.origin.y = 40
                TabCollectionServiceView.frame.origin.y = 45
            }
            if scrollView.contentOffset.y < -10 && remainderView.isHidden == true {
                remainderView.isHidden = false
                //servicesView.searchField.isHidden = false
               // self.scrollView.contentOffset.y = 104
                addional_view.tab1.frame.origin.y = CGFloat(y_pozition)
                addional_view.tab2.frame.origin.y = CGFloat(y_pozition)
                addional_view.tab1Line.frame.origin.y = CGFloat(y_pozition + 40)
                addional_view.tab2Line.frame.origin.y = CGFloat(y_pozition + 40)
                addional_view.tab3.frame.origin.y = CGFloat(y_pozition)
                addional_view.tab3Line.frame.origin.y = CGFloat(y_pozition + 40)
                TabCollectionServiceView.frame.origin.y = CGFloat(y_pozition + 45)
                
            }
        }
    }
    
    @objc func tab1Click() {
        addional_view.tab1.textColor = colorBlackWhite
        addional_view.tab2.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        addional_view.tab3.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        addional_view.tab1Line.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
        addional_view.tab2Line.backgroundColor = .clear
        addional_view.tab3Line.backgroundColor = .clear
        TabCollectionServiceView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        activePage = 0
    }
    
    @objc func tab2Click() {
        addional_view.tab1.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        addional_view.tab2.textColor = colorBlackWhite
        addional_view.tab3.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        addional_view.tab1Line.backgroundColor = .clear
        addional_view.tab2Line.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
        addional_view.tab3Line.backgroundColor = .clear
        TabCollectionServiceView.scrollToItem(at: IndexPath(item: 1, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
       
    }
    
    @objc func tab3Click() {
        addional_view.tab1.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        addional_view.tab2.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        addional_view.tab3.textColor = colorBlackWhite
        addional_view.tab1Line.backgroundColor = .clear
        addional_view.tab2Line.backgroundColor = .clear
        addional_view.tab3Line.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
        TabCollectionServiceView.scrollToItem(at: IndexPath(item: 2, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        activePage = 2
    }
    
    func sendRequest() {
        let client = APIClient.shared
            do{
              try client.packetsGetRequest().subscribe(
                onNext: { result in
                  print(result)
                    DispatchQueue.main.async {
                        self.balance_credit = String(result.subscriberBalance)
                        
                        self.remainders_data.append([String(result.balances.offnet.start), String(result.balances.offnet.now), String(result.balances.offnet.unlim)])
                        self.remainders_data.append([String(result.balances.mb.start), String(result.balances.mb.now), String(result.balances.mb.unlim)])
                        self.remainders_data.append([String(result.balances.sms.start), String(result.balances.sms.now), String(result.balances.sms.unlim)])
                    
                        
                        if result.connectedPackets.count != 0 {
                            for i in 0 ..< result.connectedPackets.count {
                                
                                var disc_id = ""
                                var disc_percent = ""
                                
                                if result.connectedPackets[i].discount != nil {
                                    disc_id = String(result.connectedPackets[i].discount!.discountServiceId)
                                    disc_percent = String(result.connectedPackets[i].discount!.discountPercent)
                                }
                                
                                if result.connectedPackets[i].unitType == 3 {
                                    self.internet_data.append([String(result.connectedPackets[i].id), String(result.connectedPackets[i].packetName ?? ""), String(result.connectedPackets[i].price),  String(result.connectedPackets[i].packetStatus), String(result.connectedPackets[i].nextApplyDate ?? ""), String(result.connectedPackets[i].description ?? ""), String(result.connectedPackets[i].period ?? ""), "connected", disc_id, disc_percent])
                                }
                                else if result.connectedPackets[i].unitType == 1 {
                                    self.minuti_data.append([String(result.connectedPackets[i].id), String(result.connectedPackets[i].packetName ?? ""), String(result.connectedPackets[i].price),  String(result.connectedPackets[i].packetStatus), String(result.connectedPackets[i].nextApplyDate ?? ""), String(result.connectedPackets[i].description ?? ""), String(result.connectedPackets[i].period ?? ""), "connected", disc_id, disc_percent])
                                }
                                else if result.connectedPackets[i].unitType == 2 {
                                    self.sms_data.append([String(result.connectedPackets[i].id), String(result.connectedPackets[i].packetName ?? ""), String(result.connectedPackets[i].price),  String(result.connectedPackets[i].packetStatus), String(result.connectedPackets[i].nextApplyDate ?? ""), String(result.connectedPackets[i].description ?? ""), String(result.connectedPackets[i].period ?? ""), "connected", disc_id, disc_percent])
                                }
                            }
                        }
                        
                        if result.internetAvailablePackets.count != 0 {
                            for i in 0 ..< result.internetAvailablePackets.count {
                                
                                var disc_id1 = ""
                                var disc_percent1 = ""
                                
                                if result.internetAvailablePackets[i].discount != nil {
                                    disc_id1 = String(result.internetAvailablePackets[i].discount!.discountServiceId)
                                    disc_percent1 = String(result.internetAvailablePackets[i].discount!.discountPercent)
                                }
                                
                                
                                self.internet_data.append([String(result.internetAvailablePackets[i].id), String(result.internetAvailablePackets[i].packetName  ?? ""), String(result.internetAvailablePackets[i].price),  String(result.internetAvailablePackets[i].packetStatus), String(result.internetAvailablePackets[i].nextApplyDate ?? ""), String(result.internetAvailablePackets[i].description ?? ""), String(result.internetAvailablePackets[i].period ?? ""), "available", disc_id1, disc_percent1])
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                emptyView = EmptyView(frame: CGRect(x: 0, y: 30, width: self.table.frame.width, height: self.table.frame.height), text: self.defaultLocalizer.stringForKey(key: "No_internet"))
                            self.table.separatorStyle = .none
                            self.table.backgroundView = emptyView
                            }
                        }
                        
                        if result.offnetAvailablePackets.count != 0 {
                            for i in 0 ..< result.offnetAvailablePackets.count {
                               
                                var disc_id2 = ""
                                var disc_percent2 = ""
                                if result.offnetAvailablePackets[i].discount != nil {
                                    disc_id2 = String(result.offnetAvailablePackets[i].discount!.discountServiceId)
                                    disc_percent2 = String(result.offnetAvailablePackets[i].discount!.discountPercent)
                                }
                                self.minuti_data.append([String(result.offnetAvailablePackets[i].id), String(result.offnetAvailablePackets[i].packetName  ?? ""), String(result.offnetAvailablePackets[i].price),  String(result.offnetAvailablePackets[i].packetStatus), String(result.offnetAvailablePackets[i].nextApplyDate ?? "") , String(result.offnetAvailablePackets[i].description ?? ""),String(result.offnetAvailablePackets[i].period ?? ""), "available", disc_id2, disc_percent2])
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                            emptyView = EmptyView(frame: CGRect(x: 0, y: 30, width: self.table2.frame.width, height: self.table2.frame.height), text: self.defaultLocalizer.stringForKey(key: "No_minutes"))
                            self.table2.separatorStyle = .none
                            self.table2.backgroundView = emptyView
                            }
                        }
                        
                        if result.smsAvailablePackets.count != 0 {
                            for i in 0 ..< result.smsAvailablePackets.count {
                                var disc_id3 = ""
                                var disc_percent3 = ""
                                if result.smsAvailablePackets[i].discount != nil {
                                    disc_id3 = String(result.smsAvailablePackets[i].discount!.discountServiceId)
                                    disc_percent3 = String(result.smsAvailablePackets[i].discount!.discountPercent)
                                }
                                self.sms_data.append([String(result.smsAvailablePackets[i].id), String(result.smsAvailablePackets[i].packetName ?? ""), String(result.smsAvailablePackets[i].price),  String(result.smsAvailablePackets[i].packetStatus), String(result.smsAvailablePackets[i].nextApplyDate ?? ""), String(result.smsAvailablePackets[i].description ?? ""), String(result.smsAvailablePackets[i].period ?? ""), "available", disc_id3, disc_percent3])
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                            emptyView = EmptyView(frame: CGRect(x: 0, y: 30, width: self.table3.frame.width, height: self.table3.frame.height), text: self.defaultLocalizer.stringForKey(key: "No_SMS"))
                            self.table3.separatorStyle = .none
                            self.table3.backgroundView = emptyView
                            }
                        }
                    }
                },
                onError: { error in
                   print(error.localizedDescription)
                    DispatchQueue.main.async { [self] in
                        setupView()
                        setupRemaindersSection()
                        setupTabCollectionView()
                        hideActivityIndicator(uiView: self.view)
                        requestAnswer(status: false, message: defaultLocalizer.stringForKey(key: "service is temporarily unavailable"), type_request: "")
                    }
                },
                onCompleted: {
                    DispatchQueue.main.async { [self] in
                        setupView()
                        setupRemaindersSection()
                        setupTabCollectionView()
                        hideActivityIndicator(uiView: self.view)
                    }
                   print("Completed event.")
                    
                }).disposed(by: disposeBag)
              }
              catch{
            }
        
    }
    
    @objc func connectPackets(_ sender: UIButton) {
      
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
        
        var checkColor = UIColor.black
        
        if UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" {
            checkColor = .white
        }
        else {
            checkColor = .black
        }
        view.image_icon.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "Service_Default_dark") : UIImage(named: "Service_Default"))
        if addional_view.tab1.textColor == checkColor {
            if internet_data[sender.tag][7] == "connected"  {
                view.name.text = defaultLocalizer.stringForKey(key: "Disable_service")
                view.name_content.text = "\(defaultLocalizer.stringForKey(key: "Disable_service2")) \"\(internet_data[sender.tag][1])\" \(defaultLocalizer.stringForKey(key: "Disable_service2_1"))?"
                view.ok.setTitle(defaultLocalizer.stringForKey(key: "Disable"), for: .normal)
                view.ok.addTarget(self, action: #selector(disablePackets(_:)), for: .touchUpInside)
            }
            else {
                view.name.text = defaultLocalizer.stringForKey(key: "Connect_service")
                view.name_content.text = "\(defaultLocalizer.stringForKey(key: "Connect_service2")) \"\(internet_data[sender.tag][1])\" \(defaultLocalizer.stringForKey(key: "Connect_service2_1"))"
                view.ok.setTitle(defaultLocalizer.stringForKey(key: "Connect"), for: .normal)
                view.ok.addTarget(self, action: #selector(okClickDialog), for: .touchUpInside)
            }
        } else if addional_view.tab2.textColor == checkColor{
            if minuti_data[sender.tag][7] == "connected"  {
                view.name.text = defaultLocalizer.stringForKey(key: "Disable_service")
                view.name_content.text = "\(defaultLocalizer.stringForKey(key: "Disable_service2")) \"\(minuti_data[sender.tag][1])\" \(defaultLocalizer.stringForKey(key: "Disable_service2_1"))?"
                view.ok.setTitle(defaultLocalizer.stringForKey(key: "Disable"), for: .normal)
                view.ok.addTarget(self, action: #selector(disablePackets(_:)), for: .touchUpInside)
            }
            else {
                view.name.text = defaultLocalizer.stringForKey(key: "Connect_service")
                view.name_content.text = "\(defaultLocalizer.stringForKey(key: "Connect_service2")) \"\(minuti_data[sender.tag][1])\" \(defaultLocalizer.stringForKey(key: "Connect_service2_1"))"
                view.ok.setTitle(defaultLocalizer.stringForKey(key: "Connect"), for: .normal)
                view.ok.addTarget(self, action: #selector(okClickDialog), for: .touchUpInside)
            }
        } else {
            if sms_data[sender.tag][7] == "connected" {
                view.name.text = defaultLocalizer.stringForKey(key: "Disable_service")
                view.name_content.text = "\(defaultLocalizer.stringForKey(key: "Disable_service2")) \"\(sms_data[sender.tag][1])\" \(defaultLocalizer.stringForKey(key: "Disable_service2_1"))?"
                view.ok.setTitle(defaultLocalizer.stringForKey(key: "Disable"), for: .normal)
                view.ok.addTarget(self, action: #selector(disablePackets(_:)), for: .touchUpInside)
            }
            else {
                view.name.text = defaultLocalizer.stringForKey(key: "Connect_service")
                view.name_content.text = "\(defaultLocalizer.stringForKey(key: "Connect_service2")) \"\(sms_data[sender.tag][1])\" \(defaultLocalizer.stringForKey(key: "Connect_service2_1"))"
                view.ok.setTitle(defaultLocalizer.stringForKey(key: "Connect"), for: .normal)
                view.ok.addTarget(self, action: #selector(okClickDialog), for: .touchUpInside)
            }
        }
        
        view.ok.tag = sender.tag
        view.cancel.addTarget(self, action: #selector(dismissDialogCancel), for: .touchUpInside)
        
        alert.view.backgroundColor = .clear
        alert.view.addSubview(view)
        //alert.view.sendSubviewToBack(view)
        
        sender.showAnimation { [self] in
            present(alert, animated: true, completion: nil)
        }
       // sender.backgroundColor = .clear
        
    }
    
    @objc func requestAnswer(status: Bool, message: String, type_request: String) {
        
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
            if type_request == "post" {
                view.name.text = defaultLocalizer.stringForKey(key: "service_connected")
                view.image_icon.image = UIImage(named: "correct_alert")
            }
            else {
                view.name.text = defaultLocalizer.stringForKey(key: "service_disabled")
                view.image_icon.image = UIImage(named: "correct_alert")
            }
            view.ok.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
        }
        else {
            view.name.text = defaultLocalizer.stringForKey(key: "error_title")
            view.image_icon.image = UIImage(named: "uncorrect_alert")
            view.ok.addTarget(self, action: #selector(dismissDialogCancel), for: .touchUpInside)
        }
        
        view.name_content.text = "\(message)"
        view.ok.setTitle("OK", for: .normal)
        
        alert.view.backgroundColor = .clear
        alert.view.addSubview(view)
        //alert.view.sendSubviewToBack(view)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func dismissDialog(_ sender: UIButton) {
        print("hello")
        alert.dismiss(animated: true, completion: nil)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(AddionalTraficsViewController(), animated: false)
        hideActivityIndicator(uiView: view)
    }
    
    @objc func dismissDialogCancel(_ sender: UIButton) {
        print(sender.backgroundColor)
        
       
        sender.showAnimation { [self] in
            alert.dismiss(animated: true, completion: nil)
            //hideActivityIndicator(uiView: view)
        }
        hideActivityIndicator(uiView: view)
    }
    
    @objc func okClickDialog(_ sender: UIButton) {
        
        alert.dismiss(animated: true, completion: nil)
        showActivityIndicator(uiView: view)
        
        var parametr: [String: Any] = ["packetId": 0, "discountId": discount_id]
        
        var checkColor = UIColor.black
        
        if UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" {
            checkColor = .white
        }
        else {
            checkColor = .black
        }
        
        if addional_view.tab1.textColor == checkColor {
            parametr = ["packetId": internet_data[sender.tag][0], "discountId": discount_id]
        } else if addional_view.tab2.textColor == checkColor {
            parametr = ["packetId": Int(minuti_data[sender.tag][0]), "discountId": discount_id]
        } else {
            parametr = ["packetId": Int(sms_data[sender.tag][0]), "discountId": discount_id]
        }
        
         let client = APIClient.shared
             do{
               try client.packetConnect(jsonBody: parametr).subscribe(
                 onNext: { [self] result in
                   print(result)
                     DispatchQueue.main.async {
                         if result.success == true {
                             requestAnswer(status: true, message: String(result.message ?? ""), type_request: "post")
                         }
                         else {
                             requestAnswer(status: false, message: String(result.message ?? ""), type_request: "post")
                         }
                     }
                    
                 },
                 onError: { [self] error in
                     DispatchQueue.main.async {
                         requestAnswer(status: false, message: defaultLocalizer.stringForKey(key: "service is temporarily unavailable"), type_request: "post")
                         print(error.localizedDescription)
                     }
                 },
                 onCompleted: { [self] in
                    // sender.hideLoading()
                     
                    print("Completed event.")
                     
                 }).disposed(by: disposeBag)
               }
               catch{
                   print("hhhhkk;okok")
             }
    }
    
    
    @objc func disablePackets(_ sender: UIButton) {
        alert.dismiss(animated: true, completion: nil)
        showActivityIndicator(uiView: view)
        
        var parametr = ""
        
        var checkColor = UIColor.black
        
        if UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" {
            checkColor = .white
        }
        else {
            checkColor = .black
        }
        
        if addional_view.tab1.textColor == checkColor {
            parametr = internet_data[sender.tag][0]
        } else if addional_view.tab2.textColor == checkColor {
            parametr = minuti_data[sender.tag][0]
        } else {
            parametr = sms_data[sender.tag][0]
        }
        
        let client = APIClient.shared
            do{
                try client.disableConnect(parametr: parametr).subscribe(
                onNext: { [self] result in
                  print(result)
                    DispatchQueue.main.async {
                        if result.success == true {
                            requestAnswer(status: true, message: String(result.message ?? ""), type_request: "delete")
                        }
                        else {
                            requestAnswer(status: false, message: String(result.message ?? ""), type_request: "delete")
                        }
                    }
                },
                onError: { error in
                   print(error.localizedDescription)
                    DispatchQueue.main.async { [self] in
                        requestAnswer(status: false, message: defaultLocalizer.stringForKey(key: "service is temporarily unavailable"), type_request: "delete")
                        print(error.localizedDescription)
                        
                    }
                },
                onCompleted: { [self] in
                    
                   print("Completed event.")
                    
                }).disposed(by: disposeBag)
              }
              catch{
            }
    }
}

extension AddionalTraficsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tabs", for: indexPath) as! TabCollectionServiceViewCell
        if indexPath.row == 0 {
            table.register(ServicesTableViewCell.self, forCellReuseIdentifier: cellID4)
            table.frame = CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width - 20, height: UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 110 + (topPadding ?? 0) + (bottomPadding ?? 0)))
            table.delegate = self
            table.dataSource = self
            table.rowHeight = 140
            table.estimatedRowHeight = 140
            table.alwaysBounceVertical = false
            table.showsVerticalScrollIndicator = false
            table.backgroundColor = contentColor
            table.separatorColor = .lightGray
            table.allowsSelection = false
            cell.addSubview(table)
        }
        else if indexPath.row == 1 {
            table2.register(ServicesTableViewCell.self, forCellReuseIdentifier: cellID4)
            table2.frame = CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width - 20, height: UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 110 + (topPadding ?? 0) + (bottomPadding ?? 0)))
            table2.delegate = self
            table2.dataSource = self
            table2.rowHeight = 140
            table2.estimatedRowHeight = 140
            table2.alwaysBounceVertical = false
            table2.showsVerticalScrollIndicator = false
            table2.backgroundColor = contentColor
            table2.separatorColor = .lightGray
            table2.allowsSelection = false
            cell.addSubview(table2)
        }
        else if indexPath.row == 2 {
            table3.register(ServicesTableViewCell.self, forCellReuseIdentifier: cellID4)
            table3.frame = CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width - 20, height: UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 110 + (topPadding ?? 0) + (bottomPadding ?? 0)))
            table3.delegate = self
            table3.dataSource = self
            table3.rowHeight = 140
            table3.estimatedRowHeight = 140
            table3.alwaysBounceVertical = false
            table3.showsVerticalScrollIndicator = false
            table3.backgroundColor = contentColor
            table3.separatorColor = .lightGray
            table3.allowsSelection = false
            cell.addSubview(table3)
          
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
      
        if indexPath.row == 0 {
            addional_view.tab1.textColor = colorBlackWhite
            addional_view.tab2.textColor = .gray
            addional_view.tab3.textColor = .gray
            addional_view.tab1Line.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
            addional_view.tab2Line.backgroundColor = .clear
            addional_view.tab3Line.backgroundColor = .clear
            activePage = 0
        }
       else if indexPath.row == 1 {
            addional_view.tab1.textColor = .gray
            addional_view.tab2.textColor = colorBlackWhite
            addional_view.tab3.textColor = .gray
            addional_view.tab1Line.backgroundColor = .clear
            addional_view.tab2Line.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
            addional_view.tab3Line.backgroundColor = .clear
        }
        else if indexPath.row == 2 {
            addional_view.tab1.textColor = .gray
            addional_view.tab2.textColor = .gray
            addional_view.tab3.textColor = colorBlackWhite
            addional_view.tab1Line.backgroundColor = .clear
            addional_view.tab2Line.backgroundColor = .clear
            addional_view.tab3Line.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
            activePage = 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //print(indexPath.row == 0)
        if indexPath.row == 0 {
            addional_view.tab1.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
            addional_view.tab2.textColor = colorBlackWhite
            addional_view.tab3.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
            addional_view.tab1Line.backgroundColor = .clear
            addional_view.tab2Line.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
            addional_view.tab3Line.backgroundColor = .clear
        }
        else if indexPath.row == 1 {
            if activePage == 0  {
                addional_view.tab1.textColor = colorBlackWhite
                addional_view.tab2.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
                addional_view.tab3.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
                addional_view.tab1Line.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
                addional_view.tab2Line.backgroundColor = .clear
                addional_view.tab3Line.backgroundColor = .clear
            }
            else if activePage == 2 {
                addional_view.tab1.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
                addional_view.tab2.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
                addional_view.tab3.textColor = colorBlackWhite
                addional_view.tab1Line.backgroundColor = .clear
                addional_view.tab2Line.backgroundColor = .clear
                addional_view.tab3Line.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
            }
        }
        else if indexPath.row == 2 {
            addional_view.tab1.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
            addional_view.tab2.textColor = colorBlackWhite
            addional_view.tab3.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
            addional_view.tab1Line.backgroundColor = .clear
            addional_view.tab2Line.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
            addional_view.tab3Line.backgroundColor = .clear
        }
    }
}

extension AddionalTraficsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == table {
            return internet_data.count
        } else if tableView == table2 {
            return minuti_data.count
        } else {
            return sms_data.count
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: cellID4, for: indexPath) as! ServicesTableViewCell
        cell.separatorInset = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        if tableView == table {
            if indexPath.row == internet_data.count - 1 {
              //  cell.separatorInset = UIEdgeInsets.init(top: -10, left: UIScreen.main.bounds.size.width, bottom: -10, right: 0)
            }
            
            if internet_data[indexPath.row][7] == "connected" {
                let dateFormatter1 = DateFormatter()
                dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                let date = dateFormatter1.date(from: internet_data[indexPath.row][4])
                dateFormatter1.dateFormat = "dd-MM-yyyy"
                var next_apply_date  =  ""
                if internet_data[indexPath.row][4] != "" {
                    next_apply_date = self.defaultLocalizer.stringForKey(key: "Active_before:") + "\(dateFormatter1.string(from: date!))"
                    cell.titleTwo.text = internet_data[indexPath.row][5] + "\n" + next_apply_date
                }
                else {
                    cell.titleTwo.text = internet_data[indexPath.row][5]
                }
                cell.getButton.backgroundColor = .clear
                cell.getButton.setTitle(defaultLocalizer.stringForKey(key: "Disable"), for: .normal)
                cell.getButton.setTitleColor(UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00), for: .normal)
                cell.getButton.layer.borderColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00).cgColor
                cell.getButton.layer.borderWidth = 1
                cell.ico_image.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "Service_Active_dark") : UIImage(named: "Service_Active"))
            
            }
            else {
                cell.titleTwo.text = internet_data[indexPath.row][5]
                cell.getButton.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
                cell.getButton.setTitle(defaultLocalizer.stringForKey(key: "Connect"), for: .normal)
                cell.getButton.setTitleColor(.white, for: .normal)
                cell.ico_image.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "Service_Default_dark") : UIImage(named: "Service_Default"))
            }
            cell.titleOne.text = internet_data[indexPath.row][1]
            
            cell.titleTwo.frame.size.height = CGFloat.greatestFiniteMagnitude
            cell.titleTwo.numberOfLines = 0
            cell.titleTwo.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.titleTwo.sizeToFit()
          
            cell.titleTwo.frame.origin.y = 60
            
            cell.contentView.frame.size = CGSize(width: view.frame.width, height: cell.titleTwo.frame.height + 70)
            
            cell.titleThree.frame.origin.y =  cell.titleTwo.frame.size.height + 60
            cell.sale_title.frame.origin.y = cell.titleTwo.frame.size.height + 80
            cell.getButton.frame.origin.y = cell.titleTwo.frame.size.height + 70
            cell.frame.size.height = cell.titleTwo.frame.height + 120
            table.rowHeight = cell.titleTwo.frame.height + 120
            
            let cost: NSString = "\(internet_data[indexPath.row][2])" as NSString
            let range = (cost).range(of: cost as String)
            let costString = NSMutableAttributedString.init(string: cost as String)
            costString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange , range: range)
            costString.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], range: range)
            
            var  period = " " + defaultLocalizer.stringForKey(key: "TJS") + "/" + internet_data[indexPath.row][6].uppercased()
            if internet_data[indexPath.row][6] == "" || internet_data[indexPath.row][6] == "0.0" {
                period = " " + defaultLocalizer.stringForKey(key: "TJS")
            }
            else {
                period = " " + defaultLocalizer.stringForKey(key: "TJS") +  "/" + internet_data[indexPath.row][6].uppercased()
            }
            
            let title_cost = period as NSString
            let titleString = NSMutableAttributedString.init(string: title_cost as String)
            let range2 = (title_cost).range(of: title_cost as String)
            titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: darkGrayLight , range: range2)
            titleString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)], range: range2)
            
            costString.append(titleString)
            cell.titleThree.attributedText = costString
            
            cell.sale_title.frame.origin.x = CGFloat((cell.titleThree.text!.count * 7) + 80) ?? 150
            
            if internet_data[indexPath.row][9] != "" {
                cell.sale_title.text = "-" + internet_data[indexPath.row][9] + "%"
                cell.sale_title.isHidden = false
            }
            else {
                cell.sale_title.isHidden = true
            }
            
            cell.getButton.tag = indexPath.row
            cell.getButton.animateWhenPressed(disposeBag: disposeBag)
            cell.getButton.addTarget(self, action: #selector(connectPackets(_:)), for: .touchUpInside)
        }
        else if tableView == table2 {
            
            if indexPath.row == minuti_data.count - 1 {
               // cell.separatorInset = UIEdgeInsets.init(top: -10, left: UIScreen.main.bounds.size.width, bottom: -10, right: 0)
            }
            
            if minuti_data[indexPath.row][7] == "connected"  {
                let dateFormatter1 = DateFormatter()
                dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                let date = dateFormatter1.date(from: minuti_data[indexPath.row][4])
                dateFormatter1.dateFormat = "dd-MM-yyyy"
                
                var next_apply_date  =  ""
                if minuti_data[indexPath.row][4] != "" {
                    next_apply_date = self.defaultLocalizer.stringForKey(key: "Active_before:") + "\(dateFormatter1.string(from: date!))"
                    cell.titleTwo.text = minuti_data[indexPath.row][5] + "\n" + next_apply_date
                }
                else {
                    cell.titleTwo.text = minuti_data[indexPath.row][5]
                }
                
                cell.getButton.backgroundColor = .clear
                cell.getButton.setTitle(defaultLocalizer.stringForKey(key: "Disable"), for: .normal)
                cell.getButton.setTitleColor(UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00), for: .normal)
                cell.getButton.layer.borderColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00).cgColor
                cell.getButton.layer.borderWidth = 1
                cell.ico_image.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "Service_Active_dark") : UIImage(named: "Service_Active"))
            }
            else {
                cell.titleTwo.text = minuti_data[indexPath.row][5]
                cell.getButton.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
                cell.getButton.setTitle(defaultLocalizer.stringForKey(key: "Connect"), for: .normal)
                cell.getButton.setTitleColor(.white, for: .normal)
                cell.ico_image.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "Service_Default_dark") : UIImage(named: "Service_Default"))
            }
            
            cell.titleTwo.frame.size.height = CGFloat.greatestFiniteMagnitude
            cell.titleTwo.numberOfLines = 0
            cell.titleTwo.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.titleTwo.sizeToFit()
          
            cell.titleTwo.frame.origin.y = 60
            
            cell.contentView.frame.size = CGSize(width: view.frame.width, height: cell.titleTwo.frame.height + 70)
            
            cell.titleThree.frame.origin.y =  cell.titleTwo.frame.size.height + 60
            cell.sale_title.frame.origin.y = cell.titleTwo.frame.size.height + 80
            cell.getButton.frame.origin.y = cell.titleTwo.frame.size.height + 70
            cell.frame.size.height = cell.titleTwo.frame.height + 120
            table2.rowHeight = cell.titleTwo.frame.height + 120
            
            cell.titleOne.text = minuti_data[indexPath.row][1]
            let cost: NSString = "\(minuti_data[indexPath.row][2])" as NSString
            let range = (cost).range(of: cost as String)
            let costString = NSMutableAttributedString.init(string: cost as String)
            costString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange , range: range)
            costString.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], range: range)
            
            var  period = " " + defaultLocalizer.stringForKey(key: "TJS") + "/" + minuti_data[indexPath.row][6].uppercased()
            if minuti_data[indexPath.row][6] == "" || minuti_data[indexPath.row][6] == "0.0" {
                period = " " + defaultLocalizer.stringForKey(key: "TJS")
            }
            else {
                period = " " + defaultLocalizer.stringForKey(key: "TJS") + "/" + minuti_data[indexPath.row][6].uppercased()
            }
            
            let title_cost = period as NSString
            let titleString = NSMutableAttributedString.init(string: title_cost as String)
            let range2 = (title_cost).range(of: title_cost as String)
            titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: darkGrayLight , range: range2)
            titleString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)], range: range2)
            
            costString.append(titleString)
            cell.titleThree.attributedText = costString
            
            cell.sale_title.frame.origin.x = CGFloat((cell.titleThree.text!.count * 7) + 80) ?? 150
            
            if minuti_data[indexPath.row][9] != "" {
                cell.sale_title.text = "-" + minuti_data[indexPath.row][9] + "%"
                cell.sale_title.isHidden = false
            }
            else {
                cell.sale_title.isHidden = true
            }
            
            cell.getButton.tag = indexPath.row
            cell.getButton.animateWhenPressed(disposeBag: disposeBag)
            cell.getButton.addTarget(self, action: #selector(connectPackets(_:)), for: .touchUpInside)
        }
        else {
            if indexPath.row == sms_data.count - 1 {
               // cell.separatorInset = UIEdgeInsets.init(top: -10, left: UIScreen.main.bounds.size.width, bottom: -10, right: 0)
            }
            
            if sms_data[indexPath.row][7] == "connected" {
                let dateFormatter1 = DateFormatter()
                dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                let date = dateFormatter1.date(from: sms_data[indexPath.row][4])
                dateFormatter1.dateFormat = "dd-MM-yyyy"
                
                var next_apply_date  =  ""
                if sms_data[indexPath.row][4] != "" {
                    next_apply_date = self.defaultLocalizer.stringForKey(key: "Active_before:") + "\(dateFormatter1.string(from: date!))"
                    cell.titleTwo.text = sms_data[indexPath.row][5] + "\n" + next_apply_date
                }
                else {
                    cell.titleTwo.text = sms_data[indexPath.row][5]
                }
                
                cell.getButton.backgroundColor = .clear
                cell.getButton.setTitle(defaultLocalizer.stringForKey(key: "Disable"), for: .normal)
                cell.getButton.setTitleColor(UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00), for: .normal)
                cell.getButton.layer.borderColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00).cgColor
                cell.getButton.layer.borderWidth = 1
                cell.ico_image.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "Service_Active_dark") : UIImage(named: "Service_Active"))
            }
            else {
                cell.titleTwo.text = sms_data[indexPath.row][5]
                cell.getButton.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
                cell.getButton.setTitle(defaultLocalizer.stringForKey(key: "Connect"), for: .normal)
                cell.getButton.setTitleColor(.white, for: .normal)
                cell.ico_image.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "Service_Default_dark") : UIImage(named: "Service_Default"))
            }
            
            cell.titleOne.text = sms_data[indexPath.row][1]
            
            cell.titleTwo.frame.size.height = CGFloat.greatestFiniteMagnitude
            cell.titleTwo.numberOfLines = 0
            cell.titleTwo.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.titleTwo.sizeToFit()
          
            cell.titleTwo.frame.origin.y = 60

            cell.contentView.frame.size = CGSize(width: view.frame.width, height: cell.titleTwo.frame.height + 70)
            
            cell.titleThree.frame.origin.y =  cell.titleTwo.frame.size.height + 60
            cell.sale_title.frame.origin.y = cell.titleTwo.frame.size.height + 80
            cell.getButton.frame.origin.y = cell.titleTwo.frame.size.height + 70
            cell.frame.size.height = cell.titleTwo.frame.height + 120
            table3.rowHeight = cell.titleTwo.frame.height + 120
            
            let cost: NSString = "\(sms_data[indexPath.row][2])" as NSString
            let range = (cost).range(of: cost as String)
            let costString = NSMutableAttributedString.init(string: cost as String)
            costString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange , range: range)
            costString.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], range: range)
            
            var  period = " " + defaultLocalizer.stringForKey(key: "TJS") + "/" + sms_data[indexPath.row][6].uppercased()
            if sms_data[indexPath.row][6] == "" || sms_data[indexPath.row][6] == "0.0" {
                period = " " + defaultLocalizer.stringForKey(key: "TJS")
            }
            else {
                period = " " + defaultLocalizer.stringForKey(key: "TJS") + "/" + sms_data[indexPath.row][6].uppercased()
            }
            
            let title_cost = period as NSString
            let titleString = NSMutableAttributedString.init(string: title_cost as String)
            let range2 = (title_cost).range(of: title_cost as String)
            titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: darkGrayLight , range: range2)
            titleString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)], range: range2)
            
            costString.append(titleString)
            cell.titleThree.attributedText = costString
            
            cell.sale_title.frame.origin.x = CGFloat((cell.titleThree.text!.count * 7) + 80) ?? 150
            
            if sms_data[indexPath.row][9] != "" {
                cell.sale_title.text = "-" + sms_data[indexPath.row][9] + "%"
                cell.sale_title.isHidden = false
            }
            else {
                cell.sale_title.isHidden = true
            }
            
            cell.getButton.tag = indexPath.row
            cell.getButton.animateWhenPressed(disposeBag: disposeBag)
            cell.getButton.addTarget(self, action: #selector(connectPackets(_:)), for: .touchUpInside)
        }
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = .clear
        cell.selectedBackgroundView = bgColorView
        
        return cell
        
    }
    
    
}
