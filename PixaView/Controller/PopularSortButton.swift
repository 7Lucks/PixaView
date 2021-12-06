//
//  PopularSortButton.swift
//  PixaView
//
//  Created by Дмитрий Игнатьев on 05.12.2021.
//

import UIKit

let myKeyId = "16834549-9bf1a2a9f7bfa54e36404be81"


class PopularLastestButton{
    
    //MARK: - sorts latests and popular
    enum Order: String {
        case latest = "lastest"
        case popular = "popular"
    }
    
    let sortHits:[Hits] = []
    
    static func pixaGallerySort(_ page: Int = 1, order: Order = .popular, handler: @escaping (Any?)->()) {
       
        var urlString = ""
        
        switch order {
        case .latest:
            urlString = "https://pixabay.com/api/?key=\(myKeyId)&editors_choice=true&page=\(page)&per_page=15&order=latest"
        case .popular:
            urlString = "https://pixabay.com/api/?key=\(myKeyId)&editors_choice=true&page=\(page)&per_page=15&order=popular"
        } //end of swith
        
        
        
//        guard let url = URL(string: urlString) else{return}
//
//        let task = URLSession.shared.dataTask(with: url){data, _, error in
//            guard let data = data, error == nil else {
//                return
//            }
//            do{
//                let jsonResults = try JSONDecoder().decode(ImageAPIResponse.self, from: data)
//
//                DispatchQueue.main.async {
////                    self.sortHits = jsonResults.hits
////                    self.collectionView.reloadData()
//
//                }// to main que
//
//            }catch{
//                print ("Here is some ERR - \(error)")
//            }
//        }
//        task.resume()
    } // end of method
} // end of class

