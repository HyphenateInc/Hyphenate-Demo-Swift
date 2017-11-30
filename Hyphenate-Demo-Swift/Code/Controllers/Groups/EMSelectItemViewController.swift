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
    func didSelected(item: Array<IEMUserModel>)
}

class EMSelectItemViewController: UITableViewController {

    var delegate: EMSelectItemViewControllerDelegate?
    var selectedAry = Array<IEMUserModel>()
    var sectionTitles = Array<String>()
    var contacts = Array<Any>()
    var titleArray: Array<String>?
    
    var doneBtn: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.setEditing(true, animated: false)
        setupDataSource()
        setupNavBar()
    }
    
    func setupNavBar() {
        title = "Add Participants"
        let leftBtn = UIButton(type: UIButtonType.custom)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        leftBtn.setImage(UIImage(named:"Icon_Back"), for: .normal)
        leftBtn.setImage(UIImage(named:"Icon_Back"), for: .highlighted)
        leftBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
        

        doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneAction))
        doneBtn?.tintColor = KermitGreenTwoColor
        updateSelectedCount()
        navigationItem.rightBarButtonItem = doneBtn
    }
    
    @objc func backAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func doneAction() {
        delegate?.didSelected(item: Array(selectedAry))
        dismiss(animated: true, completion: nil)
    }
    
    func updateSelectedCount() {
        doneBtn?.title = "Done" + "("+String(selectedAry.count)+")"
    }
    
    func setupDataSource() {
        let contacts = EMClient.shared().contactManager.getContacts()
        sortContacts(contactList: contacts as! Array<String>)
        weak var weakSelf = self
        DispatchQueue.main.async {
            weakSelf?.tableView.reloadData()
            weakSelf?.refreshControl?.endRefreshing()
        }

        EMUserProfileManager.sharedInstance.loadUserProfileInBackgroundWithBuddy(buddyList: contacts as! Array<String>, saveToLocat: true) { (succeed, error) in
            if succeed {
                DispatchQueue.global().async {
                    weakSelf?.sortContacts(contactList: contacts as! Array<String>)
                    DispatchQueue.main.async {
                        weakSelf?.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func sortContacts(contactList: Array<String>) {
        let collation =  UILocalizedIndexedCollation.current()
        let _sectionTitles = NSMutableArray.init(array: collation.sectionTitles)
        let _contacts = NSMutableArray()
        for _ in 0..<_sectionTitles.count {
            _contacts.add(Array<EMUserModel>())
        }
        
        let ary = contactList.sorted { (contact1, contact2) -> Bool in
            let nickname1 = EMUserProfileManager.sharedInstance.getNickNameWithUsername(username: contact1)
            let nickname2 = EMUserProfileManager.sharedInstance.getNickNameWithUsername(username: contact2)
            return nickname1 > nickname2
        }
        
        for hyphenateId in ary {
            let model = EMUserModel.createWithHyphenateId(hyphenateId: hyphenateId)
            if model != nil{
                let sectionIndex = collation.section(for: model!, collationStringSelector: #selector(getter: EMUserModel.nickname))
                var array = _contacts[sectionIndex] as! Array<EMUserModel>
                array.append(model as! EMUserModel)
                _contacts[sectionIndex] = array
            }
        }
        
        var indexSet: NSMutableIndexSet?
        for (idx, obj) in _contacts.enumerated() {
            let _obj = (obj as! Array<Any>)
            if _obj.count == 0 {
                if indexSet == nil {
                    indexSet = NSMutableIndexSet.init()
                }
                indexSet?.add(idx)
            }
        }
        
        if indexSet != nil {
            _contacts.removeObjects(at: indexSet! as IndexSet)
            _sectionTitles.removeObjects(at: indexSet! as IndexSet)
        }
        
        sectionTitles = _sectionTitles as! Array<String>
        contacts = _contacts as! Array<Any>
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
        if selectedAry.contains(where: { (selectedModel) -> Bool in
            return selectedModel.hyphenateID == model?.hyphenateID
        }) {
            tableView .selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }else {
            tableView .deselectRow(at: indexPath, animated: false)
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var model: EMUserModel?
        model = (contacts[indexPath.section] as! Array)[indexPath.row]
        selectedAry.append(model!)
        updateSelectedCount()
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        var model: EMUserModel?
        model = (contacts[indexPath.section] as! Array)[indexPath.row]
  
        selectedAry.remove(at: selectedAry.index { (indexModel) -> Bool in
            return indexModel.hyphenateID == model!.hyphenateID
            }!)
        
        updateSelectedCount()
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.init(rawValue: UITableViewCellEditingStyle.insert.rawValue | UITableViewCellEditingStyle.delete.rawValue)!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
