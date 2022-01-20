//
//  ViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/2/21.
//

import UIKit

let cellID = "BalanceSliderCell"
let cellID2 = "sliderCell"
let cellID3 = "hotServices"
let cellID4 = "uslugiCell"

class HomeViewController: UIViewController, UIScrollViewDelegate {

    private let scrollView = UIScrollView()
    var MyTarifPage = MyTarifViewController()
    
    var toolbar = Toolbar()
    var home_view = HomeView()
    let remainderView = RemainderStackView()
    
    let BalanceSliderView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(BalanceSliderCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        return cv
    }()
    
    let SliderView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(SliderCollectionViewCell.self, forCellWithReuseIdentifier: cellID2)
        cv.showsHorizontalScrollIndicator = false
        
        return cv
    }()
    
    let HotServicesView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(HotServicesCollectionViewCell.self, forCellWithReuseIdentifier: cellID3)
        cv.showsHorizontalScrollIndicator = false
        
        return cv
    }()
    
    let ServicesTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 700)
        view.addSubview(scrollView)
        
        setupView()
        setupBalanceSliderSection()
        setupRemaindersSection()
        setupSliderSection()
        setupHotServicesSection()
        setupServicesTableView()
        
        color2 = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
        color1 = UIColor.white
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
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
    
    @objc func openServices() {
        print("services")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(ServicesViewController(), animated: true)
        
    }
    
    func setupView() {
        view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
  
        toolbar = Toolbar(frame: CGRect(x: 0, y: 44, width: UIScreen.main.bounds.size.width, height: 60))
        home_view = HomeView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height + 700))
        
        home_view.icon_more_services.addTarget(self, action: #selector(openServices), for: .touchUpInside)
        
        self.view.addSubview(toolbar)
        scrollView.addSubview(home_view)
        scrollView.frame = CGRect(x: 0, y: 104, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 110)
    }

    func setupBalanceSliderSection() {
        scrollView.addSubview(BalanceSliderView)
        BalanceSliderView.backgroundColor = .clear
        BalanceSliderView.frame = CGRect(x: 20, y: 0, width: UIScreen.main.bounds.size.width - 40, height: 210)
        BalanceSliderView.backgroundColor = .clear
        BalanceSliderView.delegate = self
        BalanceSliderView.dataSource = self
    }
    
    func setupRemaindersSection(){
        scrollView.addSubview(remainderView)
        remainderView.frame = CGRect(x: 0, y: 230, width: UIScreen.main.bounds.size.width, height: 140)
        remainderView.internetRemainder.serviceTitle = "\(19) \n\("mb")"
        remainderView.messagesRemainder.serviceTitle = "\(10) \n\("sms")"
        remainderView.minutesRemainder.serviceTitle = "\(0) \n\("min")"
        remainderView.internetRemainder.spentProgress = CGFloat(0.1)
        remainderView.messagesRemainder.spentProgress = CGFloat(0.5)
        remainderView.minutesRemainder.spentProgress = CGFloat(0.7)
        
        remainderView.messagesRemainder.plusText.addTarget(self, action: #selector(openAddionalTraficsView), for: .touchUpInside)
        
    }
    
    func setupSliderSection() {
        scrollView.addSubview(SliderView)
        SliderView.backgroundColor = .clear
        SliderView.frame = CGRect(x: 0, y: 550, width: UIScreen.main.bounds.size.width, height: 120)
        SliderView.delegate = self
        SliderView.dataSource = self
    }
    
    func setupHotServicesSection() {
        scrollView.addSubview(HotServicesView)
        HotServicesView.backgroundColor = .clear
        HotServicesView.frame = CGRect(x: 0, y: 400, width: UIScreen.main.bounds.size.width, height: 120)
        HotServicesView.delegate = self
        HotServicesView.dataSource = self
    }
    
    func setupServicesTableView() {
        scrollView.addSubview(ServicesTableView)
        ServicesTableView.frame = CGRect(x: 10, y: 770, width: UIScreen.main.bounds.size.width - 10, height: 3 * 130)
        ServicesTableView.register(ServicesTableViewCell.self, forCellReuseIdentifier: cellID4)
        ServicesTableView.delegate = self
        ServicesTableView.dataSource = self
        ServicesTableView.rowHeight = 130
        ServicesTableView.estimatedRowHeight = 130
        ServicesTableView.isScrollEnabled = false
      }
    
    @objc func openAddionalTraficsView() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(AddionalTraficsViewController(), animated: true)
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
  }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID4, for: indexPath) as! ServicesTableViewCell
        cell.separatorInset = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        if indexPath.row == 2 {
            cell.separatorInset = UIEdgeInsets.init(top: -10, left: UIScreen.main.bounds.size.width, bottom: -10, right: 0)
        }
        //cell.textLabel?.text = characters[indexPath.row]
        return cell
  }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == BalanceSliderView {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
        else if collectionView == SliderView {
            return CGSize(width: collectionView.frame.width * 0.75, height: collectionView.frame.height * 0.75)
        }
        else {
            return CGSize(width: collectionView.frame.width * 0.2, height: collectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == BalanceSliderView {
            return 2
        }
        else if collectionView == SliderView {
            return 2
        }
        else {
            return 5
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == BalanceSliderView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! BalanceSliderCollectionViewCell
            print(indexPath.row)
            cell.actionDelegate = (self as CellBalanceActionDelegate)
            return cell
        }
        else if collectionView == SliderView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID2, for: indexPath) as! SliderCollectionViewCell
            print(indexPath.row)
           
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID3, for: indexPath) as! HotServicesCollectionViewCell
            print(indexPath.row)
           
            return cell
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
 
}

extension HomeViewController: CellBalanceActionDelegate {
    func didSettingTapped(for cell: BalanceSliderCollectionViewCell) {
        print("bbjbjj")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(SearchNumberViewController(), animated: true)
        
        //AlertViewController().modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
             //   AlertViewController().modalTransitionStyle = UIModalTransitionStyle.crossDissolve
             //   present(AlertViewController(), animated: true, completion: nil)
    }
    
    
}
