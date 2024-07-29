//
// FullSizeImgeViewer
//
// ContentView
//
//  Created by Olga Lidman on 2023-02-01
//
//

import SwiftUI

struct ContentView: View {
    @State var showImageViewer: Bool = false
    @State var currentImageIndex: Int = 0
    
    private let urls = [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQLxUJ0F_pTZcHI9IFnHTbGBjsl_ecvye3KcCGB50nuwQ&s",
        "https://i.pinimg.com/736x/8a/6b/44/8a6b4439916eb8c3d52cbc2de66150d7.jpg",
        "https://www.health.com/thmb/fbyHcuD2A3OrfZTC-LUJIPsKKVk=/2121x0/filters:no_upscale():max_bytes(150000):strip_icc()/HealthiestFruits-feb2318dc0a3454993007f57c724753f.jpg",
        "https://images.immediate.co.uk/production/volatile/sites/30/2023/02/Bowl-of-fruit-5155e6f.jpg?quality=90&resize=440,400"
        
    ]

    var body: some View {
        ZStack {
            VStack {
                ImageGallery(imagesUrls: urls, 
                             zoomEnabled: false,
                             isAlwaysShown: true,
                             pageLabelPosition: .init(alignment: .leading, bottomSpacing: 10, horizontalSpacing: 16),
                             currentPage: $currentImageIndex)
                    .frame(height: 300)
                Button {
                    showImageViewer.toggle()
                } label: {
                    Image(systemName: "photo")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("Full screen view")
                }
                .padding()
                Spacer()
            }
            
            if showImageViewer {
                ImageGallery(showView: $showImageViewer,
                             imagesUrls: urls,
                             zoomEnabled: true,
                             pageLabelPosition: .init(alignment: .center, bottomSpacing: max(.bottomArea, 20), horizontalSpacing: 16),
                             currentPage: $currentImageIndex)
            }
        }
        .ignoresSafeArea(.all)
    }
}

#Preview {
    ContentView()
}


