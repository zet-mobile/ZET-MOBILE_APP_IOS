//
//  AboutAppView.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 1/8/22.
//

import UIKit

class AboutAppView: UIView {
    
    let logo: UIImageView = {
        let iv = UIImageView()
        iv.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "about_app_b") : UIImage(named: "about_app"))
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .clear
        
        return iv
    }()

    let back_app: UIImageView = {
        let iv = UIImageView()
        iv.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "back_app_w") : UIImage(named: "back_app"))

        iv.contentMode = .scaleToFill
        iv.backgroundColor = .clear
        
        return iv
    }()
    
    lazy var version_app: UILabel = {
        let title = UILabel()
        title.text = ""
        title.numberOfLines = 1
        title.textColor = colorBlackWhite
        title.font = UIFont.systemFont(ofSize: 16)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .center
        title.frame = CGRect(x: 30, y: (Int(UIScreen.main.bounds.size.height) * 150) / 844, width: Int(UIScreen.main.bounds.size.width) - 60, height: 30)
        title.autoresizesSubviews = true
        title.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return title
    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.text = "Попробуйте другие наши приложения"
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.font = UIFont.systemFont(ofSize: (UIScreen.main.bounds.size.width * 18) / 390)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.textAlignment = .center
        label.frame = CGRect(x: 30, y: (Int(UIScreen.main.bounds.size.height) * 210) / 844, width: Int(UIScreen.main.bounds.size.width) - 60, height: 28)
        label.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return label
    }()
    
    lazy var button: UIButton = {
        let button = UIButton(frame: CGRect(x: 20, y: (Int(UIScreen.main.bounds.size.height) * 594) / 844, width: Int(UIScreen.main.bounds.size.width) - 40, height: 40))
        button.backgroundColor = .clear
        button.setTitle("Политика конфиденциальности", for: .normal)
        button.setTitleColor(.orange, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.layer.borderColor = UIColor.orange.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = button.frame.height / 2
        
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
        backgroundColor = contentColor
        
        logo.frame = CGRect(x: (Int(UIScreen.main.bounds.size.width) / 2) - 75, y: (Int(UIScreen.main.bounds.size.height) * 40) / 844, width: 150, height: (Int(UIScreen.main.bounds.size.height) * 80) / 844)
        
        back_app.frame = CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.size.width), height: (Int(UIScreen.main.bounds.size.height) * 200) / 844)
        
        self.addSubview(back_app)
        self.sendSubviewToBack(back_app)
        
        self.addSubview(logo)
        self.addSubview(version_app)
        self.addSubview(title)
        self.addSubview(button)
    }

}
