//
// FullSizeImgeViewer
//
// ImageCacheManager
//
//  Created by Olga Lidman on 2023-02-01
//
//

import Foundation
import UIKit
import OSLog

fileprivate let logger = Logger(subsystem: "fullSizeImageViewer", category: "image-cache-manager")

final class ImageCacheManager {
    static let instance = ImageCacheManager()
    
    private let documentDirectoryPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first

    private init() {}
    
    // MARK: - Get Image
    func getImageWithUrl(_ urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        let fileName = url.lastPathComponent
        if let image = load(fileName: fileName) {
            completion(image)
        } else {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                guard let data = try? Data(contentsOf: url),
                      let image = UIImage(data: data) else {
                    logger.log("Failed to load remote image from url: \(url)")
                    completion(nil)
                    return
                }
                self?.save(image, fileName: fileName)
                completion(image)
            }
        }
    }

    // MARK: - Save / Load
    private func save(_ image: UIImage, fileName: String) {
        if let jpgData = image.jpegData(compressionQuality: 1),
            let path = documentDirectoryPath?.appendingPathComponent(fileName) {
            do {
                try jpgData.write(to: path)
            } catch {
                logger.log("Failed to save image: \(fileName)")
            }
        }
    }

    private func load(fileName: String) -> UIImage? {
        guard let url = documentDirectoryPath?.appendingPathComponent(fileName),
              let imageData = try? Data(contentsOf: url) else {
            return nil
        }
        return UIImage(data: imageData)
    }
}
