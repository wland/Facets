//
//  OZLFieldSelectorTableViewController.swift
//  Facets
//
//  Created by Justin Hill on 1/1/16.
//  Copyright © 2016 Justin Hill. All rights reserved.
//

import UIKit

class OZLFieldSelectorViewController: UITableViewController {
    
    fileprivate let defaultFields = [
        ("Project", "project"),
        ("Tracker", "tracker"),
        ("Status", "status"),
        ("Priority", "priority"),
        ("Author", "author"),
        ("Category", "category"),
        ("Start Date", "start_date"),
        ("Due Date", "due_date"),
        ("Percent Done", "done_ratio"),
        ("Estimated Hours", "estimated_hours"),
        ("Creation Date", "created_on"),
        ("Last Updated", "last_updated")
    ]
    
    let DefaultFieldSection = 0
    let CustomFieldSection = 1
    var selectionChangeHandler: ((_ field: OZLSortAndFilterField) -> Void)?
    
    let TextReuseIdentifier = "TextReuseIdentifier"
    
    let customFields = OZLModelCustomField.allObjects()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Select a Field"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier:self.TextReuseIdentifier)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == DefaultFieldSection {
            return self.defaultFields.count
        } else if section == CustomFieldSection {
            return Int(self.customFields.count)
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.TextReuseIdentifier, for: indexPath)
        
        if indexPath.section == DefaultFieldSection {
            let (displayName, _) = self.defaultFields[indexPath.row]
            cell.textLabel?.text = displayName
        } else if indexPath.section == CustomFieldSection {
            let field = self.customFields[UInt(indexPath.row)] as? OZLModelCustomField
            cell.textLabel?.text = field?.name
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == DefaultFieldSection {
            let (displayName, serverName) = self.defaultFields[indexPath.row]
            self.selectionChangeHandler?(OZLSortAndFilterField(displayName: displayName, serverName: serverName))
            
        } else if indexPath.section == CustomFieldSection {
            guard let field = self.customFields[UInt(indexPath.row)] as? OZLModelCustomField else {
                return
            }
            
            if let fieldName = field.name {
                let serverName = "cf_" + String(field.fieldId)
                self.selectionChangeHandler?(OZLSortAndFilterField(displayName: fieldName, serverName: serverName))
            }
        }

        let _ = self.navigationController?.popViewController(animated: true)
    }
}
