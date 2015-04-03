//
//  PlayAudioViewController.swift
//  Pitch Perfect
//
//  Created by Jefri Vanegas on 3/19/15.
//  Copyright (c) 2015 Jefri Vanegas. All rights reserved.
//
import UIKit
import AVFoundation

class RecordAudioViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var record: UIButton!
    @IBOutlet weak var tapToRecordLabel: UILabel!
    @IBOutlet weak var offMicrophone: UIButton!
    @IBOutlet weak var stop: UIButton!
    @IBOutlet weak var pause: UIButton!
    @IBOutlet weak var resume: UIButton!
    @IBOutlet weak var pausedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        record.hidden = false
        tapToRecordLabel.hidden = false
        recordingLabel.hidden = true
        offMicrophone.hidden = true
        stop.hidden = true
        resume.hidden = true
        pause.hidden = true
        pausedLabel.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    Records user's voice when microphone button is pressed
    @IBAction func record(sender: UIButton) {
        record.hidden = true
        tapToRecordLabel.hidden = true
        recordingLabel.hidden = false
        offMicrophone.hidden = false
        stop.hidden = false
        resume.hidden = false
        pause.hidden = false
        
//      Find the directory path to store file
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
//     Setup audio session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
//     Start recording
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.record()
    }
//    Make sure file recorded properly before proceeding to the next segue
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            let recordedAudio = RecordedAudio(filePathUrl:recorder.url , title:recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else {
            println("Error passing the file between segues")
        }
    }
//    PlayAudioViewController has access to the data
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording"){
            let playSoundsVC:PlayAudioViewController = segue.destinationViewController as! PlayAudioViewController
            let data  = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func stop(sender: UIButton) {
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    @IBAction func resume(sender: UIButton) {
        audioRecorder.record()
        recordingLabel.hidden = false
        pausedLabel.hidden = true
    }
    
    @IBAction func pause(sender: UIButton) {
        audioRecorder.pause()
        recordingLabel.hidden = true
        pausedLabel.hidden = false
        
    }
}

