//
//  APIEnvironment.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/02/23.
//

import Foundation

enum HttpEnvironment: String, CaseIterable {
    case development

    var baseUrl: String {
        return "https://api.bithumb.com/public"
    }
}
