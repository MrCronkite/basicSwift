//
//  GalleryViewModel.swift
//  Await
//
//  Created by Влад Шимченко on 15.05.26.
//

import Foundation


@MainActor
final class GalleryViewModel {

    private let api = APIClient()
    private let network = Networking()

    private(set) var images: [Data] = []

    func getCoins() {
        Task {
            do {
                let coins = try await network.getCoinsData()
                print("coins sucses", coins.count)
                let urls = coins.compactMap { URL(string: $0.image) }
                load(urls: urls)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func load(urls: [URL]) {

        Task {

            do {

                async let firstBatch = api.fetchGallery(urls: urls)

                let allImages = try await firstBatch
                self.images = allImages

                print("Total", allImages.count)
            } catch is CancellationError {
                print("TASK Cancelled")
            } catch {
                print(error)
            }
        }
    }
}
