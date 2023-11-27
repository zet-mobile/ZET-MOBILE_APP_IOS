//
//  TarifToolbarView.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/5/21.
//

import UIKit

class TarifToolbarView: UIView {

    lazy var number_user_name: UILabel = {
        let number_user_name = UILabel()
        number_user_name.text = ""
        number_user_name.numberOfLines = 0
        number_user_name.textColor = colorBlackWhite
        number_user_name.font = UIFont.preferredFont(forTextStyle: .subheadline)
        number_user_name.font = UIFont.boldSystemFont(ofSize: 18)
        number_user_name.lineBreakMode = NSLineBreakMode.byWordWrapping
        number_user_name.textAlignment = .center
        
        return number_user_name
    }()
    
    
    lazy var icon_back: UIButton = {
        let icon_back = UIButton()
        icon_back.setImage((UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? #imageLiteral(resourceName: "back_w") : #imageLiteral(resourceName: "back_icon")), for: UIControl.State.normal)
        return icon_back
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
        backgroundColor = toolbarColor
        self.addSubview(number_user_name)
        self.addSubview(icon_back)
        
        icon_back.translatesAutoresizingMaskIntoConstraints = false
        number_user_name.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            icon_back.topAnchor.constraint(equalTo: topAnchor, constant: 27),
            icon_back.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            icon_back.heightAnchor.constraint(equalToConstant: 20),
            icon_back.widthAnchor.constraint(equalToConstant: 11),
            
            number_user_name.centerYAnchor.constraint(equalTo: icon_back.centerYAnchor),
            number_user_name.centerXAnchor.constraint(equalTo: centerXAnchor)
            
        ])

    }

    
}
