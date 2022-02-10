//
//  AddionalTraficsViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/12/21.
//

import UIKit

var color1 = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
var color2 = UIColor.white

class AddionalTraficsViewController: UIViewController, UIScrollViewDelegate {

    let scrollView = UIScrollView()
    
    var toolbar = TarifToolbarView()
    var addional_view = AddionalTraficsView()
    let remainderView = RemainderStackView()
    
    var x_pozition = 20
    var y_pozition = 310
    
    let table = UITableView()
    let table2 = UITableView()
    let table3 = UITableView()
    let table4 = UITableView()
    
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
        
        color1 = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
        color2 = UIColor.white
        
        setupView()
        setupRemaindersSection()
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
        addional_view = AddionalTraficsView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        
        toolbar.number_user_name.text = "Подключить пакеты"
        self.view.addSubview(toolbar)
        scrollView.addSubview(addional_view)
        
        toolbar.icon_back.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        
        scrollView.frame = CGRect(x: 0, y: 104, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 104)
    }


    func setupRemaindersSection(){
        scrollView.addSubview(remainderView)
        remainderView.frame = CGRect(x: 0, y: 10, width: UIScreen.main.bounds.size.width, height: 140)
        remainderView.internetRemainder.serviceTitle = "\(19) \n\("mb")"
        remainderView.messagesRemainder.serviceTitle = "\(10) \n\("sms")"
        remainderView.minutesRemainder.serviceTitle = "\(0) \n\("min")"
        remainderView.internetRemainder.spentProgress = CGFloat(0.1)
        remainderView.messagesRemainder.spentProgress = CGFloat(0.5)
        remainderView.minutesRemainder.spentProgress = CGFloat(0.7)
        remainderView.messagesRemainder.plusText.isHidden = true
        remainderView.messagesRemainder.backgroundColor = .clear
       // remainderView.
    }

    func setupTabCollectionView() {
        y_pozition = y_pozition + 55
        
        addional_view.tab1.frame = CGRect(x: 10, y: y_pozition, width: (Int(UIScreen.main.bounds.size.width) - 40) / 4, height: 40)
        addional_view.tab2.frame = CGRect(x: addional_view.tab1.frame.width + 10, y: CGFloat(y_pozition), width: (UIScreen.main.bounds.size.width - 20) / 4, height: 40)
        addional_view.tab3.frame = CGRect(x: (Int(addional_view.tab1.frame.width) * 2) + 20, y: y_pozition, width: (Int(UIScreen.main.bounds.size.width) - 40) / 4, height: 40)
        addional_view.tab4.frame = CGRect(x: (addional_view.tab1.frame.width * 3) + 30, y: CGFloat(y_pozition), width: (UIScreen.main.bounds.size.width - 40) / 4, height: 40)
        
        
        addional_view.tab1Line.frame = CGRect(x: 10, y: y_pozition + 40, width: (Int(UIScreen.main.bounds.size.width) - 40) / 4, height: 3)
        addional_view.tab2Line.frame = CGRect(x: addional_view.tab1.frame.width + 10, y: CGFloat(y_pozition + 40), width: (UIScreen.main.bounds.size.width - 40) / 4, height: 3)
        addional_view.tab3Line.frame = CGRect(x: CGFloat((Int(addional_view.tab1.frame.width) * 2) + 20), y: CGFloat(y_pozition + 40), width: (UIScreen.main.bounds.size.width - 40) / 4, height: 3)
        addional_view.tab4Line.frame = CGRect(x: (addional_view.tab1.frame.width * 3) + 30, y: CGFloat(y_pozition + 40), width: (UIScreen.main.bounds.size.width - 40) / 4, height: 3)
        
        scrollView.addSubview(TabCollectionServiceView)
        TabCollectionServiceView.backgroundColor = .white
        TabCollectionServiceView.frame = CGRect(x: 0, y: y_pozition + 45, width: Int(UIScreen.main.bounds.size.width), height: Int(UIScreen.main.bounds.size.height - 150))
        TabCollectionServiceView.delegate = self
        TabCollectionServiceView.dataSource = self
        TabCollectionServiceView.alwaysBounceVertical = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.scrollView == scrollView {
            if scrollView.contentOffset.y > addional_view.tab1.frame.origin.y {
                remainderView.isHidden = true
                //servicesView.searchField.isHidden = true
                self.scrollView.contentOffset.y = 0
                addional_view.tab1.frame.origin.y = 0
                addional_view.tab2.frame.origin.y = 0
                addional_view.tab1Line.frame.origin.y = 40
                addional_view.tab2Line.frame.origin.y = 40
                addional_view.tab3.frame.origin.y = 0
                addional_view.tab4.frame.origin.y = 0
                addional_view.tab3Line.frame.origin.y = 40
                addional_view.tab4Line.frame.origin.y = 40
                TabCollectionServiceView.frame.origin.y = 45
            }
            if scrollView.contentOffset.y < -10 && remainderView.isHidden == true {
                remainderView.isHidden = false
                //servicesView.searchField.isHidden = false
                self.scrollView.contentOffset.y = 104
                addional_view.tab1.frame.origin.y = CGFloat(y_pozition)
                addional_view.tab2.frame.origin.y = CGFloat(y_pozition)
                addional_view.tab1Line.frame.origin.y = CGFloat(y_pozition + 40)
                addional_view.tab2Line.frame.origin.y = CGFloat(y_pozition + 40)
                addional_view.tab3.frame.origin.y = CGFloat(y_pozition)
                addional_view.tab4.frame.origin.y = CGFloat(y_pozition)
                addional_view.tab3Line.frame.origin.y = CGFloat(y_pozition + 40)
                addional_view.tab4Line.frame.origin.y = CGFloat(y_pozition + 40)
                TabCollectionServiceView.frame.origin.y = CGFloat(y_pozition + 45)
               
            }
        }
    }
}

extension AddionalTraficsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tabs", for: indexPath) as! TabCollectionServiceViewCell
        if indexPath.row == 0 {
            table.register(ServicesTableViewCell.self, forCellReuseIdentifier: cellID4)
            table.frame = CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width - 20, height: UIScreen.main.bounds.size.height - 150)
            table.delegate = self
            table.dataSource = self
            table.rowHeight = 130
            table.estimatedRowHeight = 130
            table.alwaysBounceVertical = false
            table.showsVerticalScrollIndicator = false
            cell.addSubview(table)
        }
        else if indexPath.row == 1 {
            table2.register(ServicesTableViewCell.self, forCellReuseIdentifier: cellID4)
            table2.frame = CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width - 20, height: UIScreen.main.bounds.size.height - 150)
            table2.delegate = self
            table2.dataSource = self
            table2.rowHeight = 130
            table2.estimatedRowHeight = 130
            table2.alwaysBounceVertical = false
            table2.showsVerticalScrollIndicator = false
            cell.addSubview(table2)
        }
        else if indexPath.row == 2 {
            table3.register(ServicesTableViewCell.self, forCellReuseIdentifier: cellID4)
            table3.frame = CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width - 20, height: UIScreen.main.bounds.size.height - 150)
            table3.delegate = self
            table3.dataSource = self
            table3.rowHeight = 130
            table3.estimatedRowHeight = 130
            table3.alwaysBounceVertical = false
            table3.showsVerticalScrollIndicator = false
            cell.addSubview(table3)
        }
        else if indexPath.row == 3 {
            table4.register(ServicesTableViewCell.self, forCellReuseIdentifier: cellID4)
            table4.frame = CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width - 20, height: UIScreen.main.bounds.size.height - 150)
            table4.delegate = self
            table4.dataSource = self
            table4.rowHeight = 130
            table4.estimatedRowHeight = 130
            table4.alwaysBounceVertical = false
            table4.showsVerticalScrollIndicator = false
            cell.addSubview(table4)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
      
        if indexPath.row == 0 {
            addional_view.tab1.textColor = .black
            addional_view.tab2.textColor = .gray
            addional_view.tab3.textColor = .gray
            addional_view.tab4.textColor = .gray
            addional_view.tab1Line.backgroundColor = .orange
            addional_view.tab2Line.backgroundColor = .clear
            addional_view.tab3Line.backgroundColor = .clear
            addional_view.tab4Line.backgroundColor = .clear
        } else if indexPath.row == 2 {
            addional_view.tab1.textColor = .gray
            addional_view.tab2.textColor = .gray
            addional_view.tab3.textColor = .black
            addional_view.tab4.textColor = .gray
            addional_view.tab1Line.backgroundColor = .clear
            addional_view.tab2Line.backgroundColor = .clear
            addional_view.tab3Line.backgroundColor = .orange
            addional_view.tab4Line.backgroundColor = .clear
        }
       if indexPath.row == 1 {
            addional_view.tab1.textColor = .gray
            addional_view.tab2.textColor = .black
            addional_view.tab3.textColor = .gray
            addional_view.tab4.textColor = .gray
            addional_view.tab1Line.backgroundColor = .clear
            addional_view.tab2Line.backgroundColor = .orange
            addional_view.tab3Line.backgroundColor = .clear
            addional_view.tab4Line.backgroundColor = .clear
        } else if indexPath.row == 3 {
            addional_view.tab1.textColor = .gray
            addional_view.tab2.textColor = .gray
            addional_view.tab3.textColor = .gray
            addional_view.tab4.textColor = .black
            addional_view.tab1Line.backgroundColor = .clear
            addional_view.tab2Line.backgroundColor = .clear
            addional_view.tab3Line.backgroundColor = .clear
            addional_view.tab4Line.backgroundColor = .orange
        }
          
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //print(indexPath.row == 0)
        if indexPath.row == 0 {
            print("d")
            addional_view.tab1.textColor = .gray
            addional_view.tab2.textColor = .black
            addional_view.tab3.textColor = .gray
            addional_view.tab4.textColor = .gray
            addional_view.tab1Line.backgroundColor = .clear
            addional_view.tab2Line.backgroundColor = .orange
            addional_view.tab3Line.backgroundColor = .clear
            addional_view.tab4Line.backgroundColor = .clear
        }
        else if indexPath.row == 3 {
            addional_view.tab1.textColor = .gray
            addional_view.tab2.textColor = .gray
            addional_view.tab3.textColor = .black
            addional_view.tab4.textColor = .gray
            addional_view.tab1Line.backgroundColor = .clear
            addional_view.tab2Line.backgroundColor = .clear
            addional_view.tab3Line.backgroundColor = .orange
            addional_view.tab4Line.backgroundColor = .clear
        }
    }
}

extension AddionalTraficsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID4, for: indexPath) as! ServicesTableViewCell
            cell.separatorInset = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
         
            return cell
        
    }
    
    
}
