//
//  ServicesView.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/8/21.
//

import UIKit

class ServicesView: UIView {

    lazy var searchField: UITextField = {
        let textfield = UITextField()
        textfield.background = UIImage(named: "back_search")!
        textfield.frame = CGRect(x: 30, y: 5, width: UIScreen.main.bounds.size.width - 60, height: 50)
        textfield.borderStyle = .none
        
        return textfield
    }()
    
    lazy var tab1: UILabel = {
        let title = UILabel()
        title.text = "Активные"
        title.numberOfLines = 0
        title.textColor = .black
        title.font = UIFont.preferredFont(forTextStyle: .subheadline)
        title.font = UIFont.boldSystemFont(ofSize: 19)
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
        title.text = "Доступные"
        title.numberOfLines = 0
        title.textColor = .gray
        title.font = UIFont.preferredFont(forTextStyle: .subheadline)
        title.font = UIFont.boldSystemFont(ofSize: 19)
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
        backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
       
        white_view_back = UIView(frame: CGRect(x: 0, y: 115, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        white_view_back.backgroundColor = .white
        
        self.addSubview(white_view_back)
        self.sendSubviewToBack(white_view_back)
     
        self.addSubview(searchField)
        self.addSubview(tab1)
        self.addSubview(tab2)
        self.addSubview(tab1Line)
        self.addSubview(tab2Line)

    }
}
