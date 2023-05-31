//  Created by p0ch1ta on 26/05/2023 for project VSkipper

import Foundation
import XMLCoder

class VLCService {

    struct VLCResponse: Codable {
        let time: Int
    }

    static let shared = VLCService()

    @UserDefault(key: APP.UserDefaults.vlcPort, defaultValue: APP.VLC.port)
    var port: Int

    @UserDefault(key: APP.UserDefaults.vlcPassword, defaultValue: "")
    var password: String

    private init() {}

    func getCurrentTime() async throws -> Int {

        guard let url = URL(string: "\(APP.VLC.url):\(port)\(APP.VLC.statusPath)") else {
            throw VLCServiceError.invalidURL
        }

        var request = URLRequest(url: url)

        request.httpMethod = "GET"
        request.setValue(
            "Basic \(":\(password)".toBase64())",
            forHTTPHeaderField: "Authorization"
        )

        let (data, _) = try await URLSession.shared.data(for: request)

        let decoder = XMLDecoder()
        let response = try? decoder.decode(VLCResponse.self, from: data)

        guard let response = response else {
            throw VLCServiceError.decodingError
        }

        return response.time
    }

}
