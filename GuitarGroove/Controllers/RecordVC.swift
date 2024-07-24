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
    let libraryView = UITableView()
    let recordButton = UIButton(type: .system)
    let playButton = UIButton(type: .system)
    let saveButton = UIButton(type: .system)
    
    var audioManager = AudioManager()
    var audioFiles: [URL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        audioFiles = audioManager.getAudioFiles()
        
        audioManager.setupAudioSession()
        configureTitleImage()
        configureRecordView()
        configureLibraryView()
        configureRecordButton()
        configurePlayButton()
        configureSaveButton()
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
        recordView.layer.shadowOpacity = 0.1
        recordView.layer.shadowOffset = CGSize(width: 0, height: 2)
        recordView.layer.shadowRadius = 4
        recordView.layer.masksToBounds = false
        
        recordView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            recordView.topAnchor.constraint(equalTo: titleImageView.bottomAnchor, constant: 25),
            recordView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            recordView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            recordView.heightAnchor.constraint(equalToConstant: 150),
        ])
    }
    
    func configureLibraryView() {
        view.addSubview(libraryView)
        libraryView.backgroundColor = .tertiarySystemBackground
        libraryView.layer.cornerRadius = 10
        libraryView.layer.shadowColor = UIColor.black.cgColor
        libraryView.layer.shadowOpacity = 0.1
        libraryView.layer.shadowOffset = CGSize(width: 0, height: 2)
        libraryView.layer.shadowRadius = 4
        libraryView.layer.masksToBounds = false
        
        libraryView.delegate = self
        libraryView.dataSource = self
        libraryView.isScrollEnabled = false
        libraryView.allowsSelection = false
        libraryView.register(LibraryCell.self, forCellReuseIdentifier: LibraryCell.reuseID)
        
        libraryView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            libraryView.topAnchor.constraint(equalTo: recordView.bottomAnchor, constant: 25),
            libraryView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            libraryView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            libraryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
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
            recordButton.heightAnchor.constraint(equalToConstant: 50),
            recordButton.widthAnchor.constraint(equalToConstant: 40)
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
            playButton.heightAnchor.constraint(equalToConstant: 50),
            playButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureSaveButton() {
        recordView.addSubview(saveButton)
        let saveImage = UIImage(systemName: "folder.fill.badge.plus")
        saveButton.setBackgroundImage(saveImage, for: .normal)
        saveButton.tintColor = .systemGray
        saveButton.imageView?.contentMode = .scaleAspectFit
        
        saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 40),
            saveButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc func recordButtonAction() {
        if audioManager.isRecording {
            audioManager.stopRecording()
            recordButton.tintColor = .systemGray
        } else {
            audioManager.startRecording()
            recordButton.tintColor = .red
        }
    }
    
    
    @objc func playButtonAction() {
        if audioManager.isPlaying {
            audioManager.pauseRecording()
            let playImage = UIImage(systemName: "play.fill")
            playButton.setBackgroundImage(playImage, for: .normal)
        } else {
            audioManager.playRecording()
            let pauseImage = UIImage(systemName: "pause.fill")
            playButton.setBackgroundImage(pauseImage, for: .normal)
        }
    }
    
    @objc func stopButtonAction() {
        print("stop")
        audioManager.stopRecording()
    }
    

    @objc func saveButtonAction() {
        let alertController = UIAlertController(title: "Save Recording", message: "Enter a name for your recording", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Recording name"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let textField = alertController.textFields?.first,
                  let fileName = textField.text, !fileName.isEmpty else {
                self?.showErrorAlert(message: "Please enter a valid name.")
                return
            }
            self!.audioManager.saveRecording(fileName: fileName)
            self?.audioFiles = self?.audioManager.getAudioFiles() ?? []
            self?.libraryView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

extension RecordVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = libraryView.dequeueReusableCell(withIdentifier: LibraryCell.reuseID) as! LibraryCell
        if indexPath.row < audioFiles.count {
            let recordUrl = audioFiles[indexPath.row]
            cell.set(fileURL: recordUrl)
        } else {
            cell.playButton.isHidden = true
            cell.fileNameLabel.text = ""
            cell.durationLabel.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return libraryView.frame.height / 4
    }
}


