//
//  ProfilesMenuViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 2/24/22.
//

import UIKit

class ProfilesMenuViewController: UIViewController {

    let table = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalPresentationCapturesStatusBarAppearance = true
       
        table.layer.cornerRadius = 10
        
        view.addSubview(table)
        table.frame = CGRect(x: 5, y: Int(UIScreen.main.bounds.size.height) - 3 * 80 + 10, width: Int(UIScreen.main.bounds.size.width) - 10, height: 3 * 80)
        table.register(ProfileMenuCell.self, forCellReuseIdentifier: "profile_menu_cell")
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 80
        table.estimatedRowHeight = 80
        table.alwaysBounceVertical = false
        table.separatorStyle = .none
        table.isScrollEnabled = true
        table.backgroundColor = contentColor
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

extension ProfilesMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profile_menu_cell", for: indexPath) as! ProfileMenuCell
        //cell.titleOne.text = "tableData[indexPath.row][1]"
        //cell.textLabel?.text = characters[indexPath.row]
        
        if indexPath.row == 2 {
            cell.ico_image.isHidden = true
            cell.titleOne.isHidden = true
            cell.titleTwo.text = "Добавить профиль ＋"
            cell.titleTwo.textColor = .orange
            cell.titleTwo.frame.origin.y = 20
            cell.titleTwo.font = UIFont.boldSystemFont(ofSize: 17)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("hello")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(AddionalTraficsViewController(), animated: true)
    }
    
    
}
