//
//  MoreHistoryConntroller.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 18/11/22.
//

import UIKit

class MoreHistoryController: UIViewController, UIScrollViewDelegate {
    
    let more_view = MoreHistoryDetailView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height / 2))
    
    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        modalPresentationCapturesStatusBarAppearance = false
        
        if #available(iOS 14.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.backgroundColor = .clear
        scrollView.isScrollEnabled = true
        
        more_view.layer.cornerRadius = 10
      
        scrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height / 2)
        view.addSubview(scrollView)
        scrollView.addSubview(more_view)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? .lightContent : .darkContent)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 14.0, *) {
            scrollView.scrollIndicatorInsets = view.safeAreaInsets
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.safeAreaInsets.bottom, right: 0)
        } else {
            // Fallback on earlier versions
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        }
    }
}

class MoreHistoryDetailView: UIView {
    
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    lazy var close: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: UIScreen.main.bounds.size.width - 50, y: 10, width: 30, height: 30)
        button.setImage(#imageLiteral(resourceName: "close_icon"), for: UIControl.State.normal)
        button.isUserInteractionEnabled = true
        //button.addTarget(self, action: #selector(moreTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var title_top: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 20, y: 50, width: UIScreen.main.bounds.size.width - 120, height: 50)
        title.numberOfLines = 1
        title.textColor = colorBlackWhite
        title.font = UIFont.boldSystemFont(ofSize: 20)
        title.textAlignment = .left
        return title
    }()
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "first.png") : UIImage(named: "first_l.png"))
        image.frame = CGRect(x: UIScreen.main.bounds.size.width - 80, y: 50, width: 60, height: 60)
        return image
    }()
    
    lazy var title: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 20, y: 100, width: UIScreen.main.bounds.size.width - 40, height: 30)
        title.numberOfLines = 1
        title.textColor = colorBlackWhite
        title.font = UIFont.boldSystemFont(ofSize: 20)
        title.textAlignment = .left
        
        return title
    }()
    
    lazy var date_label: UILabel = {
        let title = UILabel()
        title.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        title.frame = CGRect(x: 20, y: 140, width: UIScreen.main.bounds.size.width - 40, height: 30)
        title.font = UIFont.systemFont(ofSize: 18)
        title.textAlignment = .left
        title.text = ""
        return title
    }()
    
    lazy var status_label: UILabel = {
        let title = UILabel()
        title.textColor = darkGrayLight
        title.frame = CGRect(x: 20, y: 180, width: UIScreen.main.bounds.size.width - 40, height: 30)
        title.font = UIFont.systemFont(ofSize: 18)
        title.textAlignment = .left
        title.text = ""
        return title
    }()
    
    lazy var cost_label: UILabel = {
        let title = UILabel()
        title.textColor = colorBlackWhite
        title.frame = CGRect(x: 20, y: 210, width: UIScreen.main.bounds.size.width - 40, height: 30)
        title.font = UIFont.systemFont(ofSize: 18)
        title.textAlignment = .left
        title.text = defaultLocalizer.stringForKey(key: "cost_packet")
        return title
    }()
    
    lazy var commission_label: UILabel = {
        let title = UILabel()
        title.textColor = colorBlackWhite
        title.frame = CGRect(x: 20, y: 240, width: (UIScreen.main.bounds.size.width / 2) + 20, height: 50)
        title.font = UIFont.systemFont(ofSize: 18)
        title.textAlignment = .left
        title.numberOfLines = 2
        title.text = defaultLocalizer.stringForKey(key: "commission_packet")
        return title
    }()
    
    lazy var summa_label: UILabel = {
        let title = UILabel()
        title.textColor = colorBlackWhite
        title.frame = CGRect(x: 20, y: 290, width: UIScreen.main.bounds.size.width - 40, height: 30)
        title.font = UIFont.systemFont(ofSize: 18)
        title.textAlignment = .left
        title.text = defaultLocalizer.stringForKey(key: "TOTAL") + ":"
        return title
    }()
    
    lazy var cost_title: UILabel = {
        let title = UILabel()
        title.textColor = colorBlackWhite
        title.frame = CGRect(x: 20, y: 290, width: 40, height: 30)
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.textAlignment = .right
        return title
    }()
    
    lazy var commission_title: UILabel = {
        let title = UILabel()
        title.textColor = colorBlackWhite
        title.frame = CGRect(x: 20, y: 290, width: 40, height: 30)
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.textAlignment = .right
        return title
    }()
    
    lazy var summa_title: UILabel = {
        let title = UILabel()
        title.textColor = colorBlackWhite
        title.frame = CGRect(x: 20, y: 290, width: 40, height: 30)
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.textAlignment = .right
        return title
    }()
    
    lazy var time_label: UILabel = {
        let title = UILabel()
        title.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        title.font = UIFont.systemFont(ofSize: 18)
        title.textAlignment = .right
        return title
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        
    }
    
    private func setupView() {
        backgroundColor = alertColor
     
        self.addSubview(image)
        self.addSubview(title)
        self.addSubview(close)
        self.addSubview(date_label)
        self.addSubview(title_top)
        
        self.addSubview(status_label)
        self.addSubview(cost_label)
        self.addSubview(commission_label)
        self.addSubview(summa_label)
        self.addSubview(cost_title)
        self.addSubview(commission_title)
        self.addSubview(summa_title)
        self.addSubview(time_label)
    }
}
