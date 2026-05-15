//
//  ImageCache.swift
//  Await
//
//  Created by Влад Шимченко on 15.05.26.
//

import Foundation


actor ImageCache {

    private var storage: [URL: Data] = [:]

    func image(for url: URL) -> Data? {
        storage[url]
    }

    func save(_ data: Data, for url: URL) {
        storage[url] = data
    }

}


final class APIClient {

    private let cache = ImageCache()

    func fetchImage(from url: URL) async throws -> Data {

        if let cached = await cache.image(for: url) {
            print("from cache:", url.lastPathComponent)
            return cached
        }

        print("downloading:", url.lastPathComponent)

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let HTTPResponse = response as? HTTPURLResponse,
              200...299 ~= HTTPResponse.statusCode
        else {
            throw APIError.responseFailure
        }

        await cache.save(data, for: url)

        return data
    }

    func fetchGallery(urls: [URL]) async throws -> [Data] {

        try await withThrowingTaskGroup(of: Data.self) { group in
            for url in urls {
                group.addTask { [weak self] in

                    guard let self else { throw CancellationError() }

                    return try await self.fetchImage(from: url)

                }
            }

            var result: [Data] = []

            for try await imageData in group {
                result.append(imageData)
            }

            return result
        }
    }

}
