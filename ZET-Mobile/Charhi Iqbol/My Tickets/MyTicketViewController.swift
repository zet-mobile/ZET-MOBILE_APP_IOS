//
//  MyTicketViewController.swift
//  ZET-Mobile
//
//  Created by iDev on 06/09/23.
//

import UIKit
import RxCocoa
import RxSwift

class MyTicketViewController: UIViewController, UIScrollViewDelegate {
    
    var alert = UIAlertController()
    var bannerUrl = ""
    
    
    let disposeBag = DisposeBag()
    
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    var toolbar = TarifToolbarView()
    // let scrollView = UIScrollView()
    var myTicketView = MyTicketView()
    let table = UITableView(frame: .zero, style: .grouped)
    var table_height = 0
    var createdAt = [String]()
    var drawId = [String]()
    var success = [Bool]()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = toolbarColor
        toolbar = TarifToolbarView(frame: CGRect(x: 0, y: topPadding ?? 0, width: UIScreen.main.bounds.size.width, height: 60))
        self.view.addSubview(myTicketView)
        self.view.addSubview(toolbar)
        
        
        toolbar.icon_back.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goBack))
        toolbar.isUserInteractionEnabled = true
        toolbar.addGestureRecognizer(tapGestureRecognizer)
        
        toolbar.number_user_name.text = defaultLocalizer.stringForKey(key: "MY_TICKETS")
        
        sendRequest()
      
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? .lightContent : .darkContent)
    }
    
    func setupView() {
        view.backgroundColor = toolbarColor
        
        
      //  myTicketView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 896)
        myTicketView.backgroundColor = .clear
        myTicketView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([myTicketView.topAnchor.constraint(equalTo: toolbar.bottomAnchor),
                                     myTicketView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     myTicketView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     myTicketView.bottomAnchor.constraint(equalTo: view.bottomAnchor )])


        
        
    }
    
    
    func setupHistoryUsagesTableView() {
        view.addSubview(table)
       // myTicketView.addSubview(table)
     
        if(self.createdAt.count == 0){
            print("попал cюды ")
            table.isHidden = true
            myTicketView.totalTickets.text = defaultLocalizer.stringForKey(key: "WITHOUT_DRAW")
            
            myTicketView.totalTickets.textAlignment = .center
            myTicketView.totalTickets.frame = CGRect(x: 0, y: myTicketView.image_banner.frame.maxY + 15 , width: myTicketView.image_banner.frame.width, height: 50)
           
            myTicketView.view_button.isHidden =  false
            myTicketView.view_button.backgroundColor = .clear
            myTicketView.sendButton.addTarget(self, action: #selector(openBuyTickets), for: .touchUpInside)
            myTicketView.view_button.frame = CGRect(x: 0, y: Int(myTicketView.totalTickets.frame.maxY) + 45, width: Int(UIScreen.main.bounds.size.width), height: 70)

            
            table.isHidden = true
        }else{
            print("попал туда ")
            
            
            myTicketView.view_button.isHidden = true
            
            
            myTicketView.totalTickets.text = defaultLocalizer.stringForKey(key: "TOTAL") + ": " + String(createdAt.count) + " ID"
            myTicketView.backgroundColor = contentColor
            table.translatesAutoresizingMaskIntoConstraints = false
            table.frame = CGRect(x: 0, y: Int(myTicketView.totalTickets.frame.minY), width: Int(UIScreen.main.bounds.size.width), height: 370)
            table.register(MyTicketsViewCell.self, forCellReuseIdentifier: "myTickets_cell")
            table.delegate = self
            table.dataSource = self
            table.rowHeight = 76
            table.alwaysBounceVertical = false
            table.separatorStyle = .none
            table.isScrollEnabled = true
            table.showsVerticalScrollIndicator = true
            table.backgroundColor = contentColor
            table.tableHeaderView?.backgroundColor = contentColor
            print("setup history table ")
            NSLayoutConstraint.activate([table.topAnchor.constraint(equalTo: myTicketView.totalTickets.bottomAnchor),
                                         table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                         table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                         table.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        }
    }
    
    
    func sendRequest()
    {
        let client = APIClient.shared
        do{
            try client.charhiIqbolMain().subscribe(
                onNext: { [weak self] result in
                    DispatchQueue.main.async {
                        self!.bannerUrl = result.bannerURL
                    }
                },
                onError: {
                    error in
                    DispatchQueue.main.async { [self] in
                        
                            // add exception
                        self.requestAnswer(status: false, message: self.defaultLocalizer.stringForKey(key: "service is temporarily unavailable"))
                        self.hideActivityIndicator(uiView: self.view)
                    }
                },
                onCompleted: {DispatchQueue
                    
                    .main
                    .async { [self] in
                        //  setupHistoryUsagesTableView()
                        myTicketView.image_banner.af_setImage(withURL: URL(string: bannerUrl)!)
                        setupView()
                        getMyTickets()

                    }
                }).disposed(by: disposeBag)
            
            print("banerok  2: \(bannerUrl)")
            
        }
        catch{
        }
    }
    
    
    func getMyTickets()
    {
        let client = APIClient.shared
        do{
            try client.getMyTickets().subscribe(
                onNext: { [weak self] result in
                    DispatchQueue.main.async {
                        
                        for i in 0 ..< result.count{
                            self!.createdAt.append(result[i].createdAt)
                            self!.drawId.append(result[i].drawId)
                            self!.success.append(result[i].success)
                        }

                    }
                    
                },
                onError: {
                    error in
                    DispatchQueue.main.async { [self] in
                        setupView()
                        self.requestAnswer(status: false, message: self.defaultLocalizer.stringForKey(key: "service is temporarily unavailable"))
                        self.hideActivityIndicator(uiView: self.view)
                    }
                },
                onCompleted: {DispatchQueue
                    
                    .main
                    .async { [self] in
                        print("banerok  3: \(bannerUrl)")
                        
                        //setupView()
                        setupHistoryUsagesTableView()

                        
                    }
                }).disposed(by: disposeBag)
            
            print("banerok  4: \(bannerUrl)")
            
        }
        catch{
        }
    }
    
    @objc func openBuyTickets(_ sender: UIButton){
        sender.showAnimation { [self] in
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.pushViewController(BuyTicketsViewController(), animated: true)
        }    }
    
    @objc func requestAnswer(status: Bool, message: String) {
        
        alert = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n\n", message: "", preferredStyle: .alert)
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
        
        let view = AlertView()
        
        view.backgroundColor = contentColor
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 40, height: 350)
        view.layer.cornerRadius = 20
        if status == true {
            view.name.text = defaultLocalizer.stringForKey(key: "service_connected")
            view.image_icon.image = UIImage(named: "correct_alert")
        }
        else {
            view.name.text = defaultLocalizer.stringForKey(key: "error_title")
            view.image_icon.image = UIImage(named: "uncorrect_alert")
        }
        
        view.name_content.text = "\(message)"
        view.ok.setTitle("OK", for: .normal)
        
        view.cancel.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
        view.ok.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
        
        alert.view.backgroundColor = .clear
        alert.view.addSubview(view)
        //alert.view.sendSubviewToBack(view)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    @objc func dismissDialog(_ sender: UIButton) {
        sender.showAnimation { [self] in
            alert.dismiss(animated: true, completion: nil)
            hideActivityIndicator(uiView: view)
        }
    }
    
    
    @objc func goBack() {
        if let destinationViewController = navigationController?.viewControllers
            .filter(
                {$0 is CompetitionViewController})
                .first {
            navigationController?.popToViewController(destinationViewController, animated: true)
        }
    }
    
}

extension MyTicketViewController:  UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return createdAt.count
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "myTickets_cell", for: indexPath) as! MyTicketsViewCell
        let time = self.createdAt[indexPath.section]
        let id = self.drawId[indexPath.section]
        myTicketView.translatesAutoresizingMaskIntoConstraints = false
       
        
      //  myTicketView.

    //NSLayoutConstraint.activate([
            //self.myTicketView.totalTickets.topAnchor.constraint(equalTo: myTicketView.image_banner.bottomAnchor)
            //,
         //   myTicketView.totalTickets.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
          // myTicketView.totalTickets.trailingAnchor.constraint(equalTo: view.trailingAnchor,  constant: 20)
                //myTicketView.totalTickets.bottomAnchor.constraint(equalTo: )
     //   ])
        cell.frame = CGRect(x: 1, y: 1, width: 1, height: 1)
        cell.titleOne.text = "ID " + id
        cell.titleTwo.text = time
        cell.isUserInteractionEnabled = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0 // Установить высоту заголовка секции равной 0
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .lightGray // Цвет вашего разделителя
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0 // Высота вашего разделителя
    }
    
}
