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
            try recordingSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
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
    
    func saveRecording(fileName: String) {
        guard let audioRecorder = audioRecorder else {
            print("Audio recorder is not initialized.")
            return
        }
        
        let audioFilename = getDocumentsDirectory().appendingPathComponent(fileName + ".wav")
        
        // Ensure the audioRecorder is recording before saving
        audioRecorder.stop()
        
        do {
            let audioData = try Data(contentsOf: audioRecorder.url)
            try audioData.write(to: audioFilename)
            print("Recording saved to: \(audioFilename.path)")
        } catch {
            print("Failed to save recording: \(error)")
        }
    }
    
    func playRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.wav")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            audioPlayer?.play()
            audioPlayer?.volume = 1.0
            print("Playback started.")
        } catch {
            // Handle playback errors
            print("Failed to play recording.")
        }
    }
    
    func pauseRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.wav")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            audioPlayer?.pause()
        } catch {
            print("Failed to pause recording")
        }
    }
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func getAudioFiles() -> [URL] {
        do {
            var audioFiles = try FileManager.default.contentsOfDirectory(at: .documentsDirectory, includingPropertiesForKeys: [.creationDateKey])
            let sortedFiles = audioFiles.sorted { (url1, url2) in
                guard let date1 = url1.creationDate, let date2 = url2.creationDate else {
                    // Handle cases where creation date is missing (put either one last or first)
                    return false
                }
                return date1 > date2
            }
            
            return sortedFiles
        } catch {
            return []
        }
    }
}

