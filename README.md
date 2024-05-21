Page controller for viewing gallery of images that can be added to a SwiftUI view. Takes an array of urls and displays zoomable and scrollable images.
This control is a combination of two elements with some changes for my personal needs.

Sources:

Page control: https://gist.github.com/stleamist/ef5d8c896edc737cea34b07291c2ca6c

Image Scroll View: https://github.com/huynguyencong/ImageScrollView/tree/master


Usage example:

```
struct ContentView: View {
    @State var showImageViewer: Bool = false
    
    private let urls = [
        "https://i.pinimg.com/736x/8a/6b/44/8a6b4439916eb8c3d52cbc2de66150d7.jpg",
        "https://www.health.com/thmb/fbyHcuD2A3OrfZTC-LUJIPsKKVk=/2121x0/filters:no_upscale():max_bytes(150000):strip_icc()/HealthiestFruits-feb2318dc0a3454993007f57c724753f.jpg",
        "https://images.immediate.co.uk/production/volatile/sites/30/2023/02/Bowl-of-fruit-5155e6f.jpg?quality=90&resize=440,400",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQLxUJ0F_pTZcHI9IFnHTbGBjsl_ecvye3KcCGB50nuwQ&s"
    ]
    
    var body: some View {
        ZStack {
            Button {
                showImageViewer.toggle()
            } label: {
                Image(systemName: "photo")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Show gallery")
            }
            .padding()
            if showImageViewer {
                FullScreenImageGallery(showViewer: $showImageViewer,
                                       imagesUrls: urls,
                                       currentPage: 0)
            }
        }
    }
}
```
