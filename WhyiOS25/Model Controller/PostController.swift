//
//  PostController.swift
//  WhyiOS25
//
//  Created by Hannah Hoff on 3/20/19.
//  Copyright © 2019 Hannah Hoff. All rights reserved.
//

import Foundation

class PostController {
    
    // base url
    static let baseUrl = URL(string: "https://whydidyouchooseios.firebaseio.com/reasons")
    
    //Mark: - CRUD Functions
    
    //GET(read)
    static func getPosts(completion: @escaping ([Post]?) -> Void) {
        
        guard let url = baseUrl else { completion(nil); return }
        
        let getterEndpoint = url.appendingPathComponent(".json")
        
        var request = URLRequest(url: getterEndpoint)
        
        request.httpMethod = "GET"
        request.httpBody = nil
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("There was an error retrieving the data: \(error) \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let data = data else {
                print("No data found from fetch posts")
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedDictionary = try decoder.decode([String: Post].self, from: data)
                let decodedPosts = decodedDictionary.compactMap({ $0.value })
                
                completion(decodedPosts)
                
            }catch{
                print(error)
                completion(nil)
                return
            }
        } .resume()
    }
    
    // POST(create)
    static func postReason(name: String, cohort: String, reason: String, completion: @escaping (Bool) -> Void) {
        guard var url = baseUrl else { completion(false); return }
        url.appendPathComponent(".json")
        let newPost = Post(cohort: cohort, name: name, reason: reason)
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(newPost)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = data
            
            URLSession.shared.dataTask(with: request) { (data, _, error) in
                if let error = error {
                    print("Erro POSTing the data: \(error) \(error.localizedDescription)")
                    completion(false)
                    return
                }
                if data != nil {
                    completion(true)
                    return
                }
                completion(false)
            }.resume()
        }catch{
            print("Error encoding post: \(error)")
            completion(false)
            return
        }
    }

}
