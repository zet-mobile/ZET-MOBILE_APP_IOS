//
//  ChangeTarifViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/7/21.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import AlamofireImage

class ChangeTarifViewController: UIViewController, UIScrollViewDelegate {
    
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    let disposeBag = DisposeBag()
    var alert = UIAlertController()
    let scrollView = UIScrollView()
    
    var toolbar = TarifToolbarView()
    var tarifView = TarifView()
    
    var icon_row_count = 0
    var icon_count2 = 0
    
    var x_pozition = 20
    var y_pozition = 200
    
    let table = UITableView()
    
    let TarifBalanceView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(TarifBalanceCollectionViewCell.self, forCellWithReuseIdentifier: cellTarBalV)
        cv.showsHorizontalScrollIndicator = false
        
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
        cv.register(TabCollectionViewCell.self, forCellWithReuseIdentifier: "tabs")
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        return cv
    }()
    
    var discount_id = ""
    var info_data = [[String]]()
    var balances_data = [[String]]()
    var overChargings_data = [[String]]()
    var availables_data = [[String]]()
    var unlim_data = [[String]]()
    var options_element = [[String]]()
    
    var twoDimensionalArray = [
        unlimOptions_data(optionName: "", dpiUnlimElements: [dpiUnlimElements_data(elementName: "", iconUrl: "")])
    ]
    override func viewDidLoad() {
        super.viewDidLoad()

        showActivityIndicator(uiView: self.view)
        view.backgroundColor = toolbarColor
        
        sendRequest()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? .lightContent : .darkContent)
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
        if let destinationViewController = navigationController?.viewControllers
                                                                .filter(
                                              {$0 is MyTarifViewController})
                                                                .first {
            navigationController?.popToViewController(destinationViewController, animated: true)
        }
        
       // navigationController?.popViewController(animated: true)
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
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 896)
        view.addSubview(scrollView)
        
        toolbar = TarifToolbarView(frame: CGRect(x: 0, y: topPadding ?? 0, width: UIScreen.main.bounds.size.width, height: 60))
        tarifView = TarifView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 896))
        tarifView.zetImage.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "Ellipse 27-2_dark2") : UIImage(named: "Ellipse 27-2"))
        
        toolbar.number_user_name.text = defaultLocalizer.stringForKey(key: "Change_tariff")
        
        toolbar.icon_back.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goBack))
        toolbar.isUserInteractionEnabled = true
        toolbar.addGestureRecognizer(tapGestureRecognizer)
        
        tarifView.titleOne.isHidden = true
        tarifView.titleOneRes.isHidden = true
        
        if info_data.count != 0 {
            tarifView.welcome.text = info_data[0][1]
            tarifView.user_name.text = info_data[0][2]
            
            tarifView.titleOneRes.text = info_data[0][1]
        }
        var max_lengh = 0
        
        var font = UIFont.systemFont(ofSize: 15)
        var fontAttributes = [NSAttributedString.Key.font: font]
        var text = ""
        var size = (text as NSString).size(withAttributes: fontAttributes)
        var size2 = (text as NSString).size(withAttributes: fontAttributes)
        
        for i in 0 ..< overChargings_data.count {
            size2 = (overChargings_data[i][2] as NSString).size(withAttributes: fontAttributes)
            if Int(size2.width) > max_lengh {
                max_lengh = Int(size2.width)
            }
        }
        print(max_lengh)
            
        for i in 0 ..< overChargings_data.count {
            
            font = UIFont.systemFont(ofSize: 15)
            fontAttributes = [NSAttributedString.Key.font: font]
            size = (overChargings_data[i][0] as NSString).size(withAttributes: fontAttributes)
           
            let title = UILabel()
            title.text = overChargings_data[i][0]
           // title.frame = CGRect(x: 20, y: y_pozition, width: Int(size.width) + 16, height: 25)
            if size.width < UIScreen.main.bounds.size.width {
                title.frame = CGRect(x: 20, y: y_pozition, width: Int(size.width) + 16, height: 25)
            } else {
                title.frame = CGRect(x: 20, y: y_pozition, width: Int(UIScreen.main.bounds.size.width) - 100, height: 40)
                y_pozition += 10
            }
            title.numberOfLines = 0
            title.textColor = darkGrayLight
            title.font = UIFont.preferredFont(forTextStyle: .subheadline)
            title.font = UIFont.systemFont(ofSize: 15)
            title.lineBreakMode = NSLineBreakMode.byWordWrapping
            title.textAlignment = .left
            
            
            size2 = (overChargings_data[i][2] as NSString).size(withAttributes: fontAttributes)
            
            let title2 = UILabel()
            title2.text = overChargings_data[i][2]
            title2.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (Int(size2.width) + 16 + 15), y: y_pozition, width: Int(size2.width) + 16, height: 25)
            title2.numberOfLines = 0
            title2.textColor = colorBlackWhite
            title2.font = UIFont.preferredFont(forTextStyle: .subheadline)
            title2.font = UIFont.systemFont(ofSize: 15)
            title2.lineBreakMode = NSLineBreakMode.byWordWrapping
            title2.textAlignment = .right
            
            let title_line = UILabel()
            title_line.frame = CGRect(x: (Int(title.frame.width) + 20), y: y_pozition + 12, width: Int(UIScreen.main.bounds.size.width) - (max_lengh + 31) - (Int(title.frame.width) + 20), height: 1)
            title_line.backgroundColor = colorLightDarkGray
            
            scrollView.addSubview(title)
            scrollView.addSubview(title2)
            scrollView.addSubview(title_line)
            y_pozition = y_pozition + 30
        }
        
        if unlim_data.count != 0  {
            let title = UILabel()
            title.text = defaultLocalizer.stringForKey(key: "unlim_on")
            title.frame = CGRect(x: 20, y: y_pozition, width: title.text!.count * 10, height: 25)
            title.numberOfLines = 0
            title.textColor = darkGrayLight
            title.font = UIFont.preferredFont(forTextStyle: .subheadline)
            title.font = UIFont.systemFont(ofSize: 16)
            title.lineBreakMode = NSLineBreakMode.byWordWrapping
            title.textAlignment = .left
            
            scrollView.addSubview(title)
            
            y_pozition = y_pozition + 30
        }
        
        for i in 0 ..< unlim_data.count {
            print(options_element[i].count)
            x_pozition = 20
            y_pozition += 10
            for j in 0 ..< options_element[i].count {
                let unlimits = UIImageView()
                if options_element[i][j] != "" {
                    unlimits.af_setImage(withURL: URL(string: options_element[i][j])!)
                }
                else {
                    unlimits.image = UIImage(named: "VK_black")
                }
                    
                if Int(UIScreen.main.bounds.size.width) - x_pozition < 55 {
                    x_pozition = 20
                    y_pozition = y_pozition + 40
                    unlimits.frame = CGRect(x: x_pozition, y: y_pozition, width: 30, height: 30)
                }
                else {
                    unlimits.frame = CGRect(x: x_pozition, y: y_pozition, width: 30, height: 30)
                    x_pozition = x_pozition + 35
                }
                scrollView.addSubview(unlimits)
            }
            
            if Int(UIScreen.main.bounds.size.width) - x_pozition < unlim_data[i][0].count * 10 {
                y_pozition = y_pozition + 45
                x_pozition = 20
            }
            
            let title = UILabel(frame: CGRect(x: x_pozition, y: y_pozition, width: unlim_data[i][0].count * 10, height: 35))
            title.text = unlim_data[i][0]
            title.numberOfLines = 0
            title.textColor = darkGrayLight
            title.font = UIFont.systemFont(ofSize: 15)
            title.lineBreakMode = NSLineBreakMode.byWordWrapping
            title.textAlignment = .left
            
            scrollView.addSubview(title)
            
            y_pozition += 30
        }
        
        if unlim_data.count != 0 {
            y_pozition += 45
        }
        else {
            y_pozition += 10
        }
  
        let ReconnectBut = UIButton(frame: CGRect(x: 20, y: y_pozition, width: Int(UIScreen.main.bounds.size.width) - 40, height: 45))
        ReconnectBut.addTarget(self, action: #selector(goToChangeTarif), for: UIControl.Event.touchUpInside)
        ReconnectBut.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
        ReconnectBut.setTitle(defaultLocalizer.stringForKey(key: "Connect_tariff"), for: .normal)
        ReconnectBut.setTitleColor(.white, for: .normal)
        ReconnectBut.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        ReconnectBut.layer.cornerRadius = ReconnectBut.frame.height / 2
        scrollView.addSubview(ReconnectBut)
        
        self.view.addSubview(toolbar)
        scrollView.addSubview(tarifView)
        scrollView.sendSubviewToBack(tarifView)
        scrollView.frame = CGRect(x: 0, y: 60 + (topPadding ?? 0), width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 60 + (topPadding ?? 0) + (bottomPadding ?? 0)))
    }
    
    func setupTarifBalanceViewSection() {
        scrollView.addSubview(TarifBalanceView)
        TarifBalanceView.backgroundColor = .clear
        TarifBalanceView.frame = CGRect(x: 10, y: 80, width: UIScreen.main.bounds.size.width - 20, height: 120)
        TarifBalanceView.delegate = self
        TarifBalanceView.dataSource = self
    }
    

    func setupTabCollectionView() {
        y_pozition = y_pozition + 70
        
        tarifView.tab1.frame = CGRect(x: (Int(UIScreen.main.bounds.size.width) / 2) / 2 , y: y_pozition, width: Int(UIScreen.main.bounds.size.width) / 2, height: 45)
        tarifView.tab1Line.frame = CGRect(x: (Int(UIScreen.main.bounds.size.width) / 2) / 2, y: y_pozition + 40, width: Int(UIScreen.main.bounds.size.width) / 2, height: 2)
        
        /*tarifView.tab1.frame = CGRect(x: 0, y: y_pozition, width: Int(UIScreen.main.bounds.size.width) / 2, height: 45)
        tarifView.tab2.frame = CGRect(x: UIScreen.main.bounds.size.width / 2 - 20, y: CGFloat(y_pozition), width: UIScreen.main.bounds.size.width / 2, height: 45)
        
        tarifView.tab1Line.frame = CGRect(x: 20, y: y_pozition + 40, width: Int(UIScreen.main.bounds.size.width) / 2 - 20, height: 2)
        tarifView.tab2Line.frame = CGRect(x: UIScreen.main.bounds.size.width / 2, y: CGFloat(y_pozition + 40), width: UIScreen.main.bounds.size.width / 2 - 20, height: 2)
    */
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tab1Click))
        tarifView.tab1.isUserInteractionEnabled = true
        tarifView.tab1.addGestureRecognizer(tapGestureRecognizer)
        
       /* let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(tab2Click))
        tarifView.tab2.isUserInteractionEnabled = true
        tarifView.tab2.addGestureRecognizer(tapGestureRecognizer2)*/
        
        scrollView.addSubview(TabCollectionView)
        TabCollectionView.backgroundColor = contentColor
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
               // self.scrollView.contentOffset.y = 104
                tarifView.tab1.frame.origin.y = CGFloat(y_pozition)
                tarifView.tab2.frame.origin.y = CGFloat(y_pozition)
                tarifView.tab1Line.frame.origin.y = CGFloat(y_pozition + 40)
                tarifView.tab2Line.frame.origin.y = CGFloat(y_pozition + 40)
                TabCollectionView.frame.origin.y = CGFloat(y_pozition + 45)
               
            }
        }
    
        if table == scrollView {
            if scrollView.contentOffset.y > 10 {
                tarifView.zetImage.isHidden = true
                tarifView.welcome.isHidden = true
                tarifView.user_name.isHidden = true
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
               // self.scrollView.contentOffset.y = 104
                tarifView.tab1.frame.origin.y = CGFloat(y_pozition)
                tarifView.tab2.frame.origin.y = CGFloat(y_pozition)
                tarifView.tab1Line.frame.origin.y = CGFloat(y_pozition + 40)
                tarifView.tab2Line.frame.origin.y = CGFloat(y_pozition + 40)
                TabCollectionView.frame.origin.y = CGFloat(y_pozition + 45)
               
            }
        }

    }
    
    @objc func tab1Click() {
        tarifView.tab1.textColor = colorBlackWhite
        tarifView.tab2.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        tarifView.tab1Line.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
        tarifView.tab2Line.backgroundColor = .clear
        TabCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionView.ScrollPosition.right, animated: true)
    }
    
    @objc func tab2Click() {
        tarifView.tab1.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        tarifView.tab2.textColor = colorBlackWhite
        tarifView.tab1Line.backgroundColor = .clear
        tarifView.tab2Line.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
        TabCollectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: UICollectionView.ScrollPosition.left, animated: true)
    }
    
    @objc func goToChangeTarif(_ sender: UIButton) {
        alert = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n\n", message: "", preferredStyle: .alert)
        let widthConstraints = alert.view.constraints.filter({ return $0.firstAttribute == .width })
        alert.view.removeConstraints(widthConstraints)
        // Here you can enter any width that you want
        let newWidth = UIScreen.main.bounds.width * 0.90
        // Adding constraint for alert base view
        let widthConstraint = NSLayoutConstraint(item: alert.view,
                                                     attribute: .width,
                                                     relatedBy: .equal,
                                                     toItem: nil,
                                                     attribute: .notAnAttribute,
                                                     multiplier: 1,
                                                     constant: newWidth)
        alert.view.addConstraint(widthConstraint)
        
        let view = AlertView()

        view.backgroundColor = contentColor
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 40, height: 350)
        view.layer.cornerRadius = 20
        view.name.text = defaultLocalizer.stringForKey(key: "Connect_tariff")
        view.name_content.text = "\(defaultLocalizer.stringForKey(key: "Connect_tariff2"))\"\(info_data[0][1])\"\(defaultLocalizer.stringForKey(key: "Connect_tariff2_1"))?"
        view.name_content.numberOfLines = 2
        view.ok.setTitle(defaultLocalizer.stringForKey(key: "Connect"), for: .normal)
        view.image_icon.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "Ellipse 27-2_dark2") : UIImage(named: "Ellipse 27-2"))
        view.cancel.addTarget(self, action: #selector(dismissDialogCancel), for: .touchUpInside)
        view.ok.addTarget(self, action: #selector(okClickDialog), for: .touchUpInside)
        
        alert.view.backgroundColor = .clear
        alert.view.addSubview(view)
        //alert.view.sendSubviewToBack(view)
        
        sender.showAnimation { [self] in
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func requestAnswer(status: Bool, message: String) {
        
        alert = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n\n", message: "", preferredStyle: .alert)
        let widthConstraints = alert.view.constraints.filter({ return $0.firstAttribute == .width })
        alert.view.removeConstraints(widthConstraints)
        // Here you can enter any width that you want
        let newWidth = UIScreen.main.bounds.width * 0.90
        // Adding constraint for alert base view
        let widthConstraint = NSLayoutConstraint(item: alert.view,
                                                     attribute: .width,
                                                     relatedBy: .equal,
                                                     toItem: nil,
                                                     attribute: .notAnAttribute,
                                                     multiplier: 1,
                                                     constant: newWidth)
        alert.view.addConstraint(widthConstraint)
        
        let view = AlertView()

        view.backgroundColor = contentColor
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 40, height: 350)
        view.layer.cornerRadius = 20
        if status == true {
            view.name.text = defaultLocalizer.stringForKey(key: "Tariff_reconnected")
            view.image_icon.image = UIImage(named: "correct_alert")
            view.cancel.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
            view.ok.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
        }
        else {
            view.name.text = defaultLocalizer.stringForKey(key: "error_title")
            view.image_icon.image = UIImage(named: "uncorrect_alert")
            view.cancel.addTarget(self, action: #selector(dismissDialogCancel), for: .touchUpInside)
            view.ok.addTarget(self, action: #selector(dismissDialogCancel), for: .touchUpInside)
        }
        
        view.name_content.text = "\(message)"
        view.ok.setTitle("OK", for: .normal)
        
        alert.view.backgroundColor = .clear
        alert.view.addSubview(view)
        //alert.view.sendSubviewToBack(view)
        
        present(alert, animated: true, completion: nil)

        
    }
    
    @objc func dismissDialog(_ sender: UIButton) {
        alert.dismiss(animated: true, completion: nil)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(ChangeTarifViewController(), animated: false)
        hideActivityIndicator(uiView: view)
    }
    
    @objc func dismissDialogCancel(_ sender: UIButton) {
    
        sender.showAnimation { [self] in
            alert.dismiss(animated: true, completion: nil)
           // hideActivityIndicator(uiView: view)
        }
        hideActivityIndicator(uiView: view)
    }
    
    @objc func okClickDialog(_ sender: UIButton) {
        
        alert.dismiss(animated: true, completion: nil)
        showActivityIndicator(uiView: view)
    
        let parametr: [String: Any] = ["priceplanForUserId": info_data[0][0], "discountId": discount_id]
        
        let client = APIClient.shared
            do{
              try client.changePricepPlan(jsonBody: parametr).subscribe(
                onNext: { [self] result in
                  print(result)
                    DispatchQueue.main.async {
                        if result.success == true {
                            requestAnswer(status: true, message: String(result.message ?? ""))
                        }
                        else {
                            requestAnswer(status: false, message: String(result.message ?? ""))
                        }
                    }
                   
                },
                onError: { [self] error in
                    DispatchQueue.main.async {
                        self.hideActivityIndicator(uiView: self.view)
                        requestAnswer(status: false, message: defaultLocalizer.stringForKey(key: "service is temporarily unavailable"))
                        print(error.localizedDescription)
                        
                    }
                    
                },
                onCompleted: { [self] in
                    
                   print("Completed event.")
                    
                }).disposed(by: disposeBag)
              }
              catch{
            }
    }
    
    
    func sendRequest() {
        availables_data.removeAll()
        balances_data.removeAll()
        unlim_data.removeAll()
        overChargings_data.removeAll()
        options_element.removeAll()
        info_data.removeAll()
        
        let client = APIClient.shared
            do{
                try client.pricePlanIDGetRequest(parametr: id_tarif_choosed).subscribe(
                onNext: { result in
                    DispatchQueue.main.async {
                        var spisanie_data = ""
                        if result.selected.nextApplyDate != nil {
                            let dateFormatter1 = DateFormatter()
                            dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                            let date = dateFormatter1.date(from: String(result.selected.nextApplyDate!))
                            dateFormatter1.dateFormat = "dd-MM-yyyy"
                            spisanie_data = self.defaultLocalizer.stringForKey(key: "Active_before:") + "\(dateFormatter1.string(from: date!))"
                         }
                        else {
                            spisanie_data = ""
                        }
                        
                        if result.selected.discount != nil {
                            self.discount_id = String(result.selected.discount!.discountServiceId)
                         }
                        else {
                            self.discount_id = ""
                        }
                        
                        self.info_data.append([String(result.selected.id), String(result.selected.priceplanName ?? ""), spisanie_data])
                        
                        if result.selected.balances != nil {
                            for i in 0 ..< result.selected.balances!.count {
                                self.balances_data.append([String(result.selected.balances![i].unitId), String(result.selected.balances![i].start), String(result.selected.balances![i].unlim)])
                            }
                        }
                        
                        if result.selected.unlimOptions != nil {
                            
                            self.options_element = [[String]](repeating: [String](repeating: "hh", count: 1), count: result.selected.unlimOptions!.count)
                            
                            for i in 0 ..< result.selected.unlimOptions!.count {
                                self.options_element[i] = [String](repeating: "", count: result.selected.unlimOptions![i].dpiUnlimElements.count)
                            }
                            
                            for i in 0 ..< result.selected.unlimOptions!.count {
                                
                                self.unlim_data.append([result.selected.unlimOptions![i].optionName])
                               
                                for j in 0 ..< result.selected.unlimOptions![i].dpiUnlimElements.count {
                                    
                                    self.options_element[i][j] = result.selected.unlimOptions![i].dpiUnlimElements[j].iconUrl
                                }
                                print(self.options_element)
                                
                            }
                            
                        }
                        
                        if result.selected.overCharging != nil {
                            for i in 0 ..< result.selected.overCharging!.count {
                                self.overChargings_data.append([String(result.selected.overCharging![i].description), String(result.selected.overCharging![i].directionPrice), String(result.selected.overCharging![i].priceAndUnit)])
                            }
                        }
                        
                        self.overChargings_data.append([String(result.selected.period ?? ""), "", String(result.selected.price ?? "")])
                        
                        if result.available.count != 0 {
                            for i in 0 ..< result.available.count {
                                self.availables_data.append([String(result.available[i].id), String(result.available[i].priceplanName), String(result.available[i].price ?? ""), String(result.available[i].currencyAndPeriod ?? ""), String(result.available[i].description ?? "")])
                            }
                        }
                    }
                },
                onError: { error in
                   print(error.localizedDescription)
                    DispatchQueue.main.async { [self] in
                        setupView()
                        setupTarifBalanceViewSection()
                        setupTabCollectionView()
                        hideActivityIndicator(uiView: self.view)
                        requestAnswer(status: false, message: defaultLocalizer.stringForKey(key: "service is temporarily unavailable"))
                    }
                },
                onCompleted: {
                    DispatchQueue.main.async { [self] in
                        setupView()
                        setupTarifBalanceViewSection()
                        setupTabCollectionView()
                        hideActivityIndicator(uiView: view)
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
        if collectionView == TabCollectionView {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        } else {
            return CGSize(width: 80, height: collectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == TabCollectionView {
            return 1
        } else {
            return balances_data.count
        }
     
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == TarifBalanceView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellTarBalV, for: indexPath) as! TarifBalanceCollectionViewCell
            print(balances_data[indexPath.row][0])

            if balances_data[indexPath.row][2] == "true" {
                cell.titleOne.text = "∞"
                cell.titleOne.font = UIFont.boldSystemFont(ofSize: 22)
            }
            else {
                cell.titleOne.text = balances_data[indexPath.row][1]
                cell.titleOne.font = UIFont.boldSystemFont(ofSize: 16)
            }
            
            if balances_data[indexPath.row][0] == "3" {
                cell.image.image = UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "Item-3.png") : UIImage(named: "internet_tarif.png")
            }
            else if balances_data[indexPath.row][0] == "4"  {
                cell.image.image = UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "Item-2.png") : UIImage(named: "minuti_zet_tarif.png")
            }
            else if balances_data[indexPath.row][0] == "1"  {
                cell.image.image = UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "Item.png") : UIImage(named: "minuti_tarif.png")
            }
            else if balances_data[indexPath.row][0] == "2"  {
                cell.image.image = UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "Item-4.png") : UIImage(named: "sms_tarif.png")
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tabs", for: indexPath) as! TabCollectionViewCell
            if indexPath.row == 0 {
                table.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 110 + (topPadding ?? 0) + (bottomPadding ?? 0)))
                table.register(TarifTabViewCell.self, forCellReuseIdentifier: "tarif_tab_cell")
                table.delegate = self
                table.dataSource = self
                table.rowHeight = 100
                table.estimatedRowHeight = 100
                table.alwaysBounceVertical = false
                table.backgroundColor = contentColor
                table.separatorColor = .lightGray
                cell.addSubview(table)
            }
            else {
                
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == TabCollectionView {
            if indexPath.row == 0 {
                tarifView.tab1.textColor = colorBlackWhite
                tarifView.tab2.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
                tarifView.tab1Line.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
                tarifView.tab2Line.backgroundColor = .clear
          } else {
                tarifView.tab1.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
                tarifView.tab2.textColor = colorBlackWhite
                tarifView.tab1Line.backgroundColor = .clear
                tarifView.tab2Line.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
          }
       }
    }
}

extension ChangeTarifViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if availables_data[indexPath.row][4] == "" {
             return 90
         }
         else {
             return 120
         }
    }
    
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
     
        cell.ico_image.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "Ellipse 27-2_dark2") : UIImage(named: "Ellipse 27-2"))
        cell.titleOne.text = availables_data[indexPath.row][1]
        cell.titleTwo.text = availables_data[indexPath.row][4]
        
        let cost: NSString = availables_data[indexPath.row][2] as NSString
        let range = (cost).range(of: cost as String)
        let costString = NSMutableAttributedString.init(string: cost as String)
        costString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange , range: range)
        costString.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], range: range)
        
        let title_cost = " \(availables_data[indexPath.row][3])" as NSString
        let titleString = NSMutableAttributedString.init(string: title_cost as String)
        let range2 = (title_cost).range(of: title_cost as String)
        titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: darkGrayLight , range: range2)
        titleString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], range: range2)
        
        costString.append(titleString)
        
        cell.titleThree.attributedText = costString
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.00) : UIColor(red: 1.00, green: 0.98, blue: 0.94, alpha: 1.00))
        bgColorView.layer.borderColor = UIColor.orange.cgColor
        bgColorView.layer.borderWidth = 1
        bgColorView.layer.cornerRadius = 10
        cell.selectedBackgroundView = bgColorView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        id_tarif_choosed = availables_data[indexPath.row][0]
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(ChangeTarifViewController(), animated: true)
        
    }
    
}
