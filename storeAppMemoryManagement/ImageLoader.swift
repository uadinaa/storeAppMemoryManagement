//
//  ImageLoader.swift
//  storeAppMemoryManagement
//
//  Created by Дина Абитова on 19.02.2025.
//

import UIKit

protocol ImageLoaderDelegate: AnyObject {
    func imageLoader(_ loader: ImageLoader, didLoad image: UIImage)
    func imageLoader(_ loader: ImageLoader, didFailWith error: Error)
}

class ImageLoader {
    weak var delegate: ImageLoaderDelegate?

// TODO: Think about closure reference type
//    var completionHandler: ((UIImage?) -> Void)? вместо этого кээш для изображении
    private var imageCache = NSCache<NSString, UIImage>()

    
    func loadImage(url: URL) {
        // TODO: Implement image loading
        // Consider: How to avoid retain cycle?
        let urlString = url.absoluteString as NSString

        // Check if the image is already cached
        if let cachedImage = imageCache.object(forKey: urlString) {
            DispatchQueue.main.async {
                self.delegate?.imageLoader(self, didLoad: cachedImage)
            }
            return
        }

        // Download image
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            do {
                let data = try Data(contentsOf: url)
                guard let image = UIImage(data: data) else {
                    throw NSError(domain: "ImageLoader", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Invalid image data"])
                }

                // Cache the image
                self.imageCache.setObject(image, forKey: urlString)

                DispatchQueue.main.async {
                    self.delegate?.imageLoader(self, didLoad: image)
                }
            } catch {
                DispatchQueue.main.async {
                    self.delegate?.imageLoader(self, didFailWith: error)
                }
            }
        }
    }
}

//    func loadImage(url: URL, completion: @escaping (UIImage?) -> Void) {
//        // TODO: Implement image loading
//        // Consider: How to avoid retain cycle?
//        URLSession.shared.dataTask(with: url) {data, _, _ in
////            guard let self = self else { return }
//            guard let data = data, let image_offset = UIImage(data: data) else {
//                DispatchQueue.main.async {
//                    completion(nil)
//                }
//                return
//            }
//            DispatchQueue.main.async{
//                completion(image_offset)
//            }
//        }.resume()
//    }
//    class PostView {
//        // TODO: Consider reference management
//        var imageLoader: ImageLoader?
//        
//        func setupImageLoader() {
//            // TODO: Implement setup
//            // Think: What reference types should be used?
//        }
//    }
//}
//    func loadImage(url: URL, completion: @escaping (UIImage?) -> Void) {
//        if let cachedImage = imageCache.object(forKey: url as NSURL) {
//            completion(cachedImage)
//            return
//        }
//
//        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
//            guard let self = self else { return }
//            
//            if let error = error {
//                DispatchQueue.main.async {
//                    self.delegate?.imageLoader(self, didFailWith: error)
//                    completion(nil)
//                }
//                return
//            }
//            
//            guard let data = data, let image = UIImage(data: data) else {
//                DispatchQueue.main.async { completion(nil) }
//                return
//            }
//            
//            self.imageCache.setObject(image, forKey: url as NSURL) // Сохраняем в кэш
//            
//            DispatchQueue.main.async {
//                self.delegate?.imageLoader(self, didLoad: image)
//                completion(image)
//            }
//        }
//        task.resume()
//    }
//}
