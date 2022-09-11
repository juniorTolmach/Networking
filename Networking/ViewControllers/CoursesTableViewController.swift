//
//  CoursesTableViewController.swift
//  Networking
//
//  Created by Daniil Oreshenkov on 29.08.2022.
//

import UIKit

class CoursesTableViewController: UITableViewController {
    
    var courses: [Course] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        courses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CoursesCell
        let course = courses[indexPath.row]
        cell.configure(with: course)

        return cell
    }
}

extension CoursesTableViewController {
    func fetchCourses() {
        NetworkManager.shared.fetch(dataType: [Course].self, from: Link.courses.rawValue) { result in
            switch result {
            case .success(let courses):
                DispatchQueue.main.async {
                    self.courses = courses
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func alamofileGetButtonPressed() {
//        AF.request(Link.courses.rawValue)
//            .responseDecodable(of: [Course].self) { dataResponse in
//                switch dataResponse.result {
//                case .success(let value):
//                    print(value)
//                case .failure(_):
//                    print("")
//                }
//            }
        
        NetworkManager.shared.fetchDataWithAlamofile(dataType: [Course].self, from: Link.courses.rawValue) { result in
            switch result {
            case .success(let courses):
                DispatchQueue.main.async {
                    self.courses = courses
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func alamofilePostButtonPressed() {
        let course = Course2 (
            name: "Network",
            imageUrl: "",
            number_of_lessons: "10",
            number_of_tests: "8"
        )
        NetworkManager.shared.postDataWithAlamofile(Link.postRequest.rawValue, data: course) { result in
            switch result {
            case .success(let course):
                self.courses.append(course)
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchAsyncAwait() {
        Task {
            do {
                courses = try await NetworkManager.shared.fetchCourses()
                tableView.reloadData()
            } catch {
                print(error)
            }
        }
    }
}
