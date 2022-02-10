//
//  DetalizationViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/30/21.
//

import UIKit
import FSCalendar

class DetalizationViewController: UIViewController , UIScrollViewDelegate, FSCalendarDataSource, FSCalendarDelegate {
    
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    let scrollView = UIScrollView()
    
    var toolbar = TarifToolbarView()
    var detalizationView = DetalizationView()
    let table = UITableView()
    
    var x_pozition = 20
    var y_pozition = 100
    
    var choosedPeriod = 0
    
    var halfModalTransitioningDelegate: HalfModalTransitioningDelegate?
    
    let TabPeriodCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(TabPeriodCollectionViewCell.self, forCellWithReuseIdentifier: "tabs_period")
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        return cv
    }()
    
    let TabCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(TapDetalizationCollectionCell.self, forCellWithReuseIdentifier: "tabs")
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
        detalizationView = DetalizationView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 896))
        
        self.view.addSubview(toolbar)
        scrollView.addSubview(detalizationView)
        
        toolbar.icon_back.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        toolbar.number_user_name.text = "Детализация"
        
        scrollView.frame = CGRect(x: 0, y: 104, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 104)
        
    }

    func setupTabCollectionView() {
        y_pozition = y_pozition + 55
        
        detalizationView.tab1.frame = CGRect(x: 0, y: y_pozition, width: Int(UIScreen.main.bounds.size.width) / 2, height: 40)
        detalizationView.tab2.frame = CGRect(x: UIScreen.main.bounds.size.width / 2, y: CGFloat(y_pozition), width: UIScreen.main.bounds.size.width / 2, height: 40)
        
        detalizationView.tab1Line.frame = CGRect(x: 10, y: y_pozition + 40, width: (Int(UIScreen.main.bounds.size.width) / 2) - 20, height: 3)
        detalizationView.tab2Line.frame = CGRect(x: (UIScreen.main.bounds.size.width / 2) + 10, y: CGFloat(y_pozition + 40), width: (UIScreen.main.bounds.size.width / 2) - 20, height: 3)
        
        scrollView.addSubview(TabCollectionView)
        TabCollectionView.backgroundColor = .white
        TabCollectionView.frame = CGRect(x: 0, y: y_pozition + 45, width: Int(UIScreen.main.bounds.size.width), height: Int(UIScreen.main.bounds.size.height - 150))
        TabCollectionView.delegate = self
        TabCollectionView.dataSource = self
        TabCollectionView.alwaysBounceVertical = false
        
        scrollView.addSubview(TabPeriodCollectionView)
        TabPeriodCollectionView.backgroundColor = .clear
        TabPeriodCollectionView.frame = CGRect(x: 0, y: 80, width: Int(UIScreen.main.bounds.size.width), height: 50)
        TabPeriodCollectionView.delegate = self
        TabPeriodCollectionView.dataSource = self
        TabPeriodCollectionView.alwaysBounceVertical = false
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.scrollView == scrollView {
            if scrollView.contentOffset.y > detalizationView.tab1.frame.origin.y {
                detalizationView.email_text.isHidden = true
                TabPeriodCollectionView.isHidden = true
                detalizationView.white_view_back.isHidden = true
                self.scrollView.contentOffset.y = 0
                detalizationView.tab1.frame.origin.y = 0
                detalizationView.tab2.frame.origin.y = 0
                detalizationView.tab1Line.frame.origin.y = 40
                detalizationView.tab2Line.frame.origin.y = 40
                TabCollectionView.frame.origin.y = 45
            }
            if scrollView.contentOffset.y < -10 && detalizationView.white_view_back.isHidden == true {
                detalizationView.email_text.isHidden = false
                TabPeriodCollectionView.isHidden = false
                detalizationView.white_view_back.isHidden = false
                self.scrollView.contentOffset.y = 104
                detalizationView.tab1.frame.origin.y = CGFloat(y_pozition)
                detalizationView.tab2.frame.origin.y = CGFloat(y_pozition)
                detalizationView.tab1Line.frame.origin.y = CGFloat(y_pozition + 40)
                detalizationView.tab2Line.frame.origin.y = CGFloat(y_pozition + 40)
                TabCollectionView.frame.origin.y = CGFloat(y_pozition + 45)
               
            }
        }
    }
}

extension DetalizationViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, CellDetalizationDelegate  {
    
    func didCalendarTapped(for cell: TapDetalizationCollectionCell) {
        
       /*  let next = CalendarViewController()
        next.view.frame = (view.frame.inset(by: UIEdgeInsets(top: 434, left: 0, bottom: 0, right: 0)))
        self.halfModalTransitioningDelegate = HalfModalTransitioningDelegate(viewController: self, presentingViewController: next)
        next.modalPresentationStyle = .custom
        next.modalPresentationCapturesStatusBarAppearance = true
        
        next.transitioningDelegate = self.halfModalTransitioningDelegate
        present(next, animated: true, completion: nil)*/
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(CalendarViewController(), animated: true)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if collectionView == TabPeriodCollectionView {
            if indexPath.row == 0 {
                return CGSize(width: 150, height: collectionView.frame.height)
            }
            else {
                return CGSize(width: 100, height: collectionView.frame.height)
            }
            
        }
        else {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == TabPeriodCollectionView {
            return 4
        }
        else {
            return 2
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == TabPeriodCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tabs_period", for: indexPath) as! TabPeriodCollectionViewCell
            
           
            
            if indexPath.row == 0 {
                cell.myPeriod.text = "Свой период"
                cell.myPeriod.frame = CGRect(x: 10, y: 10, width: 150, height: 30)

            }
            else if indexPath.row == 1 {
                cell.myPeriod.text = "Сутки"
                cell.myPeriod.frame = CGRect(x: 0, y: 10, width: 100, height: 30)
               
            }
            else if indexPath.row == 2 {
                cell.myPeriod.text = "Неделя"
                cell.myPeriod.frame = CGRect(x: 0, y: 10, width: 100, height: 30)
        
            }
            else if indexPath.row == 3 {
                cell.myPeriod.text = "Месяц"
                cell.myPeriod.frame = CGRect(x: 0, y: 10, width: 100, height: 30)
                
            }
            
            if indexPath.row == choosedPeriod {
                cell.myPeriod.backgroundColor = .orange
                cell.myPeriod.textColor = .white
                cell.myPeriod.layer.masksToBounds = true
                cell.myPeriod.layer.cornerRadius = cell.myPeriod.frame.height / 2
            }
            else {
                cell.myPeriod.backgroundColor = .clear
                cell.myPeriod.textColor = .gray
            }
            
            cell.actionDelegate = (self as CellTapPeriodActionDelegate)
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tabs", for: indexPath) as! TapDetalizationCollectionCell
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
                cell.addSubview(table)
                
            }
            cell.actionDelegate = (self as CellDetalizationDelegate)
            return cell
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
 
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == TabCollectionView {
            if indexPath.row == 0 {
                detalizationView.tab1.textColor = .black
                detalizationView.tab2.textColor = .gray
                detalizationView.tab1Line.backgroundColor = .orange
                detalizationView.tab2Line.backgroundColor = .clear
                
            } else {
                detalizationView.tab1.textColor = .gray
                detalizationView.tab2.textColor = .black
                detalizationView.tab1Line.backgroundColor = .clear
                detalizationView.tab2Line.backgroundColor = .orange
          }
       }
        else {
            print(indexPath.row)
        }
    }
}

extension DetalizationViewController: CellTapPeriodActionDelegate {
    func didTapped(for cell: TabPeriodCollectionViewCell) {
        print("hi")
        if let indexPath = TabPeriodCollectionView.indexPath(for: cell) {
            choosedPeriod = indexPath.row
            TabPeriodCollectionView.reloadData()
            
        }
    }
    
    
}

extension DetalizationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "history_transfer", for: indexPath) as! MobileHistoryViewCell
     
        return cell
       
    }
    
    
}
