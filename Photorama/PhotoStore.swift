//
//  PhotoStore.swift
//  Photorama
//
//  Created by Alberto Silva on 11/06/21.
//

import UIKit

enum PhotoError: Error {
    case imageCreationError
    case missingImageURL
}

class PhotoStore{
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func fetchInterestingPhotos(completion: @escaping (Result<[Photo], Error>) -> Void){
        let url = FlickrAPI.interestingPhotosURL
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request){
            (data, response, error) in
            let result = self.processPhotosRequest(data: data, error: error)
            
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
    }
    
    private func processPhotosRequest(data: Data?,
                                      error: Error?) -> Result<[Photo], Error> {
        guard let jsonData = data else {
            return .failure(error!)
        }

        return FlickrAPI.photos(fromJSON: jsonData)
    }
    
    func fecthImage(for photo: Photo, completion: @escaping (Result<UIImage, Error>) -> Void){
        guard let photoURL = photo.remoteURL else {
            completion(.failure(PhotoError.missingImageURL))
            return
        }
        
        let request = URLRequest(url: photoURL)
        
        let task = session.dataTask(with: request){
            (data, response, error) in
            let result = self.processImageRequest(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        
        task.resume()
    }
    
    private func processImageRequest(data: Data?, error: Error?) -> Result<UIImage, Error>{
        guard let imageData = data, let image = UIImage(data: imageData) else {
            if data == nil{
                return .failure(error!)
            } else {
                return .failure(PhotoError.imageCreationError)
            }
        }
        
        return .success(image)
    }
}
