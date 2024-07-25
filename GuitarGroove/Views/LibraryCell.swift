//
//  LibraryTableCell.swift
//  GuitarGroove
//
//  Created by Jacob  Loranger on 7/19/24.
//

import UIKit
import AVFoundation

class LibraryCell: UITableViewCell {
    
    static let reuseID = "LibraryCell"
    var fileURL: URL!
    var audioPlayer: AVAudioPlayer?
    
    let fileNameLabel = UILabel()
    let durationLabel = UILabel()
    let playButton = UIButton(type: .system)
    
    let playImage = UIImage(systemName: "play.fill")
    let pauseImage = UIImage(systemName: "pause.fill")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUILayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(fileURL: URL) {
        self.fileURL = fileURL
        setupUILayout()
        configure()
    }
    
    
    func setupUILayout() {
        contentView.addSubview(fileNameLabel)
        contentView.addSubview(durationLabel)
        contentView.addSubview(playButton)
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.backgroundColor = .tertiarySystemBackground
        
        playButton.setBackgroundImage(playImage, for: .normal)
        playButton.tintColor = .systemGray
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        
        fileNameLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        playButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            fileNameLabel.topAnchor.constraint(equalTo: topAnchor),
            fileNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            fileNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            fileNameLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            
            durationLabel.topAnchor.constraint(equalTo: fileNameLabel.bottomAnchor),
            durationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            durationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            durationLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            playButton.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            playButton.leadingAnchor.constraint(equalTo: fileNameLabel.trailingAnchor),
            playButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30)
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
        player.delegate = self
        
        if player.isPlaying {
            player.stop()
            playButton.setBackgroundImage(playImage, for: .normal)
        } else {
            player.play()
            playButton.setBackgroundImage(pauseImage, for: .normal)
        }
    }
}

extension LibraryCell: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playButton.setBackgroundImage(playImage, for: .normal)
    }
}
