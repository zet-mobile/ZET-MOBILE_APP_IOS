//
//  UsageViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/2/21.
//

import UIKit
import RxSwift
import RxCocoa
import Toast_Swift

class UsageViewController: UIViewController, UIScrollViewDelegate {

    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    let disposeBag = DisposeBag()
    
    let scrollView = UIScrollView()
    var toolbar = TarifToolbarView()
    var usage_view = UsageView()
    
    let table = UITableView(frame: .zero, style: .grouped)
    
    let UsageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(UsageCollectionViewCell.self, forCellWithReuseIdentifier: "usages")
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        return cv
    }()
    
    var usages_data = [[String]]()
    var history_data = [[String]]()
    var activePage = 0
    var table_height = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showActivityIndicator(uiView: self.view)
        
        view.backgroundColor = toolbarColor
        sendRequest()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? .lightContent : .darkContent)
    }
    
    func setupView() {
        view.backgroundColor = toolbarColor
        
        table_height = history_data.count * 140
        
        if #available(iOS 11.0, *) {
            scrollView.scrollIndicatorInsets = view.safeAreaInsets
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.safeAreaInsets.bottom, right: 0)
        } else {
            // Fallback on earlier versions
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        }
        
        //self.UsageCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        if table_height == 0  {
            scrollView.contentSize = CGSize(width: view.frame.width, height: UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 60 + (topPadding ?? 0) + (bottomPadding ?? 0)))
            scrollView.isScrollEnabled = false
        }
        else {
            scrollView.contentSize = CGSize(width: view.frame.width, height: CGFloat(table_height) + 450)
            scrollView.isScrollEnabled = true
        }
        view.addSubview(scrollView)
        
        toolbar = TarifToolbarView(frame: CGRect(x: 0, y: topPadding ?? 0, width: UIScreen.main.bounds.size.width, height: 60))
        usage_view = UsageView(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.size.width), height: table_height + 500))
        
        toolbar.number_user_name.text = defaultLocalizer.stringForKey(key: "Expenses")
        toolbar.icon_back.isHidden = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tab1Click))
        usage_view.tab1.isUserInteractionEnabled = true
        usage_view.tab1.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(tab2Click))
        usage_view.tab2.isUserInteractionEnabled = true
        usage_view.tab2.addGestureRecognizer(tapGestureRecognizer2)
        
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(tab3Click))
        usage_view.tab3.isUserInteractionEnabled = true
        usage_view.tab3.addGestureRecognizer(tapGestureRecognizer3)
        
        view.addSubview(toolbar)
        scrollView.addSubview(usage_view)
        
        scrollView.frame = CGRect(x: 0, y: 60 + (topPadding ?? 0), width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 60 + (topPadding ?? 0) + (bottomPadding ?? 0)))
        
        usage_view.get_Detaization.addTarget(self, action: #selector(openDetalazition), for: .touchUpInside)
    }

    func setupUsages() {
        
        UsageCollectionView.backgroundColor = .clear
        UsageCollectionView.layer.cornerRadius = 10
        UsageCollectionView.frame = CGRect(x: 0, y: 70, width: UIScreen.main.bounds.size.width, height: 240)
        UsageCollectionView.delegate = self
        UsageCollectionView.dataSource = self
        scrollView.addSubview(UsageCollectionView)
    }
    
    func setupHistoryUsagesTableView() {
        scrollView.addSubview(table)

        if table_height == 0  {
            table.frame = CGRect(x: 0, y: 470, width: Int(UIScreen.main.bounds.size.width), height: 200)
        }
        else {
            table.frame = CGRect(x: 0, y: 470, width: Int(UIScreen.main.bounds.size.width), height: Int(table_height))
        }
        
        table.register(HistoryUsageViewCell.self, forCellReuseIdentifier: "history_usage")
        table.register(HistoryHeaderCell.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 80
        table.estimatedRowHeight = 80
        table.sectionHeaderHeight = 35
        table.alwaysBounceVertical = false
        table.separatorStyle = .none
        table.isScrollEnabled = false
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = contentColor
        table.tableHeaderView?.backgroundColor = contentColor
      }
    
    
    @objc func openDetalazition(_ sender: UIButton) {
        sender.showAnimation { [self] in
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.pushViewController(DetalizationViewController(), animated: true)
        }
    }
    
    @objc func tab1Click() {
        usage_view.tab1.showAnimation { [self] in
            usage_view.tab1.textColor = colorBlackWhite
            usage_view.tab2.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
            usage_view.tab3.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
            usage_view.tab1Line.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
            usage_view.tab2Line.backgroundColor = .clear
            usage_view.tab3Line.backgroundColor = .clear
            UsageCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
            activePage = 0
        }
    }
    
    @objc func tab2Click() {
        usage_view.tab2.showAnimation { [self] in
            usage_view.tab1.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
            usage_view.tab2.textColor = colorBlackWhite
            usage_view.tab3.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
            usage_view.tab1Line.backgroundColor = .clear
            usage_view.tab2Line.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
            usage_view.tab3Line.backgroundColor = .clear
            UsageCollectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
            
        }
    }
    
    @objc func tab3Click() {
        usage_view.tab3.showAnimation { [self] in
            usage_view.tab1.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
            usage_view.tab2.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
            usage_view.tab3.textColor = colorBlackWhite
            usage_view.tab1Line.backgroundColor = .clear
            usage_view.tab2Line.backgroundColor = .clear
            usage_view.tab3Line.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
            UsageCollectionView.scrollToItem(at: IndexPath(item: 2, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
            activePage = 2
        }
        
    }
    
    func sendRequest() {
        history_data.removeAll()
        let client = APIClient.shared
            do{
              try client.usageGetRequest().subscribe(
                onNext: { result in
                  print(result)
                    DispatchQueue.main.async {
                        self.usages_data.removeAll()
                        if result.lastDay != nil {
                            self.usages_data.append([String(result.lastDay!.offnetMin!) , String(result.lastDay!.onnetMin!), String(result.lastDay!.internetMb!), String(result.lastDay!.sms!), String(result.lastDay!.tjs!)])
                        }
                        else {
                            self.usages_data.append(["0", "0", "0", "0", "0"])
                        }
                        
                        if result.lastWeek != nil {
                            self.usages_data.append([String(result.lastWeek!.offnetMin!), String(result.lastWeek!.onnetMin!), String(result.lastWeek!.internetMb!), String(result.lastWeek!.sms!), String(result.lastWeek!.tjs!)])
                        }
                        else {
                            self.usages_data.append(["0", "0", "0", "0", "0"])
                        }
                        
                        if result.lastMonth != nil {
                            self.usages_data.append([String(result.lastMonth!.offnetMin!), String(result.lastMonth!.onnetMin!), String(result.lastMonth!.internetMb!), String(result.lastMonth!.sms!), String(result.lastMonth!.tjs!)])
                        }
                        else {
                            self.usages_data.append(["0", "0", "0", "0", "0"])
                        }
                        
                        if result.history != nil {
                            for i in 0 ..< result.history!.count {
                                self.history_data.append([String(result.history![i].serviceName ?? ""), String(result.history![i].balanceChange ?? ""), String(result.history![i].transactionDate ??  "")])
                            }
                        }
                        else {
                            print("empty history")
                            DispatchQueue.main.async {
                                emptyView = EmptyView(frame: CGRect(x: 0, y: 30, width: self.table.frame.width, height: self.table.frame.height), text: self.defaultLocalizer.stringForKey(key: "no_expenses"))
                            self.table.separatorStyle = .none
                            self.table.backgroundView = emptyView
                            }
                        }
                    }
                },
                onError: { error in
                   print(error.localizedDescription)
                    DispatchQueue.main.async { [self] in
                        hideActivityIndicator(uiView: self.view)
                    }
                },
                onCompleted: {
                    DispatchQueue.main.async { [self] in
                        setupView()
                        setupUsages()
                        setupHistoryUsagesTableView()
                        hideActivityIndicator(uiView: view)
                    }
                   print("Completed event.")
                    
                }).disposed(by: disposeBag)
              }
              catch{
            }
    }
}

extension UsageViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.size.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "usages", for: indexPath) as! UsageCollectionViewCell
        if usages_data.count != 0 {
            cell.rez1.text = String(Int(Double(usages_data[indexPath.row][0])!))
            cell.rez2.text = String(Int(Double(usages_data[indexPath.row][1])!))
            cell.rez3.text = String(Int(Double(usages_data[indexPath.row][2])!))
            cell.rez4.text = String(Int(Double(usages_data[indexPath.row][3])!))
            cell.rez5.text = usages_data[indexPath.row][4]
            
            cell.rez1.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (cell.rez1.text!.count * 15) - 55, y: 0, width: cell.rez1.text!.count * 15, height: 45)
            cell.rez2.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (cell.rez2.text!.count * 15) - 55, y: 47, width: cell.rez2.text!.count * 15, height: 45)
            cell.rez3.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (cell.rez3.text!.count * 15) - 55, y: 94, width: cell.rez3.text!.count * 15, height: 45)
            cell.rez4.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (cell.rez4.text!.count * 15) - 55, y: 141, width: cell.rez4.text!.count * 15, height: 45)
            cell.rez5.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (cell.rez5.text!.count * 15) - 55, y: 188, width: cell.rez5.text!.count * 15, height: 45)
        }
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
           /* let pageFloat = (scrollView.contentOffset.x / scrollView.frame.size.width)
            let pageInt = Int(round(pageFloat))
            
            switch pageInt {
            case 0:
                UsageCollectionView.scrollToItem(at: [0, 2], at: .left, animated: false)
            case 3 - 1:
                UsageCollectionView.scrollToItem(at: [0, 1], at: .left, animated: false)
            default:
                break
        }*/
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
      
        print("indexPath.row")
        print(indexPath.row)
        if indexPath.row == 0 {
            
            usage_view.tab1.textColor = colorBlackWhite
            usage_view.tab2.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
            usage_view.tab3.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
            usage_view.tab1Line.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
            usage_view.tab2Line.backgroundColor = .clear
            usage_view.tab3Line.backgroundColor = .clear
            activePage = 0
        }
        else if indexPath.row == 1 {
            usage_view.tab1.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
            usage_view.tab2.textColor = colorBlackWhite
            usage_view.tab3.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
            usage_view.tab1Line.backgroundColor = .clear
            usage_view.tab2Line.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
            usage_view.tab3Line.backgroundColor = .clear
         
        }
        else if indexPath.row == 2 {
            usage_view.tab1.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
            usage_view.tab2.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
            usage_view.tab3.textColor = colorBlackWhite
            usage_view.tab1Line.backgroundColor = .clear
            usage_view.tab2Line.backgroundColor = .clear
            usage_view.tab3Line.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
            activePage = 2
        }
          
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //print(indexPath.row == 0)
        print("indexPath.row2")
        print(indexPath.row)
        if indexPath.row == 0 {
            usage_view.tab1.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
            usage_view.tab2.textColor = colorBlackWhite
            usage_view.tab3.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
            usage_view.tab1Line.backgroundColor = .clear
            usage_view.tab2Line.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
            usage_view.tab3Line.backgroundColor = .clear
        }
        else if indexPath.row == 1 {
            if activePage == 0  {
                usage_view.tab1.textColor = colorBlackWhite
                usage_view.tab2.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
                usage_view.tab3.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
                usage_view.tab1Line.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
                usage_view.tab2Line.backgroundColor = .clear
                usage_view.tab3Line.backgroundColor = .clear
            }
            else if activePage == 2 {
                usage_view.tab1.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
                usage_view.tab2.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
                usage_view.tab3.textColor = colorBlackWhite
                usage_view.tab1Line.backgroundColor = .clear
                usage_view.tab2Line.backgroundColor = .clear
                usage_view.tab3Line.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
            }
        }
        else if indexPath.row == 2 {
            usage_view.tab1.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
            usage_view.tab2.textColor = colorBlackWhite
            usage_view.tab3.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
            usage_view.tab1Line.backgroundColor = .clear
            usage_view.tab2Line.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
            usage_view.tab3Line.backgroundColor = .clear
        }
    }
}

extension UsageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if history_data.count != 0 {
            print("history_data.count")
            print(history_data.count)
            return history_data.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as! HistoryHeaderCell
        view.backgroundColor = contentColor
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter1.date(from: history_data[section][2])
        dateFormatter1.dateFormat = "dd-MM-yyyy"
        if date !=  nil {
            view.title.text = dateFormatter1.string(from: date!)
        }
       return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if history_data.count != 0 {
            return 1
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "history_usage", for: indexPath) as! HistoryUsageViewCell
        
        cell.titleOne.text = history_data[indexPath.section][0]
        cell.titleThree.text = history_data[indexPath.section][1] + " " + defaultLocalizer.stringForKey(key: "tjs")
        
        if Double(history_data[indexPath.section][1])! > 0 {
            cell.titleThree.textColor = UIColor(red: 0.15, green: 0.68, blue: 0.38, alpha: 1.00)
            cell.titleTwo.text = defaultLocalizer.stringForKey(key: "Replenishment")
        }
        else {
            cell.titleThree.textColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00)
            cell.titleTwo.text = defaultLocalizer.stringForKey(key: "Charge")
        }
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter1.date(from: history_data[indexPath.section][2])
        dateFormatter1.dateFormat = "HH:mm"
        
        if date !=  nil {
            cell.titleFour.text = dateFormatter1.string(from: date!)
        }
        return cell
    }
    
    
}
