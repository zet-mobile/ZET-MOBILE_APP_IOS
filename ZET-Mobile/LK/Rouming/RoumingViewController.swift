//
//  RoumingViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 1/9/22.
//

import UIKit
import RxSwift
import RxCocoa
import iOSDropDown

class RoumingViewController: UIViewController, UIScrollViewDelegate {
    
    let disposeBag = DisposeBag()
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    var expandedCellPaths = Set<IndexPath>()
    
    let scrollView = UIScrollView()
    
    var toolbar = TarifToolbarView()
    var rouming_view = RoumingView()
    let table = UITableView()
    
    let TabCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(TabRoumingCollectionCell.self, forCellWithReuseIdentifier: "tabs_rouming")
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        return cv
    }()
    
    var y_pozition = 250
    var questions_data = [[String]]()
    var countries_data = [[String]]()
    var roamingOperators_data = [[String]]()
    var operatorCharges_data = [[String]]()
    
    var country_choosed = ""
    var country_choosed_id = "0"
    var roamingOperators_choosed = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = toolbarColor
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
        scrollView.backgroundColor = contentColor
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 850)
        view.addSubview(scrollView)
  
        toolbar = TarifToolbarView(frame: CGRect(x: 0, y: 44, width: UIScreen.main.bounds.size.width, height: 60))
        rouming_view = RoumingView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 896))
        
        
        self.view.addSubview(toolbar)
        scrollView.addSubview(rouming_view)
        
        toolbar.icon_back.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        toolbar.number_user_name.text = "Роуминг"
        toolbar.backgroundColor = toolbarColor
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goBack))
        toolbar.isUserInteractionEnabled = true
        toolbar.addGestureRecognizer(tapGestureRecognizer)
        
        rouming_view.tab1.frame = CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.size.width) / 2, height: 40)
        rouming_view.tab2.frame = CGRect(x: UIScreen.main.bounds.size.width / 2, y: CGFloat(0), width: UIScreen.main.bounds.size.width / 2, height: 40)
        
        rouming_view.tab1Line.frame = CGRect(x: 10, y: 45, width: (Int(UIScreen.main.bounds.size.width) / 2) - 20, height: 3)
        rouming_view.tab2Line.frame = CGRect(x: (UIScreen.main.bounds.size.width / 2) + 10, y: CGFloat(45), width: (UIScreen.main.bounds.size.width / 2) - 20, height: 3)
        
        TabCollectionView.backgroundColor = .clear
        TabCollectionView.frame = CGRect(x: 0, y: 55, width: Int(UIScreen.main.bounds.size.width), height: Int(UIScreen.main.bounds.size.height - 104))
        TabCollectionView.delegate = self
        TabCollectionView.dataSource = self
        TabCollectionView.alwaysBounceVertical = false
        scrollView.addSubview(TabCollectionView)
        
        scrollView.frame = CGRect(x: 0, y: 104, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 104)
        
    }
    
    func sendRequest() {
        let client = APIClient.shared
            do{
              try client.roumingGetRequest().subscribe(
                onNext: { result in
                  print(result)
                    DispatchQueue.main.async { [self] in
                        print(result.questions.count)
                        for i in 0 ..< result.questions.count {
                            questions_data.append([String(result.questions[i].id), String(result.questions[i].question), String(result.questions[i].answer)])
                        }
                        
                        for i in 0 ..< result.countries.count {
                            countries_data.append([String(result.countries[i].id), String(result.countries[i].countryName ?? ""), String(result.countries[i].iconUrl!)])
                        }
                    }
                },
                onError: { error in
                   print(error.localizedDescription)
                },
                onCompleted: {
                    DispatchQueue.main.async { [self] in
                        setupView()
                    }
                   print("Completed event.")
                    
                }).disposed(by: disposeBag)
              }
              catch{
            }
    }

    func getRequest() {
        let client = APIClient.shared
            do{
              try client.roamingCountriesGetRequest(parametr: country_choosed_id).subscribe(
                onNext: { result in
                  print(result)
                    DispatchQueue.main.async { [self] in
                   
                        for i in 0 ..< result.roamingOperators!.count {
                            roamingOperators_data.append([String(result.roamingOperators![i].operatorId), String(result.roamingOperators![i].operatorName), String(result.roamingOperators![i].iconUrl)])
                            
                            for j in 0 ..< result.roamingOperators![i].operatorCharges.count {
                                operatorCharges_data.append([String(result.roamingOperators![i].operatorCharges[j].price), String(result.roamingOperators![i].operatorCharges[j].description)])
                            }
                            
                            operatorCharges_data.append(["25", "hello"])
                        }
                        
                       
                    }
                },
                onError: { error in
                   print(error.localizedDescription)
                },
                onCompleted: {
                    DispatchQueue.main.async { [self] in
                        setupView()
                    }
                   print("Completed event.")
                    
                }).disposed(by: disposeBag)
              }
              catch{
            }
    }
}

extension RoumingViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tabs_rouming", for: indexPath) as! TabRoumingCollectionCell
        if indexPath.row == 0 {
            cell.contentView.isHidden = true
            table.register(RoumingTableCell.self, forCellReuseIdentifier: "roming_list_cell")
            table.frame = CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width - 20, height: 7 * 80)
            table.delegate = self
            table.dataSource = self
            table.rowHeight = UITableView.automaticDimension
            table.estimatedRowHeight = 80
            table.alwaysBounceVertical = false
            table.backgroundColor = contentColor
            cell.addSubview(table)
           
        }
        else {
            cell.contentView.isHidden = false
            // setup language field
            cell.country.text = country_choosed
            cell.country.isSearchEnable = false
            cell.country.selectedRowColor = .lightGray
            let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
            cell.country.leftView = paddingView
            cell.country.leftViewMode = .always
            cell.country.didSelect { [self] (selectedText, index, id) in
                self.country_choosed = selectedText
                self.country_choosed_id = countries_data[index][0]
                getRequest()
            }
            for i in 0 ..< countries_data.count {
                cell.country.optionArray.append(countries_data[i][1])
                cell.country.optionIds?.append(Int(countries_data[i][0])!)
                
            }
            
            // setup language field
            cell.operator_type.text = roamingOperators_choosed
            cell.operator_type.isSearchEnable = false
            cell.operator_type.selectedRowColor = .lightGray
            let paddingView2: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
            cell.operator_type.leftView = paddingView2
            cell.operator_type.leftViewMode = .always
            cell.operator_type.didSelect { [self] (selectedText, index, id) in
                self.roamingOperators_choosed = selectedText
                self.roamingOperators_choosed = countries_data[index][0]
                //getRequest()
            }
            for i in 0 ..< roamingOperators_data.count {
                cell.operator_type.optionArray.append(roamingOperators_data[i][1])
                cell.operator_type.optionIds?.append(Int(roamingOperators_data[i][0])!)
            }
            
            for i in 0 ..< operatorCharges_data.count {
                let title = UILabel()
                title.text = operatorCharges_data[i][1]
                title.frame = CGRect(x: 20, y: y_pozition, width: title.text!.count * 10, height: 25)
                title.numberOfLines = 0
                title.textColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00)
                title.font = UIFont.preferredFont(forTextStyle: .subheadline)
                title.font = UIFont.systemFont(ofSize: 15)
                title.lineBreakMode = NSLineBreakMode.byWordWrapping
                title.textAlignment = .left
                
                let title2 = UILabel()
                title2.text = operatorCharges_data[i][0]
                title2.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (title2.text!.count * 10 + 15), y: y_pozition, width: title2.text!.count * 10, height: 25)
                title2.numberOfLines = 0
                title2.textColor = colorBlackWhite
                title2.font = UIFont.preferredFont(forTextStyle: .subheadline)
                title2.font = UIFont.systemFont(ofSize: 15)
                title2.lineBreakMode = NSLineBreakMode.byWordWrapping
                title2.textAlignment = .right
                
                let title_line = UILabel()
                title_line.frame = CGRect(x: (title.text!.count * 10), y: y_pozition + 12, width: Int(UIScreen.main.bounds.size.width) - (title2.text!.count * 10) - ((title.text!.count * 10)), height: 1)
                title_line.backgroundColor = colorLightDarkGray
                
                cell.addSubview(title)
                cell.addSubview(title2)
                cell.addSubview(title_line)
                y_pozition = y_pozition + 30
            }
            
            let titleOne = UILabel()
            titleOne.text = """
            Все цены указаны в национальной валюте сомони с учетом акциза 5% и НДС 18%
                
            Все звонки тарифицируются поминутно.
            """
            titleOne.numberOfLines = 0
            titleOne.textColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1)
            titleOne.font = UIFont(name: "", size: 10)
            titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
            titleOne.textAlignment = .left
            titleOne.frame = CGRect(x: 20, y: y_pozition, width: Int(UIScreen.main.bounds.size.width) - 40, height: 100)
            titleOne.autoresizesSubviews = true
            titleOne.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            
            cell.addSubview(titleOne)
             
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
 
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == TabCollectionView {
            if indexPath.row == 0 {
                rouming_view.tab1.textColor = colorBlackWhite
                rouming_view.tab2.textColor = .gray
                rouming_view.tab1Line.backgroundColor = .orange
                rouming_view.tab2Line.backgroundColor = .clear
                
            } else {
                rouming_view.tab1.textColor = .gray
                rouming_view.tab2.textColor = colorBlackWhite
                rouming_view.tab1Line.backgroundColor = .clear
                rouming_view.tab2Line.backgroundColor = .orange
          }
       }
    }
}


extension RoumingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions_data.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "roming_list_cell", for: indexPath) as! RoumingTableCell
            
        cell.separatorInset = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
            
        if indexPath.row == 6 {
            cell.separatorInset = UIEdgeInsets.init(top: -10, left: UIScreen.main.bounds.size.width, bottom: -10, right: 0)
        }
        
        cell.titleOne.text = questions_data[indexPath.row][1]
        cell.opisanie.text = questions_data[indexPath.row][2]
        cell.opisanie.isHidden = !expandedCellPaths.contains(indexPath)
        
        cell.opisanie.frame.size.height = (CGFloat(questions_data[indexPath.row][2].count) / (UIScreen.main.bounds.width / 10)) * 10
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "roming_list_cell", for: indexPath) as! RoumingTableCell
        
        /*print("hi")
        if cell.opisanie.isHidden == true {
            print("1")
            cell.opisanie.isHidden = false
            cell.contentView.frame.size.height = 80 + ((CGFloat(questions_data[indexPath.row][2].count) / (UIScreen.main.bounds.width / 10)) * 10)
            table.rowHeight = 80 + ((CGFloat(questions_data[indexPath.row][2].count) / (UIScreen.main.bounds.width / 10)) * 10)
            table.estimatedRowHeight = 80 + ((CGFloat(questions_data[indexPath.row][2].count) / (UIScreen.main.bounds.width / 10)) * 10)
        } else {
            print("2")
            cell.opisanie.isHidden = true
            cell.contentView.frame.size.height = 80
            table.rowHeight = 80
            table.estimatedRowHeight = 80
        }*/
        
        cell.opisanie.isHidden = !cell.opisanie.isHidden
        if cell.opisanie.isHidden {
            expandedCellPaths.remove(indexPath)
            cell.contentView.frame.size.height = 80
            
        } else {
            expandedCellPaths.insert(indexPath)
            cell.contentView.frame.size.height = 80 + ((CGFloat(questions_data[indexPath.row][2].count) / (UIScreen.main.bounds.width / 10)) * 10)
        }
        
        table.beginUpdates()
        table.endUpdates()
        table.reloadRows(at: [indexPath], with: .none)
        table.deselectRow(at: indexPath, animated: false)
    }
    
}
