//
// FullSizeImgeViewer
//
// UIImage+Extension
//
//  Created by Olga Lidman on 2023-02-01
//
//

import UIKit

extension UIImage {
    
    static func fromUrls(_ urls: [String], completion: @escaping ([UIImage]) -> Void) {
        var images = [UIImage]()
        urls.forEach { url in
            ImageCacheManager.instance.getImageWithUrl(url) { image in
                guard let unwrappedImage = image else { return }
                images.append(unwrappedImage)
                
                if url == urls.last {
                    completion(images)
                }
            }
        }
    }
}
