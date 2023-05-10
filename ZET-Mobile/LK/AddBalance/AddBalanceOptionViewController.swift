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
        add_balance_option.close.addTarget(self, action: #selector(close_view), for: .touchUpInside)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func close_view() {
        dismiss(animated: true, completion: nil)
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
        
        let image = UIImage(named: "Stroke_next.png")
            let checkmark  = UIImageView(frame:CGRect(x:0, y:0, width:(image?.size.width)!, height:(image?.size.height)!));
            checkmark.image = image
            cell.accessoryView = checkmark
      
        cell.titleOne.text = tableData[indexPath.row][1]
        if indexPath.row == 0 {
            cell.ico_image.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "first.png") : UIImage(named: "first_l.png"))
        }
        /*else if indexPath.row == 1 {
            cell.ico_image.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "second.png") : UIImage(named: "second_l.png"))
        }*/
        else {
            cell.ico_image.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "third.png") : UIImage(named: "third_l.png"))
        }
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.00) : UIColor(red: 1.00, green: 0.98, blue: 0.94, alpha: 1.00))
        bgColorView.layer.borderColor = UIColor.orange.cgColor
        bgColorView.layer.borderWidth = 1
        bgColorView.layer.cornerRadius = 10
        cell.selectedBackgroundView = bgColorView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("hi")
        if indexPath.row == 0 {
            self.dismiss(animated: true, completion: nil)
        }
        else if indexPath.row == 1 {
            self.dismiss(animated: true, completion: nil)
        }
        else if indexPath.row == 2 {
            print("hhhh")
            self.dismiss(animated: true) {
                ContainerViewController().navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                ContainerViewController().navigationController?.pushViewController(AskFriendViewController(), animated: true)
            }
            
        }
    }
}

class AddBalanceOptionView: UIView {
    
    lazy var close: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: UIScreen.main.bounds.size.width - 50, y: 20, width: 20, height: 20)
        button.setImage(#imageLiteral(resourceName: "close_icon"), for: UIControl.State.normal)
        button.isUserInteractionEnabled = true
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


class AddBalanceView: UIView {

    lazy var close: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: UIScreen.main.bounds.size.width - 50, y: 20, width: 30, height: 30)
        button.setImage(#imageLiteral(resourceName: "close_icon"), for: UIControl.State.normal)
        button.isUserInteractionEnabled = true
        //button.addTarget(self, action: #selector(moreTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var title_push: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 20, y: 5, width: UIScreen.main.bounds.size.width - 40, height: 50)
        title.text = defaultLocalizer.stringForKey(key: "Top_account")
        title.numberOfLines = 1
        title.textColor = colorBlackWhite
        title.font = UIFont.boldSystemFont(ofSize: 20)
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
