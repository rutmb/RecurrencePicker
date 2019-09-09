//
//  DatePickerViewCell.swift
//  RecurrencePicker
//
//  Created by Igor Rudenko on 04/09/2019.
//  Copyright © 2019 Teambition. All rights reserved.
//

import UIKit
import EventKit

internal class DatePickerViewCell: UITableViewCell, EndRecurrenceTableViewCellable {
  
  //IBOutlets
  @IBOutlet internal weak var datePicker: UIDatePicker!
  
  //IBActions
  @IBAction internal func datePickerDidChanged(_ sender: UIDatePicker) {
    delegate?.endTypeViewCell(self, didSelectEndRecurrence: EKRecurrenceEnd(end: sender.date))
  }
  
  //Properties
  var delegate: EndRecurrenceTableViewDelegate?
  
  var recurrenceEnd: EKRecurrenceEnd? {
    didSet {
      if let date = recurrenceEnd?.endDate {
        datePicker.setDate(date, animated: false)
      }
    }
  }
  
  var occurrenceDate: Date? {
    didSet {
      datePicker.minimumDate = occurrenceDate
    }
  }
  
  //Base methods
  override func awakeFromNib() {
    super.awakeFromNib()
    selectionStyle = .none
    accessoryType = .none
  }

}

