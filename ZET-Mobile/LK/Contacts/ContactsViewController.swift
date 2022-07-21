//
//  ContactsViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 13/05/22.
//

import UIKit
import Contacts
import ContactsUI

struct ContactStruct {
    let givenName: String
    let familyName: String
    let number: String
}

var to_phone = ""

class ContactsViewController: UIViewController {

    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    var vc = MobileTransferViewController()
    var toolbar = TarifToolbarView()
    var contactsView = ContactsView()
    let table = UITableView()
    
    var contactStore = CNContactStore()
    var contacts = [ContactStruct]()
    var filterContacts = [ContactStruct]()
    var countContact = 0
    
    var tableData1 = [[String]]()
    var tableData2 = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //showActivityIndicator(uiView: self.view)
        view.backgroundColor = contentColor
        fetchContacts()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationController?.tabBarController?.tabBar.isHidden = true
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? .lightContent : .darkContent)
    }
 
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func fetchContacts() {
        // 1.
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { [self] (granted, error) in
            if let error = error {
                print("failed to request access", error)
                return
            }
            if granted {
                // 2.
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                do {
                    // 3.
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                        
                        var number = contact.phoneNumbers.first?.value.stringValue ?? ""
                        number = number.trimmingCharacters(in: .whitespaces)
                        
                        number = number.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
                        number = number.replacingOccurrences(of: "(", with: "", options: NSString.CompareOptions.literal, range: nil)
                        number = number.replacingOccurrences(of: ")", with: "", options: NSString.CompareOptions.literal, range: nil)
                        number = number.replacingOccurrences(of: "-", with: "", options: NSString.CompareOptions.literal, range: nil)
                        
                        if number.prefix(4) == "+992" {
                            number = number.replacingOccurrences(of: number.prefix(4), with: "", options: NSString.CompareOptions.literal, range: nil)
                        }
                        else if number.prefix(3) == "992" {
                            number = number.replacingOccurrences(of: number.prefix(3), with: "", options: NSString.CompareOptions.literal, range: nil)
                            
                        }
                        
                        if  number.prefix(3) == "911" || number.prefix(3) == "915" || number.prefix(3) == "917" || number.prefix(3) == "919" || number.prefix(2) == "80" || number.prefix(2) == "40"  {
                          
                            print(number)
                            self.tableData1.append([String(contact.givenName), String(contact.familyName), String(number)])
                            self.tableData2.append([String(contact.givenName), String(contact.familyName), String(number)])
                        }
                        
                         /*if str == "911" || str == "915" || str == "917" || str == "919" || str2 == "80" || str2 == "40" || str3 == "(911)" || str3 == "(915)" || str3 == "(917)" || str3 == "(919)" || str3 == "(80)" || str3 == "(40)" || str == "992" || str4 == "+992" {
                             self.contacts.append(ContactStruct(givenName: contact.givenName, familyName: contact.familyName, number: contact.phoneNumbers.first?.value.stringValue ?? ""))
                        }*/
                        
                    })
                    setupView()
                } catch let error {
                    print("Failed to enumerate contact", error)
                }
            } else {
                print("access denied")
            }
        }
    }
    
    func setupView() {
        view.backgroundColor = contentColor
        
        toolbar = TarifToolbarView(frame: CGRect(x: 0, y: 44, width: UIScreen.main.bounds.size.width, height: 60))
        contactsView = ContactsView(frame: CGRect(x: 0, y: 104, width: UIScreen.main.bounds.size.width, height: 896))
        contactsView.searchField.delegate = self
        
        toolbar.icon_back.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goBack))
        toolbar.isUserInteractionEnabled = true
        toolbar.addGestureRecognizer(tapGestureRecognizer)
        
        toolbar.number_user_name.text = defaultLocalizer.stringForKey(key: "ZetContacts")
        toolbar.backgroundColor = contentColor
        
        table.register(ContactsTableViewCell.self, forCellReuseIdentifier: "contacts")
        table.frame = CGRect(x: 10, y: 80, width: UIScreen.main.bounds.size.width - 20, height: UIScreen.main.bounds.size.height - (140 + (topPadding ?? 0) + (bottomPadding ?? 0)))
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 70
        table.estimatedRowHeight = 70
        table.alwaysBounceVertical = false
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = contentColor
        
        self.view.addSubview(toolbar)
        contactsView.addSubview(table)
        self.view.addSubview(contactsView)
        
        hideActivityIndicator(uiView: view)
    }
}

extension ContactsViewController: UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        contactsView.searchField.resignFirstResponder()
         
         return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        contactsView.searchField.placeholder = ""
        contactsView.searchField.setView(.left, image: nil)
        let close = contactsView.searchField.setView(.right, image: UIImage(named: "close_icon"))
        close.addTarget(self, action: #selector(clearAll), for: .touchUpInside)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        contactsView.searchField.resignFirstResponder()
        contactsView.searchField.endEditing(true)
        contactsView.searchField.setView(.left, image: UIImage(named: "Search"))
        contactsView.searchField.setView(.right, image: nil)
        contactsView.searchField.placeholder = "Искать номер"
        tableData1 = tableData2
        table.reloadData()
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{

        var searchText  = textField.text! + string

        tableData1.removeAll()
        
        if string  == "" {
            searchText = (searchText as String).substring(to: searchText.index(before: searchText.endIndex))
        }
        
        tableData1 = searchText.isEmpty ? tableData2 : tableData2.filter { (dataArray:[String]) -> Bool in
            return dataArray.filter({ (string) -> Bool in
                return string.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }).count > 0
        }
        
        table.reloadData()

        return true
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contacts", for: indexPath) as! ContactsTableViewCell
        cell.titleOne.text = tableData1[indexPath.row][0] + " " + tableData1[indexPath.row][1]
        cell.titleTwo.text = tableData1[indexPath.row][2]
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.00) : UIColor(red: 1.00, green: 0.98, blue: 0.94, alpha: 1.00))
        bgColorView.layer.borderColor = UIColor.orange.cgColor
        bgColorView.layer.borderWidth = 1
        bgColorView.layer.cornerRadius = 10
        cell.selectedBackgroundView = bgColorView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        to_phone = tableData1[indexPath.row][2]
        navigationController?.popViewController(animated: true)
    }
    
    func updateNumber() {
        vc.table.reloadData()
        vc.table.beginUpdates()
        vc.table.endUpdates()
        navigationController?.popViewController(animated: true)
    }
    
    @objc func clearAll() {
        if contactsView.searchField.text != "" {
            contactsView.searchField.text = ""
            tableData1 = tableData2
            table.reloadData()
        }
        else {
            contactsView.searchField.resignFirstResponder()
            contactsView.searchField.endEditing(true)
            contactsView.searchField.setView(.left, image: UIImage(named: "Search"))
            contactsView.searchField.setView(.right, image: nil)
            contactsView.searchField.placeholder = "Искать номер"
            tableData1 = tableData2
            table.reloadData()
        }
    }
}

class ContactsView: UIView {

    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    lazy var searchField: UITextField = {
        let textfield = UITextField()
        textfield.keyboardType = .numberPad
        textfield.frame = CGRect(x: 20, y: 5, width: UIScreen.main.bounds.size.width - 40, height: 50)
        textfield.borderStyle = .none
        textfield.backgroundColor = .clear
        textfield.layer.cornerRadius = 20
        textfield.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        textfield.layer.borderWidth = 1
        textfield.placeholder = "Искать номер"
        textfield.setView(.left, image: UIImage(named: "Search"))
        return textfield
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        
    }
    
    private func setupView() {
        backgroundColor = contentColor
     
        self.addSubview(searchField)
    }
}
