//
//  RecentRecordView.swift
//  GuitarGroove
//
//  Created by Jacob  Loranger on 7/20/24.
//

import UIKit

class RecentRecordView: UIView {
    
    let recordNameLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(recordName: String, recordURL: URL? ) {
        super.init(frame: .zero)
        recordNameLabel.text = recordName
        configure()
    }
    
    func configure() {
        addSubview(recordNameLabel)
        
        recordNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            recordNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            recordNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            recordNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            recordNameLabel.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }
}
