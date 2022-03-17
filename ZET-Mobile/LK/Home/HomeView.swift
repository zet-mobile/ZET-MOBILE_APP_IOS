//
//  BalanceView.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/2/21.
//
import Foundation
import UIKit

class HomeView: UIView {
    
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    lazy var titleOne: UILabel = {
        let title = UILabel()
        title.text = "Быстрые услуги"
        title.numberOfLines = 0
        title.textColor = .black
        title.font = UIFont.preferredFont(forTextStyle: .subheadline)
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: 20, y: 0, width: 200, height: 28)
        
        return title
    }()

    lazy var titleTwo: UILabel = {
        let title = UILabel()
        title.text = "Специальные предложения"
        title.numberOfLines = 0
        title.textColor = .black
        title.font = UIFont.preferredFont(forTextStyle: .subheadline)
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: 20, y: 170, width: 300, height: 28)
        
        return title
    }()
    
    lazy var titleThree: UILabel = {
        let title = UILabel()
        title.text = defaultLocalizer.stringForKey(key: "services_title")
        title.numberOfLines = 0
        title.textColor = .black
        title.font = UIFont.preferredFont(forTextStyle: .subheadline)
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: 20, y: 370, width: 300, height: 28)
        
        return title
    }()
    
    lazy var icon_more: UIButton = {
        let icon_more = UIButton()
        //icon_more.setImage(#imageLiteral(resourceName: "View_all"), for: UIControl.State.normal)
        icon_more.backgroundColor = .clear
        icon_more.frame = CGRect(x: 20, y: 320, width: 200, height: 20)
        icon_more.contentHorizontalAlignment = .left
        icon_more.setTitle(defaultLocalizer.stringForKey(key: "view_all"), for: .normal)
        icon_more.setTitleColor(.orange, for: .normal)
        icon_more.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        //openmenu.addTarget(self, action: #selector(goback), for: UIControl.Event.touchUpInside)
        return icon_more
    }()
    
    lazy var icon_more_services: UIButton = {
        let icon_more = UIButton()
        //icon_more.setImage(#imageLiteral(resourceName: "icon_more_services"), for: UIControl.State.normal)
        icon_more.backgroundColor = .clear
        icon_more.frame = CGRect(x: 20, y: 1800, width: 200, height: 20)
        icon_more.contentHorizontalAlignment = .left
        icon_more.setTitle(defaultLocalizer.stringForKey(key: "all_services"), for: .normal)
        icon_more.setTitleColor(.orange, for: .normal)
        icon_more.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        //openmenu.addTarget(self, action: #selector(goback), for: UIControl.Event.touchUpInside)
        return icon_more
    }()
    
    var zero_help_view = UIView()
    
    lazy var zetImage: UIImageView = {
        let zetImage = UIImageView()
        zetImage.image = nil
        zetImage.image = UIImage(named: "image_user")
        zetImage.frame = CGRect(x: 10, y: 20, width: 48, height: 48)
        
        //let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(zetClick))
        zetImage.isUserInteractionEnabled = true
        //zetImage.addGestureRecognizer(tapGestureRecognizer)
        
        return zetImage
    }()
    
    lazy var title_help: UILabel = {
        let title = UILabel()
        title.text = "Помощь при нуле"
        title.numberOfLines = 0
        title.textColor = .black
        title.font = UIFont.preferredFont(forTextStyle: .subheadline)
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: 70, y: 10, width: 200, height: 28)
        
        return title
    }()
    
    lazy var title_help_desc: UILabel = {
        let title = UILabel()
        title.text = "У вас имеется неоплаченный пакет"
        title.numberOfLines = 2
        title.textColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00)
        title.font = UIFont.systemFont(ofSize: 15)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: 70, y: 40, width: 200, height: 20)
        title.autoresizesSubviews = true
        title.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return title
    }()
    
    lazy var title_help_price: UILabel = {
        let title = UILabel()
        title.text = "54 сомони"
        title.numberOfLines = 0
        title.textColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00)
        title.font = UIFont.systemFont(ofSize: 16)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: 70, y: 90, width: 300, height: 30)
        title.autoresizesSubviews = true
        title.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return title
    }()
    
    lazy var popolnit: UIButton = {
        let popolnit = UIButton()
        //popolnit.setImage(#imageLiteral(resourceName: "Popolnit"), for: UIControl.State.normal)
        popolnit.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
        popolnit.setTitle("Оплатить", for: .normal)
        popolnit.setTitleColor(.white, for: .normal)
        popolnit.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        popolnit.frame = CGRect(x: UIScreen.main.bounds.size.width - 180, y: 90, width: 120, height: 30)
        popolnit.layer.cornerRadius = popolnit.frame.height / 2
        //popolnit.addTarget(self, action: #selector(addBalanceOption), for: UIControl.Event.touchUpInside)
        return popolnit
    }()
    
    var white_view_back = UIView()
    var white_view_back2 = UIView()
    
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
        
        let gray_view_back = UIView(frame: CGRect(x: 0, y: -360, width: UIScreen.main.bounds.size.width, height: 80))
        gray_view_back.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
        
        white_view_back = UIView(frame: CGRect(x: 0, y: -280, width: UIScreen.main.bounds.size.width, height: 440))
        white_view_back.backgroundColor = .white
        
        white_view_back2 = UIView(frame: CGRect(x: 0, y: 350, width: UIScreen.main.bounds.size.width, height: 500))
        white_view_back2.backgroundColor = .white
        
        zero_help_view = UIView(frame: CGRect(x: 20, y: 20, width: UIScreen.main.bounds.size.width - 40, height: 130))
        zero_help_view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
        zero_help_view.isHidden = false
        zero_help_view.layer.cornerRadius = 10
        zero_help_view.addSubview(zetImage)
        zero_help_view.addSubview(title_help_desc)
        zero_help_view.addSubview(title_help)
        zero_help_view.addSubview(title_help_price)
        zero_help_view.addSubview(popolnit)
        
        self.addSubview(white_view_back)
        self.sendSubviewToBack(white_view_back)
        
        self.addSubview(white_view_back2)
        self.sendSubviewToBack(white_view_back2)
        
        self.addSubview(gray_view_back)
        self.sendSubviewToBack(gray_view_back)
        
        self.addSubview(titleOne)
        self.addSubview(titleTwo)
        self.addSubview(icon_more)
        self.addSubview(titleThree)
        self.addSubview(icon_more_services)
        self.addSubview(zero_help_view)
    }
}
