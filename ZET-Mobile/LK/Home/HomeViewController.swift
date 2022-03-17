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
    
    var services_data = [[String]]()
    var slider_data = [[String]]()
    var hot_services_data = [[String]]()
    var remainders_data = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        color2 = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
        color1 = UIColor.white
        
        sendRequest()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
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
    
    @objc func openServices() {
        print("services")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(ServicesViewController(), animated: true)
        
    }
    
    func setupView() {
        view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
  
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + CGFloat((services_data.count * 140)) - 100)
        view.addSubview(scrollView)
        
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
        remainderView.frame = CGRect(x: 0, y: 230, width: UIScreen.main.bounds.size.width, height: 140)
        
        var textColor = UIColor.black
        var textColor2 = UIColor.lightGray
        var number_data = ""
        
        if remainders_data[0][1] == "0" {
            textColor = .red
            textColor2 = .red
        }
        else {
            textColor = .black
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
        
        var title_label = "\n МИНУТ" as NSString
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
            textColor = .black
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
        title_label = "\n МЕГАБАЙТ" as NSString
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
            textColor = .black
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
        title_label = "\n SMS" as NSString
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
            ServicesTableView.frame = CGRect(x: 10, y: 770, width: Int(UIScreen.main.bounds.size.width) - 10, height: (services_data.count * 140))
        }
        else {
            ServicesTableView.frame = CGRect(x: 0, y: 940, width: Int(UIScreen.main.bounds.size.width), height: 1400)
        }
        ServicesTableView.register(ServicesTableViewCell.self, forCellReuseIdentifier: cellID4)
        ServicesTableView.delegate = self
        ServicesTableView.dataSource = self
        ServicesTableView.rowHeight = 140
        ServicesTableView.estimatedRowHeight = 140
        ServicesTableView.isScrollEnabled = false
      }
    
    @objc func openAddionalTraficsView() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(AddionalTraficsViewController(), animated: true)
    }
    
    @objc func openMenu() {
        // Define the menu
        let menu = SideMenuNavigationController(rootViewController: MenuViewController())
        menu.menuWidth = UIScreen.main.bounds.size.width - 50
        menu.presentationStyle = .menuSlideIn
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
                        let dateFormatter1 = DateFormatter()
                        dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        let date = dateFormatter1.date(from: String(result.priceplan.nextApplyDate))
                        dateFormatter1.dateFormat = "dd MMMM"
                        dateFormatter1.locale = Locale(identifier: "ru_RU")
                        self.next_apply_date = "Активен до \(dateFormatter1.string(from: date!))"
                        
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
                                self.services_data.append([String(result.services[i].id), String(result.services[i].serviceName), String(result.services[i].price),  String(result.services[i].period)])
                            }
                        }

                    }
                },
                onError: { error in
                   print(error.localizedDescription)
                },
                onCompleted: {
                    DispatchQueue.main.async { [self] in
                        setupView()
                        setupRemaindersSection()
                        setupServicesTableView()
                        setupBalanceSliderSection()
                        setupSliderSection()
                        setupHotServicesSection()
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
        cell.separatorInset = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        if indexPath.row == 2 {
            cell.separatorInset = UIEdgeInsets.init(top: -10, left: UIScreen.main.bounds.size.width, bottom: -10, right: 0)
        }
        cell.titleOne.text = services_data[indexPath.row][1]
        let cost: NSString = "\(services_data[indexPath.row][2])c/" as NSString
        let range = (cost).range(of: cost as String)
        let costString = NSMutableAttributedString.init(string: cost as String)
        costString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange , range: range)
        costString.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], range: range)
        
        let title_cost = services_data[indexPath.row][3] as NSString
        let titleString = NSMutableAttributedString.init(string: title_cost as String)
        let range2 = (title_cost).range(of: title_cost as String)
        titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.darkGray , range: range2)
        titleString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], range: range2)
        
        costString.append(titleString)
        cell.titleThree.attributedText = costString
        return cell
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
            cell.balance.text = balance_credit + " сомони"
            cell.titleTarif.text = tarif_name
            cell.spisanie.text = next_apply_date
            
            cell.settings.frame = CGRect(x: cell.titleTarif.text!.count * 10 + 30, y: 100, width: 20, height: 20)
            let first = String(UserDefaults.standard.string(forKey: "mobPhone")!.prefix(2))
            let second = String(UserDefaults.standard.string(forKey: "mobPhone")!.prefix(5)).dropFirst(2)
            let third = String(String(UserDefaults.standard.string(forKey: "mobPhone")!.dropFirst(5))).prefix(2)

            print(UserDefaults.standard.string(forKey: "mobPhone"))
            print(first)
            print(second)
            print(third)
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
                cell.image.image = UIImage(named: "hot_trafic")
            }
            else if hot_services_data[indexPath.row][0] == "3"  {
                cell.image.image = UIImage(named: "hot_change")
            }
            else if hot_services_data[indexPath.row][0] == "4"  {
                cell.image.image = UIImage(named: "hot_money")
            }
            else if hot_services_data[indexPath.row][0] == "5"  {
                cell.image.image = UIImage(named: "hot_help")
            }
            else if hot_services_data[indexPath.row][0] == "6" {
                cell.image.image = UIImage(named: "hot_detalization")
            }
            else if hot_services_data[indexPath.row][0] == "7" {
                cell.image.image = UIImage(named: "hot_search")
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

