//
//  APIService.swift
//  Recipes
//
//  Created by noha abbass on 8/23/22.
//

import Foundation
import Alamofire

class APIService : DataHandlingProtocol {
    static var shared = APIService()
    private init() {}
    
    func getAllRecipes(urlString: String, query: String, healthFilter: String?, page: Int, completion: @escaping (Result<[Recipe], Error>) -> ()) {
        var components = URLComponents(string: urlString)
        components?.queryItems = [
            URLQueryItem(name: "app_id", value: Constants.APP_ID),
            URLQueryItem(name: "app_key", value: Constants.APP_KEY),
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "from", value: "\(page)")
        ]
        
        if let _ = healthFilter {
            components?.queryItems?.append(URLQueryItem(name: "health", value: healthFilter))
        }
        
        guard let url = components?.url else { return }
        AF.request(url)
            .validate()
            .responseDecodable(of: RecipeResponse.self) { (result) in
                if let response = result.value {
                    if response.more {
                        completion(.success(response.hits))
                    } else {
                        completion(.success([]))
                    }
                } else {
                    print("url = \(String(describing: result.request?.url))")
                    completion(.failure(result.error!))
                }
                
            }
    }

}
