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
    var tableData = [["Notification", defaultLocalizer.stringForKey(key: "Notifications")], ["Discount", defaultLocalizer.stringForKey(key: "Promotions")], ["Setting", defaultLocalizer.stringForKey(key: "Settings")], ["roaming", defaultLocalizer.stringForKey(key: "Roaming")], ["Message", defaultLocalizer.stringForKey(key: "Feedback")], ["Info Square", defaultLocalizer.stringForKey(key: "About")], ["Logout", defaultLocalizer.stringForKey(key: "Exit")]]
    
    
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
        tableView.rowHeight = (UIScreen.main.bounds.size.height * 70) / 926
        tableView.separatorStyle = .none
        tableView.frame = CGRect(x: 0, y: 10, width: UIScreen.main.bounds.size.width - 50, height: UIScreen.main.bounds.size.height - (UIScreen.main.bounds.size.height * 200) / 926)
        tableView.backgroundColor = contentColor
        view.addSubview(tableView)

    }
    
}


// MARK: - Extensions
extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! MenuViewCell
        cell.descriptionLabel.text = tableData[indexPath.row][1]
        cell.ico_image.image = UIImage(named: tableData[indexPath.row][0])?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
         
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.pushViewController(PushViewController(), animated: true)
        }
        else if indexPath.row == 1  {
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.pushViewController(ChangeTransferViewController(), animated: true)
        }
        else if indexPath.row == 2  {
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.pushViewController(SettingsViewController(), animated: true)
        }
        else if indexPath.row == 3  {
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.pushViewController(RoumingViewController(), animated: true)
        }
        else if indexPath.row == 4 {
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.pushViewController(ReplyToZetViewController(), animated: true)
        }
        else if indexPath.row == 5 {
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.pushViewController(AboutAppViewController(), animated: true)
        }
        else if indexPath.row == 6 {
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
            })
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
