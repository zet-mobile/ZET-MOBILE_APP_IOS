//
//  PushViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/9/21.
//

import UIKit

class PushViewController: UIViewController {

    var toolbar = TarifToolbarView()
    
    let table = UITableView()
    
    var show_more_tapped_ind = 0
    var show_more_tapped = false
    var show_more_tapped_ind2 = 0
    var show_more_tapped2 = false
    
    var halfModalTransitioningDelegate: HalfModalTransitioningDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // showActivityIndicator(uiView: self.view)
        view.backgroundColor = toolbarColor
        toolbar = TarifToolbarView(frame: CGRect(x: 0, y: 44, width: UIScreen.main.bounds.size.width, height: 60))
        toolbar.number_user_name.text = "Уведомления"
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goBack))
        toolbar.isUserInteractionEnabled = true
        toolbar.addGestureRecognizer(tapGestureRecognizer)
        
        self.view.addSubview(toolbar)

        table.register(PushPhotoTypeViewCell.self, forCellReuseIdentifier: "push_photo_cell")
        table.register(PushTableViewCell.self, forCellReuseIdentifier: "push_cell")
        table.frame = CGRect(x: 0, y: 100, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 150)
        table.delegate = self
        table.dataSource = self
        table.alwaysBounceVertical = false
        table.separatorStyle = .none
        table.allowsSelection = false
        //table.backgroundColor =
        view.addSubview(table)
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
}

extension PushViewController: UITableViewDataSource, UITableViewDelegate,  CellPushDelegate {
    func didOpenSheetMore(for cell: PushPhotoTypeViewCell) {
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
        
    }
    
    
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
            cell.actionDelegate = (self as CellPushDelegate)
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
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "push_cell", for: indexPath) as! PushTableViewCell
            cell.actionDelegate = (self as CellPushDelegate)
           
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
    
    
}
