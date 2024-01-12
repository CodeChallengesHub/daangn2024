//
//  APIService.swift
//  ITBook
//
//  Created by TAE SU LEE on 1/10/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import Foundation

typealias SearchAPIService = APIService<SearchAPI>

final class APIService<Endpoint: APIEndpoint> {
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
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
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
                // 오류 처리. 예를 들어, 특정 오류 타입 또는 상태 코드에 따른 메시지를 던질 수 있습니다.
                throw URLError(.badServerResponse)
            }
            
            // 데이터 로그 (예: JSON 문자열로)
#if DEBUG
            if let jsonDataString = String(data: data, encoding: .utf8) {
                TSLogger.api("Received Data: \(jsonDataString)")
            }
#endif
            return data
        } catch {
            // 오류 처리
            throw error
        }
    }
}
