//
//  TraficTransferViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/22/21.
//

import UIKit

class TraficTransferViewController: UIViewController, UIScrollViewDelegate {

    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
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
        traficView = TraficTransferView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 896))
        
        self.view.addSubview(toolbar)
        scrollView.addSubview(traficView)
        
        toolbar.icon_back.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        toolbar.number_user_name.text = "Трафик трансфер"
        
        scrollView.frame = CGRect(x: 0, y: 104, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 104)
    }

    func setupTabCollectionView() {
        y_pozition = y_pozition + 55
        
        traficView.tab1.frame = CGRect(x: 0, y: y_pozition, width: Int(UIScreen.main.bounds.size.width) / 2, height: 40)
        traficView.tab2.frame = CGRect(x: UIScreen.main.bounds.size.width / 2, y: CGFloat(y_pozition), width: UIScreen.main.bounds.size.width / 2, height: 40)
        
        traficView.tab1Line.frame = CGRect(x: 10, y: y_pozition + 40, width: (Int(UIScreen.main.bounds.size.width) / 2) - 20, height: 3)
        traficView.tab2Line.frame = CGRect(x: (UIScreen.main.bounds.size.width / 2) + 10, y: CGFloat(y_pozition + 40), width: (UIScreen.main.bounds.size.width / 2) - 20, height: 3)
        
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
}

extension TraficTransferViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "history_transfer", for: indexPath) as! TraficHistoryViewCell
     
        return cell
       
    }
    
    
}
