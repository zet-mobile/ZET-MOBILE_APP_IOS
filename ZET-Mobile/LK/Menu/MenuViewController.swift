//
//  MenuViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 2/23/22.
//

import UIKit

private let reuseIdentifer = "MenuOptionCell"

class MenuViewController: UIViewController {

    var tableView: UITableView!
    var tableData = [["Notification", "Уведомления"], ["Discount", "Акции и предложения"], ["Setting", "Настройки"], ["roaming", "Роуминг"], ["Message", "Обратная связь"], ["Info Square", "О нас"], ["Logout", "Выйти"]]
    
    
    var menuView = MenuView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureTableView()
        menuView = MenuView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - (UIScreen.main.bounds.size.height * 200) / 926, width: UIScreen.main.bounds.size.width - 50, height: (UIScreen.main.bounds.size.height * 200) / 926))

        view.addSubview(menuView)
    }
    
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MenuViewCell.self, forCellReuseIdentifier: reuseIdentifer)
        tableView.backgroundColor = .clear
        tableView.rowHeight = (UIScreen.main.bounds.size.height * 70) / 926
        tableView.separatorStyle = .none
        tableView.frame = CGRect(x: 0, y: 10, width: UIScreen.main.bounds.size.width - 50, height: UIScreen.main.bounds.size.height - (UIScreen.main.bounds.size.height * 200) / 926)
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
