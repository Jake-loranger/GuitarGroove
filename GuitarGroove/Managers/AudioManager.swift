//
//  AudioManager.swift
//  GuitarGroove
//
//  Created by Jacob  Loranger on 7/15/24.
//

import AVFoundation

class AudioManager {
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var recordingSession: AVAudioSession!
    
    var isRecording: Bool {
        return audioRecorder?.isRecording ?? false
    }
    
    var isPlaying: Bool {
        return audioPlayer?.isPlaying ?? false
    }
    
    func setupAudioSession() {
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.setupRecorder()
                    } else {
                        // Handle error on main thread
                    }
                }
            }
        } catch {
            // Display error on main thread
        }
    }
    
    func setupRecorder() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.wav")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.prepareToRecord()
        } catch {
            // Handle recorder setup errors
        }
    }
    
    func startRecording() {
        if audioRecorder?.isRecording == false {
            audioRecorder?.record()
        }
    }
    
    func stopRecording() {
        if audioRecorder?.isRecording == true {
            audioRecorder?.stop()
        }
    }
    
    func saveRecording() -> URL? {
        guard let audioRecorder = audioRecorder else { return nil }
        
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.wav")
        
        do {
            try FileManager.default.moveItem(at: audioRecorder.url, to: audioFilename)
            return audioFilename
        } catch {
            // Handle save error
            return nil
        }
    }
    
    func playRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.wav")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            audioPlayer?.play()
            print("Playback started.")
        } catch {
            // Handle playback errors
            print("Failed to play recording.")
        }
    }
    
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}