//
//  TabRoumingCollectionCell.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 1/9/22.
//

import UIKit

class TabRoumingCollectionCell: UICollectionViewCell {
    
    lazy var titleOne: UILabel = {
        let titleOne = UILabel()
        titleOne.text = "Выберите страну"
        titleOne.numberOfLines = 0
        titleOne.textColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00)
        titleOne.font = UIFont.systemFont(ofSize: 16)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .left
        titleOne.frame = CGRect(x: 20, y: 20, width: 300, height: 20)
        titleOne.autoresizesSubviews = true
        titleOne.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return titleOne
    }()
    
    lazy var country: UITextField = {
        let textfield = UITextField()
        textfield.frame = CGRect(x: 20, y: 50, width: UIScreen.main.bounds.size.width - 40, height: 50)
        textfield.layer.cornerRadius = 16
        textfield.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        textfield.layer.borderWidth = 1
        textfield.setView(.right, image: UIImage(named: "drop_icon"))
        return textfield
    }()
    
    lazy var titleTwo: UILabel = {
        let titleOne = UILabel()
        titleOne.text = "Гостевой оператор"
        titleOne.numberOfLines = 0
        titleOne.textColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00)
        titleOne.font = UIFont.systemFont(ofSize: 16)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .left
        titleOne.frame = CGRect(x: 20, y: 140, width: 300, height: 20)
        titleOne.autoresizesSubviews = true
        titleOne.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return titleOne
    }()
    
    lazy var operator_type: UITextField = {
        let textfield = UITextField()
        textfield.frame = CGRect(x: 20, y: 170, width: UIScreen.main.bounds.size.width - 40, height: 50)
        textfield.layer.cornerRadius = 16
        textfield.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        textfield.layer.borderWidth = 1
        textfield.setView(.right, image: UIImage(named: "drop_icon"))
        return textfield
    }()
    
    lazy var title2: UILabel = {
        let title = UILabel()
        title.text = "Входящие звонки"
        title.numberOfLines = 0
        title.textColor = .black
        title.font = UIFont.preferredFont(forTextStyle: .subheadline)
        title.font = UIFont.systemFont(ofSize: 15)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: 20, y: 250, width: 140, height: 25)
        title.backgroundColor = .clear
        
        return title
    }()
    
    lazy var title2Line: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 160, y: 262, width: UIScreen.main.bounds.size.width - title2Res.frame.size.width - title2.frame.size.width - 40, height: 1)
        title.backgroundColor = .lightGray
        return title
    }()
    
    lazy var title2Res: UILabel = {
        let title = UILabel()
        title.text = "150"
        title.numberOfLines = 0
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 15)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .right
        title.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (title.text!.count * 10 + 15), y: 250, width: title.text!.count * 10, height: 25)
        title.backgroundColor = .clear
        return title
    }()
    
    lazy var title3: UILabel = {
        let title = UILabel()
        title.text = "Входящие SMS"
        title.numberOfLines = 0
        title.textColor = .black
        title.font = UIFont.preferredFont(forTextStyle: .subheadline)
        title.font = UIFont.systemFont(ofSize: 15)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: 20, y: 290, width: 130, height: 25)
        title.backgroundColor = .clear
        
        return title
    }()
    
    lazy var title3Line: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 150, y: 302, width: UIScreen.main.bounds.size.width - title3Res.frame.size.width - title3.frame.size.width - 40, height: 1)
        title.backgroundColor = .lightGray
        return title
    }()
    
    lazy var title3Res: UILabel = {
        let title = UILabel()
        title.text = "150"
        title.numberOfLines = 0
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 15)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .right
        title.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (title.text!.count * 10 + 15), y: 290, width: title.text!.count * 10, height: 25)
        title.backgroundColor = .clear
        return title
    }()
    
    lazy var title4: UILabel = {
        let title = UILabel()
        title.text = "Исходящие звонки"
        title.numberOfLines = 0
        title.textColor = .black
        title.font = UIFont.preferredFont(forTextStyle: .subheadline)
        title.font = UIFont.systemFont(ofSize: 15)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: 20, y: 330, width: 130, height: 25)
        title.backgroundColor = .clear
        
        return title
    }()
    
    lazy var title4Line: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 150, y: 342, width: UIScreen.main.bounds.size.width - title4Res.frame.size.width - title4.frame.size.width - 40, height: 1)
        title.backgroundColor = .lightGray
        return title
    }()
    
    lazy var title4Res: UILabel = {
        let title = UILabel()
        title.text = "150"
        title.numberOfLines = 0
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 15)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .right
        title.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (title.text!.count * 10 + 15), y: 330, width: title.text!.count * 10, height: 25)
        title.backgroundColor = .clear
        return title
    }()
    
    lazy var title5: UILabel = {
        let title = UILabel()
        title.text = "Исходящие SMS"
        title.numberOfLines = 0
        title.textColor = .black
        title.font = UIFont.preferredFont(forTextStyle: .subheadline)
        title.font = UIFont.systemFont(ofSize: 15)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: 20, y: 370, width: 130, height: 25)
        title.backgroundColor = .clear
        
        return title
    }()
    
    lazy var title5Line: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 150, y: 382, width: UIScreen.main.bounds.size.width - title5Res.frame.size.width - title5.frame.size.width - 40, height: 1)
        title.backgroundColor = .lightGray
        return title
    }()
    
    lazy var title5Res: UILabel = {
        let title = UILabel()
        title.text = "150"
        title.numberOfLines = 0
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 15)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .right
        title.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (title.text!.count * 10 + 15), y: 370, width: title.text!.count * 10, height: 25)
        title.backgroundColor = .clear
        return title
    }()
    
    lazy var title6: UILabel = {
        let title = UILabel()
        title.text = "Интернет"
        title.numberOfLines = 0
        title.textColor = .black
        title.font = UIFont.preferredFont(forTextStyle: .subheadline)
        title.font = UIFont.systemFont(ofSize: 15)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: 20, y: 410, width: 100, height: 25)
        title.backgroundColor = .clear
        
        return title
    }()
    
    lazy var title6Line: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 120, y: 422, width: UIScreen.main.bounds.size.width - title6Res.frame.size.width - title6.frame.size.width - 40, height: 1)
        title.backgroundColor = .lightGray
        return title
    }()
    
    lazy var title6Res: UILabel = {
        let title = UILabel()
        title.text = "150"
        title.numberOfLines = 0
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 15)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .right
        title.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (title.text!.count * 10 + 15), y: 410, width: title.text!.count * 10, height: 25)
        title.backgroundColor = .clear
        return title
    }()
    
    lazy var title7: UILabel = {
        let title = UILabel()
        title.text = "Интернет 4G"
        title.numberOfLines = 0
        title.textColor = .black
        title.font = UIFont.preferredFont(forTextStyle: .subheadline)
        title.font = UIFont.systemFont(ofSize: 15)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: 20, y: 450, width: 100, height: 25)
        title.backgroundColor = .clear
        
        return title
    }()
    
    lazy var title7Line: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 120, y: 462, width: UIScreen.main.bounds.size.width - title7Res.frame.size.width - title7.frame.size.width - 40, height: 1)
        title.backgroundColor = .lightGray
        return title
    }()
    
    lazy var title7Res: UILabel = {
        let title = UILabel()
        title.text = "150"
        title.numberOfLines = 0
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 15)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .right
        title.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (title.text!.count * 10 + 15), y: 450, width: title.text!.count * 10, height: 25)
        title.backgroundColor = .clear
        return title
    }()
    
    lazy var title8: UILabel = {
        let title = UILabel()
        title.text = "Спутниковый вызов"
        title.numberOfLines = 0
        title.textColor = .black
        title.font = UIFont.preferredFont(forTextStyle: .subheadline)
        title.font = UIFont.systemFont(ofSize: 15)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: 20, y: 490, width: 150, height: 25)
        title.backgroundColor = .clear
        
        return title
    }()
    
    lazy var title8Line: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 170, y: 502, width: UIScreen.main.bounds.size.width - title8Res.frame.size.width - title8.frame.size.width - 40, height: 1)
        title.backgroundColor = .lightGray
        return title
    }()
    
    lazy var title8Res: UILabel = {
        let title = UILabel()
        title.text = "150"
        title.numberOfLines = 0
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 15)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .right
        title.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (title.text!.count * 10 + 15), y: 490, width: title.text!.count * 10, height: 25)
        title.backgroundColor = .clear
        return title
    }()
    
    lazy var title9: UILabel = {
        let title = UILabel()
        title.text = "PAYG тарификация"
        title.numberOfLines = 0
        title.textColor = .black
        title.font = UIFont.preferredFont(forTextStyle: .subheadline)
        title.font = UIFont.systemFont(ofSize: 15)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: 20, y: 530, width: 150, height: 25)
        title.backgroundColor = .clear
        
        return title
    }()
    
    lazy var title9Line: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 170, y: 542, width: UIScreen.main.bounds.size.width - title9Res.frame.size.width - title9.frame.size.width - 40, height: 1)
        title.backgroundColor = .lightGray
        return title
    }()
    
    lazy var title9Res: UILabel = {
        let title = UILabel()
        title.text = "150"
        title.numberOfLines = 0
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 15)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .right
        title.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (title.text!.count * 10 + 15), y: 530, width: title.text!.count * 10, height: 25)
        title.backgroundColor = .clear
        return title
    }()
    
    lazy var opisanie: UILabel = {
        let titleOne = UILabel()
        titleOne.text = """
        Все цены указаны в национальной валюте сомони с учетом акциза 5% и НДС 18%

        Все звонки тарифицируются поминутно.
        """
        titleOne.numberOfLines = 0
        titleOne.textColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1)
        titleOne.font = UIFont(name: "", size: 10)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .left
        titleOne.frame = CGRect(x: 20, y: 580, width: UIScreen.main.bounds.size.width - 40, height: 100)
        titleOne.autoresizesSubviews = true
        titleOne.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return titleOne
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .clear
        contentView.autoresizesSubviews = true
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.addSubview(titleOne)
        contentView.addSubview(titleTwo)
        contentView.addSubview(operator_type)
        contentView.addSubview(country)
        
        contentView.addSubview(title2)
        contentView.addSubview(title2Line)
        contentView.addSubview(title2Res)
        contentView.addSubview(title3)
        contentView.addSubview(title3Line)
        contentView.addSubview(title3Res)
        contentView.addSubview(title4)
        contentView.addSubview(title4Line)
        contentView.addSubview(title4Res)
        contentView.addSubview(title5)
        contentView.addSubview(title5Line)
        contentView.addSubview(title5Res)
        contentView.addSubview(title6)
        contentView.addSubview(title6Line)
        contentView.addSubview(title6Res)
        contentView.addSubview(title7)
        contentView.addSubview(title7Line)
        contentView.addSubview(title7Res)
        contentView.addSubview(title8)
        contentView.addSubview(title8Line)
        contentView.addSubview(title8Res)
        contentView.addSubview(title9)
        contentView.addSubview(title9Line)
        contentView.addSubview(title9Res)
        
        contentView.addSubview(opisanie)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
