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
    
    let scrollView = UIScrollView()
    
    var toolbar = TarifToolbarView()
    var servicesView = ServicesView()
    
    var x_pozition = 20
    var y_pozition = 150
    
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
        
        view.backgroundColor = .white
        sendRequest()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
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
        
        view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
  
        toolbar = TarifToolbarView(frame: CGRect(x: 0, y: 44, width: UIScreen.main.bounds.size.width, height: 60))
        servicesView = ServicesView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 896))
        
        self.view.addSubview(toolbar)
        scrollView.addSubview(servicesView)
        
        toolbar.icon_back.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        toolbar.number_user_name.text = "Услуги"
        
        scrollView.frame = CGRect(x: 0, y: 104, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 104)
    }

    func setupSliderSection() {
        scrollView.addSubview(SliderView)
        SliderView.backgroundColor = .clear
        SliderView.frame = CGRect(x: 0, y: 60, width: UIScreen.main.bounds.size.width, height: 120)
        SliderView.delegate = self
        SliderView.dataSource = self
    }
    
    func setupTabCollectionView() {
        y_pozition = y_pozition + 55
        
        servicesView.tab1.frame = CGRect(x: 0, y: y_pozition, width: Int(UIScreen.main.bounds.size.width) / 2, height: 40)
        servicesView.tab2.frame = CGRect(x: UIScreen.main.bounds.size.width / 2 - 20, y: CGFloat(y_pozition), width: UIScreen.main.bounds.size.width / 2 - 20, height: 40)
        
        servicesView.tab1Line.frame = CGRect(x: 10, y: y_pozition + 40, width: Int(UIScreen.main.bounds.size.width) / 2 - 10, height: 3)
        servicesView.tab2Line.frame = CGRect(x: UIScreen.main.bounds.size.width / 2 - 10, y: CGFloat(y_pozition + 40), width: UIScreen.main.bounds.size.width / 2 - 10, height: 3)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tab1Click))
        servicesView.tab1.isUserInteractionEnabled = true
        servicesView.tab1.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(tab2Click))
        servicesView.tab2.isUserInteractionEnabled = true
        servicesView.tab2.addGestureRecognizer(tapGestureRecognizer2)
        
        scrollView.addSubview(TabCollectionServiceView)
        TabCollectionServiceView.backgroundColor = .white
        TabCollectionServiceView.frame = CGRect(x: 0, y: y_pozition + 45, width: Int(UIScreen.main.bounds.size.width), height: Int(UIScreen.main.bounds.size.height - 150))
        TabCollectionServiceView.delegate = self
        TabCollectionServiceView.dataSource = self
        TabCollectionServiceView.alwaysBounceVertical = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.scrollView == scrollView {
            if scrollView.contentOffset.y > servicesView.tab1.frame.origin.y {
                SliderView.isHidden = true
                servicesView.searchField.isHidden = true
                self.scrollView.contentOffset.y = 0
                servicesView.tab1.frame.origin.y = 0
                servicesView.tab2.frame.origin.y = 0
                servicesView.tab1Line.frame.origin.y = 40
                servicesView.tab2Line.frame.origin.y = 40
                TabCollectionServiceView.frame.origin.y = 45
            }
            if scrollView.contentOffset.y < -10 && SliderView.isHidden == true {
                SliderView.isHidden = false
                servicesView.searchField.isHidden = false
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
        servicesView.tab1.textColor = .black
        servicesView.tab2.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        servicesView.tab1Line.backgroundColor = .orange
        servicesView.tab2Line.backgroundColor = .clear
        TabCollectionServiceView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionView.ScrollPosition.right, animated: true)
    }
    
    @objc func tab2Click() {
        servicesView.tab1.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        servicesView.tab2.textColor = .black
        servicesView.tab1Line.backgroundColor = .clear
        servicesView.tab2Line.backgroundColor = .orange
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
                                self.slider_data.append([String(result.offers[i].id), String(result.offers[i].iconUrl), String(result.offers[i].url), String(result.offers[i].name)])
                            }
                        }
                        
                        if result.connected.count != 0 {
                            for i in 0 ..< result.connected.count {
                                self.connected_data.append([String(result.connected[i].id), String(result.connected[i].serviceName), String(result.connected[i].price ?? ""),  String(result.available[i].period ?? "")])
                            }
                        }
                        
                        if result.available.count != 0 {
                            for i in 0 ..< result.available.count {
                                self.availables_data.append([String(result.available[i].id), String(result.available[i].serviceName), String(result.available[i].price ?? ""),  String(result.available[i].period ?? "")])
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
                        setupSliderSection()
                        setupTabCollectionView()
                    }
                   print("Completed event.")
                    
                }).disposed(by: disposeBag)
              }
              catch{
            }
    }
    
    @objc func connectService(_ sender: UIButton) {
        let parametr: [String: Any] = ["serviceId": sender.tag, "discountId": discount_id]
        print(sender.tag)
        let client = APIClient.shared
            do{
              try client.connectService(jsonBody: parametr).subscribe(
                onNext: { [self] result in
                  print(result)
                    //sendRequest()
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
    
    @objc func disableService(_ sender: UIButton) {
     
        let client = APIClient.shared
            do{
              try client.disableService(parametr: String(sender.tag)).subscribe(
                onNext: { [self] result in
                  print(result)
                    sendRequest()
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
}

extension ServicesViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       if collectionView == SliderView {
            return CGSize(width: collectionView.frame.width * 0.75, height: collectionView.frame.height * 0.75)
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
                table.backgroundColor = .white
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
                table2.backgroundColor = .white
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
                servicesView.tab1.textColor = .black
                servicesView.tab2.textColor = .gray
                servicesView.tab1Line.backgroundColor = .orange
                servicesView.tab2Line.backgroundColor = .clear
                
            } else {
                servicesView.tab1.textColor = .gray
                servicesView.tab2.textColor = .black
                servicesView.tab1Line.backgroundColor = .clear
                servicesView.tab2Line.backgroundColor = .orange
          }
       }
    }
}

extension ServicesViewController: UITableViewDataSource, UITableViewDelegate {
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
            
            if indexPath.row == 2 {
                cell.separatorInset = UIEdgeInsets.init(top: -10, left: UIScreen.main.bounds.size.width, bottom: -10, right: 0)
            }
            cell.titleOne.text = connected_data[indexPath.row][1]
            let cost: NSString = "\(connected_data[indexPath.row][2])c/" as NSString
            let range = (cost).range(of: cost as String)
            let costString = NSMutableAttributedString.init(string: cost as String)
            costString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange , range: range)
            costString.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], range: range)
            
            let title_cost = connected_data[indexPath.row][3] as NSString
            let titleString = NSMutableAttributedString.init(string: title_cost as String)
            let range2 = (title_cost).range(of: title_cost as String)
            titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.darkGray , range: range2)
            titleString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], range: range2)
            
            costString.append(titleString)
            cell.titleThree.attributedText = costString
            
            cell.getButton.tag = Int(connected_data[indexPath.row][0])!
            cell.getButton.addTarget(self, action: #selector(disableService(_:)), for: .touchUpInside)
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID4, for: indexPath) as! ServicesTableViewCell
            
            cell.separatorInset = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
            
            if indexPath.row == 2 {
                cell.separatorInset = UIEdgeInsets.init(top: -10, left: UIScreen.main.bounds.size.width, bottom: -10, right: 0)
            }
            cell.titleOne.text = availables_data[indexPath.row][1]
            let cost: NSString = "\(availables_data[indexPath.row][2])c/" as NSString
            let range = (cost).range(of: cost as String)
            let costString = NSMutableAttributedString.init(string: cost as String)
            costString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange , range: range)
            costString.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], range: range)
            
            let title_cost = availables_data[indexPath.row][3] as NSString
            let titleString = NSMutableAttributedString.init(string: title_cost as String)
            let range2 = (title_cost).range(of: title_cost as String)
            titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.darkGray , range: range2)
            titleString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], range: range2)
            
            costString.append(titleString)
            cell.titleThree.attributedText = costString
            
            cell.getButton.tag = Int(availables_data[indexPath.row][0])!
            cell.getButton.addTarget(self, action: #selector(connectService), for: .touchUpInside)
            
            return cell
        }
    }
    
    
}
