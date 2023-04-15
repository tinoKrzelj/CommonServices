//
//  ImageService.swift
//  Common Services
//
//  Created by Tino Krzelj on 15/04/2023.
//

import SwiftUI

struct ImageService {
    
    enum ImageServiceError: Error {
        case badStringUrl
        case failedUrlSession
        case badImageData
    }
    
    func fetchImage(stringUrl: String) async throws -> UIImage {
        guard let url = URL(string: stringUrl) else { throw ImageServiceError.badStringUrl }
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw ImageServiceError.failedUrlSession }
        guard let image = UIImage(data: data) else { throw ImageServiceError.badImageData }
        return image
    }
    
}
