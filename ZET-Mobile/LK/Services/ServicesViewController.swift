//
//  ServicesViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/8/21.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import AlamofireImage

class ServicesViewController: UIViewController, UIScrollViewDelegate {

    let disposeBag = DisposeBag()
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    var alert = UIAlertController()
    
    let scrollView = UIScrollView()
    
    var toolbar = TarifToolbarView()
    var servicesView = ServicesView()
    
    var x_pozition = 20
    var y_pozition = 100
    
    let tableConnected = UITableView()
    let tableAvailable = UITableView()
    
    let SliderView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(SliderCollectionViewCell.self, forCellWithReuseIdentifier: cellID2)
        cv.showsHorizontalScrollIndicator = false
        
        return cv
    }()
    
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
    var serviceId = ""
    var slider_data = [[String]]()
    var connected_data = [[String]]()
    var availables_data = [[String]]()
    var table2HeightRow = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showActivityIndicator(uiView: self.view)
        view.backgroundColor = toolbarColor
        sendRequest()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? .lightContent : .darkContent)
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
        if let destinationViewController = navigationController?.viewControllers
                                                                .filter(
                                              {$0 is HomeViewController})
                                                                .first {
            navigationController?.popToViewController(destinationViewController, animated: true)
        }
        //navigationController?.popViewController(animated: true)
    }
    
    func setupView() {
        table2HeightRow.removeAll()
        if availables_data.count != 0  {
            for i in 0 ..< availables_data.count {
                if availables_data[i][6] != "" {
                    table2HeightRow.append(((availables_data[i][6].count / 35) * 40) + 120)

                } else {
                    table2HeightRow.append(120)
                }
            }
        }
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.backgroundColor = .clear
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 805)
        view.addSubview(scrollView)
        
        view.backgroundColor = toolbarColor
  
        toolbar = TarifToolbarView(frame: CGRect(x: 0, y: topPadding ?? 0, width: UIScreen.main.bounds.size.width, height: 60))
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goBack))
        toolbar.isUserInteractionEnabled = true
        toolbar.addGestureRecognizer(tapGestureRecognizer)
        
        servicesView = ServicesView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 896))
        
        self.view.addSubview(toolbar)
        scrollView.addSubview(servicesView)
        
        toolbar.icon_back.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        
        toolbar.number_user_name.text = defaultLocalizer.stringForKey(key: "Services")
        
        scrollView.frame = CGRect(x: 0, y: 60 + (topPadding ?? 0), width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 60 + (topPadding ?? 0) + (bottomPadding ?? 0)))
    }

    func setupSliderSection() {
        scrollView.addSubview(SliderView)
        SliderView.backgroundColor = .clear
        SliderView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 120)
        SliderView.delegate = self
        SliderView.dataSource = self
    }
    
    func setupTabCollectionView() {
        y_pozition = y_pozition + 55
        
        servicesView.tab1.frame = CGRect(x: 20, y: y_pozition, width: Int(UIScreen.main.bounds.size.width) / 2 - 40, height: 40)
        servicesView.tab2.frame = CGRect(x: UIScreen.main.bounds.size.width / 2 + 20, y: CGFloat(y_pozition), width: UIScreen.main.bounds.size.width / 2 - 40, height: 40)
        
        servicesView.tab1Line.frame = CGRect(x: 20, y: y_pozition + 40, width: Int(UIScreen.main.bounds.size.width) / 2 - 40, height: 2)
        servicesView.tab2Line.frame = CGRect(x: UIScreen.main.bounds.size.width / 2 + 20, y: CGFloat(y_pozition + 40), width: UIScreen.main.bounds.size.width / 2 - 40, height: 2)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tab1Click))
        servicesView.tab1.isUserInteractionEnabled = true
        servicesView.tab1.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(tab2Click))
        servicesView.tab2.isUserInteractionEnabled = true
        servicesView.tab2.addGestureRecognizer(tapGestureRecognizer2)
        
        scrollView.addSubview(TabCollectionServiceView)
        TabCollectionServiceView.backgroundColor = contentColor
        TabCollectionServiceView.frame = CGRect(x: 0, y: y_pozition + 45, width: Int(UIScreen.main.bounds.size.width), height: Int(UIScreen.main.bounds.size.height - 150))
        TabCollectionServiceView.delegate = self
        TabCollectionServiceView.dataSource = self
        TabCollectionServiceView.alwaysBounceVertical = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.scrollView == scrollView || tableConnected == scrollView || tableAvailable == scrollView {
            if scrollView.contentOffset.y > servicesView.tab1.frame.origin.y {
                SliderView.isHidden = true
                self.scrollView.contentOffset.y = 0
                servicesView.tab1.frame.origin.y = 0
                servicesView.tab2.frame.origin.y = 0
                servicesView.tab1Line.frame.origin.y = 40
                servicesView.tab2Line.frame.origin.y = 40
                TabCollectionServiceView.frame.origin.y = 45
            }
            if scrollView.contentOffset.y < -10 && SliderView.isHidden == true {
                SliderView.isHidden = false
                servicesView.tab1.frame.origin.y = CGFloat(y_pozition)
                servicesView.tab2.frame.origin.y = CGFloat(y_pozition)
                servicesView.tab1Line.frame.origin.y = CGFloat(y_pozition + 40)
                servicesView.tab2Line.frame.origin.y = CGFloat(y_pozition + 40)
                TabCollectionServiceView.frame.origin.y = CGFloat(y_pozition + 45)
               
            }
        }
        
    }
    
    @objc func tab1Click() {
        servicesView.tab1.textColor = colorBlackWhite
        servicesView.tab2.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        servicesView.tab1Line.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
        servicesView.tab2Line.backgroundColor = .clear
        TabCollectionServiceView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionView.ScrollPosition.right, animated: true)
    }
    
    @objc func tab2Click() {
        servicesView.tab1.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        servicesView.tab2.textColor = colorBlackWhite
        servicesView.tab1Line.backgroundColor = .clear
        servicesView.tab2Line.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
        TabCollectionServiceView.scrollToItem(at: IndexPath(item: 1, section: 0), at: UICollectionView.ScrollPosition.left, animated: true)
    }
    
    func sendRequest() {
        availables_data.removeAll()
        connected_data.removeAll()
        slider_data.removeAll()
        let client = APIClient.shared
            do{
              try client.servicesGetRequest().subscribe(
                onNext: { result in
                  print(result)
                    DispatchQueue.main.async {
                        if result.offers.count != 0 {
                            for i in 0 ..< result.offers.count {
                                self.slider_data.append([String(result.offers[i].id), String(result.offers[i].iconUrl), String(result.offers[i].url), String(result.offers[i].name ?? "")])
                            }
                        }
                        
                        if result.connected.count != 0 {
                            for i in 0 ..< result.connected.count {
                                self.connected_data.append([String(result.connected[i].id), String(result.connected[i].serviceName ?? ""), String(result.connected[i].price ?? ""),  String(result.connected[i].period ?? ""), String(result.connected[i].description ?? ""), String(result.connected[i].nextChargeDate ?? "")])
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                emptyView = EmptyView(frame: CGRect(x: 0, y: 30, width: self.tableConnected.frame.width, height: self.tableConnected.frame.height), text: self.defaultLocalizer.stringForKey(key: "no_active_services"))
                            self.tableConnected.separatorStyle = .none
                            self.tableConnected.backgroundView = emptyView
                            }
                        }
                        
                        if result.available != nil && result.available.count != 0 {
                            for i in 0 ..< result.available.count {
                                
                                var disc_id = ""
                                var disc_percent = ""
                                
                                if result.available[i].discount != nil {
                                    disc_id = String(result.available[i].discount!.discountServiceId)
                                    disc_percent = String(result.available[i].discount!.discountPercent)
                                }
                                
                                self.availables_data.append([String(result.available[i].id), String(result.available[i].serviceName ?? ""), String(result.available[i].price ?? ""),  String(result.available[i].period ?? ""), disc_id, disc_percent, String(result.available[i].description ?? "")])
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                emptyView = EmptyView(frame: CGRect(x: 0, y: 30, width: self.tableAvailable.frame.width, height: self.tableAvailable.frame.height), text: self.defaultLocalizer.stringForKey(key: "no_available_services"))
                            self.tableAvailable.separatorStyle = .none
                            self.tableAvailable.backgroundView = emptyView
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
                },
                onCompleted: {
                    DispatchQueue.main.async { [self] in
                        setupView()
                        setupSliderSection()
                        setupTabCollectionView()
                        hideActivityIndicator(uiView: view)
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
        var checkColor = UIColor.black
        
        if UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" {
            checkColor = .white
        }
        else {
            checkColor = .black
        }
        
        if servicesView.tab1.textColor == checkColor {
            view.name.text = defaultLocalizer.stringForKey(key: "Disable_service")
            view.name_content.text = "\(defaultLocalizer.stringForKey(key: "Disable_service2")) \"\(connected_data[sender.tag][1])\" \(defaultLocalizer.stringForKey(key: "Disable_service2_1"))?"
            view.ok.setTitle(defaultLocalizer.stringForKey(key: "Disable"), for: .normal)
            view.ok.addTarget(self, action: #selector(disableService(_:)), for: .touchUpInside)
        }
        else {
            view.name.text = defaultLocalizer.stringForKey(key: "Connect_service")
            view.name_content.text = "\(defaultLocalizer.stringForKey(key: "Connect_service2")) \"\(availables_data[sender.tag][1])\" \(defaultLocalizer.stringForKey(key: "Connect_service2_1"))"
            view.ok.setTitle(defaultLocalizer.stringForKey(key: "Connect"), for: .normal)
            view.ok.addTarget(self, action: #selector(okClickDialog(_:)), for: .touchUpInside)
        }
        
        
        view.ok.tag = sender.tag
        view.cancel.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
        
        alert.view.backgroundColor = .clear
        alert.view.addSubview(view)
        //alert.view.sendSubviewToBack(view)
        
        present(alert, animated: true, completion: nil)
        
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
        var checkColor = UIColor.black
        
        if UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" {
            checkColor = .white
        }
        else {
            checkColor = .black
        }
        
        if status == true {
            if servicesView.tab1.textColor == checkColor {
                view.name.text = defaultLocalizer.stringForKey(key: "service_disabled")
                view.image_icon.image = UIImage(named: "correct_alert")
                view.ok.addTarget(self, action: #selector(okTrueDialog), for: .touchUpInside)
            }
            else {
                view.name.text = defaultLocalizer.stringForKey(key: "service_connected")
                view.image_icon.image = UIImage(named: "correct_alert")
                view.ok.addTarget(self, action: #selector(okTrueDialog), for: .touchUpInside)
            }
            
        }
        else {
            view.name.text = defaultLocalizer.stringForKey(key: "error_title")
            view.image_icon.image = UIImage(named: "uncorrect_alert")
            view.ok.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
        }
        
        view.name_content.text = "\(message)"
        view.ok.setTitle("OK", for: .normal)
        
        view.cancel.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
        
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
    
    @objc func okTrueDialog(_ sender: UIButton) {
       
        alert.dismiss(animated: true, completion: nil)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(ServicesViewController(), animated: false)
      
    }
    
    @objc func okClickDialog(_ sender: UIButton) {
        
        alert.dismiss(animated: true, completion: nil)
        showActivityIndicator(uiView: view)
        
        print(sender.tag)
        let parametr: [String: Any] = ["serviceId": Int(availables_data[sender.tag][0])!, "discountId": discount_id]
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
    
    @objc func disableService(_ sender: UIButton) {
        alert.dismiss(animated: true, completion: nil)
        showActivityIndicator(uiView: view)
       
        let client = APIClient.shared
            do{
                try client.disableService(parametr: String(connected_data[sender.tag][0])).subscribe(
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
                        self.hideActivityIndicator(uiView: self.view)
                        requestAnswer(status: false, message: defaultLocalizer.stringForKey(key: "service is temporarily unavailable"))
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

extension ServicesViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,   sizeForItemAt indexPath: IndexPath) -> CGSize {
       if collectionView == SliderView {
            return CGSize(width: UIScreen.main.bounds.size.width - 40, height: collectionView.frame.height * 0.75)
        }
        else {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == SliderView {
            return slider_data.count
        }
        else {
            return 2
        }

    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == SliderView {
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tabs", for: indexPath) as! TabCollectionServiceViewCell
            if indexPath.row == 0 {
                tableConnected.register(ServicesConnectTableViewCell.self, forCellReuseIdentifier: "serv_connect")
                tableConnected.frame = CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width - 20, height: UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 110 + (topPadding ?? 0) + (bottomPadding ?? 0)))
                tableConnected.delegate = self
                tableConnected.dataSource = self
                tableConnected.rowHeight = UITableView.automaticDimension
                tableConnected.estimatedRowHeight = 140 // Примерное значение высоты ячейки
                tableConnected.alwaysBounceVertical = false
                tableConnected.backgroundColor = contentColor
                tableConnected.separatorColor = .lightGray
                tableConnected.allowsSelection = false
                tableConnected.showsVerticalScrollIndicator = false
                cell.addSubview(tableConnected)
            }
            else {
                tableAvailable.register(ServicesTableViewCell.self, forCellReuseIdentifier: cellID4)
                tableAvailable.frame = CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width - 20, height: UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 110 + (topPadding ?? 0) + (bottomPadding ?? 0)))
                tableAvailable.delegate = self
                tableAvailable.dataSource = self
                tableAvailable.backgroundColor = contentColor
                tableAvailable.separatorColor = .lightGray
                tableAvailable.alwaysBounceVertical = false
                tableAvailable.allowsSelection = false
                tableAvailable.showsVerticalScrollIndicator = false
                tableAvailable.rowHeight = UITableView.automaticDimension
                tableAvailable.estimatedRowHeight = 140 // Примерное значение высоты ячейки
                tableAvailable.rowHeight = UITableView.automaticDimension
                cell.addSubview(tableAvailable)
            }
            return cell
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == SliderView {
            open(scheme: slider_data[indexPath.row][2])
        }
    }
 
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == TabCollectionServiceView {
            if indexPath.row == 0 {
                servicesView.tab1.textColor = colorBlackWhite
                servicesView.tab2.textColor = .gray
                servicesView.tab1Line.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
                servicesView.tab2Line.backgroundColor = .clear
                
            } else {
                servicesView.tab1.textColor = .gray
                servicesView.tab2.textColor = colorBlackWhite
                servicesView.tab1Line.backgroundColor = .clear
                servicesView.tab2Line.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
          }
       }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == TabCollectionServiceView {
            if indexPath.row == 0 {
                servicesView.tab1.textColor = .gray
                servicesView.tab2.textColor = colorBlackWhite
                servicesView.tab1Line.backgroundColor = .clear
                servicesView.tab2Line.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
                
            } else {
                servicesView.tab1.textColor = colorBlackWhite
                servicesView.tab2.textColor = .gray
                servicesView.tab1Line.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
                servicesView.tab2Line.backgroundColor = .clear
          }
        }
        
    }
}
//for tables
extension ServicesViewController: UITableViewDataSource, UITableViewDelegate {
    //amount of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableConnected {
            return connected_data.count
        }
        else {
            return availables_data.count
        }
    }
    
    //table of connected services
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //table of connected services
        
        if tableView == tableConnected {
            let cell = tableView.dequeueReusableCell(withIdentifier: "serv_connect", for: indexPath) as! ServicesConnectTableViewCell
            cell.separatorInset = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
            
            if indexPath.row == connected_data.count - 1 {
              //  cell.separatorInset = UIEdgeInsets.init(top: -10, left: UIScreen.main.bounds.size.width, bottom: -10, right: 0)
            }
            
            //setting values to cells
            
            cell.serviceTitle.text = connected_data[indexPath.row][1]
            cell.serviceDesc.text = connected_data[indexPath.row][4]
            cell.serviceCharge.text = defaultLocalizer.stringForKey(key: "Charge").uppercased() + " " + connected_data[indexPath.row][5]
            
            let cost: NSString = "\(connected_data[indexPath.row][2])" as NSString
            let range = (cost).range(of: cost as String)
            let costString = NSMutableAttributedString.init(string: cost as String)
            costString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange , range: range)
            costString.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], range: range)
            
            var  period = " " + defaultLocalizer.stringForKey(key: "TJS") +  "/" + connected_data[indexPath.row][3].uppercased()
            if connected_data[indexPath.row][3] == "" {
                period = " " + defaultLocalizer.stringForKey(key: "TJS")
            }
            else {
                period = " " + defaultLocalizer.stringForKey(key: "TJS") + "/" + connected_data[indexPath.row][3].uppercased()
            }
            
            let title_cost = period  as NSString
            let titleString = NSMutableAttributedString.init(string: title_cost as String)
            let range2 = (title_cost).range(of: title_cost as String)
            titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: darkGrayLight , range: range2)
            titleString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)], range: range2)
            
            costString.append(titleString)
            cell.servPrice.attributedText = costString
            
            cell.getButton.tag = indexPath.row
            cell.getButton.animateWhenPressed(disposeBag: disposeBag)
            cell.getButton.addTarget(self, action: #selector(connectService), for: .touchUpInside)
            
            return cell
        }
        else
        {
            //table of available services
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID4, for: indexPath) as! ServicesTableViewCell
            
            cell.separatorInset = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
            
            if indexPath.row == availables_data.count - 1 {
               // cell.separatorInset = UIEdgeInsets.init(top: -10, left: UIScreen.main.bounds.size.width, bottom: -10, right: 0)
            }
            
            print(availables_data[indexPath.row][6])
            cell.serviceTitle.text = availables_data[indexPath.row][1]
            cell.serviceDesc.text = availables_data[indexPath.row][6]
       
            let cost: NSString = "\(availables_data[indexPath.row][2])" as NSString
            let range = (cost).range(of: cost as String)
            let costString = NSMutableAttributedString.init(string: cost as String)
            costString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange , range: range)
            costString.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], range: range)
            
            var  period = " " + defaultLocalizer.stringForKey(key: "TJS") + "/" + availables_data[indexPath.row][3].uppercased()
            if availables_data[indexPath.row][3] == "" {
                period = " " + defaultLocalizer.stringForKey(key: "TJS")
            }
            else {
                period = " " + defaultLocalizer.stringForKey(key: "TJS") + "/" + availables_data[indexPath.row][3].uppercased()
            }
            
            let title_cost = period as NSString
            let titleString = NSMutableAttributedString.init(string: title_cost as String)
            let range2 = (title_cost).range(of: title_cost as String)
            titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: darkGrayLight , range: range2)
            titleString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)], range: range2)
            
            costString.append(titleString)
            cell.servicePrice.attributedText = costString
            
            if availables_data[indexPath.row][5] != "" {
                cell.discount.text = "-" + availables_data[indexPath.row][5] + "%"
                cell.discount.isHidden = false
            }
            else {
                cell.discount.isHidden = true
            }
            
            cell.getButton.tag = indexPath.row
            cell.getButton.animateWhenPressed(disposeBag: disposeBag)
            cell.getButton.addTarget(self, action: #selector(connectService), for: .touchUpInside)
            
            return cell
        }
    }
    
    
}
