//
//  APIServiceError.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/02/23.
//

import Foundation

enum APIServiceError: Error {
    case urlEncodingError
    case clientError(message: String?)
    case serverError
}
