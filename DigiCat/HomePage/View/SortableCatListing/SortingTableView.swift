//
//  SortingTableView.swift
//  DigiCat
//
//  Created by Krishnarjun on 31/08/19.
//  Copyright © 2019 Krishnarjun. All rights reserved.
//

import Foundation
import UIKit

/** Sorting logic mapped to their API counterparts. */
enum SortingLogic: String, CaseIterable {
    case ASC = "ASC"
    case DESC = "DESC"
}

class SortingTableView: UITableView {
    static let sortingLabels: [SortingLogic] = [.ASC, .DESC]
    
    var selectedIndex: Int = 0
    var sortClickListener: SortClickListener?
    
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

extension SortingTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SortingTableView.sortingLabels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SortingTableViewCell.dequeueCell(tableView, indexPath: indexPath) as? SortingTableViewCell ?? SortingTableViewCell()
        
        cell.label = SortingTableView.enumToDisplayString(SortingTableView.sortingLabels[indexPath.row])
        if indexPath.row == selectedIndex {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        if indexPath.row == 0 {
           sortClickListener?.sortClicked(.ASC)
        }
        else {
            sortClickListener?.sortClicked(.DESC)
        }
        
    }
    
    class func enumToDisplayString(_ logic: SortingLogic) -> String {
        switch logic {
        case .ASC:
            return "ASCENDING"
        case .DESC:
            return "DESCENDING"
   
        }
    }
}
