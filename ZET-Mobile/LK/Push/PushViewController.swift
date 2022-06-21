//
//  PushViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/9/21.
//

import UIKit

class PushViewController: UIViewController {

    let detailViewController = MoreDetailViewController()
    var nav = UINavigationController()
    
    var toolbar = TarifToolbarView()
    
    let table = UITableView()
    
    var show_more_tapped_ind = 0
    var show_more_tapped = false
    var show_more_tapped_ind2 = 0
    var show_more_tapped2 = false
    
    var notif_data = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showActivityIndicator(uiView: self.view)
        view.backgroundColor = toolbarColor
        
        toolbar = TarifToolbarView(frame: CGRect(x: 0, y: 44, width: UIScreen.main.bounds.size.width, height: 60))
        toolbar.number_user_name.text = "Уведомления"
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goBack))
        toolbar.isUserInteractionEnabled = true
        toolbar.addGestureRecognizer(tapGestureRecognizer)
        
        self.view.addSubview(toolbar)
        
        sendRequest()
        
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupView() {
        view.backgroundColor = toolbarColor

        table.register(PushPhotoTypeViewCell.self, forCellReuseIdentifier: "push_photo_cell")
        table.register(PushTableViewCell.self, forCellReuseIdentifier: "push_cell")
        table.frame = CGRect(x: 0, y: 100, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 204)
        table.delegate = self
        table.dataSource = self
        table.alwaysBounceVertical = false
        table.separatorStyle = .none
        table.backgroundColor = toolbarColor
        //table.allowsSelection = false
        
        /*if notif_data.count == 0 {
            emptyView = EmptyView(frame: CGRect(x: 0, y: 30, width: table.frame.width, height: table.frame.height), text: """
            У вас нет никаких уведомлений
            """)
            table.separatorStyle = .none
            table.backgroundView = emptyView
        }*/
        
        view.addSubview(table)
    }
    
    func sendRequest() {
        let client = APIClient.shared
            do{
              try client.getNotificationRequest().subscribe(
                onNext: { result in
                  print(result)
                    DispatchQueue.main.async {
                        if result.notifications!.count != 0 {
                            for i in 0 ..< result.notifications!.count {
                                self.notif_data.append([String(result.notifications![i].id), String(result.notifications![i].title), String(result.notifications![i].body), String(result.notifications![i].image), String(result.notifications![i].icon), String(result.notifications![i].statusId)])
                            }
                        }
                    }
                },
                onError: { error in
                   print(error.localizedDescription)
                    //self.requestAnswer(status: false, message: error.localizedDescription)
                },
                onCompleted: {
                    DispatchQueue.main.async { [self] in
                        setupView()
                        hideActivityIndicator(uiView: view)
                    }
                   print("Completed event.")
                    
                }).disposed(by: disposeBag)
              }
              catch{
            }
    }
    
}

extension PushViewController: UITableViewDataSource, UITableViewDelegate {
   /* func didOpenSheetMore(for cell: PushPhotoTypeViewCell) {
        let next = PushMoreViewController()
        next.view.frame = (view.frame.inset(by: UIEdgeInsets(top: 434, left: 0, bottom: 0, right: 0)))
        self.halfModalTransitioningDelegate = HalfModalTransitioningDelegate(viewController: self, presentingViewController: next)
        next.modalPresentationStyle = .custom
        next.modalPresentationCapturesStatusBarAppearance = true
        
        next.transitioningDelegate = self.halfModalTransitioningDelegate
        present(next, animated: true, completion: nil)
    }
    
    func didMoreTwoTapped(for cell: PushTableViewCell) {
        if let indexPath = table.indexPath(for: cell) {
            if show_more_tapped2 == false {
                show_more_tapped2 = true
                show_more_tapped_ind2 = indexPath.row
                cell.view_cell.frame.size.height = 160
                cell.about.frame.size.height = 60
                cell.about.numberOfLines = 4
                cell.icon_show_more.isHidden = false
                cell.icon_more.setImage(#imageLiteral(resourceName: "opened_icon"), for: UIControl.State.normal)
                table.reloadData()
            } else if show_more_tapped2 == true && show_more_tapped_ind2 != indexPath.row {
                show_more_tapped2 = true
                show_more_tapped_ind2 = indexPath.row
                cell.view_cell.frame.size.height = 160
                cell.about.frame.size.height = 60
                cell.about.numberOfLines = 4
                cell.icon_show_more.isHidden = false
                cell.icon_more.setImage(#imageLiteral(resourceName: "opened_icon"), for: UIControl.State.normal)
                table.reloadData()
            } else {
                show_more_tapped2 = false
                show_more_tapped_ind2 = indexPath.row
                cell.view_cell.frame.size.height = 100
                cell.about.frame.size.height = 30
                cell.about.numberOfLines = 1
                cell.icon_show_more.isHidden = true
                cell.icon_more.setImage(#imageLiteral(resourceName: "closed_icon"), for: UIControl.State.normal)
                table.reloadData()
            }
            
        }
    }
    
    
    func didMoreTapped(for cell: PushPhotoTypeViewCell) {
        print("fff")
        if let indexPath = table.indexPath(for: cell) {
            if show_more_tapped == false {
                show_more_tapped = true
                show_more_tapped_ind = indexPath.row
                cell.view_cell.frame.size.height = 160
                cell.about.frame.size.height = 60
                cell.about.numberOfLines = 4
                cell.icon_show_more.isHidden = false
                cell.icon_more.setImage(#imageLiteral(resourceName: "opened_icon"), for: UIControl.State.normal)
                table.reloadData()
            } else if show_more_tapped == true && show_more_tapped_ind != indexPath.row {
                show_more_tapped = true
                show_more_tapped_ind = indexPath.row
                cell.view_cell.frame.size.height = 160
                cell.about.frame.size.height = 60
                cell.about.numberOfLines = 4
                cell.icon_show_more.isHidden = false
                cell.icon_more.setImage(#imageLiteral(resourceName: "opened_icon"), for: UIControl.State.normal)
                table.reloadData()
            } else {
                show_more_tapped = false
                show_more_tapped_ind = indexPath.row
                cell.view_cell.frame.size.height = 100
                cell.about.frame.size.height = 30
                cell.about.numberOfLines = 1
                cell.icon_show_more.isHidden = true
                cell.icon_more.setImage(#imageLiteral(resourceName: "closed_icon"), for: UIControl.State.normal)
                table.reloadData()
            }
            
        }
        
    }*/
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == show_more_tapped_ind && show_more_tapped == true  || indexPath.row == show_more_tapped_ind2 && show_more_tapped2 == true {
            return 180
        } else {
            
            return 120
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "push_photo_cell", for: indexPath) as! PushPhotoTypeViewCell
            if indexPath.row == show_more_tapped_ind && show_more_tapped == true {
                cell.view_cell.frame.size.height = 160
                cell.about.frame.size.height = 60
                cell.about.numberOfLines = 4
                cell.icon_show_more.isHidden = false
                cell.icon_more.setImage(#imageLiteral(resourceName: "opened_icon"), for: UIControl.State.normal)
          
            } else {
                cell.view_cell.frame.size.height = 100
                cell.about.frame.size.height = 30
                cell.about.numberOfLines = 1
                cell.icon_show_more.isHidden = true
                cell.icon_more.setImage(#imageLiteral(resourceName: "closed_icon"), for: UIControl.State.normal)
             
            }
            
           // cell.title.text = notif_data[indexPath.row][1]
            //cell.about.text = notif_data[indexPath.row][2]
            
            cell.icon_show_more.addTarget(self, action: #selector(openMore), for: .touchUpInside)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "push_cell", for: indexPath) as! PushTableViewCell
            
            if indexPath.row == show_more_tapped_ind2 && show_more_tapped2 == true {
                cell.view_cell.frame.size.height = 160
                cell.about.frame.size.height = 60
                cell.about.numberOfLines = 4
                cell.icon_show_more.isHidden = false
                cell.icon_more.setImage(#imageLiteral(resourceName: "opened_icon"), for: UIControl.State.normal)
          
            } else {
                cell.view_cell.frame.size.height = 100
                cell.about.frame.size.height = 30
                cell.about.numberOfLines = 1
                cell.icon_show_more.isHidden = true
                cell.icon_more.setImage(#imageLiteral(resourceName: "closed_icon"), for: UIControl.State.normal)
             
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("hhhttt")
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "push_photo_cell", for: indexPath) as! PushPhotoTypeViewCell
            if show_more_tapped == false {
                show_more_tapped = true
                show_more_tapped_ind = indexPath.row
                cell.view_cell.frame.size.height = 160
                cell.about.frame.size.height = 60
                cell.about.numberOfLines = 4
                cell.icon_show_more.isHidden = false
                cell.icon_more.setImage(#imageLiteral(resourceName: "opened_icon"), for: UIControl.State.normal)
                table.reloadData()
            } else if show_more_tapped == true && show_more_tapped_ind != indexPath.row {
                show_more_tapped = true
                show_more_tapped_ind = indexPath.row
                cell.view_cell.frame.size.height = 160
                cell.about.frame.size.height = 60
                cell.about.numberOfLines = 4
                cell.icon_show_more.isHidden = false
                cell.icon_more.setImage(#imageLiteral(resourceName: "opened_icon"), for: UIControl.State.normal)
                table.reloadData()
            } else {
                show_more_tapped = false
                show_more_tapped_ind = indexPath.row
                cell.view_cell.frame.size.height = 100
                cell.about.frame.size.height = 30
                cell.about.numberOfLines = 1
                cell.icon_show_more.isHidden = true
                cell.icon_more.setImage(#imageLiteral(resourceName: "closed_icon"), for: UIControl.State.normal)
                table.reloadData()
            }
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "push_cell", for: indexPath) as! PushTableViewCell
            
            if show_more_tapped2 == false {
                show_more_tapped2 = true
                show_more_tapped_ind2 = indexPath.row
                cell.view_cell.frame.size.height = 160
                cell.about.frame.size.height = 60
                cell.about.numberOfLines = 4
                cell.icon_show_more.isHidden = false
                cell.icon_more.setImage(#imageLiteral(resourceName: "opened_icon"), for: UIControl.State.normal)
                table.reloadData()
            } else if show_more_tapped2 == true && show_more_tapped_ind2 != indexPath.row {
                show_more_tapped2 = true
                show_more_tapped_ind2 = indexPath.row
                cell.view_cell.frame.size.height = 160
                cell.about.frame.size.height = 60
                cell.about.numberOfLines = 4
                cell.icon_show_more.isHidden = false
                cell.icon_more.setImage(#imageLiteral(resourceName: "opened_icon"), for: UIControl.State.normal)
                table.reloadData()
            } else {
                show_more_tapped2 = false
                show_more_tapped_ind2 = indexPath.row
                cell.view_cell.frame.size.height = 100
                cell.about.frame.size.height = 30
                cell.about.numberOfLines = 1
                cell.icon_show_more.isHidden = true
                cell.icon_more.setImage(#imageLiteral(resourceName: "closed_icon"), for: UIControl.State.normal)
                table.reloadData()
            }
        }
        
    }
    
    @objc func openMore() {
       // detailViewController.more_view.content.text = notif_data[trasfer_type_choosed_id][15]
        detailViewController.more_view.image.image = UIImage(named: "transfer")
        detailViewController.more_view.title_top.text = defaultLocalizer.stringForKey(key: "Traffic_exchange")
        
        detailViewController.more_view.close_banner.addTarget(self, action: #selector(dismiss_view), for: .touchUpInside)
        detailViewController.more_view.close.addTarget(self, action: #selector(dismiss_view), for: .touchUpInside)
    
        nav = UINavigationController(rootViewController: detailViewController)
        nav.modalPresentationStyle = .pageSheet
        nav.view.backgroundColor = contentColor
        nav.isNavigationBarHidden = true
        detailViewController.view.backgroundColor = colorGrayWhite
        if #available(iOS 15.0, *) {
            if let sheet = nav.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.selectedDetentIdentifier = .medium
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false

            }
        } else {
            // Fallback on earlier versions
        }
            // 4
        present(nav, animated: true, completion: nil)
    }
    
    @objc func dismiss_view() {
        print("jlllllll")
        nav.dismiss(animated: true, completion: nil)
    }
}
