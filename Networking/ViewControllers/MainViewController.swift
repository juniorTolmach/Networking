//
//  MainViewController.swift
//  Networking
//
//  Created by Daniil Oreshenkov on 29.08.2022.
//

import UIKit
import Alamofire

enum Link: String {
    case imageUrl = "https://img.desktopwallpapers.ru/world/pics/wide/1920x1200/ec13dd5a2fb69efdb62c6b349de31e1f.jpg"
    case courses = "https://swiftbook.ru//wp-content/uploads/api/api_courses"
    case postRequest = "https://jsonplaceholder.typicode.com/posts"
}

enum UserAction: String, CaseIterable {
    case dowloadImage = "Dowload Image"
    case get = "Get"
    case postWithDict = "Post with dictonary"
    case postWithModel = "Post with Model"
    case alamofileGet = "Alamofile Get"
    case alamofilePost = "Alamofile Post"
    case asyncAwait = "Async Await"
}

class MainViewController: UICollectionViewController {
    
    let userActions = UserAction.allCases

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        userActions.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserActionCell
        cell.userActionLabel.text = userActions[indexPath.item].rawValue
        
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userAction = userActions[indexPath.item]
        
        switch userAction {
        case .dowloadImage: performSegue(withIdentifier: "showImage", sender: nil)
        case .get: performSegue(withIdentifier: "showCourses", sender: nil)
        case .postWithDict: postRequestWithDict()
        case .postWithModel: postRequestWithModel()
        case .alamofileGet: performSegue(withIdentifier: "alamofileGet", sender: nil)
        case .alamofilePost: performSegue(withIdentifier: "alamofilePost", sender: nil)
        case .asyncAwait: performSegue(withIdentifier: "asyncAwait", sender: nil)
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let coursesTVC = segue.destination as? CoursesTableViewController else { return }
        switch segue.identifier {
        case "showCourses": coursesTVC.fetchCourses()
        case "alamofileGet": coursesTVC.alamofileGetButtonPressed()
        case "alamofilePost": coursesTVC.alamofilePostButtonPressed()
        case "asyncAwait": coursesTVC.fetchAsyncAwait()
        default: break
        }
    }
    
    private func successAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Success",
                message: "You can see the results in the Debug aria",
                preferredStyle: .alert
            )
            
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
    
    private func failedAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Failed",
                message: "You can see error in the Debug aria",
                preferredStyle: .alert
            )
            
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
}

extension MainViewController {
    func postRequestWithDict() {
        let course = [
            "name": "Networking",
            "imageUrl": "image url",
            "numberOfLessons": "10",
            "numberOfTests": "8"
        ]
        NetworkManager.shared.pastRequestWithDict(with: course, to: Link.postRequest.rawValue) { result in
            switch result {
            case .success(let json):
                print(json)
                self.successAlert()
            case .failure(let error):
                print(error)
                self.failedAlert()
            }
        }
    }
    
    func postRequestWithModel() {
        let course = Course2 (
            name: "Network",
            imageUrl: "",
            number_of_lessons: "10",
            number_of_tests: "8"
        )
        NetworkManager.shared.pastRequestWithModel(with: course, to: Link.postRequest.rawValue) { result in
            switch result {
            case .success(let course):
                print(course)
                self.successAlert()
            case .failure(let error):
                print(error)
                self.failedAlert()
            }
        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 48, height: 100)
    }
}
