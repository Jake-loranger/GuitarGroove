//
//  SoundBarView.swift
//  GuitarGroove
//
//  Created by Jacob  Loranger on 8/9/24.
//

import UIKit

class SoundBarView: UIView {
    
    private let shapeLayer = CAShapeLayer()
    let tempVolumeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
//        configureVolume(volume: "volume")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, text: String) {
        super.init(frame: frame)
        setup()
        configureVolume(volume: text)
    }
    
    private func setup() {
        shapeLayer.strokeColor = UIColor.blue.cgColor
        shapeLayer.lineWidth = 2.0
        shapeLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(shapeLayer)
    }
    
    private func configureVolume(volume: String) {
        tempVolumeLabel.text = volume
        self.addSubview(tempVolumeLabel)
        
        tempVolumeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tempVolumeLabel.topAnchor.constraint(equalTo: topAnchor),
            tempVolumeLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            tempVolumeLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            tempVolumeLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func updateWaveform(with rms: Float) {
        let height = CGFloat(rms) * self.bounds.height
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: self.bounds.midY))
        path.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.midY + height))
        shapeLayer.path = path.cgPath
    }
}
