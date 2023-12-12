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
    
    let tableMB = UITableView()
    let tableMin = UITableView()
    let tableSms = UITableView()
    
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
        addional_view.balanceValue.text = balance_credit + " " + defaultLocalizer.stringForKey(key: "tjs")
        
      
        //added autolayout
        
        addional_view.balanceValue.translatesAutoresizingMaskIntoConstraints = false
        addional_view.balanceLabel.translatesAutoresizingMaskIntoConstraints = false
      
        //balanceLabel
        addional_view.balanceLabel.leadingAnchor.constraint(equalTo: addional_view.leadingAnchor, constant: 20).isActive = true
        addional_view.balanceLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
        addional_view.balanceLabel.topAnchor.constraint(equalTo: addional_view.topAnchor, constant: 160).isActive = true

        //balanceValue
        addional_view.balanceValue.trailingAnchor.constraint(equalTo: addional_view.trailingAnchor, constant: -20).isActive = true
        addional_view.balanceValue.centerYAnchor.constraint(equalTo:  addional_view.balanceLabel.centerYAnchor).isActive = true
        addional_view.balanceValue.heightAnchor.constraint(equalToConstant: 28).isActive = true
        addional_view.balanceValue.topAnchor.constraint(equalTo: addional_view.topAnchor, constant: 160).isActive = true

        
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
        if self.scrollView == scrollView || tableMB == scrollView || tableMin == scrollView || tableSms == scrollView {
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
                                emptyView = EmptyView(frame: CGRect(x: 0, y: 30, width: self.tableMB.frame.width, height: self.tableMB.frame.height), text: self.defaultLocalizer.stringForKey(key: "No_internet"))
                            self.tableMB.separatorStyle = .none
                            self.tableMB.backgroundView = emptyView
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
                            emptyView = EmptyView(frame: CGRect(x: 0, y: 30, width: self.tableMin.frame.width, height: self.tableMin.frame.height), text: self.defaultLocalizer.stringForKey(key: "No_minutes"))
                            self.tableMin.separatorStyle = .none
                            self.tableMin.backgroundView = emptyView
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
                            emptyView = EmptyView(frame: CGRect(x: 0, y: 30, width: self.tableSms.frame.width, height: self.tableSms.frame.height), text: self.defaultLocalizer.stringForKey(key: "No_SMS"))
                            self.tableSms.separatorStyle = .none
                            self.tableSms.backgroundView = emptyView
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
            tableMB.register(ServicesTableViewCell.self, forCellReuseIdentifier: cellID4)
            tableMB.frame = CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width - 20, height: UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 110 + (topPadding ?? 0) + (bottomPadding ?? 0)))
            tableMB.delegate = self
            tableMB.dataSource = self
            tableMB.rowHeight = UITableView.automaticDimension
            tableMB.estimatedRowHeight = 140 // Примерное значение высоты ячейки
            tableMB.alwaysBounceVertical = false
            tableMB.showsVerticalScrollIndicator = false
            tableMB.backgroundColor = contentColor
            tableMB.separatorColor = .lightGray
            tableMB.allowsSelection = false
            cell.addSubview(tableMB)
        }
        else if indexPath.row == 1 {
            tableMin.register(ServicesTableViewCell.self, forCellReuseIdentifier: cellID4)
            tableMin.frame = CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width - 20, height: UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 110 + (topPadding ?? 0) + (bottomPadding ?? 0)))
            tableMin.delegate = self
            tableMin.dataSource = self
            tableMin.rowHeight = UITableView.automaticDimension
            tableMin.estimatedRowHeight = 140 // Примерное значение высоты ячейки
            tableMin.alwaysBounceVertical = false
            tableMin.showsVerticalScrollIndicator = false
            tableMin.backgroundColor = contentColor
            tableMin.separatorColor = .lightGray
            tableMin.allowsSelection = false
            cell.addSubview(tableMin)
        }
        else if indexPath.row == 2 {
            tableSms.register(ServicesTableViewCell.self, forCellReuseIdentifier: cellID4)
            tableSms.frame = CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width - 20, height: UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 110 + (topPadding ?? 0) + (bottomPadding ?? 0)))
            tableSms.delegate = self
            tableSms.dataSource = self
            tableSms.rowHeight = UITableView.automaticDimension
            tableSms.estimatedRowHeight = 140 // Примерное значение высоты ячейки
            tableSms.alwaysBounceVertical = false
            tableSms.showsVerticalScrollIndicator = false
            tableSms.backgroundColor = contentColor
            tableSms.separatorColor = .lightGray
            tableSms.allowsSelection = false
            cell.addSubview(tableSms)
          
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

// кол-во строк в таблиецах

    extension AddionalTraficsViewController: UITableViewDataSource, UITableViewDelegate {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if tableView == tableMB {
                return internet_data.count
            } else if tableView == tableMin {
                return minuti_data.count
            } else {
                return sms_data.count
            }

        }
    
        // проставляем данные,используя одну кастомную ячейку, в разбивке по таблицам в табах
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: cellID4, for: indexPath) as! ServicesTableViewCell
        cell.separatorInset = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
       
        if tableView == tableMB {
            if indexPath.row == internet_data.count - 1 {
              //  cell.separatorInset = UIEdgeInsets.init(top: -10, left: UIScreen.main.bounds.size.width, bottom: -10, right: 0)
            }
            cell.getButton.tag = indexPath.row
            cell.getButton.animateWhenPressed(disposeBag: disposeBag)
            cell.getButton.addTarget(self, action: #selector(connectPackets(_:)), for: .touchUpInside)
            
            // все операции проходят в configureCell
            cell.configureCell(with: internet_data[indexPath.row])

        }
        else if tableView == tableMin {
            
            if indexPath.row == minuti_data.count - 1 {
                // cell.separatorInset = UIEdgeInsets.init(top: -10, left: UIScreen.main.bounds.size.width, bottom: -10, right: 0)
            }
            
            cell.getButton.tag = indexPath.row
            cell.getButton.animateWhenPressed(disposeBag: disposeBag)
            cell.getButton.addTarget(self, action: #selector(connectPackets(_:)), for: .touchUpInside)
            
            // все операции проходят в configureCell
            cell.configureCell(with: minuti_data[indexPath.row])
        }
        else {
            if indexPath.row == sms_data.count - 1 {
               // cell.separatorInset = UIEdgeInsets.init(top: -10, left: UIScreen.main.bounds.size.width, bottom: -10, right: 0)
            }
         
            cell.getButton.tag = indexPath.row
            cell.getButton.animateWhenPressed(disposeBag: disposeBag)
            cell.getButton.addTarget(self, action: #selector(connectPackets(_:)), for: .touchUpInside)
            
            // все операции проходят в configureCell
            cell.configureCell(with: sms_data[indexPath.row])
        }
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = .clear
        cell.selectedBackgroundView = bgColorView
        
        return cell
        
    }
    
    
}
