//
//  ServicesViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/8/21.
//

import UIKit
import RxSwift
import RxCocoa

class ServicesViewController: UIViewController, UIScrollViewDelegate {

    let disposeBag = DisposeBag()
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    var alert = UIAlertController()
    
    let scrollView = UIScrollView()
    
    var toolbar = TarifToolbarView()
    var servicesView = ServicesView()
    
    var x_pozition = 20
    var y_pozition = 100
    
    let table = UITableView()
    let table2 = UITableView()
    
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
        navigationController?.popViewController(animated: true)
    }
    
    func setupView() {
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
        if self.scrollView == scrollView {
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
                self.scrollView.contentOffset.y = 104
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
                            emptyView = EmptyView(frame: CGRect(x: 0, y: 30, width: self.table.frame.width, height: self.table.frame.height), text: "Нет активных услуг")
                            self.table.separatorStyle = .none
                            self.table.backgroundView = emptyView
                            }
                        }
                        
                        if result.available.count != 0 {
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
                            emptyView = EmptyView(frame: CGRect(x: 0, y: 30, width: self.table.frame.width, height: self.table.frame.height), text: "Нет доступных услуг")
                            self.table.separatorStyle = .none
                            self.table.backgroundView = emptyView
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
        
        var checkColor = UIColor.black
        
        if UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" {
            checkColor = .white
        }
        else {
            checkColor = .black
        }
        
        if servicesView.tab1.textColor == checkColor {
            view.name.text = defaultLocalizer.stringForKey(key: "Disable_service")
            view.name_content.text = "\(defaultLocalizer.stringForKey(key: "Disable_service"))\n \(connected_data[sender.tag][1])?"
            view.ok.setTitle(defaultLocalizer.stringForKey(key: "Disable"), for: .normal)
            view.ok.addTarget(self, action: #selector(disableService(_:)), for: .touchUpInside)
        }
        else {
            view.name.text = defaultLocalizer.stringForKey(key: "Connect_service")
            view.name_content.text = "\(defaultLocalizer.stringForKey(key: "Connect_service"))\n \(availables_data[sender.tag][1])?"
            view.ok.setTitle(defaultLocalizer.stringForKey(key: "Connect/Activate"), for: .normal)
            view.ok.addTarget(self, action: #selector(okClickDialog), for: .touchUpInside)
        }
        
        
        view.ok.tag = sender.tag
        view.cancel.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
        
        alert.view.backgroundColor = .clear
        alert.view.addSubview(view)
        //alert.view.sendSubviewToBack(view)
        
        sender.showAnimation { [self] in
            present(alert, animated: true, completion: nil)
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
        var checkColor = UIColor.black
        
        if UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" {
            checkColor = .white
        }
        else {
            checkColor = .black
        }
        
        if status == true {
            if servicesView.tab1.textColor == checkColor {
                view.name.text = "Услуга отключена!"
                view.image_icon.image = UIImage(named: "correct_alert")
            }
            else {
                view.name.text = "Услуга подключена!"
                view.image_icon.image = UIImage(named: "correct_alert")
            }
            
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
    
    @objc func disableService(_ sender: UIButton) {
        sender.showAnimation { [self] in
            alert.dismiss(animated: true, completion: nil)
            showActivityIndicator(uiView: view)
        }
        
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
                        requestAnswer(status: false, message: error.localizedDescription)
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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
                table.register(ServicesConnectTableViewCell.self, forCellReuseIdentifier: "serv_connect")
                table.frame = CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width - 20, height: UIScreen.main.bounds.size.height - 150)
                table.delegate = self
                table.dataSource = self
                table.rowHeight = 160
                table.estimatedRowHeight = 160
                table.alwaysBounceVertical = false
                table.backgroundColor = contentColor
                table.separatorColor = .lightGray
                table.allowsSelection = false
                cell.addSubview(table)
            }
            else {
                table2.register(ServicesTableViewCell.self, forCellReuseIdentifier: cellID4)
                table2.frame = CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width - 20, height: UIScreen.main.bounds.size.height - 150)
                table2.delegate = self
                table2.dataSource = self
                table2.rowHeight = 140
                table2.estimatedRowHeight = 140
                table2.alwaysBounceVertical = false
                table2.backgroundColor = contentColor
                table2.separatorColor = .lightGray
                table2.allowsSelection = false
                cell.addSubview(table2)
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

extension ServicesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == table {
            if connected_data[indexPath.row][4] == "" {
                return 130
            } else {
                return 160
            }
        }
        else {
            if availables_data[indexPath.row][5] == "" {
                return 110
            } else {
                return 140
            }
       }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == table {
            return connected_data.count
        }
        else {
            return availables_data.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == table {
            let cell = tableView.dequeueReusableCell(withIdentifier: "serv_connect", for: indexPath) as! ServicesConnectTableViewCell
            cell.separatorInset = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
            
            if indexPath.row == connected_data.count - 1 {
                cell.separatorInset = UIEdgeInsets.init(top: -10, left: UIScreen.main.bounds.size.width, bottom: -10, right: 0)
            }
            cell.titleOne.text = connected_data[indexPath.row][1]
            cell.titleTwo.text = connected_data[indexPath.row][4]
            cell.spisanie.text = defaultLocalizer.stringForKey(key: "Charge") + " " + connected_data[indexPath.row][5]
            
            if connected_data[indexPath.row][4] == "" {
                cell.titleThree.frame.origin.y = 50
                cell.getButton.frame.origin.y = 60
                cell.spisanie.frame.origin.y = 80
                cell.ic_image.frame.origin.y = 106
            }
            
            let cost: NSString = "\(connected_data[indexPath.row][2])" as NSString
            let range = (cost).range(of: cost as String)
            let costString = NSMutableAttributedString.init(string: cost as String)
            costString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange , range: range)
            costString.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], range: range)
            
            var  period = " С/" + connected_data[indexPath.row][3].uppercased()
            if connected_data[indexPath.row][3] == "" {
                period = " С"
            }
            else {
                period = " С/" + connected_data[indexPath.row][3].uppercased()
            }
            
            let title_cost = period  as NSString
            let titleString = NSMutableAttributedString.init(string: title_cost as String)
            let range2 = (title_cost).range(of: title_cost as String)
            titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: darkGrayLight , range: range2)
            titleString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)], range: range2)
            
            costString.append(titleString)
            cell.titleThree.attributedText = costString
            
            let bgColorView = UIView()
            bgColorView.backgroundColor = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.00) : UIColor(red: 1.00, green: 0.98, blue: 0.94, alpha: 1.00))
            bgColorView.layer.borderColor = UIColor.orange.cgColor
            bgColorView.layer.borderWidth = 1
            bgColorView.layer.cornerRadius = 10
            cell.selectedBackgroundView = bgColorView
            
            cell.getButton.tag = indexPath.row
            cell.getButton.addTarget(self, action: #selector(connectService), for: .touchUpInside)
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID4, for: indexPath) as! ServicesTableViewCell
            
            cell.separatorInset = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
            
            if indexPath.row == availables_data.count - 1 {
                cell.separatorInset = UIEdgeInsets.init(top: -10, left: UIScreen.main.bounds.size.width, bottom: -10, right: 0)
            }
            cell.titleOne.text = availables_data[indexPath.row][1]
            cell.titleTwo.text = availables_data[indexPath.row][5]
            
            if availables_data[indexPath.row][5] == "" {
                cell.titleThree.frame.origin.y = 50
                cell.getButton.frame.origin.y = 60
                cell.sale_title.frame.origin.y = 70
            }
            
            let cost: NSString = "\(availables_data[indexPath.row][2])" as NSString
            let range = (cost).range(of: cost as String)
            let costString = NSMutableAttributedString.init(string: cost as String)
            costString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange , range: range)
            costString.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], range: range)
            
            var  period = " С/" + availables_data[indexPath.row][3].uppercased()
            if availables_data[indexPath.row][3] == "" {
                period = " С"
            }
            else {
                period = " С/" + availables_data[indexPath.row][3].uppercased()
            }
            
            let title_cost = period as NSString
            let titleString = NSMutableAttributedString.init(string: title_cost as String)
            let range2 = (title_cost).range(of: title_cost as String)
            titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: darkGrayLight , range: range2)
            titleString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)], range: range2)
            
            costString.append(titleString)
            cell.titleThree.attributedText = costString
            cell.sale_title.frame.origin.x = CGFloat((cell.titleThree.text!.count * 7) + 80) ?? 150
            if availables_data[indexPath.row][5] != "" {
                cell.sale_title.text = "-" + availables_data[indexPath.row][5] + "%"
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
            
            cell.getButton.tag = indexPath.row
            cell.getButton.addTarget(self, action: #selector(connectService), for: .touchUpInside)
            
            return cell
        }
    }
    
    
}
