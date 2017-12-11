//
//  EMCallBaseViewController.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/12/6.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import UIKit
import AVFoundation

let kShowEMCallError = "kShowEMCallError"
let kAddEMCallHistory = "kAddEMCallHistory"

protocol EMCallBaseVCDelegate {
    func didHungUp()
    func didAnswer()
    func didReject()
    func didMute(_ isMute:Bool)
    func didSpeaker(speakerOut isSpeaker:Bool)
    func didSwitchCamera(isFront: Bool)
    func didPauseVideo(_ isPause:Bool)
    func didUpdateLocalCameraView(_ cameraView: UIView)
    func didUpdateRemoteCameraView(_ cameraView: UIView)
}

class EMCallBaseViewController: UIViewController {

    var ringPlayer: AVAudioPlayer?
    var delegate: EMCallBaseVCDelegate?
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotifications()
    }
    
    func startRing() {
        ringPlayer?.stop()
        let soundPath = Bundle.main.path(forResource: "callRing", ofType: "mp3")
        if soundPath != nil {
            let rungURL = URL(fileURLWithPath: soundPath!)
            ringPlayer = try! AVAudioPlayer(contentsOf: rungURL)
            ringPlayer?.volume = 1.0
            ringPlayer?.numberOfLoops = -1
            if ringPlayer!.prepareToPlay() {
                ringPlayer?.play()
            }
        }
    }
    
    func stopRing() {
        ringPlayer?.stop()
        ringPlayer = nil
    }
    
    func startTimer() {
        stopTimer()
        time = 0
        if timer == nil {
            timerStrWillChange(timeStr)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        }
    }
    
    func stopTimer() {
        if timer != nil {
            guard let _timer = timer else { return }
            _timer.invalidate()
        }
        timer = nil
    }
    
    @objc func updateTime() {
        time += 1
        timerStrDidChange(timeStr)
    }
    
    func timerStrWillChange(_ aTimeStr: String) {
        
    }
    
    func timerStrDidChange(_ aTimeStr: String) {
        
    }
    
    func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(showError), name: NSNotification.Name(kShowEMCallError), object: nil)
    }
    
    @objc func showError(noti: Notification) {
        if noti.object is String {
            show(noti.object as! String)
        }
    }
    
    func callDidAccept() {
        startTimer()
    }
}
