//
//  ShareImageController.swift
//  GelatoImageApp
//
//  Created by RN on 12/07/21.
//

import UIKit

public class ShareImageController: NSObject, UIScrollViewDelegate, ShareSheetView {
    private let imageDataLoader: ImageDataLoader
    private let imageURL: URL
    var task: LoaderTask?
    var activeView: UIView?
    var downloadedImage: UIImage?

    init(imageDataLoader: ImageDataLoader, imageURL: URL) {
        self.imageDataLoader = imageDataLoader
        self.imageURL = imageURL
    }

    public func showView(from childView: UIView, in parentView: UIView) {
        let image = childView.snapshot()
        childView.isHidden = true

        let globalPoint = childView.superview!.convert(childView.frame.origin, to: nil)

        let imageView = UIImageView(frame: CGRect(x: globalPoint.x, y: globalPoint.y, width: childView.frame.size.width, height: childView.frame.size.height))
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        parentView.addSubview(imageView)
        UIView.animate(withDuration: 0.4) {
            imageView.frame = parentView.frame
        } completion: { [weak self] _ in
            guard let `self` = self else {
                return
            }
            childView.isHidden = false
            imageView.removeFromSuperview()
            self.activeView = UIView(frame: parentView.frame)
            let scrollView: UIScrollView = UIScrollView(frame: self.activeView!.frame) // force unwrapping here to make sure that it is present
            let newImageView = UIImageView(frame: scrollView.frame)
            newImageView.contentMode = .scaleAspectFit
            newImageView.image = image
            self.downloadAndSetFullImage(to: newImageView, from: self.imageURL)
            scrollView.addSubview(newImageView)
            scrollView.backgroundColor = .black
            scrollView.delegate = self
            scrollView.minimumZoomScale = 1.0
            scrollView.maximumZoomScale = 3.0
            self.activeView?.addSubview(scrollView)
            parentView.addSubview(self.activeView!)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ShareImageController.didClose(gesture:)))
            scrollView.addGestureRecognizer(tapGesture)
        }
    }

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollView.subviews.first
    }

    private func downloadAndSetFullImage(to imageView: UIImageView, from url: URL) {
        task = self.imageDataLoader.load(url: url) {[weak self] result in
            guard let `self` = self else {
                return
            }
            if let data = try? result.get(), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageView.image = image
                    self.downloadedImage = image
                    self.createAnShowShareButton()
                }
            }
        }
    }

    @objc func didClose(gesture: UIGestureRecognizer) {
        activeView?.removeFromSuperview()
        downloadedImage = nil
        task?.cancel()
        task = nil
    }

    func createAnShowShareButton() {
        guard let parentView = activeView else {
            return
        }
        let fixedHeight: CGFloat = 100
        let buttonheight: CGFloat = fixedHeight + (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0)
        let button = UIButton(type: .custom)
        button.setTitle("SHARE", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .white
        button.frame = CGRect(origin: CGPoint(x: 0, y: parentView.frame.size.height - fixedHeight), size: CGSize(width: parentView.frame.size.width, height: buttonheight))
        parentView.addSubview(button)
        button.addTarget(self, action: #selector(ShareImageController.didClickShare), for: .touchUpInside)

    }

    @objc func didClickShare() {
        guard let image = downloadedImage else {
            return
        }
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        let keyWindow = UIApplication.shared.keyWindow
        let topViewController = keyWindow?.topViewController()
        activityViewController.completionWithItemsHandler = {[weak topViewController] activityType, completed, returnedItems, activityError in
            if completed {
                topViewController?.showToast(message: "Action completed succesfully")
            }
          // handle error use cases here
        }
        keyWindow?.topViewController()?.present(activityViewController, animated: true, completion: nil)

    }

}

