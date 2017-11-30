//
//  EMCreateGroupViewController.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/11/29.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import UIKit
import Hyphenate
import MBProgressHUD

class EMCreateGroupViewController: UITableViewController, EMSelectItemViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var membersCollection: UICollectionView!
    @IBOutlet weak var participantsLabel: UILabel!
    @IBOutlet weak var publicSwitch: UISwitch!
    @IBOutlet weak var otherSwitch: UISwitch!
    @IBOutlet weak var otherLabel: UILabel!
    
    
    let maxCount = 2000
    let currentAccount = EMClient.shared().currentUsername
    
    var selectedItems: Array<IEMUserModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupForDismissKeyboard()
        setupNavBar()
        tableView.tableFooterView = UIView()
        membersCollection.register(UINib(nibName: "EMMemberCollectionCell", bundle: nil), forCellWithReuseIdentifier: "EMMemberCollectionCell")
    }
    
    func setupNavBar() {
        title = "New Group"
        let leftBtn = UIButton(type: UIButtonType.custom)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        leftBtn.setImage(UIImage(named:"Icon_Back"), for: .normal)
        leftBtn.setImage(UIImage(named:"Icon_Back"), for: .highlighted)
        leftBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        let leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let rigetBarButtonItem = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(createGroup))
        rigetBarButtonItem.tintColor = KermitGreenTwoColor
        navigationItem.rightBarButtonItem = rigetBarButtonItem
    }
    
    @objc func createGroup() {
        let groupSettngs = EMGroupOptions()
        groupSettngs.maxUsersCount = maxCount
        if publicSwitch.isOn {
            groupSettngs.style = otherSwitch.isOn ? EMGroupStylePublicOpenJoin : EMGroupStylePublicJoinNeedApproval
        }else {
            groupSettngs.style = otherSwitch.isOn ? EMGroupStylePrivateMemberCanInvite : EMGroupStylePrivateOnlyOwnerInvite
        }
        weak var weakSelf = self
        
        let invitees = selectedItems?.map({ (model) -> String in
            model.hyphenateID
        })

        view.endEditing(true)
        
        MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow, animated: true)
        EMClient.shared().groupManager.createGroup(withSubject: subjectTextField.text, description: descriptionTextField.text, invitees: invitees, message: nil, setting: groupSettngs) { (group, error) in
            MBProgressHUD.hideAllHUDs(for: UIApplication.shared.keyWindow, animated: true)
            if error == nil {
                weakSelf?.show("Send succeed")
                NotificationCenter.default.post(name: NSNotification.Name(KEM_REFRESH_GROUPLIST_NOTIFICATION), object: nil)
            }else {
                weakSelf?.show((error?.errorDescription)!)
            }
        }
    }
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectPhotoAction(_ sender: UIButton) {
        showAlert("Unsuppend")
    }

    @IBAction func appearSwitchChangeAction(_ sender: UISwitch) {
        if  sender.isOn {
            otherLabel.text = "Join the group freely"
        }else {
            otherLabel.text = "Allow members to invite"
        }
    }

    
    // MARK: - EMSelectItemViewControllerDelegate
    func didSelected(item: Array<IEMUserModel>) {
        selectedItems = Array(item.reversed())
        participantsLabel.text = "Participants: " + String(selectedItems!.count + 1) + "/2000"
        membersCollection.reloadData()
    }
    
    
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0,1:
            return 1
        default:
            return selectedItems?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView .dequeueReusableCell(withReuseIdentifier: "EMMemberCollectionCell", for: indexPath) as! EMMemberCollectionViewCell
        switch indexPath.section {
        case 0:
            cell.setupModel(model: nil)
            break
        case 1:
            cell.setupModel(model: EMUserModel.createWithHyphenateId(hyphenateId: currentAccount!))
            break
        default:
            cell.setupModel(model: selectedItems![indexPath.row])
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView .deselectItem(at: indexPath, animated: true)
        switch indexPath.section{
        case 0:
            let selectItemVC = EMSelectItemViewController()
            selectItemVC.selectedAry = Array((selectedItems ?? Array<IEMUserModel>()).reversed())
            selectItemVC.delegate = self
            let nav = UINavigationController.init(rootViewController: selectItemVC)
            present(nav, animated: true, completion: nil)
            break
        case 1:
            break
        default:
            selectedItems?.remove(at: indexPath.row)
            participantsLabel.text = "Participants: " + String(selectedItems!.count + 1) + "/2000"
            collectionView.deleteItems(at: [indexPath])
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 45 , height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 25, left: 17, bottom: 5, right: 5)
        } else {
            return UIEdgeInsets(top: 25, left: 5, bottom: 5, right: 15)
        }
    }
}
