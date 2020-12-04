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
    let cornerRadius: CGFloat = 2.0
    
    lazy var frontLayer: CALayer = {
        let transform = CATransform3DMakeTranslation(0, 0, size / 2)
        return createGradientFaceLayer(with: transform,
                                       colors: [UIColor(white: 0.4, alpha: 1.0),
                                                UIColor(white: 0.6, alpha: 1.0)])
    }()
    lazy var rightLayer: CALayer = {
        var transform = CATransform3DMakeTranslation(size / 2, 0, 0)
        transform = CATransform3DRotate(transform, CGFloat.pi / 2 , 0, 1, 0)
        return createGradientFaceLayer(with: transform,
                                       colors: [UIColor(white: 0.6, alpha: 1.0),
                                                UIColor(white: 0.8, alpha: 1.0)])
    }()
    lazy var topLayer: CALayer = {
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
        let layer = createFaceLayer(with: transform, color: .clear)
        let shadowRadius: CGFloat = 3
        let shadowBaseLayer = CALayer()
        shadowBaseLayer.frame = CGRect(x: cornerRadius, y: cornerRadius, width: size - cornerRadius * 2, height: size - cornerRadius * 2)
        shadowBaseLayer.backgroundColor = UIColor.white.cgColor
        layer.addSublayer(shadowBaseLayer)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 1, height: -2)
        return layer
    }()
    lazy var backLayer: CALayer = {
        var transform = CATransform3DMakeTranslation(0, 0, -size / 2)
        transform = CATransform3DRotate(transform, CGFloat.pi , 0, 1, 0)
        return createFaceLayer(with: transform, color: .clear)
    }()
    
    lazy var frontTopLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: -size / 2, y: -size / 2, width: size, height: cornerRadius)
        layer.colors = [UIColor(white: 1, alpha: 0.8),
                        UIColor(white: 1, alpha: 0)].map { $0.cgColor }
        layer.transform = CATransform3DMakeTranslation(size / 2, size / 2, 0)
        layer.allowsEdgeAntialiasing = true
        return layer
    }()
    lazy var frontLeftLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        let transform = CATransform3DMakeTranslation(size / 2, size / 2, 0)
        layer.frame = CGRect(x: -size / 2, y: -size / 2, width: cornerRadius, height: size)
        layer.colors = [UIColor(white: 1, alpha: 0.3),
                        UIColor(white: 1, alpha: 0)].map { $0.cgColor }
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.transform = transform
        layer.allowsEdgeAntialiasing = true
        return layer
    }()
    lazy var frontRightLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        let transform = CATransform3DMakeTranslation(size * 1.5 - cornerRadius, size / 2, 0)
        layer.frame = CGRect(x: -size / 2, y: -size / 2, width: cornerRadius, height: size)
        layer.colors = [UIColor(white: 1, alpha: 0),
                        UIColor(white: 1, alpha: 0.3)].map { $0.cgColor }
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.transform = transform
        layer.allowsEdgeAntialiasing = true
        return layer
    }()
    lazy var frontBottomLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: -size / 2, y: -size / 2, width: size, height: cornerRadius)
        layer.colors = [UIColor(white: 1, alpha: 0),
                        UIColor(white: 1, alpha: 0.2)].map { $0.cgColor }
        layer.transform = CATransform3DMakeTranslation(size / 2, size * 1.5 - cornerRadius, 0)
        layer.allowsEdgeAntialiasing = true
        return layer
    }()
    lazy var rightTopLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: -size / 2, y: -size / 2, width: size, height: cornerRadius)
        layer.colors = [UIColor(white: 1, alpha: 0.8),
                        UIColor(white: 1, alpha: 0)].map { $0.cgColor }
        layer.transform = CATransform3DMakeTranslation(size / 2, size / 2, 0)
        layer.allowsEdgeAntialiasing = true
        return layer
    }()
    lazy var rightLeftLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        let transform = CATransform3DMakeTranslation(size / 2, size / 2, 0)
        layer.frame = CGRect(x: -size / 2, y: -size / 2, width: cornerRadius, height: size)
        layer.colors = [UIColor(white: 1, alpha: 0.3),
                        UIColor(white: 1, alpha: 0)].map { $0.cgColor }
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.transform = transform
        layer.allowsEdgeAntialiasing = true
        return layer
    }()
    lazy var rightRightLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        let transform = CATransform3DMakeTranslation(size * 1.5 - cornerRadius, size / 2, 0)
        layer.frame = CGRect(x: -size / 2, y: -size / 2, width: cornerRadius, height: size)
        layer.colors = [UIColor(white: 1, alpha: 0),
                        UIColor(white: 1, alpha: 0.3)].map { $0.cgColor }
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.transform = transform
        layer.allowsEdgeAntialiasing = true
        return layer
    }()
    lazy var rightBottomLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: -size / 2, y: -size / 2, width: size, height: cornerRadius)
        layer.colors = [UIColor(white: 1, alpha: 0),
                        UIColor(white: 1, alpha: 0.2)].map { $0.cgColor }
        layer.transform = CATransform3DMakeTranslation(size / 2, size * 1.5 - cornerRadius, 0)
        layer.allowsEdgeAntialiasing = true
        return layer
    }()
    lazy var topTopLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: -size / 2, y: -size / 2, width: size, height: cornerRadius)
        layer.colors = [UIColor(white: 1, alpha: 1),
                        UIColor(white: 1, alpha: 0)].map { $0.cgColor }
        layer.transform = CATransform3DMakeTranslation(size / 2, size / 2, 0)
        layer.allowsEdgeAntialiasing = true
        return layer
    }()
    lazy var topLeftLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        let transform = CATransform3DMakeTranslation(size / 2, size / 2, 0)
        layer.frame = CGRect(x: -size / 2, y: -size / 2, width: cornerRadius, height: size)
        layer.colors = [UIColor(white: 1, alpha: 1),
                        UIColor(white: 1, alpha: 0)].map { $0.cgColor }
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.transform = transform
        layer.allowsEdgeAntialiasing = true
        return layer
    }()
    lazy var topRightLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        let transform = CATransform3DMakeTranslation(size * 1.5 - cornerRadius, size / 2, 0)
        layer.frame = CGRect(x: -size / 2, y: -size / 2, width: cornerRadius, height: size)
        layer.colors = [UIColor(white: 1, alpha: 0),
                        UIColor(white: 1, alpha: 1)].map { $0.cgColor }
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.transform = transform
        layer.allowsEdgeAntialiasing = true
        return layer
    }()
    lazy var topBottomLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: -size / 2, y: -size / 2, width: size, height: cornerRadius)
        layer.colors = [UIColor(white: 1, alpha: 0),
                        UIColor(white: 1, alpha: 1)].map { $0.cgColor }
        layer.transform = CATransform3DMakeTranslation(size / 2, size * 1.5 - cornerRadius, 0)
        layer.allowsEdgeAntialiasing = true
        return layer
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
        path.move(to: CGPoint(x: cornerRadius, y: size))
        path.addLine(to: CGPoint(x: size - cornerRadius, y: size))
        // curve
        path.addCurve(to: CGPoint(x: size, y: size - cornerRadius), control1: CGPoint(x: size, y: size), control2: CGPoint(x: size, y: size - cornerRadius))
        path.addLine(to: CGPoint(x: size, y: cornerRadius))
        // curve
        path.addCurve(to: CGPoint(x: size + cornerRadius, y: cornerRadius * 2), control1: CGPoint(x: size, y: 0), control2: CGPoint(x: size + cornerRadius, y: cornerRadius * 2))
        path.addLine(to: CGPoint(x: size * 1.5, y: size))
        path.addLine(to: CGPoint(x: size / 2 * 3, y: size * 2))
        path.addLine(to: CGPoint(x: size / 2, y: size * 2))
        path.addLine(to: CGPoint(x: cornerRadius, y: size + cornerRadius * 2))
        // curve
        path.addCurve(to: CGPoint(x: cornerRadius, y: size), control1: CGPoint(x: 0, y: size), control2: CGPoint(x: cornerRadius, y: size))
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
        
        frontLayer.addSublayer(frontTopLayer)
        frontLayer.addSublayer(frontRightLayer)
        frontLayer.addSublayer(frontLeftLayer)
        frontLayer.addSublayer(frontBottomLayer)
        rightLayer.addSublayer(rightTopLayer)
        rightLayer.addSublayer(rightLeftLayer)
        rightLayer.addSublayer(rightRightLayer)
        rightLayer.addSublayer(rightBottomLayer)
        topLayer.addSublayer(topTopLayer)
        topLayer.addSublayer(topBottomLayer)
        topLayer.addSublayer(topRightLayer)
        topLayer.addSublayer(topLeftLayer)

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
    
    func createGradientFaceLayer(with transform: CATransform3D, colors: [UIColor]) -> CALayer {
        
        let layer = CALayer()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: size, height: size)
        gradientLayer.colors = colors.map { $0.cgColor }
        layer.frame = CGRect(x: -size / 2, y: -size / 2, width: size, height: size)
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        layer.transform = transform
        layer.allowsEdgeAntialiasing = true
        layer.addSublayer(gradientLayer)
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
