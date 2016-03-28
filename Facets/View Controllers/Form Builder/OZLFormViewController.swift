//
//  OZLFormViewController.swift
//  Facets
//
//  Created by Justin Hill on 3/13/16.
//  Copyright © 2016 Justin Hill. All rights reserved.
//

import UIKit

class OZLFormViewController: OZLTableViewController, OZLFormFieldDelegate {

    var sections: [OZLFormSection] = []
    var contentPadding: CGFloat = OZLContentPadding
    var changes: [String: AnyObject?] = [:]
    var currentEditingResponder: UIResponder?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if self.tableView.numberOfSections == 0 {
            self.reloadData()
        }
    }

    func reloadData() {
        self.sections = self.definitionsForFields()
        self.tableView.reloadData()
    }

    func definitionsForFields() -> [OZLFormSection] {
        assertionFailure("Must override definitionsForFields in a subclass")

        return []
    }

    // MARK: UITableViewDelegate/DataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].fields.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let field = self.sections[indexPath.section].fields[indexPath.row]

        if let cellClass = field.cellClass as? OZLFormFieldCell.Type {
            cellClass.registerOnTableViewIfNeeded(tableView)

            let cell = cellClass.init(style: .Default, reuseIdentifier: String(cellClass.self))
            cell.applyFormField(field)
            cell.contentPadding = self.contentPadding
            cell.delegate = self

            return cell
        }

        return UITableViewCell(style: .Default, reuseIdentifier: nil)
    }

    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let field = self.sections[indexPath.section].fields[indexPath.row]

        return field.fieldHeight
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section].title
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.sections[section].fields.count == 0 {
            return CGFloat.min
        } else if section == 0 {
            return 58.0
        } else {
            return 38.0
        }
    }

    func formFieldCell(formCell: OZLFormFieldCell, valueChangedFrom fromValue: AnyObject?, toValue: AnyObject?, atKeyPath keyPath: String, userInfo: [String : AnyObject]) {
        self.changes[keyPath] = toValue
    }

    func formFieldCellWillBeginEditing(formCell: OZLFormFieldCell, firstResponder: UIResponder?) {
        if firstResponder == nil {
            self.currentEditingResponder?.resignFirstResponder()
        }

        self.currentEditingResponder = firstResponder
    }
}
