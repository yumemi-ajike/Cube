//
//  LumberTexture.swift
//  Cube
//
//  Created by Atsushi Jike on 2020/12/05.
//  Copyright © 2020 Atsushi Jike. All rights reserved.
//

import UIKit
import CoreGraphics

final class LumberTexture {
    struct Ring: Codable {
        let distance: CGFloat
        let width: CGFloat
        let depth: CGFloat
        let colorComponents: [CGFloat]
    }
    struct Base: Codable {
        let colorComponents: [CGFloat]
        let centerColorComponents: [[CGFloat]]
        let gradientLocations: [CGFloat]
        let centerGradientRadius: CGFloat
        
        static var `default`: Base {
            return .init(colorComponents: [], centerColorComponents: [], gradientLocations: [], centerGradientRadius: 0)
        }
    }
    
    let side: CGFloat
    private var colorSet: LumberColorSet = LumberColorSet.default
    private var base: Base = Base.default
    private var roughRings: [Ring] = []
    private var smoothRings: [Ring] = []
    
    init(side: CGFloat) {
        self.side = side
        self.base = createBase()
        self.smoothRings = createSmoothRings()
        self.roughRings = createRoughRings()
    }
    
    private func createBase() -> Base {
        
        // Resore saved base from UserDefaults
        if let data = UserDefaults.standard.data(forKey: "Base"),
           let base = try? JSONDecoder().decode(Base.self, from: data) {
            
            return base
        }
        
        let locations: [CGFloat] = [
            CGFloat(Float.random(in: 0.5 ... 0.8)),
            CGFloat(Float.random(in: 0.8 ... 1.0))
        ]
        let radius: CGFloat = CGFloat(Float.random(in: 0.6 ... 1.0))
        self.base = Base(colorComponents: colorSet.baseColorComponents,
                         centerColorComponents: colorSet.centerBaseColorComponents,
                         gradientLocations: locations,
                         centerGradientRadius: radius)
        
        // Save base to UserDefaults
        UserDefaults.standard.setValue(try? JSONEncoder().encode(base), forKey: "Base")
        
        return base
    }
    
    private func createSmoothRings() -> [Ring] {
        
        // Restore saved rings from UserDefaults
        if let data = UserDefaults.standard.data(forKey: "SmoothRings"),
           let rings = try? JSONDecoder().decode([Ring].self, from: data) {
            
            return rings
        }
        
        var smoothRings: [Ring] = []
        var pointer: CGFloat = 0
        
        repeat {
            let distance = CGFloat(Float.random(in: 2 ... 3))
            let width = CGFloat(Float.random(in: 0.5 ... 2))
            let depth = CGFloat(Float.random(in: 0.8 ... 1.0))
            let colorComponents = colorSet.smoothRingColorComponents
            if (pointer + distance + width / 2) < (side * sqrt(2)) {
                smoothRings.append(Ring(distance: distance, width: width, depth: depth, colorComponents: colorComponents))
                pointer += distance
            } else {
                break
            }
            
        } while(pointer < (side * sqrt(2)))
        
        // Save rings to UserDefaults
        UserDefaults.standard.setValue(try? JSONEncoder().encode(smoothRings), forKeyPath: "SmoothRings")
        
        return smoothRings
    }
    
    private func createRoughRings() -> [Ring] {
        
        // Restore saved rings from UserDefaults
        if let data = UserDefaults.standard.data(forKey: "RoughRings"),
           let rings = try? JSONDecoder().decode([Ring].self, from: data) {
            
            return rings
        }
        
        var roughRings: [Ring] = []
        var pointer: CGFloat = 0
        
        repeat {
            let distance = CGFloat(Float.random(in: 5 ... 30))
            let width = CGFloat(Float.random(in: 2 ... 12))
            let depth = CGFloat(Float.random(in: 0.4 ... 0.6))
            let colorComponents = colorSet.roughRingColorComponents[Int.random(in: 0 ... 1)]
            if (pointer + distance + width / 2) < (side * sqrt(2)) {
                roughRings.append(Ring(distance: distance, width: width, depth: depth, colorComponents: colorComponents))
                pointer += distance
            } else {
                break
            }
            
        } while(pointer < (side * sqrt(2)))
        
        // Save rings to UserDefaults
        UserDefaults.standard.setValue(try? JSONEncoder().encode(roughRings), forKeyPath: "RoughRings")
        
        return roughRings
    }
    
    func updateRings() {
        
        UserDefaults.standard.removeObject(forKey: "Base")
        UserDefaults.standard.removeObject(forKey: "SmoothRings")
        UserDefaults.standard.removeObject(forKey: "RoughRings")
        self.base = createBase()
        self.smoothRings = createSmoothRings()
        self.roughRings = createRoughRings()
    }
}

extension LumberTexture {
    
    func lumberTopImage() -> CGImage? {
        
        UIGraphicsBeginImageContext(CGSize(width: side, height: side))
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        // Draw base color
        context.setFillColor(UIColor(red: base.colorComponents[0],
                                     green: base.colorComponents[1],
                                     blue: base.colorComponents[2],
                                     alpha: 1).cgColor)
        context.fill(CGRect(x: 0, y: 0, width: side, height: side))
        
        if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                     colors: [
                                        UIColor(red: base.centerColorComponents[0][0],
                                                green: base.centerColorComponents[0][1],
                                                blue: base.centerColorComponents[0][2],
                                                alpha: 0.3).cgColor,
                                        UIColor(red: base.centerColorComponents[1][0],
                                                green: base.centerColorComponents[1][1],
                                                blue: base.centerColorComponents[1][2],
                                                alpha: 1).cgColor] as CFArray,
                                     locations: base.gradientLocations) {
            
            context.drawRadialGradient(gradient,
                                       startCenter: CGPoint(x: 0, y: side),
                                       startRadius: 0,
                                       endCenter: CGPoint(x: 0, y: side),
                                       endRadius: side * base.centerGradientRadius,
                                       options: [.drawsBeforeStartLocation])
        }
        
        // Draw annual tree rings
        [smoothRings, roughRings].forEach { rings in
            var pointer: CGFloat = 0
            rings.forEach { ring in
                pointer += ring.distance
                
                context.setLineWidth(ring.width)
                let startPoint = CGPoint(x: pointer, y: side)
                let endPoint = CGPoint(x: 0, y: side - pointer)
                context.move(to: startPoint)
                context.addCurve(to: endPoint,
                                  control1: CGPoint(x: pointer, y: side - pointer / 2),
                                  control2: CGPoint(x: pointer / 2, y: side - pointer))
                let components: [CGFloat] = ring.colorComponents
                context.setStrokeColor(UIColor(red: components[0],
                                               green: components[1],
                                               blue: components[2],
                                               alpha: ring.depth).cgColor)
                context.strokePath()
            }
        }
        
        // Draw scratch
        var pointer: CGFloat = 0
        repeat {
            
            context.setLineWidth(1)
            let startPoint = CGPoint(x: 0, y: pointer * sqrt(2))
            let endPoint = CGPoint(x: pointer * sqrt(2), y: 0)
            context.move(to: startPoint)
            context.addLine(to: endPoint)
            let alpha = (1 - pointer / side * sqrt(2))
            context.setStrokeColor(UIColor(white: 1, alpha: alpha).cgColor)
            context.strokePath()
            
            pointer += 6
        } while(pointer < side * sqrt(2))
        
        return context.makeImage()
    }
    
    func lumberSideImage() -> CGImage? {
        
        UIGraphicsBeginImageContext(CGSize(width: side * sqrt(2), height: side))
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        // Draw base color
        context.setFillColor(UIColor(red: base.colorComponents[0],
                                     green: base.colorComponents[1],
                                     blue: base.colorComponents[2],
                                     alpha: 1).cgColor)
        context.fill(CGRect(x: 0, y: 0, width: side * sqrt(2), height: side))
        
        if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                     colors: [
                                        UIColor(red: base.centerColorComponents[0][0],
                                                green: base.centerColorComponents[0][1],
                                                blue: base.centerColorComponents[0][2],
                                                alpha: 0.3).cgColor,
                                        UIColor(red: base.centerColorComponents[1][0],
                                                green: base.centerColorComponents[1][1],
                                                blue: base.centerColorComponents[1][2],
                                                alpha: 1).cgColor] as CFArray,
                                     locations: base.gradientLocations) {
            
            context.drawLinearGradient(gradient,
                                       start: CGPoint.zero,
                                       end: CGPoint(x: side * base.centerGradientRadius, y: 0),
                                       options: [.drawsBeforeStartLocation])
        }
        
        // Draw smooth annual tree rings
        var pointer: CGFloat = 0
        smoothRings.forEach { ring in
            pointer += ring.distance
            
            context.setLineWidth(ring.width)
            let startPoint = CGPoint(x: pointer, y: 0)
            let endPoint = CGPoint(x: pointer, y: side)
            context.move(to: startPoint)
            context.addLine(to: endPoint)
            let components: [CGFloat] = ring.colorComponents
            context.setStrokeColor(UIColor(red: components[0],
                                           green: components[1],
                                           blue: components[2],
                                           alpha: ring.depth).cgColor)
            context.strokePath()
        }
        
        // Draw rough annual tree rings
        pointer = 0
        roughRings.forEach { ring in
            pointer += ring.distance
            
            context.setLineWidth(ring.width)
            let startPoint = CGPoint(x: pointer, y: 0)
            let endPoint = CGPoint(x: pointer, y: side)
            context.move(to: startPoint)
            context.addLine(to: endPoint)
            let components: [CGFloat] = ring.colorComponents
            context.setStrokeColor(UIColor(red: components[0],
                                           green: components[1],
                                           blue: components[2],
                                           alpha: ring.depth).cgColor)
            context.strokePath()
        }
        
        // Distort the pattern
        if let image = context.makeImage() {
            
            let ciimage = CIImage(cgImage: image)
            let filter = CIFilter(name: "CITwirlDistortion")
            filter?.setValue(ciimage, forKey: kCIInputImageKey)
            filter?.setValue(CIVector(x: side * 1.2, y: -side / 3), forKey: kCIInputCenterKey)
            filter?.setValue(side * 1.3, forKey: kCIInputRadiusKey)
            filter?.setValue(CGFloat.pi / 8, forKey: kCIInputAngleKey)
            
            if let outputImage = filter?.outputImage {
                let cicontext = CIContext(options: nil)
                return cicontext.createCGImage(outputImage, from: CGRect(x: 0, y: 0, width: side, height: side))
            }
            
            return image
        }
        return nil
    }
    
    func lumberStrechImage(topImage: CGImage?, sideImage: CGImage?) -> CGImage? {
        
        UIGraphicsBeginImageContext(CGSize(width: side, height: side))
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        if let topImage = topImage,
           let tilingImage = topTilingImage(topImage: topImage) {
            
            context.saveGState()
            context.draw(tilingImage, in: CGRect(x: 0, y: 0, width: side, height: side))
            context.restoreGState()
        }
        
        if let sideImage = sideImage,
            let tilingImage = sideTilingImage(sideImage: sideImage),
            let maskedImage = gradientMaskedImage(image: tilingImage) {
            
            context.saveGState()
            context.draw(maskedImage, in: CGRect(x: 0, y: 0, width: side, height: side))
            context.restoreGState()
        }
        
        return context.makeImage()
    }
    
    private func topTilingImage(topImage: CGImage) -> CGImage? {
        
        UIGraphicsBeginImageContext(CGSize(width: side, height: side))
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        if let cropImage = topImage.cropping(to: CGRect(x: side - 1, y: 0, width: 1, height: side)) {
            
            context.saveGState()
            context.rotate(by: -CGFloat.pi / 2)
            context.draw(cropImage, in: CGRect(x: 0, y: 0, width: side, height: side), byTiling: true)
            context.restoreGState()
            
            return context.makeImage()
        }
        return nil
    }
    
    private func sideTilingImage(sideImage: CGImage) -> CGImage? {
        
        UIGraphicsBeginImageContext(CGSize(width: side, height: side))
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        if let cropImage = sideImage.cropping(to: CGRect(x: side - 1, y: 0, width: 1, height: side)) {
            
            context.saveGState()
            context.draw(cropImage, in: CGRect(x: 0, y: 0, width: side, height: side), byTiling: true)
            context.restoreGState()
            return context.makeImage()
        }
        return nil
    }

    private func gradientMaskedImage(image: CGImage) -> CGImage? {
        
        UIGraphicsBeginImageContext(CGSize(width: side, height: side))
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceGray(),
                                     colors: [UIColor.black.cgColor,
                                              UIColor.white.cgColor] as CFArray,
                                     locations: [0.8, 1.0]) {

            context.saveGState()
            context.drawLinearGradient(gradient,
                                       start: CGPoint(x: 0, y: 0),
                                       end: CGPoint(x: side / 4, y: side / 8),
                                       options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
            context.restoreGState()
            if let maskImage = context.makeImage(),
               let mask = CGImage(maskWidth: maskImage.width,
                                  height: maskImage.height,
                                  bitsPerComponent: maskImage.bitsPerComponent,
                                  bitsPerPixel: maskImage.bitsPerPixel,
                                  bytesPerRow: maskImage.bytesPerRow,
                                  provider: maskImage.dataProvider!,
                                  decode: nil,
                                  shouldInterpolate: false) {
                
                return image.masking(mask)
            }
        }
        return nil
    }
}
