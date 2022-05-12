//
//  SearchNumberView.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 12/10/21.
//

import UIKit

class SearchNumberView: UIView {

    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    lazy var searchField: UITextField = {
        let textfield = UITextField()
        textfield.frame = CGRect(x: 20, y: 5, width: UIScreen.main.bounds.size.width - 40, height: 50)
        textfield.borderStyle = .none
        textfield.backgroundColor = contentColor
        textfield.layer.cornerRadius = 20
        textfield.setView(.left, image: UIImage(named: "Search"))
        return textfield
    }()
    
    let image: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "search_banner")
        iv.contentMode = .scaleToFill
        iv.backgroundColor = .clear
        iv.autoresizesSubviews = true
        
        iv.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return iv
    }()
    
    lazy var titleOne: UILabel = {
        let titleOne = UILabel()
        titleOne.text = "Текущий номер"
        titleOne.numberOfLines = 0
        titleOne.textColor = .white
        titleOne.font = UIFont.systemFont(ofSize: 16)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .left
        titleOne.frame = CGRect(x: 30, y: 90, width: 300, height: 20)
        titleOne.autoresizesSubviews = true
        titleOne.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return titleOne
    }()
    
    lazy var number: UILabel = {
        let label = UILabel()
        label.text = "+992 91 111 0611"
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.textAlignment = .left
        label.frame = CGRect(x: 30, y: 120, width: 200, height: 28)
        label.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return label
    }()
    
    // bottom view
    lazy var title_info: UILabel = {
        let title = UILabel()
        title.text = defaultLocalizer.stringForKey(key: "Selected_number")
        title.numberOfLines = 1
        title.textColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1)
        title.font = UIFont(name: "", size: 10)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: 20, y: 10, width: UIScreen.main.bounds.size.width - 40, height: 50)
        title.autoresizesSubviews = true
        title.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return title
    }()
    
    
    lazy var type_paket: UILabel = {
        let title = UILabel()
        title.text = "+992 91 111 0611"
        title.numberOfLines = 0
        title.textColor = colorBlackWhite
        title.font = UIFont.boldSystemFont(ofSize: 20)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: 80, y: 70, width: 300, height: 20)
        title.autoresizesSubviews = true
        title.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return title
    }()
    
    lazy var summa: UILabel = {
        let title = UILabel()
        title.text = "Итого: 0.2 сомони"
        title.numberOfLines = 0
        title.textColor = .orange
        title.font = UIFont(name: "", size: 9)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: 20, y: 110, width: 300, height: 20)
        title.autoresizesSubviews = true
        title.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return title
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 20, y: 150, width: Int(UIScreen.main.bounds.size.width) - 40, height: 45))
        //ReconnectBut.setImage(#imageLiteral(resourceName: "connect"), for: UIControl.State.normal)
        //openmenu.addTarget(self, action: #selector(goback), for: UIControl.Event.touchUpInside)
        button.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
        button.setTitle(defaultLocalizer.stringForKey(key: "Connect"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.layer.cornerRadius = button.frame.height / 2
        return button
    }()
    
    lazy var getButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 20, y: 215, width: Int(UIScreen.main.bounds.size.width) - 40, height: 45))
        //ReconnectBut.setImage(#imageLiteral(resourceName: "connect"), for: UIControl.State.normal)
        //openmenu.addTarget(self, action: #selector(goback), for: UIControl.Event.touchUpInside)
        button.backgroundColor = .clear
        button.setTitle(defaultLocalizer.stringForKey(key: "Connect_service"), for: .normal)
        button.setTitleColor(.orange, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.layer.cornerRadius = button.frame.height / 2
        return button
    }()
    
    let bottom_view = UIView(frame: CGRect(x: 0, y: 5 * 80 + 240, width: UIScreen.main.bounds.size.width, height: 260))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        
    }
    
    private func setupView() {
        backgroundColor = .clear

        image.frame = CGRect(x: 20, y: 80, width: self.frame.size.width - 40, height: 120)
        self.addSubview(image)
        self.sendSubviewToBack(image)
        
        let white_view_back = UIView(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.size.width, height: 550))
        white_view_back.backgroundColor = contentColor
        
        self.addSubview(white_view_back)
        self.sendSubviewToBack(white_view_back)
        
        bottom_view.backgroundColor = contentColor
        bottom_view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08).cgColor
        bottom_view.layer.shadowOpacity = 1
        bottom_view.layer.shadowOffset = .zero
        bottom_view.layer.shadowRadius = 10
        
        self.bottom_view.addSubview(title_info)
        self.bottom_view.addSubview(type_paket)
        self.bottom_view.addSubview(summa)
        self.bottom_view.addSubview(sendButton)
        self.bottom_view.addSubview(getButton)
        
        self.addSubview(bottom_view)
        self.addSubview(searchField)
        self.addSubview(number)
        self.addSubview(titleOne)
        //self.addSubview(titleThree)
        //self.addSubview(icon_more_services)
    }
}
