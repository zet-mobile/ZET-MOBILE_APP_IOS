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
    
    let table = UITableView()
    
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

    func setupView() {
        view.backgroundColor = toolbarColor
        
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
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 805)
        view.addSubview(scrollView)
        
        toolbar = TarifToolbarView(frame: CGRect(x: 0, y: 44, width: UIScreen.main.bounds.size.width, height: 60))
        usage_view = UsageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
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
        
        scrollView.frame = CGRect(x: 0, y: 104, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 104)
        
        usage_view.get_Detaization.addTarget(self, action: #selector(openDetalazition), for: .touchUpInside)
    }

    func setupUsages() {
        
        UsageCollectionView.backgroundColor = colorGrayWhite
        UsageCollectionView.layer.cornerRadius = 10
        UsageCollectionView.frame = CGRect(x: 20, y: 70, width: UIScreen.main.bounds.size.width - 40, height: 250)
        UsageCollectionView.delegate = self
        UsageCollectionView.dataSource = self
        scrollView.addSubview(UsageCollectionView)
    }
    
    func setupHistoryUsagesTableView() {
        scrollView.addSubview(table)
        table.frame = CGRect(x: 0, y: 470, width: UIScreen.main.bounds.size.width, height: 700)
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
            usage_view.tab1Line.backgroundColor = .orange
            usage_view.tab2Line.backgroundColor = .clear
            usage_view.tab3Line.backgroundColor = .clear
            UsageCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        }
    }
    
    @objc func tab2Click() {
        usage_view.tab2.showAnimation { [self] in
            usage_view.tab1.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
            usage_view.tab2.textColor = colorBlackWhite
            usage_view.tab3.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
            usage_view.tab1Line.backgroundColor = .clear
            usage_view.tab2Line.backgroundColor = .orange
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
            usage_view.tab3Line.backgroundColor = .orange
            UsageCollectionView.scrollToItem(at: IndexPath(item: 2, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        }
        
    }
    
    func sendRequest() {
        let client = APIClient.shared
            do{
              try client.usageGetRequest().subscribe(
                onNext: { result in
                  print(result)
                    DispatchQueue.main.async {
                        self.usages_data.removeAll()
                        self.usages_data.append([String(result.lastDay.offnetMin!) , String(result.lastDay.onnetMin!), String(result.lastDay.internetMb!), String(result.lastDay.sms!), String(result.lastDay.tjs!)])
                        
                        self.usages_data.append([String(result.lastWeek.offnetMin!), String(result.lastWeek.onnetMin!), String(result.lastWeek.internetMb!), String(result.lastWeek.sms!), String(result.lastWeek.tjs!)])
                        
                        self.usages_data.append([String(result.lastMonth.offnetMin!), String(result.lastMonth.onnetMin!), String(result.lastMonth.internetMb!), String(result.lastMonth.sms!), String(result.lastMonth.tjs!)])
                        
                        
                        if result.history != nil {
                            for i in 0 ..< result.history!.count {
                                self.history_data.append([String(result.history![i].serviceName!), String(result.history![i].balanceChange!), String(result.history![i].transactionDate!)])
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
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
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
            
            cell.rez1.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (cell.rez1.text!.count * 15) - 45, y: 0, width: cell.rez1.text!.count * 15, height: 45)
            cell.rez2.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (cell.rez2.text!.count * 15 + 45), y: 47, width: cell.rez2.text!.count * 15, height: 45)
            cell.rez3.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (cell.rez3.text!.count * 15 + 45), y: 94, width: cell.rez3.text!.count * 15, height: 45)
            cell.rez4.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (cell.rez4.text!.count * 15 + 45), y: 141, width: cell.rez4.text!.count * 15, height: 45)
            cell.rez5.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (cell.rez5.text!.count * 15 + 45), y: 188, width: cell.rez5.text!.count * 15, height: 45)
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
      
        if indexPath.row == 0 {
            usage_view.tab1.textColor = colorBlackWhite
            usage_view.tab2.textColor = .gray
            usage_view.tab3.textColor = .gray
            usage_view.tab1Line.backgroundColor = .orange
            usage_view.tab2Line.backgroundColor = .clear
            usage_view.tab3Line.backgroundColor = .clear
        } else if indexPath.row == 2 {
            usage_view.tab1.textColor = .gray
            usage_view.tab2.textColor = .gray
            usage_view.tab3.textColor = colorBlackWhite
            usage_view.tab1Line.backgroundColor = .clear
            usage_view.tab2Line.backgroundColor = .clear
            usage_view.tab3Line.backgroundColor = .orange
        }
          
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //print(indexPath.row == 0)
        if indexPath.row == 0 {
            print("d")
            usage_view.tab1.textColor = .gray
            usage_view.tab2.textColor = colorBlackWhite
            usage_view.tab3.textColor = .gray
            usage_view.tab1Line.backgroundColor = .clear
            usage_view.tab2Line.backgroundColor = .orange
            usage_view.tab3Line.backgroundColor = .clear
        }
        else if indexPath.row == 2 {
            usage_view.tab1.textColor = .gray
            usage_view.tab2.textColor = colorBlackWhite
            usage_view.tab3.textColor = .gray
            usage_view.tab1Line.backgroundColor = .clear
            usage_view.tab2Line.backgroundColor = .orange
            usage_view.tab3Line.backgroundColor = .clear
        }
    }
}

extension UsageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if history_data.count != 0 {
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
        dateFormatter1.dateFormat = "dd.MM.yyyy HH:mm:ss"
        let date = dateFormatter1.date(from: history_data[section][2])
        dateFormatter1.dateFormat = "dd MMMM"
        dateFormatter1.locale = Locale(identifier: "ru_RU")
        view.title.text = dateFormatter1.string(from: date!)
        
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
        cell.titleThree.text = history_data[indexPath.section][1] + " с"
        
        if Double(history_data[indexPath.section][1])! > 0 {
            cell.titleThree.textColor = UIColor(red: 0.15, green: 0.68, blue: 0.38, alpha: 1.00)
            cell.titleTwo.text = "Пополнение"
        }
        else {
            cell.titleThree.textColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00)
            cell.titleTwo.text = "Списание"
        }
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "dd.MM.yyyy HH:mm:ss"
        let date = dateFormatter1.date(from: history_data[indexPath.section][2])
        dateFormatter1.dateFormat = "HH:mm"
        
        cell.titleFour.text = dateFormatter1.string(from: date!)
        return cell
    }
    
    
}
