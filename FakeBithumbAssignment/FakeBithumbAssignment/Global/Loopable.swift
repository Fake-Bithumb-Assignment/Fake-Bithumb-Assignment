//
//  Loopable.swift
//  FakeBithumbAssignment
//
//  Created by chihoooon on 2022/03/05.
//

import Foundation

protocol Loopable {
    func allProperties() throws -> [String: Item]
}

extension Loopable {
    func allProperties() throws -> [String: Item] {
        
        var result: [String: Item] = [:]
        
        let mirror = Mirror(reflecting: self)
        
        // Optional check to make sure we're iterating over a struct or class
        guard let style = mirror.displayStyle, style == .struct || style == .class else {
            throw NSError()
        }
        
        for (property, value) in mirror.children {
            guard let property = property else {
                continue
            }
            
            result[property] = value as? Item
        }
        
        return result
    }
}
