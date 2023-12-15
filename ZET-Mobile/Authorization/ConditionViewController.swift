//
//  ConditionViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 2/22/22.
//

import UIKit

class ConditionViewController: UIViewController, UIScrollViewDelegate {

    let condition_view = ConditionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
    
    let scrollView = UIScrollView()
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "Frame 150 1") : UIImage(named: "zet 1-2"))
    //    image.frame = CGRect(x: UIScreen.main.bounds.size.width / 2 - 100, y: 70, width: 200, height: 30)
        return image
    }()
    
    lazy var close: UIButton = {
        let button = UIButton()
       // button.frame = CGRect(x: UIScreen.main.bounds.size.width - 50, y: 20, width: 30, height: 30)
        button.setImage(#imageLiteral(resourceName: "close_icon"), for: UIControl.State.normal)
        button.isUserInteractionEnabled = true
        //button.addTarget(self, action: #selector(moreTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var title_view: UILabel = {
        let title = UILabel()
       // title.frame = CGRect(x: 20, y: 110, width: UIScreen.main.bounds.size.width - 40, height: 50)
        title.text = defaultLocalizer.stringForKey(key: "userOfferDocumentTitle") 
        title.numberOfLines = 1
        title.textColor = colorBlackWhite
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.textAlignment = .left
        
        return title
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        modalPresentationCapturesStatusBarAppearance = true
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.backgroundColor = .clear
        
        condition_view.layer.cornerRadius = 10
        
        condition_view.content.frame.size.height = CGFloat.greatestFiniteMagnitude
        condition_view.content.textColor = darkGrayLight
        condition_view.content.numberOfLines = 0
        condition_view.content.lineBreakMode = NSLineBreakMode.byWordWrapping
        condition_view.content.sizeToFit()
      
        print(condition_view.content.frame.height)
        condition_view.content.frame.origin.y = 10
        scrollView.contentSize = CGSize(width: view.frame.width, height: condition_view.content.frame.height + 210)
        condition_view.frame.size.height = condition_view.content.frame.height + 210
        
        scrollView.frame = CGRect(x: 0, y: 160, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - (bottomPadding ?? 0))
        view.addSubview(scrollView)
        
        view.addSubview(image)
        view.addSubview(title_view)
        view.addSubview(close)
        

        close.translatesAutoresizingMaskIntoConstraints = false
        close.widthAnchor.constraint(equalToConstant: 30).isActive = true
        close.heightAnchor.constraint(equalToConstant: 30).isActive = true
        close.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        close.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true

        
        image.translatesAutoresizingMaskIntoConstraints = false
        image.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        image.widthAnchor.constraint(equalToConstant: 200).isActive = true
        image.heightAnchor.constraint(equalToConstant: 30).isActive = true
        image.topAnchor.constraint(equalTo: close.bottomAnchor, constant: 20).isActive = true
        
    
        title_view.translatesAutoresizingMaskIntoConstraints = false
        title_view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        title_view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        title_view.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20).isActive = true
        
        
        scrollView.addSubview(condition_view)
        
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.scrollView == scrollView {
            if scrollView.contentOffset.y > condition_view.content.frame.origin.y {
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

class ConditionView: UIView {
    
    lazy var content: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 20, y: 10, width: UIScreen.main.bounds.size.width - 40, height: CGFloat.greatestFiniteMagnitude)
        title.textColor = darkGrayLight
        title.font = UIFont.systemFont(ofSize: 16)
        title.textAlignment = .left
        title.text = defaultLocalizer.stringForKey(key: "userOfferDocument")
 
        title.numberOfLines = 0
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.sizeToFit()
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
        backgroundColor = colorGrayWhite
    
        self.addSubview(content)
    
    }
}

