//
//  PopularSortButton.swift
//  PixaView
//
//  Created by Дмитрий Игнатьев on 05.12.2021.
//

import UIKit
import TestFramework


class PopularLastestButton{

    //MARK: - sorts latests and popular
    enum Order: String {
        case latest = "latest"
        case popular = "popular"
    }
    var sortHits:[Hits] = []

    func pixaGallerySort(_ page: Int = 1, order: Order = .popular) {
        var urlString = ""
        switch order {
        case .latest:
            urlString = "https://pixabay.com/api/?key=\(myKeyId)&editors_choice=true&page=\(page)&per_page=15&order=latest"
        case .popular:
            urlString = "https://pixabay.com/api/?key=\(myKeyId)&editors_choice=true&page=\(page)&per_page=15&order=popular"
        } //end of swith

    } // end of method
} // end of class



// переделать через делегат
// пределать меню на новый вьюконтроллер 
