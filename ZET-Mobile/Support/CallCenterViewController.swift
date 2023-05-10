//
//  CallCenterViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/2/21.
//

import UIKit
import YandexMapKit
import RxSwift
import RxCocoa
import Alamofire
import AlamofireImage

var officesdata = [[String]]()
var supportdata = [[String]]()

class CallCenterViewController: UIViewController, UIScrollViewDelegate {
    
    let disposeBag = DisposeBag()
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    var halfModalTransitioningDelegate: HalfModalTransitioningTwoDelegate?
    var nav = UINavigationController()
    
    var alert = UIAlertController()
    let scrollView = UIScrollView()
    
    var toolbar = TarifToolbarView()
    var support_view = SupportView()
    let table = UITableView()
    let table2 = UITableView()
    
    let SupportCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(SupportCollectionViewCell.self, forCellWithReuseIdentifier: "SupportCollectionCell")
        cv.showsHorizontalScrollIndicator = false
        
        return cv
    }()
    
    var x_pozition = 25
    var long = ""
    var lat = ""
    var mapView = YMKMapView()
    var y_pozition = 150
    
    var tableData = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = YMKMapView(frame: CGRect(x: 0, y: 215 + 60 + (topPadding ?? 0), width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        
        mapView.mapWindow.map.mapType = .map
        
        view.backgroundColor = toolbarColor
        
        setupView()
        print("officesdata.count")
        print(officesdata.count)
        
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? .lightContent : .darkContent)
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
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 850)
        scrollView.isScrollEnabled = false
        
        view.addSubview(scrollView)
        
        toolbar = TarifToolbarView(frame: CGRect(x: 0, y: (topPadding ?? 0), width: UIScreen.main.bounds.size.width, height: 60))
        support_view = SupportView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(mapClick))
        support_view.title1.isUserInteractionEnabled = true
        support_view.title1.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(listClick))
        support_view.title2.isUserInteractionEnabled = true
        support_view.title2.addGestureRecognizer(tapGestureRecognizer2)
        
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(mapClick))
        support_view.icon1.isUserInteractionEnabled = true
        support_view.icon1.addGestureRecognizer(tapGestureRecognizer3)
        
        let tapGestureRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(listClick))
        support_view.icon2.isUserInteractionEnabled = true
        support_view.icon2.addGestureRecognizer(tapGestureRecognizer4)
        
        
        self.view.addSubview(toolbar)
        self.view.addSubview(mapView)
        scrollView.addSubview(support_view)
        
        setMapView()
        
        toolbar.icon_back.isHidden = true
        toolbar.number_user_name.text = defaultLocalizer.stringForKey(key: "Support")
        
        if supportdata.count !=  0  {
            support_view.number.text = supportdata[0][1]
        }
    
        let tapGestureRecognizer5 = UITapGestureRecognizer(target: self, action: #selector(numberClick))
        support_view.number.isUserInteractionEnabled = true
        support_view.number.addGestureRecognizer(tapGestureRecognizer5)
        
       // mapView.backgroundColor = .clear
       // support_view.white_background.backgroundColor = UIColor(red: 0.98, green: 0.97, blue: 0.95, alpha: 1.00)
        /* if let url = URL(string: "tel://800"), UIApplication.shared.canOpenURL(url) {
         if #available(iOS 10, *) {
             UIApplication.shared.open(url)
         } else {
             UIApplication.shared.openURL(url)
         }
     }*/
        SupportCollectionView.backgroundColor = .clear
        SupportCollectionView.frame = CGRect(x: 0, y: 80, width: Int(UIScreen.main.bounds.size.width), height: 50)
        SupportCollectionView.delegate = self
        SupportCollectionView.dataSource = self
        SupportCollectionView.alwaysBounceVertical = false
        SupportCollectionView.isHidden = false
        scrollView.addSubview(SupportCollectionView)
        
        table.register(SupportListCell.self, forCellReuseIdentifier: "support_list_cell")
        table.frame = CGRect(x: 10, y: 230, width: UIScreen.main.bounds.size.width - 10, height: UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 290 + (topPadding ?? 0) + (bottomPadding ?? 0)))
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 100
        table.estimatedRowHeight = 100
        table.alwaysBounceVertical = false
        table.isHidden = true
        table.backgroundColor = .clear
        support_view.white_back.isHidden = true
        scrollView.addSubview(table)
        
        scrollView.frame = CGRect(x: 0, y: 60 + (topPadding ?? 0), width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 60 + (topPadding ?? 0) + (bottomPadding ?? 0)))
        
    }
    
    @objc func numberClick(_ sender: UIButton) {
        if let url = URL(string: "tel://\(supportdata[0][2])"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       // support_view.frame.origin.y = scrollView.contentOffset.y
        //SupportCollectionView.frame.origin.y =  scrollView.contentOffset.y + 80
        //table.frame.origin.y =  scrollView.contentOffset.y + 230
        
        if table == scrollView{
            if scrollView.contentOffset.y > support_view.white_view_back.frame.origin.y {
                SupportCollectionView.isHidden = true
                support_view.title_info.isHidden = true
                support_view.number.isHidden = true
                support_view.white_view_back.frame.origin.y = 0
                support_view.white_background.frame.origin.y = 30
                support_view.white_back.frame.origin.y = 30
              //  mapView.frame.origin.y = 130 + (topPadding ?? 0)
                table.frame.origin.y = 70
                table.frame.size.height = UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 130 + (topPadding ?? 0) + (bottomPadding ?? 0))
            }
            if scrollView.contentOffset.y < -10 && SupportCollectionView.isHidden == true {
                SupportCollectionView.isHidden = false
                support_view.title_info.isHidden = false
                support_view.number.isHidden = false
                support_view.white_view_back.frame.origin.y = 150
                support_view.white_background.frame.origin.y = 180
                support_view.white_back.frame.origin.y = 180
              //  mapView.frame.origin.y = 215 + 60 + (topPadding ?? 0)
                table.frame.origin.y = 230
                table.frame.size.height = UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 290 + (topPadding ?? 0) + (bottomPadding ?? 0))
            }
        }
    }
    
    func setMapView() {
        
        mapView.mapWindow.map.mapObjects.clear()
        if (long !=  "" && lat != "") {
            print("illll")
            mapView.mapWindow.map.move(with: YMKCameraPosition.init(target: YMKPoint(latitude: Double(lat)!, longitude: Double(long)!), zoom: 13, azimuth: 0, tilt: 0),animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 0),cameraCallback: nil)
            
            let myPlace = mapView.mapWindow.map.mapObjects.addPlacemark(with: YMKPoint(latitude: Double(lat)!, longitude: Double(long)!))
            myPlace.setIconWith(UIImage(named: "Ellipse")!)
            
        }
        else {
            mapView.mapWindow.map.move(
                with: YMKCameraPosition.init(target: YMKPoint(latitude: 38.53575, longitude: 68.77905), zoom: 12, azimuth: 0, tilt: 0),
                animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 0),
                cameraCallback: nil)
        }
       // let myPlace = mapView.mapWindow.map.mapObjects.addPlacemark(with: YMKPoint(latitude: 38.85818, longitude: 71.24798))
       // myPlace.setIconWith(UIImage(named: "myLL.png")!)
        
        let mapObjects = self.mapView.mapWindow.map.mapObjects
        mapObjects.clear()
        if (officesdata.count != 0) {
            var placeMark = mapObjects.addPlacemark(with: YMKPoint(latitude: Double(officesdata[0][4])!, longitude: Double(officesdata[0][5])!))
          
            placeMark.userData = officesdata[0][0] + "&" + officesdata[0][1]
            placeMark.setIconWith(UIImage(named: "Location.png")!)
            placeMark.addTapListener(with: self)
          
            for i in 1 ..< officesdata.count - 1 {
                placeMark = mapObjects.addPlacemark(with: YMKPoint(latitude: Double(officesdata[i][4])!, longitude: Double(officesdata[i][5])!))
                if ((officesdata[i][6]) == "2") {
                    placeMark.setIconWith(UIImage(named: "Location.png")!)
                }
                else {
                    placeMark.setIconWith(UIImage(named: "ecc.png")!)
                }
                placeMark.addTapListener(with: self)
                placeMark.userData = officesdata[i][0] + "&" + officesdata[i][1]
        }
      }
   }
    
    @objc func mapClick() {
        support_view.icon1.image = UIImage(named: "Pin_alt_light")
        support_view.title1.textColor = colorBlackWhite
        support_view.icon2.image = UIImage(named: "list_map")
        support_view.title2.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        table.isHidden = true
        mapView.isHidden = false
        support_view.white_back.isHidden = true
        
        SupportCollectionView.isHidden = false
        support_view.title_info.isHidden = false
        support_view.number.isHidden = false
        support_view.white_view_back.frame.origin.y = 150
    }
    
    @objc func listClick() {
        support_view.icon1.image = UIImage(named: "Pin_alt_light_gray")
        support_view.title1.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        support_view.icon2.image = UIImage(named: "list_map_orange")
        support_view.title2.textColor = colorBlackWhite
        table.isHidden = false
        mapView.isHidden = true
        support_view.white_back.isHidden = false
        
        SupportCollectionView.isHidden = false
        support_view.title_info.isHidden = false
        support_view.number.isHidden = false
        support_view.white_view_back.frame.origin.y = 150
        support_view.white_background.frame.origin.y = 180
        support_view.white_back.frame.origin.y = 180
        table.frame.origin.y = 230
        table.frame.size.height = UIScreen.main.bounds.size.height -
        (ContainerViewController().tabBar.frame.size.height + 290 + (topPadding ?? 0) + (bottomPadding ?? 0))
        table.reloadData()
    }
    
    func onObjectAdded(with view: YMKUserLocationView) {
        view.arrow.setIconWith(UIImage(named:"UserArrow")!)
        
        let pinPlacemark = view.pin.useCompositeIcon()
        
        pinPlacemark.setIconWithName("icon",
                                     image: UIImage(named:"Icon")!,
                                     style:YMKIconStyle(
                                        anchor: CGPoint(x: 0, y: 0) as NSValue,
                                        rotationType:YMKRotationType.rotate.rawValue as NSNumber,
                                        zIndex: 0,
                                        flat: true,
                                        visible: true,
                                        scale: 1.5,
                                        tappableArea: nil))
        
        pinPlacemark.setIconWithName(
            "pin",
            image: UIImage(named:"SearchResult")!,
            style:YMKIconStyle(
                anchor: CGPoint(x: 0.5, y: 0.5) as NSValue,
                rotationType:YMKRotationType.rotate.rawValue as NSNumber,
                zIndex: 1,
                flat: true,
                visible: true,
                scale: 1,
                tappableArea: nil))
        
        view.accuracyCircle.fillColor = UIColor.blue
    }
    
    
    func onObjectRemoved(with view: YMKUserLocationView) {}
    
    func onObjectUpdated(with view: YMKUserLocationView, event: YMKObjectEvent) {}
    
}

extension CallCenterViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return CGSize(width: collectionView.frame.width * 0.15, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return supportdata.count - 1

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SupportCollectionCell", for: indexPath) as! SupportCollectionViewCell
        
        if supportdata[indexPath.row + 1][3] != "" {
            cell.button.af_setImage(for: .normal, url: URL(string: supportdata[indexPath.row + 1][3])!, placeholderImage: nil, filter: nil, progress: nil, progressQueue: DispatchQueue.main.self, completion: nil)
        }
        else {
            if supportdata[indexPath.row + 1][1] == "Facebook" {
                cell.button.setImage(UIImage(named: "facebook"), for: .normal)
            }
            else if supportdata[indexPath.row + 1][1] == "VK" {
                cell.button.setImage(UIImage(named: "vks"), for: .normal)
            }
            else if supportdata[indexPath.row + 1][1] == "Instagram" {
                cell.button.setImage(UIImage(named: "instagrams"), for: .normal)
            }
            else if supportdata[indexPath.row + 1][1] == "Telegram" {
                cell.button.setImage(UIImage(named: "telegrams"), for: .normal)
            }
            else if supportdata[indexPath.row + 1][1] == "OK" {
                cell.button.setImage(UIImage(named: "telegrams"), for: .normal)
            }
        }
        
        cell.button.tag = indexPath.row
        cell.button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(supportdata[indexPath.row + 1][2])
        //open(scheme: supportdata[indexPath.row + 1][2])
    }
    
    @objc func buttonClick(_ sender: UIButton) {
        print(supportdata[sender.tag + 1][2])
        open(scheme: supportdata[sender.tag + 1][2])
    }
}

extension CallCenterViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == table {
            return officesdata.count
        }
        else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == table {
            let cell = tableView.dequeueReusableCell(withIdentifier: "support_list_cell", for: indexPath) as! SupportListCell
                
            cell.separatorInset = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
                
            if indexPath.row == officesdata.count - 1 {
                cell.separatorInset = UIEdgeInsets.init(top: -10, left: UIScreen.main.bounds.size.width, bottom: -10, right: 0)
            
            }
            
            cell.titleOne.text = officesdata[indexPath.row][1]
            cell.titleTwo.text = officesdata[indexPath.row][0]
            
            if officesdata[indexPath.row][1].count > 25 {
                cell.titleTwo.frame.origin.y = 60
            }
            else {
                cell.titleTwo.frame.origin.y = 50
            }
            
            let bgColorView = UIView()
            bgColorView.backgroundColor = .clear
            cell.selectedBackgroundView = bgColorView
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DialogOfficesViewCell", for: indexPath) as! DialogOfficesViewCell
            
            cell.ico_image.image = UIImage(named: tableData[indexPath.row][0])
            cell.titleOne.text = tableData[indexPath.row][1]
            //cell.textLabel?.text = characters[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        mapView.mapWindow.map.move(
            with: YMKCameraPosition.init(target: YMKPoint(latitude: Double(officesdata[indexPath.row][4])!, longitude: Double(officesdata[indexPath.row][5])!), zoom: 13, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 0),
            cameraCallback: nil)
        
        support_view.icon1.image = UIImage(named: "Pin_alt_light")
        support_view.title1.textColor = colorBlackWhite
        support_view.icon2.image = UIImage(named: "list_map")
        support_view.title2.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        table.isHidden = true
        mapView.isHidden = false
        support_view.white_back.isHidden = true
        
        SupportCollectionView.isHidden = false
        support_view.title_info.isHidden = false
        support_view.number.isHidden = false
        support_view.white_view_back.frame.origin.y = 150
        mapView.frame.origin.y = 215 + 60 + (topPadding ?? 0)
        table.frame.origin.y = 230
        table.frame.size.height = UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 290 + (topPadding ?? 0) + (bottomPadding ?? 0))
    }
    
}

extension CallCenterViewController: YMKMapObjectTapListener {
    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
      
        var office_choosed = mapObject.userData as? String
        var office_choosed_array = office_choosed!.components(separatedBy: "&")
        choosed_office_name = office_choosed_array[1]
        choosed_office_time = office_choosed_array[0]
       
        tableData.removeAll()
        tableData.append(["Home_light", choosed_office_name])
        tableData.append(["Time_light", choosed_office_time])
        
        alert = UIAlertController(title: "\n\n\n\n\n\n", message: "", preferredStyle: .actionSheet)
        let widthConstraints = alert.view.constraints.filter({ return $0.firstAttribute == .width })
        alert.view.removeConstraints(widthConstraints)
        // Here you can enter any width that you want
        let newWidth = UIScreen.main.bounds.width
        // Adding constraint for alert base view
        let widthConstraint = NSLayoutConstraint(item: alert.view,
                                                     attribute: .width,
                                                     relatedBy: .equal,
                                                     toItem: nil,
                                                     attribute: .notAnAttribute,
                                                     multiplier: 1,
                                                     constant: newWidth)
        alert.view.addConstraint(widthConstraint)
        
        let view = DialogOfficesView()

        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 180)
        view.layer.cornerRadius = 20
        view.close.addTarget(self, action: #selector(close_view), for: .touchUpInside)
        
        table2.frame = CGRect(x:5, y: 60, width: Int(UIScreen.main.bounds.size.width) - 10, height: 80)
        table2.register(DialogOfficesViewCell.self, forCellReuseIdentifier: "DialogOfficesViewCell")
        table2.delegate = self
        table2.dataSource = self
        table2.rowHeight = 40
        table2.estimatedRowHeight = 40
        table2.alwaysBounceVertical = false
        table2.separatorStyle = .none
        table2.isScrollEnabled = false
        table2.backgroundColor = .clear
        table2.allowsSelection =  false
        
        alert.view.backgroundColor = .clear
        alert.view.addSubview(view)
        alert.view.addSubview(table2)
        table2.reloadData()
        present(alert, animated: true, completion: nil)
        
        return true
    }
    
    @objc func close_view() {
        alert.dismiss(animated: true, completion: nil)
    }
    
}

extension Float {
    func sign() -> Int {
        return (self < Self(0) ? -1 : 1)
    }
}
