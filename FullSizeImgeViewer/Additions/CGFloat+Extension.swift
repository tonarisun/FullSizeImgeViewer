//
// FullSizeImgeViewer
//
// UIDevice+Extension
//
//  Created by Olga Lidman on 2023-02-01
//
//

import UIKit

extension CGFloat {
    static var topArea: CGFloat {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        return window?.safeAreaInsets.top ?? 0
    }
    
    static var bottomArea: CGFloat {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        return window?.safeAreaInsets.bottom ?? 0
    }
}
