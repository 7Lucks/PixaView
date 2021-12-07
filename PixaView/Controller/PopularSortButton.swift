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
    var sortHits:[Hits] = []

    func pixaGallerySort(_ page: Int = 1, order: Order = .popular) {
        var urlString = ""
        //var collectionSort = PixaViewController()  // вылетает симулятор

        switch order {
        case .latest:
            urlString = "https://pixabay.com/api/?key=\(myKeyId)&editors_choice=true&page=\(page)&per_page=15&order=latest"
        case .popular:
            urlString = "https://pixabay.com/api/?key=\(myKeyId)&editors_choice=true&page=\(page)&per_page=15&order=popular"
        } //end of swith

    } // end of method
} // end of class

