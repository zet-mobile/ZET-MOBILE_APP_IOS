//
//  DialogOfficesViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 06/04/22.
//

import UIKit

var choosed_office_name = ""
var choosed_office_time = ""

class DialogOfficesViewController: UIViewController {
    
    let table = UITableView()
    
    let tableData = [["Home_light", choosed_office_name], ["Time_light", choosed_office_time]]
    
    let dialog_office = DialogOfficesView(frame: CGRect(x: 5, y: UIScreen.main.bounds.size.height - 80 - 60, width: UIScreen.main.bounds.size.width - 10, height: UIScreen.main.bounds.size.height / 4))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        modalPresentationCapturesStatusBarAppearance = true
       
        dialog_office.layer.cornerRadius = 10
        dialog_office.close.addTarget(self, action: #selector(close_view), for: .touchUpInside)
        view.addSubview(dialog_office)
        
        view.addSubview(table)
        table.frame = CGRect(x: 5, y: Int(UIScreen.main.bounds.size.height) - tableData.count * 40, width: Int(UIScreen.main.bounds.size.width) - 10, height: tableData.count * 40)
        table.register(DialogOfficesViewCell.self, forCellReuseIdentifier: "DialogOfficesViewCell")
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 40
        table.estimatedRowHeight = 40
        table.alwaysBounceVertical = false
        table.separatorStyle = .none
        table.isScrollEnabled = false
        table.backgroundColor = contentColor
        table.allowsSelection =  false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @objc func close_view() {
        dismiss(animated: true, completion: nil)
    }
}

extension DialogOfficesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DialogOfficesViewCell", for: indexPath) as! DialogOfficesViewCell
        cell.accessoryType = .disclosureIndicator
        cell.ico_image.image = UIImage(named: tableData[indexPath.row][0])
        cell.titleOne.text = tableData[indexPath.row][1]
        //cell.textLabel?.text = characters[indexPath.row]
        return cell
    }
    
}

class DialogOfficesView: UIView {
    
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
        title.text = defaultLocalizer.stringForKey(key: "Zet_office")
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
