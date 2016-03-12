//
//  OZLIssueTableViewCell.swift
//  Facets
//
//  Created by Justin Hill on 3/12/16.
//  Copyright © 2016 Justin Hill. All rights reserved.
//

import UIKit

class OZLIssueTableViewCell: UITableViewCell {

    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var issueNumberLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var assigneeNameLabel: UILabel!
    @IBOutlet weak var assigneeAvatarImageView: UIImageView!
    @IBOutlet weak var dueDateLabel: UILabel!

    private class func cell() -> OZLIssueTableViewCell {
        let instance = UINib(nibName: "OZLIssueTableViewCell", bundle: NSBundle.mainBundle()).instantiateWithOwner(nil, options: nil).first

        return instance as! OZLIssueTableViewCell
    }

    var contentPadding: CGFloat = 0.0 {
        didSet {
            self.setNeedsLayout()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.priorityLabel.layer.masksToBounds = true
        self.assigneeAvatarImageView.layer.masksToBounds = true
        self.assigneeAvatarImageView.backgroundColor = UIColor.OZLVeryLightGrayColor()
    }

    func applyIssueModel(issue: OZLModelIssue) {
        self.priorityLabel.text = issue.priority?.name.uppercaseString;
        self.statusLabel.text = issue.status?.name.uppercaseString;
        self.issueNumberLabel.text = "#\(issue.index)"
        self.subjectLabel.text = issue.subject;

        self.assigneeNameLabel.hidden = (issue.assignedTo == nil)
        self.assigneeAvatarImageView.hidden = (issue.assignedTo == nil)
        self.dueDateLabel.hidden = (issue.dueDate == nil)

        if let assignee = issue.assignedTo {
            self.assigneeNameLabel.text = assignee.name.uppercaseString
        }

        if let dueDate = issue.dueDate {
            self.dueDateLabel.text = "due \(dueDate.timeAgoSinceNow())".uppercaseString
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.priorityLabel.sizeToFit()
        self.priorityLabel.frame = CGRectMake(self.contentPadding,
                                              self.contentPadding,
                                              self.priorityLabel.frame.size.width + 6,
                                              self.priorityLabel.frame.size.height + 4)

        self.statusLabel.sizeToFit()
        self.statusLabel.frame = CGRectMake(self.priorityLabel.right,
                                            self.priorityLabel.top,
                                            self.statusLabel.frame.size.width + 6,
                                            self.priorityLabel.frame.size.height)

        self.issueNumberLabel.sizeToFit()
        self.issueNumberLabel.frame = CGRectMake(self.statusLabel.right + (self.contentPadding / 2),
                                                 self.statusLabel.top,
                                                 self.issueNumberLabel.frame.size.width,
                                                 self.priorityLabel.frame.size.height)

        self.subjectLabel.frame = CGRectMake(0, 0, self.frame.size.width - (2 * self.contentPadding), 0)
        self.subjectLabel.sizeToFit()
        self.subjectLabel.frame = CGRectMake(self.contentPadding,
                                             self.priorityLabel.bottom + (self.contentPadding / 2),
                                             self.subjectLabel.frame.size.width,
                                             self.subjectLabel.frame.size.height)

        let bottomRowElementSpacing: CGFloat = 8.0
        let bottomRowElementYOffset: CGFloat = self.subjectLabel.bottom + (self.contentPadding / 2)
        let bottomRowElementHeight: CGFloat = 16.0

        if !self.assigneeNameLabel.hidden {

            self.assigneeNameLabel.sizeToFit()
            self.assigneeNameLabel.frame = CGRectMake(self.frame.size.width - self.contentPadding - self.assigneeNameLabel.frame.size.width,
                                                      bottomRowElementYOffset,
                                                      self.assigneeNameLabel.frame.size.width,
                                                      bottomRowElementHeight)

            self.assigneeAvatarImageView.frame = CGRectMake(self.assigneeNameLabel.frame.origin.x - bottomRowElementHeight - bottomRowElementSpacing,
                                                            bottomRowElementYOffset,
                                                            bottomRowElementHeight,
                                                            bottomRowElementHeight)
        }

        if !self.dueDateLabel.hidden {
            self.dueDateLabel.sizeToFit()

            if self.assigneeAvatarImageView.hidden {
                self.dueDateLabel.frame = CGRectMake(self.frame.size.width - self.contentPadding - self.dueDateLabel.frame.size.width,
                                                     bottomRowElementYOffset,
                                                     self.dueDateLabel.frame.size.width,
                                                     bottomRowElementHeight)
            } else {
                self.dueDateLabel.frame = CGRectMake(self.assigneeAvatarImageView.frame.origin.x - self.dueDateLabel.frame.size.width - bottomRowElementSpacing,
                                                     bottomRowElementYOffset,
                                                     self.dueDateLabel.frame.size.width,
                                                     bottomRowElementHeight)
            }
        }
    }

    override func layoutSublayersOfLayer(layer: CALayer) {
        super.layoutSublayersOfLayer(layer)

        let leftRoundedMask = CAShapeLayer()
        leftRoundedMask.path = UIBezierPath(roundedRect: self.priorityLabel.bounds, byRoundingCorners: [.TopLeft, .BottomLeft], cornerRadii: CGSizeMake(2.0, 2.0)).CGPath

        self.priorityLabel.layer.mask = leftRoundedMask

        let rightRoundedMask = CAShapeLayer()
        rightRoundedMask.path = UIBezierPath(roundedRect: self.statusLabel.bounds, byRoundingCorners: [.TopRight, .BottomRight], cornerRadii: CGSizeMake(2.0, 2.0)).CGPath

        self.statusLabel.layer.mask = rightRoundedMask

        self.assigneeAvatarImageView.layer.cornerRadius = (self.assigneeAvatarImageView.frame.size.width / 2.0)
    }

    private static let sizingInstance = OZLIssueTableViewCell.cell()
    class func heightWithWidth(width: CGFloat, issue: OZLModelIssue, contentPadding: CGFloat) -> CGFloat {
        let instance = OZLIssueTableViewCell.sizingInstance
        instance.frame = CGRectMake(0, 0, width, 0)
        instance.contentPadding = contentPadding
        instance.applyIssueModel(issue)
        instance.layoutSubviews()

        if !instance.dueDateLabel.hidden {
            return instance.dueDateLabel.bottom + contentPadding

        } else if !instance.assigneeAvatarImageView.hidden {
            return instance.assigneeAvatarImageView.bottom + contentPadding

        } else {
            return instance.subjectLabel.bottom + contentPadding
        }
    }
}