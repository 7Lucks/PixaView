//
//  AlertError.swift
//  PixaView
//
//  Created by Дмитрий Игнатьев on 10.01.2022.
//

import UIKit

extension UIViewController{
    
    func alertError(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "понял принял", style: .default)
        
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
        
    }
}

