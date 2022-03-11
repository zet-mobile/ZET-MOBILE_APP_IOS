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
    var y_pozition = 150
    
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
        
        var textColor = UIColor.black
        var textColor2 = UIColor.lightGray
        
        var number_label: NSString = "356" as NSString
        var range = (number_label).range(of: number_label as String)
        var number_label_String = NSMutableAttributedString.init(string: number_label as String)
        number_label_String.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor , range: range)
        number_label_String.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)], range: range)
        
        var title_label = "\n минут из 350" as NSString
        var titleString = NSMutableAttributedString.init(string: title_label as String)
        var range2 = (title_label).range(of: title_label as String)
        titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor2, range: range2)
        titleString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11)], range: range2)
        
        number_label_String.append(titleString)
        remainderView.minutesRemainder.text.attributedText = number_label_String
       
        number_label = "7060" as NSString
        title_label = "\n мегабайт из 4500" as NSString
        range = (number_label).range(of: number_label as String)
        number_label_String = NSMutableAttributedString.init(string: number_label as String)
        number_label_String.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: range)
        number_label_String.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)], range: range)
        
        titleString = NSMutableAttributedString.init(string: title_label as String)
        range2 = (title_label).range(of: title_label as String)
        titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor2, range: range2)
        titleString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11)], range: range2)
        
        number_label_String.append(titleString)
        remainderView.internetRemainder.text.attributedText = number_label_String
        
        let b = "0"
        if b == "0" {
            textColor = .red
        }
        number_label = "0" as NSString
        title_label = "\n SMS из 150" as NSString
        range = (number_label).range(of: number_label as String)
        number_label_String = NSMutableAttributedString.init(string: number_label as String)
        number_label_String.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: range)
        number_label_String.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)], range: range)
        
        titleString = NSMutableAttributedString.init(string: title_label as String)
        range2 = (title_label).range(of: title_label as String)
        titleString.addAttribute(NSAttributedString.Key.foregroundColor, value:textColor2, range: range2)
        titleString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11)], range: range2)
        
        number_label_String.append(titleString)
        remainderView.messagesRemainder.text.attributedText = number_label_String
        
        remainderView.internetRemainder.spentProgress = CGFloat(0.1)
        remainderView.messagesRemainder.spentProgress = CGFloat(0.5)
        remainderView.minutesRemainder.spentProgress = CGFloat(0.7)
        remainderView.messagesRemainder.plusText.isHidden = true
        remainderView.messagesRemainder.backgroundColor = .clear
       // remainderView.
    }

    func setupTabCollectionView() {
        y_pozition = y_pozition + 55
        
        addional_view.tab1.frame = CGRect(x: 10, y: y_pozition, width: (Int(UIScreen.main.bounds.size.width) - 40) / 3, height: 40)
        addional_view.tab2.frame = CGRect(x: addional_view.tab1.frame.width + 10, y: CGFloat(y_pozition), width: (UIScreen.main.bounds.size.width - 20) / 3, height: 40)
        addional_view.tab3.frame = CGRect(x: (Int(addional_view.tab1.frame.width) * 2) + 20, y: y_pozition, width: (Int(UIScreen.main.bounds.size.width) - 40) / 3, height: 40)
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tab1Click))
        addional_view.tab1.isUserInteractionEnabled = true
        addional_view.tab1.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(tab2Click))
        addional_view.tab2.isUserInteractionEnabled = true
        addional_view.tab2.addGestureRecognizer(tapGestureRecognizer2)
        
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(tab3Click))
        addional_view.tab3.isUserInteractionEnabled = true
        addional_view.tab3.addGestureRecognizer(tapGestureRecognizer3)
        
        
        addional_view.tab1Line.frame = CGRect(x: 10, y: y_pozition + 40, width: (Int(UIScreen.main.bounds.size.width) - 40) / 3, height: 3)
        addional_view.tab2Line.frame = CGRect(x: addional_view.tab1.frame.width + 10, y: CGFloat(y_pozition + 40), width: (UIScreen.main.bounds.size.width - 40) / 3, height: 3)
        addional_view.tab3Line.frame = CGRect(x: CGFloat((Int(addional_view.tab1.frame.width) * 2) + 20), y: CGFloat(y_pozition + 40), width: (UIScreen.main.bounds.size.width - 40) / 3, height: 3)
        
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
                addional_view.tab3Line.frame.origin.y = 40
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
                addional_view.tab3Line.frame.origin.y = CGFloat(y_pozition + 40)
                TabCollectionServiceView.frame.origin.y = CGFloat(y_pozition + 45)
               
            }
        }
    }
    
    @objc func tab1Click() {
        addional_view.tab1.textColor = .black
        addional_view.tab2.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        addional_view.tab3.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        addional_view.tab1Line.backgroundColor = .orange
        addional_view.tab2Line.backgroundColor = .clear
        addional_view.tab3Line.backgroundColor = .clear
        TabCollectionServiceView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
    }
    
    @objc func tab2Click() {
        addional_view.tab1.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        addional_view.tab2.textColor = .black
        addional_view.tab3.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        addional_view.tab1Line.backgroundColor = .clear
        addional_view.tab2Line.backgroundColor = .orange
        addional_view.tab3Line.backgroundColor = .clear
        TabCollectionServiceView.scrollToItem(at: IndexPath(item: 1, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
    }
    
    @objc func tab3Click() {
        addional_view.tab1.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        addional_view.tab2.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        addional_view.tab3.textColor = .black
        addional_view.tab1Line.backgroundColor = .clear
        addional_view.tab2Line.backgroundColor = .clear
        addional_view.tab3Line.backgroundColor = .orange
        TabCollectionServiceView.scrollToItem(at: IndexPath(item: 2, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
    }
    
    @objc func tab4Click() {
        addional_view.tab1.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        addional_view.tab2.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        addional_view.tab3.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
       
        addional_view.tab1Line.backgroundColor = .clear
        addional_view.tab2Line.backgroundColor = .clear
        addional_view.tab3Line.backgroundColor = .clear
        TabCollectionServiceView.scrollToItem(at: IndexPath(item: 3, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
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
            table.rowHeight = 140
            table.estimatedRowHeight = 140
            table.alwaysBounceVertical = false
            table.showsVerticalScrollIndicator = false
            cell.addSubview(table)
        }
        else if indexPath.row == 1 {
            table2.register(ServicesTableViewCell.self, forCellReuseIdentifier: cellID4)
            table2.frame = CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width - 20, height: UIScreen.main.bounds.size.height - 150)
            table2.delegate = self
            table2.dataSource = self
            table2.rowHeight = 140
            table2.estimatedRowHeight = 140
            table2.alwaysBounceVertical = false
            table2.showsVerticalScrollIndicator = false
            cell.addSubview(table2)
        }
        else if indexPath.row == 2 {
            table3.register(ServicesTableViewCell.self, forCellReuseIdentifier: cellID4)
            table3.frame = CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width - 20, height: UIScreen.main.bounds.size.height - 150)
            table3.delegate = self
            table3.dataSource = self
            table3.rowHeight = 140
            table3.estimatedRowHeight = 140
            table3.alwaysBounceVertical = false
            table3.showsVerticalScrollIndicator = false
            cell.addSubview(table3)
        }
        else if indexPath.row == 3 {
            table4.register(ServicesTableViewCell.self, forCellReuseIdentifier: cellID4)
            table4.frame = CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width - 20, height: UIScreen.main.bounds.size.height - 150)
            table4.delegate = self
            table4.dataSource = self
            table4.rowHeight = 140
            table4.estimatedRowHeight = 140
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
            addional_view.tab1Line.backgroundColor = .orange
            addional_view.tab2Line.backgroundColor = .clear
            addional_view.tab3Line.backgroundColor = .clear
        } else if indexPath.row == 2 {
            addional_view.tab1.textColor = .gray
            addional_view.tab2.textColor = .gray
            addional_view.tab3.textColor = .black
            addional_view.tab1Line.backgroundColor = .clear
            addional_view.tab2Line.backgroundColor = .clear
            addional_view.tab3Line.backgroundColor = .orange
        }
       if indexPath.row == 1 {
            addional_view.tab1.textColor = .gray
            addional_view.tab2.textColor = .black
            addional_view.tab3.textColor = .gray
            addional_view.tab1Line.backgroundColor = .clear
            addional_view.tab2Line.backgroundColor = .orange
            addional_view.tab3Line.backgroundColor = .clear
        } else if indexPath.row == 3 {
            addional_view.tab1.textColor = .gray
            addional_view.tab2.textColor = .gray
            addional_view.tab3.textColor = .gray
            addional_view.tab1Line.backgroundColor = .clear
            addional_view.tab2Line.backgroundColor = .clear
            addional_view.tab3Line.backgroundColor = .clear
        }
          
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //print(indexPath.row == 0)
        if indexPath.row == 0 {
            print("d")
            addional_view.tab1.textColor = .gray
            addional_view.tab2.textColor = .black
            addional_view.tab3.textColor = .gray
            addional_view.tab1Line.backgroundColor = .clear
            addional_view.tab2Line.backgroundColor = .orange
            addional_view.tab3Line.backgroundColor = .clear
        }
        else if indexPath.row == 3 {
            addional_view.tab1.textColor = .gray
            addional_view.tab2.textColor = .gray
            addional_view.tab3.textColor = .black
            addional_view.tab1Line.backgroundColor = .clear
            addional_view.tab2Line.backgroundColor = .clear
            addional_view.tab3Line.backgroundColor = .orange
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
