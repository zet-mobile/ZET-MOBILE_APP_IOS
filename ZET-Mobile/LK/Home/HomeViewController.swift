//
//  ViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/2/21.
//

import UIKit
import SideMenu
import RxCocoa
import RxSwift
import Alamofire
import AlamofireImage


let cellID = "BalanceSliderCell"
let cellID2 = "sliderCell"
let cellID3 = "hotServices"
let cellID4 = "uslugiCell"

class HomeViewController: UIViewController, UIScrollViewDelegate {

    var halfModalTransitioningDelegate: HalfModalTransitioningTwoDelegate?
    
    let disposeBag = DisposeBag()
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    var alert = UIAlertController()
    
    private let scrollView = UIScrollView()
    var MyTarifPage = MyTarifViewController()
    
    var toolbar = Toolbar()
    var home_view = HomeView()
    let remainderView = RemainderStackView()
    
    var zero_help_view_show = false
    
    let BalanceSliderView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(BalanceSliderCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        return cv
    }()
    
    let SliderView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(SliderCollectionViewCell.self, forCellWithReuseIdentifier: cellID2)
        cv.showsHorizontalScrollIndicator = false
        
        return cv
    }()
    
    let HotServicesView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(HotServicesCollectionViewCell.self, forCellWithReuseIdentifier: cellID3)
        cv.showsHorizontalScrollIndicator = false
        
        return cv
    }()
    
    let ServicesTableView = UITableView()
    var user_name = ""
    var balance_credit = ""
    var tarif_name = ""
    var next_apply_date = ""
    
    var discount_id = ""
    var serviceId = ""
    var services_data = [[String]]()
    var slider_data = [[String]]()
    var hot_services_data = [[String]]()
    var remainders_data = [[String]]()
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        showActivityIndicator(uiView: self.view)
        view.backgroundColor = toolbarColor
        
        color2 = colorLightDarkGray
        color1 = contentColor
        
        sendMapRequest()
       // self.refreshGetToken()
        print(UserDefaults.standard.string(forKey: "token")!)
        print(UserDefaults.standard.string(forKey: "refresh_token")!)
        print(UserDefaults.standard.string(forKey: "mobPhone"))
                
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        if cellClick == "0" {
            
        }
        else if  cellClick == "1" {
            
        }
        else if cellClick == "2" {
            
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.pushViewController(AskFriendViewController(), animated: true)
        }
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        scrollView.refreshControl = refreshControl
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
    
    @objc func refresh(){
            // Code to refresh table view
            self.sendMapRequest()

    }
    
    @objc func openServices() {
        print("services")
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(ServicesViewController(), animated: true)
        
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
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + CGFloat((services_data.count * (Int(UIScreen.main.bounds.size.height) * 140) / 580)))
        view.addSubview(scrollView)
        scrollView.backgroundColor = colorLightDarkGray
        
        toolbar = Toolbar(frame: CGRect(x: 0, y: 44, width: UIScreen.main.bounds.size.width, height: 60))
        home_view = HomeView(frame: CGRect(x: 0, y: 360, width: UIScreen.main.bounds.size.width, height: CGFloat((services_data.count * 140)) + 500))
        toolbar.user_name.text = user_name
        
        if zero_help_view_show == false {
            home_view.zero_help_view.isHidden = true
            home_view.titleOne.frame.origin.y = 0
            home_view.titleTwo.frame.origin.y = 170
            home_view.titleThree.frame.origin.y = 370
            home_view.icon_more.frame.origin.y = 320
            home_view.icon_more_services.frame.origin.y = CGFloat((services_data.count * 140)) + 430
            home_view.white_view_back.frame.size.height = 440
            home_view.white_view_back2.frame.size.height = 500
            home_view.white_view_back2.frame.origin.y = 350
        }
        else {
            home_view.zero_help_view.isHidden = false
            home_view.titleOne.frame.origin.y = 170
            home_view.titleTwo.frame.origin.y = 340
            home_view.titleThree.frame.origin.y = 540
            home_view.icon_more.frame.origin.y = 490
            home_view.icon_more_services.frame.origin.y = CGFloat((services_data.count * 140)) + 600
            home_view.white_view_back.frame.size.height = 610
            home_view.white_view_back2.frame.size.height = 670
            home_view.white_view_back2.frame.origin.y = 520
        }
        
        toolbar.openmenu.addTarget(self, action: #selector(openMenu), for: .touchUpInside)
        toolbar.icon_more.addTarget(self, action: #selector(openProfileMenu), for: .touchUpInside)
        home_view.icon_more_services.addTarget(self, action: #selector(openServices), for: .touchUpInside)
        
        self.view.addSubview(toolbar)
        scrollView.addSubview(home_view)
        scrollView.frame = CGRect(x: 0, y: 104, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 104)
    }

    func setupBalanceSliderSection() {
        scrollView.addSubview(BalanceSliderView)
        BalanceSliderView.backgroundColor = .clear
        BalanceSliderView.frame = CGRect(x: 20, y: 0, width: UIScreen.main.bounds.size.width - 40, height: 210)
        BalanceSliderView.backgroundColor = .clear
        BalanceSliderView.delegate = self
        BalanceSliderView.dataSource = self
    }
    
    func setupRemaindersSection(){
        scrollView.addSubview(remainderView)
        remainderView.frame = CGRect(x: 0, y: 230, width: UIScreen.main.bounds.size.width, height: 145)
        
        var textColor = UIColor.black
        var textColor2 = UIColor.lightGray
        var number_data = ""
        
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
            textColor = .orange
            textColor2 = .lightGray
        }
        else {
            number_data = remainders_data[0][1]
        }
        var number_label: NSString = number_data as NSString
        var range = (number_label).range(of: number_label as String)
        var number_label_String = NSMutableAttributedString.init(string: number_label as String)
        number_label_String.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor , range: range)
        number_label_String.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)], range: range)
        
        var title_label = "\n \(defaultLocalizer.stringForKey(key: "minutes"))" as NSString
        var titleString = NSMutableAttributedString.init(string: title_label as String)
        var range2 = (title_label).range(of: title_label as String)
        titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor2, range: range2)
        titleString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)], range: range2)
        
        number_label_String.append(titleString)
        remainderView.minutesRemainder.text.attributedText = number_label_String
       
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
            textColor = .orange
            textColor2 = .lightGray
        }
        else {
            number_data = remainders_data[1][1]
        }
        number_label = number_data as NSString
        title_label = "\n \(defaultLocalizer.stringForKey(key: "megabyte"))" as NSString
        range = (number_label).range(of: number_label as String)
        number_label_String = NSMutableAttributedString.init(string: number_label as String)
        number_label_String.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: range)
        number_label_String.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)], range: range)
        
        titleString = NSMutableAttributedString.init(string: title_label as String)
        range2 = (title_label).range(of: title_label as String)
        titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor2, range: range2)
        titleString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)], range: range2)
        
        number_label_String.append(titleString)
        remainderView.internetRemainder.text.attributedText = number_label_String
        
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
            textColor = .orange
            textColor2 = .lightGray
        }
        else {
            number_data = remainders_data[2][1]
        }
        number_label = number_data as NSString
        title_label = "\n \(defaultLocalizer.stringForKey(key: "SMS"))" as NSString
        range = (number_label).range(of: number_label as String)
        number_label_String = NSMutableAttributedString.init(string: number_label as String)
        number_label_String.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: range)
        number_label_String.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)], range: range)
        
        titleString = NSMutableAttributedString.init(string: title_label as String)
        range2 = (title_label).range(of: title_label as String)
        titleString.addAttribute(NSAttributedString.Key.foregroundColor, value:textColor2, range: range2)
        titleString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)], range: range2)
        
        number_label_String.append(titleString)
        remainderView.messagesRemainder.text.attributedText = number_label_String
        
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
        
        remainderView.messagesRemainder.plusText.addTarget(self, action: #selector(openAddionalTraficsView), for: .touchUpInside)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openAddionalTraficsView))
        remainderView.messagesRemainder.isUserInteractionEnabled = true
        remainderView.messagesRemainder.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    func setupSliderSection() {
        scrollView.addSubview(SliderView)
        
        if zero_help_view_show == false {
            SliderView.frame = CGRect(x: 0, y: 550, width: UIScreen.main.bounds.size.width, height: 120)
        }
        else {
            SliderView.frame = CGRect(x: 0, y: 720, width: UIScreen.main.bounds.size.width, height: 120)
        }
        SliderView.backgroundColor = .clear
        SliderView.delegate = self
        SliderView.dataSource = self
    }
    
    func setupHotServicesSection() {
        scrollView.addSubview(HotServicesView)
        if zero_help_view_show == false {
            HotServicesView.frame = CGRect(x: 0, y: 400, width: UIScreen.main.bounds.size.width, height: 120)
        }
        else {
            HotServicesView.frame = CGRect(x: 0, y: 570, width: UIScreen.main.bounds.size.width, height: 120)
        }
        HotServicesView.backgroundColor = .clear
        HotServicesView.delegate = self
        HotServicesView.dataSource = self
    }
    
    func setupServicesTableView() {
        scrollView.addSubview(ServicesTableView)
        if zero_help_view_show == false {
            ServicesTableView.frame = CGRect(x: 0, y: 770, width: Int(UIScreen.main.bounds.size.width), height: (services_data.count * 140))
        }
        else {
            ServicesTableView.frame = CGRect(x: 0, y: 940, width: Int(UIScreen.main.bounds.size.width), height: (services_data.count * 140))
        }
        ServicesTableView.register(ServicesTableViewCell.self, forCellReuseIdentifier: cellID4)
        ServicesTableView.delegate = self
        ServicesTableView.dataSource = self
        ServicesTableView.rowHeight = 140
        ServicesTableView.estimatedRowHeight = 140
        ServicesTableView.isScrollEnabled = false
        ServicesTableView.backgroundColor = contentColor
        ServicesTableView.separatorColor = colorLine
      }
    
    @objc func openAddionalTraficsView() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(AddionalTraficsViewController(), animated: true)
    }
    
    @objc func openMenu() {
        // Define the menu
        let menu = SideMenuNavigationController(rootViewController: MenuViewController())
        menu.menuWidth = UIScreen.main.bounds.size.width - 110
    
        menu.presentationStyle = .menuSlideIn
        menu.view.layer.cornerRadius = 20
        present(menu, animated: true, completion: nil)
    }
    
    @objc func openProfileMenu() {
        let next = ProfilesMenuViewController()
        next.view.frame = (view.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)))
        self.halfModalTransitioningDelegate = HalfModalTransitioningTwoDelegate(viewController: self, presentingViewController: next)
        next.modalPresentationStyle = .custom
        //next.modalPresentationCapturesStatusBarAppearance = true
        
        next.transitioningDelegate = self.halfModalTransitioningDelegate
        present(next, animated: true, completion: nil)
    }
    
    func sendRequest() {
        let client = APIClient.shared
            do{
              try client.homeGetRequest().subscribe(
                onNext: { result in
                  print(result)
                    DispatchQueue.main.async {
                        self.balance_credit = String(result.subscriberBalance)
                        self.tarif_name = String(result.priceplan.priceplanName)
                        if result.priceplan.nextApplyDate != nil {
                            let dateFormatter1 = DateFormatter()
                            dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                            let date = dateFormatter1.date(from: String(result.priceplan.nextApplyDate!))
                            dateFormatter1.dateFormat = "dd.MM.yyyy"
                            self.next_apply_date = "Активен до: \(dateFormatter1.string(from: date!))"
                        }
                        
                        self.remainders_data.append([String(result.balances.offnet.start), String(result.balances.offnet.now), String(result.balances.offnet.unlim)])
                        self.remainders_data.append([String(result.balances.mb.start), String(result.balances.mb.now), String(result.balances.mb.unlim)])
                        self.remainders_data.append([String(result.balances.sms.start), String(result.balances.sms.now), String(result.balances.sms.unlim)])
                        
                        
                        if result.microServices.count != 0 {
                            for i in 0 ..< result.microServices.count {
                                self.hot_services_data.append([String(result.microServices[i].id), String(result.microServices[i].iconUrl), String(result.microServices[i].microServiceName)])
                            }
                        }
                        
                        if result.offers.count != 0 {
                            for i in 0 ..< result.offers.count {
                                self.slider_data.append([String(result.offers[i].id), String(result.offers[i].iconUrl), String(result.offers[i].url), String(result.offers[i].name)])
                            }
                        }
                        
                        if result.services.count != 0 {
                            for i in 0 ..< result.services.count {
                                var disc_id = ""
                                var disc_percent = ""
                                
                                if result.services[i].discount != nil {
                                    disc_id = String(result.services[i].discount!.discountServiceId)
                                    disc_percent = String(result.services[i].discount!.discountPercent)
                                }
                                
                                self.services_data.append([String(result.services[i].id), String(result.services[i].serviceName), String(result.services[i].price!),  String(result.services[i].period!), disc_id, disc_percent])
                            }
                        }
                    

                    }
                },
                onError: { error in
                   print(error.localizedDescription)
                    DispatchQueue.main.async {
                        self.requestAnswer(status: false, message: error.localizedDescription)
                        print(error.localizedDescription)
                        self.hideActivityIndicator(uiView: self.view)
                    }
                },
                onCompleted: {
                    DispatchQueue.main.async { [self] in
                        
                        setupView()
                        if remainders_data.count != 0 {
                            setupRemaindersSection()
                        }
                        setupServicesTableView()
                        setupBalanceSliderSection()
                        setupSliderSection()
                        setupHotServicesSection()
                        hideActivityIndicator(uiView: self.view)
                        refreshControl.endRefreshing()
                    }
                   print("Completed event.")
                    
                }).disposed(by: disposeBag)
              }
              catch{
            }
    }
    
    @objc func connectService(indexPath: Int) {
        print(indexPath)
        print("indexPath")
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
        view.name.text = defaultLocalizer.stringForKey(key: "Connect_service")
        view.name_content.text = "\(defaultLocalizer.stringForKey(key: "Connect_service"))\n \(services_data[indexPath][1])?"
        
        view.ok.tag = indexPath
        view.cancel.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
        view.ok.addTarget(self, action: #selector(okClickDialog), for: .touchUpInside)
        
        alert.view.backgroundColor = .clear
        alert.view.addSubview(view)
        //alert.view.sendSubviewToBack(view)
        
        present(alert, animated: true, completion: nil)
    
        
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
            view.name.text = "Услуга подключена!"
            view.image_icon.image = UIImage(named: "correct_alert")
        }
        else {
            view.name.text = "Что-то пошло не так"
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
        print("hello")
        sender.showAnimation { [self] in
            alert.dismiss(animated: true, completion: nil)
            hideActivityIndicator(uiView: view)
        }
    }
    
    @objc func okClickDialog(_ sender: UIButton) {
        
        sender.showAnimation { [self] in
            alert.dismiss(animated: true, completion: nil)
            showActivityIndicator(uiView: view)
        }
    
        print(sender.tag)
        let parametr: [String: Any] = ["serviceId": Int(services_data[sender.tag][0])!, "discountId": discount_id]
         let client = APIClient.shared
             do{
               try client.connectService(jsonBody: parametr).subscribe(
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
                    // sender.hideLoading()
                     
                    print("Completed event.")
                     
                 }).disposed(by: disposeBag)
               }
               catch{
             }
    }
    
    func sendMapRequest() {
        let client = APIClient.shared
            do{
              try client.supportGetRequest().subscribe(
                onNext: { result in
                  print(result)
                    DispatchQueue.main.async { [self] in
                        if result.offices.count != 0 {
                            for i in 0 ..< result.offices.count {
                               officesdata.append([String(result.offices[i].information ?? ""), String(result.offices[i].title ?? ""), String(result.offices[i].iconUrl), String(result.offices[i].officeType ?? ""), String(result.offices[i].latitude), String(result.offices[i].longitude), String(result.offices[i].officeTypeId)])
                            }
                        }
                        
                        if result.support.count != 0 {
                            for i in 0 ..< result.support.count {
                               supportdata.append([String(result.support[i].id), String(result.support[i].description ?? ""), String(result.support[i].url), String(result.support[i].iconUrl)])
                            }
                        }

                    }
                },
                onError: { error in
                   print(error.localizedDescription)
                    
                    DispatchQueue.main.async {
                        self.requestAnswer(status: false, message: error.localizedDescription)
                        print(error.localizedDescription)
                        self.hideActivityIndicator(uiView: self.view)
                    }
                },
                onCompleted: {
                    DispatchQueue.main.async {
                        if supportdata.count != 0 {
                            self.sendRequest()
                        }
                        else {
                            self.hideActivityIndicator(uiView: self.view)
                        }
                        
                    }
                   print("Completed event.")
                    
                }).disposed(by: disposeBag)
              }
              catch{
            }
    }

}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services_data.count
  }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID4, for: indexPath) as! ServicesTableViewCell
        cell.separatorInset = UIEdgeInsets.init(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
        
        if indexPath.row == services_data.count - 1 {
            cell.separatorInset = UIEdgeInsets.init(top: -10, left: UIScreen.main.bounds.size.width, bottom: -10, right: 0)
        }
        cell.titleOne.text = services_data[indexPath.row][1]
        let cost: NSString = "\(services_data[indexPath.row][2])" as NSString
        let range = (cost).range(of: cost as String)
        let costString = NSMutableAttributedString.init(string: cost as String)
        costString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange , range: range)
        costString.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], range: range)
        
        let title_cost = " С/" + services_data[indexPath.row][3].uppercased() as NSString
        let titleString = NSMutableAttributedString.init(string: title_cost as String)
        let range2 = (title_cost).range(of: title_cost as String)
        titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.darkGray , range: range2)
        titleString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)], range: range2)
        
        costString.append(titleString)
        cell.titleThree.attributedText = costString
        cell.sale_title.frame.origin.x = CGFloat((cell.titleThree.text!.count * 7) + 80) ?? 150
        if services_data[indexPath.row][5] != "" {
            cell.sale_title.text = "-" + services_data[indexPath.row][5] + "%"
            cell.sale_title.isHidden = false
        }
        else {
            cell.sale_title.isHidden = true
        }
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.00) : UIColor(red: 1.00, green: 0.98, blue: 0.94, alpha: 1.00))
        bgColorView.layer.borderColor = UIColor.orange.cgColor
        bgColorView.layer.borderWidth = 1
        bgColorView.layer.cornerRadius = 10
        cell.selectedBackgroundView = bgColorView
        
        cell.actionDelegate = (self as? CellActionDelegate)
        
        return cell
  }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == ServicesTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID4, for: indexPath) as! ServicesTableViewCell
            cell.getButton.tag = indexPath.row
            cell.getButton.addTarget(self, action: #selector(connectService), for: .touchUpInside)
        }
        else if tableView == AddBalanceOptionViewController().table {
            if indexPath.row == 0 {
                
            }
            else if indexPath.row == 1 {
                
            }
            else {
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                navigationController?.pushViewController(AskFriendViewController(), animated: true)
            }
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == BalanceSliderView {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
        else if collectionView == SliderView {
            return CGSize(width: collectionView.frame.width * 0.75, height: collectionView.frame.height * 0.75)
        }
        else {
            return CGSize(width: collectionView.frame.width * 0.2, height: collectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == BalanceSliderView {
            return 1
        }
        else if collectionView == SliderView {
            return slider_data.count
        }
        else {
            return hot_services_data.count
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == BalanceSliderView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! BalanceSliderCollectionViewCell
            print(indexPath.row)
            cell.balance.text = balance_credit + " с."
            cell.titleTarif.text = tarif_name
            cell.spisanie.text = next_apply_date
            
            cell.titleTarif.frame = CGRect(x: 20, y: 105, width: CGFloat(cell.titleTarif.text!.count * 10 + 20), height: 20)
            cell.settings.frame.origin.x = CGFloat(cell.titleTarif.text!.count * 10 + 40)
            let first = String(UserDefaults.standard.string(forKey: "mobPhone")!.prefix(2))
            let second = String(UserDefaults.standard.string(forKey: "mobPhone")!.prefix(5)).dropFirst(2)
            let third = String(String(UserDefaults.standard.string(forKey: "mobPhone")!.dropFirst(5))).prefix(2)

            print(UserDefaults.standard.string(forKey: "mobPhone"))
           
            cell.titleNumber.text = "(+992) \(first)-\(second)-\(third)-\(UserDefaults.standard.string(forKey: "mobPhone")!.dropFirst(7))"
            cell.actionDelegate = (self as CellBalanceActionDelegate)
            return cell
        }
        else if collectionView == SliderView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID2, for: indexPath) as! SliderCollectionViewCell
            print(indexPath.row)
           
            if slider_data.count != 0 {
                cell.image.af_setImage(withURL: URL(string: self.slider_data[indexPath.row][1])!)
            }
            else {
               cell.image.image = nil
            }
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID3, for: indexPath) as! HotServicesCollectionViewCell
            print(indexPath.row)
            /*if hot_services_data.count != 0 {
                cell.image.af_setImage(withURL: URL(string: self.hot_services_data[indexPath.row][1])!)
            }
            else {
               cell.image.image = nil
            }*/
            if hot_services_data[indexPath.row][0] == "2" {
                cell.image.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ?  UIImage(named: "hot_trafic_w") :  UIImage(named: "hot_trafic"))
            }
            else if hot_services_data[indexPath.row][0] == "3"  {
                cell.image.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ?  UIImage(named: "hot_change_w") :  UIImage(named: "hot_change"))
            }
            else if hot_services_data[indexPath.row][0] == "4"  {
                cell.image.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ?  UIImage(named: "hot_money_w") :  UIImage(named: "hot_money"))
            }
            else if hot_services_data[indexPath.row][0] == "5"  {
                cell.image.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ?  UIImage(named: "hot_help_w") :  UIImage(named: "hot_help"))
            }
            else if hot_services_data[indexPath.row][0] == "6" {
                cell.image.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ?  UIImage(named: "hot_detalization_w") :  UIImage(named: "hot_detalization"))
            }
            else if hot_services_data[indexPath.row][0] == "7" {
                cell.image.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ?  UIImage(named: "hot_search_w") :  UIImage(named: "hot_search"))
            }
            
            cell.titleOne.text = hot_services_data[indexPath.row][2]
            
            return cell
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        if collectionView == HotServicesView {
            if hot_services_data[indexPath.row][0] == "2" {
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                navigationController?.pushViewController(TraficTransferViewController(), animated: true)
            }
            else if hot_services_data[indexPath.row][0] == "3"  {
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                navigationController?.pushViewController(ChangeTransferViewController(), animated: true)
            }
            else if hot_services_data[indexPath.row][0] == "4"  {
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                navigationController?.pushViewController(MobileTransferViewController(), animated: true)
            }
            else if hot_services_data[indexPath.row][0] == "5"  {
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                navigationController?.pushViewController(ZeroHelpViewController(), animated: true)
            }
            else if hot_services_data[indexPath.row][0] == "6" {
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                navigationController?.pushViewController(DetalizationViewController(), animated: true)
            }
            else if hot_services_data[indexPath.row][0] == "7" {
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                navigationController?.pushViewController(SearchNumberViewController(), animated: true)
            }
        }
        else if collectionView == SliderView {
            open(scheme: slider_data[indexPath.row][2])
        }
        
    }
    
 
}

extension HomeViewController: CellBalanceActionDelegate {
    func didAddBalance(for cell: BalanceSliderCollectionViewCell) {
        let next = AddBalanceOptionViewController()
        next.view.frame = (view.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)))
        self.halfModalTransitioningDelegate = HalfModalTransitioningTwoDelegate(viewController: self, presentingViewController: next)
        next.modalPresentationStyle = .custom
        //next.modalPresentationCapturesStatusBarAppearance = true

        next.transitioningDelegate = self.halfModalTransitioningDelegate
        present(next, animated: true, completion: nil)
        
    }
    
    func didSettingTapped(for cell: BalanceSliderCollectionViewCell) {
        print("bbjbjj")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(MyTarifViewController(), animated: true)
        
        //AlertViewController().modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
             //   AlertViewController().modalTransitionStyle = UIModalTransitionStyle.crossDissolve
             //   present(AlertViewController(), animated: true, completion: nil)
    }
}

extension HomeViewController: CellActionDelegate {
    func didServiceConnect(for cell: ServicesTableViewCell) {
        if let indexPath = ServicesTableView.indexPath(for: cell) {
            connectService(indexPath: indexPath.row)
        }
    }
    
    func didServiceReconnect(for cell: ServicesConnectTableViewCell) {
        
    }
    
    
}
