//
//  EMVideoViewController.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/12/8.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import UIKit
import Hyphenate

enum EMVideoCallType{
    case EMVideoCallIn
    case EMVideoCalling
    case EMVideoCallOut
}

class EMVideoViewController: EMCallBaseViewController {

    var viewsHidden = false
    
    @IBOutlet weak var callNameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var callCancelBtn: UIButton!
    @IBOutlet weak var callHungupBtn: UIButton!
    @IBOutlet weak var callAnswerBtn: UIButton!
    @IBOutlet weak var callBGView: UIView!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var cameraSwitchBtn: UIButton!
    @IBOutlet weak var muteBtn: UIButton!
    @IBOutlet weak var speakerBtn: UIButton!
    
    
    var remoteCameraView: EMCallRemoteView?
    var localCameraView: EMCallLocalView?
    
    var videoCallType = EMVideoCallType.EMVideoCallIn
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if remoteCameraView == nil {
            remoteCameraView = EMCallRemoteView(frame: view.bounds)
            remoteCameraView!.scaleMode = EMCallViewScaleModeAspectFill
            view.addSubview(remoteCameraView!)
            delegate?.didUpdataRemoteCameraView(remoteCameraView!)
            remoteCameraView?.isHidden = true
        }
        
        if localCameraView == nil {
            localCameraView = EMCallLocalView(frame: CGRect(x: view.width() - 90 , y: 0, width: 90, height: 120))
            view.addSubview(localCameraView!)
            delegate?.didUpdataLocalCameraView(localCameraView!)
        }
        
        view.bringSubview(toFront: callBGView)
    }
    
    func setupUI() {
        switch videoCallType {
        case .EMVideoCallIn, .EMVideoCallOut:
            if videoCallType == .EMVideoCallIn {
                callHungupBtn.isHidden = true
                callAnswerBtn.isHidden = false
                callCancelBtn.isHidden = false
            }else {
                callHungupBtn.isHidden = false
                callAnswerBtn.isHidden = true
                callCancelBtn.isHidden = true
            }

            cameraSwitchBtn.isHidden = true
            speakerBtn.isHidden = true
            muteBtn.isHidden = true
            
            break
        case .EMVideoCalling:
            callHungupBtn.isHidden = false
            callAnswerBtn.isHidden = true
            callCancelBtn.isHidden = true
            
            cameraSwitchBtn.isHidden = false
            speakerBtn.isHidden = false
            muteBtn.isHidden = false
            break
        }
    }
    
    func setupUI(_ isHidden: Bool) {
        callNameLabel.isHidden = isHidden
        timeLabel.isHidden = isHidden
        callHungupBtn.isHidden = isHidden
        cameraSwitchBtn.isHidden = isHidden
        muteBtn.isHidden = isHidden
        speakerBtn.isHidden = isHidden
    }
    
    override func timerStrWillChange(_ aTimeStr: String) {
        timeLabel.text = aTimeStr
    }
    
    override func timerStrDidChange(_ aTimeStr: String) {
        timeLabel.text = aTimeStr
    }
    
    @IBAction func hungupAction(_ sender: UIButton) {
        super.stopTimer()
        delegate?.didHungUp()
    }
    
    @IBAction func answerAction(_ sender: UIButton) {
        super.startTimer()
        delegate?.didAnswer()
        videoCallType = .EMVideoCalling
        setupUI()
    }
    
    @IBAction func switchCamera(_ sender: UIButton) {
        delegate?.didSwitchCamera(isFront: sender.isSelected)
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func speakerAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.didSpeaker(speakerOut: sender.isSelected)
    }
    
    @IBAction func muteAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.didMute(sender.isSelected)
    }
    
    @IBAction func bgTapGestureRecognizer(_ sender: UITapGestureRecognizer) {
        if videoCallType ==  EMVideoCallType.EMVideoCalling {
            viewsHidden = !viewsHidden
            setupUI(viewsHidden)
        }
    }
    
    override func callDidAccept() {
        super.callDidAccept()
        videoCallType = .EMVideoCalling
        setupUI()
    }
}
