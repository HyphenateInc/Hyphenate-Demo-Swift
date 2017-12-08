//
//  EMVoiceViewController.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/12/6.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import UIKit
import Hyphenate

enum EMVoiceCallType{
    case EMVoiceCallIn
    case EMVoiceCalling
    case EMVoiceCallOut
}

class EMVoiceViewController: EMCallBaseViewController {
    
    var voiceCallType = EMVoiceCallType.EMVoiceCallIn
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var callNameLabel: UILabel!
    @IBOutlet weak var callCancelBtn: UIButton!
    @IBOutlet weak var callHungupBtn: UIButton!
    @IBOutlet weak var callAnswerBtn: UIButton!
    @IBOutlet weak var speakerBtn: UIButton!
    @IBOutlet weak var muteBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        timeLabel.text = "Calling..."
    }
    
    func setupUI() {
        switch voiceCallType {
        case .EMVoiceCallIn, .EMVoiceCallOut:
            if voiceCallType == .EMVoiceCallIn {
                callHungupBtn.isHidden = true
                callAnswerBtn.isHidden = false
                callCancelBtn.isHidden = false
            }else {
                callHungupBtn.isHidden = false
                callAnswerBtn.isHidden = true
                callCancelBtn.isHidden = true
            }
            
            speakerBtn.isHidden = true
            muteBtn.isHidden = true
            
            break
        case .EMVoiceCalling:
            callHungupBtn.isHidden = false
            callAnswerBtn.isHidden = true
            callCancelBtn.isHidden = true
            
            speakerBtn.isHidden = false
            muteBtn.isHidden = false
            
            break
        }
    }
    
    func connected() {
        
    }
    
    override func timerStrWillChange(_ aTimeStr: String) {
        timeLabel.text = aTimeStr
    }
    
    override func timerStrDidChange(_ aTimeStr: String) {
        timeLabel.text = aTimeStr
    }
    
    @IBAction func speakerAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.didSpeaker(speakerOut: sender.isSelected)
    }
    
    @IBAction func muteAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.didMute(sender.isSelected)
    }

    @IBAction func hungupAction(_ sender: UIButton) {
        super.stopTimer()
        delegate?.didHungUp()
    }
    
    @IBAction func answerAction(_ sender: UIButton) {
        super.startTimer()
        delegate?.didAnswer()
        voiceCallType = .EMVoiceCalling
        setupUI()
    }
    
    override func callDidAccept() {
        super.callDidAccept()
        voiceCallType = .EMVoiceCalling
        setupUI()
    }
    
}
