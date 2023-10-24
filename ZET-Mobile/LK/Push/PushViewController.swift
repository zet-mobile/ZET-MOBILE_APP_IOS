//
//  PushViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/9/21.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import AlamofireImage

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
        
        sendRequest()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? .lightContent : .darkContent)
    }
    
    @objc func goBack() {
       // navigationController?.popViewController(animated: true)
        
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        guard let rootViewController = window.rootViewController else {
            return
        }
        
        let vc = ContainerViewController()
        vc.view.frame = rootViewController.view.frame
        vc.view.layoutIfNeeded()
        window.rootViewController = vc
        
    }
    
    func setupView() {
        view.backgroundColor = toolbarColor

        toolbar = TarifToolbarView(frame: CGRect(x: 0, y: topPadding ?? 0, width: UIScreen.main.bounds.size.width, height: 60))
        toolbar.number_user_name.text = defaultLocalizer.stringForKey(key: "Notifications")
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goBack))
        toolbar.isUserInteractionEnabled = true
        toolbar.addGestureRecognizer(tapGestureRecognizer)
        
        self.view.addSubview(toolbar)
        
        table.register(PushPhotoTypeViewCell.self, forCellReuseIdentifier: "push_photo_cell")
        table.register(PushTableViewCell.self, forCellReuseIdentifier: "push_cell")
        table.frame = CGRect(x: 0, y: 60 + (topPadding ?? 0), width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 60 + (topPadding ?? 0) + (bottomPadding ?? 0)))
        table.delegate = self
        table.dataSource = self
        table.alwaysBounceVertical = false
        table.separatorStyle = .none
        table.backgroundColor = toolbarColor
        //table.allowsSelection = false
        if notif_data.isEmpty {
            emptyView = EmptyView(frame: CGRect(x: 0, y: 30, width: table.frame.width, height: table.frame.height), text: defaultLocalizer.stringForKey(key: "no_push"))
            table.separatorStyle = .none
            table.backgroundView = emptyView
        }
        
        view.addSubview(table)
    }
    
    func sendRequest() {
        let client = APIClient.shared
            do{
              try client.getNotificationRequest().subscribe (
                onNext: { result in
                    DispatchQueue.main.async {
                        if result.notifications!.count != 0 {
                            for i in 0 ..< result.notifications!.count {
                                if result.notifications![i].service != nil {
                                    self.notif_data.append([String(result.notifications![i].id),
                                                            String(result.notifications![i].notificationId),
                                                            String(result.notifications![i].title ?? ""),
                                                            String(result.notifications![i].body ?? ""),
                                                            String(result.notifications![i].shortDescription ?? ""),
                                                            String(result.notifications![i].image ?? ""),
                                                            String(result.notifications![i].icon ?? ""),
                                                            String(result.notifications![i].statusId),
                                                            String(result.notifications![i].url ?? ""),
                                                            String(result.notifications![i].service!.id)])
                                } else {
                                    self.notif_data.append([String(result.notifications![i].id),
                                                            String(result.notifications![i].notificationId),
                                                            String(result.notifications![i].title ?? ""),
                                                            String(result.notifications![i].body ?? ""),
                                                            String(result.notifications![i].shortDescription ?? ""),
                                                            String(result.notifications![i].image ?? ""),
                                                            String(result.notifications![i].icon ?? ""),
                                                            String(result.notifications![i].statusId), ""])
                                }
                            }
                        }
                    }
                },
                onError: { error in
                   print(error.localizedDescription)
                    DispatchQueue.main.async { [self] in
                        hideActivityIndicator(uiView: self.view)
                    }
                },
                onCompleted: {
                    DispatchQueue.main.async { [self] in
                        setupView()
                        hideActivityIndicator(uiView: view)
                    }
                    
                }).disposed(by: disposeBag)
              }
              catch{
            }
    }
    
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
        print("hello")
        sender.showAnimation { [self] in
            alert.dismiss(animated: true, completion: nil)
            hideActivityIndicator(uiView: view)
        }
    }
}

extension PushViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if notif_data[indexPath.row][6] == "" && indexPath.row == show_more_tapped_ind && show_more_tapped == true  || indexPath.row == show_more_tapped_ind2 && show_more_tapped2 == true {
            return 170
        }
        else if notif_data[indexPath.row][6] != "" && indexPath.row == show_more_tapped_ind && show_more_tapped == true  || indexPath.row == show_more_tapped_ind2 && show_more_tapped2 == true {
            return 200
            
        } else {
            return 120
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notif_data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "push_photo_cell", for: indexPath) as! PushPhotoTypeViewCell
    
        if notif_data[indexPath.row][7] == "2" {
            cell.sign.isHidden = false
        }
        else {
            cell.sign.isHidden = true
        }
        
      
        
        if notif_data[indexPath.row][6] == "" {
            cell.ico_image.isHidden = true
            cell.title.frame.origin.x =  20
            cell.about.frame.origin.x = 20
            cell.icon_show_more.frame.origin.x = 20
        }
        else {
            cell.ico_image.isHidden = false
            cell.title.frame.origin.x =  70
            cell.about.frame.origin.x = 70
            
            cell.ico_image.frame.origin.y = 60

            
            cell.icon_show_more.frame.origin.x = 70
            cell.ico_image.af_setImage(withURL: URL(string: notif_data[indexPath.row][6])!)
        }
        
        if notif_data[indexPath.row][6] == ""  {
            cell.icon_show_more.isHidden = true
 
            if indexPath.row == show_more_tapped_ind && show_more_tapped == true {
                print("1 type 1")
                cell.view_cell.frame.size.height = 150
                cell.title.frame.size.height = 70
                cell.about.frame.size.height = 60
                
                cell.ico_image.frame.origin.y = 65

                cell.about.frame.origin.y = 70
                cell.about.numberOfLines = 4
                cell.icon_more.setImage(#imageLiteral(resourceName: "opened_icon"), for: UIControl.State.normal)
          
            } else {
                print("2 type 1")
                cell.view_cell.frame.size.height = 100
                cell.title.frame.size.height = 50
                cell.about.frame.size.height = 30
                
                cell.ico_image.frame.origin.y = 20

                cell.about.frame.origin.y = 60
                cell.about.numberOfLines = 1
                cell.icon_more.setImage(#imageLiteral(resourceName: "closed_icon"), for: UIControl.State.normal)
             
            }
        }
        else {
            cell.icon_show_more.isHidden = false
            if indexPath.row == show_more_tapped_ind && show_more_tapped == true {
                print("3 type 1")
                cell.view_cell.frame.size.height = 180
                cell.title.frame.size.height = 70
                cell.about.frame.size.height = 60
                
              //  cell.ico_image.frame.origin.y = 65

                cell.about.frame.origin.y = 70
                cell.about.numberOfLines = 4
                cell.icon_show_more.frame.origin.y = 110
                cell.icon_show_more.isHidden = false
                cell.icon_more.setImage(#imageLiteral(resourceName: "opened_icon"), for: UIControl.State.normal)
          
            } else {
                print("4 type 1")
                cell.view_cell.frame.size.height = 100
                cell.title.frame.size.height = 30
                cell.about.frame.size.height = 30
                cell.about.frame.origin.y = 50
                
                cell.ico_image.frame.origin.y = 32

                cell.about.numberOfLines = 1

                cell.icon_show_more.frame.origin.y = 50
                cell.icon_show_more.isHidden = true
                cell.icon_more.setImage(#imageLiteral(resourceName: "closed_icon"), for: UIControl.State.normal)
             
            }
        }
//
//        if notif_data[indexPath.row][8] == "0" {
//            cell.ico_image.isHidden = true
//            cell.title.frame.origin.x =  20
//            cell.about.frame.origin.x = 20
//            cell.icon_show_more.frame.origin.x = 20
//
//        }
//
        cell.icon_show_more.tag = indexPath.row
        cell.title.text = notif_data[indexPath.row][2]
        cell.about.text = notif_data[indexPath.row][4]
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = .clear
        cell.selectedBackgroundView = bgColorView
        
        cell.icon_show_more.addTarget(self, action: #selector(openMore), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "push_photo_cell", for: indexPath) as! PushPhotoTypeViewCell

                
        if notif_data[indexPath.row][7] == "2" {
            readPush(pushID: indexPath.row)
        }
        
        if notif_data[indexPath.row][6] != "" && show_more_tapped == false {
            print("1 type 2")
            show_more_tapped = true
            show_more_tapped_ind = indexPath.row
            cell.view_cell.frame.size.height = 180
            cell.about.frame.size.height = 60
            
            cell.ico_image.frame.origin.y = 65

            cell.about.numberOfLines = 4
            cell.icon_show_more.isHidden = false
            cell.icon_more.setImage(#imageLiteral(resourceName: "opened_icon"), for: UIControl.State.normal)
            table.reloadData()
        }
        else if notif_data[indexPath.row][6] != "" && show_more_tapped == true && show_more_tapped_ind != indexPath.row {
            print("2 type 2")
            show_more_tapped = true
            show_more_tapped_ind = indexPath.row
            cell.view_cell.frame.size.height = 180
            cell.about.frame.size.height = 60
            
            cell.ico_image.frame.origin.y = 65

            cell.about.numberOfLines = 4
            cell.icon_show_more.isHidden = false
            cell.icon_more.setImage(#imageLiteral(resourceName: "opened_icon"), for: UIControl.State.normal)
            table.reloadData()
        }
        else if notif_data[indexPath.row][6] == "" && show_more_tapped == false {
            print("3 type 2")
            show_more_tapped = true
            show_more_tapped_ind = indexPath.row
            cell.view_cell.frame.size.height = 150
            cell.about.frame.size.height = 60
            
            cell.ico_image.frame.origin.y = 65

            cell.about.numberOfLines = 4
            cell.icon_more.setImage(#imageLiteral(resourceName: "opened_icon"), for: UIControl.State.normal)
            table.reloadData()
        }
        else if notif_data[indexPath.row][6] == "" && show_more_tapped == true && show_more_tapped_ind != indexPath.row {
            print("4 type 2")
            show_more_tapped = true
            show_more_tapped_ind = indexPath.row
            cell.view_cell.frame.size.height = 150
            cell.about.frame.size.height = 60
            
            cell.ico_image.frame.origin.y = 65

            
            cell.about.numberOfLines = 4
            cell.icon_more.setImage(#imageLiteral(resourceName: "opened_icon"), for: UIControl.State.normal)
            table.reloadData()
        }
        else {
            print("5 type 2")
            show_more_tapped = false
            show_more_tapped_ind = indexPath.row
            cell.view_cell.frame.size.height = 100
            cell.about.frame.size.height = 30
            cell.about.frame.origin.y = 35
            
            cell.ico_image.frame.origin.y = 30

            cell.about.numberOfLines = 1
            cell.icon_show_more.isHidden = true
            cell.icon_more.setImage(#imageLiteral(resourceName: "closed_icon"), for: UIControl.State.normal)
            table.reloadData()
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "push_photo_cell", for: indexPath) as! PushPhotoTypeViewCell
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = .clear
        cell.selectedBackgroundView = bgColorView
        
        // Archive action
        let delete = UIContextualAction(style: .normal, title: "") { [weak self] (action, view, completionHandler) in
            self?.handleMoveToArchive(pushID: indexPath.row)
          completionHandler(true)
        }
        
        delete.image = UIImage(named: "cards_delete.png")
        delete.backgroundColor = .clear
        

        let configuration = UISwipeActionsConfiguration(actions: [delete])
    //  configuration.performsFirstActionWithFullSwipe = false
        return configuration
        }
    
    private func handleMoveToArchive(pushID: Int) {
           print("Moved to archive")
        showActivityIndicator(uiView: view)
        
         let client = APIClient.shared
             do{
               try client.deleteNotificationRequest(parametr: notif_data[pushID][0]).subscribe(
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
                     DispatchQueue.main.async { [self] in
                         hideActivityIndicator(uiView: self.view)
                     }
                     
                 },
                 onCompleted: { [self] in
                    // sender.hideLoading()
                     DispatchQueue.main.async { [self] in
                         sendRequest2()
                     }
                     
                 }).disposed(by: disposeBag)
               }
               catch{
             }
       }
    
    func sendRequest2() {
        notif_data.removeAll()
        
        let client = APIClient.shared
            do{
              try client.getNotificationRequest().subscribe(
                onNext: { result in
                  print(result)
                    DispatchQueue.main.async {
                        if result.notifications!.count != 0 {
                            for i in 0 ..< result.notifications!.count {
                                if result.notifications![i].service != nil {
                                    self.notif_data.append([String(result.notifications![i].id), String(result.notifications![i].notificationId), String(result.notifications![i].title ?? ""), String(result.notifications![i].body ?? ""), String(result.notifications![i].shortDescription ?? ""), String(result.notifications![i].image ?? ""), String(result.notifications![i].icon ?? ""), String(result.notifications![i].statusId), String(result.notifications![i].service!.id)])
                                } else {
                                    self.notif_data.append([String(result.notifications![i].id), String(result.notifications![i].notificationId), String(result.notifications![i].title ?? ""), String(result.notifications![i].body ?? ""), String(result.notifications![i].shortDescription ?? ""), String(result.notifications![i].image ?? ""), String(result.notifications![i].icon ?? ""), String(result.notifications![i].statusId), ""])
                                }
                            }
                        }
                    }
                },
                onError: { error in
                   print(error.localizedDescription)
                    DispatchQueue.main.async { [self] in
                        hideActivityIndicator(uiView: self.view)
                    }
                },
                onCompleted: {
                    DispatchQueue.main.async { [self] in
                        table.reloadData()
                    }
                   print("Completed event.")
                    
                }).disposed(by: disposeBag)
              }
              catch{
            }
    }
    
    @objc func readPush(pushID: Int) {
        print(notif_data[pushID][0])
        
         let client = APIClient.shared
             do{
               try client.postNotificationRequest(parametr: notif_data[pushID][0]).subscribe(
                 onNext: { [self] result in
                   print(result)
                     DispatchQueue.main.async {
                         if result.success == true {
                           //  sendUpdateRequest(pushID: pushID)
                         }
                         else {
                             
                         }
                     }
                    
                 },
                 onError: { [self] error in
                     DispatchQueue.main.async {
                         print(error.localizedDescription)
                         self.hideActivityIndicator(uiView: self.view)
                     }
                     
                 },
                 onCompleted: { [self] in
                     DispatchQueue.main.async { [self] in
                         sendUpdateRequest(pushID: pushID)
                     }
                     
                    print("Completed event.")
                     
                 }).disposed(by: disposeBag)
               }
               catch{
             }
       }
    
    func sendUpdateRequest(pushID: Int) {
    
        let client = APIClient.shared
            do{
              try client.getNotificationRequest().subscribe(
                onNext: { result in
                    DispatchQueue.main.async { [self] in
                        if result.notifications!.count != 0 {
                            for i in 0 ..< result.notifications!.count {
                                
                                if String(result.notifications![i].id) == notif_data[pushID][0] {
                                   
                                    
                                    notif_data[pushID][7] = String(result.notifications![i].statusId)
                                }
                            }
                        }
                    }
                },
                onError: { error in
                   print(error.localizedDescription)
                    DispatchQueue.main.async { [self] in
                        hideActivityIndicator(uiView: self.view)
                        requestAnswer(status: false, message: defaultLocalizer.stringForKey(key: "service is temporarily unavailable"))
                    }
                },
                onCompleted: {
                    DispatchQueue.main.async { [self] in
                        let indexPath = IndexPath(row: pushID, section: 0)
                        let cell = table.cellForRow(at: indexPath) as! PushPhotoTypeViewCell
                        
                        cell.sign.isHidden = true
                        //table.reloadRows(at: [indexPath], with: .none)
                        print(notif_data[pushID][7])
                       
                    }
                   print("Completed event.")
                    
                }).disposed(by: disposeBag)
              }
              catch{
            }
    }
    
    
    @objc func openMore(_  sender: UIButton) {
        // detailViewController.more_view.content.text = notif_data[trasfer_type_choosed_id][15]
        detailViewController.more_view.image.isHidden = false
    
        if notif_data[sender.tag][5] != "" {
            detailViewController.more_view.image.contentMode = .scaleAspectFit
            detailViewController.more_view.image.af_setImage(withURL: URL(string: notif_data[sender.tag][5])!)
        }
        detailViewController.more_view.title_top.text = notif_data[sender.tag][2]
        detailViewController.more_view.title_top.frame.size.height = 50
        detailViewController.more_view.title_top.numberOfLines = 2
        // detailViewController.more_view.image.frame.origin.y = 90

        detailViewController.more_view.title.isHidden = true
        detailViewController.more_view.content.text = notif_data[sender.tag][3]

        if notif_data[sender.tag].contains("0"){
            detailViewController.more_view.close_banner.setTitle(defaultLocalizer.stringForKey(key: "Close"), for: .normal)
            detailViewController.more_view.close_banner.addTarget(self, action: #selector(dismiss_view), for: .touchUpInside)
        }
        else  {
            detailViewController.more_view.close_banner.setTitle(defaultLocalizer.stringForKey(key: "Connect"), for: .normal)
            detailViewController.more_view.close_banner.addTarget(self, action: #selector(okClickDialog), for: .touchUpInside)
        }
        detailViewController.more_view.close.addTarget(self, action: #selector(dismiss_view), for: .touchUpInside)

//        let webButton = UIButton(type: .system)
//        webButton.setTitle(defaultLocalizer.stringForKey(key: "SiteForward"), for: .normal)
//        webButton.addTarget(self, action: #selector(openWeb), for: .touchUpInside)
//        detailViewController.view.addSubview(webButton)
//
//        webButton.setTitleColor(.orange, for: .normal)
//        webButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
//        webButton.frame = CGRect(x: 70, y: 500, width: 200, height: 40)
//        webButton.translatesAutoresizingMaskIntoConstraints = false
//        
//       // webButton.centerXAnchor.constraint(equalTo: detailViewController.view.centerXAnchor).isActive = true
//            //  webButton.topAnchor.constraint(equalTo: detailViewController.more_view.content.centerYAnchor, constant: 16).isActive = true
//        webButton.bottomAnchor.constraint(equalTo: detailViewController.more_view.content.centerYAnchor, constant: 54).isActive = true
//        webButton.centerXAnchor.constraint(equalTo: detailViewController.more_view.content.leftAnchor, constant: 70).isActive = true
//        


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
        }

        present(nav, animated: true, completion: nil)
    }

    
    @objc func openWeb() {
        let webViewController = UIViewController()
        let webView = UIWebView(frame: webViewController.view.bounds)
        let url = URL(string: "https://www.zet-mobile.com")!
        let request = URLRequest(url: url)
        webView.loadRequest(request)
        webView.loadRequest(request)
        webViewController.view.addSubview(webView)
        webViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: defaultLocalizer.stringForKey(key: "Close"), style: .plain, target: self, action: #selector(closeWeb))
        let webNav = UINavigationController(rootViewController: webViewController)
        webNav.modalPresentationStyle = .fullScreen
        detailViewController.present(webNav, animated: true, completion: nil)
    }
    

   

    @objc func closeWeb() {
        detailViewController.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    @objc func dismiss_view() {
        nav.dismiss(animated: true, completion: nil)
    }
    
    
    
    @objc func okClickDialog(_ sender: UIButton) {
        
        sender.showAnimation { [self] in
            alert.dismiss(animated: true, completion: nil)
            showActivityIndicator(uiView: view)
        }
    
        let parametr: [String: Any] = ["serviceId": Int(notif_data[sender.tag][9])!]
         let client = APIClient.shared
             do{
               try client.connectService(jsonBody: parametr).subscribe(
                 onNext: { [self] result in
                   
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
                         self.hideActivityIndicator(uiView: self.view)
                         requestAnswer(status: false, message: defaultLocalizer.stringForKey(key: "service is temporarily unavailable"))
                         print(error.localizedDescription)
                         
                     }
                     
                 },
                 onCompleted: { [self] in
                    // sender.hideLoading()
                     
                    print("Completed event. 333333")
                     
                 }).disposed(by: disposeBag)
               }
               catch{
             }
    }
    
    
    
}
