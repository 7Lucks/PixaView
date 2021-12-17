//
//  HttpClient.swift
//  TestFrameworkTests
//
//  Created by Дмитрий Игнатьев on 27.11.2021.
//

import UIKit


//MARK: - Protocols-

public protocol NetworkSession{
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkRequest
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> ())
}

public protocol NetworkRequest{
    func resume()
}

extension URLSessionDataTask: NetworkRequest{
}

//MARK: - Classes-

public class URLSessionHttpClient: HTTPClient{
    private struct UnexpectedArguments: Error {}
    private let session: NetworkSession
    
    public init(session: NetworkSession){
        self.session = session
    }
    
    public func get(from url: URL, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> ()){
        
        let dataTask = session.dataTask(with: url){data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let response = response as? HTTPURLResponse, let data = data {
                completion(.success((data, response)))
            }else{
                completion(.failure(UnexpectedArguments()))
            }
        }
        dataTask.resume()
    }
}
