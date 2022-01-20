//
//  TabCollectionViewCell.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/5/21.
//

import UIKit

protocol CellTarifiActionDelegate{
    func didTarifTapped(for cell: TabCollectionViewCell)
}

class TabCollectionViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    let tarifView = TarifView()
    let TarifVC = MyTarifViewController()
    
    var actionDelegate: CellTarifiActionDelegate?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
  }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tarif_tab_cell", for: indexPath) as! TarifTabViewCell
        cell.separatorInset = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
     
        //cell.textLabel?.text = characters[indexPath.row]
        return cell
  }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("ggg")
        actionDelegate?.didTarifTapped(for: self)
       /* UIApplication.topViewController()?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        UIApplication.topViewController()?.navigationController?.pushViewController(ChangeTarifViewController(), animated: true) */
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }
    
    
    let table = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        contentView.addSubview(table)
        table.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 150)
        table.register(TarifTabViewCell.self, forCellReuseIdentifier: "tarif_tab_cell")
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 100
        table.estimatedRowHeight = 100
        table.alwaysBounceVertical = false
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
