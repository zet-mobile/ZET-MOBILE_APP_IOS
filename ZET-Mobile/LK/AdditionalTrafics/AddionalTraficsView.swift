//
//  AddionalTraficsView.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/12/21.
//

import UIKit

class AddionalTraficsView: UIView {
    
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    lazy var balanceLabel: UILabel = {
        let balanceLabel = UILabel()
        balanceLabel.text = defaultLocalizer.stringForKey(key: "Your_balance")
        balanceLabel.numberOfLines = 0
        balanceLabel.textColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00)
        balanceLabel.font = UIFont(name: "", size: 10)
        balanceLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        balanceLabel.textAlignment = .left
    //    balanceLabel.frame = CGRect(x: 20, y: 160, width: 300, height: 28)
        balanceLabel.autoresizesSubviews = true
        balanceLabel.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return balanceLabel
    }()
    
    lazy var balanceValue: UILabel = {
        let balanceValue = UILabel()
        balanceValue.text = ""
        balanceValue.numberOfLines = 0
        balanceValue.textColor = colorBlackWhite
        balanceValue.font = UIFont.preferredFont(forTextStyle: .subheadline)
        balanceValue.font = UIFont.boldSystemFont(ofSize: 24)
        balanceValue.lineBreakMode = NSLineBreakMode.byWordWrapping
        balanceValue.textAlignment = .right
     //   balanceValue.frame = CGRect(x: UIScreen.main.bounds.size.width - 220, y: 160, width: 200, height: 28)
        balanceValue.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return balanceValue
    }()
    
    lazy var tab1: UILabel = {
        let title = UILabel()
        title.text = defaultLocalizer.stringForKey(key: "DATA")
        title.numberOfLines = 0
        title.textColor = .black
        title.font = UIFont.preferredFont(forTextStyle: .subheadline)
        title.font = UIFont.systemFont(ofSize: 17)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .center
        //title.frame = CGRect(x: 0, y: 550, width: UIScreen.main.bounds.size.width / 2, height: 50)
        return title
    }()
    
    lazy var tab1Line: UILabel = {
        let title = UILabel()
        //title.frame = CGRect(x: 20, y: 600, width: UIScreen.main.bounds.size.width / 2 - 20, height: 3)
        title.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
        return title
    }()
    
    lazy var tab2: UILabel = {
        let title = UILabel()
        title.text = defaultLocalizer.stringForKey(key: "Calls")
        title.numberOfLines = 0
        title.textColor = .gray
        title.font = UIFont.preferredFont(forTextStyle: .subheadline)
        title.font = UIFont.systemFont(ofSize: 17)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .center
        //title.frame = CGRect(x: UIScreen.main.bounds.size.width / 2 - 20, y: 550, width: UIScreen.main.bounds.size.width / 2 - 20, height: 50)
            
        return title
    }()
    
    lazy var tab2Line: UILabel = {
        let title = UILabel()
        //title.frame = CGRect(x: UIScreen.main.bounds.size.width / 2, y: 600, width: UIScreen.main.bounds.size.width / 2, height: 10)
        title.backgroundColor = .clear
        return title
    }()
    
    lazy var tab3: UILabel = {
        let title = UILabel()
        title.text = defaultLocalizer.stringForKey(key: "Messages")
        title.numberOfLines = 0
        title.textColor = .gray
        title.font = UIFont.preferredFont(forTextStyle: .subheadline)
        title.font = UIFont.systemFont(ofSize: 17)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .center
        //title.frame = CGRect(x: UIScreen.main.bounds.size.width / 2 - 20, y: 550, width: UIScreen.main.bounds.size.width / 2 - 20, height: 50)
            
        return title
    }()
    
    lazy var tab3Line: UILabel = {
        let title = UILabel()
        //title.frame = CGRect(x: UIScreen.main.bounds.size.width / 2, y: 600, width: UIScreen.main.bounds.size.width / 2, height: 10)
        title.backgroundColor = .clear
        return title
    }()
    
    lazy var unlimits: UIImageView = {
        let zetImage = UIImageView()
        zetImage.image = nil
        zetImage.image = UIImage(named: "VK_black")
        zetImage.frame = CGRect(x: 20, y: 400, width: 30, height: 30)
        
        //let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(zetClick))
        zetImage.isUserInteractionEnabled = true
        //zetImage.addGestureRecognizer(tapGestureRecognizer)
        
        return zetImage
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
       
        white_view_back = UIView(frame: CGRect(x: 0, y: 200, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        white_view_back.backgroundColor = contentColor
        
        self.addSubview(white_view_back)
        self.sendSubviewToBack(white_view_back)
        
        self.addSubview(balanceLabel)
        self.addSubview(balanceValue)
        self.addSubview(tab1)
        self.addSubview(tab2)
        self.addSubview(tab1Line)
        self.addSubview(tab2Line)
        self.addSubview(tab3)
        self.addSubview(tab3Line)
        //self.addSubview(unlimits)
    }
}
