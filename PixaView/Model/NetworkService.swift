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
    //MARK:  Methods -
    func fetchPics(order : Order, filterCategory:[Categories], currentPage:Int, completion: @escaping ( [Hits], Int) -> ()) {
        var urlComponents = URLComponents(string: "https://pixabay.com/api")!
        urlComponents.queryItems = [
            "key": myKeyId,
            "image_type": "photo",
            "per_page": 20,
            "safesearch": "true",
            "page": currentPage,
            "order": order,
            "category": filterCategory [0]
        ].map({ URLQueryItem(name: $0, value: "\($1)")})
        
        session.get(from: urlComponents.url!) { (result) in
            switch result {
            case let .success(data, response):
                let response = try! JSONDecoder().decode(ImageAPIResponse.self, from: data)
                completion(response.hits, response.total)
            case let .failure(error):
                break
            }//end of switch
        }// end of session
        //print("the url is -- \(urlComponents.url)")
    } // end of fetchPics
    
} // end of HTTPService


//MARK: ImageLoader -

struct ImageLoader {
    
    let session: HTTPClient
    
    init(with session: HTTPClient) {
        self.session = session
    }
    func loadPics(from url: URL, completion: @escaping (UIImage) -> ()) {
        session.get(from: url) { (result) in
            
            switch result {
            case let .success(data, _):
                completion(UIImage(data: data)!)
            case let .failure(error):
                break
            }
        }
    }
} // end of ImageLoader


//MARK:  Extensions -
extension URLSession: NetworkSession{
    
    public func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkRequest {
        let datatask = dataTask(with: URLRequest(url: url), completionHandler: completionHandler)
        return datatask
    }
}
//MARK: - end of Extensions
