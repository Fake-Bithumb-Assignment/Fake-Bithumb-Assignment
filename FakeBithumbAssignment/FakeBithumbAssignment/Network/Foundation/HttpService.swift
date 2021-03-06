//
//  APIService.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/02/23.
//

import Foundation

final class HttpService {
    var requestTimeOut: Float = 30
    
    func request<T: Decodable>(_ request: NetworkRequest) async throws -> T? {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = TimeInterval(request.requestTimeOut ?? requestTimeOut)
        sessionConfig.requestCachePolicy = .reloadIgnoringLocalCacheData
        guard let encodedUrl = request.url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedUrl) else {
                  throw HttpServiceError.urlEncodingError
              }
        let (data, response) = try await URLSession(configuration: sessionConfig).data(for: request.buildURLRequest(with: url))
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<500) ~= httpResponse.statusCode else {
                  throw HttpServiceError.serverError
              }
        let decoder = JSONDecoder()
        let baseModelData = try decoder.decode(BaseModel<T>.self, from: data)
        if baseModelData.status == "0000" {
            return baseModelData.data
        } else {
            throw HttpServiceError.clientError(message: baseModelData.message)
        }
    }
}

