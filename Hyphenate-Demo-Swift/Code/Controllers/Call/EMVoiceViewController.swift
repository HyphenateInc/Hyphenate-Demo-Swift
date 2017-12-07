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
    var timer: Timer?
    var time = 0
    
    var timeStr : String{
        get {
            let hour = time / 3600
            let min = (time - hour * 3600) / 60
            let sec = time - hour * 3600 - min * 60
            return String(format: "%02d", hour) + ":" + String(format: "%02d", min) + ":" + String(format: "%02d", sec)
        }
    }
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var callNameLabel: UILabel!
    @IBOutlet weak var callCancelBtn: UIButton!
    @IBOutlet weak var callHungupBtn: UIButton!
    @IBOutlet weak var callAnswerBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        timeLabel.text = "Calling..."
    }
    
    func setupUI() {
        switch voiceCallType {
        case .EMVoiceCallIn:
            callHungupBtn.isHidden = true
            callAnswerBtn.isHidden = false
            callCancelBtn.isHidden = false
            break
        case .EMVoiceCalling, .EMVoiceCallOut:
            callHungupBtn.isHidden = false
            callAnswerBtn.isHidden = true
            callCancelBtn.isHidden = true
            break
        }
    }
    
    func connected() {
        
    }
    
    func startTimer() {
        stopTimer()
        time = 0
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        }
    }
    
    func stopTimer() {
        if timer != nil {
            guard let _timer = timer else { return }
            _timer.invalidate()
        }
    }
    
    @objc func updateTime() {
        time += 1
        timeLabel.text = timeStr
    }
    
    @IBAction func speakerAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.didSpeaker()
    }
    
    @IBAction func muteAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.didMute()
    }

    @IBAction func hungupAction(_ sender: UIButton) {
        stopTimer()
        delegate?.didHungUp()
    }
    
    @IBAction func awnserAction(_ sender: UIButton) {
        startTimer()
        delegate?.didAwnser()
        voiceCallType = .EMVoiceCalling
        setupUI()
    }
    
    func callDidAccept() {
        startTimer()
        voiceCallType = .EMVoiceCalling
        setupUI()
    }
    
}
