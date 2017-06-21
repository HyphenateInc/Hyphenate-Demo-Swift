//
//  EMChatViewController.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/6/16.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import UIKit
import Hyphenate

class EMChatViewController: UIViewController, EMChatToolBarDelegate, EMChatManagerDelegate, EMChatroomManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate{
    

    @IBOutlet weak var tableView: UITableView!
    
    private var _chatToolBar: EMChatToolBar?
    private var _imagePickController: UIImagePickerController?
    private var _dataSource: Array<Any>?
    private var _refresh: UIRefreshControl?
    private var _backButton: UIButton?
    private var _camButton: UIButton?
    private var _audioButton: UIButton?
    private var _detailButton: UIButton?
    private var _longPressIndexPath: NSIndexPath?
    
    private var _conversaiton: EMConversation?
    private var _pervAudioModel: EMMessageModel?
    
    init(_ conversationId: String, _ conversationType: EMConversationType) {
        super.init(nibName: nil, bundle: nil)
        _conversaiton = EMClient.shared().chatManager .getConversation(conversationId, type: conversationType, createIfNotExist: true)
        _conversaiton?.markAllMessages(asRead: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _setupInstanceUI()
        view.backgroundColor = UIColor.white
        edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(endChat(withConversationId:)), name: NSNotification.Name(rawValue:KEM_END_CHAT), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteAllMessages), name: NSNotification.Name(rawValue:KNOTIFICATIONNAME_DELETEALLMESSAGE), object: nil)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(keyboradHidden))
        view.addGestureRecognizer(tap)
        
        tableView.tableFooterView = UIView()
        _refresh = refresh()
        tableView.addSubview(_refresh!)
 
        _chatToolBar!.delegate = self
        view.addSubview(_chatToolBar!)
//        _chatToolBar?.setupInput(textInfo: "test")
        
        tableViewDidTriggerHeaderRefresh()
        
        EMClient.shared().chatManager.add(self, delegateQueue: nil)
        EMClient.shared().roomManager.add(self, delegateQueue: nil)
        
        _setupNavigationBar()
        _setupViewLayout()
    }
    
    private func _setupInstanceUI() {
        tableView.delegate = self
//        tableView.dataSource = self
        _dataSource = Array<Any>()
        _refresh = refresh()
        _chatToolBar = chatToolBar()
        _backButton = backButton()
        _camButton = camButton()
        _audioButton = audioButton()
        _detailButton = detailButton()
        _imagePickController = imagePickerController()
    }
    
    // MARK: - Private Layout Views
    private func _setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: _backButton!)
        if _conversaiton?.type == EMConversationTypeChat {
            navigationItem.rightBarButtonItems = [UIBarButtonItem.init(customView: _audioButton!), UIBarButtonItem.init(customView: _camButton!)]
            title = EMUserProfileManager.sharedInstance.getNickNameWithUsername(username: (_conversaiton?.conversationId!)!)
        } else if _conversaiton?.type == EMConversationTypeGroupChat {
            navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: _detailButton!)
            title = EMConversationModel.init(conversation: _conversaiton!).title()
        } else if _conversaiton?.type == EMConversationTypeChatRoom {
            navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: _detailButton!)
        }
    }
    
    private func _setupViewLayout() {
        tableView.width(width: kScreenWidth)
        tableView.height(height: kScreenHeight - (_chatToolBar?.height())! - 64)
        
        _chatToolBar?.width(width: kScreenWidth)
        _chatToolBar?.top(top: kScreenHeight - (_chatToolBar?.height())! - 64)
    }
    
    // MARK: - Getter 
    func refresh() -> UIRefreshControl {
        let refresh = UIRefreshControl()
        refresh.tintColor = UIColor.lightGray
        refresh.addTarget(self, action: #selector(_loadMoreMessage), for: UIControlEvents.valueChanged)
        return refresh
    }
    
    func chatToolBar() -> EMChatToolBar {
        let toolBar = EMChatToolBar.instance()
        return toolBar
    }
    
    func backButton() -> UIButton {
        let btn = UIButton(type: UIButtonType.custom)
        btn.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        btn.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        btn.addTarget(self, action: #selector(backAction), for: UIControlEvents.touchUpInside)
        return btn
    }
    
    func audioButton() -> UIButton {
        let btn = UIButton(type: UIButtonType.custom)
        btn.frame = CGRect(x: 0, y: 0, width: 25, height: 15)
        btn.setImage(UIImage(named:"iconCall"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(makeAudioCall), for: UIControlEvents.touchUpInside)
        return btn
    }
    
    func camButton() -> UIButton {
        let btn = UIButton(type: UIButtonType.custom)
        btn.frame = CGRect(x: 0, y: 0, width: 25, height: 15)
        btn.setImage(UIImage(named:"iconVideo"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(makeVideoCall), for: UIControlEvents.touchUpInside)
        return btn
    }
    
    func detailButton() -> UIButton {
        let btn = UIButton(type: UIButtonType.custom)
        btn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        btn.setImage(UIImage(named:"icon_info"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(enterDetailView), for: UIControlEvents.touchUpInside)
        return btn
    }
    
    func imagePickerController() -> UIImagePickerController {
        let imgPickerC = UIImagePickerController()
        imgPickerC.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        imgPickerC.allowsEditing = false
        imgPickerC.delegate = self
        
        return imgPickerC
    }
    
    func endChat(withConversationId conversationId:String) {
        
    }
    
    func deleteAllMessages() {
        
    }
    
    func keyboradHidden(){
        
    }
    
    func _loadMoreMessage() {
    
    }
    
    // MARK: - EMChatToolBarDelegate
    func didSendText(text:String) {
    
    }
    
    func didSendAudio(recordPath: String, duration:Int) {
    
    }
    
    func didTakePhotos() {
    
    }
    
    func didSelectPhotos() {
    
    }
    
    func didSelectLocation() {
    
    }
    
    func didUpdateInputTextInfo(inputInfo: String) {
    
    }
    
    func chatToolBarDidChangeFrame(toHeight height: CGFloat) {
        UIView.animate(withDuration: 0.25) { 
            self.tableView.top(top: 0)
//            self.tableView.height(height: view.height() - height)
        }
        
        // TODO
    }
    
    // MARK: - Actions
    func tableViewDidTriggerHeaderRefresh() {
    
    }
    
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    func makeVideoCall() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:KNOTIFICATION_CALL), object: ["chatter":_conversaiton?.conversationId! as Any,"type":NSNumber.init(value: 1)])
    }
    
    func makeAudioCall() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:KNOTIFICATION_CALL), object: ["chatter":_conversaiton?.conversationId! as Any,"type":NSNumber.init(value: 0)])
    }
    
    func enterDetailView() {
        // TODO info
    }
    
    // MARK: - UITableViewDelegate & UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
