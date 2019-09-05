//
//  EndTimesViewCell.swift
//  RecurrencePicker
//
//  Created by Igor Rudenko on 04/09/2019.
//  Copyright © 2019 Teambition. All rights reserved.
//

import UIKit
import EventKit

internal protocol EndTimesPickerViewCellDelegate: AnyObject {
  func endTimesViewCell(_ cell: EndTimesPickerViewCell, didSelectTimes times: Int)
}

internal class EndTimesPickerViewCell: UITableViewCell, EndTypeTableViewCell {
  private let maxTimes = 999
  
  //IBOutlets
  @IBOutlet internal weak var pickerView: UIPickerView!
  
  //Properties
  internal weak var delegate: EndTimesPickerViewCellDelegate?
  
  var recurrenceEnd: EKRecurrenceEnd? {
    didSet {
      if let times = recurrenceEnd?.occurrenceCount {
        pickerView.selectRow(times - 1, inComponent: 0, animated: false)
      }
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
}

extension EndTimesPickerViewCell: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 2
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if component == 0 {
      return maxTimes
    } else {
      return 1
    }
  }
  
}

extension EndTimesPickerViewCell: UIPickerViewDelegate {
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if component == 0 {
      return "\(row+1)"
    } else {
      return "times"
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if component == 0 {
      delegate?.endTimesViewCell(self, didSelectTimes: row+1)
    }
  }
}
