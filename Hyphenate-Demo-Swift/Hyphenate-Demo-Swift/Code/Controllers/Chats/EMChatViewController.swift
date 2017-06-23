//
//  EMChatViewController.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/6/16.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import UIKit
import Hyphenate
import MBProgressHUD

class EMChatViewController: UIViewController, EMChatToolBarDelegate, EMChatManagerDelegate, EMChatroomManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var tableView: UITableView!
    
    private var _chatToolBar: EMChatToolBar?
    private var _imagePickController: UIImagePickerController?
    private var _dataSource: Array<EMMessageModel>?
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
        _conversaiton = EMClient.shared().chatManager.getConversation(conversationId, type: conversationType, createIfNotExist: true)
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(endChat(withConversationIdNotification:)), name: NSNotification.Name(rawValue:KEM_END_CHAT), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteAllMessages(sender:)), name: NSNotification.Name(rawValue:KNOTIFICATIONNAME_DELETEALLMESSAGE), object: nil)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(keyboardHidden(tap:)))
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(remoteGroupNotification(noti:)), name: NSNotification.Name(rawValue:KEM_REMOVEGROUP_NOTIFICATION), object: nil) // oc demo in "viewDidAppear"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var unreadMessages = Array<EMMessage>()
        if _dataSource != nil {
            for model in _dataSource! {
                if _shouldSendHasReadAck(message: model.message!, false) {
                    unreadMessages.append(model.message!)
                }
            }
            
            if unreadMessages.count > 0 {
                _sendHasReadResponse(messages: unreadMessages, true)
            }
            
            _conversaiton?.markAllMessages(asRead: nil)
        }
    }
    
    private func _setupInstanceUI() {
        tableView.delegate = self
        tableView.dataSource = self
        _dataSource = Array<EMMessageModel>()
        _refresh = refresh()
        _chatToolBar = chatToolBar()
        _backButton = backButton()
        _camButton = camButton()
        _audioButton = audioButton()
        _detailButton = detailButton()
        _imagePickController = imagePickerController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // TODO
    }
    
    deinit {
        // TODO
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
    
    // MARK: - Notification Method
    func remoteGroupNotification(noti: Notification) {
        navigationController?.popToViewController(self, animated: false)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = _dataSource![indexPath.row]
        let CellIdentifier = EMChatBaseCell.cellIdentifier(forMessageModel: model)
        var cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier)
        if cell == nil {
            cell = EMChatBaseCell.chatBaseCell(withMessageModel: model)
        }
        
        (cell as! EMChatBaseCell).set(model: model)
        
        return cell!
    }
    
    // MARK: - Table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = _dataSource![indexPath.row]
        return EMChatBaseCell.height(forMessageModel: model)
    }
    
    // MARK: - EMChatToolBarDelegate
    func chatToolBarDidChangeFrame(toHeight height: CGFloat) {
        UIView.animate(withDuration: 0.25) {
            self.tableView.top(top: 0)
            self.tableView.height(height: self.view.height() - height)
        }
        
        _scrollViewToBottom(animated: false)
    }
    func didSendText(text:String) {
        let message = EMSDKHelper.createTextMessage(text, to:(_conversaiton?.conversationId)!, _messageType(), nil)
        _sendMessage(message: message)
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
    
    // MARK: - Actions
    func tableViewDidTriggerHeaderRefresh() {
        DispatchQueue.global().async {
            self._conversaiton?.loadMessagesStart(fromId: nil, count: 20, searchDirection: EMMessageSearchDirectionUp, completion: { (messages, aError) in
                if aError == nil {
                    self._dataSource!.removeAll()
                    for msg in messages! {
                        self._addMessageToDatasource(message: msg as! EMMessage)
                    }
                    
                    self.refresh().endRefreshing()
                    self.tableView.reloadData()
                    self._scrollViewToBottom(animated: false)
                }
            })
        }
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
    
    func backAction() {
        if _conversaiton!.type == EMConversationTypeChatRoom {
            self.showHub(inView: UIApplication.shared.keyWindow!, "Leaving the chatroom...")
            EMClient.shared().roomManager.leaveChatroom(_conversaiton?.conversationId, completion: { (error) in
                self.hideHub()
                if error != nil {
                    // TODO
                }
                self.navigationController?.popToViewController(self, animated: true)
                self.navigationController?.popViewController(animated: true)
            })
        }else {
            self.navigationController?.popToViewController(self, animated: true)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func deleteAllMessages(sender: AnyObject) {
        if _dataSource!.count == 0 {
            return
        }
        
        if sender is Notification{
            let _sender = sender as! Notification
            let groupId = _sender.object as! String
            let isDelete = groupId == _conversaiton!.conversationId
            if _conversaiton?.type == EMConversationTypeChat && isDelete {
                _conversaiton!.deleteAllMessages(nil)
                _dataSource?.removeAll()
                tableView.reloadData()
            }
        }
    }
    
    func endChat(withConversationIdNotification notification: NSNotification) {
        let obj = notification.object
        if obj is String{
            let conversationId = obj as! String
            if conversationId.characters.count > 0 && conversationId == _conversaiton?.conversationId {
                backAction()
            }
        } else if obj is EMChatroom && _conversaiton?.type == EMConversationTypeChatRoom{
            let chatroom = obj as! EMChatroom
            if chatroom.chatroomId == _conversaiton?.conversationId {
                self.navigationController?.popToViewController(self, animated: true)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // MARK: - GestureRecognizer
    func keyboardHidden(tap: UITapGestureRecognizer) {
        if tap.state == UIGestureRecognizerState.ended {
            _chatToolBar?.endEditing(true)
        }
    }
    
    // MARK: - Private
    func _joinChatroom(chatroomId: String) {
        // TODO
        self.showHub(inView: view, "Joining the chatroom")
        EMClient.shared().roomManager.joinChatroom(chatroomId) { (chatroom, error) in
            self.hideHub()
            if error != nil {
                if error?.code == EMErrorChatroomAlreadyJoined {
                    
                }
            }
        }
    }
    
    func _sendMessage(message: EMMessage) {
        _addMessageToDatasource(message: message)
        tableView.reloadData()
        EMClient.shared().chatManager.send(message, progress: nil) { (message, error) in
            self.tableView.reloadData()
        }
        _scrollViewToBottom(animated: true)
    }
    
    func _addMessageToDatasource(message: EMMessage) {
        let model = EMMessageModel.init(withMesage: message)
        _dataSource?.append(model)
    }
    
    func _scrollViewToBottom(animated: Bool) {
        if tableView.contentSize.height > tableView.height() {
            let point = CGPoint(x: 0, y: tableView.contentSize.height - tableView.height())
            tableView.setContentOffset(point, animated: true)
        }
    }
    
    func _loadMoreMessage() {
        DispatchQueue.global().async {
            var messageId = ""
            if (self._dataSource?.count)! > 0 {
                let model = self._dataSource?[0]
                messageId = model!.message!.messageId
            }
            
            self._conversaiton?.loadMessagesStart(fromId: messageId.characters.count > 0 ? messageId : nil, count: 20, searchDirection: EMMessageSearchDirectionUp, completion: { (messages, error) in
                if error == nil {
                    for message in messages as! Array<EMMessage> {
                        let model = EMMessageModel.init(withMesage: message)
                        self._dataSource?.insert(model, at: 0)
                    }
                }
                self._refresh?.endRefreshing()
                self.tableView.reloadData()

            })
        }
    }
    
    // TODO _convert2Mp4
    
    func _sendHasReadResponse(messages: Array<EMMessage>, _ isRead: Bool) {
        var unreadMessage = Array<EMMessage>()
        for message in messages {
            let isSend = _shouldSendHasReadAck(message: message, isRead)
            if isSend {
                unreadMessage.append(message)
            }
        }
        
        if unreadMessage.count > 0 {
            for message in unreadMessage {
                EMClient.shared().chatManager .sendMessageReadAck(message, completion: nil)
            }
        }
    }
    
    func _shouldSendHasReadAck(message: EMMessage,_ isRead: Bool) -> Bool {
        let account = EMClient.shared().currentUsername
        if message.chatType != EMChatTypeChat || message.isReadAcked || account != message.from || UIApplication.shared.applicationState == UIApplicationState.background {
            return false
        }
        
        let body = message.body
        switch body!.type {
        case EMMessageBodyTypeVideo, EMMessageBodyTypeVoice, EMMessageBodyTypeImage:
            if !isRead {
                return false
            }else {
                return true
            }
        default:
            return true
        }
    }
    
    func _shouldMarkMessageAsRead() -> Bool{
        var isMark = true
        if UIApplication.shared.applicationState == UIApplicationState.background {
            isMark = false
        }
        return isMark
    }
    
    func _messageType() -> EMChatType {
        var type = EMChatTypeChat
        switch _conversaiton!.type {
        case EMConversationTypeChat:
            type = EMChatTypeChat
            break
        case EMConversationTypeGroupChat:
            type = EMChatTypeGroupChat
            break
        case EMConversationTypeChatRoom:
            type = EMChatTypeChatRoom
            break
        default: break
        }
        
        return type
    }
    
    // MARK: - EMChatManagerDelegate
    
    func messagesDidReceive(_ aMessages: [Any]!) {
        for var message in aMessages {
            message = message as! EMMessage
            if _conversaiton?.conversationId == (message as AnyObject).conversationId {
                _addMessageToDatasource(message: message as! EMMessage)
                _sendHasReadResponse(messages: [message as! EMMessage], false)
                if _shouldMarkMessageAsRead() {
                    _conversaiton!.markMessageAsRead(withId: (message as AnyObject).messageId, error: nil)
                }
            }
        }
        
        tableView.reloadData()
        _scrollViewToBottom(animated: true)
    }
    
    func messageAttachmentStatusDidChange(_ aMessage: EMMessage!, error aError: EMError!) {
        if _conversaiton?.conversationId == aMessage.conversationId {
            tableView.reloadData()
        }
    }
    
    func messagesDidRead(_ aMessages: [Any]!) {
        for var message in aMessages {
            message = message as! EMMessage
            if _conversaiton?.conversationId == (message as AnyObject).conversationId {
                tableView.reloadData()
                break
            }
        }
    }
    
    // MARK: - EMChatManagerChatroomDelegate
    func userDidJoin(_ aChatroom: EMChatroom!, user aUsername: String!) {
        show(aUsername + " join chatroom " + aChatroom.chatroomId)
    }
    
    func userDidLeave(_ aChatroom: EMChatroom!, user aUsername: String!) {
        show(aUsername + " leave chatroom " + aChatroom.chatroomId)
    }
    
    func didDismiss(from aChatroom: EMChatroom!, reason aReason: EMChatroomBeKickedReason) {
        if _conversaiton?.conversationId == aChatroom.chatroomId {
            show("be removed from chatroom " + aChatroom.chatroomId)
            navigationController?.popToViewController(self, animated: false)
            navigationController?.popViewController(animated: true)
        }
    }
}
