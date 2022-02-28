//
//  JSONDecoder+Extension.swift
//  FakeBithumbAssignment
//
//  Created by momo on 2022/02/24.
//

import Foundation

extension JSONDecoder {
    func decode<T: Decodable>(_ type: T.Type, from jsonString: String) -> T? {
        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }
        return try? self.decode(T.self, from: data)
    }
}
