//
//  MenuViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 2/23/22.
//

import UIKit

private let reuseIdentifer = "MenuOptionCell"
var defaultLocalizer = AMPLocalizeUtils.defaultLocalizer

class MenuViewController: UIViewController {
    
    var tableView: UITableView!
    var tableData = [["Notification", "Notification-1", defaultLocalizer.stringForKey(key: "Notifications")], ["roaming", "roaming-1", defaultLocalizer.stringForKey(key: "Roaming")], ["Setting menu", "Setting-1", defaultLocalizer.stringForKey(key: "Settings")], ["Message", "Message-1", defaultLocalizer.stringForKey(key: "Feedback")], ["Info Square", "Info Square-1", defaultLocalizer.stringForKey(key: "About")], ["Logout", "Logout-1", defaultLocalizer.stringForKey(key: "Exit")]]
    
    
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
        menuView = MenuView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - (UIScreen.main.bounds.size.height * 200) / 926, width: UIScreen.main.bounds.size.width - 50, height: (UIScreen.main.bounds.size.height * 200) / 926))

        view.addSubview(menuView)
    }
    
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MenuViewCell.self, forCellReuseIdentifier: reuseIdentifer)
        tableView.rowHeight = (UIScreen.main.bounds.size.height * 50) / 926
        tableView.separatorStyle = .none
        tableView.frame = CGRect(x: 0, y: 10, width: UIScreen.main.bounds.size.width - 50, height: UIScreen.main.bounds.size.height - (UIScreen.main.bounds.size.height * 200) / 926)
        tableView.backgroundColor = contentColor
        view.addSubview(tableView)

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
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.pushViewController(PushViewController(), animated: true)
        }
        else if indexPath.row == 2  {
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.pushViewController(SettingsViewController(), animated: true)
        }
        else if indexPath.row == 1  {
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.pushViewController(RoumingViewController(), animated: true)
        }
        else if indexPath.row == 3 {
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.pushViewController(ReplyToZetViewController(), animated: true)
        }
        else if indexPath.row == 4 {
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.pushViewController(AboutAppViewController(), animated: true)
        }
        else if indexPath.row == 5 {
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
                UserDefaults.standard.set(1, forKey: "language")
                UserDefaults.standard.set(LanguageType.ru.rawValue, forKey: "language_string")
                UserDefaults.standard.set("", forKey: "PinCode")
                UserDefaults.standard.set(true, forKey: "BiometricEnter")
                UserDefaults.standard.set("", forKey: "token")
                UserDefaults.standard.set("", forKey: "refresh_token")
                
            })
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
