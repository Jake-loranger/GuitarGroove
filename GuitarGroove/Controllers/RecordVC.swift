//
//  RecordVC.swift
//  GuitarGroove
//
//  Created by Jacob  Loranger on 7/15/24.
//

import UIKit

class RecordVC: UIViewController {
    
    let titleImageView = UIImageView()
    let recordView = UIView()
    let libraryView = UIView()
    let libraryTableView = UITableView()
    let recordButton = UIButton(type: .system)
    let playButton = UIButton(type: .system)
    
    var audioManager = AudioManager()
    let recordings: [String] = ["Recording 1", "Recording 2", "Recording", "Recording", "Recording", "Recording", "Recording", "Recording", "Recording", "Recording", "Recording",]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        audioManager.setupAudioSession()
        configureTitleImage()
        configureRecordView()
        configureLibraryView()
        configureRecordButton()
        configureLibraryTableView()
        configurePlayButton()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    func configureTitleImage() {
        view.addSubview(titleImageView)
        titleImageView.image = UIImage(named: "GuitarGrooveLogo")
        titleImageView.contentMode = .left
        
        titleImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleImageView.heightAnchor.constraint(equalToConstant: 80),
        ])
    }
    
    func configureRecordView() {
        view.addSubview(recordView)
        recordView.backgroundColor = .tertiarySystemBackground
        recordView.layer.cornerRadius = 10
        
        recordView.layer.shadowColor = UIColor.black.cgColor
        recordView.layer.shadowOpacity = 0.2
        recordView.layer.shadowOffset = CGSize(width: 0, height: 2)
        recordView.layer.shadowRadius = 6
        recordView.layer.masksToBounds = false
        
        recordView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            recordView.topAnchor.constraint(equalTo: titleImageView.bottomAnchor, constant: 25),
            recordView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            recordView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            recordView.heightAnchor.constraint(equalToConstant: 150),
        ])
    }
    
    func configureRecordButton() {
        recordView.addSubview(recordButton)
        let recordImage = UIImage(systemName: "mic.fill")
        recordButton.setBackgroundImage(recordImage, for: .normal)
        recordButton.tintColor = .systemGray
        recordButton.imageView?.contentMode = .scaleAspectFit
        
        
        recordButton.addTarget(self, action: #selector(recordButtonAction), for: .touchUpInside)
        
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            recordButton.leadingAnchor.constraint(equalTo: recordView.leadingAnchor, constant: 40),
            recordButton.centerYAnchor.constraint(equalTo: recordView.centerYAnchor),
            recordButton.heightAnchor.constraint(equalToConstant: 80),
            recordButton.widthAnchor.constraint(equalToConstant: 70)
        ])
        
    }
    
    func configurePlayButton() {
        recordView.addSubview(playButton)
        let playImage = UIImage(systemName: "play.fill")
        playButton.setBackgroundImage(playImage, for: .normal)
        playButton.tintColor = .systemGray
        playButton.imageView?.contentMode = .scaleAspectFit
        
        
        playButton.addTarget(self, action: #selector(playButtonAction), for: .touchUpInside)
        
        playButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playButton.leadingAnchor.constraint(equalTo: recordButton.trailingAnchor, constant: 40),
            playButton.centerYAnchor.constraint(equalTo: recordButton.centerYAnchor),
            playButton.heightAnchor.constraint(equalToConstant: 80),
            playButton.widthAnchor.constraint(equalToConstant: 70)
        ])
        
    }
    
    func configureLibraryView() {
        view.addSubview(libraryView)
        libraryView.backgroundColor = .tertiarySystemBackground
        libraryView.layer.cornerRadius = 10
        
        libraryView.layer.shadowColor = UIColor.black.cgColor
        libraryView.layer.shadowOpacity = 0.2
        libraryView.layer.shadowOffset = CGSize(width: 0, height: 2)
        libraryView.layer.shadowRadius = 6
        libraryView.layer.masksToBounds = false
        
        libraryView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            libraryView.topAnchor.constraint(equalTo: recordView.bottomAnchor, constant: 25),
            libraryView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            libraryView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            libraryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
        ])
    }
    
    func configureLibraryTableView() {
        libraryView.addSubview(libraryTableView)
        
        libraryTableView.frame = libraryView.bounds
        libraryTableView.rowHeight = 70
        libraryTableView.delegate = self
        libraryTableView.dataSource = self
        
        libraryTableView.layer.cornerRadius = 10
        
        libraryTableView.layer.shadowColor = UIColor.black.cgColor
        libraryTableView.layer.shadowOpacity = 0.2
        libraryTableView.layer.shadowOffset = CGSize(width: 0, height: 2)
        libraryTableView.layer.shadowRadius = 6
        libraryView.layer.masksToBounds = false
        
        libraryTableView.register(UITableViewCell.self, forCellReuseIdentifier: "AudioTrack")
        
        libraryTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            libraryTableView.topAnchor.constraint(equalTo: libraryView.topAnchor),
            libraryTableView.leadingAnchor.constraint(equalTo: libraryView.leadingAnchor),
            libraryTableView.trailingAnchor.constraint(equalTo: libraryView.trailingAnchor),
            libraryTableView.bottomAnchor.constraint(equalTo: libraryView.bottomAnchor),
        ])
    }
    
    @objc func recordButtonAction() {
        if audioManager.isRecording {
            audioManager.stopRecording()
            print(audioManager.saveRecording())
            recordButton.tintColor = .systemGray
        } else {
            audioManager.startRecording()
            recordButton.tintColor = .red
        }
    }
    
    
    @objc func playButtonAction() {
        print("play")
        audioManager.playRecording()
    }
    
    @objc func stopButtonAction() {
        print("stop")
        audioManager.stopRecording()
    }
    
    @objc func saveButtonAction() {
        print("save")
        if let savedURL = audioManager.saveRecording() {
            print("Recording saved at: \(savedURL)")
            // Handle further actions after saving
        } else {
            // Handle error saving recording
        }
    }
}

extension RecordVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(recordings.count, 7)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AudioTrack", for: indexPath)
        cell.textLabel?.text = recordings[indexPath.row]
        cell.backgroundColor = .tertiarySystemBackground
        return cell
    }
}

