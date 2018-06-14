//
//  ViewController.swift
//  ContactsApp
//
//  Created by Yerkegali Abubakirov on 08.06.2018.
//  Copyright © 2018 Yerkegali Abubakirov. All rights reserved.
//

import UIKit
import Contacts

class ViewController: UITableViewController {
    
    let cellId = "cellId"
    
    func someMethod(cell: UITableViewCell) {
        print("Some method")
        guard let indexPathTapped = tableView.indexPath(for: cell) else { return }
        
        let contact = twoDimensionsArray[indexPathTapped.section].names[indexPathTapped.row]
        print(contact)
        
        let hasFavorited = contact.hasFavorited
        
        twoDimensionsArray[indexPathTapped.section].names[indexPathTapped.row].hasFavorited = !hasFavorited
        print(contact)
        
//        tableView.reloadRows(at: [indexPathTapped], with: .fade)
        
        cell.accessoryView?.tintColor = hasFavorited ? UIColor.lightGray : .red
    }
    
    var twoDimensionsArray = [ExpandableNames]()
    
//    var twoDimensionsArray = [
//        ExpandableNames(isExpanded: true, names: ["Jack", "Till", "RDA", "JSP", "Yoel", "TWood", "Brian", "Maks"].map{ FavoritableContact(name: $0, hasFavorited: false) }),
//        ExpandableNames(isExpanded: true, names: ["Chris", "Cerone", "Cab", "Christina", "Cameron", "Carl"].map{ FavoritableContact(name: $0, hasFavorited: false) }),
//        ExpandableNames(isExpanded: true, names: ["Derek", "David"].map{ FavoritableContact(name: $0, hasFavorited: false) }),
//        ExpandableNames(isExpanded: true, names: [FavoritableContact(name: "Patrick", hasFavorited: false)]),
//
//        ]
    
    private func fetchContacts() {
        
        let store = CNContactStore()
        
        store.requestAccess(for: .contacts) { (granted, err) in
            if let err = err {
                print("ERROOOORRRRR", err)
                return
            }
            
            if granted {
                
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                do {
                    
                    var favoritableContact = [FavoritableContact]()
                    
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointerIfYouWantToStopEnumerating) in
                        print(contact.givenName)
                        print(contact.familyName)
                        print(contact.phoneNumbers.first?.value.stringValue ?? "")
                        
                        favoritableContact.append(FavoritableContact(contact: contact, hasFavorited: false))
                        
//                        favoritableContact.append(FavoritableContact(name: contact.givenName + "" + contact.familyName, hasFavorited: false))

                    })
                
                    let names = ExpandableNames(isExpanded: true, names: favoritableContact)
                    self.twoDimensionsArray = [names]
                    self.tableView.reloadData()
                    
                } catch let err {
                    print("FAILLLL", err)
                }
                print("Access printed")
            } else {
                print("Access denied")
            }
            
        }
        
    }
    
    var showIndexPath = false
    
    @objc func handleShowIndexPath() {
        var indexPathToReload = [IndexPath]()
        for section in twoDimensionsArray.indices {
            for row in twoDimensionsArray[section].names.indices {
                print(section, row)
                let indexPath = IndexPath(row: row, section: section)
                indexPathToReload.append(indexPath)
            }
        }
        
        showIndexPath = !showIndexPath
        
        let animationStyle = showIndexPath ? UITableViewRowAnimation.right: .left
        
        tableView.reloadRows(at: indexPathToReload, with: animationStyle)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchContacts()
        navigationItem.title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show IndexPath", style: .plain, target: self, action: #selector(handleShowIndexPath))
        tableView.register(ContactCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let button = UIButton(type: .system)
        button.setTitle("Close", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor.yellow
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleOpenClose), for: .touchUpInside)
        
        button.tag = section
        
        return button
    }
    
    @objc func handleOpenClose(button: UIButton) {
        
        let section = button.tag
        var indexPaths = [IndexPath]()
        for row in twoDimensionsArray[section].names.indices {
            let indexpath  = IndexPath(row: row, section: section)
            indexPaths.append(indexpath)
        }
        
        let isExpanded = twoDimensionsArray[section].isExpanded
        twoDimensionsArray[section].isExpanded = !isExpanded
        
        button.setTitle(isExpanded ? "Open" : "Close", for: .normal)
        
        if isExpanded {
            tableView.deleteRows(at: indexPaths, with: .fade)
        } else {
            tableView.insertRows(at: indexPaths, with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return twoDimensionsArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if !twoDimensionsArray[section].isExpanded {
            return 0
        }
        
        return twoDimensionsArray[section].names.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ContactCell
        
        let cell = ContactCell(style: .subtitle, reuseIdentifier: cellId)
        
        cell.link = self
        let favoritableContact = twoDimensionsArray[indexPath.section].names[indexPath.row]
        
        cell.textLabel?.text = favoritableContact.contact.givenName + "" + favoritableContact.contact.familyName

        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        cell.detailTextLabel?.text = favoritableContact.contact.phoneNumbers.first?.value.stringValue

        cell.accessoryView?.tintColor = favoritableContact.hasFavorited ? UIColor.red : .lightGray
        
        if showIndexPath {
//            cell.textLabel?.text = "\(favoritableContact.name)"
        }
        
        return cell
    }
}

