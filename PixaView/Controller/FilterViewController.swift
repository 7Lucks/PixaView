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
    
   //MARK:  Properties-
    let tableView = UITableView()
    let filterCategory:[Categories] = Categories.allCases
    var holder: PixaViewController?
//MARK: - end of Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
    title = "Pixa View Filters"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonFilterVC))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
tableView.register(TableHeader.self, forHeaderFooterViewReuseIdentifier: "header")
        
        tableView.delegate = self
        tableView.dataSource = self
    }//end of viewDidLoad
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    @objc private func cancelButtonFilterVC(){
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    //MARK: teble methods -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = filterCategory[indexPath.row].rawValue.capitalized

        return cell
    }
    
    // select row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        holder?.enumValue = filterCategory[indexPath.row].rawValue
        holder?.didSelectCategory(category:[filterCategory[indexPath.row]])
    }
    
    // viewForHeader
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
        return header
    }
    
}// end of FilterViewController

//MARK: - HEADER and FOOTER for the table

class TableHeader: UITableViewHeaderFooterView{
    static let identifier = "TableHeader"

    private let label: UILabel = {
    let label = UILabel()
    label.text = "Select Image Filter(s)"
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .center
        label.textColor = .systemGray
    
    return label
    }()

    private let cancelButton = UIButton()
    
    
//    private let headerDoneButton: UIButton = {
//        let doneButton = UIButton()
//        doneButton.setTitle("Done", for: .normal)
//        doneButton.backgroundColor = .systemMint
//        doneButton.frame = CGRect(x: 5, y: 0, width: 70, height: 30)
//        doneButton.layer.cornerRadius = 15
//
//        return doneButton
//    }()

//    private let headerCancelButton: UIButton = {
//        let cancelButton = UIButton()
//        cancelButton.setTitle("Cancel", for: .normal)
//        cancelButton.backgroundColor = .systemRed
//        cancelButton.frame = CGRect(x: 340, y: 0, width: 70, height: 30)
//        cancelButton.layer.cornerRadius = 15
//
//        return cancelButton
//    }()


    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
//        contentView.addSubview(headerDoneButton)
//        contentView.addSubview(headerCancelButton)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        label.sizeToFit()
        label.frame = CGRect(x: 0,
                             y: contentView.frame.size.height - 10 - label.frame.size.height,
                             width: contentView.frame.size.width,
                             height: contentView.frame.size.height)

//        headerDoneButton.sizeToFit()
//        headerCancelButton.sizeToFit()

    }


}


class TableFooter: UITableViewHeaderFooterView{
    static let identifier = "TableFooter"

}
