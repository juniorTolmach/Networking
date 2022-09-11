//
//  CoursesCell.swift
//  Networking
//
//  Created by Daniil Oreshenkov on 29.08.2022.
//

import UIKit

class CoursesCell: UITableViewCell {


    @IBOutlet var viewImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberOfLessonsLabel: UILabel!
    @IBOutlet var numberOfTestsLabel: UILabel!
    
    func configure(with course: Course) {
        nameLabel.text = course.name
        numberOfLessonsLabel.text = "Number of lessons: \(course.number_of_lessons)"
        numberOfTestsLabel.text = "Number of lessons: \(course.number_of_tests)"
        
        DispatchQueue.global().async {
            guard let dataImage = NetworkManager.shared.fetchImage(from: course.imageUrl) else { return }
            DispatchQueue.main.async {
                self.viewImage.image = UIImage(data: dataImage)
            }
        }
    }

}
