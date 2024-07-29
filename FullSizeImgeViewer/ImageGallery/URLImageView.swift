//
// FullSizeImgeViewer
//
// URLImageView
//
//  Created by Olga Lidman on 2023-02-01
//
//

import UIKit

class URLImageView: UIImageView {
    let url: String
    
    init(url: String) {
        self.url = url
        super.init(frame: .zero)
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        UIImage.fromUrls([url]) { [weak self] images in
            self?.image = images.first
        }
    }
}
