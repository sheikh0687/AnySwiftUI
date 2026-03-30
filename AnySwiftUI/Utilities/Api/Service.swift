//
//  Service.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 09/03/26.
//

import Foundation
import Alamofire
import UIKit

// MARK: - Error Enum
enum ApiError: Error, LocalizedError {
    case noInternet
    case serverError(String)
    case decodingError(String)
    case invalidResponse
    case invalidUrl
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .noInternet:
            return "No Internet connection. Please check your network."
        case .serverError(let msg):
            return msg
        case .decodingError(let msg):
            return "Data parsing failed: \(msg)"
        case .invalidResponse:
            return "Received an invalid response from server."
        case .unknown(let msg):
            return msg
        case .invalidUrl:
            return "Received an invalid url from server."
        }
    }
}

// MARK: - Service Layer
final class Service {
    
    static let shared = Service()
    private init() {}
    
//    private let session: Session = {
//        let config = URLSessionConfiguration.default
//        config.timeoutIntervalForRequest = 60
//        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
//        config.urlCache = nil
//        return Session(configuration: config)
//    }()

    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 60
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        config.urlCache = nil
        return URLSession(configuration: config)
    }()
    
    // MARK: - Connectivity Check
    private func checkConnection() -> Bool {
        return Utility.checkNetworkConnectivityWithDisplayAlert(isShowAlert: false)
    }
    
    // MARK: - Raw Data Request
//    func requestData (
//        url: String,
//        method: HTTPMethod = .post,
//        params: [String: Any]? = nil
//    ) async throws -> Data {
//        guard checkConnection() else { throw ApiError.noInternet }
//        
//        let request = session.request(url, method: method, parameters: params)
//        let data = try await request.serializingData().value
//        
//        if let params = params, !params.isEmpty {
//            let queryString = params.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
//            let fullUrl = "\(url)?\(queryString)"
//            print("""
//            🟢 Full API for Browser
//            ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//            \(fullUrl)
//            ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//            """)
//        } else {
//            print("""
//            🟢 Full API for Browser
//            ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//            \(url)
//            ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//            """)
//        }
//        
//        return data
//    }
    
//    func requestData (
//        url: String,
//        method: String = "GET",
//        params: [String: Any]? = nil
//    ) async throws -> Data {
//        
//        guard checkConnection() else { throw ApiError.noInternet }
//        
//        var finalURL = url
//        
//        // ✅ Handle GET params in URL
//        if method == "GET", let params = params {
//            var components = URLComponents(string: url)!
//            components.queryItems = params.map {
//                URLQueryItem(name: $0.key, value: "\($0.value)")
//            }
//            finalURL = components.url?.absoluteString ?? url
//        }
//        
//        guard let requestURL = URL(string: finalURL) else {
//            throw ApiError.invalidUrl
//        }
//        
//        var request = URLRequest(url: requestURL)
//        request.httpMethod = method
//        
//        if method != "Get", let params = params {
//            request.httpBody = try JSONSerialization.data(withJSONObject: params)
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        }
//        
//        let (data, response) = try await session.data(for: request)
//        
//        guard let httpResponse = response as? HTTPURLResponse else {
//            throw ApiError.invalidResponse
//        }
//        
//        guard 200...299 ~= httpResponse.statusCode else {
//            throw ApiError.serverError("Status Code: \(httpResponse.statusCode)")
//        }
//        
//        if let params = params, !params.isEmpty {
//            let queryString = params.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
//            let fullUrl = "\(url)?\(queryString)"
//            print("""
//            🟢 Full API for Browser
//            ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//            \(fullUrl)
//            ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//            """)
//        } else {
//            print("""
//            🟢 Full API for Browser
//            ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//            \(url)
//            ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//            """)
//        }
//        
//        return data
//    }

    func requestData(
        url: String,
        method: String = "GET",
        params: [String: Any]? = nil
    ) async throws -> Data {
        
        guard checkConnection() else { throw ApiError.noInternet }
        
        let uppercasedMethod = method.uppercased()
        var finalURL = url
        
        var components: URLComponents?
        
        // ✅ Handle GET params in URL
        if uppercasedMethod == "GET", let params = params, !params.isEmpty {
            components = URLComponents(string: url)
            components?.queryItems = params.map {
                URLQueryItem(name: $0.key, value: "\($0.value)")
            }
            finalURL = components?.url?.absoluteString ?? url
        }
        
        guard let requestURL = URL(string: finalURL) else {
            throw ApiError.invalidUrl
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = uppercasedMethod
        
        // ✅ Only attach body for NON-GET
        if uppercasedMethod != "GET", let params = params {
            request.httpBody = try JSONSerialization.data(withJSONObject: params)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // ✅ PRINT FULL URL (Browser Ready)
        print("""
        🟢 Final API URL (Encoded)
        ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        \(finalURL)
        ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        """)
        
        // ✅ OPTIONAL: Readable params (non-encoded)
//        if let params = params, !params.isEmpty {
//            let readableQuery = params.map { "\($0.key)=\($0.value)" }
//                .joined(separator: "&")
//            
//            print("""
//            🟡 Readable Params
//            ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//            \(url)?\(readableQuery)
//            ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//            """)
//        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ApiError.invalidResponse
        }
        
        // ✅ Raw response
        if let responseString = String(data: data, encoding: .utf8) {
            print("""
            🔴 Raw Response:
            ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            \(responseString)
            ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            """)
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            throw ApiError.serverError("Status Code: \(httpResponse.statusCode)")
        }
        
        return data
    }

    
    // MARK: - Decodable Request
//    func request<T: Decodable> (
//        url: String,
//        method: HTTPMethod = .post,
//        params: [String: Any]? = nil,
//        responseType: T.Type
//    ) async throws -> T {
//        let data = try await requestData(url: url, method: method, params: params)
//        return try JSONDecoder().decode(T.self, from: data)
//    }

//    func request<T: Decodable> (
//        url: String,
//        method: String = "GET",
//        params: [String: Any]? = nil,
//        responseType: T.Type
//    ) async throws -> T {
//        
//        let data = try await requestData (
//            url: url,
//            method: method,
//            params: params
//        )
//        
//        do {
//            return try JSONDecoder().decode(T.self, from: data)
//        } catch {
//            throw ApiError.decodingError(error.localizedDescription)
//        }
//    }

    func request<T: Decodable> (
        url: String,
        method: String = "GET",
        params: [String: Any]? = nil,
        responseType: T.Type
    ) async throws -> T {
        
        let data = try await requestData (
            url: url,
            method: method,
            params: params
        )
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            if let raw = String(data: data, encoding: .utf8) {
                print("❌ Decoding Failed. Raw JSON:\n\(raw)")
            }
            throw ApiError.decodingError(error.localizedDescription)
        }
    }

    
//    func uploadSingleMedia<T: Decodable> (
//        url: String,
//        params: [String: String]? = nil,
//        images: [String: UIImage]? = nil,
//        videos: [String: Data]? = nil,
//        responseType: T.Type
//    ) async throws -> T {
//        
//        guard checkConnection() else { throw ApiError.noInternet}
//        
//        return try await withCheckedThrowingContinuation { continuation in
//            session.upload(multipartFormData: { multipart in
//                self.appendParameters(params, to: multipart)
//                self.appendImages(images, to: multipart)
//                self.appendVideos(videos, to: multipart)
//            }, to: url)
//            .validate()
//            .responseData { response in
//                switch response.result {
//                case .success(let data):
//                    do {
//                        let decoded = try JSONDecoder().decode(T.self, from: data)
//                        continuation.resume(returning: decoded)
//                    } catch {
//                        print("❌ Decoding failed: \(error.localizedDescription)")
//                        continuation.resume(throwing: ApiError.decodingError(error.localizedDescription))
//                    }
//                case .failure(let error):
//                    print("❌ Upload Failed: \(error.localizedDescription)")
//                    continuation.resume(throwing: ApiError.serverError(error.localizedDescription))
//                }
//            }
//        }
//    }
    
    func uploadSingleMedia<T: Decodable> (
        url: String,
        params: [String: String]? = nil,
        images: [String: UIImage]? = nil,
        videos: [String: Data]? = nil,
        responseType: T.Type
    ) async throws -> T {
        
        guard checkConnection() else { throw ApiError.noInternet }
        
        guard let requestURL = URL(string: url) else {
            throw ApiError.invalidUrl
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        
        request.setValue(
            "multipart/form-data; boundary=\(boundary)",
            forHTTPHeaderField: "Content-Type"
        )
        
        var body = Data()
        
        // Parameters
        params?.forEach { key, value in
            
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            
            body.append(
                "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n"
                    .data(using: .utf8)!
            )
            
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        // Images
        images?.forEach { key, image in
            
            if let imageData = image.jpegData(compressionQuality: 0.7) {
                
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                
                body.append(
                    "Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(key).jpg\"\r\n"
                        .data(using: .utf8)!
                )
                
                body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                
                body.append(imageData)
                
                body.append("\r\n".data(using: .utf8)!)
            }
        }
        
        // Videos
        videos?.forEach { key, data in
            
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            
            body.append(
                "Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(key).mp4\"\r\n"
                    .data(using: .utf8)!
            )
            
            body.append("Content-Type: video/mp4\r\n\r\n".data(using: .utf8)!)
            
            body.append(data)
            
            body.append("\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let (data, _) = try await session.data(for: request)
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw ApiError.decodingError(error.localizedDescription)
        }
    }

    
    // MARK: - Upload Multiple Media
//    func uploadMultipleMedia (
//        url: String,
//        params: [String: String]? = nil,
//        imageArrays: [String: [UIImage]]? = nil,
//        videoURLs: [String: [URL]]? = nil
//    ) async throws -> Data {
//        guard checkConnection() else { throw ApiError.noInternet }
//        
//        return try await withCheckedThrowingContinuation { continuation in
//            session.upload(multipartFormData: { multipart in
//                self.appendParameters(params, to: multipart)
//                
//                // Multiple Images
//                imageArrays?.forEach { key, images in
//                    for image in images {
//                        if let data = image.jpegData(compressionQuality: 0.7) {
//                            multipart.append(data,
//                                             withName: key,
//                                             fileName: "\(UUID().uuidString).jpg",
//                                             mimeType: "image/jpeg")
//                        }
//                    }
//                }
//                
//                // Multiple Videos
//                videoURLs?.forEach { key, urls in
//                    for url in urls {
//                        multipart.append(url,
//                                         withName: key,
//                                         fileName: "\(UUID().uuidString).mp4",
//                                         mimeType: "video/mp4")
//                    }
//                }
//            }, to: url)
//            .validate()
//            .responseData { response in
//                switch response.result {
//                case .success(let data):
//                    continuation.resume(returning: data)
//                case .failure(let error):
//                    continuation.resume(throwing: ApiError.serverError(error.localizedDescription))
//                }
//            }
//        }
//    }
    
    func uploadMultipleMedia(
        url: String,
        params: [String: String]? = nil,
        imageArrays: [String: [UIImage]]? = nil,
        videoURLs: [String: [URL]]? = nil
    ) async throws -> Data {
        
        guard checkConnection() else { throw ApiError.noInternet }
        
        guard let requestURL = URL(string: url) else {
            throw ApiError.invalidUrl
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        
        request.setValue(
            "multipart/form-data; boundary=\(boundary)",
            forHTTPHeaderField: "Content-Type"
        )
        
        var body = Data()
        
        params?.forEach { key, value in
            
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            
            body.append(
                "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n"
                    .data(using: .utf8)!
            )
            
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        // Multiple Images
        imageArrays?.forEach { key, images in
            
            for image in images {
                
                if let data = image.jpegData(compressionQuality: 0.7) {
                    
                    body.append("--\(boundary)\r\n".data(using: .utf8)!)
                    
                    body.append(
                        "Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(UUID().uuidString).jpg\"\r\n"
                            .data(using: .utf8)!
                    )
                    
                    body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                    
                    body.append(data)
                    
                    body.append("\r\n".data(using: .utf8)!)
                }
            }
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let (data, _) = try await session.data(for: request)
        
        return data
    }

//    func requestJSON (
//        url: String,
//        parameters params: [String: Any]? = nil,
//        method: String = "POST"
//    ) async throws -> AnyObject {
//        
//        let data = try await requestData(
//            url: url,
//            method: method,
//            params: params
//        )
//        
//        do {
//            let json = try JSONSerialization.jsonObject(with: data)
//            return json as AnyObject
//        } catch {
//            throw ApiError.decodingError(error.localizedDescription)
//        }
//    }

//    func requestJSON (
//        url: String,
//        parameters params: [String: Any]? = nil,
//        method: HTTPMethod = .post
//    ) async throws -> AnyObject {
//        
//        guard checkConnection() else { throw ApiError.noInternet }
//        
//        print("📡 URL:", url)
//        print("📦 Params:", params ?? [:])
//        print("➡️ Method:", method.rawValue)
//        
//        let encoding: ParameterEncoding = (method == .get)
//        ? URLEncoding.default
//        : JSONEncoding.default   // ✅ important
//        
//        return try await withCheckedThrowingContinuation { continuation in
//            session.request (
//                url,
//                method: method,
//                parameters: params,
//                encoding: encoding
//            )
//            // 🚨 TEMPORARILY REMOVE validate() to debug
//            //.validate()
//            .responseData { response in
//                
//                print("📊 Status Code:", response.response?.statusCode ?? -1)
//                
//                if let data = response.data,
//                   let raw = String(data: data, encoding: .utf8) {
//                    print("📄 Raw Response:", raw)
//                }
//                
//                switch response.result {
//                case .success(let data):
//                    do {
//                        let json = try JSONSerialization.jsonObject(with: data)
//                        continuation.resume(returning: json as AnyObject)
//                    } catch {
//                        continuation.resume (
//                            throwing: ApiError.decodingError(error.localizedDescription)
//                        )
//                    }
//                    
//                case .failure(let error):
//                    continuation.resume (
//                        throwing: ApiError.serverError(error.localizedDescription)
//                    )
//                }
//            }
//        }
//    }
}

// MARK: - Multipart Helpers
private extension Service {
    
    func appendParameters(_ params: [String: String]?, to multipart: MultipartFormData) {
        params?.forEach { key, value in
            if let data = value.data(using: .utf8) {
                multipart.append(data, withName: key)
            }
        }
    }
    
    func appendImages(_ images: [String: UIImage]?, to multipart: MultipartFormData) {
        images?.forEach { key, image in
            if let data = image.jpegData(compressionQuality: 0.7) {
                multipart.append(data,
                                 withName: key,
                                 fileName: "\(key).jpg",
                                 mimeType: "image/jpeg")
            }
        }
    }
    
    func appendVideos(_ videos: [String: Data]?, to multipart: MultipartFormData) {
        videos?.forEach { key, data in
            multipart.append(data,
                             withName: key,
                             fileName: "\(key).mp4",
                             mimeType: "video/mp4")
        }
    }
}
