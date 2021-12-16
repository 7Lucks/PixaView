//
//  NetworkService.swift
//  PixaView
//
//  Created by Дмитрий Игнатьев on 15.12.2021.
//
import UIKit
import TestFramework
let myKeyId = "16834549-9bf1a2a9f7bfa54e36404be81"

public class HTTPService{
    let session: HTTPClient

   public init(with session: HTTPClient) {
        self.session = session
    }

    func fetch(completion: @escaping ([Hits]) -> (),order : PopularLastestButton.Order ,selectedCategory:[String],currentPage:Int) {

        var urlComponents = URLComponents(string: "https://pixabay.com/api")!
        urlComponents.queryItems = [
            "key": myKeyId,
            "image_type": "photo",
            "per_page": 150,
            "safesearch": "true",
            "page": currentPage,
            "order": order,
            "category": selectedCategory.joined(separator: ",")
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
