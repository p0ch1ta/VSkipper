//  Created by p0ch1ta on 19/03/2023 for project VSkipper

import Foundation
import XMLCoder

class VLCApi {

    struct VLCResponse: Codable {
        let time: Int
        let currentplid: Int
        let information: Information
    }

    struct Information: Codable {
        let category: [Category]

        enum CodingKeys: String, CodingKey {
            case category = "category"
        }
    }

    struct Category: Codable {
        let name: String
        let info: [Info]

        enum CodingKeys: String, CodingKey {
            case name = "name"
            case info = "info"
        }
    }

    struct Info: Codable, DynamicNodeEncoding {
        static func nodeEncoding(for key: CodingKey) -> XMLCoder.XMLEncoder.NodeEncoding {
            switch key {
            case CodingKeys.name:
                return .attribute
            default:
                return .element
            }
        }

        let name: String
        let value: String

        enum CodingKeys: String, CodingKey {
            case name
            case value = ""
        }
    }

    private var url: URL
    private var password: String

    init(port: Int, password: String) {
        url = URL(string: "http://127.0.0.1:\(port)/requests/status.xml")!
        self.password = password
    }

    func skipForward(seconds: Int) {
        let params = [
            URLQueryItem(name: "command", value: "seek"),
            URLQueryItem(name: "val", value: "+\(seconds)s")
        ]

        let request = getURLRequestWithAuthorization(params: params)

        let session = URLSession.shared

        let (_, _, _) = session.synchronousDataTask(request: request)
    }
    
    func playNext() {
        let params = [
            URLQueryItem(name: "command", value: "pl_next")
        ]

        let request = getURLRequestWithAuthorization(params: params)

        let session = URLSession.shared

        let (_, _, _) = session.synchronousDataTask(request: request)
    }

    func getCurrentTime() throws -> Int {
        let request = getURLRequestWithAuthorization(params: [])

        let session = URLSession.shared

        let (data, _, _) = session.synchronousDataTask(request: request)

        guard let data = data else {
            throw VLCError.noData
        }

        let decoder = XMLDecoder()
        let response = try? decoder.decode(VLCResponse.self, from: data)

        guard let response = response else {
            throw VLCError.decodingError
        }

        return response.time
    }

    func getCurrentFileName() throws -> String {
        let request = getURLRequestWithAuthorization(params: [])

        let session = URLSession.shared

        let (data, _, _) = session.synchronousDataTask(request: request)

        guard let data = data else {
            throw VLCError.noData
        }

        let decoder = XMLDecoder()
        let response = try? decoder.decode(VLCResponse.self, from: data)

        guard let response = response else {
            throw VLCError.decodingError
        }

        let category = response.information.category.first(where: { $0.name == "meta" })
        let info = category?.info.first(where: { $0.name == "filename" })
        guard let fileName = info?.value else {
            throw VLCError.decodingError
        }

        guard let decodedFileName = fileName.decodeHTMLSymbols() else {
            throw VLCError.decodingError
        }

        return decodedFileName
    }

    func getCurrentTimeWithFilename() throws -> (Int, String) {
        let request = getURLRequestWithAuthorization(params: [])

        let session = URLSession.shared

        let (data, _, _) = session.synchronousDataTask(request: request)

        guard let data = data else {
            throw VLCError.noData
        }

        let decoder = XMLDecoder()
        let response = try? decoder.decode(VLCResponse.self, from: data)

        guard let response = response else {
            throw VLCError.decodingError
        }

        let category = response.information.category.first(where: { $0.name == "meta" })
        let info = category?.info.first(where: { $0.name == "filename" })
        guard let fileName = info?.value else {
            throw VLCError.decodingError
        }

        guard let decodedFileName = fileName.decodeHTMLSymbols() else {
            throw VLCError.decodingError
        }

        return (response.time, decodedFileName)
    }

    private func getURLRequestWithAuthorization(params: [URLQueryItem]) -> URLRequest {

        var resultURL = url

        if !params.isEmpty {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = params
            resultURL = components?.url ?? url
        }

        var request = URLRequest(url: resultURL)

        request.httpMethod = "GET"
        request.setValue(
            "Basic \(":\(password)".toBase64())",
            forHTTPHeaderField: "Authorization"
        )

        return request
    }
    
}
