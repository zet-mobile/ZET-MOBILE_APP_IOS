//
//  UsageView.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/10/21.
//

import UIKit

class UsageView: UIView {
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer

    lazy var tab1: UILabel = {
        let title = UILabel()
        title.text = defaultLocalizer.stringForKey(key: "Yesterday")
        title.numberOfLines = 0
        title.textColor = colorBlackWhite
        title.font = UIFont.preferredFont(forTextStyle: .subheadline)
        title.font = UIFont.systemFont(ofSize: 19)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: 20, y: 10, width: 80, height: 50)
        return title
    }()
    
    lazy var tab1Line: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 20, y: 60, width: 70, height: 2)
        title.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
        return title
    }()
    
    lazy var tab2: UILabel = {
        let title = UILabel()
        title.text = defaultLocalizer.stringForKey(key: "Aweek")
        title.numberOfLines = 0
        title.textColor = .gray
        title.font = UIFont.preferredFont(forTextStyle: .subheadline)
        title.font = UIFont.systemFont(ofSize: 19)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: tab1.frame.size.width + 10, y: 10, width: 80, height: 50)
            
        return title
    }()
    
    lazy var tab2Line: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: tab1.frame.size.width + 10, y: 60, width: 70, height: 2)
        title.backgroundColor = .clear
        return title
    }()
    
    lazy var tab3: UILabel = {
        let title = UILabel()
        title.text = defaultLocalizer.stringForKey(key: "Month")
        title.numberOfLines = 0
        title.textColor = .gray
        title.font = UIFont.preferredFont(forTextStyle: .subheadline)
        title.font = UIFont.systemFont(ofSize: 19)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: (tab1.frame.size.width + 10) * 2, y: 10, width: 80, height: 50)
            
        return title
    }()
    
    lazy var tab3Line: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: (tab1.frame.size.width + 10) * 2, y: 60, width: 70, height: 2)
        title.backgroundColor = .clear
        return title
    }()

    lazy var get_Detaization: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "button"), for: UIControl.State.normal)
        
        button.frame = CGRect(x: 5, y: 350, width: UIScreen.main.bounds.size.width - 10, height: 45)
        //openmenu.addTarget(self, action: #selector(goback), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    lazy var titleTable: UILabel = {
        let title = UILabel()
        title.text = defaultLocalizer.stringForKey(key: "History_of_expenses")
        title.numberOfLines = 0
        title.textColor = colorBlackWhite
        title.font = UIFont.preferredFont(forTextStyle: .subheadline)
        title.font = UIFont.boldSystemFont(ofSize: 19)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: 20, y: 440, width: 200, height: 30)
            
        return title
    }()
    var white_view_back = UIView()
    
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
     
        white_view_back = UIView(frame: CGRect(x: 0, y: 420, width: UIScreen.main.bounds.size.width, height: 650))
        white_view_back.backgroundColor = contentColor
        
        self.addSubview(white_view_back)
        self.sendSubviewToBack(white_view_back)
        
        self.addSubview(tab1)
        self.addSubview(tab2)
        self.addSubview(tab3)
        self.addSubview(tab1Line)
        self.addSubview(tab2Line)
        self.addSubview(tab3Line)
        self.addSubview(get_Detaization)
        self.addSubview(titleTable)

    }
}
