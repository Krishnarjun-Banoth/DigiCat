//
//  SortingTableBottomSheet.swift
//  DigiCat
//
//  Created by Krishnarjun on 31/08/19.
//  Copyright © 2019 Krishnarjun. All rights reserved.
//

import UIKit

class SortingTableBottomSheet: UIViewController {

    @IBOutlet weak var sortingTableView: SortingTableView!
    var sortIndex = 0
    var sortClickListener: SortClickListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sortingTableView.selectedIndex = sortIndex
        sortingTableView.sortClickListener = sortClickListener
    }
}
