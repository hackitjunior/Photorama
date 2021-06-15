//
//  PhotoInfoViewController.swift
//  Photorama
//
//  Created by Alberto Silva on 15/06/21.
//

import UIKit

class PhotoInfoViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var photo: Photo! {
        didSet {
            navigationItem.title = photo.title
        }
    }
    
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.fecthImage(for: photo){(result) -> Void in
            
            switch result {
            case let .success(image):
                self.imageView.image = image
            case let .failure(error):
                print("Error fetching image for photo: \(error)")
            }
            
            
            
        }
    }
}
