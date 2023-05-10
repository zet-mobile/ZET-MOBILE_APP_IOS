//
//  MenuView.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 2/24/22.
//

import UIKit

class MenuView: UIView {

    lazy var title: UILabel = {
        let title = UILabel()
        title.text = defaultLocalizer.stringForKey(key: "social_networks").uppercased()
        title.numberOfLines = 2
        title.textColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00)
        title.font = UIFont.systemFont(ofSize: 14)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .center
        title.frame = CGRect(x: 0, y: 20, width: frame.width, height: 40)
        title.autoresizesSubviews = true
        title.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        title.isHidden = false
        return title
    }()
    
    
    lazy var vk: UIButton = {
        let button = UIButton(frame: CGRect(x: (frame.width / 2) - 20 - 30 - 50, y: 60, width: 40, height: 40))
        
        button.setBackgroundImage(UIImage(named: "vk.png"), for: UIControl.State.normal)
        return button
    }()
    
    lazy var telegram: UIButton = {
        let button = UIButton(frame: CGRect(x: (frame.width / 2) - 20 , y: 60, width: 40, height: 40))
        
        button.setBackgroundImage(UIImage(named: "telegram.png"), for: UIControl.State.normal)
        return button
    }()
    
    lazy var instagram: UIButton = {
        let button = UIButton(frame: CGRect(x: (frame.width / 2) + 20 + 30, y: 60, width: 40, height: 40))
        
        button.setBackgroundImage(UIImage(named: "instagram.png"), for: UIControl.State.normal)
        return button
    }()

    lazy var end_title: UILabel = {
        let title = UILabel()
        title.text = "© ZET-MOBILE 2023"
        title.numberOfLines = 1
        title.textColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00)
        title.font = UIFont.systemFont(ofSize: 14)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .center
        title.frame = CGRect(x: 0, y: 110, width: frame.width, height: 20)
        title.autoresizesSubviews = true
        title.autoresizingMask = [.flexibleHeight, .flexibleWidth]

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
        backgroundColor = contentColor
       
        self.addSubview(title)
        self.addSubview(vk)
        self.addSubview(telegram)
        self.addSubview(instagram)
        self.addSubview(end_title)
    }
}
