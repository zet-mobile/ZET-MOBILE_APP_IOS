//
//  MoreDetailViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 16/04/22.
//

import UIKit

class MoreDetailViewController: UIViewController, UIScrollViewDelegate {
    
    let more_view = MoreDetailView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
    
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
        more_view.content.textColor = darkGrayLight
      
        more_view.content.frame.size.height = CGFloat.greatestFiniteMagnitude
        more_view.content.numberOfLines = 0
        more_view.content.lineBreakMode = NSLineBreakMode.byWordWrapping
        more_view.content.sizeToFit()

        if more_view.image.image != nil {
            more_view.image.frame = CGRect(x: 20, y: 90, width: more_view.image.contentClippingRect.width, height: more_view.image.contentClippingRect.height)
        }
        else {
            more_view.image.frame = CGRect(x: 20, y: 90, width: 0, height: 0)
        }
        more_view.content.frame.origin.y = more_view.image.frame.size.height + 120
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: more_view.content.frame.height + more_view.image.frame.size.height + 220)
        more_view.frame.size.height = more_view.content.frame.height + more_view.image.frame.size.height + 220
        
        more_view.close_banner.frame.origin.y = more_view.content.frame.height + more_view.image.frame.size.height + 140
      
        scrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - (topPadding ?? 0) + (bottomPadding ?? 0))
       

        scrollView.addSubview(more_view)
        view.addSubview(scrollView)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.scrollView == scrollView {
            if scrollView.contentOffset.y > more_view.image.frame.origin.y {
                print("large")
                modalPresentationStyle = .pageSheet
                if #available(iOS 15.0, *) {
                    sheetPresentationController?.selectedDetentIdentifier = .large
                } else {
                    // Fallback on earlier versions
                }
            }
        }
    }
}

class MoreDetailView: UIView {
    
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.frame = CGRect(x: 20, y: 70, width: UIScreen.main.bounds.size.width - 40, height: UIScreen.main.bounds.size.width - 40)
        image.isHidden = true
        return image
    }()
    
    lazy var close: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: UIScreen.main.bounds.size.width - 50, y: 20, width: 30, height: 30)
        button.setImage(#imageLiteral(resourceName: "close_icon"), for: UIControl.State.normal)
        button.isUserInteractionEnabled = true
        //button.addTarget(self, action: #selector(moreTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var title_top: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 20, y: 20, width: UIScreen.main.bounds.size.width - 70, height: 30)
        title.numberOfLines = 1
        title.textColor = colorBlackWhite
        title.font = UIFont.boldSystemFont(ofSize: 20)
        title.textAlignment = .left
        return title
    }()
    
    lazy var title: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 20, y: 70, width: UIScreen.main.bounds.size.width - 40, height: 50)
       // title.text = defaultLocalizer.stringForKey(key: "Conditions")
        title.numberOfLines = 1
        title.textColor = colorBlackWhite
        title.font = UIFont.boldSystemFont(ofSize: 20)
        title.textAlignment = .left
        
        return title
    }()
    
    lazy var content: UILabel = {
        let title = UILabel()
        title.textColor = darkGrayLight
        title.frame = CGRect(x: 20, y: 120, width: UIScreen.main.bounds.size.width - 40, height: 700)
        title.font = UIFont.systemFont(ofSize: 18)
        title.textAlignment = .left
        title.text = ""
        return title
    }()
    
    lazy var close_banner: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 10, y: 580, width: UIScreen.main.bounds.size.width - 20, height: 50)
        button.isUserInteractionEnabled = true
        button.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
        button.setTitle(defaultLocalizer.stringForKey(key: "Close"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.layer.cornerRadius = button.frame.height / 2
        button.isUserInteractionEnabled = true
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
        self.addSubview(title_top)
        self.addSubview(close_banner)
        self.addSubview(content)

    }
}

extension UIImageView {
    var contentClippingRect: CGRect {
        guard let image = image else { return bounds }
        guard contentMode == .scaleAspectFit else { return bounds }
        guard image.size.width > 0 && image.size.height > 0 else { return bounds }

        let scale: CGFloat
        if image.size.width > image.size.height {
            scale = bounds.width / image.size.width
        } else {
            scale = bounds.height / image.size.height
        }

        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let x = (bounds.width - size.width) / 2.0
        let y = (bounds.height - size.height) / 2.0

        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }
}
