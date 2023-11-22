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



class FAQViewController: UIViewController, UIScrollViewDelegate {
    
    let disposeBag = DisposeBag()
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    var alert = UIAlertController()
    let scrollView = UIScrollView()
    
    var toolbar = TarifToolbarView()
    var faq_view = FAQView()
    let table = UITableView()
    
    let TabCollectionView: UICollectionView = {
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
    var questions_data = [[String]]()
    var countries_data = [[String]]()
    var roamingOperators_data = [[String]]()
    var operatorCharges_data = [[String]]()
    var operatorCharges_Data = [operatorChargeData(description: [String](), price: [String]())]
    
    var row_height = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    
    var country_choosed = ""
    var country_choosed_id = "0"
    var country_choosed_img = ""
    var roamingOperators_choosed = ""
    var roamingOperators_choosed_id = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = toolbarColor
        operatorCharges_Data.removeAll()
        roamingOperators_data.removeAll()
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
        navigationController?.popViewController(animated: true)
    }
    
    func setupView() {
        view.backgroundColor = contentColor
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.backgroundColor = contentColor
        
        if operatorCharges_Data.count != 0 {
            scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + CGFloat(operatorCharges_Data[roamingOperators_choosed_id].price.count * 55))
        }
        else {
            scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        }
        
        scrollView.isScrollEnabled = false
        view.addSubview(scrollView)
  
        toolbar = TarifToolbarView(frame: CGRect(x: 0, y: topPadding ?? 0, width: UIScreen.main.bounds.size.width, height: 60))
        faq_view = FAQView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 60 + (topPadding ?? 0) + (bottomPadding ?? 0))))
      
        self.view.addSubview(toolbar)
        scrollView.addSubview(faq_view)
        
        toolbar.icon_back.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        toolbar.number_user_name.text = defaultLocalizer.stringForKey(key: "FAQ")
        toolbar.backgroundColor = contentColor
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goBack))
        toolbar.isUserInteractionEnabled = true
        toolbar.addGestureRecognizer(tapGestureRecognizer)
        
    
       // let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(tab2Click))
       // rouming_view.tab2.isUserInteractionEnabled = true
       // rouming_view.tab2.addGestureRecognizer(tapGestureRecognizer2)
        
        TabCollectionView.backgroundColor = .clear
        TabCollectionView.frame = CGRect(x: 0, y: 65, width: Int(UIScreen.main.bounds.size.width), height: Int(UIScreen.main.bounds.size.height - 104))
        TabCollectionView.delegate = self
        TabCollectionView.dataSource = self
        TabCollectionView.alwaysBounceVertical = false
        scrollView.addSubview(TabCollectionView)
        
        scrollView.frame = CGRect(x: 0, y: 60 + (topPadding ?? 0), width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 60 + (topPadding ?? 0) + (bottomPadding ?? 0)))
        
      //  getRequest()
    }
    
   
    
    func sendRequest() {
        let client = APIClient.shared
            do{
              try client.charhiIqbolMain().subscribe(
                onNext: { result in
                  print(result)
                    DispatchQueue.main.async { [self] in
                        for i in 0 ..< result.faqs.count {
                            questions_data.append([String(result.faqs[i].id), String(result.faqs[i].question ?? ""), String(result.faqs[i].answer ?? ""), "false"])
                        }
                        
                       
                       
                        
                    }
                },
                onError: { error in
                   print(error.localizedDescription)
                    DispatchQueue.main.async { [self] in
                        setupView()
                        hideActivityIndicator(uiView: self.view)
                        requestAnswer(message: defaultLocalizer.stringForKey(key: "service is temporarily unavailable"))
                    }
                },
                onCompleted: {
                    client.requestObservable.tabIndicator = "1"
                    DispatchQueue.main.async { [self] in
                        setupView()
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
        //alert.view.sendSubviewToBack(view)
        
        present(alert, animated: true, completion: nil)

    }
    
    @objc func dismissDialog() {
        alert.dismiss(animated: true, completion: nil)
    }
}

extension FAQViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tabs_rouming", for: indexPath) as! TabRoamingCollectionCell
        scrollView.showsVerticalScrollIndicator = false
            cell.contentView.isHidden = true
            table.register(RoumingTableCell.self, forCellReuseIdentifier: "roming_list_cell")
            table.register(RoumingTopViewCell.self, forCellReuseIdentifier: "roaming_top")
            table.frame = CGRect(x: 0, y: 15, width: UIScreen.main.bounds.size.width - 20, height: UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 120 + (topPadding ?? 0) + (bottomPadding ?? 0)))
            table.delegate = self
            table.dataSource = self
            table.rowHeight = 60
            table.estimatedRowHeight = 60
            table.alwaysBounceVertical = false
            table.backgroundColor = contentColor
            table.isHidden = false
            cell.addSubview(table)
           
        
        return cell
    }

    
    
}


extension FAQViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return questions_data.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if questions_data[section][3] == "true" {
            return 2
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 60
        }
        else {
            return row_height[indexPath.section] + 10
        }
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = table.dequeueReusableCell(withIdentifier: "roaming_top", for: indexPath) as! RoumingTopViewCell
            
            cell.cellTitle.text = questions_data[indexPath.section][1]
            
            if questions_data[indexPath.section][3] == "true" {
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
            
            cell.descript.text = questions_data[indexPath.section][2]
            cell.descript.textColor = darkGrayLight
            cell.descript.frame = CGRect(x: 20, y: 25, width: UIScreen.main.bounds.size.width - 40, height: CGFloat.greatestFiniteMagnitude)
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
        
        print("a")
        table.deselectRow(at: indexPath, animated: true)
       // print(cell.opisanie.frame.height)
        if questions_data[indexPath.section][3] == "false" {
            print("b")
            cell.backgroundColor = colorLightDarkGray
            questions_data[indexPath.section][3] = "true"
            cell.cellButton.setImage(#imageLiteral(resourceName: "drop_icon2"), for: UIControl.State.normal)
                
        }
        else {
            print("c")
            cell.backgroundColor = .clear
            questions_data[indexPath.section][3] = "false"
            cell.cellButton.setImage(#imageLiteral(resourceName: "drop_icon"), for: UIControl.State.normal)
        }
    
        UIView.setAnimationsEnabled(false)
        self.table.beginUpdates()
        self.table.reloadSections([indexPath.section], with: .none)
        self.table.endUpdates()
    }
    
}
