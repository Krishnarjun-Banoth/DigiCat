//
//  FilterByBottomSheet.swift
//  DigiCat
//
//  Created by Krishnarjun on 31/08/19.
//  Copyright © 2019 Krishnarjun. All rights reserved.
//

import UIKit

class FilterByBottomSheet: UIViewController {

    @IBOutlet weak var filterByTableView: FilteringTableView!
    
    var filterData = [FilterWidget: Any]()
    var filterClickListener: FilterClickListener?
    override func viewDidLoad() {
        super.viewDidLoad()
        filterByTableView.filterData = filterData
        filterByTableView.filterClickListener = filterClickListener
    }
}
