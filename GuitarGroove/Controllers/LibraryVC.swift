//
//  LibraryVC.swift
//  GuitarGroove
//
//  Created by Jacob  Loranger on 7/20/24.
//

import UIKit

class LibraryVC: UIViewController {
    
    let tableView = UITableView()
    var audioFiles: [URL] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Library"
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        audioFiles = AudioManager().getAudioFiles()
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        tableView.rowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AudioFileCell")
    }
}

extension LibraryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioFiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AudioFileCell", for: indexPath)
        cell.textLabel?.text = audioFiles[indexPath.row].lastPathComponent
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle cell selection
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedFile = audioFiles[indexPath.row]
        print("Selected file: \(selectedFile)")
        // Add code to handle file selection, e.g., playback or detail view
    }
}
