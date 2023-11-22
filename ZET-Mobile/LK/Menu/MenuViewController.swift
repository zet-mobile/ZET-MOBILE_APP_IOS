//
//  MenuViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 2/23/22.
//

import UIKit

private let reuseIdentifer = "MenuOptionCell"
var defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
var count_notif = ""

class MenuViewController: UIViewController {
    
    var alert = UIAlertController()
    
    var tableView: UITableView!
    var tableData = [["Notification", "Notification-1", defaultLocalizer.stringForKey(key: "Notifications")], ["roaming", "roaming-1", defaultLocalizer.stringForKey(key: "Roaming")], ["Setting menu", "Setting-1", defaultLocalizer.stringForKey(key: "Settings")], ["Message", "Message-1", defaultLocalizer.stringForKey(key: "Feedback")], ["Info Square", "Info Square-1", defaultLocalizer.stringForKey(key: "About")], ["Logout", "Logout-1", defaultLocalizer.stringForKey(key: "Exit")]]
    var color = [UIColor.red, UIColor.green, UIColor.gray, UIColor.white, UIColor.yellow, UIColor.purple]
    
    var menuView = MenuView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = toolbarColor
        configureTableView()
        menuView = MenuView(frame: CGRect(x: 0, y: tableView.frame.height - 30 + (topPadding ?? 0), width: UIScreen.main.bounds.size.width - 110, height: UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 60 + (topPadding ?? 0) + (bottomPadding ?? 0))))
        
        menuView.vk.addTarget(self, action: #selector(vkClick), for: .touchUpInside)
        menuView.telegram.addTarget(self, action: #selector(telegramClick), for: .touchUpInside)
        menuView.instagram.addTarget(self, action: #selector(instagramClick), for: .touchUpInside)
        view.addSubview(menuView)
    }
    
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MenuViewCell.self, forCellReuseIdentifier: reuseIdentifer)
        tableView.rowHeight = 50
        //(UIScreen.main.bounds.size.height * 50) / 926
        tableView.estimatedRowHeight = 50
        //(UIScreen.main.bounds.size.height * 50) / 926
        tableView.separatorStyle = .none
        tableView.frame = CGRect(x: 0, y: 20, width: UIScreen.main.bounds.size.width - 110, height: UIScreen.main.bounds.size.height - (UIScreen.main.bounds.size.height * 200) / 926)
        tableView.backgroundColor = contentColor
        view.addSubview(tableView)

    }
    
    @objc func vkClick(_ sender: UIButton) {
        open(scheme: "https://vk.com/zetmobile")
    }
    
    @objc func telegramClick(_ sender: UIButton) {
        open(scheme: "https://t.me/ZETMOBILE" )
    }
    
    @objc func instagramClick(_ sender: UIButton) {
        open(scheme: "https://www.instagram.com/zet_mobile/")
    }
}


// MARK: - Extensions
extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! MenuViewCell
        cell.descriptionLabel.text = tableData[indexPath.row][2]
        cell.ico_image.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: tableData[indexPath.row][1])?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal) : UIImage(named: tableData[indexPath.row][0])?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        
        if count_notif != "0" && indexPath.row == 0 {
            cell.countLabel.text = count_notif
            cell.countLabel.isHidden = false
        }
        else {
            cell.countLabel.isHidden = true
        }
        
        if indexPath.row == 2 {
            cell.ico_image.frame = CGRect(x: 25, y: 20, width: 23, height: 23)
        }
       // cell.descriptionLabel.frame.origin.y = (UIScreen.main.bounds.size.height * 20) / 926
      //  cell.ico_image.frame.origin.y = (UIScreen.main.bounds.size.height * 20) / 926
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = .clear
        cell.selectedBackgroundView = bgColorView
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            dismiss(animated: false)
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.pushViewController(PushViewController(), animated: true)
        }
        else if indexPath.row == 2  {
            dismiss(animated: false)
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.pushViewController(SettingsViewController(), animated: true)
        }
        else if indexPath.row == 1  {
            dismiss(animated: false)
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.pushViewController(RoamingViewController(), animated: true)
        }
        else if indexPath.row == 3 {
            dismiss(animated: false)
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.pushViewController(ReplyToZetViewController(), animated: true)
        }
        else if indexPath.row == 4 {
            dismiss(animated: false)
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.pushViewController(AboutAppViewController(), animated: true)
        }
        else if indexPath.row == 5 {
            
            alert = UIAlertController(title: "\n\n\n\n\n\n\n", message: "", preferredStyle: .alert)
            let widthConstraints = alert.view.constraints.filter({ return $0.firstAttribute == .width })
            alert.view.removeConstraints(widthConstraints)
            // Here you can enter any width that you want
            let newWidth = UIScreen.main.bounds.width * 0.90
            // Adding constraint for alert base view
            let widthConstraint = NSLayoutConstraint(item: alert.view,
                                                         attribute: .width,
                                                         relatedBy: .equal,
                                                         toItem: nil,
                                                         attribute: .notAnAttribute,
                                                         multiplier: 1,
                                                         constant: newWidth)
            alert.view.addConstraint(widthConstraint)
            
            let view = AlertView5()

            view.backgroundColor = contentColor
            view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 40, height: 200)
            view.layer.cornerRadius = 20
            view.cancel.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
            view.ok.addTarget(self, action: #selector(exit), for: .touchUpInside)
            
            alert.view.backgroundColor = .clear
            alert.view.addSubview(view)
            //alert.view.sendSubviewToBack(view)
            
            present(alert, animated: true, completion: nil)
        
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func dismissDialog(_ sender: UIButton) {
        print("hello")
        sender.showAnimation { [self] in
            alert.dismiss(animated: true, completion: nil)
            
        }
    }
    
    @objc func exit() {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        guard let rootViewController = window.rootViewController else {
            return
        }
        let vc = UINavigationController(rootViewController: SplashViewController())
        vc.view.frame = rootViewController.view.frame
        vc.view.layoutIfNeeded()
        UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromLeft, animations: {
            window.rootViewController = vc
        }, completion: { completed in
            UserDefaults.standard.set("", forKey: "mobPhone")
            UserDefaults.standard.set("", forKey: "PinCode")
           // UserDefaults.standard.set(true, forKey: "BiometricEnter")
            UserDefaults.standard.set("", forKey: "token")
            UserDefaults.standard.set("", forKey: "refresh_token")
            
            UserDefaults.standard.set(1, forKey: "language")
            UserDefaults.standard.set(LanguageType.ru.rawValue, forKey: "language_string")
            defaultLocalizer.setSelectedLanguage(lang: .ru)
            
        })
    }
}
