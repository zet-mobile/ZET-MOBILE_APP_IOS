//
//  MoreDetailViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 16/04/22.
//

import UIKit

class MoreDetailViewController: UIViewController, UIScrollViewDelegate {
    
    let more_view = MoreDetailView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 10, height: UIScreen.main.bounds.size.height + 800))
    
    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        modalPresentationCapturesStatusBarAppearance = false
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.backgroundColor = .clear
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 800)
        view.addSubview(scrollView)
        
        scrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        
        more_view.layer.cornerRadius = 10
        scrollView.addSubview(more_view)

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent

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
    
    
}

class MoreDetailView: UIView {
    
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "transfer")
        image.frame = CGRect(x: 20, y: 70, width: UIScreen.main.bounds.size.width - 40, height: UIScreen.main.bounds.size.width - 40)
        return image
    }()
    
    lazy var close: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: UIScreen.main.bounds.size.width - 50, y: 20, width: 20, height: 20)
        button.setImage(#imageLiteral(resourceName: "close_icon"), for: UIControl.State.normal)
        button.isUserInteractionEnabled = true
        //button.addTarget(self, action: #selector(moreTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var title_top: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 20, y: 5, width: UIScreen.main.bounds.size.width - 40, height: 50)
    
        title.numberOfLines = 1
        title.textColor = colorBlackWhite
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.textAlignment = .left
        return title
    }()
    
    lazy var title: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 20, y: (UIScreen.main.bounds.size.width - 40) + 90, width: UIScreen.main.bounds.size.width - 40, height: 50)
        title.text = defaultLocalizer.stringForKey(key: "Conditions")
        title.numberOfLines = 1
        title.textColor = colorBlackWhite
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.textAlignment = .left
        
        return title
    }()
    
    lazy var content: UITextView = {
        let title = UITextView()
        title.frame = CGRect(x: 20, y: (Int(UIScreen.main.bounds.size.width) - 40) + 140, width: Int(UIScreen.main.bounds.size.width) - 40, height: 400)
        title.textColor = darkGrayLight
        //title.numberOfLines = 0
        title.showsVerticalScrollIndicator = true
        title.isEditable = false
        title.isScrollEnabled = true
        title.font = UIFont.systemFont(ofSize: 16)
        title.textAlignment = .left
        title.text = ""
        title.backgroundColor = .clear
        return title
    }()
    
    lazy var close_banner: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 10, y: (UIScreen.main.bounds.size.width - 40) + 600, width: UIScreen.main.bounds.size.width - 20, height: 50)
        button.isUserInteractionEnabled = true
        button.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
        button.setTitle(defaultLocalizer.stringForKey(key: "Close"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.layer.cornerRadius = button.frame.height / 2
        //button.addTarget(self, action: #selector(moreTapped), for: .touchUpInside)
        return button
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
        backgroundColor = colorGrayWhite
     
        self.addSubview(image)
        self.addSubview(title)
        self.addSubview(close)
        self.addSubview(content)
        self.addSubview(title_top)
        self.addSubview(close_banner)
    }
}

