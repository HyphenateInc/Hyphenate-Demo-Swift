//
//  EMCreateGroupViewController.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/11/29.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import UIKit

class EMCreateGroupViewController: UITableViewController, EMSelectItemViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var subjectLabel: UITextField!
    @IBOutlet weak var membersCollection: UICollectionView!
    
    
    var selectedItems: Array<IEMUserModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
    }
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectPhotoAction(_ sender: UIButton) {
        
    }
    
    @IBAction func addItemAction(_ sender: UIButton) {
        let selectItemVC = EMSelectItemViewController()
        selectItemVC.selectedDic = {
            var dic = Dictionary<String, IEMUserModel>()
            if selectedItems != nil {
                for model in selectedItems! {
                    dic[model.hyphenateID!] = model
                }
            }
            return dic
        }()
        selectItemVC.delegate = self
        let nav = UINavigationController.init(rootViewController: selectItemVC)
        present(nav, animated: true, completion: nil)
    }
    
    @IBAction func appearSwitchChangeAction(_ sender: UISwitch) {
        
    }
    
    @IBAction func inviteSwitchChangeAction(_ sender: UISwitch) {
        
    }
    
    // MARK: - EMSelectItemViewControllerDelegate
    func didSelected(item: Array<IEMUserModel>) {
        selectedItems = item
        membersCollection.reloadData()
    }
    
    
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else {
            return selectedItems?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView .dequeueReusableCell(withReuseIdentifier: "EMMemberCollectionCell", for: indexPath)
        cell.backgroundColor = UIColor.red
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView .deselectItem(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let selectItemVC = EMSelectItemViewController()
            selectItemVC.selectedDic = {
                var dic = Dictionary<String, IEMUserModel>()
                if selectedItems != nil {
                    for model in selectedItems! {
                        dic[model.hyphenateID!] = model
                    }
                }
                return dic
            }()
            selectItemVC.delegate = self
            let nav = UINavigationController.init(rootViewController: selectItemVC)
            present(nav, animated: true, completion: nil)
        } else {
            
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.width() / 7, height: collectionView.width() / 7)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 25, left: 15, bottom: 15, right: 5)
        } else {
            return UIEdgeInsets(top: 25, left: 5, bottom: 15, right: 15)
        }
    }
}
