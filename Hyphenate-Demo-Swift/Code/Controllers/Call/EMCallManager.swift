//
//  EMCallManager.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/12/7.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import Foundation
import Hyphenate

class EMCallManager: NSObject, EMCallManagerDelegate, EMCallBaseVCDelegate{
    
    static let standard = EMCallManager()
    
    let callManager = (EMClient.shared().callManager)!
    
    var voiceViewController: EMVoiceViewController?
    
    var callSession: EMCallSession?
    override init() {
        super.init()
        setupEMCall()
    }
    
    func setupEMCall() {
        let options = EMCallOptions()
        options.isSendPushIfOffline = true
        options.offlineMessageText = "You Have a call..."
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
        
        NotificationCenter.default.post(name: NSNotification.Name(kShowCallError), object: errorStr)
    }
    
    // MARK: - CallActions
    func makeVoiceCall(caller: String?) {
        if caller == nil {
            return
        }
        weak var weakSelf = self
        showVoiceVCWith(callType: EMVoiceCallType.EMVoiceCallOut, showName: (EMUserModel.createWithHyphenateId(hyphenateId: caller!)?.nickname)!)
        callManager.start!(EMCallTypeVoice, remoteName: caller, ext: "") { (session, error) in
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
        if aSession.type == EMCallTypeVoice {
            showVoiceVCWith(callType: EMVoiceCallType.EMVoiceCallIn, showName: (EMUserModel.createWithHyphenateId(hyphenateId: aSession.remoteName)?.nickname)!)
        }else {
            
        }
    }
    
    func callDidAccept(_ aSession: EMCallSession!) {
        callSession = aSession
        if aSession.type == EMCallTypeVoice {
            voiceViewController?.callDidAccept()
        }else {
            
        }
    }
    
    func callDidEnd(_ aSession: EMCallSession!, reason aReason: EMCallEndReason, error aError: EMError!) {
        if aSession.callId == callSession?.callId {
            hiddenVoiceVC()
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
            UIView.animate(withDuration: 0.3, animations: {
                weakSelf?.voiceViewController?.view.alpha = 0
            }) { (_) in
                weakSelf?.voiceViewController?.view.removeFromSuperview()
                weakSelf?.voiceViewController = nil
            }
        }
    }
    
    // MARK: - EMCallBaseVCDelegate
    func didHungUp() {
        let error = callManager.endCall!(callSession?.callId, reason: EMCallEndReasonHangup)
        if error != nil {
            postErrorNotification(error?.errorDescription)
        }else {
            hiddenVoiceVC()
        }
    }
    
    func didAwnser() {
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
        }
    }
    
    func didMute() {
        let error = callSession?.pauseVoice()
        if error != nil {
            postErrorNotification(error?.errorDescription)
        }else {
            
        }
    }
    
    func didSpeaker() {
        
    }
}
