//
// FullSizeImgeViewer
//
// ImageScrollView
//
//  Created by Olga Lidman on 2023-02-01
//
//

import Foundation
import UIKit

// MARK: - ImageScrollViewDelegate Protocol
protocol ImageScrollViewDelegate: UIScrollViewDelegate {
    func imageScrollViewDidChangeOrientation(imageScrollView: ImageScrollView)
}

final class ImageScrollView: UIScrollView {
    // MARK: - Properties
    private let image: UIImage
    private var zoomView: UIImageView?
    private var pointToCenterAfterResize: CGPoint = CGPoint.zero
    private var scaleToRestoreAfterResize: CGFloat = 1
    private weak var imageScrollViewDelegate: ImageScrollViewDelegate?
    
    override var frame: CGRect {
        willSet {
            if !frame.equalTo(newValue) && !newValue.equalTo(.zero) && !image.size.equalTo(CGSize.zero) {
                prepareToResize()
            }
        }
        
        didSet {
            if !frame.equalTo(oldValue) && !frame.equalTo(CGRect.zero) && !image.size.equalTo(CGSize.zero) {
                recoverFromResizing()
            }
        }
    }

    // MARK: - Initialization
    public init(frame: CGRect, image: UIImage) {
        self.image = image
        super.init(frame: frame)
        
        initialize()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initialize() {
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        bouncesZoom = true
        bounces = true
        decelerationRate = UIScrollView.DecelerationRate.fast
        delegate = self
        
        display()
    }
    
    // MARK: - Set Max Min Zoom
    private func setMaxMinZoomScalesForCurrentBounds() {
        var minScale = bounds.width / image.size.width
        let maxScale = (image.size.width / bounds.width) * minScale
        if minScale > maxScale {
            minScale = maxScale
        }
        
        maximumZoomScale = maxScale
        minimumZoomScale = minScale
    }

    // MARK: - Adjust To Center
    private func adjustFrameToCenter() {
        guard let unwrappedZoomView = zoomView else {
            return
        }
        
        var frameToCenter = unwrappedZoomView.frame
        
        if frameToCenter.size.width < bounds.width {
            frameToCenter.origin.x = (bounds.width - frameToCenter.size.width) / 2
        }
        else {
            frameToCenter.origin.x = 0
        }
        
        if frameToCenter.size.height < bounds.height {
            frameToCenter.origin.y = (bounds.height - frameToCenter.size.height) / 2
        }
        else {
            frameToCenter.origin.y = 0
        }
        
        unwrappedZoomView.frame = frameToCenter
    }
    
    // MARK: - Resizing
    private func prepareToResize() {
        let boundsCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        pointToCenterAfterResize = convert(boundsCenter, to: zoomView)
        
        scaleToRestoreAfterResize = zoomScale

        if scaleToRestoreAfterResize <= minimumZoomScale + CGFloat(Float.ulpOfOne) {
            scaleToRestoreAfterResize = 0
        }
    }
    
    private func recoverFromResizing() {
        setMaxMinZoomScalesForCurrentBounds()
        let maxZoomScale = max(minimumZoomScale, scaleToRestoreAfterResize)
        zoomScale = min(maximumZoomScale, maxZoomScale)
        
        let boundsCenter = convert(pointToCenterAfterResize, to: zoomView)
        var offset = CGPoint(x: boundsCenter.x - bounds.size.width / 2, y: boundsCenter.y - bounds.size.height / 2)
        let maxOffset = maximumContentOffset()
        let minOffset = minimumContentOffset()
        
        var realMaxOffset = min(maxOffset.x, offset.x)
        offset.x = max(minOffset.x, realMaxOffset)
        
        realMaxOffset = min(maxOffset.y, offset.y)
        offset.y = max(minOffset.y, realMaxOffset)
        
        contentOffset = offset
    }
    
    private func configureImageForSize() {
        contentSize = image.size
        setMaxMinZoomScalesForCurrentBounds()
        zoomScale = minimumZoomScale
        
        let yOffset = contentSize.height < bounds.height ? 0 : (contentSize.height - bounds.height) / 2
        let xOffset = contentSize.width > bounds.width ? 0 : (bounds.width - contentSize.width) / 2
        
        contentOffset = CGPoint(x: xOffset, y: yOffset)
    }
    
    // MARK: - Offsets
    private func maximumContentOffset() -> CGPoint {
        return CGPoint(x: contentSize.width - bounds.width, y: contentSize.height - bounds.height)
    }
    
    private func minimumContentOffset() -> CGPoint {
        return CGPoint.zero
    }
    
    // MARK: - Display image
    func display() {
        if let zoomView = zoomView {
            zoomView.removeFromSuperview()
        }
        
        zoomView = UIImageView(image: image)
        
        guard let unwrappedView = zoomView else { return }
        
        unwrappedView.isUserInteractionEnabled = true
        addSubview(unwrappedView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ImageScrollView.doubleTapGestureRecognizer(_:)))
        tapGesture.numberOfTapsRequired = 2
        unwrappedView.addGestureRecognizer(tapGesture)
        
        configureImageForSize()
        adjustFrameToCenter()
    }
    
    // MARK: - Gesture
    @objc func doubleTapGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        let zoomDelta = (maximumZoomScale - minimumZoomScale) / 2
        if zoomScale > minimumZoomScale + zoomDelta {
            setZoomScale(minimumZoomScale, animated: true)
        } else {
            setZoomScale(maximumZoomScale, animated: true)
        }
    }
}

// MARK: - UIScrollViewDelegate
extension ImageScrollView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        imageScrollViewDelegate?.scrollViewDidScroll?(scrollView)
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        imageScrollViewDelegate?.scrollViewWillBeginDragging?(scrollView)
    }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        imageScrollViewDelegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        imageScrollViewDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        imageScrollViewDelegate?.scrollViewWillBeginDecelerating?(scrollView)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        imageScrollViewDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        imageScrollViewDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        imageScrollViewDelegate?.scrollViewWillBeginZooming?(scrollView, with: view)
    }
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        imageScrollViewDelegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
    }
    
    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return false
    }
    
    public func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        imageScrollViewDelegate?.scrollViewDidChangeAdjustedContentInset?(scrollView)
    }

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return zoomView
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        adjustFrameToCenter()
        imageScrollViewDelegate?.scrollViewDidZoom?(scrollView)
    }
}
