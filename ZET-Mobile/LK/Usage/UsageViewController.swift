//
//  UsageViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/2/21.
//

import UIKit

class UsageViewController: UIViewController, UIScrollViewDelegate {

    let scrollView = UIScrollView()
    var toolbar = ToolbarUsage()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 805)
        view.addSubview(scrollView)
        
        setupView()
        setupUsages()
        setupHistoryUsagesTableView()
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
        
        self.UsageCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
    }

    func setupView() {
        view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
        
        toolbar = ToolbarUsage(frame: CGRect(x: 0, y: 44, width: UIScreen.main.bounds.size.width, height: 60))
        usage_view = UsageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        
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
        
        UsageCollectionView.backgroundColor = .white
        UsageCollectionView.layer.cornerRadius = 10
        UsageCollectionView.frame = CGRect(x: 20, y: 70, width: UIScreen.main.bounds.size.width - 40, height: 300)
        UsageCollectionView.delegate = self
        UsageCollectionView.dataSource = self
        scrollView.addSubview(UsageCollectionView)
    }
    
    func setupHistoryUsagesTableView() {
        scrollView.addSubview(table)
        table.frame = CGRect(x: 20, y: 480, width: UIScreen.main.bounds.size.width - 20, height: 10 * 100)
        table.register(HistoryUsageViewCell.self, forCellReuseIdentifier: "history_usage")
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 100
        table.estimatedRowHeight = 100
        table.alwaysBounceVertical = false
        table.separatorStyle = .none
        table.isScrollEnabled = false
        table.showsVerticalScrollIndicator = false
      }
    
    @objc func openDetalazition() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(DetalizationViewController(), animated: true)
    }
    
    @objc func tab1Click() {
        usage_view.tab1.textColor = .black
        usage_view.tab2.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        usage_view.tab3.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        usage_view.tab1Line.backgroundColor = .orange
        usage_view.tab2Line.backgroundColor = .clear
        usage_view.tab3Line.backgroundColor = .clear
        UsageCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
    }
    
    @objc func tab2Click() {
        usage_view.tab1.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        usage_view.tab2.textColor = .black
        usage_view.tab3.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        usage_view.tab1Line.backgroundColor = .clear
        usage_view.tab2Line.backgroundColor = .orange
        usage_view.tab3Line.backgroundColor = .clear
        UsageCollectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
    }
    
    @objc func tab3Click() {
        usage_view.tab1.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        usage_view.tab2.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        usage_view.tab3.textColor = .black
        usage_view.tab1Line.backgroundColor = .clear
        usage_view.tab2Line.backgroundColor = .clear
        usage_view.tab3Line.backgroundColor = .orange
        UsageCollectionView.scrollToItem(at: IndexPath(item: 2, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
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
        //cell.actionDelegate = (self as CellBalanceActionDelegate)
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
            usage_view.tab1.textColor = .black
            usage_view.tab2.textColor = .gray
            usage_view.tab3.textColor = .gray
            usage_view.tab1Line.backgroundColor = .orange
            usage_view.tab2Line.backgroundColor = .clear
            usage_view.tab3Line.backgroundColor = .clear
        } else if indexPath.row == 2 {
            usage_view.tab1.textColor = .gray
            usage_view.tab2.textColor = .gray
            usage_view.tab3.textColor = .black
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
            usage_view.tab2.textColor = .black
            usage_view.tab3.textColor = .gray
            usage_view.tab1Line.backgroundColor = .clear
            usage_view.tab2Line.backgroundColor = .orange
            usage_view.tab3Line.backgroundColor = .clear
        }
        else if indexPath.row == 2 {
            usage_view.tab1.textColor = .gray
            usage_view.tab2.textColor = .black
            usage_view.tab3.textColor = .gray
            usage_view.tab1Line.backgroundColor = .clear
            usage_view.tab2Line.backgroundColor = .orange
            usage_view.tab3Line.backgroundColor = .clear
        }
    }
}

extension UsageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "history_usage", for: indexPath) as! HistoryUsageViewCell
        
        //cell.textLabel?.text = characters[indexPath.row]
        return cell
    }
    
    
}
