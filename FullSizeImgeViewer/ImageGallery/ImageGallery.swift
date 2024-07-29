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

struct ImageGallery: View {
    struct PageLabelPosition {
        let alignment: HorizontalAlignment
        let bottomSpacing: CGFloat
        let horizontalSpacing: CGFloat
    }
    
    // MARK: - Properties
    @Binding var showView: Bool
    @Binding var currentPage: Int
    @State var opacity: CGFloat = 0
    let imagesUrls: [String]
    let isZoomable: Bool
    let isAlwaysShown: Bool
    let backgroundColor: Color
    let pageLabelPosition: PageLabelPosition
    
    // MARK: - Init
    init(showView: Binding<Bool> = .constant(true),
         imagesUrls: [String],
         zoomEnabled: Bool,
         isAlwaysShown: Bool = false,
         backgroundColor: Color = .black,
         pageLabelPosition: PageLabelPosition ,
         currentPage: Binding<Int>) {
        self.isAlwaysShown = isAlwaysShown
        self._showView = isAlwaysShown ? .constant(true) : showView
        self.imagesUrls = imagesUrls
        self.isZoomable = zoomEnabled
        self.pageLabelPosition = pageLabelPosition
        self._currentPage = currentPage
        self.backgroundColor = backgroundColor
    }
    
    // MARK: - Body
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                PageView(pages: imagesUrls.map { 
                    if isZoomable {
                        ImageScrollView(frame: .init(origin: .zero, size: proxy.size), url: $0)
                    } else {
                        URLImageView(url: $0)
                    }
                },
                         currentPage: $currentPage)
                VStack {
                    Spacer()
                    switch pageLabelPosition.alignment {
                    case .center: 
                        pageLabel()
                    case .leading:
                        HStack {
                            pageLabel()
                            Spacer()
                        }
                    case .trailing:
                        HStack {
                            Spacer()
                            pageLabel()
                        }
                    default:
                        pageLabel()
                    }
                }

                if !isAlwaysShown {
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
        }
        .animation(.easeInOut(duration: 2), value: showView)
        .background(backgroundColor)
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    private func pageLabel() -> some View {
        Text("\(currentPage+1)/\(imagesUrls.count)")
            .font(.footnote)
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 2)
            .background {
                Color.black.opacity(0.7)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
            }
            .padding(.bottom, pageLabelPosition.bottomSpacing)
            .padding(.horizontal, pageLabelPosition.horizontalSpacing)
    }
}
