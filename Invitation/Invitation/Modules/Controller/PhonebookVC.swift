//
//  PhonebookVC.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 12/3/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class PhonebookVC: BaseViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pageLabel: UILabel!
    
    var count: Int = 0 {
        didSet {
            pageLabel.text = "\(count)"
        }
    }
    
    var listPhonebook = [FetchedContact]()
    var suggestContacts = [FetchedContact]()
    var closureContact: ((FetchedContact) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chọn khách mời"
        searchTextField.delegate = self
        tableView.register(ChoseContactCell.nib(), forCellReuseIdentifier: ChoseContactCell.identifier())
        getListContact()
        count = suggestContacts.count
        setShadowView(view: searchView)
    }
    
    func getListContact() {
        print("Attempting to fetch contacts")
        
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, error) in
            if let error = error {
                print("failed to request access", error)
                return
            }
            
            if granted {
                print("access granted")
                
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                do {
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                        print(contact.givenName)
                        var item = FetchedContact()
                        item.firstName = contact.givenName
                        item.lastName = contact.familyName
                        item.telephone = contact.phoneNumbers.first?.value.stringValue
                        //                        item.iconContact = contact.imageData
                        self.listPhonebook.append(item)
                        self.suggestContacts.append(item)
                        //                        self.contacts.append(FetchedContact(firstName: contact.givenName, lastName: contact.familyName, telephone: contact.phoneNumbers.first?.value.stringValue ?? "", iconContact: contact.imageData))
                    })
                } catch let error {
                    print("Failed to enumerate contact", error)
                }
            } else {
                print("access denied")
            }
        }
        //        suggestContacts = contacts
        tableView.reloadData()
    }
    
    func filterContact() {
        if searchTextField.text == "" {
            suggestContacts = listPhonebook
        } else {
            suggestContacts = listPhonebook.filter { (data: FetchedContact) in
                if let text = searchTextField.text, let name = data.firstName, let phone = data.telephone {
                    if name.lowercased().range(of: text.lowercased()) != nil || phone.lowercased().range(of: text.lowercased()) != nil {
                        return true
                    }
                }
                return false
            }
        }
        count = suggestContacts.count
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChoseContactCell.identifier(), for: indexPath) as! ChoseContactCell
        cell.infoContact = suggestContacts[indexPath.row]
        cell.fillData()
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        closureContact?(suggestContacts[indexPath.row])
        navigationController?.popViewController(animated: true)
    }

    //MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        filterContact()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        filterContact()
    }
    
}
