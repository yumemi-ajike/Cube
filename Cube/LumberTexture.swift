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
    let side: CGFloat
    let baseColorComponents: [CGFloat] = [(255 / 255), (227 / 255), (220 / 255)]
    let centerBaseColorComponents: [[CGFloat]] = [
        [(205 / 255), (175 / 255), (131 / 255)],
        [(201 / 255), (138 / 255), (40 / 255)],
    ]
    let smoothRingColorComponents: [CGFloat] = [(199 / 255), (173 / 255), (122 / 255)]
    let roughRingColorComponents: [[CGFloat]] = [
        [(176 / 255), (130 / 255), (71 / 255)],
        [(194 / 255), (158 / 255), (96 / 255)],
    ]
    private var roughRings: [Ring] = []
    private var smoothRings: [Ring] = []
    
    init(side: CGFloat) {
        self.side = side
        self.smoothRings = createSmoothRings()
        self.roughRings = createRoughRings()
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
            let colorComponents = smoothRingColorComponents
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
            let colorComponents = roughRingColorComponents[Int.random(in: 0 ... 1)]
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
        
        UserDefaults.standard.removeObject(forKey: "SmoothRings")
        UserDefaults.standard.removeObject(forKey: "RoughRings")
        self.smoothRings = createSmoothRings()
        self.roughRings = createRoughRings()
    }
}

extension LumberTexture {
    
    func lumberTopImage() -> CGImage? {
        
        UIGraphicsBeginImageContext(CGSize(width: side, height: side))
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        // Draw base color
        context.setFillColor(UIColor(red: baseColorComponents[0],
                                     green: baseColorComponents[1],
                                     blue: baseColorComponents[2],
                                     alpha: 1).cgColor)
        context.fill(CGRect(x: 0, y: 0, width: side, height: side))
        
        if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                     colors: [
                                        UIColor(red: centerBaseColorComponents[0][0],
                                                green: centerBaseColorComponents[0][1],
                                                blue: centerBaseColorComponents[0][2],
                                                alpha: 0.3).cgColor,
                                        UIColor(red: centerBaseColorComponents[1][0],
                                                green: centerBaseColorComponents[1][1],
                                                blue: centerBaseColorComponents[1][2],
                                                alpha: 1).cgColor] as CFArray,
                                     locations: [0.7, 1.0]) {
            
            context.drawRadialGradient(gradient,
                                       startCenter: CGPoint(x: 0, y: side),
                                       startRadius: 0,
                                       endCenter: CGPoint(x: 0, y: side),
                                       endRadius: side * 0.8,
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
        
        return context.makeImage()
    }
    
    func lumberSideImage() -> CGImage? {
        
        UIGraphicsBeginImageContext(CGSize(width: side * sqrt(2), height: side))
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        // Draw base color
        context.setFillColor(UIColor(red: baseColorComponents[0],
                                     green: baseColorComponents[1],
                                     blue: baseColorComponents[2],
                                     alpha: 1).cgColor)
        context.fill(CGRect(x: 0, y: 0, width: side * sqrt(2), height: side))
        
        if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                     colors: [
                                        UIColor(red: centerBaseColorComponents[0][0],
                                                green: centerBaseColorComponents[0][1],
                                                blue: centerBaseColorComponents[0][2],
                                                alpha: 0.3).cgColor,
                                        UIColor(red: centerBaseColorComponents[1][0],
                                                green: centerBaseColorComponents[1][1],
                                                blue: centerBaseColorComponents[1][2],
                                                alpha: 1).cgColor] as CFArray,
                                     locations: [0.7, 1.0]) {
            
            context.drawLinearGradient(gradient,
                                       start: CGPoint.zero,
                                       end: CGPoint(x: side * 0.8, y: 0),
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
