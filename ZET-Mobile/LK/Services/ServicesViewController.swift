//
//  ServicesViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/8/21.
//

import UIKit

class ServicesViewController: UIViewController, UIScrollViewDelegate {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        setupView()
        setupSliderSection()
        setupTabCollectionView()
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
            return 2
        }
        else {
            return 2
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == SliderView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID2, for: indexPath) as! SliderCollectionViewCell
            print(indexPath.row)
           
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
                cell.addSubview(table)
            }
            else {
                table2.register(ServicesTableViewCell.self, forCellReuseIdentifier: cellID4)
                table2.frame = CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width - 20, height: UIScreen.main.bounds.size.height - 150)
                table2.delegate = self
                table2.dataSource = self
                table2.rowHeight = 130
                table2.estimatedRowHeight = 130
                table2.alwaysBounceVertical = false
                cell.addSubview(table2)
            }
            return cell
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == table {
            let cell = tableView.dequeueReusableCell(withIdentifier: "serv_connect", for: indexPath) as! ServicesConnectTableViewCell
            cell.separatorInset = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
     
        //cell.textLabel?.text = characters[indexPath.row]
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID4, for: indexPath) as! ServicesTableViewCell
            cell.separatorInset = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
         
            //cell.textLabel?.text = characters[indexPath.row]
            return cell
        }
    }
    
    
}
