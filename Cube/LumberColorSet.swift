//
//  LumberColorSet.swift
//  Cube
//
//  Created by 寺家 篤史 on 2020/12/11.
//  Copyright © 2020 Atsushi Jike. All rights reserved.
//

import Foundation
import CoreGraphics

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
}
