//
//  TraficTransferViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/22/21.
//

import UIKit
import RxCocoa
import RxSwift
import MultiSlider

struct historyData {
    let date_header: String
    let phoneNumber: [String]
    let status: [String]
    let date: [String]
    let id: [String]
    let volume: [String]
    let price: [String]
    let type: [String]
    let transferType: [String]
    let statusId: [String]
    let transactionId: [String]
}

class TraficTransferViewController: UIViewController, UIScrollViewDelegate {

    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    let disposeBag = DisposeBag()
    
    let scrollView = UIScrollView()
    
    var toolbar = TarifToolbarView()
    var traficView = TraficTransferView()
    let table = UITableView()
    
    var x_pozition = 20
    var y_pozition = 390
    
    let TabCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(TabTraficCollectionViewCell.self, forCellWithReuseIdentifier: "tabs")
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        return cv
    }()
    
    
    var balances_data = [[String]]()
    var settings_data = [[String]]()
    var history_data = [[String]]()
    var histories_data = [[String]]()
    
    var balance = ""
    var trasfer_type_choosed = ""
    var trasfer_type_choosed_id = 0
    
    var HistoryData = [historyData(date_header: String(), phoneNumber: [String](), status: [String](), date: [String](), id: [String](), volume: [String](), price: [String](), type: [String](), transferType: [String](), statusId: [String](), transactionId: [String]())]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
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
        view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
  
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
        traficView = TraficTransferView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 896))
        
        self.view.addSubview(toolbar)
        scrollView.addSubview(traficView)
        
        toolbar.icon_back.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        toolbar.number_user_name.text = "Трафик трансфер"
        
        self.traficView.balance.text = balance
        
        traficView.rez1.text = balances_data[0][0]
        traficView.rez2.text = balances_data[0][1]
        traficView.rez3.text = balances_data[0][2]
        traficView.rez4.text = balances_data[0][3]
        
        traficView.rez1.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (traficView.rez1.text!.count * 15) - 50, y: 0, width: (traficView.rez1.text!.count * 15), height: 45)
        traficView.rez2.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (traficView.rez2.text!.count * 15) - 50, y: 47, width: (traficView.rez2.text!.count * 15), height: 45)
        traficView.rez3.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (traficView.rez3.text!.count * 15) - 50, y: 94, width: (traficView.rez3.text!.count * 15), height: 45)
        traficView.rez4.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (traficView.rez4.text!.count * 15) - 50, y: 141, width: (traficView.rez4.text!.count * 15), height: 45)
        
        scrollView.frame = CGRect(x: 0, y: 104, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 104)
    }

    func setupTabCollectionView() {
        y_pozition = y_pozition + 55
        
        traficView.tab1.frame = CGRect(x: 0, y: y_pozition, width: Int(UIScreen.main.bounds.size.width) / 2, height: 40)
        traficView.tab2.frame = CGRect(x: UIScreen.main.bounds.size.width / 2, y: CGFloat(y_pozition), width: UIScreen.main.bounds.size.width / 2, height: 40)
        
        traficView.tab1Line.frame = CGRect(x: 10, y: y_pozition + 40, width: (Int(UIScreen.main.bounds.size.width) / 2) - 20, height: 3)
        traficView.tab2Line.frame = CGRect(x: (UIScreen.main.bounds.size.width / 2) + 10, y: CGFloat(y_pozition + 40), width: (UIScreen.main.bounds.size.width / 2) - 20, height: 3)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tab1Click))
        traficView.tab1.isUserInteractionEnabled = true
        traficView.tab1.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(tab2Click))
        traficView.tab2.isUserInteractionEnabled = true
        traficView.tab2.addGestureRecognizer(tapGestureRecognizer2)
        
        scrollView.addSubview(TabCollectionView)
        TabCollectionView.backgroundColor = .white
        TabCollectionView.frame = CGRect(x: 0, y: y_pozition + 45, width: Int(UIScreen.main.bounds.size.width), height: Int(UIScreen.main.bounds.size.height - 150))
        TabCollectionView.delegate = self
        TabCollectionView.dataSource = self
        TabCollectionView.alwaysBounceVertical = false
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.scrollView == scrollView {
            if scrollView.contentOffset.y > traficView.tab1.frame.origin.y {
                traficView.titleOne.isHidden = true
                traficView.balance.isHidden = true
                traficView.image_banner.isHidden = true
                traficView.white_view_back.isHidden = true
                self.scrollView.contentOffset.y = 0
                traficView.tab1.frame.origin.y = 0
                traficView.tab2.frame.origin.y = 0
                traficView.tab1Line.frame.origin.y = 40
                traficView.tab2Line.frame.origin.y = 40
                TabCollectionView.frame.origin.y = 45
            }
            if scrollView.contentOffset.y < -10 && traficView.white_view_back.isHidden == true {
                traficView.titleOne.isHidden = false
                traficView.balance.isHidden = false
                traficView.image_banner.isHidden = false
                traficView.white_view_back.isHidden = false
                self.scrollView.contentOffset.y = 104
                traficView.tab1.frame.origin.y = CGFloat(y_pozition)
                traficView.tab2.frame.origin.y = CGFloat(y_pozition)
                traficView.tab1Line.frame.origin.y = CGFloat(y_pozition + 40)
                traficView.tab2Line.frame.origin.y = CGFloat(y_pozition + 40)
                TabCollectionView.frame.origin.y = CGFloat(y_pozition + 45)
               
            }
        }
    }
    
    @objc func tab1Click() {
        traficView.tab1.textColor = .black
        traficView.tab2.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        traficView.tab1Line.backgroundColor = .orange
        traficView.tab2Line.backgroundColor = .clear
        TabCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionView.ScrollPosition.right, animated: true)
    }
    
    @objc func tab2Click() {
        traficView.tab1.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        traficView.tab2.textColor = .black
        traficView.tab1Line.backgroundColor = .clear
        traficView.tab2Line.backgroundColor = .orange
        TabCollectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: UICollectionView.ScrollPosition.left, animated: true)
    }
    
    func sendRequest() {
        let client = APIClient.shared
            do{
              try client.getTransferRequest().subscribe(
                onNext: { result in
                  print(result)
                    DispatchQueue.main.async {
                        
                        self.balances_data.append([String(result.balances.offnet.now) , String(result.balances.onnet.now), String(result.balances.mb.now), String(result.balances.sms.now)])
                        
                        self.balance = String(result.subscriberBalance) + " сомони"
                        
                        if result.settings.count != 0 {
                            for i in 0 ..< result.settings.count {
                                self.settings_data.append([String(result.settings[i].minValue), String(result.settings[i].maxValue), String(result.settings[i].midValue), String(result.settings[i].midPrice), String(result.settings[i].price), String(result.settings[i].quantityLimit), String(result.settings[i].volumeLimit), String(result.settings[i].conversationRate), String(result.settings[i].discountPercent), String(result.settings[i].transferType), String(result.settings[i].transferTypeId), String(result.settings[i].description)])
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
        let client = APIClient.shared
            do{
              try client.transferHistoryRequest().subscribe(
                onNext: { result in
                  print(result)
                    DispatchQueue.main.async { [self] in
                        
                        if result.history != nil {
                            
                            for i in 0 ..< result.history!.count {
                                
                               var tableData = [[String]]()
                               
                                for j in 0 ..< result.history![i].histories.count {
                                    
                                    tableData.append([String(result.history![i].histories[j].phoneNumber), String(result.history![i].histories[j].status), String(result.history![i].histories[j].date), String(result.history![i].histories[j].id), String(result.history![i].histories[j].volume), String(result.history![i].histories[j].price), String(result.history![i].histories[j].type), String(result.history![i].histories[j].transferType), String(result.history![i].histories[j].statusId), String(result.history![i].histories[j].transactionId)])
                                }
                                
                              //  HistoryData.append(historyData(date_header: String(result.history![i].date), phoneNumber: tableData[i][0], status: tableData[i][1], date: tableData[i][2], id: tableData[i][3], volume: tableData[i][4], price: tableData[i][5], type: tableData[i][6], transferType: tableData[i][7], statusId: tableData[i][8], transactionId: tableData[i][9]))
                            }
                            
                        }
                        
                       /* if result.history.count != 0 {
                            for i in 0 ..< result.settings.count {
                                self.settings_data.append([String(result.settings[i].minValue), String(result.settings[i].maxValue), String(result.settings[i].midValue), String(result.settings[i].midPrice), String(result.settings[i].price), String(result.settings[i].quantityLimit), String(result.settings[i].volumeLimit), String(result.settings[i].conversationRate), String(result.settings[i].discountPercent), String(result.settings[i].transferType), String(result.settings[i].transferTypeId), String(result.settings[i].description)])
                            }
                        }*/
                        
                    }
                },
                onError: { error in
                   print(error.localizedDescription)
                },
                onCompleted: {
                    DispatchQueue.main.async { [self] in
                        setupView()
                        setupTabCollectionView()
                    }
                   print("Completed event.")
                    
                }).disposed(by: disposeBag)
              }
              catch{
            }
    }
}

extension TraficTransferViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tabs", for: indexPath) as! TabTraficCollectionViewCell
        if indexPath.row == 0 {
            // setup language field
            trasfer_type_choosed = settings_data[0][9]
            trasfer_type_choosed_id = Int(settings_data[0][10])!
            cell.slider.value = [CGFloat(Double(settings_data[0][0])!)]
            cell.count_transfer.text = String(Int((cell.slider.value[0])))
            
            cell.type_transfer.text = trasfer_type_choosed
            
            cell.type_transfer.didSelect { [self] (selectedText, index, id) in
                self.trasfer_type_choosed = selectedText
                self.trasfer_type_choosed_id = Int(settings_data[index][10])!
                //putRequest()
                cell.slider.minimumValue = CGFloat(Double(settings_data[index][0])!)
                cell.slider.maximumValue = CGFloat(Double(settings_data[index][1])!)
                cell.slider.value = [CGFloat(Double(settings_data[index][0])!)]
                cell.count_transfer.text = String(Int((cell.slider.value[0])))
            }
            
            for i in 0 ..< settings_data.count {
                cell.type_transfer.optionArray.append(settings_data[i][9])
                cell.type_transfer.optionIds?.append(Int(settings_data[i][10])!)
               // putRequest()
                
            }
            
            cell.slider.addTarget(self, action: #selector(self.sliderChanged), for: .valueChanged)
            
           
        }
        else {
            table.register(TraficHistoryViewCell.self, forCellReuseIdentifier: "history_transfer")
            table.frame = CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width - 20, height: UIScreen.main.bounds.size.height - 150)
            table.delegate = self
            table.dataSource = self
            table.rowHeight = 90
            table.estimatedRowHeight = 90
            table.alwaysBounceVertical = false
            table.separatorStyle = .none
            table.showsVerticalScrollIndicator = false
            table.backgroundColor = .white
            cell.addSubview(table)
            
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
 
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == TabCollectionView {
            if indexPath.row == 0 {
                traficView.tab1.textColor = .black
                traficView.tab2.textColor = .gray
                traficView.tab1Line.backgroundColor = .orange
                traficView.tab2Line.backgroundColor = .clear
                
            } else {
                traficView.tab1.textColor = .gray
                traficView.tab2.textColor = .black
                traficView.tab1Line.backgroundColor = .clear
                traficView.tab2Line.backgroundColor = .orange
          }
       }
    }
    
    @objc func sliderChanged(_ slider: MultiSlider) {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.TabCollectionView.cellForItem(at: indexPath) as! TabTraficCollectionViewCell
        cell.count_transfer.text = String(Int(slider.value[0]))
        
    }
}

extension TraficTransferViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if HistoryData.count != 0 {
            return HistoryData.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as! HistoryHeaderCell
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "dd.MM.yyyy HH:mm:ss"
        let date = dateFormatter1.date(from: history_data[section][2])
        dateFormatter1.dateFormat = "dd MMMM"
        dateFormatter1.locale = Locale(identifier: "ru_RU")
        view.title.text = dateFormatter1.string(from: date!)
        
       return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HistoryData[section].phoneNumber.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "history_transfer", for: indexPath) as! TraficHistoryViewCell
     
        return cell
       
    }
    
    
}
