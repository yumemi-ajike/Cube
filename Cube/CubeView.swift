//
//  CubeView.swift
//  Cube
//
//  Created by 寺家 篤史 on 2020/11/13.
//  Copyright © 2020 Atsushi Jike. All rights reserved.
//

import UIKit

final class CubeView: UIView {
    
    let groundLayer = CATransformLayer()
    let baseLayer = CATransformLayer()
    let size: CGFloat = 200
    
    lazy var frontLayer: CAGradientLayer = {
        let transform = CATransform3DMakeTranslation(0, 0, size / 2)
        return createGradientFaceLayer(with: transform,
                                       colors: [UIColor(white: 0.4, alpha: 1.0),
                                                UIColor(white: 0.6, alpha: 1.0)])
    }()
    lazy var rightLayer: CAGradientLayer = {
        var transform = CATransform3DMakeTranslation(size / 2, 0, 0)
        transform = CATransform3DRotate(transform, CGFloat.pi / 2 , 0, 1, 0)
        return createGradientFaceLayer(with: transform,
                                       colors: [UIColor(white: 0.6, alpha: 1.0),
                                                UIColor(white: 0.8, alpha: 1.0)])
    }()
    lazy var topLayer: CAGradientLayer = {
        var transform = CATransform3DMakeTranslation(0, -size / 2, 0)
        transform = CATransform3DRotate(transform, CGFloat.pi / 2 , 1, 0, 0)
        return createGradientFaceLayer(with: transform,
                                       colors: [UIColor(white: 1.0, alpha: 1.0),
                                                UIColor(white: 0.8, alpha: 1.0)])
    }()
    lazy var leftLayer: CALayer = {
        var transform = CATransform3DMakeTranslation(-size / 2, 0, 0)
        transform = CATransform3DRotate(transform, -CGFloat.pi / 2 , 0, 1, 0)
        return createFaceLayer(with: transform, color: .clear)
    }()
    lazy var bottomLayer: CALayer = {
        var transform = CATransform3DMakeTranslation(0, size / 2, 0)
        transform = CATransform3DRotate(transform, -CGFloat.pi / 2 , 1, 0, 0)
        return createFaceLayer(with: transform, color: .clear)
    }()
    lazy var backLayer: CALayer = {
        var transform = CATransform3DMakeTranslation(0, 0, -size / 2)
        transform = CATransform3DRotate(transform, CGFloat.pi , 0, 1, 0)
        return createFaceLayer(with: transform, color: .clear)
    }()
    
    lazy var shadowLayer: CALayer = {
        var transform = CATransform3DMakeTranslation(size / 2, size / 2, size / 2)
        transform = CATransform3DRotate(transform, CGFloat.pi / 2 , 1, 0, 0)
        let layer = CALayer()
        layer.frame = CGRect(x: -size, y: -size, width: size * 2, height: size * 2)
        layer.transform = transform
        layer.allowsEdgeAntialiasing = true
        return layer
    }()
    lazy var shadowShapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = CGRect(x: 0, y: 0, width: size * 2, height: size * 2)
        layer.fillColor = UIColor.black.cgColor
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: size))
        path.addLine(to: CGPoint(x: size, y: size))
        path.addLine(to: CGPoint(x: size, y: 0))
        path.addLine(to: CGPoint(x: size / 2 * 3, y: size * 2))
        path.addLine(to: CGPoint(x: size / 2, y: size * 2))
        path.addLine(to: CGPoint(x: 0, y: size))
        path.closeSubpath()
        layer.path = path
        layer.allowsEdgeAntialiasing = true
        return layer
    }()
    lazy var shadowGradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 0, y: 0, width: size * 2, height: size * 2)
        layer.colors = [UIColor(white: 0, alpha: 0.4), .clear].map { $0.cgColor }
        layer.allowsEdgeAntialiasing = true
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        shadowLayer.addSublayer(shadowGradientLayer)
        shadowGradientLayer.mask = shadowShapeLayer
        baseLayer.addSublayer(shadowLayer)
        
        groundLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        
        baseLayer.addSublayer(frontLayer)
        baseLayer.addSublayer(rightLayer)
        baseLayer.addSublayer(topLayer)
        baseLayer.addSublayer(leftLayer)
        baseLayer.addSublayer(bottomLayer)
        baseLayer.addSublayer(backLayer)
        baseLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        
        layer.addSublayer(groundLayer)
        layer.addSublayer(baseLayer)
        
        var transform = CATransform3DIdentity
        transform.m34 = -1.0 / 1000
        transform = CATransform3DRotate(transform, -30 * CGFloat.pi / 180, 0, 1, 0)
        transform = CATransform3DRotate(transform, -30 * CGFloat.pi / 180, 1, 0, 0)
        transform = CATransform3DRotate(transform, 15 * CGFloat.pi / 180, 0, 0, 1)
        baseLayer.transform = transform
    }
    
    func createGradientFaceLayer(with transform: CATransform3D, colors: [UIColor]) -> CAGradientLayer {
        
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: -size / 2, y: -size / 2, width: size, height: size)
        layer.colors = colors.map { $0.cgColor }
        layer.transform = transform
        layer.allowsEdgeAntialiasing = true
        return layer
    }
    
    func createFaceLayer(with transform: CATransform3D, color: UIColor) -> CALayer {
        
        let layer = CALayer()
        layer.frame = CGRect(x: -size / 2, y: -size / 2, width: size, height: size)
        layer.backgroundColor = color.cgColor
        layer.transform = transform
        layer.allowsEdgeAntialiasing = true
        return layer
    }
}
