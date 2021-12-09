//
//  FilterViewController.swift
//  PixaView
//
//  Created by Дмитрий Игнатьев on 08.12.2021.
//

import UIKit

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


class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    let tableView = UITableView()
    let filterCategory:[Categories] = Categories.allCases
    var holder: PixaViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.delegate = self
        tableView.dataSource = self
    }//end of viewDidLoad
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = filterCategory[indexPath.row].rawValue.capitalized

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        holder?.enumValue = filterCategory[indexPath.row].rawValue
        holder?.didSelectCategory(category:[filterCategory[indexPath.row]])
    }
    
}// end of FilterViewController
