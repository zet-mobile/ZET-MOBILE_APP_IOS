//
//  ZeroHelpViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/29/21.
//

import UIKit
import RxCocoa
import RxSwift

struct zeroHelpData {
    let date_header: String
    let packet_tax: [String]
    let packet_sum: [String]
    let packet_amount: [String]
    let credit_id: [String]
    let remaind_sum_amount: [String]
    let remaind_tax_amount: [String]
    let remaind_credit_amount: [String]
    let is_repayment: [String]
    let packet_name: [String]
    let created_at: [String]
}

class ZeroHelpViewController: UIViewController, UIScrollViewDelegate {
    
    var halfModalTransitioningDelegate: HalfModalTransitioningTwoDelegate?
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    let disposeBag = DisposeBag()
    
    let detailViewController = MoreDetailViewController()
    var nav = UINavigationController()
    var alert = UIAlertController()
    
    let scrollView = UIScrollView()
    
    var toolbar = TarifToolbarView()
    var zeroView = ZeroHelpView()
    let table = UITableView()
    let table2 = UITableView()
    
    var x_pozition = 20
    var y_pozition = 300
    
    let TabCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(TabZeroCollectionViewCell.self, forCellWithReuseIdentifier: "tabs")
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        return cv
    }()
    
    var balance = ""
    var message = ""
    var descrip = ""
    var lifetime = ""
    var arpu = ""
    var packets_data = [[String]]()
    var history_data = [[String]]()
    
    var HistoryData = [zeroHelpData(date_header: String(), packet_tax: [String](), packet_sum: [String](), packet_amount: [String](), credit_id: [String](), remaind_sum_amount: [String](), remaind_tax_amount: [String](), remaind_credit_amount: [String](), is_repayment: [String](), packet_name: [String](), created_at: [String]())]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showActivityIndicator(uiView: self.view)
        view.backgroundColor = toolbarColor
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
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupView() {
        view.backgroundColor = toolbarColor
  
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
        
        toolbar = TarifToolbarView(frame: CGRect(x: 0, y: 44, width: UIScreen.main.bounds.size.width, height: 60))
        zeroView = ZeroHelpView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 896))
        
        self.view.addSubview(toolbar)
        scrollView.addSubview(zeroView)
        
        toolbar.icon_back.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        toolbar.number_user_name.text = defaultLocalizer.stringForKey(key: "Help_at_zero")
        
        zeroView.balance.text = balance
        zeroView.rez1.text = arpu
        zeroView.rez2.text = lifetime
        
        zeroView.rez1.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (zeroView.rez1.text!.count * 15) - 50, y: 0, width: (zeroView.rez1.text!.count * 15), height: 55)
        zeroView.rez2.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (zeroView.rez2.text!.count * 15) - 50, y: 57, width: (zeroView.rez2.text!.count * 15), height: 45)
        
        scrollView.frame = CGRect(x: 0, y: 104, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 104)
    }

    func setupTabCollectionView() {
        y_pozition = y_pozition + 55
        
        zeroView.tab1.frame = CGRect(x: 0, y: y_pozition, width: Int(UIScreen.main.bounds.size.width) / 2, height: 40)
        zeroView.tab2.frame = CGRect(x: UIScreen.main.bounds.size.width / 2, y: CGFloat(y_pozition), width: UIScreen.main.bounds.size.width / 2, height: 40)
        
        zeroView.tab1Line.frame = CGRect(x: 10, y: y_pozition + 40, width: (Int(UIScreen.main.bounds.size.width) / 2) - 20, height: 3)
        zeroView.tab2Line.frame = CGRect(x: (UIScreen.main.bounds.size.width / 2) + 10, y: CGFloat(y_pozition + 40), width: (UIScreen.main.bounds.size.width / 2) - 20, height: 3)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tab1Click))
        zeroView.tab1.isUserInteractionEnabled = true
        zeroView.tab1.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(tab2Click))
        zeroView.tab2.isUserInteractionEnabled = true
        zeroView.tab2.addGestureRecognizer(tapGestureRecognizer2)
        
        scrollView.addSubview(TabCollectionView)
        TabCollectionView.backgroundColor = contentColor
        TabCollectionView.frame = CGRect(x: 0, y: y_pozition + 45, width: Int(UIScreen.main.bounds.size.width), height: Int(UIScreen.main.bounds.size.height - 150))
        TabCollectionView.delegate = self
        TabCollectionView.dataSource = self
        TabCollectionView.alwaysBounceVertical = false
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.scrollView == scrollView {
            if scrollView.contentOffset.y > zeroView.tab1.frame.origin.y {
                zeroView.titleOne.isHidden = true
                zeroView.balance.isHidden = true
                zeroView.image_banner.isHidden = true
                zeroView.white_view_back.isHidden = true
                self.scrollView.contentOffset.y = 0
                zeroView.tab1.frame.origin.y = 0
                zeroView.tab2.frame.origin.y = 0
                zeroView.tab1Line.frame.origin.y = 40
                zeroView.tab2Line.frame.origin.y = 40
                TabCollectionView.frame.origin.y = 45
            }
            if scrollView.contentOffset.y < -10 && zeroView.white_view_back.isHidden == true {
                zeroView.titleOne.isHidden = false
                zeroView.balance.isHidden = false
                zeroView.image_banner.isHidden = false
                zeroView.white_view_back.isHidden = false
                self.scrollView.contentOffset.y = 104
                zeroView.tab1.frame.origin.y = CGFloat(y_pozition)
                zeroView.tab2.frame.origin.y = CGFloat(y_pozition)
                zeroView.tab1Line.frame.origin.y = CGFloat(y_pozition + 40)
                zeroView.tab2Line.frame.origin.y = CGFloat(y_pozition + 40)
                TabCollectionView.frame.origin.y = CGFloat(y_pozition + 45)
               
            }
        }
    }
    
    @objc func tab1Click() {
        zeroView.tab1.textColor = colorBlackWhite
        zeroView.tab2.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        zeroView.tab1Line.backgroundColor = .orange
        zeroView.tab2Line.backgroundColor = .clear
        TabCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionView.ScrollPosition.right, animated: true)
    }
    
    @objc func tab2Click() {
        zeroView.tab1.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        zeroView.tab2.textColor = colorBlackWhite
        zeroView.tab1Line.backgroundColor = .clear
        zeroView.tab2Line.backgroundColor = .orange
        TabCollectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: UICollectionView.ScrollPosition.left, animated: true)
    }
    
    func sendRequest() {
        let client = APIClient.shared
            do{
              try client.getCreditRequest().subscribe(
                onNext: { result in
                  print(result)
                    DispatchQueue.main.async { [self] in
                        
                        self.balance = String(result.balance) + " с."
                        self.message = String(result.message)
                        self.lifetime = String(result.lifetime)
                        self.descrip = String(result.description)
                        self.arpu = String(result.arpu)
                        
                        if result.packets != nil {
                            if result.packets!.count != 0 {
                                for i in 0 ..< result.packets!.count {
                                    packets_data.append([String(result.packets![i].packet_tax), String(result.packets![i].packet_sum), String(result.packets![i].packet_amount), String(result.packets![i].packet_name)])
                                }
                            }
                        }
                        
                        else if result.packets == nil {
                            print("empty history")
                            DispatchQueue.main.async {
                            emptyView = EmptyView(frame: CGRect(x: 0, y: 30, width: self.table.frame.width, height: self.table.frame.height), text: self.message)
                            self.table.separatorStyle = .none
                            self.table.backgroundView = emptyView
                            }
                        }
                    }
                },
                onError: { error in
                   print(error.localizedDescription)
                },
                onCompleted: {
                    DispatchQueue.main.async { [self] in
                        sendHistoryRequest()
                    }
                   print("Completed event.")
                    
                }).disposed(by: disposeBag)
              }
              catch{
            }
    }
    
    func sendHistoryRequest() {
        HistoryData.removeAll()
        
        let client = APIClient.shared
            do{
              try client.getCreditHistoryRequest().subscribe(
                onNext: { result in
                  print(result)
                    DispatchQueue.main.async { [self] in
                        
                        if result.history?.count != 0 {
                            
                            print(result.history!.count)
                            for i in 0 ..< result.history!.count {
                                
                                var tableData1 = [String]()
                                var tableData2 = [String]()
                                var tableData3 = [String]()
                                var tableData4 = [String]()
                                var tableData5 = [String]()
                                var tableData6 = [String]()
                                var tableData7 = [String]()
                                var tableData8 = [String]()
                                var tableData9 = [String]()
                                var tableData10 = [String]()
                               
                                for j in 0 ..< result.history![i].histories.count {
                                    
                                    tableData1.append(String(result.history![i].histories[j].packet_tax))
                                    tableData2.append(String(result.history![i].histories[j].packet_sum))
                                    tableData3.append(String(result.history![i].histories[j].packet_amount))
                                    tableData4.append(String(result.history![i].histories[j].credit_id))
                                    tableData5.append(String(result.history![i].histories[j].remaind_sum_amount))
                                    tableData6.append(String(result.history![i].histories[j].remaind_tax_amount))
                                    tableData7.append(String(result.history![i].histories[j].remaind_credit_amount))
                                    tableData8.append(String(result.history![i].histories[j].is_repayment))
                                    tableData9.append(String(result.history![i].histories[j].packet_name))
                                    tableData10.append(String(result.history![i].histories[j].created_at))
                                    
                                }
                                
                                HistoryData.append(zeroHelpData(date_header: String(result.history![i].date), packet_tax: tableData1, packet_sum: tableData2, packet_amount: tableData3, credit_id: tableData4, remaind_sum_amount: tableData5, remaind_tax_amount: tableData6, remaind_credit_amount: tableData7, is_repayment: tableData8, packet_name: tableData9, created_at: tableData10))
                            }
                            
                        }
                        else {
                            print("empty history")
                            DispatchQueue.main.async {
                            emptyView = EmptyView(frame: CGRect(x: 0, y: 30, width: self.table2.frame.width, height: self.table2.frame.height), text: """
                                Вы еще не воспользовались услугой "Обмен трафика"
                                """)
                            self.table2.separatorStyle = .none
                            self.table2.backgroundView = emptyView
                            }
                        }
                        
                    }
                },
                onError: { error in
                   print(error.localizedDescription)
                },
                onCompleted: {
                    DispatchQueue.main.async { [self] in
                        print(HistoryData.count)
                        setupView()
                        setupTabCollectionView()
                        hideActivityIndicator(uiView: self.view)
                    }
                   print("Completed event.")
                    
                }).disposed(by: disposeBag)
              }
              catch{
            }
    }
    
    @objc func openCondition() {
        detailViewController.more_view.content.text = descrip
        detailViewController.more_view.title_top.text = defaultLocalizer.stringForKey(key: "Help_at_zero")
        detailViewController.more_view.image.image = UIImage(named: "mobile.png")
        detailViewController.more_view.close_banner.addTarget(self, action: #selector(dismiss_view), for: .touchUpInside)
        detailViewController.more_view.close.addTarget(self, action: #selector(dismiss_view), for: .touchUpInside)
    
        nav = UINavigationController(rootViewController: detailViewController)
        nav.modalPresentationStyle = .pageSheet
        nav.view.backgroundColor = contentColor
        nav.isNavigationBarHidden = true
        detailViewController.view.backgroundColor = colorGrayWhite
        if #available(iOS 15.0, *) {
            if let sheet = nav.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.selectedDetentIdentifier = .medium
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false

            }
        } else {
            // Fallback on earlier versions
        }
            // 4
        present(nav, animated: true, completion: nil)
    }
    
    @objc func dismiss_view() {
        print("jlllllll")
        nav.dismiss(animated: true, completion: nil)
    }
}

extension ZeroHelpViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tabs", for: indexPath) as! TabZeroCollectionViewCell
        if indexPath.row == 0 {
            table.register(ZeroTableViewCell.self, forCellReuseIdentifier: "zero_cell")
            table.frame = CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width - 20, height: 4 * 90)
            table.delegate = self
            table.dataSource = self
            table.rowHeight = 80
            table.estimatedRowHeight = 80
            table.alwaysBounceVertical = false
            table.showsVerticalScrollIndicator = false
            table.backgroundColor = contentColor
            table.separatorColor = colorLine
            cell.addSubview(table)
           
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openCondition))
            cell.icon_more.isUserInteractionEnabled = true
            cell.icon_more.addGestureRecognizer(tapGestureRecognizer)
            
            if packets_data.count == 0 {
                emptyView = EmptyView(frame: CGRect(x: 0, y: 30, width: table.frame.width, height: table.frame.height), text: message)
                table.separatorStyle = .none
                table.backgroundView = emptyView
                cell.icon_more.isHidden = !cell.icon_more.isHidden
                cell.title_info.isHidden = !cell.title_info.isHidden
            }
            
        }
        else {
            table2.register(ZeroHistoryViewCell.self, forCellReuseIdentifier: "history_transfer")
            table2.register(HistoryHeaderCell.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")
            table2.frame = CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width - 20, height: UIScreen.main.bounds.size.height - 150)
            table2.delegate = self
            table2.dataSource = self
            table2.rowHeight = 90
            table2.estimatedRowHeight = 90
            table2.alwaysBounceVertical = false
            table2.separatorStyle = .none
            table2.showsVerticalScrollIndicator = false
            table2.backgroundColor = contentColor
            cell.addSubview(table2)
            
            if history_data.count == 0 {
                emptyView = EmptyView(frame: CGRect(x: 0, y: 30, width: table2.frame.width, height: table2.frame.height), text: """
                Вы еще не воспользовались услугой "Помощь при нуле"
                """)
                table2.separatorStyle = .none
                table2.backgroundView = emptyView
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
 
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == TabCollectionView {
            if indexPath.row == 0 {
                zeroView.tab1.textColor = colorBlackWhite
                zeroView.tab2.textColor = .gray
                zeroView.tab1Line.backgroundColor = .orange
                zeroView.tab2Line.backgroundColor = .clear
                
            } else {
                zeroView.tab1.textColor = .gray
                zeroView.tab2.textColor = colorBlackWhite
                zeroView.tab1Line.backgroundColor = .clear
                zeroView.tab2Line.backgroundColor = .orange
          }
       }
    }
}

extension ZeroHelpViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == table {
            return 1
        }
        else {
            if HistoryData.count != 0 {
                return HistoryData.count
            }
            else {
                return 0
            }
        }
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == table {
            return packets_data.count
        }
        else {
            return HistoryData[section].packet_tax.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == table {
            return 0
        }
        else {
            if HistoryData.count != 0 {
                return 44
            }
            else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as! HistoryHeaderCell
        print(HistoryData[section].date_header)
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = DateFormatter.Style.long
        dateFormatter1.dateFormat = "yyyy-MM-dd "
        let date = dateFormatter1.date(from: HistoryData[section].date_header)
        dateFormatter1.dateFormat = "dd MMMM"
        dateFormatter1.locale = Locale(identifier: "ru_RU")
        
        view.title.text = HistoryData[section].date_header
        
       return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == table {
            let cell = tableView.dequeueReusableCell(withIdentifier: "zero_cell", for: indexPath) as! ZeroTableViewCell
            
            cell.separatorInset = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
            
            if indexPath.row == 3 {
                cell.separatorInset = UIEdgeInsets.init(top: -10, left: UIScreen.main.bounds.size.width, bottom: -10, right: 0)
                cell.titleOne.text = packets_data[indexPath.row][0]
                cell.titleTwo.text = packets_data[indexPath.row][1]
            
            }
            //cell.button.setImage(#imageLiteral(resourceName: "choosed_help"), for: UIControl.State.normal)
            cell.button.setImage(#imageLiteral(resourceName: "un_choosed_help"), for: UIControl.State.normal)
            cell.button.isUserInteractionEnabled = false
            
            let bgColorView = UIView()
            bgColorView.backgroundColor = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.00) : UIColor(red: 1.00, green: 0.98, blue: 0.94, alpha: 1.00))
            bgColorView.layer.borderColor = UIColor.orange.cgColor
            bgColorView.layer.borderWidth = 1
            bgColorView.layer.cornerRadius = 10
            cell.selectedBackgroundView = bgColorView

            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "history_transfer", for: indexPath) as! ZeroHistoryViewCell
            cell.titleOne.text = HistoryData[indexPath.section].packet_name[indexPath.row]
            cell.titleTwo.text = "" + HistoryData[indexPath.section].is_repayment[indexPath.row]
            cell.titleThree.text = HistoryData[indexPath.section].packet_sum[indexPath.row]
            
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
            let date = dateFormatter1.date(from: String(HistoryData[indexPath.section].created_at[indexPath.row]))
            dateFormatter1.dateFormat = "HH:mm"
            
            cell.titleFour.text = dateFormatter1.string(from: date!)
            
            cell.titleThree.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (cell.titleThree.text!.count * 15) - 30, y: 10, width: (cell.titleThree.text!.count * 15), height: 30)
            
            cell.titleFour.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (cell.titleFour.text!.count * 15) - 30, y: 40, width: (cell.titleFour.text!.count * 15), height: 30)
            return cell
        }
        
       
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        // Find any selected row in this section
        if let selectedIndexPath = table.indexPathsForSelectedRows?.first(where: {
            $0.section == indexPath.section
        }) {
            // Deselect the row
            table.deselectRow(at: selectedIndexPath, animated: false)
            // deselectRow doesn't fire the delegate method so need to
            // unset the checkmark here
            let cell = table.cellForRow(at: selectedIndexPath) as! ZeroTableViewCell
            
            cell.button.setImage(#imageLiteral(resourceName: "un_choosed_help"), for: UIControl.State.normal)
        }
        return indexPath
    }

    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        // Prevent deselection of a cell
        return nil
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = table.cellForRow(at: indexPath) as! ZeroTableViewCell
        
        cell.button.setImage(#imageLiteral(resourceName: "choosed_help"), for: UIControl.State.normal)
        
        let next = ZeroButtonViewController()
        next.view.frame = (view.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)))
        self.halfModalTransitioningDelegate = HalfModalTransitioningTwoDelegate(viewController: self, presentingViewController: next)
        next.modalPresentationStyle = .custom
        //next.modalPresentationCapturesStatusBarAppearance = true
        
        next.transitioningDelegate = self.halfModalTransitioningDelegate
        present(next, animated: true, completion: nil)
    }
    
}
