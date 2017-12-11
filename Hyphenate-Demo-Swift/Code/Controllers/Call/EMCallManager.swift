//
//  EMCallManager.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/12/7.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import Foundation
import Hyphenate
import AVFoundation

class EMCallManager: NSObject, EMCallManagerDelegate, EMCallBaseVCDelegate{
    
    let nickname = EMClient.shared().pushOptions.displayName
    
    static let standard = EMCallManager()
    
    let callManager = (EMClient.shared().callManager)!
    
    var voiceViewController: EMVoiceViewController?
    
    var videoViewController: EMVideoViewController?
    
    var callSession: EMCallSession?
    
    override init() {
        super.init()
        setupEMCall()
    }
    
    func setupEMCall() {
        let options = EMCallOptions()
        options.isSendPushIfOffline = true
        options.offlineMessageText = "Incoming video call..."
        options.videoResolution = EMCallVideoResolutionAdaptive
        callManager.setCallOptions!(options)
        callManager.add!(self, delegateQueue: nil)
    }
    
    deinit {
        callManager.remove!(self)
    }
    
    func postErrorNotification(_ errorStr: String?) {
        if errorStr == nil {
            return
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(kShowEMCallError), object: errorStr)
    }
    
    // MARK: - CallActions
    func makeVoiceCall(caller: String?) {
        if caller == nil {
            return
        }
        weak var weakSelf = self
        showVoiceVCWith(callType: EMVoiceCallType.EMVoiceCallOut, showName: (EMUserModel.createWithHyphenateId(hyphenateId: caller!)?.nickname)!)
        callManager.start!(EMCallTypeVoice, remoteName: caller, ext: nickname) { (session, error) in
            if error == nil {
                weakSelf?.callSession = session
            }
        }
    }
    
    func makeVideoCall(caller: String?) {
        if caller == nil {
            return
        }
        weak var weakSelf = self
        showVideoVCWith(callType: EMVideoCallType.EMVideoCallOut, showName: (EMUserModel.createWithHyphenateId(hyphenateId: caller!)?.nickname)!)
        callManager.start!(EMCallTypeVideo, remoteName: caller, ext: nickname) { (session, error) in
            if error == nil {
                weakSelf?.callSession = session
            }
        }
    }
    
    
    // MARK: - EMCallManagerDelegate
    func callDidReceive(_ aSession: EMCallSession!) {
        if voiceViewController != nil {
            let _ = callManager.endCall!(aSession.callId, reason: EMCallEndReasonBusy)
            return
        }
        callSession = aSession
        var remoteName = aSession.ext
        if remoteName?.count == 0 {
            remoteName  = (EMUserModel.createWithHyphenateId(hyphenateId: aSession.remoteName)?.nickname)!
        }
        if aSession.type == EMCallTypeVoice {
            showVoiceVCWith(callType: EMVoiceCallType.EMVoiceCallIn, showName: remoteName!)
        }else {
            showVideoVCWith(callType: EMVideoCallType.EMVideoCallIn, showName: remoteName!)
        }
    }
    
    func callDidAccept(_ aSession: EMCallSession!) {
        callSession = aSession
        if aSession.type == EMCallTypeVoice {
            voiceViewController?.callDidAccept()
        }else {
            videoViewController?.remoteCameraView?.isHidden = false
            videoViewController?.callDidAccept()
        }
    }
    
    func callDidEnd(_ aSession: EMCallSession!, reason aReason: EMCallEndReason, error aError: EMError!) {
        if aSession.callId == callSession?.callId {
            if aSession.type == EMCallTypeVoice {
                hiddenVoiceVC()
            }else {
                hiddenVideoVC()
            }
        }
    }
    
    func callDidConnect(_ aSession: EMCallSession!) {
        voiceViewController?.connected()
    }
    
    func showVoiceVCWith(callType: EMVoiceCallType, showName: String) {
        voiceViewController = EMVoiceViewController()
        voiceViewController?.voiceCallType = callType
        voiceViewController?.delegate = self
        voiceViewController?.view.alpha = 0
        voiceViewController?.view.frame = (UIApplication.shared.keyWindow?.bounds)!
        weak var weakSelf = self
        UIApplication.shared.keyWindow?.addSubview((voiceViewController?.view)!)
        voiceViewController?.callNameLabel.text = showName
        UIView.animate(withDuration: 0.3, animations: { weakSelf?.voiceViewController?.view.alpha = 1 })
    }
    
    func hiddenVoiceVC() {
        if voiceViewController != nil {
            weak var weakSelf = self
            voiceViewController?.stopTimer()
            let time = voiceViewController?.timeStr
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                UIView.animate(withDuration: 0.3, animations: {
                    weakSelf?.voiceViewController?.view.alpha = 0
                }) { (_) in
                    weakSelf?.voiceViewController?.view.removeFromSuperview()
                    weakSelf?.voiceViewController = nil
                }
            })
            
            addCallHistory(time!)
            callSession = nil
        }
    }
    
    func showVideoVCWith(callType: EMVideoCallType, showName: String) {
        videoViewController = EMVideoViewController()
        videoViewController?.videoCallType = callType
        videoViewController?.delegate = self
        videoViewController?.view.alpha = 0
        videoViewController?.view.frame = (UIApplication.shared.keyWindow?.bounds)!
        weak var weakSelf = self
        UIApplication.shared.keyWindow?.addSubview((videoViewController?.view)!)
        videoViewController?.callNameLabel.text = showName
        UIView.animate(withDuration: 0.3, animations: { weakSelf?.videoViewController?.view.alpha = 1 })
    }
    
    func hiddenVideoVC() {
        if videoViewController != nil {
            weak var weakSelf = self
            videoViewController?.stopTimer()
            let time = videoViewController?.timeStr
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                UIView.animate(withDuration: 0.3, animations: {
                    weakSelf?.videoViewController?.view.alpha = 0
                }) { (_) in
                    weakSelf?.videoViewController?.view.removeFromSuperview()
                    weakSelf?.videoViewController = nil
                }
            })
            
            addCallHistory(time!)
        }
    }
    
    func addCallHistory(_ time: String) {
        
        let conversation = EMClient.shared().chatManager.getConversation(callSession?.remoteName, type: EMConversationTypeChat, createIfNotExist: true)
        let msgBody = EMTextMessageBody(text: time)
        var msg: EMMessage?
        if callSession!.isCaller {
            msg = EMMessage(conversationID: callSession?.remoteName, from: callSession?.localName, to: callSession?.remoteName, body: msgBody, ext: nil)
            msg?.direction = EMMessageDirectionSend
        }else {
            msg = EMMessage(conversationID: callSession?.remoteName, from: callSession?.remoteName, to: callSession?.localName, body: msgBody, ext: nil)
            msg?.direction = EMMessageDirectionReceive
        }
        msg?.isDeliverAcked = true
        msg?.isReadAcked = true
        msg?.isRead = true
        msg?.status = EMMessageStatusSucceed
        conversation?.insert(msg, error: nil)
        NotificationCenter.default.post(name: NSNotification.Name(KEM_UPDATE_CONVERSATIONS), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(KEM_ADD_CALLHISTORY), object: msg)
    }
    
    // MARK: - EMCallBaseVCDelegate
    func didHungUp() {
        let error = callManager.endCall!(callSession?.callId, reason: EMCallEndReasonHangup)
        if error != nil {
            postErrorNotification(error?.errorDescription)
        }else {
            hiddenVoiceVC()
            hiddenVideoVC()
        }
    }
    
    func didAnswer() {
        let error = callManager.answerIncomingCall!(callSession?.callId)
        if error != nil {
            postErrorNotification(error?.errorDescription)
        }else {
            
        }
    }
    
    func didReject() {
        let error = callManager.endCall!(callSession?.callId, reason: EMCallEndReasonHangup)
        if error != nil {
            postErrorNotification(error?.errorDescription)
        }else {
            hiddenVoiceVC()
            hiddenVideoVC()
        }
    }
    
    func didMute(_ isMute: Bool) {
        var error: EMError?
        if isMute {
            error = callSession?.pauseVoice()
        } else {
            error = callSession?.resumeVoice()
        }
        if error != nil {
            postErrorNotification(error?.errorDescription)
        }else {
            
        }
    }
    
    func didSpeaker(speakerOut isSpeaker: Bool) {
        let audioSession = AVAudioSession.sharedInstance()
        if isSpeaker {
            try! audioSession.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
        }else {
            try! audioSession.overrideOutputAudioPort(AVAudioSessionPortOverride.none)
        }
        try! audioSession.setActive(true)
    }

    func didSwitchCamera(isFront: Bool) {
        callSession?.switchCameraPosition(isFront)
    }
    
    func didPauseVideo(_ isPause: Bool) {
        var error: EMError?
        if isPause {
            error = callSession?.pauseVideo()
        } else {
            error = callSession?.resumeVideo()
        }
        if error != nil {
            postErrorNotification(error?.errorDescription)
        }else {
            
        }
    }
    
    func didUpdateLocalCameraView(_ cameraView: UIView) {
        callSession?.localVideoView = cameraView as! EMCallLocalView
    }
    
    func didUpdateRemoteCameraView(_ cameraView: UIView) {
        callSession?.remoteVideoView = cameraView as! EMCallRemoteView
    }
}
