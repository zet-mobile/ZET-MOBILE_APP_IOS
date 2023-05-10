//
//  CompetitionViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 07/12/22.
//

import UIKit
import RxCocoa
import RxSwift

class CompetitionViewController: UIViewController, UIScrollViewDelegate {

    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    let disposeBag = DisposeBag()
    var halfModalTransitioningDelegate: HalfModalTransitioningDelegate?
    let detailViewController = MoreDetailViewController()
    
    var nav = UINavigationController()
    var alert = UIAlertController()
    
    let scrollView = UIScrollView()
    
    var toolbar = TarifToolbarView()
    var competitionView = CompetitionView()
    let table = UITableView()
    
    var prizeImageData = ["image 99", "image 100", "image 102", "image 99"]
    var tableData = ["Мои билеты", "Купить билеты", "Условия розыгрыша"]
    
    let CollectionPrizeView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CollectionPrizeViewCell.self, forCellWithReuseIdentifier: cellID3)
        cv.showsHorizontalScrollIndicator = false
        
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // showActivityIndicator(uiView: self.view)
        view.backgroundColor = toolbarColor
        
        toolbar = TarifToolbarView(frame: CGRect(x: 0, y: topPadding ?? 0, width: UIScreen.main.bounds.size.width, height: 60))
        self.view.addSubview(toolbar)
        
        toolbar.icon_back.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goBack))
        toolbar.isUserInteractionEnabled = true
        toolbar.addGestureRecognizer(tapGestureRecognizer)
        
        toolbar.number_user_name.text = defaultLocalizer.stringForKey(key: "CharhiIqbol")
        
        setupView()
        setupCollectionPrizeSection()
        setupTableView()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationController?.tabBarController?.tabBar.isHidden = false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? .lightContent : .darkContent)
    }
    
    @objc func goBack() {
        if let destinationViewController = navigationController?.viewControllers
                                                                .filter(
                                              {$0 is HomeViewController})
                                                                .first {
            navigationController?.popToViewController(destinationViewController, animated: true)
        }
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
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 950)
        view.addSubview(scrollView)
        
        competitionView = CompetitionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 896))
        
        scrollView.addSubview(competitionView)
        
        scrollView.frame = CGRect(x: 0, y: 60 + (topPadding ?? 0), width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 60 + (topPadding ?? 0) + (bottomPadding ?? 0)))
    }
    
    func setupCollectionPrizeSection() {
        scrollView.addSubview(CollectionPrizeView)
        CollectionPrizeView.frame = CGRect(x: 0, y: 180, width: UIScreen.main.bounds.size.width, height: 120)
        CollectionPrizeView.backgroundColor = .clear
        CollectionPrizeView.delegate = self
        CollectionPrizeView.dataSource = self
    }
    
    func setupTableView() {
        scrollView.addSubview(table)
    
        table.frame = CGRect(x: 0, y: 310, width: Int(UIScreen.main.bounds.size.width), height: 210)
        
        table.register(ListTableViewCell.self, forCellReuseIdentifier: "list_cell")
        table.delegate = self
        table.dataSource = self
        table.isScrollEnabled = false
        table.backgroundColor = .white
        table.separatorColor = .lightGray
        table.rowHeight = 70
        table.estimatedRowHeight = 70
        table.alwaysBounceVertical = false
        table.showsVerticalScrollIndicator = false
        table.allowsSelection = false
      }
}


extension CompetitionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "list_cell", for: indexPath) as! ListTableViewCell
            
            
            let bgColorView = UIView()
            bgColorView.backgroundColor = .clear
            cell.selectedBackgroundView = bgColorView
            
            return cell
        
  }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
}

@available(iOS 15.0, *)
extension CompetitionViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID3, for: indexPath) as! CollectionPrizeViewCell
            cell.image.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ?  UIImage(named: prizeImageData[indexPath.row]) :  UIImage(named: prizeImageData[indexPath.row]))
            
            return cell
        }
}
