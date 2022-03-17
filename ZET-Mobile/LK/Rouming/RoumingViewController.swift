//
//  RoumingViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 1/9/22.
//

import UIKit
import RxSwift
import RxCocoa

class RoumingViewController: UIViewController, UIScrollViewDelegate {
    
    let disposeBag = DisposeBag()
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    let scrollView = UIScrollView()
    
    var toolbar = TarifToolbarView()
    var rouming_view = RoumingView()
    let table = UITableView()
    
    let TabCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(TabRoumingCollectionCell.self, forCellWithReuseIdentifier: "tabs_rouming")
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
        scrollView.backgroundColor = .white
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 850)
        view.addSubview(scrollView)
        
        sendRequest()
        setupView()
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
        view.backgroundColor = .white
  
        toolbar = TarifToolbarView(frame: CGRect(x: 0, y: 44, width: UIScreen.main.bounds.size.width, height: 60))
        rouming_view = RoumingView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 896))
        
        
        self.view.addSubview(toolbar)
        scrollView.addSubview(rouming_view)
        
        toolbar.icon_back.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        toolbar.number_user_name.text = "Роуминг"
        toolbar.backgroundColor = .white
        
        scrollView.addSubview(TabCollectionView)
        
        rouming_view.tab1.frame = CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.size.width) / 2, height: 40)
        rouming_view.tab2.frame = CGRect(x: UIScreen.main.bounds.size.width / 2, y: CGFloat(0), width: UIScreen.main.bounds.size.width / 2, height: 40)
        
        rouming_view.tab1Line.frame = CGRect(x: 10, y: 45, width: (Int(UIScreen.main.bounds.size.width) / 2) - 20, height: 3)
        rouming_view.tab2Line.frame = CGRect(x: (UIScreen.main.bounds.size.width / 2) + 10, y: CGFloat(45), width: (UIScreen.main.bounds.size.width / 2) - 20, height: 3)
        
        TabCollectionView.backgroundColor = .clear
        TabCollectionView.frame = CGRect(x: 0, y: 55, width: Int(UIScreen.main.bounds.size.width), height: Int(UIScreen.main.bounds.size.height - 150))
        TabCollectionView.delegate = self
        TabCollectionView.dataSource = self
        TabCollectionView.alwaysBounceVertical = false
        
        scrollView.frame = CGRect(x: 0, y: 104, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 104)
        
    }
    
    func sendRequest() {
        let client = APIClient.shared
            do{
              try client.roumingGetRequest().subscribe(
                onNext: { result in
                  print(result)
                    DispatchQueue.main.async {
                    }
                },
                onError: { error in
                   print(error.localizedDescription)
                },
                onCompleted: {
                    DispatchQueue.main.async {
                       
                    }
                   print("Completed event.")
                    
                }).disposed(by: disposeBag)
              }
              catch{
            }
    }

}

extension RoumingViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tabs_rouming", for: indexPath) as! TabRoumingCollectionCell
        if indexPath.row == 0 {
            cell.contentView.isHidden = true
            table.register(RoumingTableCell.self, forCellReuseIdentifier: "roming_list_cell")
            table.frame = CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width - 20, height: 7 * 80)
            table.delegate = self
            table.dataSource = self
            table.rowHeight = 80
            table.estimatedRowHeight = 80
            table.alwaysBounceVertical = false
            table.backgroundColor = .clear
            cell.addSubview(table)
           
        }
        else {
            cell.contentView.isHidden = false
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
 
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == TabCollectionView {
            if indexPath.row == 0 {
                rouming_view.tab1.textColor = .black
                rouming_view.tab2.textColor = .gray
                rouming_view.tab1Line.backgroundColor = .orange
                rouming_view.tab2Line.backgroundColor = .clear
                
            } else {
                rouming_view.tab1.textColor = .gray
                rouming_view.tab2.textColor = .black
                rouming_view.tab1Line.backgroundColor = .clear
                rouming_view.tab2Line.backgroundColor = .orange
          }
       }
    }
}


extension RoumingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "roming_list_cell", for: indexPath) as! RoumingTableCell
            
            cell.separatorInset = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
            
            if indexPath.row == 6 {
                cell.separatorInset = UIEdgeInsets.init(top: -10, left: UIScreen.main.bounds.size.width, bottom: -10, right: 0)
            
            }
                        
            return cell
        
       
    }
    
    
}
