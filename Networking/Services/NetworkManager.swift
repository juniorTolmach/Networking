//
//  Network.swift
//  Networking
//
//  Created by Daniil Oreshenkov on 29.08.2022.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case invalidUrl
    case noData
    case decodingError
}

struct NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchImage(from url: String?) -> Data? {
        guard let urlString = url else { return nil}
        guard let url = URL(string: urlString) else { return nil}
        return try? Data(contentsOf: url)
    }
    
    func fetch<T: Decodable>(dataType: T.Type, from url: String, completion: @escaping(Result<T,NetworkError>) -> Void) {
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let response = response else {
                completion(.failure(.invalidUrl))
                return
            }
            
            print(response)
            
            do {
                let type = try JSONDecoder().decode(T.self, from: data)
                completion(.success(type))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func pastRequestWithDict(with data: [String: Any], to url: String, completion: @escaping(Result<Any, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidUrl))
            return
        }
        
        let courseData = try? JSONSerialization.data(withJSONObject: data)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = courseData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let response = response else {
                completion(.failure(.noData))
                return
            }
            
            print(response)
            
            do {
                let course = try JSONSerialization.jsonObject(with: data)
                completion(.success(course))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func pastRequestWithModel(with data: Course2, to url: String, completion: @escaping(Result<Any, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidUrl))
            return
        }
        
        guard let courseData = try? JSONEncoder().encode(data) else {
            completion(.failure(.noData))
            return
        }
        
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = courseData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let response = response else {
                completion(.failure(.noData))
                return
            }
            
            print(response)
            
            do {
                let course = try JSONDecoder().decode(Course2.self, from: data )
                completion(.success(course))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func fetchDataWithAlamofile<T: Decodable>(dataType: T.Type, from url: String, completion: @escaping(Result<T,NetworkError>) -> Void) {
        AF.request(url)
            .responseDecodable(of: dataType) { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(.decodingError))
                    print(error)
            }
        }
    }
    
    func postDataWithAlamofile(_ url: String, data: Course2, completion: @escaping(Result<Course, NetworkError>) -> Void) {
        AF.request(url, method: .post, parameters: data)
            .validate()
            .responseDecodable(of: Course2.self) { dataResponse in
                switch dataResponse.result {
                case .success(let course2):
                    let course = Course(
                        name: course2.name,
                        imageUrl: course2.imageUrl,
                        numberOfLessons: Int(course2.number_of_lessons) ?? 0,
                        numberOfTests: Int(course2.number_of_tests) ?? 0
                    )
                    completion(.success(course))
                case .failure:
                    completion(.failure(.decodingError))
            }
        }
    }
    
    func fetchCourses() async throws -> [Course] {
        guard let url = URL(string: Link.courses.rawValue) else {
            throw NetworkError.invalidUrl
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        guard let courses = try? decoder.decode([Course].self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return courses
    }
}
