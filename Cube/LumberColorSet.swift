//
//  LumberColorSet.swift
//  Cube
//
//  Created by 寺家 篤史 on 2020/12/11.
//  Copyright © 2020 Atsushi Jike. All rights reserved.
//

import UIKit
import CoreGraphics
import CoreImage

struct LumberColorSet {
    let baseColorComponents: [CGFloat]
    let centerBaseColorComponents: [[CGFloat]]
    let smoothRingColorComponents: [CGFloat]
    let roughRingColorComponents: [[CGFloat]]
    
    static var `default`: LumberColorSet {
        return .init(baseColorComponents: [
                        (255 / CGFloat(255)), (227 / CGFloat(255)), (220 / CGFloat(255))
                     ],
                     centerBaseColorComponents: [
                        [(205 / CGFloat(255)), (175 / CGFloat(255)), (131 / CGFloat(255))],
                        [(201 / CGFloat(255)), (138 / CGFloat(255)), (40 / CGFloat(255))],
                     ],
                     smoothRingColorComponents: [
                        (199 / CGFloat(255)), (173 / CGFloat(255)), (122 / CGFloat(255))
                     ],
                     roughRingColorComponents: [
                        [(176 / CGFloat(255)), (130 / CGFloat(255)), (71 / CGFloat(255))],
                        [(194 / CGFloat(255)), (158 / CGFloat(255)), (96 / CGFloat(255))],
                     ])
    }
    
    static var xmas: LumberColorSet {
        return .init(baseColorComponents: [
                        (255 / CGFloat(255)), (245 / CGFloat(255)), (193 / CGFloat(255))
                     ],
                     centerBaseColorComponents: [
                        [(105 / CGFloat(255)), (58 / CGFloat(255)), (24 / CGFloat(255))],
                        [(223 / CGFloat(255)), (176 / CGFloat(255)), (39 / CGFloat(255))],
                     ],
                     smoothRingColorComponents: [
                        (0 / CGFloat(255)), (162 / CGFloat(255)), (95 / CGFloat(255))
                     ],
                     roughRingColorComponents: [
                        [(160 / CGFloat(255)), (28 / CGFloat(255)), (34 / CGFloat(255))],
                        [(255 / CGFloat(255)), (0 / CGFloat(255)), (0 / CGFloat(255))],
                     ])
    }
    
    init(baseColorComponents: [CGFloat],
         centerBaseColorComponents: [[CGFloat]],
         smoothRingColorComponents: [CGFloat],
         roughRingColorComponents: [[CGFloat]]) {
        self.baseColorComponents = baseColorComponents
        self.centerBaseColorComponents = centerBaseColorComponents
        self.smoothRingColorComponents = smoothRingColorComponents
        self.roughRingColorComponents = roughRingColorComponents
    }
    
    init?(image: UIImage) {
        
        guard let components = image.cgImage?.getPixelColors(count: 6),
              components.count == 6 else {
            return nil
        }
        
        self.init(baseColorComponents: [
                    components[0][0], components[0][1], components[0][2]
                  ],
                  centerBaseColorComponents: [
                    [components[1][0], components[1][1], components[1][2]],
                    [components[2][0], components[2][1], components[2][2]]
                  ],
                  smoothRingColorComponents: [
                    components[3][0], components[3][1], components[3][2]
                  ],
                  roughRingColorComponents: [
                    [components[4][0], components[4][1], components[4][2]],
                    [components[5][0], components[5][1], components[5][2]]
                  ])
    }
}

extension CGImage {
    
    private func averageColor() -> UIColor? {

        let inputImage = CIImage(cgImage: self)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: inputImage.extent]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: nil)
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
    
    private func colorSampleImage() -> CGImage? {
        
        let inputImage = CIImage(cgImage: self)

        guard let filter = CIFilter(name: "CIKMeans") else { return nil }
        filter.setDefaults()
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(inputImage.extent, forKey: kCIInputExtentKey)
        filter.setValue(64, forKey: "inputCount")
        filter.setValue(10, forKey: "inputPasses")
        let seeds = [CIColor(red: 0, green: 0, blue: 0),    // black
                     CIColor(red: 1, green: 0, blue: 0),    // red
                     CIColor(red: 0, green: 1, blue: 0),    // green
                     CIColor(red: 1, green: 1, blue: 0),    // yellow
                     CIColor(red: 0, green: 0, blue: 1),    // blue
                     CIColor(red: 1, green: 1, blue: 1)]    // white
        filter.setValue(seeds, forKey: "inputMeans")
        guard let outputImage = filter.outputImage else { return nil }

        let context = CIContext(options: nil)
        return context.createCGImage(outputImage, from: CGRect(origin: .zero, size: outputImage.extent.size))
    }
    
    func getPixelColors(count: Int) -> [[CGFloat]] {
        
        var components: [[CGFloat]] = []
        guard let importantColorImage = colorSampleImage() else { return components }
        
        (0...count).forEach { index in
            
            let scale: CGFloat = 1
            let rect = CGRect(x: CGFloat(index) * scale, y: 0, width: scale, height: scale)
            if let cropImage = importantColorImage.cropping(to: rect),
               let color = cropImage.averageColor()?.color(mimimumBrightness: 0.5).color(mimimumSaturation: 0.5) {
                
                var r: CGFloat = 0
                var g: CGFloat = 0
                var b: CGFloat = 0
                var a: CGFloat = 0
                color.getRed(&r, green: &g, blue: &b, alpha: &a)
                
                let hexString = String.init(format: "`#%02lX%02lX%02lX`", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
                print("\(index): \(hexString)")
                
                components.append([r, g, b])
            }
        }
        return components
    }
}

extension UIColor {
    
    func color(mimimumBrightness: CGFloat) -> UIColor {
        
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        if b < mimimumBrightness {
            return UIColor(hue: h, saturation: s, brightness: mimimumBrightness, alpha: a)
        }
        return self
    }
    
    func color(mimimumSaturation: CGFloat) -> UIColor {
        
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        if s < mimimumSaturation {
            return UIColor(hue: h, saturation: mimimumSaturation, brightness: b, alpha: a)
        }
        return self
    }
}
