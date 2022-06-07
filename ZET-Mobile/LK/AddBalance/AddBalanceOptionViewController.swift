//
//  AddBalanceOption.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 2/9/22.
//

import UIKit

var cellClick = ""

class AddBalanceOptionViewController: UIViewController {
    
    let table = UITableView()
    
    let tableData = [["icon1", defaultLocalizer.stringForKey(key: "Temporary_payment")], ["iconn2", defaultLocalizer.stringForKey(key: "Payment_via")], ["icon3", defaultLocalizer.stringForKey(key: "Ask_friend")]]
    
    let add_balance_option = AddBalanceOptionView(frame: CGRect(x: 5, y: UIScreen.main.bounds.size.height - (3 * 80) - 60, width: UIScreen.main.bounds.size.width - 10, height: UIScreen.main.bounds.size.height / 4))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        modalPresentationCapturesStatusBarAppearance = true
       
        add_balance_option.layer.cornerRadius = 10
        view.addSubview(add_balance_option)
        
        view.addSubview(table)
        table.frame = CGRect(x:5, y: Int(UIScreen.main.bounds.size.height) - tableData.count * 80, width: Int(UIScreen.main.bounds.size.width) - 10, height: tableData.count * 80)
        table.register(AddBalanceOptionViewCell.self, forCellReuseIdentifier: "add_balance_cell")
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 80
        table.estimatedRowHeight = 80
        table.alwaysBounceVertical = false
        table.separatorStyle = .none
        table.isScrollEnabled = false
        table.backgroundColor = contentColor
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

extension AddBalanceOptionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "add_balance_cell", for: indexPath) as! AddBalanceOptionViewCell
        cell.accessoryType = .disclosureIndicator
        cell.titleOne.text = tableData[indexPath.row][1]
        //cell.textLabel?.text = characters[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellClick = String(indexPath.row)
        print("hi")
        if indexPath.row == 0 {
            
        }
        else if indexPath.row == 1 {
            
        }
        else if indexPath.row == 2 {
            print("hhhh")
            self.dismiss(animated: true) {
                HomeViewController().navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                HomeViewController().navigationController?.pushViewController(AskFriendViewController(), animated: true)
            }
            
        }
    }
}

class AddBalanceOptionView: UIView {
    
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
        title.text = defaultLocalizer.stringForKey(key: "Top_account")
        title.numberOfLines = 1
        title.textColor = colorBlackWhite
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.textAlignment = .left
        
        return title
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
    
        self.addSubview(title_push)
        self.addSubview(close)

    }
}
