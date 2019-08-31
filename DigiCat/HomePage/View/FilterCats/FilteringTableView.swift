//
//  FilterByTableView.swift
//  DigiCat
//
//  Created by Krishnarjun on 31/08/19.
//  Copyright © 2019 Krishnarjun. All rights reserved.
//

import UIKit


enum FilterWidget: String, CaseIterable {
    case BREEDS = "Breeds"
    case CATEGORY = "Categories"
}

class FilteringTableView: UITableView {

    var filterData = [FilterWidget: Any]()
    
    var selectedIndexPath: IndexPath?
    var filterClickListener: FilterClickListener?
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTableView()
    }
    
    private func setupTableView() {
        dataSource = self
        delegate = self
        separatorStyle = .none
        register(UINib(nibName: SortingTableViewCell.nameOfClass, bundle: nil), forCellReuseIdentifier: SortingTableViewCell.nameOfClass)
    }
}


extension FilteringTableView: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            guard let categories = filterData[FilterWidget.CATEGORY] as? [Category] else {return 0}
            return categories.count
        }
        else {
            guard let breeds = filterData[FilterWidget.BREEDS] as? [Breed] else {return 0}
            return breeds.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SortingTableViewCell.dequeueCell(tableView, indexPath: indexPath) as? SortingTableViewCell ?? SortingTableViewCell()
        
        cell.label = getRowData(for: indexPath)
        guard let selectedIndexPath = selectedIndexPath else { return cell}
        if indexPath == selectedIndexPath {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        if indexPath.section == 0 {
            guard let categories = filterData[FilterWidget.CATEGORY] as? [Category] else {return }
            filterClickListener?.filterClicked(.CATEGORY, String(categories[indexPath.row].id))
        }
        else {
            guard let breeds = filterData[FilterWidget.BREEDS] as? [Breed] else {return }
            filterClickListener?.filterClicked(.BREEDS, breeds[indexPath.row].id)
        }
    }
    
    func getRowData(for indexPath: IndexPath) -> String {
        if indexPath.section == 0 {
            guard let categories = filterData[FilterWidget.CATEGORY] as? [Category] else {return ""}
            return categories[indexPath.row].name
        }
        else {
            guard let breeds = filterData[FilterWidget.BREEDS] as? [Breed] else {return ""}
            return breeds[indexPath.row].name
        }
    }
}
