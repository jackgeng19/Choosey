//
//  Convert.swift
//  Choosey
//
//  Created by Qicheng Geng on 10/15/23.
//

import Foundation

extension Int {
    func converted(from: UnitLength, to: UnitLength) -> Int{
        return Int(Measurement(value: Double(self), unit: from).converted(to: to).value)
    }
}
