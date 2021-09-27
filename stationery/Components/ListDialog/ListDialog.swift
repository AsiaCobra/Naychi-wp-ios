//
//  ListDialog.swift
//  Component
//
//  Created by Codigo NOL on 20/01/2020.
//  Copyright © 2020 Codigo. All rights reserved.
//

import UIKit

public enum ListItemAlign {
    case left
    case centre
    case right
}

public protocol ListDialogProtocol: AnyObject {
    func listDialog(didSelect title: String, id: String, value: String)
}

class ListDialog: BaseListDialogVC {
  
    public static func show(_ title: String, items: [(id: String, value: String)], delegate: ListDialogProtocol?, tapGestureDismissal: Bool = true, panGestureDismissal: Bool = true, align: ListItemAlign = .left, shouldShowArrow: Bool = false, selectedId: String = "") {
        DispatchQueue.main.async {
            guard let topVC = UIApplication.shared.keyWindow?.topViewController() else { return }
            let dialog = ListDialog(nibName: ListDialog.className, bundle: Bundle.main)
            dialog.titleMessage = title
            dialog.items = items
            dialog.delegate = delegate
            dialog.align = align
            dialog.tapGestureDismissal = tapGestureDismissal
            dialog.panGestureDismissal = panGestureDismissal
            dialog.shouldShowArrow = shouldShowArrow
            dialog.selectedId = selectedId
            topVC.present(dialog, animated: true, completion: nil)
        }
    }
    
    public weak var delegate: ListDialogProtocol?
    public var items: [(id: String, value: String)] = []
   
    var align = ListItemAlign.left
    var shouldShowArrow = false
    var selectedId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        totalItems = items.count
        setUpTable()
    }
    
    func setUpTable() {
        tblItems.register(nib: ListDialogCell.className, bundle: Bundle(for: type(of: self)))
        tblItems.delegate = self
        tblItems.dataSource = self
        tblItems.rowHeight = cellHeight
        tblItems.estimatedRowHeight = cellHeight
        tblItems.reloadData()
        
    }
    
}

extension ListDialog: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.deque(ListDialogCell.self)
        cell.setTitle(title: items[indexPath.row].value, align: align, showArrow: shouldShowArrow, isSelected: items[indexPath.row].id == selectedId)
        return  cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedId = items[indexPath.row].id
        delegate?.listDialog(didSelect: titleMessage, id: items[indexPath.row].id, value: items[indexPath.row].value)
        quit()
    }
}

