//
//  MobileTransferViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/29/21.
//

import UIKit
import RxSwift
import RxCocoa

class MobileTransferViewController: UIViewController, UIScrollViewDelegate {
    
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    let disposeBag = DisposeBag()
    
    let scrollView = UIScrollView()
    
    var toolbar = TarifToolbarView()
    var mobileView = MobileTransferView()
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
        cv.register(TabMobileCollectionViewCell.self, forCellWithReuseIdentifier: "tabs")
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        return cv
    }()
    
    var balances_data = [[String]]()
    var settings_data = [[String]]()
    var history_data = [[String]]()
    
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
        mobileView = MobileTransferView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 896))
        
        self.view.addSubview(toolbar)
        scrollView.addSubview(mobileView)
        
        toolbar.icon_back.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        toolbar.number_user_name.text = "Мобильный перевод"
        
        mobileView.rez1.text = balances_data[0][0]
        mobileView.rez2.text = balances_data[0][1]
        mobileView.rez3.text = balances_data[0][2]
        mobileView.rez4.text = balances_data[0][3]
        
        mobileView.rez1.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (mobileView.rez1.text!.count * 10) - 50, y: 0, width: (mobileView.rez1.text!.count * 10), height: 45)
        mobileView.rez2.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (mobileView.rez2.text!.count * 10) - 50, y: 47, width: (mobileView.rez2.text!.count * 10), height: 45)
        mobileView.rez3.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (mobileView.rez3.text!.count * 10) - 50, y: 94, width: (mobileView.rez3.text!.count * 10), height: 45)
        mobileView.rez4.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (mobileView.rez4.text!.count * 10) - 50, y: 141, width: (mobileView.rez4.text!.count * 10), height: 45)
        
        scrollView.frame = CGRect(x: 0, y: 104, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 104)
    }

    func setupTabCollectionView() {
        y_pozition = y_pozition + 55
        
        mobileView.tab1.frame = CGRect(x: 0, y: y_pozition, width: Int(UIScreen.main.bounds.size.width) / 2, height: 40)
        mobileView.tab2.frame = CGRect(x: UIScreen.main.bounds.size.width / 2, y: CGFloat(y_pozition), width: UIScreen.main.bounds.size.width / 2, height: 40)
        
        mobileView.tab1Line.frame = CGRect(x: 10, y: y_pozition + 40, width: (Int(UIScreen.main.bounds.size.width) / 2) - 20, height: 3)
        mobileView.tab2Line.frame = CGRect(x: (UIScreen.main.bounds.size.width / 2) + 10, y: CGFloat(y_pozition + 40), width: (UIScreen.main.bounds.size.width / 2) - 20, height: 3)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tab1Click))
        mobileView.tab1.isUserInteractionEnabled = true
        mobileView.tab1.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(tab2Click))
        mobileView.tab2.isUserInteractionEnabled = true
        mobileView.tab2.addGestureRecognizer(tapGestureRecognizer2)
        
        scrollView.addSubview(TabCollectionView)
        TabCollectionView.backgroundColor = .white
        TabCollectionView.frame = CGRect(x: 0, y: y_pozition + 45, width: Int(UIScreen.main.bounds.size.width), height: Int(UIScreen.main.bounds.size.height - 150))
        TabCollectionView.delegate = self
        TabCollectionView.dataSource = self
        TabCollectionView.alwaysBounceVertical = false
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.scrollView == scrollView {
            if scrollView.contentOffset.y > mobileView.tab1.frame.origin.y {
                mobileView.titleOne.isHidden = true
                mobileView.balance.isHidden = true
                mobileView.image_banner.isHidden = true
                mobileView.white_view_back.isHidden = true
                self.scrollView.contentOffset.y = 0
                mobileView.tab1.frame.origin.y = 0
                mobileView.tab2.frame.origin.y = 0
                mobileView.tab1Line.frame.origin.y = 40
                mobileView.tab2Line.frame.origin.y = 40
                TabCollectionView.frame.origin.y = 45
            }
            if scrollView.contentOffset.y < -10 && mobileView.white_view_back.isHidden == true {
                mobileView.titleOne.isHidden = false
                mobileView.balance.isHidden = false
                mobileView.image_banner.isHidden = false
                mobileView.white_view_back.isHidden = false
                self.scrollView.contentOffset.y = 104
                mobileView.tab1.frame.origin.y = CGFloat(y_pozition)
                mobileView.tab2.frame.origin.y = CGFloat(y_pozition)
                mobileView.tab1Line.frame.origin.y = CGFloat(y_pozition + 40)
                mobileView.tab2Line.frame.origin.y = CGFloat(y_pozition + 40)
                TabCollectionView.frame.origin.y = CGFloat(y_pozition + 45)
               
            }
        }
    }
    
    @objc func tab1Click() {
        mobileView.tab1.textColor = .black
        mobileView.tab2.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        mobileView.tab1Line.backgroundColor = .orange
        mobileView.tab2Line.backgroundColor = .clear
        TabCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionView.ScrollPosition.right, animated: true)
    }
    
    @objc func tab2Click() {
        mobileView.tab1.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        mobileView.tab2.textColor = .black
        mobileView.tab1Line.backgroundColor = .clear
        mobileView.tab2Line.backgroundColor = .orange
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
                        
                        self.mobileView.balance.text = String(result.subscriberBalance) + " сомони"
                        
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

extension MobileTransferViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tabs", for: indexPath) as! TabMobileCollectionViewCell
        if indexPath.row == 0 {
            
             
           
        }
        else {
            table.register(MobileHistoryViewCell.self, forCellReuseIdentifier: "history_transfer")
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
                mobileView.tab1.textColor = .black
                mobileView.tab2.textColor = .gray
                mobileView.tab1Line.backgroundColor = .orange
                mobileView.tab2Line.backgroundColor = .clear
                
            } else {
                mobileView.tab1.textColor = .gray
                mobileView.tab2.textColor = .black
                mobileView.tab1Line.backgroundColor = .clear
                mobileView.tab2Line.backgroundColor = .orange
          }
       }
    }
}

extension MobileTransferViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "history_transfer", for: indexPath) as! MobileHistoryViewCell
     
        return cell
       
    }
    
    
}
