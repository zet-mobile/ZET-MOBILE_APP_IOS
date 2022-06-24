//
//  PushViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/9/21.
//

import UIKit
import RxSwift
import RxCocoa

class PushViewController: UIViewController, UIGestureRecognizerDelegate {

    let disposeBag = DisposeBag()
    let detailViewController = MoreDetailViewController()
    var nav = UINavigationController()
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    var alert = UIAlertController()
    
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
        table.frame = CGRect(x: 0, y: 60 + (topPadding ?? 0), width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 60 + (topPadding ?? 0) + (bottomPadding ?? 0)))
        table.delegate = self
        table.dataSource = self
        table.alwaysBounceVertical = false
        table.separatorStyle = .none
        table.backgroundColor = toolbarColor
        //table.allowsSelection = false
        
        if notif_data.count == 0 {
            emptyView = EmptyView(frame: CGRect(x: 0, y: 30, width: table.frame.width, height: table.frame.height), text: """
            У вас нет никаких уведомлений
            """)
            table.separatorStyle = .none
            table.backgroundView = emptyView
        }
        
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
                                self.notif_data.append([String(result.notifications![i].id), String(result.notifications![i].title), String(result.notifications![i].image), String(result.notifications![i].icon), String(result.notifications![i].statusId)])
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
    
    @objc func requestAnswer(status: Bool, message: String) {
        
        alert = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n", message: "", preferredStyle: .alert)
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
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 40, height: 330)
        view.layer.cornerRadius = 20
        var checkColor = UIColor.black
        
        if UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" {
            checkColor = .white
        }
        else {
            checkColor = .black
        }
        
        if status == true {
            view.name.text = "Deleted!"
            view.image_icon.image = UIImage(named: "correct_alert")
            
        }
        else {
            view.name.text = "Что-то пошло не так"
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
        print("hello")
        sender.showAnimation { [self] in
            alert.dismiss(animated: true, completion: nil)
            hideActivityIndicator(uiView: view)
        }
    }
}

extension PushViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == show_more_tapped_ind && show_more_tapped == true  || indexPath.row == show_more_tapped_ind2 && show_more_tapped2 == true {
            return 180
        } else {
            
            return 120
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notif_data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
            
            cell.title.text = notif_data[indexPath.row][1]
            cell.about.text = notif_data[indexPath.row][2]
            
            let bgColorView = UIView()
            bgColorView.backgroundColor = .clear
            cell.selectedBackgroundView = bgColorView
            
            cell.icon_show_more.addTarget(self, action: #selector(openMore), for: .touchUpInside)
            return cell
       /* }
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
        }*/
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("hhhttt")
    
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
       /* }
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
        }*/
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        // Archive action
        let delete = UIContextualAction(style: .normal, title: "") { [weak self] (action, view, completionHandler) in
            self?.handleMoveToArchive(pushID: self!.notif_data[indexPath.row][0] )
          completionHandler(true)
        }
        
        delete.image = UIImage(named: "cards_delete.png")
        delete.backgroundColor = .clear
        

        let configuration = UISwipeActionsConfiguration(actions: [delete])
    //  configuration.performsFirstActionWithFullSwipe = false
        return configuration
        }
    
    private func handleMoveToArchive(pushID: String) {
           print("Moved to archive")
        showActivityIndicator(uiView: view)
        
         let client = APIClient.shared
             do{
               try client.deleteNotificationRequest(parametr: pushID).subscribe(
                 onNext: { [self] result in
                   print(result)
                     DispatchQueue.main.async {
                         if result.success == true {
                             requestAnswer(status: true, message: String(result.message ?? ""))
                         }
                         else {
                             requestAnswer(status: false, message: String(result.message ?? ""))
                         }
                     }
                    
                 },
                 onError: { [self] error in
                     DispatchQueue.main.async {
                         requestAnswer(status: false, message: error.localizedDescription)
                         print(error.localizedDescription)
                         
                     }
                     
                 },
                 onCompleted: { [self] in
                    // sender.hideLoading()
                     
                    print("Completed event.")
                     
                 }).disposed(by: disposeBag)
               }
               catch{
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
