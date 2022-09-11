//
//  ImageViewController.swift
//  Networking
//
//  Created by Daniil Oreshenkov on 29.08.2022.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        fetchImageThroughUrlSession()
    }
    
    private func fetchImageThroughUrlSession() {
        guard let url = URL(string: Link.imageUrl.rawValue) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No description")
                return
            }

            guard let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.imageView.image = image
                self.activityIndicator.stopAnimating()
            }
        }.resume()
    }
}
