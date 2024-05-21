//
// FullSizeImgeViewer
//
// ImageViewer
//
//  Created by Olga Lidman on 2023-02-01
//
//
import Foundation
import SwiftUI

struct FullScreenImageGallery: View {
    // MARK: - Properties
    @Binding var showView: Bool
    @State var currentPage: Int
    let imagesUrls: [String]
    
    // MARK: - Init
    init(showView: Binding<Bool>,
         imagesUrls: [String],
         currentPage: Int) {
        self._showView = showView
        self.imagesUrls = imagesUrls
        self.currentPage = currentPage
    }
    
    // MARK: - Body
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                PageView(pages: imagesUrls.map { ImageScrollView(frame: .init(origin: .zero, size: proxy.size), url: $0) },
                         currentPage: $currentPage)
                VStack {
                    Spacer()
                    Text("\(currentPage+1)/\(imagesUrls.count)")
                        .font(.footnote)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 2)
                        .background {
                            Color.black.opacity(0.7)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                        }
                        .padding(.bottom, max(.bottomArea, 10))
                }

                HStack(alignment: .top) {
                    Spacer()
                    VStack {
                        Button {
                            showView.toggle()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .renderingMode(.template)
                                .resizable()
                                .imageScale(.large)
                                .foregroundStyle(.white, .black.opacity(0.7))
                                .frame(width: 30, height: 30)
                        }
                        .padding(.top, .topArea + 10)
                        .padding(.horizontal, 16)
                        Spacer()
                    }
                }
            }
        }
        .animation(.easeIn, value: showView)
        .background(.black)
        .edgesIgnoringSafeArea(.all)
    }
}
