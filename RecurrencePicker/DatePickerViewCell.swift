//
//  DatePickerViewCell.swift
//  RecurrencePicker
//
//  Created by Igor Rudenko on 04/09/2019.
//  Copyright © 2019 Teambition. All rights reserved.
//

import UIKit

internal protocol DatePickerViewCellDelegate: AnyObject {
  func datePickerViewCell(_ cell: DatePickerViewCell, didSelectDate date: Date)
}

internal class DatePickerViewCell: UITableViewCell, EndTypeTableViewCell {
  //IBOutlets
  @IBOutlet internal weak var datePicker: UIDatePicker!
  
  //IBActions
  @IBAction internal func datePickerDidChanged(_ sender: UIDatePicker) {
    delegate?.datePickerViewCell(self, didSelectDate: sender.date)
  }
  
  //Properties
  internal weak var delegate: DatePickerViewCellDelegate?
  var endType: RecurrenceEndType? {
    didSet {
      if case .onDate(let date)? = endType {
        datePicker.setDate(date, animated: false)
      }
    }
  }
 
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}

