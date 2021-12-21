//
//  NetworkService.swift
//  PixaView
//
//  Created by Дмитрий Игнатьев on 15.12.2021.
//
import UIKit
import TestFramework

let myKeyId = "16834549-9bf1a2a9f7bfa54e36404be81"

 enum Categories: String, CaseIterable{
    case backgrounds
    case fashion
    case nature
    case science
    case education
    case feelings
    case health
    case people
    case religion
    case places
    case animals
    case industry
    case computer
    case food
    case sports
    case transportation
    case travel
    case buildings
    case business
    case music
}


public class HTTPService{
    let session: HTTPClient

   public init(with session: HTTPClient) {
        self.session = session
    }

    func fetchPics(order : PopularLastestButton.Order ,filterCategory:[Categories],currentPage:Int, completion: @escaping ([Hits]) -> ()) {
        
        let filterCategory:[Categories] = Categories.allCases
        
        var urlComponents = URLComponents(string: "https://pixabay.com/api")!
        urlComponents.queryItems = [
            "key": myKeyId,
            "image_type": "photo",
            "per_page": 15,
            "safesearch": "true",
            "page": currentPage,
            "order": order,
            "category": filterCategory
        ].map({ URLQueryItem(name: $0, value: "\($1)")})
     
        session.get(from: urlComponents.url!) { (result) in
            switch result {
            case let .success(data, response):
                completion((try? JSONDecoder().decode(ImageAPIResponse.self, from: data).hits) ?? [])
            case let .failure(error):
                break
            }
        }
    }
}
extension URLSession: NetworkSession{
    
    public func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkRequest {
        let datatask = dataTask(with: URLRequest(url: url), completionHandler: completionHandler)
        return datatask
    }
    
     
}
