//
//  APIService.swift
//  ITBook
//
//  Created by TAE SU LEE on 1/10/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import Core
import Foundation

typealias SearchAPIService = APIService<SearchAPI>

struct APIService<Endpoint: APIEndpointProtocol> {
    private let session: APISessionProtocol
    
    init(session: APISessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func request(_ endpoint: Endpoint) async throws -> Data {
        let url = endpoint.baseURL.appendingPathComponent(endpoint.path)
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        // HTTP 헤더 설정
        endpoint.headers?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        // HTTP 바디 설정
        switch endpoint.task {
        case .requestPlain:
            break
        case .requestData(let data):
            request.httpBody = data
        case .requestParameters(let parameters):
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        }
        
        // 요청 로그
        TSLogger.api("Request \(url)")
        TSLogger.api("HTTP Method: \(request.httpMethod ?? "N/A")")
        TSLogger.api("Headers: \(request.allHTTPHeaderFields ?? [:])")
        
        do {
            let (data, response) = try await session.data(for: request)
            
            // 응답 로그
            if let httpResponse = response as? HTTPURLResponse {
                TSLogger.api("Response Status Code: \(httpResponse.statusCode)")
                TSLogger.api("Response Headers: \(httpResponse.allHeaderFields)")
            }
            
            // HTTP 응답 상태 코드 검증
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                let error = URLError(.badServerResponse)
                TSLogger.api("Error: \(error)")
                throw error
            }
#if DEBUG
            if let jsonDataString = String(data: data, encoding: .utf8) {
                TSLogger.api("Received Data: \(jsonDataString)")
            }
#endif
            return data
        } catch {
            TSLogger.api("Error: \(error)")
            throw error
        }
    }
}
