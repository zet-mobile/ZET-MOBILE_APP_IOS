//
//  NetworkController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/13/21.
//

import UIKit

class AlertViewController: UIViewController {

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
    
    lazy var image_icon: UIImageView = {
        let image = UIImageView()
        image.image = nil
        image.image = UIImage(named: "image_user")
        image.frame = CGRect(x: UIScreen.main.bounds.size.width / 2 - 70, y: 52, width: 70, height: 70)
       
        return image
    }()
    
    lazy var name: UILabel = {
        let title = UILabel()
        title.text = "Добавить трафик"
        title.numberOfLines = 0
        title.textColor = .black
        title.font = UIFont.boldSystemFont(ofSize: 19)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .center
        title.frame = CGRect(x: 20, y: 144, width: UIScreen.main.bounds.size.width - 120, height: 25)
        return title
    }()
    
    lazy var name_content: UILabel = {
        let title = UILabel()
        title.text = "Подключить пакет Чаккон+ “30 Гб”?"
        title.numberOfLines = 2
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 17)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .center
        title.frame = CGRect(x: UIScreen.main.bounds.size.width / 2 - 125, y: 188, width: 170, height: 44)
        return title
    }()
    
    lazy var ok: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "connect"), for: UIControl.State.normal)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        
        button.frame = CGRect(x: 20, y: 249, width: UIScreen.main.bounds.size.width - 120, height: 45)
        //openmenu.addTarget(self, action: #selector(goback), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    lazy var cancel: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "close_icon"), for: UIControl.State.normal)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.frame = CGRect(x: UIScreen.main.bounds.size.width - 120, y: 20, width: 24, height: 24)
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
        backgroundColor = .white
        
        self.addSubview(name)
        self.addSubview(name_content)
        self.addSubview(image_icon)
        self.addSubview(ok)
        self.addSubview(cancel)

    }
}
