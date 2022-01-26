//
//  CallCenterViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/2/21.
//

import UIKit
import YandexMapKit

class CallCenterViewController: UIViewController, UIScrollViewDelegate {
    
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    let scrollView = UIScrollView()
    
    var toolbar = TarifToolbarView()
    var support_view = SupportView()
    let table = UITableView()
    
    var mapView = YMKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.backgroundColor = .clear
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 850)
        view.addSubview(scrollView)
        
        setupView()
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
        view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
  
        toolbar = TarifToolbarView(frame: CGRect(x: 0, y: 44, width: UIScreen.main.bounds.size.width, height: 60))
        support_view = SupportView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 896))
        
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
        
        mapView = YMKMapView(frame: CGRect(x: 0, y: 180, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        
        self.view.addSubview(toolbar)
        scrollView.addSubview(support_view)
        scrollView.addSubview(mapView)
        //setMapView()
        //scrollView.sendSubviewToBack(mapView)
        
        toolbar.icon_back.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        toolbar.number_user_name.text = "Поддержка"
        
        table.register(SupportListCell.self, forCellReuseIdentifier: "support_list_cell")
        table.frame = CGRect(x: 10, y: 230, width: UIScreen.main.bounds.size.width - 20, height: 7 * 80)
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 80
        table.estimatedRowHeight = 80
        table.alwaysBounceVertical = false
        table.isHidden = true
        support_view.white_back.isHidden = true
        scrollView.addSubview(table)
        
        scrollView.frame = CGRect(x: 0, y: 104, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 104)
        
    }
    
    func setMapView() {
        mapView.mapWindow.map.move(
              with: YMKCameraPosition.init(target: YMKPoint(latitude: 38.85818, longitude: 71.24798), zoom: 10, azimuth: 0, tilt: 0),
              animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 0),
              cameraCallback: nil)
          let myPlace = mapView.mapWindow.map.mapObjects.addPlacemark(with: YMKPoint(latitude: 38.85818, longitude: 71.24798))
          //myPlace.setIconWith(UIImage(named: "")!)
    }

    @objc func mapClick() {
        support_view.icon1.image = UIImage(named: "Pin_alt_light")
        support_view.title1.textColor = .black
        support_view.icon2.image = UIImage(named: "list_map")
        support_view.title2.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        table.isHidden = true
        mapView.isHidden = false
        support_view.white_back.isHidden = true
    }
    
    @objc func listClick() {
        support_view.icon1.image = UIImage(named: "Pin_alt_light_gray")
        support_view.title1.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        support_view.icon2.image = UIImage(named: "list_map_orange")
        support_view.title2.textColor = .black
        table.isHidden = false
        mapView.isHidden = true
        support_view.white_back.isHidden = false
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

extension CallCenterViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "support_list_cell", for: indexPath) as! SupportListCell
            
            cell.separatorInset = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
            
            if indexPath.row == 6 {
                cell.separatorInset = UIEdgeInsets.init(top: -10, left: UIScreen.main.bounds.size.width, bottom: -10, right: 0)
            
            }
                        
            return cell
        
       
    }
    
}

extension CallCenterViewController: YMKMapObjectTapListener {
    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
    
        
       /* mapView.mapWindow.map.move(
            with: YMKCameraPosition.init(target: YMKPoint(latitude: point.latitude, longitude: point.longitude), zoom: 15, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 0),
            cameraCallback: nil)*/
 
        var message = mapObject.userData as? String
        
        message = message!.replacingOccurrences(of: ";", with: "\n")
       // message = (message! as? String)!.replacingOccurrences(of: ";", with: "\n")
       
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        alert.view.backgroundColor = UIColor.darkGray
        alert.view.alpha = 0.8
        alert.view.layer.cornerRadius = 15
        
        let close = UIAlertAction(title: "Закрыть", style:.default){ (action) in
            alert.dismiss(animated: false, completion: nil)
           /* self.mapView.mapWindow.map.move(
                with: YMKCameraPosition.init(target: YMKPoint(latitude: point.latitude, longitude: point.longitude), zoom: 15, azimuth: 0, tilt: 0),
                animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 0),
                cameraCallback: nil)*/
                
        }
        alert.addAction(close)
        self.present(alert, animated: true)
        
       /* DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            alert.dismiss(animated: true)
        }*/
        
        return true
    }
    
    
}

extension Float {
    func sign() -> Int {
        return (self < Self(0) ? -1 : 1)
    }
}
