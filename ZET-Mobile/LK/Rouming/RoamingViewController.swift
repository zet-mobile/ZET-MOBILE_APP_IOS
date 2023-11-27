//
//  RoumingViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 1/9/22.
//

import UIKit
import RxSwift
import RxCocoa
import iOSDropDown

struct operatorChargeData {
    let description: [String]
    let price: [String]
}

class RoamingViewController: UIViewController, UIScrollViewDelegate {
    
    let disposeBag = DisposeBag()
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    var alert = UIAlertController()
    let scrollView = UIScrollView()
    
    var toolbar = TarifToolbarView()
    var roamingView = RoamingView()
    let table = UITableView()
    
    let tabCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(TabRoamingCollectionCell.self, forCellWithReuseIdentifier: "tabs_rouming")
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        return cv
    }()
    
    var y_pozition = 250
    var questionsData = [[String]]()
    var countriesData = [[String]]()
    var roamingOperatorsData = [[String]]()
    var operatorChargesData = [operatorChargeData(description: [String](), price: [String]())]
    
    var row_height = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    
    var countryChoosed = ""
    var countryChoosedId = "0"
    var countryChoosedImg = ""
    var roamingOperatorsChoosed = ""
    var roamingOperatorsChoosedId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = toolbarColor
        operatorChargesData.removeAll()
        roamingOperatorsData.removeAll()
        sendRequest()
       
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 11.0, *) {
            scrollView.scrollIndicatorInsets = view.safeAreaInsets
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.safeAreaInsets.bottom, right: 0)
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? .lightContent : .darkContent)
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupView() {
        view.backgroundColor = contentColor
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
        }
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.backgroundColor = contentColor
        
        if operatorChargesData.isEmpty {
            scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + CGFloat(operatorChargesData[roamingOperatorsChoosedId].price.count * 55))
        }
        else {
            scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        }
        
        scrollView.isScrollEnabled = true
        view.addSubview(scrollView)
  
        toolbar = TarifToolbarView(frame: CGRect(x: 0, y: topPadding ?? 0, width: UIScreen.main.bounds.size.width, height: 60)) // Move to autolayout
        
        self.view.addSubview(toolbar)
        view.addSubview(roamingView)

        toolbar.icon_back.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        toolbar.number_user_name.text = defaultLocalizer.stringForKey(key: "ROAMING")
        toolbar.backgroundColor = contentColor
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goBack))
        toolbar.isUserInteractionEnabled = true
        toolbar.addGestureRecognizer(tapGestureRecognizer)
       
        roamingView.countriesTabLine.frame = CGRect(x: 10, y: 55, width: (Int(UIScreen.main.bounds.size.width) / 2) - 20, height: 2)
      
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(tab1Click))
        roamingView.countriesConditionsTab.isUserInteractionEnabled = true
        roamingView.countriesConditionsTab.addGestureRecognizer(tapGestureRecognizer1)
               
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(tab2Click))
        roamingView.informationTab.isUserInteractionEnabled = true
        roamingView.informationTab.addGestureRecognizer(tapGestureRecognizer2)
               
        tabCollectionView.backgroundColor = .clear
        tabCollectionView.delegate = self
        tabCollectionView.dataSource = self
        tabCollectionView.alwaysBounceVertical = false
        
        view.addSubview(tabCollectionView)
        
        roamingView.informationTab.translatesAutoresizingMaskIntoConstraints = false
        roamingView.informationTabLine.translatesAutoresizingMaskIntoConstraints = false
        roamingView.countriesConditionsTab.translatesAutoresizingMaskIntoConstraints = false
        roamingView.translatesAutoresizingMaskIntoConstraints = false
        tabCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            roamingView.topAnchor.constraint(equalTo: toolbar.bottomAnchor),
            roamingView.countriesConditionsTab.heightAnchor.constraint(equalToConstant: 50),
            roamingView.countriesConditionsTab.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            roamingView.informationTab.heightAnchor.constraint(equalToConstant: 50),
            roamingView.informationTab.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: -5),
            
            roamingView.informationTabLine.topAnchor.constraint(equalTo: roamingView.informationTab.bottomAnchor, constant: 4),
            roamingView.informationTabLine.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: -5),
            roamingView.informationTabLine.heightAnchor.constraint(equalToConstant: 2),
            roamingView.informationTabLine.widthAnchor.constraint(equalToConstant: 104.5),
            
            tabCollectionView.topAnchor.constraint(equalTo: roamingView.informationTabLine.bottomAnchor),
            tabCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tabCollectionView.heightAnchor.constraint(equalToConstant: 900),
        ])
        
      
        
        scrollView.frame = CGRect(x: 0, y: 60 + (topPadding ?? 0), width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 60 + (topPadding ?? 0) + (bottomPadding ?? 0)))
        
    }
    
    @objc func tab1Click() {
        roamingView.countriesConditionsTab.textColor = colorBlackWhite
        roamingView.informationTab.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        roamingView.countriesTabLine.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
        roamingView.informationTabLine.backgroundColor = .clear
        tabCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionView.ScrollPosition.right, animated: true)
    }
    
    @objc func tab2Click() {
        roamingView.countriesConditionsTab.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        roamingView.informationTab.textColor = colorBlackWhite
        roamingView.countriesTabLine.backgroundColor = .clear
        roamingView.informationTabLine.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
        tabCollectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: UICollectionView.ScrollPosition.left, animated: true)
    }
    
    func sendRequest() {
        let client = APIClient.shared
            do{
              try client.roumingGetRequest().subscribe(
                onNext: { result in
                  print(result)
                    DispatchQueue.main.async { [self] in
                        for i in 0 ..< result.questions.count {
                            questionsData.append([String(result.questions[i].id), String(result.questions[i].question ?? ""), String(result.questions[i].answer ?? ""), "false"])
                        }
                        
                        for i in 0 ..< result.countries.count {
                            countriesData.append([String(result.countries[i].id), String(result.countries[i].countryName ?? ""), String(result.countries[i].iconUrl ?? ""), "Roaming_Flag"])
                        }
                        countryChoosed = countriesData[0][1]
                        countryChoosedId = countriesData[0][0]
                        if countriesData[0][2] != "" {
                            countryChoosedImg = countriesData[0][2]
                        }
                        else {
                            countryChoosedImg = countriesData[0][3]
                        }
                        
                    }
                },
                onError: { error in
                   print(error.localizedDescription)
                    DispatchQueue.main.async { [self] in
                      //  setupView()
                        hideActivityIndicator(uiView: self.view)
                        requestAnswer(message: defaultLocalizer.stringForKey(key: "service is temporarily unavailable"))
                    }
                },
                onCompleted: {
                    client.requestObservable.tabIndicator = "1"
                    DispatchQueue.main.async { [self] in
                        getRequest2()
                    }
                   print("Completed event.")
                    
                }).disposed(by: disposeBag)
              }
              catch{
            }
    }

    func getRequest2() {
        operatorChargesData.removeAll()
        roamingOperatorsData.removeAll()
       // table.allowsSelection = false
        
        let client = APIClient.shared
            do{
              try client.roamingCountriesGetRequest(parametr: countryChoosedId).subscribe(
                onNext: { result in
                  print(result)
                    DispatchQueue.main.async { [self] in
                   
                        if result.roamingOperators?.count != 0 {
                            for i in 0 ..< result.roamingOperators!.count {
                                roamingOperatorsData.append([String(result.roamingOperators![i].operatorId), String(result.roamingOperators![i].operatorName), String(result.roamingOperators![i].iconUrl)])
                                
                                var tableData = [String]()
                                var tableData1 = [String]()
                                
                                for j in 0 ..< result.roamingOperators![i].operatorCharges.count {
                                    print(result.roamingOperators![i].operatorCharges.count)
                                
                                    print(String(result.roamingOperators![i].operatorCharges[j].description ?? ""))
                                    
                                    tableData.append(String(result.roamingOperators![i].operatorCharges[j].description ?? ""))
                                    tableData1.append(String(result.roamingOperators![i].operatorCharges[j].price))
                                    print("")
                                    print(result.roamingOperators![i].operatorCharges.count)
                                }
                                
                                operatorChargesData.append(operatorChargeData(description: tableData, price: tableData1))
                            }
                            
                            print("operatorCharges_Data.count")
                            print(operatorChargesData.count)
                        }
                        
                       
                    }
                },
                onError: { error in
                   print(error.localizedDescription)
                    DispatchQueue.main.async { [self] in
                        hideActivityIndicator(uiView: self.view)
                        requestAnswer(message: defaultLocalizer.stringForKey(key: "service is temporarily unavailable"))
                    }
                    client.requestObservable.tabIndicator = "0"
                    print("roamingerror")
                },
                onCompleted: {
                    client.requestObservable.tabIndicator = "0"
                    DispatchQueue.main.async { [self] in
                        setupView()
                        
                    }
                   print("Completed event.")
                    
                }).disposed(by: disposeBag)
              }
              catch{
            }
    }
    
    func getRequest() {
        operatorChargesData.removeAll()
        roamingOperatorsData.removeAll()
       // table.allowsSelection = false
        
        let client = APIClient.shared
            do{
              try client.roamingCountriesGetRequest(parametr: countryChoosedId).subscribe(
                onNext: { result in
                  print(result)
                    DispatchQueue.main.async { [self] in
                   
                        if result.roamingOperators?.count != 0 {
                            for i in 0 ..< result.roamingOperators!.count {
                                roamingOperatorsData.append([String(result.roamingOperators![i].operatorId), String(result.roamingOperators![i].operatorName), String(result.roamingOperators![i].iconUrl)])
                                
                                var tableData = [String]()
                                var tableData1 = [String]()
                                
                                for j in 0 ..< result.roamingOperators![i].operatorCharges.count {
                                    tableData.append(String(result.roamingOperators![i].operatorCharges[j].description ?? ""))
                                    tableData1.append(String(result.roamingOperators![i].operatorCharges[j].price))
                                }
                                
                                operatorChargesData.append(operatorChargeData(description: tableData, price: tableData1))
                            }
                        }
                        
                        
                       
                    }
                },
                onError: { error in
                   print(error.localizedDescription)
                    DispatchQueue.main.async { [self] in
                        hideActivityIndicator(uiView: self.view)
                        requestAnswer(message: defaultLocalizer.stringForKey(key: "service is temporarily unavailable"))
                    }
                },
                onCompleted: {
                    DispatchQueue.main.async { [self] in
                        let indexPath = IndexPath(item: 0, section: 0)
                        
                       // TabCollectionView.reloadItems(at: [indexPath])
                     //   TabCollectionView.reloadData()
                        
                        tabCollectionView.reloadData()
                        
                    }
                   print("Completed event.")
                    
                }).disposed(by: disposeBag)
              }
              catch{
            }
    }
    
    @objc func requestAnswer(message: String) {
        
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
        view.name.text = defaultLocalizer.stringForKey(key: "error_title")
        view.image_icon.image = UIImage(named: "uncorrect_alert")
        view.name_content.text = "\(message)"
        view.ok.setTitle("OK", for: .normal)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissDialog))
        view.name.isUserInteractionEnabled = true
        view.name.addGestureRecognizer(tapGestureRecognizer)
        
        view.cancel.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
        view.ok.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
        
        alert.view.backgroundColor = .clear
        alert.view.addSubview(view)
        present(alert, animated: true, completion: nil)

    }
    
    @objc func dismissDialog() {
        alert.dismiss(animated: true, completion: nil)
    }
}

extension RoamingViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tabs_rouming", for: indexPath) as! TabRoamingCollectionCell
          if indexPath.row == 0 {
            cell.contentView.isHidden = false
            table.isHidden = true
            let titleOne = UILabel()
            var y_poz = 0
            let price_list_view = UIView()
            cell.country.isSearchEnable = false
            cell.country.selectedRowColor = .lightGray
            cell.country.y_pozition = 60 + (topPadding ?? 0) + 55
            cell.country.listHeight = UIScreen.main.bounds.size.height - ContainerViewController().tabBar.frame.size.height - (bottomPadding ?? 0) - (topPadding ?? 0) - 120
            cell.country.controller = "rouming"
            cell.country.text = countryChoosed
              
            if countriesData.count != 0 {
                self.countryChoosedId = countriesData[0][0]
                if countriesData[0][2] != "" {
                    self.countryChoosedImg = countriesData[1][3]
                }
                else {
                    self.countryChoosedImg = countriesData[1][3]
                }
            }
              
            cell.country.selectedRowColor = .clear
            cell.country.rowHeight = 44
            cell.country.didSelect { [self] (selectedText, index, id) in
                print(countriesData[index][0])
                self.countryChoosed = selectedText
                self.countryChoosedId = countriesData[index][0]
                if countriesData[index][2] != "" {
                    self.countryChoosedImg = countriesData[index][3]
                }
                else {
                    self.countryChoosedImg = countriesData[index][3]
                }
                titleOne.removeFromSuperview()
                price_list_view.removeFromSuperview()
                getRequest()
            }
            
            cell.country.optionArray.removeAll()
            cell.country.optionIds?.removeAll()
            for i in 0 ..< countriesData.count {
                cell.country.optionArray.append(countriesData[i][1])
                cell.country.optionIds?.append(Int(countriesData[i][0])!)
                cell.country.optionImageArray.append(countriesData[i][3])
            }
            
            cell.country.setView(.right, image: UIImage(named: "drop_icon")).isUserInteractionEnabled = false
            cell.country.setView(.left, image: UIImage(named: countryChoosedImg)).isUserInteractionEnabled = false
            cell.operatorType.setView(.right, image: UIImage(named: "drop_icon")).isUserInteractionEnabled = false
            
            cell.operatorType.y_pozition = 60 + (topPadding ?? 0) + 55
            cell.operatorType.listHeight = UIScreen.main.bounds.size.height - ContainerViewController().tabBar.frame.size.height - (bottomPadding ?? 0) - (topPadding ?? 0) - 120
            cell.operatorType.isSearchEnable = false
            cell.operatorType.selectedRowColor = .lightGray
            
            let paddingView2: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
            cell.operatorType.leftView = paddingView2
            cell.operatorType.leftViewMode = .always
            cell.operatorType.optionArray.removeAll()
            cell.operatorType.optionIds?.removeAll()
            
            if roamingOperatorsData.count != 0 {
                cell.operatorType.text = roamingOperatorsData[0][1]
                
                for i in 0 ..< roamingOperatorsData.count {
                    cell.operatorType.optionArray.append(roamingOperatorsData[i][1])
                    cell.operatorType.optionIds?.append(Int(roamingOperatorsData[i][0])!)
                }
                
                if operatorChargesData[0].price.count != 0 {
                    price_list_view.frame = CGRect(x: 0, y: 250, width: Int(view.frame.width), height: operatorChargesData[0].price.count * 55)
                    y_poz = 0
                    
                    for i in 0 ..< operatorChargesData[0].price.count {
                        let title = UILabel()
                        title.text = operatorChargesData[0].description[i]
                        title.frame = CGRect(x: 20, y: y_poz, width: title.text!.count * 10, height: 25)
                        title.numberOfLines = 0
                        title.textColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00)
                        title.font = UIFont.preferredFont(forTextStyle: .subheadline)
                        title.font = UIFont.systemFont(ofSize: 15)
                        title.lineBreakMode = NSLineBreakMode.byWordWrapping
                        title.textAlignment = .left
                                        
                        let title2 = UILabel()
                        title2.text = operatorChargesData[0].price[i]
                        title2.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (title2.text!.count * 10 + 15), y: y_poz, width: title2.text!.count * 10, height: 25)
                        title2.numberOfLines = 0
                        title2.textColor = colorBlackWhite
                        title2.font = UIFont.preferredFont(forTextStyle: .subheadline)
                        title2.font = UIFont.systemFont(ofSize: 15)
                        title2.lineBreakMode = NSLineBreakMode.byWordWrapping
                        title2.textAlignment = .right
                                        
                        let title_line = UILabel()
                        title_line.frame = CGRect(x: (title.text!.count * 10), y: y_poz + 12, width: Int(UIScreen.main.bounds.size.width) - (title2.text!.count * 10) - ((title.text!.count * 10)), height: 1)
                        title_line.backgroundColor = colorLightDarkGray
                                        
                        price_list_view.addSubview(title)
                        price_list_view.addSubview(title2)
                        price_list_view.addSubview(title_line)
                        y_poz += 30
                    }
                                    
                    cell.addSubview(price_list_view)
                                    
                    titleOne.text = defaultLocalizer.stringForKey(key: "all_prices")
                    titleOne.numberOfLines = 0
                    titleOne.textColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1)
                    titleOne.font = UIFont(name: "", size: 10)
                    titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
                    titleOne.textAlignment = .left
                    titleOne.frame = CGRect(x: 20, y: y_pozition + y_poz, width: Int(UIScreen.main.bounds.size.width) - 40, height: 100)
                    titleOne.autoresizesSubviews = true
                    titleOne.autoresizingMask = [.flexibleHeight, .flexibleWidth]
                                    
                    cell.addSubview(titleOne)
                }
                
                cell.operatorType.didSelect { [self] (selectedText, index, id) in
                    
                    print(countriesData[index][0])
                    self.roamingOperatorsChoosed = selectedText
                    self.roamingOperatorsChoosed = countriesData[index][0]
                    self.roamingOperatorsChoosedId = cell.operatorType.selectedIndex ?? 0
                    
                    let labels = getLabelsInView(view: price_list_view)
                    for label in labels {
                       label.removeFromSuperview()
                    }
                    price_list_view.removeFromSuperview()
                    titleOne.removeFromSuperview()
                    
                    price_list_view.frame = CGRect(x: 0, y: 250, width: Int(view.frame.width), height: operatorChargesData[index].price.count * 55)
                    y_poz = 0
                    
                    for i in 0 ..< operatorChargesData[Int(cell.operatorType.selectedIndex ?? 0)].price.count {
                                            
                        let title = UILabel()
                        title.text = operatorChargesData[Int(cell.operatorType.selectedIndex ?? 0)].description[i]
                        title.frame = CGRect(x: 20, y: y_poz, width: title.text!.count * 10, height: 25)
                        title.numberOfLines = 0
                        title.textColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00)
                        title.font = UIFont.preferredFont(forTextStyle: .subheadline)
                        title.font = UIFont.systemFont(ofSize: 15)
                        title.lineBreakMode = NSLineBreakMode.byWordWrapping
                        title.textAlignment = .left
                                            
                        let title2 = UILabel()
                        title2.text = operatorChargesData[Int(cell.operatorType.selectedIndex ?? 0)].price[i]
                        title2.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (title2.text!.count * 10 + 15), y: y_poz, width: title2.text!.count * 10, height: 25)
                        title2.numberOfLines = 0
                        title2.textColor = colorBlackWhite
                        title2.font = UIFont.preferredFont(forTextStyle: .subheadline)
                        title2.font = UIFont.systemFont(ofSize: 15)
                        title2.lineBreakMode = NSLineBreakMode.byWordWrapping
                        title2.textAlignment = .right
                                            
                        let title_line = UILabel()
                        title_line.frame = CGRect(x: (title.text!.count * 10), y: y_poz + 12, width: Int(UIScreen.main.bounds.size.width) - (title2.text!.count * 10) - ((title.text!.count * 10)), height: 1)
                        title_line.backgroundColor = colorLightDarkGray
                                            
                        price_list_view.addSubview(title)
                        price_list_view.addSubview(title2)
                        price_list_view.addSubview(title_line)
                        y_poz += 30
                    }
                                        
                    cell.addSubview(price_list_view)

                    titleOne.text = """
                            Все цены указаны в национальной валюте сомони с учетом акциза 7% и НДС 15%
                                            
                            Все звонки тарифицируются поминутно.
                            """
                    titleOne.numberOfLines = 0
                    titleOne.textColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1)
                    titleOne.font = UIFont(name: "", size: 10)
                    titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
                    titleOne.textAlignment = .left
                    titleOne.frame = CGRect(x: 20, y: y_pozition + y_poz, width: Int(UIScreen.main.bounds.size.width) - 40, height: 100)
                    titleOne.autoresizesSubviews = true
                    titleOne.autoresizingMask = [.flexibleHeight, .flexibleWidth]
                                        
                    cell.addSubview(titleOne)
                }
            }
            else {
                cell.operatorType.text = defaultLocalizer.stringForKey(key: "no_operators")
                cell.operatorType.optionArray.append(defaultLocalizer.stringForKey(key: "no_operators"))
                cell.operatorType.optionIds?.append(0)
                cell.operatorType.y_pozition = 60 + (topPadding ?? 0) + 55 + cell.operatorType.frame.origin.y + 55
                cell.operatorType.listHeight = 30
                cell.operatorType.didSelect { [self] (selectedText, index, id) in
                }
            }
        }
        else if indexPath.row == 1 {
            cell.contentView.isHidden = true
            table.register(RoumingTableCell.self, forCellReuseIdentifier: "roming_list_cell")
            table.register(RoumingTopViewCell.self, forCellReuseIdentifier: "roaming_top")
            table.frame = CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width - 20, height: UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 120 + (topPadding ?? 0) + (bottomPadding ?? 0)))
            table.delegate = self
            table.dataSource = self
            table.rowHeight = 60
            table.estimatedRowHeight = 60
            table.alwaysBounceVertical = false
            table.backgroundColor = contentColor
            table.isHidden = false
            cell.addSubview(table)
           
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
 
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == tabCollectionView {
            if indexPath.row == 0 {
                roamingView.countriesConditionsTab.textColor = colorBlackWhite
                roamingView.informationTab.textColor = .gray
                roamingView.countriesTabLine.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
                roamingView.informationTabLine.backgroundColor = .clear
                
            } else {
                roamingView.countriesConditionsTab.textColor = .gray
                roamingView.informationTab.textColor = colorBlackWhite
                roamingView.countriesTabLine.backgroundColor = .clear
                roamingView.informationTabLine.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
          }
       }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(indexPath.row)
        if collectionView == tabCollectionView {
            if indexPath.row == 0 {
                roamingView.countriesConditionsTab.textColor = .gray
                roamingView.informationTab.textColor = colorBlackWhite
                roamingView.countriesTabLine.backgroundColor = .clear
                roamingView.informationTabLine.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
          }
         else {
             roamingView.countriesConditionsTab.textColor = colorBlackWhite
             roamingView.informationTab.textColor = .gray
             roamingView.countriesTabLine.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
             roamingView.informationTabLine.backgroundColor = .clear
          }
       }
    }
}


extension RoamingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return questionsData.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if questionsData[section][3] == "true" {
            return 2
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 78
        }
        else {
            return row_height[indexPath.section] + 10
        }
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = table.dequeueReusableCell(withIdentifier: "roaming_top", for: indexPath) as! RoumingTopViewCell
            
            cell.cellTitle.text = questionsData[indexPath.section][1]
            
            if questionsData[indexPath.section][3] == "true" {
                cell.separatorInset = UIEdgeInsets.init(top: -10, left: UIScreen.main.bounds.size.width, bottom: -10, right: 0)
            }
            
            let bgColorView = UIView()
            bgColorView.backgroundColor = .clear
            cell.selectedBackgroundView = bgColorView
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "roming_list_cell", for: indexPath) as! RoumingTableCell
                
            cell.separatorInset = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
            
            cell.descript.text = questionsData[indexPath.section][2]
            
            cell.descript.frame = CGRect(x: 10, y: 10, width: UIScreen.main.bounds.size.width - 40, height: CGFloat.greatestFiniteMagnitude)
            cell.descript.numberOfLines = 0
            cell.descript.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.descript.sizeToFit()
            print(cell.descript.frame.height)
            row_height[indexPath.section] = cell.descript.frame.height
            
            let bgColorView = UIView()
            bgColorView.backgroundColor = .clear
            cell.selectedBackgroundView = bgColorView
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = table.dequeueReusableCell(withIdentifier: "roaming_top", for: indexPath) as! RoumingTopViewCell
        
        table.deselectRow(at: indexPath, animated: true)
        if questionsData[indexPath.section][3] == "false" {
            cell.backgroundColor = colorLightDarkGray
            questionsData[indexPath.section][3] = "true"
            cell.cellButton.setImage(#imageLiteral(resourceName: "drop_icon2"), for: UIControl.State.normal)
                
        }
        else {
            cell.backgroundColor = .clear
            questionsData[indexPath.section][3] = "false"
            cell.cellButton.setImage(#imageLiteral(resourceName: "drop_icon"), for: UIControl.State.normal)
        }
        UIView.setAnimationsEnabled(false)
        self.table.beginUpdates()
        self.table.reloadSections([indexPath.section], with: .none)
        self.table.endUpdates()
    }
}
