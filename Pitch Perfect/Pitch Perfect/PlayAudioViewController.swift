//
//  PlayAudioViewController.swift
//  Pitch Perfect
//
//  Created by Jefri Vanegas on 3/23/15.
//  Copyright (c) 2015 Jefri Vanegas. All rights reserved.
//
import AVFoundation
import UIKit

class PlayAudioViewController: UIViewController {
    
    var receivedAudio:RecordedAudio!
    var audioPlayer:AVAudioPlayer!
    var audioEngine: AVAudioEngine!
    var audioFile:AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }
    
//    Change speed of Audio
    func playAudioWithSpeed (speed: Float) {
        audioPlayer.stop()
        audioPlayer.rate = speed
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
//    Play with audio effect Darthvader, Chipmunk, Reverb, Echo
    func playWithEffect (effect: NSObject) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        audioEngine.attachNode(effect as! AVAudioNode)
        
        audioEngine.connect(audioPlayerNode, to: effect as! AVAudioNode, format: nil)
        audioEngine.connect(effect as! AVAudioNode, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
//    Buttons for Chipmunk, DarthVader, Reverb, Echo
    @IBAction func chipmunk(sender: UIButton) {
        var chipmunk = AVAudioUnitTimePitch()
        chipmunk.pitch = 1000
        playWithEffect(chipmunk)
    }
    
    @IBAction func darthvader(sender: UIButton) {
        var darthvader = AVAudioUnitTimePitch()
        darthvader.pitch = -1000
        playWithEffect(darthvader)
    }
    
    @IBAction func reverb(sender: UIButton) {
        var reverb = AVAudioUnitReverb()
        reverb.loadFactoryPreset(AVAudioUnitReverbPreset.LargeHall)
        reverb.wetDryMix = 40.0
        playWithEffect(reverb)
    }
    
    @IBAction func echo(sender: UIButton) {
        var echo = AVAudioUnitDelay()
        echo.delayTime = 0.5
        playWithEffect(echo)
    }
    
//    Buttons for Fast and Slow Motion
    @IBAction func fast(sender: UIButton) {
        playAudioWithSpeed(1.5)
    }
    
    @IBAction func slow(sender: UIButton) {
        playAudioWithSpeed(0.5)
    }
    
    @IBAction func stop(sender: UIButton) {
        audioPlayer.stop()
    }
}
