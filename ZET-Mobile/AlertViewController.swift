//
//  NetworkController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/13/21.
//

import UIKit

class AlertViewController: UIViewController {

    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    var alert_view = AlertView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alert_view.frame = CGRect(x: 40, y: 200, width: UIScreen.main.bounds.size.width - 80, height: 330)
        alert_view.layer.cornerRadius = 20
        view.addSubview(alert_view)
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }


}

class AlertView: UIView {
    
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    lazy var image_icon: UIImageView = {
        let image = UIImageView()
        image.image = nil
        image.image = UIImage(named: "image_user")
        image.frame = CGRect(x: UIScreen.main.bounds.size.width / 2 - 50, y: 52, width: 70, height: 70)
       
        return image
    }()
    
    lazy var name: UILabel = {
        let title = UILabel()
        title.text = "Добавить трафик"
        title.numberOfLines = 0
        title.textColor = colorBlackWhite
        title.font = UIFont.boldSystemFont(ofSize: 19)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .center
        title.frame = CGRect(x: 20, y: 144, width: UIScreen.main.bounds.size.width - 80, height: 25)
        return title
    }()
    
    lazy var name_content: UILabel = {
        let title = UILabel()
        title.text = "Подключить пакет Чаккон+ “30 Гб”?"
        title.numberOfLines = 4
        title.textColor = colorBlackWhite
        title.font = UIFont.systemFont(ofSize: 17)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .center
        title.frame = CGRect(x: 20, y: 188, width: UIScreen.main.bounds.size.width - 80, height: 60)
        return title
    }()
    
    lazy var ok: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 20, y: 275, width: UIScreen.main.bounds.size.width - 80, height: 45)
        button.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
        button.setTitle("Подключить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.layer.cornerRadius = button.frame.height / 2
        
        
        //openmenu.addTarget(self, action: #selector(goback), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    lazy var cancel: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "close_icon"), for: UIControl.State.normal)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.frame = CGRect(x: UIScreen.main.bounds.size.width - 80, y: 20, width: 24, height: 24)
        return button
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
        //backgroundColor = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? colorFrom1 : colorTo1)
        
        self.addSubview(name)
        self.addSubview(name_content)
        self.addSubview(image_icon)
        self.addSubview(ok)
        self.addSubview(cancel)

    }
}

class AlertView2: UIView {
    
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    lazy var image_icon: UIImageView = {
        let image = UIImageView()
        image.image = nil
        image.image = UIImage(named: "image_user")
        image.frame = CGRect(x: UIScreen.main.bounds.size.width / 2 - 70, y: 52, width: 70, height: 70)
       
        return image
    }()
    
    lazy var name: UILabel = {
        let title = UILabel()
        title.text = ""
        title.numberOfLines = 0
        title.textColor = colorBlackWhite
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .center
        title.frame = CGRect(x: 20, y: 144, width: UIScreen.main.bounds.size.width - 120, height: 25)
        return title
    }()
    
    lazy var value_title: UILabel = {
        let title = UILabel()
        title.text = defaultLocalizer.stringForKey(key: "Transfer")
        title.numberOfLines = 2
        title.font = UIFont.systemFont(ofSize: 16)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .center
        title.frame = CGRect(x: 20, y: 180, width: UIScreen.main.bounds.size.width - 120, height: 30)
        return title
    }()
    
    lazy var number_title: UILabel = {
        let title = UILabel()
        title.text = ""
        title.numberOfLines = 2
        title.font = UIFont.systemFont(ofSize: 16)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .center
        title.frame = CGRect(x: 20, y: 205, width: UIScreen.main.bounds.size.width - 120, height: 30)
        return title
    }()
  
    lazy var cost_title: UILabel = {
        let title = UILabel()
        title.text = ""
        title.numberOfLines = 1
        title.font = UIFont.systemFont(ofSize: 16)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .center
        title.frame = CGRect(x: 20, y: 240, width: UIScreen.main.bounds.size.width - 120, height: 30)
        return title
    }()
    
    lazy var ok: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 20, y: 300, width: UIScreen.main.bounds.size.width - 120, height: 45)
        button.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
        button.setTitle(defaultLocalizer.stringForKey(key: "Transfer2"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.layer.cornerRadius = button.frame.height / 2
        
        
        //openmenu.addTarget(self, action: #selector(goback), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    lazy var cancel: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "close_icon"), for: UIControl.State.normal)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.frame = CGRect(x: UIScreen.main.bounds.size.width - 120, y: 20, width: 24, height: 24)
        return button
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
        //backgroundColor = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? colorFrom1 : colorTo1)
        
        self.addSubview(name)
        self.addSubview(value_title)
        self.addSubview(number_title)
        self.addSubview(cost_title)
        self.addSubview(image_icon)
        self.addSubview(ok)
        self.addSubview(cancel)

    }
}

class AlertView3: UIView {
    
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    lazy var image_icon: UIImageView = {
        let image = UIImageView()
        image.image = nil
        image.image = UIImage(named: "image_user")
        image.frame = CGRect(x: UIScreen.main.bounds.size.width / 2 - 125, y: 52, width: 70, height: 70)
       
        return image
    }()
    
    lazy var symbol: UILabel = {
        let title = UILabel()
        title.text = ">>"
        title.numberOfLines = 0
        title.textColor = .orange
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .center
        title.frame = CGRect(x: UIScreen.main.bounds.size.width / 2 - 45, y: 70, width: 30, height: 40)
        return title
    }()
    
    lazy var image_icon2: UIImageView = {
        let image = UIImageView()
        image.image = nil
        image.image = UIImage(named: "image_user")
        image.frame = CGRect(x: UIScreen.main.bounds.size.width / 2 - 5, y: 52, width: 70, height: 70)
       
        return image
    }()
    
    lazy var name: UILabel = {
        let title = UILabel()
        title.text = ""
        title.numberOfLines = 0
        title.textColor = colorBlackWhite
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .center
        title.frame = CGRect(x: 20, y: 144, width: UIScreen.main.bounds.size.width - 120, height: 25)
        return title
    }()
    
    lazy var value_title: UILabel = {
        let title = UILabel()
        title.text = defaultLocalizer.stringForKey(key: "Transfer")
        title.numberOfLines = 1
        title.font = UIFont.systemFont(ofSize: 16)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .center
        title.frame = CGRect(x: 20, y: 180, width: UIScreen.main.bounds.size.width - 120, height: 30)
        return title
    }()
    
    lazy var number_title: UILabel = {
        let title = UILabel()
        title.text = ""
        title.numberOfLines = 1
        title.font = UIFont.systemFont(ofSize: 16)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .center
        title.frame = CGRect(x: 20, y: 205, width: UIScreen.main.bounds.size.width - 120, height: 30)
        return title
    }()
  
    lazy var cost_title: UILabel = {
        let title = UILabel()
        title.text = ""
        title.numberOfLines = 1
        title.font = UIFont.systemFont(ofSize: 16)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .center
        title.frame = CGRect(x: 20, y: 240, width: UIScreen.main.bounds.size.width - 120, height: 30)
        return title
    }()
    
    lazy var ok: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 20, y: 300, width: UIScreen.main.bounds.size.width - 120, height: 45)
        button.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
        button.setTitle(defaultLocalizer.stringForKey(key: "Transfer2"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.layer.cornerRadius = button.frame.height / 2
        
        
        //openmenu.addTarget(self, action: #selector(goback), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    lazy var cancel: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "close_icon"), for: UIControl.State.normal)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.frame = CGRect(x: UIScreen.main.bounds.size.width - 120, y: 20, width: 24, height: 24)
        return button
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
        //backgroundColor = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? colorFrom1 : colorTo1)
        
        self.addSubview(name)
        self.addSubview(value_title)
        self.addSubview(number_title)
        self.addSubview(cost_title)
        self.addSubview(image_icon)
        self.addSubview(image_icon2)
        self.addSubview(symbol)
        self.addSubview(ok)
        self.addSubview(cancel)

    }
}

class AlertView4: UIView {
    
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer

    lazy var name: UILabel = {
        let title = UILabel()
        title.text = defaultLocalizer.stringForKey(key: "FORGOT_PASSWORD?")
        title.numberOfLines = 0
        title.textColor = colorBlackWhite
        title.font = UIFont.boldSystemFont(ofSize: 20)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .center
        title.frame = CGRect(x: 20, y: 30, width: UIScreen.main.bounds.size.width - 80, height: 35)
        return title
    }()
    
    lazy var value_title: UILabel = {
        let title = UILabel()
        title.text = defaultLocalizer.stringForKey(key: "Пройдите регистрацию повторно по номеру телефона")
        title.numberOfLines = 3
        title.textColor = colorBlackWhite
        title.font = UIFont.systemFont(ofSize: 18)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .center
        title.frame = CGRect(x: 20, y: 60, width: UIScreen.main.bounds.size.width - 80, height: 80)
        return title
    }()

    lazy var ok: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 20, y: 150, width: UIScreen.main.bounds.size.width - 80, height: 45)
        button.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
        button.setTitle(defaultLocalizer.stringForKey(key: "Proceed"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.layer.cornerRadius = button.frame.height / 2
        
        
        //openmenu.addTarget(self, action: #selector(goback), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    lazy var cancel: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 20, y: 210, width: UIScreen.main.bounds.size.width - 80, height: 45)
        button.backgroundColor = .clear
        button.setTitle(defaultLocalizer.stringForKey(key: "Cancel"), for: .normal)
        button.setTitleColor(UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.layer.cornerRadius = button.frame.height / 2
        
        
        //openmenu.addTarget(self, action: #selector(goback), for: UIControl.Event.touchUpInside)
        return button
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
        //backgroundColor = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? colorFrom1 : colorTo1)
        
        self.addSubview(name)
        self.addSubview(value_title)
        self.addSubview(ok)
        self.addSubview(cancel)

    }
}

class AlertView5: UIView {
    
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer

    lazy var name: UILabel = {
        let title = UILabel()
        title.text = defaultLocalizer.stringForKey(key: "submit")
        title.numberOfLines = 0
        title.textColor = colorBlackWhite
        title.font = UIFont.boldSystemFont(ofSize: 20)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: 20, y: 30, width: UIScreen.main.bounds.size.width - 80, height: 35)
        return title
    }()
    
    lazy var value_title: UILabel = {
        let title = UILabel()
        title.text = defaultLocalizer.stringForKey(key: "confirm_exit")
        title.numberOfLines = 2
        title.textColor = colorBlackWhite
        title.font = UIFont.systemFont(ofSize: 18)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: 20, y: 60, width: UIScreen.main.bounds.size.width - 80, height: 80)
        return title
    }()

    lazy var ok: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle(defaultLocalizer.stringForKey(key: "Exit"), for: .normal)
        button.setTitleColor(UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
       // button.frame = CGRect(x: 20, y: 150, width: UIScreen.main.bounds.size.width - 80, height: 45)
        button.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - ((button.titleLabel?.text!.count)! * 12) - 80, y: 130, width: (button.titleLabel?.text!.count)! * 12, height: 45)
        //openmenu.addTarget(self, action: #selector(goback), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    lazy var cancel: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = .clear
        button.setTitle(defaultLocalizer.stringForKey(key: "Cancel"), for: .normal)
        button.setTitleColor(UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.layer.cornerRadius = button.frame.height / 2
        button.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - ((button.titleLabel?.text!.count)! * 12) - ((ok.titleLabel?.text!.count)! * 10) - 100, y: 130, width: (button.titleLabel?.text!.count)! * 12, height: 45)
        
        //openmenu.addTarget(self, action: #selector(goback), for: UIControl.Event.touchUpInside)
        return button
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
        //backgroundColor = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? colorFrom1 : colorTo1)
        
        self.addSubview(name)
        self.addSubview(value_title)
        self.addSubview(ok)
        self.addSubview(cancel)

    }
}
