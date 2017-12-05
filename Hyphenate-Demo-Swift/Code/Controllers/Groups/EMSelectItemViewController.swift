//
//  EMSelectItemViewController.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/11/29.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import UIKit
import Hyphenate

protocol EMSelectItemViewControllerDelegate {
    func didSelected(item: Array<IEMUserModel>?)
}

public enum EMSelectItemType : Int {
    case showSelected
    case unShowSelected
}

class EMSelectItemViewController: UITableViewController {

    var delegate: EMSelectItemViewControllerDelegate?
    var selectedAry: Array<IEMUserModel>?
    var sectionTitles = Array<String>()
    var contacts = Array<Any>()
    var titleArray: Array<String>?
    var doneBtn: UIBarButtonItem?
    var selectType = EMSelectItemType.showSelected
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Participants"
        tableView.setEditing(true, animated: false)
        setupDataSource()
        setupNavBar()
        setupBackAction()
    }
    
    func setupNavBar() {
        doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneAction))
        doneBtn?.tintColor = KermitGreenTwoColor
        updateSelectedCount()
        navigationItem.rightBarButtonItem = doneBtn
    }
    
    override func backAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func doneAction() {
        delegate?.didSelected(item: selectedAry)
        dismiss(animated: true, completion: nil)
    }
    
    func updateSelectedCount() {
        doneBtn?.title = "Done" + "("+String(selectedAry?.count ?? 0)+")"
    }
    
    func setupDataSource() {
        var contactList = EMClient.shared().contactManager.getContacts() as! Array<String>
        if selectedAry != nil && selectType == EMSelectItemType.unShowSelected {
            let selected = selectedAry!.map({ (model) in model.hyphenateID })
            contactList = contactList.filter({ (username) -> Bool in
                return !selected.contains(username)
            })
            selectedAry = nil
        }
        sortContacts(contactList: contactList)
        weak var weakSelf = self
        DispatchQueue.main.async {
            weakSelf?.tableView.reloadData()
            weakSelf?.refreshControl?.endRefreshing()
        }

        EMUserProfileManager.sharedInstance.loadUserProfileInBackgroundWithBuddy(buddyList: contactList, saveToLocat: true) { (succeed, error) in
            if succeed {
                DispatchQueue.global().async {
                    weakSelf?.sortContacts(contactList: contactList)
                    DispatchQueue.main.async {
                        weakSelf?.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func sortContacts(contactList: Array<String>) {
        let collation =  UILocalizedIndexedCollation.current()
        var _contacts = collation.sectionTitles.map { _ in Array<EMUserModel>() }
        
        let ary = contactList.sorted { (contact1, contact2) -> Bool in
            let nickname1 = EMUserProfileManager.sharedInstance.getNickNameWithUsername(username: contact1)
            let nickname2 = EMUserProfileManager.sharedInstance.getNickNameWithUsername(username: contact2)
            return nickname1 > nickname2
        }
        
        var titlesSet = Set<String>()
        for hyphenateId in ary {
            let model = EMUserModel.createWithHyphenateId(hyphenateId: hyphenateId)
            if model != nil{
                let sectionIndex = collation.section(for: model!, collationStringSelector: #selector(getter: EMUserModel.nickname))
                titlesSet.insert(collation.sectionTitles[sectionIndex])
                _contacts[sectionIndex].append(model as! EMUserModel)
            }
        }
        
        contacts = _contacts.flatMap({ (ary) in ary.count > 0 ? ary : nil})
        sectionTitles = titlesSet.map({(str) in str}).sorted(by: <)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return  sectionTitles
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let ary = contacts[section] as! Array<Any>
        return ary.count
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var model: EMUserModel?
        model = (contacts[indexPath.section] as! Array)[indexPath.row]
        let cellItentify = "EMContactCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellItentify)
        if cell == nil {
            cell = Bundle.main.loadNibNamed("EMContactCell", owner: self, options: nil)?.first as! EMContactCell
        }
        
        (cell as! EMContactCell).set(model: model!)
        if selectedAry != nil {
            if selectedAry!.contains(where: { (selectedModel) -> Bool in
                return selectedModel.hyphenateID == model?.hyphenateID
            }) {
                tableView .selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }else {
                tableView .deselectRow(at: indexPath, animated: false)
            }
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var model: EMUserModel?
        model = (contacts[indexPath.section] as! Array)[indexPath.row]
        if selectedAry == nil {
            selectedAry = Array<IEMUserModel>()
        }
        selectedAry!.append(model!)
        updateSelectedCount()
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        var model: EMUserModel?
        model = (contacts[indexPath.section] as! Array)[indexPath.row]
        if selectedAry != nil {
            selectedAry!.remove(at: selectedAry!.index { (indexModel) -> Bool in
                return indexModel.hyphenateID == model!.hyphenateID
            }!)
        }
        
        updateSelectedCount()
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.init(rawValue: UITableViewCellEditingStyle.insert.rawValue | UITableViewCellEditingStyle.delete.rawValue)!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
