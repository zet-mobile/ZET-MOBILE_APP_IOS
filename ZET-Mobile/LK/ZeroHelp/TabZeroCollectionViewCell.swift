//
//  TabZeroCollectionViewCell.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/29/21.
//

import UIKit

class TabZeroCollectionViewCell: UICollectionViewCell {
    
 /*   lazy var title_info: UILabel = {
        let title = UILabel()
        title.text = "Оставайтесь на связи даже при нулевом балансе"
        title.numberOfLines = 2
        title.textColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1)
        title.font = UIFont(name: "", size: 10)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: 20, y: 4 * 90 + 10, width: UIScreen.main.bounds.size.width - 40, height: 50)
        title.autoresizesSubviews = true
        title.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return title
    }()
    
    lazy var icon_more: UIButton = {
        let icon_more = UIButton()
        //icon_more.setImage(#imageLiteral(resourceName: "View_all"), for: UIControl.State.normal)
        icon_more.backgroundColor = .clear
        icon_more.frame = CGRect(x: 20, y: 4 * 90 + 70, width: 200, height: 20)
        icon_more.contentHorizontalAlignment = .left
        icon_more.setTitle("\(defaultLocalizer.stringForKey(key: "More_about_the_service"))  >", for: .normal)
        icon_more.setTitleColor(.orange, for: .normal)
        icon_more.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        //openmenu.addTarget(self, action: #selector(goback), for: UIControl.Event.touchUpInside)
        return icon_more
    }()*/
    
    lazy var title_info: UILabel = {
           let title = UILabel()
        title.text = defaultLocalizer.stringForKey(key: "unpaid_package")
        title.numberOfLines = 2
        title.textColor = .red
        title.font = UIFont.systemFont(ofSize: 15)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: 20, y: 10, width: UIScreen.main.bounds.size.width - 40, height: 40)
        title.autoresizesSubviews = true
        title.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return title
    }()
    
    lazy var type_paket: UILabel = {
        let title = UILabel()
        title.text = ""
        title.numberOfLines = 0
        title.textColor = colorBlackWhite
        title.font = UIFont.boldSystemFont(ofSize: 17)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: 20, y: 60, width: 300, height: 20)
        title.autoresizesSubviews = true
        title.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return title
    }()
    
    lazy var title_commission: UILabel = {
        let title = UILabel()
        title.text = ""
        title.numberOfLines = 0
        title.textColor = .orange
        title.font = UIFont(name: "", size: 9)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: 20, y: 80, width: 300, height: 20)
        title.autoresizesSubviews = true
        title.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return title
    }()
    
    lazy var summa: UILabel = {
        let title = UILabel()
        title.text = ""
        title.numberOfLines = 0
        title.textColor = .orange
        title.font = UIFont(name: "", size: 9)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: 20, y: 100, width: 300, height: 20)
        title.autoresizesSubviews = true
        title.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return title
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 20, y: 140, width: Int(UIScreen.main.bounds.size.width) - 40, height: 45))
        //ReconnectBut.setImage(#imageLiteral(resourceName: "connect"), for: UIControl.State.normal)
        //openmenu.addTarget(self, action: #selector(goback), for: UIControl.Event.touchUpInside)
        button.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
        button.setTitle(defaultLocalizer.stringForKey(key: "Pay_current2"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.layer.cornerRadius = button.frame.height / 2
        return button
    }()
    
    let whiteView_back = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 60 + (topPadding ?? 0) + (bottomPadding ?? 0)) - 260, width: UIScreen.main.bounds.size.width, height: 260))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        whiteView_back.backgroundColor = colorGrayWhite
        whiteView_back.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08).cgColor
        whiteView_back.layer.shadowOpacity = 1
        whiteView_back.layer.shadowOffset = .zero
        whiteView_back.layer.shadowRadius = 10
        whiteView_back.isHidden = true
        
        contentView.backgroundColor = .clear
        contentView.autoresizesSubviews = true
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.addSubview(whiteView_back)
        
        whiteView_back.addSubview(title_info)
        whiteView_back.addSubview(type_paket)
        whiteView_back.addSubview(title_commission)
        whiteView_back.addSubview(summa)
        whiteView_back.addSubview(sendButton)
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
