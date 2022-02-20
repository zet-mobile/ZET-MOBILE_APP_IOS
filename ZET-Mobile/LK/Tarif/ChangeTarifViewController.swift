//
//  ChangeTarifViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/7/21.
//

import UIKit

class ChangeTarifViewController: UIViewController, UIScrollViewDelegate {
    
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    let scrollView = UIScrollView()
    
    var toolbar = TarifToolbarView()
    var tarifView = TarifView()
    
    var icon_count = 2
    var icon_count2 = 1
    
    var x_pozition = 20
    var y_pozition = 320
    
    let TabCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(TabCollectionViewCell.self, forCellWithReuseIdentifier: "tabs")
        cv.showsHorizontalScrollIndicator = false
        
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
        tarifView = TarifView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 896))
        
        toolbar.icon_back.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        
        toolbar.number_user_name.text = "Сменить тариф"
        tarifView.welcome.text = "Тариф “Фаври"
        tarifView.user_name.text = "80 сомони / 30 дней"
        tarifView.white_view_back.frame.origin.y = 100
        let labels = getLabelsInView(view: tarifView)
        for label in labels {
            label.frame.origin.y = label.frame.origin.y - 80
        }
        tarifView.welcome.frame.origin.y = 5
        tarifView.user_name.frame.origin.y = 35
        
        self.view.addSubview(toolbar)
        scrollView.addSubview(tarifView)
        
        for i in 0 ..< icon_count {
            print("i \(i) \(50 * (i + 1))")
            let unlimits = UIImageView()
            unlimits.image = UIImage(named: "VK_black")
            
            
            if x_pozition > 378 {
                x_pozition = 20
                unlimits.frame = CGRect(x: x_pozition, y: y_pozition, width: 30, height: 30)
                y_pozition = y_pozition + 40
            }
            else {
                unlimits.frame = CGRect(x: x_pozition, y: y_pozition, width: 30, height: 30)
                x_pozition = x_pozition + 50
            }
            scrollView.addSubview(unlimits)
        
        }
        
        print(x_pozition)
        print(y_pozition)
        if 428 - x_pozition < 250 {
            y_pozition = y_pozition + 40
            x_pozition = 20
        }
        
        let title = UILabel(frame: CGRect(x: x_pozition, y: y_pozition, width: 250, height: 25))
        title.text = "Безлимит на социальные сети"
        title.numberOfLines = 0
        title.textColor = .darkGray
        title.font = UIFont.systemFont(ofSize: 15)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        
        scrollView.addSubview(title)
        
        x_pozition = 20
        y_pozition = y_pozition + 40
        
        for i in 0 ..< icon_count2 {
            let unlimits = UIImageView()
            unlimits.image = UIImage(named: "VK_black")
            
            if x_pozition > 378 {
                x_pozition = 20
                unlimits.frame = CGRect(x: x_pozition, y: y_pozition, width: 30, height: 30)
                y_pozition = y_pozition + 40
            }
            else {
                unlimits.frame = CGRect(x: x_pozition, y: y_pozition, width: 30, height: 30)
                x_pozition = x_pozition + 50
            }
            scrollView.addSubview(unlimits)
        
        }
        
        if 428 - x_pozition < 200 {
            y_pozition = y_pozition + 40
            x_pozition = 20
        }
        
        let title2 = UILabel(frame: CGRect(x: x_pozition, y: y_pozition, width: 200, height: 25))
        title2.text = "Ночной безлимит"
        title2.numberOfLines = 0
        title2.textColor = .darkGray
        title2.font = UIFont.systemFont(ofSize: 15)
        title2.lineBreakMode = NSLineBreakMode.byWordWrapping
        title2.textAlignment = .left
        
        scrollView.addSubview(title2)
        
        y_pozition = y_pozition + 50
        let ReconnectBut = UIButton(frame: CGRect(x: 20, y: y_pozition, width: Int(UIScreen.main.bounds.size.width) - 40, height: 45))
        //ReconnectBut.setImage(#imageLiteral(resourceName: "connect"), for: UIControl.State.normal)
        //openmenu.addTarget(self, action: #selector(goback), for: UIControl.Event.touchUpInside)
        ReconnectBut.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
        ReconnectBut.setTitle(defaultLocalizer.stringForKey(key: "connect"), for: .normal)
        ReconnectBut.setTitleColor(.white, for: .normal)
        ReconnectBut.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        ReconnectBut.layer.cornerRadius = ReconnectBut.frame.height / 2
        scrollView.addSubview(ReconnectBut)
        
        scrollView.frame = CGRect(x: 0, y: 104, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 104)
    }

    func setupTabCollectionView() {
        y_pozition = y_pozition + 55
        
        tarifView.tab1.frame = CGRect(x: 0, y: y_pozition, width: Int(UIScreen.main.bounds.size.width) / 2, height: 50)
        tarifView.tab2.frame = CGRect(x: UIScreen.main.bounds.size.width / 2 - 20, y: CGFloat(y_pozition), width: UIScreen.main.bounds.size.width / 2 - 20, height: 50)
        
        tarifView.tab1Line.frame = CGRect(x: 0, y: y_pozition + 55, width: Int(UIScreen.main.bounds.size.width) / 2, height: 50)
        tarifView.tab2Line.frame = CGRect(x: UIScreen.main.bounds.size.width / 2 - 20, y: CGFloat(y_pozition + 55), width: UIScreen.main.bounds.size.width / 2 - 20, height: 50)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tab1Click))
        tarifView.tab1.isUserInteractionEnabled = true
        tarifView.tab1.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(tab2Click))
        tarifView.tab2.isUserInteractionEnabled = true
        tarifView.tab2.addGestureRecognizer(tapGestureRecognizer2)
        
        scrollView.addSubview(TabCollectionView)
        TabCollectionView.backgroundColor = .white
        TabCollectionView.frame = CGRect(x: 0, y: y_pozition + 60, width: Int(UIScreen.main.bounds.size.width), height: Int(UIScreen.main.bounds.size.height - 150))
        TabCollectionView.delegate = self
        TabCollectionView.dataSource = self
        TabCollectionView.alwaysBounceVertical = false
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.scrollView == scrollView {
            if scrollView.contentOffset.y > tarifView.tab1.frame.origin.y {
                tarifView.zetImage.isHidden = true
                tarifView.welcome.isHidden = true
                tarifView.user_name.isHidden = true
                tarifView.titleOne.isHidden = true
                tarifView.title2.isHidden = true
                tarifView.title3.isHidden = true
                tarifView.title4.isHidden = true
                tarifView.title5.isHidden = true
                tarifView.title6.isHidden = true
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
                tarifView.titleOne.isHidden = false
                tarifView.title2.isHidden = false
                tarifView.title3.isHidden = false
                tarifView.title4.isHidden = false
                tarifView.title5.isHidden = false
                tarifView.title6.isHidden = false
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

    func getLabelsInView(view: UIView) -> [UILabel] {
        var results = [UILabel]()
        for subview in view.subviews as [UIView] {
            if let labelView = subview as? UILabel {
                results += [labelView]
            } else {
                results += getLabelsInView(view: subview)
            }
        }
        return results
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
