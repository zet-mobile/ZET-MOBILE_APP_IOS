//
//  AboutAppViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 1/8/22.
//

import UIKit
import RxCocoa
import RxSwift

class AboutAppViewController: UIViewController , UIScrollViewDelegate {
    
    let disposeBag = DisposeBag()
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    var halfModalTransitioningDelegate: HalfModalTransitioningDelegate?
    
    let scrollView = UIScrollView()
    var alert = UIAlertController()
    
    var toolbar = TarifToolbarView()
    var about_view = AboutAppView()
    let table = UITableView()

    var table_data = [[String]]()
    override func viewDidLoad() {
        super.viewDidLoad()

        showActivityIndicator(uiView: self.view)
        
        sendRequest()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 11.0, *) {
            scrollView.scrollIndicatorInsets = view.safeAreaInsets
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.safeAreaInsets.bottom, right: 0)
        } else {
            // Fallback on earlier versions
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        }
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupView() {
        view.backgroundColor = toolbarColor
  
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.backgroundColor = .clear
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        scrollView.isScrollEnabled = false
        view.addSubview(scrollView)
        
        
        toolbar = TarifToolbarView(frame: CGRect(x: 0, y: 44, width: UIScreen.main.bounds.size.width, height: 60))
        about_view = AboutAppView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 896))
        
        let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject?
        let version = nsObject as! String
        let nsObject2: AnyObject? = Bundle.main.infoDictionary!["CFBundleVersion"] as AnyObject?
        let build = nsObject2 as! String
        about_view.version_app.text = "v. " + version + " (" + build + ")"
        
        self.view.addSubview(toolbar)
        scrollView.addSubview(about_view)
        
        toolbar.icon_back.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        toolbar.number_user_name.text = "О приложении"
        
        about_view.button.addTarget(self, action: #selector(openCondition), for: .touchUpInside)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goBack))
        toolbar.isUserInteractionEnabled = true
        toolbar.addGestureRecognizer(tapGestureRecognizer)
        
        table.register(AboutViewCell.self, forCellReuseIdentifier: "about_cell")
        table.frame = CGRect(x: 10, y: CGFloat((Int(UIScreen.main.bounds.size.height) * 250) / 844), width: UIScreen.main.bounds.size.width - 20, height: (UIScreen.main.bounds.size.height * 320) / 844)
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 80
        table.estimatedRowHeight = 80
        table.alwaysBounceVertical = false
        table.backgroundColor = contentColor
        scrollView.addSubview(table)
        
        scrollView.frame = CGRect(x: 0, y: 60 + (topPadding ?? 0), width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 60 + (topPadding ?? 0) + (bottomPadding ?? 0)))
        
    }
    
    @objc func openCondition(_ sender: UIButton) {
        sender.showAnimation { [self] in
            let next = ConditionViewController()
            next.view.frame = (view.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)))
            self.halfModalTransitioningDelegate = HalfModalTransitioningDelegate(viewController: self, presentingViewController: next)
            next.modalPresentationStyle = .custom
            next.modalPresentationCapturesStatusBarAppearance = true
            
            next.transitioningDelegate = self.halfModalTransitioningDelegate
            present(next, animated: true, completion: nil)
        }
    }

    func sendRequest() {
        
        let client = APIClient.shared
            do{
                try client.aboutGetRequest().subscribe(
                onNext: { result in
                  print(result)
                    DispatchQueue.main.async {
                        
                        if result.data.count != 0 {
                            for i in 0 ..< result.data.count {
                                self.table_data.append([String(result.data[i].id), String(result.data[i].title), String(result.data[i].description), String(result.data[i].url)])
                            }
                        }
                        
                    }
                },
                onError: { error in
                   print(error.localizedDescription)
                    self.requestAnswer(message: error.localizedDescription)
                },
                onCompleted: {
                    DispatchQueue.main.async {
                        self.setupView()
                        self.hideActivityIndicator(uiView: self.view)
                    }
                   print("Completed event.")
                    
                }).disposed(by: disposeBag)
              }
              catch{
            }
    }
    
    @objc func requestAnswer(message: String) {
        
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
        view.name.text = "Что-то пошло не так"
        view.image_icon.image = UIImage(named: "uncorrect_alert")
        view.name_content.text = "\(message)"
        view.ok.setTitle("OK", for: .normal)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissDialog))
        view.name.isUserInteractionEnabled = true
        view.name.addGestureRecognizer(tapGestureRecognizer)
        
        view.cancel.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
        view.ok.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
        
        alert.view.backgroundColor = .clear
        alert.view.addSubview(view)
        //alert.view.sendSubviewToBack(view)
        
        present(alert, animated: true, completion: nil)

    }
    
    @objc func dismissDialog() {
        alert.dismiss(animated: true, completion: nil)
    }
}

extension AboutAppViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return table_data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "about_cell", for: indexPath) as! AboutViewCell
        cell.separatorInset = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
            
        if indexPath.row == table_data.count - 1 {
            cell.separatorInset = UIEdgeInsets.init(top: -10, left: UIScreen.main.bounds.size.width, bottom: -10, right: 0)
        }
        
        cell.titleOne.text = table_data[indexPath.row][1]
        cell.titleTwo.text = table_data[indexPath.row][2]
        
        return cell
        
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if table_data[indexPath.row][0] == "1" {
            open(scheme: table_data[indexPath.row][3])
        }
        else if table_data[indexPath.row][0] == "2"  {
            open(scheme: table_data[indexPath.row][3])
        }
        else if table_data[indexPath.row][0] == "3"  {
            open(scheme: table_data[indexPath.row][3])
        }
        else if table_data[indexPath.row][0] == "4"  {
            open(scheme: table_data[indexPath.row][3])
        }
    }
    
}

