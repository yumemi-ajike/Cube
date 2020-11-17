//
//  WireCubeView.swift
//  Cube
//
//  Created by 寺家 篤史 on 2020/11/17.
//  Copyright © 2020 Atsushi Jike. All rights reserved.
//

import UIKit

final class WireCubeView: UIView {
    
    let baseLayer = CATransformLayer()
    let size: CGFloat = 200
    lazy var frontLayer: CALayer = {
        let transform = CATransform3DMakeTranslation(0, 0, size / 2)
        return createFaceLayer(with: transform)
    }()
    lazy var rightLayer: CALayer = {
        var transform = CATransform3DMakeTranslation(size / 2, 0, 0)
        transform = CATransform3DRotate(transform, CGFloat.pi / 2 , 0, 1, 0)
        return createFaceLayer(with: transform)
    }()
    lazy var topLayer: CALayer = {
        var transform = CATransform3DMakeTranslation(0, -size / 2, 0)
        transform = CATransform3DRotate(transform, CGFloat.pi / 2 , 1, 0, 0)
        return createFaceLayer(with: transform)
    }()
    lazy var leftLayer: CALayer = {
        var transform = CATransform3DMakeTranslation(-size / 2, 0, 0)
        transform = CATransform3DRotate(transform, -CGFloat.pi / 2 , 0, 1, 0)
        return createFaceLayer(with: transform)
    }()
    lazy var bottomLayer: CALayer = {
        var transform = CATransform3DMakeTranslation(0, size / 2, 0)
        transform = CATransform3DRotate(transform, -CGFloat.pi / 2 , 1, 0, 0)
        return createFaceLayer(with: transform)
    }()
    lazy var backLayer: CALayer = {
        var transform = CATransform3DMakeTranslation(0, 0, -size / 2)
        transform = CATransform3DRotate(transform, CGFloat.pi , 0, 1, 0)
        return createFaceLayer(with: transform)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        baseLayer.addSublayer(frontLayer)
        baseLayer.addSublayer(rightLayer)
        baseLayer.addSublayer(topLayer)
        baseLayer.addSublayer(leftLayer)
        baseLayer.addSublayer(bottomLayer)
        baseLayer.addSublayer(backLayer)
        baseLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        layer.addSublayer(baseLayer)
        
        if false {
            // Animation
            let anim = CABasicAnimation(keyPath: "transform")
            anim.fromValue = baseLayer.transform
            anim.toValue = CATransform3DMakeRotation(CGFloat.pi, 1, 1, 1)
            anim.duration = 2
            anim.isCumulative = true
            anim.repeatCount = .greatestFiniteMagnitude
            baseLayer.add(anim, forKey: "transform")
        } else {
            var transform = CATransform3DIdentity
            transform.m34 = -1.0 / 1000
            transform = CATransform3DRotate(transform, -30 * CGFloat.pi / 180, 0, 1, 0)
            transform = CATransform3DRotate(transform, -30 * CGFloat.pi / 180, 1, 0, 0)
            transform = CATransform3DRotate(transform, 15 * CGFloat.pi / 180, 0, 0, 1)
            baseLayer.transform = transform
        }
    }
    
    func createFaceLayer(with transform: CATransform3D) -> CALayer {
        
        let layer = CALayer()
        layer.frame = CGRect(x: -size / 2, y: -size / 2, width: size, height: size)
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
        layer.transform = transform
        layer.allowsEdgeAntialiasing = true
        return layer
    }
}
