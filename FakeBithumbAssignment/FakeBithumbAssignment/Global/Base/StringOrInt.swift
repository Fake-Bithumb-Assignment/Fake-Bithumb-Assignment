//
//  StringOrInt.swift
//  FakeBithumbAssignment
//
//  Created by momo on 2022/03/04.
//

import Foundation

/// Decoding 전 Json의 값이 [String or Int] 일 경우 사용되는 enum
enum StringOrInt: Decodable {
    case string(String)
    case int(Int)
    
    var stringValue: String {
        get {
            switch self {
            case .string(let value):
                return value
            case .int:
                return ""
            }
        }
    }
    var intValue: Int {
        get {
            switch self {
            case .string:
                return 0
            case .int(let value):
                return value
            }
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self = try .string(container.decode(String.self))
        } catch DecodingError.typeMismatch {
            do {
                self = try .int(container.decode(Int.self))
            } catch DecodingError.typeMismatch {
                throw DecodingError.typeMismatch(StringOrInt.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Encoded payload not of an expected type"))
            }
        }
    }
}
