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
        title.frame = CGRect(x: 20, y: 360, width: 200, height: 28)
        
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
        title.frame = CGRect(x: 20, y: 530, width: 300, height: 28)
        
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
        title.frame = CGRect(x: 20, y: 730, width: 300, height: 28)
        
        return title
    }()
    
    lazy var icon_more: UIButton = {
        let icon_more = UIButton()
        //icon_more.setImage(#imageLiteral(resourceName: "View_all"), for: UIControl.State.normal)
        icon_more.backgroundColor = .clear
        icon_more.frame = CGRect(x: 20, y: 680, width: 200, height: 20)
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
        icon_more.frame = CGRect(x: 20, y: 780 + (3 * 130), width: 200, height: 20)
        icon_more.contentHorizontalAlignment = .left
        icon_more.setTitle(defaultLocalizer.stringForKey(key: "all_services"), for: .normal)
        icon_more.setTitleColor(.orange, for: .normal)
        icon_more.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        //openmenu.addTarget(self, action: #selector(goback), for: UIControl.Event.touchUpInside)
        return icon_more
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
        backgroundColor = .clear
        
        let gray_view_back = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 80))
        gray_view_back.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
        
        let white_view_back = UIView(frame: CGRect(x: 0, y: 80, width: UIScreen.main.bounds.size.width, height: 440))
        white_view_back.backgroundColor = .white
        
        let white_view_back2 = UIView(frame: CGRect(x: 0, y: 710, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        white_view_back2.backgroundColor = .white
        
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
    }
}
