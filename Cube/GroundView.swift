//
//  GroundView.swift
//  Cube
//
//  Created by 寺家 篤史 on 2020/11/18.
//  Copyright © 2020 Atsushi Jike. All rights reserved.
//

import UIKit

final class GroundView: UIView {
    
    lazy var groundLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor(white: 1.0, alpha: 1.0).cgColor,
                        UIColor(white: 0.7, alpha: 1.0).cgColor]
        layer.locations = [0.5, 1.0]
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(groundLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        groundLayer.frame = bounds
    }
}
