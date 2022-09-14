//
//  PushMoreViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/10/21.
//

import UIKit

class PushMoreViewController: UIViewController {

    let push_view = PushMoreView(frame: CGRect(x: 0, y: topPadding ?? 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        push_view.layer.cornerRadius = 10
        view.addSubview(push_view)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? .lightContent : .darkContent)
    }

}

class PushMoreView: UIView {
    
    lazy var image_push: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "image16")
        image.frame = CGRect(x: 20, y: 70, width: UIScreen.main.bounds.size.width - 40, height: UIScreen.main.bounds.size.width - 40)
        return image
    }()
    
    lazy var close: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: UIScreen.main.bounds.size.width - 50, y: 20, width: 20, height: 20)
        button.setImage(#imageLiteral(resourceName: "close_icon"), for: UIControl.State.normal)
        button.isUserInteractionEnabled = false
        //button.addTarget(self, action: #selector(moreTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var title_push: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 20, y: 5, width: UIScreen.main.bounds.size.width - 40, height: 50)
        title.text = "Скидка на Хаматарафа+200"
        title.numberOfLines = 1
        title.textColor = colorBlackWhite
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.textAlignment = .left
        
        return title
    }()
    
    lazy var about: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 20, y: 70 + (UIScreen.main.bounds.size.width), width: UIScreen.main.bounds.size.width - 40, height: 60)
        title.text = """
 С 12 октября по 31 января действуют 50% СКИДКИ на пакеты Хаматарафа+120, Хаматарафа+95, Хаматарафа+75.
 """
        title.numberOfLines = 4
        title.textColor = darkGrayLight
        title.font = UIFont.systemFont(ofSize: 16)
        title.textAlignment = .left
        return title
    }()
    
    lazy var connect: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 10, y: 70 + (UIScreen.main.bounds.size.width) + 60 + 20, width: UIScreen.main.bounds.size.width - 20, height: 50)
        button.setImage(#imageLiteral(resourceName: "connect"), for: UIControl.State.normal)
        //button.addTarget(self, action: #selector(moreTapped), for: .touchUpInside)
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
        backgroundColor = contentColor
        self.addSubview(image_push)
        self.addSubview(title_push)
        self.addSubview(close)
        self.addSubview(about)
        self.addSubview(connect)

    }
}
