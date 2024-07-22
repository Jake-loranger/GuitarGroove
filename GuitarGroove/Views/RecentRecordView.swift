//
//  RecentRecordView.swift
//  GuitarGroove
//
//  Created by Jacob  Loranger on 7/20/24.
//

import UIKit
import AVFoundation

class RecentRecordView: UIView {
    
    var fileURL: URL!
    var audioPlayer: AVAudioPlayer?
    
    let fileNameLabel = UILabel()
    let durationLabel = UILabel()
    let playButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUILayout()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(fileURL: URL) {
        super.init(frame: .zero)
        self.fileURL = fileURL
        setupUILayout()
        configure()
    }
    
    
    func setupUILayout() {
        addSubview(fileNameLabel)
        addSubview(durationLabel)
        addSubview(playButton)
        
        playButton.setTitle("Play", for: .normal)
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        
        fileNameLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        playButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            fileNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            fileNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            fileNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            fileNameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            durationLabel.topAnchor.constraint(equalTo: fileNameLabel.bottomAnchor),
            durationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            durationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            durationLabel.heightAnchor.constraint(equalToConstant: 20),
            
            playButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            playButton.leadingAnchor.constraint(equalTo: fileNameLabel.trailingAnchor),
            playButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            playButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func configure() {
        let fileName = fileURL.lastPathComponent.replacingOccurrences(of: ".wav", with: "")
        fileNameLabel.text = fileName
        
        let asset = AVAsset(url: fileURL)
        let duration = asset.duration
        let durationInSeconds = CMTimeGetSeconds(duration)
        durationLabel.text = "\(String(format: "%.2f", durationInSeconds)) seconds"
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
        } catch {
            print("Error initializing AVAudioPlayer: \(error.localizedDescription)")
        }
    }
    
    @objc private func playButtonTapped() {
        guard let player = audioPlayer else { return }
        
        if player.isPlaying {
            player.stop()
            playButton.setTitle("Play", for: .normal)
        } else {
            player.play()
            playButton.setTitle("Pause", for: .normal)
        }
    }
}
