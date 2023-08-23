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
import SnapKit
import RoundCoachMark


let cellID = "BalanceSliderCell"
let cellID2 = "sliderCell"
let cellID3 = "hotServices"
let cellID4 = "uslugiCell"

var hot_services_data = [[String]]()

class HomeViewController: UIViewController, UIScrollViewDelegate {

    var tap = UITapGestureRecognizer()
    var tappedState = false
    var preregInfoLabel = UILabel()
    var preregInfoLayout = UIView()
    
    private var coachMarker: CoachMarker?
    var marksContainer = UIView()
    var halfModalTransitioningDelegate: HalfModalTransitioningTwoDelegate?
    
    let disposeBag = DisposeBag()
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    var alert = UIAlertController()
    
    private let scrollView = UIScrollView()
    var MyTarifPage = MyTarifViewController()
    
    var toolbar = Toolbar()
    var home_view = HomeView()
    let remainderView = RemainderStackView()
    let circular = CircularProgressView()
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
    //added for prereg
    var preregStatus = false
    var user_name = ""
    var welcomePhrase = ""
    var balance_credit = ""
    var tarif_name = ""
    var next_apply_date = ""
    var mainBannerUrl = ""
    
    var discount_id = ""
    var serviceId = ""
    var services_data = [[String]]()
    var slider_data = [[String]]()
    var remainders_data = [[String]]()
    
    var refreshControl = UIRefreshControl()
    
    var table_height = 0
    
    let table_balance = UITableView()
    var tableData = [[String]]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = toolbarColor
        color2 = colorLightDarkGray
        color1 = contentColor
        
        tableData = [["icon1", defaultLocalizer.stringForKey(key: "Help_at_zero")]]
        
        sendMapRequest()
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(update))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        print(UserDefaults.standard.string(forKey: "token")!)
        print(UserDefaults.standard.string(forKey: "refresh_token")!)
        print(UserDefaults.standard.string(forKey: "mobPhone"))

                
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? .lightContent : .darkContent)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        tabBarController?.tabBar.isUserInteractionEnabled = true
        
        color2 = colorLightDarkGray
        color1 = contentColor
        
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
        // Code to refresh table viewё
        sendUpdateRequest()
        hideActivityIndicator(uiView: view)
        
    }
    
    @objc func update(){
        sendRequest()
    }
    
    @objc func openServices() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(ServicesViewController(), animated: true)
        
    }
    
    func setupView() {
        
        view.backgroundColor = toolbarColor
        table_height = 0
        if services_data.count != 0  {
            for i in 0 ..< services_data.count {
                if services_data[i][6] != "" {
                    table_height += ((services_data[i][6].count / 35) * 20) + 140

                } else {
                    table_height += 140
                }
            }
        }
        
        table_height += 20
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: view.frame.width, height: CGFloat(table_height) + 800)
    
        
        view.addSubview(scrollView)
        
        scrollView.backgroundColor = colorLightDarkGray
        
        home_view = HomeView(frame: CGRect(x: 0, y: 360, width: Int(UIScreen.main.bounds.size.width), height: table_height + 500))
     
        toolbar = Toolbar(frame: CGRect(x: 0, y: topPadding ?? 0, width: UIScreen.main.bounds.size.width, height: 60))
        if user_name.count > 30 {
            toolbar.user_name.font = UIFont.boldSystemFont(ofSize: (UIScreen.main.bounds.size.width * 14) / 390)
        }
        else {
            toolbar.user_name.font = UIFont.boldSystemFont(ofSize: (UIScreen.main.bounds.size.width * 18) / 390)
        }
        toolbar.user_name.text = user_name
    
        toolbar.welcome.text = welcomePhrase
        
        if count_notif != "0" {
            toolbar.icon_push.setTitle(count_notif, for: .normal)
            toolbar.icon_push.isHidden = false
        }
        else {
            toolbar.icon_push.isHidden = true
        }
        
      
        view.addSubview(toolbar)
        
        if zero_help_view_show == false {
            home_view.zero_help_view.isHidden = true
            home_view.titleOne.frame.origin.y = 0
            home_view.titleTwo.frame.origin.y = 170
            home_view.titleThree.frame.origin.y = 370
            home_view.icon_more.frame.origin.y = 320
            home_view.icon_more_services.frame.origin.y = CGFloat(table_height + 430)
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
            home_view.icon_more_services.frame.origin.y = CGFloat(table_height + 600)
            home_view.white_view_back.frame.size.height = 610
            home_view.white_view_back2.frame.size.height = 670
            home_view.white_view_back2.frame.origin.y = 520
        }
        
        toolbar.openmenu.addTarget(self, action: #selector(openMenu), for: .touchUpInside)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openMenu))
        toolbar.view_menu.isUserInteractionEnabled = true
        toolbar.view_menu.addGestureRecognizer(tapGestureRecognizer)
        
        toolbar.notificationRing.addTarget(self, action: #selector(openPushNotifications), for: .touchUpInside)
        toolbar.icon_push.addTarget(self, action: #selector(openPushNotifications), for: .touchUpInside)
        let tapGestureRecognizerRing = UITapGestureRecognizer(target: self, action: #selector(openPushNotifications))
        toolbar.view_notification.isUserInteractionEnabled = true
        toolbar.view_notification.addGestureRecognizer(tapGestureRecognizerRing)
        
       
        
       // toolbar.icon_more.addTarget(self, action: #selector(openProfileMenu), for: .touchUpInside)
        home_view.icon_more_services.addTarget(self, action: #selector(openServices), for: .touchUpInside)
        
        
        scrollView.addSubview(home_view)
    
        scrollView.frame = CGRect(x: 0, y: 60 + (topPadding ?? 0), width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 60 + (topPadding ?? 0) + (bottomPadding ?? 0)))
        

    }

    func setupBalanceSliderSection() {
        scrollView.addSubview(BalanceSliderView)
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
        var size = 18
        
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
            size = 30
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
        
        var title_label = "\n \(defaultLocalizer.stringForKey(key: "minutes"))" as NSString
        if remainders_data[0][3] != "" {
            title_label = "\n" + remainders_data[0][4] + " " + remainders_data[0][3] as NSString
        }
        
        var titleString = NSMutableAttributedString.init(string: title_label as String)
        var range2 = (title_label).range(of: title_label as String)
        titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor2, range: range2)
        titleString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)], range: range2)
        
        number_label_String.append(titleString)
        //remainderView.minutesRemainder.text.attributedText = number_label_String
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
        title_label = "\n \(defaultLocalizer.stringForKey(key: "megabyte"))" as NSString
        if remainders_data[1][3] != "" {
            title_label = "\n" + remainders_data[1][4] + " " + remainders_data[1][3] as NSString
        }
        
        range = (number_label).range(of: number_label as String)
        number_label_String = NSMutableAttributedString.init(string: number_label as String)
        number_label_String.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: range)
        number_label_String.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: CGFloat(size))], range: range)
        
        titleString = NSMutableAttributedString.init(string: title_label as String)
        range2 = (title_label).range(of: title_label as String)
        titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor2, range: range2)
        titleString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)], range: range2)
        
        number_label_String.append(titleString)
        //remainderView.internetRemainder.text.attributedText = number_label_String
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
        title_label = "\n \(defaultLocalizer.stringForKey(key: "SMS"))" as NSString
        if remainders_data[2][3] != "" {
            title_label = "\n" + remainders_data[2][4] + " " + remainders_data[2][3] as NSString
        }
        
        range = (number_label).range(of: number_label as String)
        number_label_String = NSMutableAttributedString.init(string: number_label as String)
        number_label_String.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: range)
        number_label_String.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: CGFloat(size))], range: range)
        
        titleString = NSMutableAttributedString.init(string: title_label as String)
        range2 = (title_label).range(of: title_label as String)
        titleString.addAttribute(NSAttributedString.Key.foregroundColor, value:textColor2, range: range2)
        titleString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)], range: range2)
        
        number_label_String.append(titleString)
        if number_data == "∞" {
            remainderView.messagesRemainder.text2.attributedText = number_label_String
        }
        else {
            remainderView.messagesRemainder.text.attributedText = number_label_String
        }
        
        
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
        
        remainderView.messagesRemainder.clickActionEffect.addTarget(self, action: #selector(openAddionalTraficsView3), for: .touchUpInside)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openAddionalTraficsView3))
        remainderView.messagesRemainder.isUserInteractionEnabled = true
        remainderView.messagesRemainder.addGestureRecognizer(tapGestureRecognizer)
        
        
        remainderView.minutesRemainder.clickActionEffect.addTarget(self, action: #selector(openAddionalTraficsView2), for: .touchUpInside)
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(openAddionalTraficsView2))
        remainderView.minutesRemainder.isUserInteractionEnabled = true
        remainderView.minutesRemainder.addGestureRecognizer(tapGestureRecognizer2)
      
        
        remainderView.internetRemainder.clickActionEffect.addTarget(self, action: #selector(openAddionalTraficsView), for: .touchUpInside)
    
       let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(openAddionalTraficsView))
        remainderView.internetRemainder.isUserInteractionEnabled = true
        remainderView.internetRemainder.addGestureRecognizer(tapGestureRecognizer3)
        
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
        
       if UserDefaults.standard.bool(forKey: "First Launch") == true {
            UserDefaults.standard.set(true, forKey: "First Launch")
        } else {
            createCoachMarker()
            addMarks()
            coachMarker?.tapPlay(autoStart:true,completion:{
                print("tapPlay finished")
                self.tabBarController?.tabBar.isUserInteractionEnabled = true
                
            })
            UserDefaults.standard.set(true, forKey: "First Launch")
            tabBarController?.tabBar.isUserInteractionEnabled = false
        }
    }
     
    func setupServicesTableView() {
        scrollView.addSubview(ServicesTableView)
    
        if zero_help_view_show == false {
            ServicesTableView.frame = CGRect(x: 0, y: 770, width: Int(UIScreen.main.bounds.size.width), height: table_height)
        }
        else {
            ServicesTableView.frame = CGRect(x: 0, y: 940, width: Int(UIScreen.main.bounds.size.width), height: table_height)
        }
        ServicesTableView.register(ServicesTableViewCell.self, forCellReuseIdentifier: cellID4)
        ServicesTableView.delegate = self
        ServicesTableView.dataSource = self
        ServicesTableView.isScrollEnabled = false
        ServicesTableView.backgroundColor = contentColor
        ServicesTableView.separatorColor = .lightGray
        ServicesTableView.alwaysBounceVertical = false
        ServicesTableView.showsVerticalScrollIndicator = false
        ServicesTableView.allowsSelection = false
        ServicesTableView.estimatedRowHeight = 140
        ServicesTableView.rowHeight = UITableView.automaticDimension
      }
    
    
    private func createCoachMarker() {
        
        marksContainer.frame.size = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        navigationController!.view.addSubview(marksContainer)
        
        navigationController!.view.layoutIfNeeded()
        
        coachMarker = CoachMarker(in:marksContainer, infoPadding:20)
        
        guard let marker = coachMarker,
        let info_view = marker.currentInfoView else {return}
        
        info_view.setTitleStyle(font: UIFont.boldSystemFont(ofSize: 20), color: UIColor.black)
        info_view.setInfoStyle(font: UIFont.systemFont(ofSize: 16), color: UIColor.black)
    }
    
// MARK: - ADD MARKS

    private func addMarks()
    {
        guard let controls = toolbar.openmenu.superview else {return}
        
        // There are several methods to add (or register) a mark.
        // 1. Pass no control view - control:nil - and position in marker's coordinate system:
        let pos_0 = controls.convert(toolbar.openmenu.center, to:marksContainer)
        let ape_0 = toolbar.openmenu.bounds.height + 6
        //coachMarker?.addMark(title: defaultLocalizer.stringForKey(key: "menu"), info: defaultLocalizer.stringForKey(key: "menu_content"), position:pos_0, aperture:ape_0, control:nil)
        coachMarker?.addMark(title: defaultLocalizer.stringForKey(key: "menu"), info: defaultLocalizer.stringForKey(key: "menu_content"), control: toolbar.openmenu)
        
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = BalanceSliderView.cellForItem(at: indexPath) as! BalanceSliderCollectionViewCell
        
        coachMarker?.addMark(title: defaultLocalizer.stringForKey(key: "tarif_set"), info: defaultLocalizer.stringForKey(key: "tarif_set_content"), control:cell.settings)
        
        coachMarker?.addMark(title: defaultLocalizer.stringForKey(key: "serv_set"), info: defaultLocalizer.stringForKey(key: "serv_set_content"), control:remainderView.messagesRemainder.plusText)
     
        let indexPath2 = IndexPath(row: 0, section: 0)
        let cell2 = HotServicesView.cellForItem(at: indexPath2) as! HotServicesCollectionViewCell
        
        coachMarker?.addMark(title: defaultLocalizer.stringForKey(key: "serv_fast"), info: defaultLocalizer.stringForKey(key: "serv_fast_content"), control: cell2.contentView)
        
        
        let tabBarVc = tabBarController
        
        guard let items = tabBarVc?.tabBar.items else {
            return
        }
                
        guard let view = items[0].value(forKey: "view") as? UIView else
        {
            return
        }
        
        coachMarker?.addMark(title: defaultLocalizer.stringForKey(key: "main_title"), info: defaultLocalizer.stringForKey(key: "main_title_content"), control: view)
        
        
        guard let view2 = items[1].value(forKey: "view") as? UIView else
        {
            return
        }
        
        coachMarker?.addMark(title: defaultLocalizer.stringForKey(key: "usage_title"), info: defaultLocalizer.stringForKey(key: "usage_title_content"), control: view2)
    
        
        guard let view3 = items[2].value(forKey: "view") as? UIView else
        {
            return
        }
        
        coachMarker?.addMark(title: defaultLocalizer.stringForKey(key: "help_title"), info: defaultLocalizer.stringForKey(key: "help_title_content"), control: view3)
        
       
        self.tabBarController?.tabBar.isUserInteractionEnabled = true
        navigationController!.popViewController(animated: true)
        
    }

    @objc func openAddionalTraficsView() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
       
        let viewControllerB = AddionalTraficsViewController()
        viewControllerB.whichTab = "1"
        navigationController?.pushViewController(viewControllerB, animated: true)
        // navigationController?.pushViewController(AddionalTraficsViewController(), animated: true)
    }

    @objc func openAddionalTraficsView2() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
       
        let viewControllerB = AddionalTraficsViewController()
        viewControllerB.whichTab = "2"
        navigationController?.pushViewController(viewControllerB, animated: true)
        // navigationController?.pushViewController(AddionalTraficsViewController(), animated: true)
    }

    
    @objc func openAddionalTraficsView3() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
       
        let viewControllerB = AddionalTraficsViewController()
        viewControllerB.whichTab = "3"
        navigationController?.pushViewController(viewControllerB, animated: true)
        // navigationController?.pushViewController(AddionalTraficsViewController(), animated: true)
    }

    
    @objc func openMenu() {
        // Define the menu
        
        let menu = SideMenuNavigationController(rootViewController: MenuViewController())
        
        menu.menuWidth = UIScreen.main.bounds.size.width - 110
    
        menu.presentationStyle = .menuSlideIn
        menu.view.layer.cornerRadius = 20
        present(menu, animated: true, completion: nil)
    }
    
    @objc func openPushNotifications() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(PushViewController(), animated: true)
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
        services_data.removeAll()
        remainders_data.removeAll()
        slider_data.removeAll()
        hot_services_data.removeAll()
        
        let client = APIClient.shared
            do{
              try client.homeGetRequest().subscribe(
                onNext: { result in
                    DispatchQueue.main.async {
                        self.preregStatus = Bool(result.prereg ?? false)
                        self.balance_credit = String(result.subscriberBalance ?? 0)
                        self.tarif_name = String(result.priceplan?.priceplanName ?? "")
                        self.user_name = String(result.subscriberName ?? "")
                        self.welcomePhrase = String(result.welcomePhrase ?? "")
                        self.mainBannerUrl = String(result.mainBannerUrl ?? "")
                        count_notif = String(result.notificationsCount ?? 0)
                        langId_choosed = Int(result.languageId ?? 1)
                        themeID_choosed = Int(result.themeId ?? 1)
                        
                        if result.priceplan != nil {
                            if result.priceplan!.nextApplyDate != nil {
                                
                                let dateFormatter1 = DateFormatter()
                                dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                                let date1 = dateFormatter1.date(from: String(result.priceplan!.nextApplyDate ?? ""))
                                dateFormatter1.dateFormat = "dd.MM.yyyy"
                                
                                var toDay = Calendar.current.startOfDay(for: Date())
                                
                                if date1 != nil && Calendar.current.startOfDay(for: date1!) < toDay {
                                    self.next_apply_date = self.defaultLocalizer.stringForKey(key: "Not_paid")
                                }
                                else {
                                    self.next_apply_date = self.defaultLocalizer.stringForKey(key: "Active_before:") + "\(dateFormatter1.string(from: date1!))"
                                }
                            }
                        }
                        
                        if result.balances != nil  {
                            self.remainders_data.append([String(result.balances!.offnet.start), String(result.balances!.offnet.now), String(result.balances!.offnet.unlim), String(result.balances!.offnet.unlimConditions?.hours ?? ""), String(result.balances!.offnet.unlimConditions?.speed ?? "")])
                            self.remainders_data.append([String(result.balances!.mb.start), String(result.balances!.mb.now), String(result.balances!.mb.unlim), String(result.balances!.mb.unlimConditions?.hours ?? ""), String(result.balances!.mb.unlimConditions?.speed ?? "")])
                            self.remainders_data.append([String(result.balances!.sms.start), String(result.balances!.sms.now), String(result.balances!.sms.unlim), String(result.balances!.sms.unlimConditions?.hours ?? ""), String(result.balances!.sms.unlimConditions?.speed ?? "")])
                        }
                        
                        if result.microServices != nil && result.microServices!.count != 0 {
                            for i in 0 ..< result.microServices!.count {
                                if String(result.microServices![i].id) != "7" {
                                    hot_services_data.append([String(result.microServices![i].id), String(result.microServices![i].iconUrl), String(result.microServices![i].microServiceName ?? ""), String(result.microServices![i].bannerUrl ?? "")])
                                }
                                
                            }
                        }
                        
                        if result.offers != nil && result.offers!.count != 0 {
                            for i in 0 ..< result.offers!.count {
                                self.slider_data.append([String(result.offers![i].id), String(result.offers![i].iconUrl), String(result.offers![i].url), String(result.offers![i].name ?? "")])
                            }
                        }
                        
                        if result.services != nil && result.services!.count != 0 {
                            print("meha meha")
                            for i in 0 ..< result.services!.count {
                                var disc_id = ""
                                var disc_percent = ""
                                
                                if result.services![i].discount != nil {
                                    disc_id = String(result.services![i].discount!.discountServiceId)
                                    disc_percent = String(result.services![i].discount!.discountPercent)
                                }
                                
                                self.services_data.append([String(result.services![i].id), String(result.services![i].serviceName ?? ""), String(result.services![i].price ?? ""),  String(result.services![i].period ?? ""), disc_id, disc_percent, String(result.services![i].description ?? "")])
                                
                            }
                        }
                    

                    }
                },
                onError: { error in
                   print(error.localizedDescription)
                    DispatchQueue.main.async {
                        
                        self.requestAnswer(status: false, message: self.defaultLocalizer.stringForKey(key: "service is temporarily unavailable"))
                        print(error.localizedDescription)
                        self.hideActivityIndicator(uiView: self.view)
                    }
                },
                onCompleted: {
                    DispatchQueue.main.async { [self] in
                        print("themeId = \(themeID_choosed)")
                        
                        setupView()
                        if remainders_data.count != 0 {
                            setupRemaindersSection()
                        }
                        setupServicesTableView()
                        setupBalanceSliderSection()
                        setupSliderSection()
                        setupHotServicesSection()
                       // animationStart()
                        hideActivityIndicator(uiView: self.view)
                        refreshControl.endRefreshing()
                    
                    }
                   print("Completed event.")
                    
                }).disposed(by: disposeBag)
              }
              catch{
            }
    }
    
    func sendUpdateRequest() {
        services_data.removeAll()
        remainders_data.removeAll()
        slider_data.removeAll()
        hot_services_data.removeAll()
        
        let client = APIClient.shared
            do{
              try client.homeGetRequest().subscribe(
                onNext: { result in
                    DispatchQueue.main.async {
                        //added for prereg
                        self.preregStatus = Bool(result.prereg ?? false)
                        self.balance_credit = String(result.subscriberBalance ?? 0)
                        self.tarif_name = String(result.priceplan?.priceplanName ?? "")
                        self.user_name = String(result.subscriberName ?? "")
                        self.welcomePhrase = String(result.welcomePhrase ?? "")
                        self.mainBannerUrl = String(result.mainBannerUrl ?? "")
                        count_notif = String(result.notificationsCount ?? 0)
                        langId_choosed = Int(result.languageId ?? 1)
                        themeID_choosed = Int(result.themeId ?? 1)
                        
                        if result.priceplan != nil {
                            if result.priceplan!.nextApplyDate != nil {
                                
                                let dateFormatter1 = DateFormatter()
                                dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                                let date1 = dateFormatter1.date(from: String(result.priceplan!.nextApplyDate ?? ""))
                                dateFormatter1.dateFormat = "dd.MM.yyyy"
                                
                                var toDay = Calendar.current.startOfDay(for: Date())
                                
                                if date1 != nil && Calendar.current.startOfDay(for: date1!) < toDay {
                                    self.next_apply_date = self.defaultLocalizer.stringForKey(key: "Not_paid")
                                }
                                else {
                                    self.next_apply_date = self.defaultLocalizer.stringForKey(key: "Active_before:") + "\(dateFormatter1.string(from: date1!))"
                                }
                            }
                        }
                        
                        if result.balances != nil  {
                            self.remainders_data.append([String(result.balances!.offnet.start), String(result.balances!.offnet.now), String(result.balances!.offnet.unlim), String(result.balances!.offnet.unlimConditions?.hours ?? ""), String(result.balances!.offnet.unlimConditions?.speed ?? "")])
                            self.remainders_data.append([String(result.balances!.mb.start), String(result.balances!.mb.now), String(result.balances!.mb.unlim), String(result.balances!.mb.unlimConditions?.hours ?? ""), String(result.balances!.mb.unlimConditions?.speed ?? "")])
                            self.remainders_data.append([String(result.balances!.sms.start), String(result.balances!.sms.now), String(result.balances!.sms.unlim), String(result.balances!.sms.unlimConditions?.hours ?? ""), String(result.balances!.sms.unlimConditions?.speed ?? "")])
                        }
                        
                        if result.microServices != nil && result.microServices!.count != 0 {
                            for i in 0 ..< result.microServices!.count {
                                if String(result.microServices![i].id) != "7" {
                                    hot_services_data.append([String(result.microServices![i].id), String(result.microServices![i].iconUrl), String(result.microServices![i].microServiceName ?? ""), String(result.microServices![i].bannerUrl ?? "")])
                                }
                                
                            }
                        }
                        
                        if result.offers != nil && result.offers!.count != 0 {
                            for i in 0 ..< result.offers!.count {
                                self.slider_data.append([String(result.offers![i].id), String(result.offers![i].iconUrl), String(result.offers![i].url), String(result.offers![i].name ?? "")])
                            }
                        }
                        
                        if result.services != nil && result.services!.count != 0 {
                            for i in 0 ..< result.services!.count {
                                var disc_id = ""
                                var disc_percent = ""
                                
                                if result.services![i].discount != nil {
                                    disc_id = String(result.services![i].discount!.discountServiceId)
                                    disc_percent = String(result.services![i].discount!.discountPercent)
                                }
                                
                                self.services_data.append([String(result.services![i].id), String(result.services![i].serviceName ?? ""), String(result.services![i].price ?? ""),  String(result.services![i].period ?? ""), disc_id, disc_percent, String(result.services![i].description ?? "")])
                            }
                        }
                    

                    }
                },
                onError: { error in
                   print(error.localizedDescription)
                    DispatchQueue.main.async {
                        
                        self.requestAnswer(status: false, message: self.defaultLocalizer.stringForKey(key: "service is temporarily unavailable"))
                        print(error.localizedDescription)
                        self.hideActivityIndicator(uiView: self.view)
                    }
                },
                onCompleted: {
                    DispatchQueue.main.async { [self] in
                        
                        BalanceSliderView.reloadData()
                        
                        SliderView.reloadData()
                        HotServicesView.reloadData()
                        hideActivityIndicator(uiView: self.view)
                        refreshControl.endRefreshing()
                    
                    }
                   print("Completed event.")
                    
                }).disposed(by: disposeBag)
              }
              catch{
            }
    }
    
    
    @objc func connectService(_ sender: UIButton) {
        
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
        view.image_icon.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "Service_Default_dark") : UIImage(named: "Service_Default"))
        view.name.text = defaultLocalizer.stringForKey(key: "Connect_service")
        view.name_content.text = "\(defaultLocalizer.stringForKey(key: "Connect_service2")) \"\(services_data[sender.tag][1])\" \(defaultLocalizer.stringForKey(key: "Connect_service2_1"))"
        view.ok.setTitle(defaultLocalizer.stringForKey(key: "Connect"), for: .normal)
        
        view.ok.tag = sender.tag
        view.cancel.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
        view.ok.addTarget(self, action: #selector(okClickDialog), for: .touchUpInside)
        
        alert.view.backgroundColor = .clear
        alert.view.addSubview(view)
        //alert.view.sendSubviewToBack(view)
        
        sender.showAnimation { [self] in
            present(alert, animated: true, completion: nil)
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
    
    @objc func okClickDialog(_ sender: UIButton) {
        
        sender.showAnimation { [self] in
            alert.dismiss(animated: true, completion: nil)
            showActivityIndicator(uiView: view)
        }
    
        let parametr: [String: Any] = ["serviceId": Int(services_data[sender.tag][0])!, "discountId": discount_id]
         let client = APIClient.shared
             do{
               try client.connectService(jsonBody: parametr).subscribe(
                 onNext: { [self] result in
                   
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
                         self.hideActivityIndicator(uiView: self.view)
                         requestAnswer(status: false, message: defaultLocalizer.stringForKey(key: "service is temporarily unavailable"))
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
        showActivityIndicator(uiView: self.view)
        officesdata.removeAll()
        supportdata.removeAll()
        
        let client = APIClient.shared
            do{
              try client.supportGetRequest().subscribe(
                onNext: { result in
                  
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
                        self.requestAnswer(status: false, message: self.defaultLocalizer.stringForKey(key: "service is temporarily unavailable"))
                        print(error.localizedDescription)
                        self.hideActivityIndicator(uiView: self.view)
                    }
                },
                onCompleted: {
                    DispatchQueue.main.async {
                        if supportdata.count != 0 {
                            self.sendRequest()
                        }
                        else  {
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
    
    /*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == table_balance {
            return 60
        }
        /*else {
            if services_data[indexPath.row][6] == "" {
                return 110
            } else {
                
                return 140
            }
        }*/
        return 140
    }*/
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == table_balance {
            return tableData.count
        }
        else {
            return services_data.count
        }
        
  }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == table_balance {
            let cell = tableView.dequeueReusableCell(withIdentifier: "add_balance_cell", for: indexPath) as! AddBalanceOptionViewCell
            
            let image = UIImage(named: "Stroke_next.png")
                let checkmark  = UIImageView(frame:CGRect(x:0, y:0, width:(image?.size.width)!, height:(image?.size.height)!));
                checkmark.image = image
                cell.accessoryView = checkmark
          
            cell.titleOne.text = tableData[indexPath.row][1]
            if indexPath.row == 0 {
                cell.ico_image.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "first.png") : UIImage(named: "first_l.png"))
            }
            /*else if indexPath.row == 1 {
                cell.ico_image.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "second.png") : UIImage(named: "second_l.png"))
            }
            else {
                cell.ico_image.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "third.png") : UIImage(named: "third_l.png"))
            }*/
            
            let bgColorView = UIView()
            bgColorView.backgroundColor = .clear
            cell.selectedBackgroundView = bgColorView
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID4, for: indexPath) as! ServicesTableViewCell
            cell.separatorInset = UIEdgeInsets.init(top: 10.0, left: 20.0, bottom: 2.0, right: 20.0)
            
            if indexPath.row == services_data.count - 1 {
         //       cell.separatorInset = UIEdgeInsets.init(top: -10, left: UIScreen.main.bounds.size.width, bottom: -10, right: 0)
            }
            cell.titleOne.text = services_data[indexPath.row][1]
            cell.titleTwo.text = services_data[indexPath.row][6]
            
           /* if services_data[indexPath.row][6] == "" {
                cell.titleThree.frame.origin.y = 50
                cell.getButton.frame.origin.y = 60
                cell.sale_title.frame.origin.y = 70
            }*/
            
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
            ServicesTableView.rowHeight = cell.titleTwo.frame.height + 140
            
            let cost: NSString = "\(services_data[indexPath.row][2])" as NSString
            let range = (cost).range(of: cost as String)
            let costString = NSMutableAttributedString.init(string: cost as String)
            costString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange , range: range)
            costString.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], range: range)
            
            var  period = " " + defaultLocalizer.stringForKey(key: "TJS") + "/" + services_data[indexPath.row][3].uppercased()
            if services_data[indexPath.row][3] == "" {
                period = " " + defaultLocalizer.stringForKey(key: "TJS")
            }
            else {
                period = " " + defaultLocalizer.stringForKey(key: "TJS") + "/" + services_data[indexPath.row][3].uppercased()
            }
            let title_cost = period as NSString
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
            bgColorView.backgroundColor = .clear
            cell.selectedBackgroundView = bgColorView
            
            cell.getButton.tag = indexPath.row
            cell.getButton.animateWhenPressed(disposeBag: disposeBag)
            cell.getButton.addTarget(self, action: #selector(connectService(_:)), for: .touchUpInside)
            
            return cell
        }
        
  }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == table_balance {
            if indexPath.row == 0 {
                self.dismiss(animated: true, completion: nil)
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                navigationController?.pushViewController(ZeroHelpViewController(), animated: true)
            }
            else if indexPath.row == 1 {
             
                self.dismiss(animated: true, completion: nil)
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                navigationController?.pushViewController(AskFriendViewController(), animated: true)
                
                
            }
        }
    }
}


@available(iOS 15.0, *)
extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == BalanceSliderView {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
        else if collectionView == SliderView {
            return CGSize(width: UIScreen.main.bounds.size.width - 40, height: collectionView.frame.height * 0.75)
        }
        else {
            return CGSize(width: 80, height: collectionView.frame.height)
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
            
            cell.balance.text = balance_credit + defaultLocalizer.stringForKey(key: "tjs")
            cell.titleTarif.text = tarif_name
            cell.spisanie.text = next_apply_date
            if next_apply_date == defaultLocalizer.stringForKey(key: "Not_paid") {
                cell.spisanie.textColor  = .red
            }
            else {
                cell.spisanie.textColor  = .white
            }
            // cell.image.image = UIImage(named: mainBannerUrl)
            
            if mainBannerUrl != "" {
                cell.image.af_setImage(withURL: URL(string: mainBannerUrl)!)
            }
            else {
                cell.image.image = UIImage(named: "BalanceBack")
            }
            
            cell.titleTarif.frame = CGRect(x: 20, y: 105, width: CGFloat(cell.titleTarif.text!.count * 10 + 20), height: 20)
            cell.settings.frame.origin.x = CGFloat(cell.titleTarif.text!.count * 10 + 40)
            
            let first = String(UserDefaults.standard.string(forKey: "mobPhone")!.prefix(2))
            let second = String(UserDefaults.standard.string(forKey: "mobPhone")!.prefix(5)).dropFirst(2)
            let third = String(String(UserDefaults.standard.string(forKey: "mobPhone")!.dropFirst(5))).prefix(2)
            
            print(UserDefaults.standard.string(forKey: "mobPhone"))
            
            cell.titleNumber.text = "(+992) \(first)-\(second)-\(third)-\(UserDefaults.standard.string(forKey: "mobPhone")!.dropFirst(7))"
            
            //for prereg status
          
            preregInfoLabel = cell.preregInfo
            preregInfoLayout = cell.white_view_back
            
            cell.prereg.addTarget(self, action: #selector(showPrergInfo), for: UIControl.Event.touchUpInside)
            
            if preregStatus == true
            {
                cell.prereg.setImage(UIImage(named: "preregTrue"), for: .normal)
                cell.preregInfo.text = defaultLocalizer.stringForKey(key: "PreregYes")
                cell.preregInfo.frame =  CGRect(x: 15, y: 195, width: UIScreen.main.bounds.size.width - 70, height: 16)
              
            }
            else
            {
                cell.prereg.setImage(UIImage(named: "preregFalse"), for: .normal)
                cell.preregInfo.text = defaultLocalizer.stringForKey(key: "PreregNo")
                cell.preregInfo.frame = CGRect(x: 15, y: 195, width: UIScreen.main.bounds.size.width - 70, height: 16)
            }
            

            
            cell.prereg.frame.origin.x = CGFloat(cell.titleNumber.text!.count * 10 + 15)
          
            cell.actionDelegate = (self as CellBalanceActionDelegate)
            
            tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            
        //    if(!tappedState)
         //   {
                
           //     scrollView.addGestureRecognizer(tap)
           // }
           
            
            return cell
        }
        else if collectionView == SliderView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID2, for: indexPath) as! SliderCollectionViewCell
           
           
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
            /*else if hot_services_data[indexPath.row][0] == "7" {
                cell.image.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ?  UIImage(named: "hot_search_w") :  UIImage(named: "hot_search"))
            }*/
            
            cell.titleOne.text = hot_services_data[indexPath.row][2]
            
            return cell
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
        
        alert = UIAlertController(title: "\n\n\n\n", message: "", preferredStyle: .actionSheet)
        let widthConstraints = alert.view.constraints.filter({ return $0.firstAttribute == .width })
        alert.view.removeConstraints(widthConstraints)
        // Here you can enter any width that you want
        let newWidth = UIScreen.main.bounds.width
        // Adding constraint for alert base view
        let widthConstraint = NSLayoutConstraint(item: alert.view,
                                                     attribute: .width,
                                                     relatedBy: .equal,
                                                     toItem: nil,
                                                     attribute: .notAnAttribute,
                                                     multiplier: 1,
                                                     constant: newWidth)
        alert.view.addConstraint(widthConstraint)
        
        let view = AddBalanceView()

        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 150)
        view.layer.cornerRadius = 20
        view.close.addTarget(self, action: #selector(dismissDialog(_:)), for: .touchUpInside)
        
        table_balance.frame = CGRect(x:5, y: 60, width: Int(UIScreen.main.bounds.size.width) - 10, height: (tableData.count * 60) + 50)
        table_balance.register(AddBalanceOptionViewCell.self, forCellReuseIdentifier: "add_balance_cell")
        table_balance.delegate = self
        table_balance.dataSource = self
        table_balance.rowHeight = 60
        table_balance.estimatedRowHeight = 60
        table_balance.alwaysBounceVertical = false
        table_balance.separatorStyle = .none
        table_balance.isScrollEnabled = false
        table_balance.backgroundColor = .clear
        
        alert.view.backgroundColor = .clear
        alert.view.addSubview(view)
        alert.view.addSubview(table_balance)
        //alert.view.sendSubviewToBack(view)
        
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func didSettingTapped(for cell: BalanceSliderCollectionViewCell) {
   
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(MyTarifViewController(), animated: true)
        
        //AlertViewController().modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
             //   AlertViewController().modalTransitionStyle = UIModalTransitionStyle.crossDissolve
             //   present(AlertViewController(), animated: true, completion: nil)
    }
    
    @objc func showPrergInfo(_ sender: UIButton){
        sender.showAnimation {
            if(self.tappedState)
            {
                self.preregInfoLabel.isHidden = true
                self.preregInfoLayout.isHidden = true
                self.tappedState = false
                self.scrollView.removeGestureRecognizer(self.tap)
                
            }
            else
            {
                self.preregInfoLabel.isHidden = false
                self.preregInfoLayout.isHidden = false
                self.tappedState = true
                self.scrollView.addGestureRecognizer(self.tap)
            }
        }
        
    }

    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        if(!self.preregInfoLabel.isHidden)
        {
            self.preregInfoLabel.isHidden = true
            self.preregInfoLayout.isHidden = true
            
            self.tappedState = false
            scrollView.removeGestureRecognizer(tap)
            
        }
       
        
    }
    
    @objc func dismissOnTapOutside(){
        self.dismiss(animated: true, completion: nil)
     }

    
}



extension UIBarButtonItem {

    var frame: CGRect? {
        guard let view = self.value(forKey: "view") as? UIView else {
            return nil
        }
        return view.frame
    }

}

