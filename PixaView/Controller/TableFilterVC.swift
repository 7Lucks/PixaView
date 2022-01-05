//
//  FilterViewController.swift
//  PixaView
//
//  Created by Дмитрий Игнатьев on 08.12.2021.
//

import UIKit
import TestFramework

protocol TableFilterViewControllerDelegate: AnyObject{
    func filterButtonDidTap(filterCategory: [Categories])
}

class TableFilterVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK:  Properties-
    let tableView = UITableView()
    let filterCategory:[Categories] = Categories.allCases
    var holder: PixaViewController?
    weak var tableViewFilterSelectedDelegate: TableFilterViewControllerDelegate?
    var selectedCategories: [Categories] = []
    //MARK: - end of Properties
    
    //MARK:  viewDidLoad -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        title = "Pixa View Filters"
        
        //cancel button in nav bar
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(cancelButtonFilterVC))
        //search button in nav bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(searchButtonFilterVC))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(TableHeader.self, forHeaderFooterViewReuseIdentifier: "header")
        
        tableView.delegate = self
        tableView.dataSource = self
    }//end of viewDidLoad
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    //MARK: button actions-
    
    //cancel button nav bar method
    @objc private func cancelButtonFilterVC(){
        dismiss(animated: true, completion: nil)
    }
    
    //search button nav bar method
    @objc private func  searchButtonFilterVC(){
       self.navigationController?.popViewController(animated: true)
        
        tableViewFilterSelectedDelegate?.filterButtonDidTap(filterCategory: selectedCategories)
        dismiss(animated: true, completion: nil)
        
    }
 //MARK: - end of button actions
    
    //MARK: tаble methods -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = filterCategory[indexPath.row].rawValue.capitalized
    
        return cell
    }
    
    // select rows
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //checkmarks in tableview
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        //animation for selection
        tableView.deselectRow(at: indexPath, animated: true)
        
        holder?.enumValue = filterCategory[indexPath.row].rawValue
        selectedCategories.append(filterCategory[indexPath.row])
 
    }
    
    // viewForHeader
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
        return header
    }
}// end of FilterViewController

//MARK: HEADER and FOOTER for the table -

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
    }
}


class TableFooter: UITableViewHeaderFooterView{
    static let identifier = "TableFooter"
        
}
