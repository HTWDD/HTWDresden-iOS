//
//  ZoomableImageView.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 26.09.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation

class ZoomableImageView: UIScrollView {
    
    var imageView: UIImageView!
    var gestureRecognizer: UITapGestureRecognizer!
    
    convenience init(frame: CGRect, image: UIImage) {
        self.init(frame: frame)
        
        imageView = UIImageView(image: image).also {
            $0.frame                = frame
            $0.contentMode          = .scaleAspectFill
        }
        addSubview(imageView)
        setup()
        setupGesture()
        layoutIfNeeded()
    }
    
    private func setupGesture() {
        gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onDoubleTap)).also {
            $0.numberOfTapsRequired = 2
        }
        addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func onDoubleTap() {
        if zoomScale == 1 {
            zoom(to: zoomZoom(maximumZoomScale, center: gestureRecognizer.location(in: gestureRecognizer.view)), animated: true)
        } else {
            setZoomScale(1, animated: true)
        }
    }
    
    private func zoomZoom(_ scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width = imageView.frame.size.width / scale
        let newCenter = convert(center, from: imageView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
}

// MARK: - Zooming
extension ZoomableImageView: UIScrollViewDelegate {
    
    func setup() {
        delegate            = self
        minimumZoomScale    = 1.0
        maximumZoomScale    = 3.0
        layer.cornerRadius  = 4
        clipsToBounds       = true
        showsVerticalScrollIndicator    = false
        showsHorizontalScrollIndicator  = false
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

