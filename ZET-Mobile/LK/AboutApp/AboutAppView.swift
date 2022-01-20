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
        iv.image = UIImage(named: "about_app")
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .clear
        
        return iv
    }()

    let back_app: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "back_app")
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .clear
        
        return iv
    }()
    
    lazy var version_app: UILabel = {
        let title = UILabel()
        title.text = "V. 1.12.03"
        title.numberOfLines = 1
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 16)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .center
        title.frame = CGRect(x: 30, y: 190, width: UIScreen.main.bounds.size.width - 60, height: 30)
        title.autoresizesSubviews = true
        title.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return title
    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.text = "Попробуйте другие наши приложения"
        label.numberOfLines = 0
        label.textColor = UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.00)
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.textAlignment = .center
        label.frame = CGRect(x: 30, y: 300, width: UIScreen.main.bounds.size.width - 60, height: 28)
        label.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return label
    }()
    
    lazy var button: UIButton = {
        let button = UIButton(frame: CGRect(x: 20, y: Int(UIScreen.main.bounds.size.height) - 250, width: Int(UIScreen.main.bounds.size.width) - 40, height: 50))
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
        backgroundColor = .white
        
        logo.frame = CGRect(x: (UIScreen.main.bounds.size.width / 2) - 90, y: 40, width: 180, height: 140)
        
        back_app.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 180)
        
        self.addSubview(back_app)
        self.sendSubviewToBack(back_app)
        
        self.addSubview(logo)
        self.addSubview(version_app)
        self.addSubview(title)
        self.addSubview(button)
    }

}
