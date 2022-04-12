//
//  ZeroHelpView.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/29/21.
//

import UIKit

class ZeroHelpView: UIView {

    lazy var image_banner: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "zero_mini")
        image.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 160)
        return image
    }()
    
    lazy var titleOne: UILabel = {
        let titleOne = UILabel()
        titleOne.text = "Баланс и пакеты"
        titleOne.numberOfLines = 0
        titleOne.textColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1)
        titleOne.font = UIFont(name: "", size: 10)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .left
        titleOne.frame = CGRect(x: 20, y: 170, width: 300, height: 28)
        titleOne.autoresizesSubviews = true
        titleOne.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return titleOne
    }()
    
    lazy var balance: UILabel = {
        let user_name = UILabel()
        user_name.text = "45 somoni"
        user_name.numberOfLines = 0
        user_name.textColor = .black
        user_name.font = UIFont.preferredFont(forTextStyle: .subheadline)
        user_name.font = UIFont.boldSystemFont(ofSize: 24)
        user_name.lineBreakMode = NSLineBreakMode.byWordWrapping
        user_name.textAlignment = .right
        user_name.frame = CGRect(x: UIScreen.main.bounds.size.width - 220, y: 170, width: 200, height: 28)
        user_name.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return user_name
    }()
    
    let image: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Call_usage")
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .clear
        iv.frame = CGRect(x: 20, y: 10, width: 25, height: 25)
        return iv
    }()
    
    lazy var title1: UILabel = {
        let title = UILabel()
        title.text = "Расходы за 3 месяца (сомони)"
        title.numberOfLines = 1
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 14)
        title.textAlignment = .left
        title.frame = CGRect(x: 60, y: 0, width: (title.text!.count * 15), height: 45)
        
        return title
    }()
    
    lazy var rez1: UILabel = {
        let title = UILabel()
        title.text = "23"
        title.numberOfLines = 1
        title.textColor = .orange
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.textAlignment = .right
        title.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (title.text!.count * 15) - 50, y: 0, width: (title.text!.count * 15), height: 45)
        
        return title
    }()
    
    lazy var Line1: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 20, y: 45, width: UIScreen.main.bounds.size.width - 70, height: 2)
        title.backgroundColor = UIColor(red: 0.925, green: 0.925, blue: 0.925, alpha: 1)
        return title
    }()
    
    let image2: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "zet")
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .clear
        iv.frame = CGRect(x: 20, y: 57, width: 25, height: 25)
        return iv
    }()
    
    lazy var title2: UILabel = {
        let title = UILabel()
        title.text = "Дней внутри сети"
        title.numberOfLines = 1
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 14)
        title.textAlignment = .left
        title.frame = CGRect(x: 60, y: 47, width: (title.text!.count * 15), height: 45)
        
        return title
    }()
    
    lazy var rez2: UILabel = {
        let title = UILabel()
        title.text = "23"
        title.numberOfLines = 1
        title.textColor = .orange
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.textAlignment = .right
        title.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (title.text!.count * 15) - 50, y: 47, width: (title.text!.count * 15), height: 45)
        
        return title
    }()
    
    lazy var Line2: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 20, y: 92, width: UIScreen.main.bounds.size.width - 70, height: 2)
        title.backgroundColor = UIColor(red: 0.925, green: 0.925, blue: 0.925, alpha: 1)
        return title
    }()
    
    
    
    lazy var tab1: UILabel = {
        let title = UILabel()
        title.text = "Новый пакет"
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
        title.text = "История запросов"
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
    
    let white_view_back = UIView(frame: CGRect(x: 20, y: 210, width: UIScreen.main.bounds.size.width - 40, height: 100))

    
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
        
        white_view_back.backgroundColor = .white
        white_view_back.layer.cornerRadius = 20
        white_view_back.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08).cgColor
        white_view_back.layer.shadowOpacity = 1
        white_view_back.layer.shadowOffset = .zero
        white_view_back.layer.shadowRadius = 10
        
        white_view_back.addSubview(image)
        white_view_back.addSubview(title1)
        white_view_back.addSubview(Line1)
        white_view_back.addSubview(rez1)
        
        white_view_back.addSubview(image2)
        white_view_back.addSubview(title2)
        //white_view_back.addSubview(Line2)
        white_view_back.addSubview(rez2)
        
        self.addSubview(white_view_back)
       
        let white_view_back2 = UIView(frame: CGRect(x: 0, y: 260, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        white_view_back2.backgroundColor = .white
        self.addSubview(white_view_back2)
        self.sendSubviewToBack(white_view_back2)
        
        self.addSubview(image_banner)
        self.addSubview(titleOne)
        self.addSubview(balance)
        self.addSubview(tab1)
        self.addSubview(tab2)
        self.addSubview(tab1Line)
        self.addSubview(tab2Line)
    }

}

