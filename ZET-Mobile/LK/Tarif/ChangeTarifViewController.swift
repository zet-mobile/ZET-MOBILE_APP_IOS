//
//  ChangeTarifViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/7/21.
//

import UIKit
import RxSwift
import RxCocoa

class ChangeTarifViewController: UIViewController, UIScrollViewDelegate {
    
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    let disposeBag = DisposeBag()
    
    let scrollView = UIScrollView()
    
    var toolbar = TarifToolbarView()
    var tarifView = TarifView()
    
    var icon_count = 0
    var icon_count2 = 0
    
    var x_pozition = 20
    var y_pozition = 100
    
    let table = UITableView()
    
    let TabCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(TabCollectionViewCell.self, forCellWithReuseIdentifier: "tabs")
        cv.showsHorizontalScrollIndicator = false
        
        return cv
    }()
    
    var tarif_name = ""
    var spisanie = ""
    var balances_data = [[String]]()
    var overChargings_data = [[String]]()
    var availables_data = [[String]]()
    var unlim_data = [[String]]()
    
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
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 896)
        view.addSubview(scrollView)
        
        toolbar = TarifToolbarView(frame: CGRect(x: 0, y: 44, width: UIScreen.main.bounds.size.width, height: 60))
        tarifView = TarifView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 896))
        
        toolbar.number_user_name.text = "Тарифный план"
        
        toolbar.icon_back.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        
        tarifView.titleOne.isHidden = true
        tarifView.titleOneRes.isHidden = true
        tarifView.white_view_back.frame.origin.y = 85
        tarifView.welcome.text = tarif_name
        tarifView.user_name.text = spisanie
        
        tarifView.titleOneRes.text = tarif_name
        
        y_pozition = 100
        
        for i in 0 ..< overChargings_data.count {
            let title = UILabel()
            title.text = overChargings_data[i][0]
            title.frame = CGRect(x: 20, y: y_pozition, width: title.text!.count * 10, height: 25)
            title.numberOfLines = 0
            title.textColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00)
            title.font = UIFont.preferredFont(forTextStyle: .subheadline)
            title.font = UIFont.systemFont(ofSize: 15)
            title.lineBreakMode = NSLineBreakMode.byWordWrapping
            title.textAlignment = .left
            
            let title2 = UILabel()
            title2.text = overChargings_data[i][2]
            title2.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (title2.text!.count * 10 + 15), y: y_pozition, width: title2.text!.count * 10, height: 25)
            title2.numberOfLines = 0
            title2.textColor = .black
            title2.font = UIFont.preferredFont(forTextStyle: .subheadline)
            title2.font = UIFont.systemFont(ofSize: 15)
            title2.lineBreakMode = NSLineBreakMode.byWordWrapping
            title2.textAlignment = .right
            
            let title_line = UILabel()
            title_line.frame = CGRect(x: (title.text!.count * 10), y: y_pozition + 12, width: Int(UIScreen.main.bounds.size.width) - (title2.text!.count * 10) - ((title.text!.count * 10)), height: 1)
            title_line.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
            
            scrollView.addSubview(title)
            scrollView.addSubview(title2)
            scrollView.addSubview(title_line)
            y_pozition = y_pozition + 30
        }
        
        if icon_count != 0 {
            y_pozition = y_pozition + 20
        }
        
        for i in 0 ..< icon_count {
            let unlimits = UIImageView()
            unlimits.image = UIImage(named: "VK_black")
            
            if x_pozition > 378 {
                x_pozition = 20
                unlimits.frame = CGRect(x: x_pozition, y: y_pozition, width: 35, height: 35)
                y_pozition = y_pozition + 40
            }
            else {
                unlimits.frame = CGRect(x: x_pozition, y: y_pozition, width: 35, height: 35)
                x_pozition = x_pozition + 45
            }
            scrollView.addSubview(unlimits)
        
        }
        
        if 428 - x_pozition < 250 {
            y_pozition = y_pozition + 45
            x_pozition = 20
        }
        
        let title = UILabel(frame: CGRect(x: x_pozition, y: y_pozition, width: 250, height: 35))
        title.text = "Безлимит на социальные сети"
        title.numberOfLines = 0
        title.textColor = .darkGray
        title.font = UIFont.systemFont(ofSize: 15)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        
        if icon_count != 0  {
            scrollView.addSubview(title)
        }
        
        if icon_count2 != 0  {
            x_pozition = 20
            y_pozition = y_pozition + 55
        }
        
        for i in 0 ..< icon_count2 {
            let unlimits = UIImageView()
            unlimits.image = UIImage(named: "VK_black")
            
            if x_pozition > 378 {
                x_pozition = 20
                unlimits.frame = CGRect(x: x_pozition, y: y_pozition, width: 35, height: 35)
                y_pozition = y_pozition + 45
            }
            else {
                unlimits.frame = CGRect(x: x_pozition, y: y_pozition, width: 35, height: 35)
                x_pozition = x_pozition + 45
            }
            scrollView.addSubview(unlimits)
        
        }
        
        if 428 - x_pozition < 200 {
            y_pozition = y_pozition + 45
            x_pozition = 20
        }
        
        let title2 = UILabel(frame: CGRect(x: x_pozition, y: y_pozition, width: 200, height: 35))
        title2.text = "Ночной безлимит"
        title2.numberOfLines = 0
        title2.textColor = .darkGray
        title2.font = UIFont.systemFont(ofSize: 15)
        title2.lineBreakMode = NSLineBreakMode.byWordWrapping
        title2.textAlignment = .left
        
        if icon_count2 != 0 {
            scrollView.addSubview(title2)
        }
        
        if icon_count != 0 && icon_count2 != 0 {
            y_pozition = y_pozition + 50
        }
        
        let ReconnectBut = UIButton(frame: CGRect(x: 20, y: y_pozition, width: Int(UIScreen.main.bounds.size.width) - 40, height: 45))
        //ReconnectBut.addTarget(self, action: #selector(goToChangeTarif), for: UIControl.Event.touchUpInside)
        ReconnectBut.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
        ReconnectBut.setTitle(defaultLocalizer.stringForKey(key: "reconnect"), for: .normal)
        ReconnectBut.setTitleColor(.white, for: .normal)
        ReconnectBut.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        ReconnectBut.layer.cornerRadius = ReconnectBut.frame.height / 2
        scrollView.addSubview(ReconnectBut)
        
        self.view.addSubview(toolbar)
        scrollView.addSubview(tarifView)
        scrollView.sendSubviewToBack(tarifView)
        scrollView.frame = CGRect(x: 0, y: 104, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 104)
    }

    func setupTabCollectionView() {
        y_pozition = y_pozition + 70
        
        tarifView.tab1.frame = CGRect(x: 0, y: y_pozition, width: Int(UIScreen.main.bounds.size.width) / 2, height: 45)
        tarifView.tab2.frame = CGRect(x: UIScreen.main.bounds.size.width / 2 - 20, y: CGFloat(y_pozition), width: UIScreen.main.bounds.size.width / 2, height: 45)
        
        tarifView.tab1Line.frame = CGRect(x: 20, y: y_pozition + 40, width: Int(UIScreen.main.bounds.size.width) / 2 - 20, height: 3)
        tarifView.tab2Line.frame = CGRect(x: UIScreen.main.bounds.size.width / 2, y: CGFloat(y_pozition + 40), width: UIScreen.main.bounds.size.width / 2 - 20, height: 3)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tab1Click))
        tarifView.tab1.isUserInteractionEnabled = true
        tarifView.tab1.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(tab2Click))
        tarifView.tab2.isUserInteractionEnabled = true
        tarifView.tab2.addGestureRecognizer(tapGestureRecognizer2)
        
        scrollView.addSubview(TabCollectionView)
        TabCollectionView.backgroundColor = .white
        TabCollectionView.frame = CGRect(x: 0, y: y_pozition + 45, width: Int(UIScreen.main.bounds.size.width), height: Int(UIScreen.main.bounds.size.height - 150))
        TabCollectionView.delegate = self
        TabCollectionView.dataSource = self
        TabCollectionView.alwaysBounceVertical = false
        TabCollectionView.showsVerticalScrollIndicator = false
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.scrollView == scrollView {
            if scrollView.contentOffset.y > tarifView.tab1.frame.origin.y {
                tarifView.zetImage.isHidden = true
                tarifView.welcome.isHidden = true
                tarifView.user_name.isHidden = true
                tarifView.backgroundColor = .white
                self.scrollView.contentOffset.y = 0
                tarifView.tab1.frame.origin.y = 0
                tarifView.tab2.frame.origin.y = 0
                tarifView.tab1Line.frame.origin.y = 40
                tarifView.tab2Line.frame.origin.y = 40
                TabCollectionView.frame.origin.y = 45
            }
            if scrollView.contentOffset.y < -10 && tarifView.zetImage.isHidden == true {
                tarifView.zetImage.isHidden = false
                tarifView.welcome.isHidden = false
                tarifView.user_name.isHidden = false
                tarifView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
                self.scrollView.contentOffset.y = 104
                tarifView.tab1.frame.origin.y = CGFloat(y_pozition)
                tarifView.tab2.frame.origin.y = CGFloat(y_pozition)
                tarifView.tab1Line.frame.origin.y = CGFloat(y_pozition + 40)
                tarifView.tab2Line.frame.origin.y = CGFloat(y_pozition + 40)
                TabCollectionView.frame.origin.y = CGFloat(y_pozition + 45)
               
            }
        }
    }
    
    @objc func tab1Click() {
        tarifView.tab1.textColor = .black
        tarifView.tab2.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        tarifView.tab1Line.backgroundColor = .orange
        tarifView.tab2Line.backgroundColor = .clear
        TabCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionView.ScrollPosition.right, animated: true)
    }
    
    @objc func tab2Click() {
        tarifView.tab1.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        tarifView.tab2.textColor = .black
        tarifView.tab1Line.backgroundColor = .clear
        tarifView.tab2Line.backgroundColor = .orange
        TabCollectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: UICollectionView.ScrollPosition.left, animated: true)
    }
    
    func sendRequest() {
        let client = APIClient.shared
            do{
                try client.pricePlanIDGetRequest(parametr: id_tarif_choosed).subscribe(
                onNext: { result in
                  print(result)
                    DispatchQueue.main.async {
                        self.tarif_name = String(result.selected.priceplanName)
                        self.spisanie = String(result.selected.price) + " / " + String(result.selected.period)
                        
                        if result.selected.balances.count != 0 {
                            for i in 0 ..< result.selected.balances.count {
                                self.balances_data.append([String(result.selected.balances[i].unitId), String(result.selected.balances[i].start), String(result.selected.balances[i].unlim)])
                            }
                        }
                        
                        if result.selected.unlimOptions.count != 0 {
                            self.icon_count = result.selected.unlimOptions.count
                            self.icon_count2 = result.selected.unlimOptions.count
                            
                        }
                        
                        if result.selected.overCharging.count != 0 {
                            for i in 0 ..< result.selected.overCharging.count {
                                self.overChargings_data.append([String(result.selected.overCharging[i].description), String(result.selected.overCharging[i].directionPrice), String(result.selected.overCharging[i].priceAndUnit)])
                            }
                        }
                        
                        if result.available.count != 0 {
                            for i in 0 ..< result.available.count {
                                self.availables_data.append([String(result.available[i].id), String(result.available[i].priceplanName), String(result.available[i].price), String(result.available[i].currencyAndPeriod)])
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

extension ChangeTarifViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
     
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tabs", for: indexPath) as! TabCollectionViewCell
        table.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 150)
        table.register(TarifTabViewCell.self, forCellReuseIdentifier: "tarif_tab_cell")
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 100
        table.estimatedRowHeight = 100
        table.alwaysBounceVertical = false
        
        cell.addSubview(table)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == TabCollectionView {
            if indexPath.row == 0 {
                tarifView.tab1.textColor = .black
                tarifView.tab2.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
                tarifView.tab1Line.backgroundColor = .orange
                tarifView.tab2Line.backgroundColor = .clear
            } else {
                tarifView.tab1.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
                tarifView.tab2.textColor = .black
                tarifView.tab1Line.backgroundColor = .clear
                tarifView.tab2Line.backgroundColor = .orange
          }
       }
    }
}

extension ChangeTarifViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if availables_data.count != 0 {
            return availables_data.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tarif_tab_cell", for: indexPath) as! TarifTabViewCell
        cell.separatorInset = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
     
        cell.titleOne.text = availables_data[indexPath.row][1]
        
        let cost: NSString = availables_data[indexPath.row][2] as NSString
        let range = (cost).range(of: cost as String)
        let costString = NSMutableAttributedString.init(string: cost as String)
        costString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange , range: range)
        costString.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], range: range)
        
        let title_cost = " \(availables_data[indexPath.row][3])" as NSString
        let titleString = NSMutableAttributedString.init(string: title_cost as String)
        let range2 = (title_cost).range(of: title_cost as String)
        titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.darkGray , range: range2)
        titleString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], range: range2)
        
        costString.append(titleString)
        
        cell.titleThree.attributedText = costString
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        id_tarif_choosed = availables_data[indexPath.row][0]
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(ChangeTarifViewController(), animated: true)
    }
    
}
