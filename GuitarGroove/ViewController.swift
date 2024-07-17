//
//  ViewController.swift
//  GuitarGroove
//
//  Created by Jacob  Loranger on 7/15/24.
//

import UIKit

class ViewController: UIViewController {
    
    let statusLabel = UILabel()
    let recordButton = UIButton()
    let stopButton = UIButton()
    let playButton = UIButton()
    let saveButton = UIButton()
    let hStackView = UIStackView()
    
    var audioManager = AudioManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.title = "GuitarGroove"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        audioManager.setupAudioSession()
        configureConnectStatusLabel()
        configureButtons()
        configureHStack()
    }
    
    func configureConnectStatusLabel() {
        view.addSubview(statusLabel)
        statusLabel.text = "Connected"
        
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
            statusLabel.heightAnchor.constraint(equalToConstant: 25),
        ])
    }
    
    func configureButtons() {
        playButton.backgroundColor = .systemGray4
        playButton.setTitle("Play", for: .normal)
        playButton.addTarget(self, action: #selector(playButtonAction), for: .touchUpInside)
        playButton.layer.cornerRadius = 5
        
        
        stopButton.backgroundColor = .systemGray4
        stopButton.setTitle("Stop", for: .normal)
        stopButton.addTarget(self, action: #selector(stopButtonAction), for: .touchUpInside)
        stopButton.layer.cornerRadius = 5
        
        saveButton.backgroundColor = .systemGray4
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        saveButton.layer.cornerRadius = 5
        
        recordButton.backgroundColor = .systemGray4
        recordButton.setTitle("Record", for: .normal)
        recordButton.addTarget(self, action: #selector(recordButtonAction), for: .touchUpInside)
        recordButton.layer.cornerRadius = 5
    }
    
    func configureHStack() {
        view.addSubview(hStackView)
        hStackView.axis = .horizontal
        hStackView.spacing = 20
        hStackView.distribution = .fillEqually
        
        hStackView.addArrangedSubview(recordButton)
        hStackView.addArrangedSubview(stopButton)
        hStackView.addArrangedSubview(playButton)
        hStackView.addArrangedSubview(saveButton)
        
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hStackView.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 20),
            hStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            hStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            hStackView.heightAnchor.constraint(equalToConstant: 50)
            
        ])
    }
     
    @objc func recordButtonAction() {
        print("record")
        audioManager.startRecording()
        if audioManager.isRecording { statusLabel.text = "Recording" }
    }
    
    
    @objc func playButtonAction() {
        print("play")
        audioManager.playRecording()
        if audioManager.isPlaying { statusLabel.text = "Playing" }
    }
    
    @objc func stopButtonAction() {
        print("stop")
        audioManager.stopRecording()
        if !audioManager.isRecording { statusLabel.text = "Not Recording" }
    }
    
    @objc func saveButtonAction() {
        print("save")
        if let savedURL = audioManager.saveRecording() {
            print("Recording saved at: \(savedURL)")
            // Handle further actions after saving
        } else {
            print("Failed to save recording.")
            // Handle error saving recording
        }
    }
}

