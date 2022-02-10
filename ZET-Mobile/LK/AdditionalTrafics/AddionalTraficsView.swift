//
//  AddionalTraficsView.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/12/21.
//

import UIKit

class AddionalTraficsView: UIView {
    
    lazy var title2: UILabel = {
        let title = UILabel()
        title.text = "Минут внутри сети"
        title.numberOfLines = 0
        title.textColor = .darkGray
        title.font = UIFont.preferredFont(forTextStyle: .subheadline)
        title.font = UIFont.systemFont(ofSize: 15)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: 20, y: 190, width: 150, height: 25)
        title.backgroundColor = .clear
        
        return title
    }()
    
    lazy var title2Line: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 170, y: 202, width: UIScreen.main.bounds.size.width - title2Res.frame.size.width - title2.frame.size.width - 40, height: 1)
        title.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
        return title
    }()
    
    lazy var title2Res: UILabel = {
        let title = UILabel()
        title.text = "150"
        title.numberOfLines = 0
        title.textColor = .darkGray
        title.font = UIFont.systemFont(ofSize: 15)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .right
        title.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (title.text!.count * 10 + 15), y: 190, width: title.text!.count * 10, height: 25)
        title.backgroundColor = .clear
        return title
    }()
    
    lazy var title3: UILabel = {
        let title = UILabel()
        title.text = "Минут на другие сети"
        title.numberOfLines = 0
        title.textColor = .darkGray
        title.font = UIFont.preferredFont(forTextStyle: .subheadline)
        title.font = UIFont.systemFont(ofSize: 15)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: 20, y: 220, width: 180, height: 25)
        
        return title
    }()
    
    lazy var title3Line: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 200, y: 232, width: UIScreen.main.bounds.size.width - title3Res.frame.size.width - title3.frame.size.width - 40, height: 1)
        title.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
        return title
    }()
    
    lazy var title3Res: UILabel = {
        let title = UILabel()
        title.text = "150"
        title.numberOfLines = 0
        title.textColor = .darkGray
        title.font = UIFont.systemFont(ofSize: 15)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .right
        title.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (title.text!.count * 10 + 15), y: 220, width: title.text!.count * 10, height: 25)
        title.backgroundColor = .clear
        return title
    }()
    
    lazy var title4: UILabel = {
        let title = UILabel()
        title.text = "Интернет (мб)"
        title.numberOfLines = 0
        title.textColor = .darkGray
        title.font = UIFont.preferredFont(forTextStyle: .subheadline)
        title.font = UIFont.systemFont(ofSize: 15)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: 20, y: 250, width: 100, height: 25)
        
        return title
    }()
    
    lazy var title4Line: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 120, y: 262, width: UIScreen.main.bounds.size.width - title4Res.frame.size.width - title4.frame.size.width - 40, height: 1)
        title.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
        return title
    }()
    
    lazy var title4Res: UILabel = {
        let title = UILabel()
        title.text = "4200"
        title.numberOfLines = 0
        title.textColor = .darkGray
        title.font = UIFont.systemFont(ofSize: 15)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .right
        title.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (title.text!.count * 10 + 15), y: 250, width: title.text!.count * 10, height: 25)
        title.backgroundColor = .clear
        return title
    }()
    
    lazy var title5: UILabel = {
        let title = UILabel()
        title.text = "SMS"
        title.numberOfLines = 0
        title.textColor = .darkGray
        title.font = UIFont.preferredFont(forTextStyle: .subheadline)
        title.font = UIFont.systemFont(ofSize: 15)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: 20, y: 280, width: 60, height: 25)
        
        return title
    }()
    
    lazy var title5Line: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 80, y: 292, width: UIScreen.main.bounds.size.width - title5Res.frame.size.width - title5.frame.size.width - 40, height: 1)
        title.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
        return title
    }()
    
    lazy var title5Res: UILabel = {
        let title = UILabel()
        title.text = "0.3c / 1 SMS"
        title.numberOfLines = 0
        title.textColor = .darkGray
        title.font = UIFont.systemFont(ofSize: 15)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .right
        title.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (title.text!.count * 10 + 15), y: 280, width: title.text!.count * 10, height: 25)
        title.backgroundColor = .clear
        return title
    }()
    
    lazy var title6: UILabel = {
        let title = UILabel()
        title.text = "Сумма за 30 дней (сомони)"
        title.numberOfLines = 0
        title.textColor = .darkGray
        title.font = UIFont.preferredFont(forTextStyle: .subheadline)
        title.font = UIFont.systemFont(ofSize: 15)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: 20, y: 310, width: 200, height: 25)
        
        return title
    }()
    
    lazy var title6Line: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 220, y: 322, width: UIScreen.main.bounds.size.width - title6Res.frame.size.width - title6.frame.size.width - 40, height: 1)
        title.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
        return title
    }()
    
    lazy var title6Res: UILabel = {
        let title = UILabel()
        title.text = "50"
        title.numberOfLines = 0
        title.textColor = .darkGray
        title.font = UIFont.systemFont(ofSize: 15)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .right
        title.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (title.text!.count * 10 + 15), y: 310, width: title.text!.count * 10, height: 25)
        title.backgroundColor = .clear
        return title
    }()
    
    lazy var tab1: UILabel = {
        let title = UILabel()
        title.text = "Интернет"
        title.numberOfLines = 0
        title.textColor = .black
        title.font = UIFont.preferredFont(forTextStyle: .subheadline)
        title.font = UIFont.boldSystemFont(ofSize: 17)
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
        title.text = "Звонки"
        title.numberOfLines = 0
        title.textColor = .gray
        title.font = UIFont.preferredFont(forTextStyle: .subheadline)
        title.font = UIFont.boldSystemFont(ofSize: 17)
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
        title.text = "Сообщения"
        title.numberOfLines = 0
        title.textColor = .gray
        title.font = UIFont.preferredFont(forTextStyle: .subheadline)
        title.font = UIFont.boldSystemFont(ofSize: 17)
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
    
    lazy var tab4: UILabel = {
        let title = UILabel()
        title.text = "Роуминг"
        title.numberOfLines = 0
        title.textColor = .gray
        title.font = UIFont.preferredFont(forTextStyle: .subheadline)
        title.font = UIFont.boldSystemFont(ofSize: 17)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .center
        //title.frame = CGRect(x: UIScreen.main.bounds.size.width / 2 - 20, y: 550, width: UIScreen.main.bounds.size.width / 2 - 20, height: 50)
            
        return title
    }()
    
    lazy var tab4Line: UILabel = {
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
        backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
       
        white_view_back = UIView(frame: CGRect(x: 0, y: 160, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        white_view_back.backgroundColor = .white
        
        self.addSubview(white_view_back)
        self.sendSubviewToBack(white_view_back)
        
        self.addSubview(title2)
        self.addSubview(title3)
        self.addSubview(title4)
        self.addSubview(title5)
        self.addSubview(title6)
        self.addSubview(tab1)
        self.addSubview(tab2)
        self.addSubview(tab1Line)
        self.addSubview(tab2Line)
        self.addSubview(tab3)
        self.addSubview(tab4)
        self.addSubview(tab3Line)
        self.addSubview(tab4Line)
        
        self.addSubview(title2Res)
        self.addSubview(title2Line)
        self.addSubview(title3Res)
        self.addSubview(title3Line)
        self.addSubview(title4Res)
        self.addSubview(title4Line)
        self.addSubview(title5Res)
        self.addSubview(title5Line)
        self.addSubview(title6Res)
        self.addSubview(title6Line)
        //self.addSubview(unlimits)
    }
}
