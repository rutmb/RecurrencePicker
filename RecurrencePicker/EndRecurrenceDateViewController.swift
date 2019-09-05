//
//  EndRecurrenceDateViewController.swift
//  RecurrencePicker
//
//  Created by Igor Rudenko on 04/09/2019.
//  Copyright © 2019 Teambition. All rights reserved.
//

import UIKit

internal protocol EndRecurrenceDateViewControllerDelegate: class {
  func endRecurrenceDateViewControllerDelegate(_ controller: EndRecurrenceDateViewController, didSelectRecurrenceEndDate endType: RecurrenceEndType)
}

enum RecurrenceEndType: Equatable {
  case never
  case onDate(Date)
  case afterTimes(Int)
}

internal class EndRecurrenceDateViewController: UITableViewController {
  
  //Properties
  internal weak var delegate: EndRecurrenceDateViewControllerDelegate?
  internal var tintColor: UIColor!
  internal var backgroundColor: UIColor?
  internal var separatorColor: UIColor?
  
  fileprivate var isShowingPickerView = false
  fileprivate var isShowingOnDatePickerView: Bool {
    if case .onDate = endType, isShowingPickerView {
      return true
    } else {
      return false
    }
  }
  fileprivate var isShowingAfterTimesPickerView: Bool {
    if case .afterTimes = endType, isShowingPickerView {
      return true
    } else {
      return false
    }
  }
  var endType: RecurrenceEndType = .never {
    didSet {
      switch endType {
      case .onDate:
        selectedIndexPath = IndexPath(row: 1, section: 0)
        isShowingPickerView = true
        
      case .afterTimes:
        selectedIndexPath = IndexPath(row: 2, section: 0)
        isShowingPickerView = true
        
      default:
        break
      }
      delegate?.endRecurrenceDateViewControllerDelegate(self, didSelectRecurrenceEndDate: endType)
    }
  }
  fileprivate var selectedIndexPath = IndexPath(row: 0, section: 0)
  
  // MARK: - Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    commonInit()
  }
}

extension EndRecurrenceDateViewController {
  //MARK: UITableViewDataSource
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return isShowingPickerView ? 4 : 3
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if isShowingOnDatePickerView && indexPath.row == 2 {
      let cell = tableView.dequeueReusableCell(withIdentifier: CellID.datePickerViewCell, for: indexPath) as! DatePickerViewCell
      cell.endType = endType
      cell.delegate = self
      return cell
    } else if isShowingAfterTimesPickerView && indexPath.row == 3 {
      let cell = tableView.dequeueReusableCell(withIdentifier: CellID.endTimesPickerViewCell, for: indexPath) as! EndTimesPickerViewCell
      cell.delegate = self
      cell.endType = endType
      return cell
    }
    
    var cell = tableView.dequeueReusableCell(withIdentifier: CellID.basicRecurrenceCell)
    if cell == nil {
      cell = UITableViewCell(style: .default, reuseIdentifier: CellID.basicRecurrenceCell)
    }
    
    if indexPath.row == 0 {
      cell?.textLabel?.text = LocalizedString("basicRecurrence.endDate.never")
    } else if indexPath.row == 1 {
      cell?.textLabel?.text = LocalizedString("basicRecurrence.endDate.onDate")
    } else {
      cell?.textLabel?.text = LocalizedString("basicRecurrence.endDate.after")
    }
    
    let checkmark = UIImage(named: "checkmark", in: Bundle(for: type(of: self)), compatibleWith: nil)
    cell?.imageView?.image = checkmark?.withRenderingMode(.alwaysTemplate)
    
    if indexPath == selectedIndexPath {
      cell?.imageView?.isHidden = false
    } else {
      cell?.imageView?.isHidden = true
    }
    return cell!
  }
  
}

extension EndRecurrenceDateViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedIndexPath = indexPath
    tableView.beginUpdates()
    switch indexPath.row {
    case 0:
      unfold()
      endType = .never
      
    case 1:
      if isShowingAfterTimesPickerView {
        unfoldAfterTimesPicker()
      }
      endType = .onDate(Date())
      foldDatePicker()
      
    case 2 where !isShowingOnDatePickerView, 3 where isShowingOnDatePickerView:
      if isShowingOnDatePickerView {
        unfoldDatePicker()
      }
      endType = .afterTimes(1)
      foldAfterTimesPicker()
      selectedIndexPath = IndexPath(row: 2, section: 0)
      
    default:
      break
    }
    
    tableView.reloadSections(IndexSet(integer: 0), with: .fade)
    tableView.endUpdates()
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

extension EndRecurrenceDateViewController {
  // MARK: - Helper
  fileprivate func commonInit() {
    navigationItem.title = LocalizedString("basicRecurrence.endDate")
    navigationController?.navigationBar.tintColor = tintColor
    tableView.tintColor = tintColor
    if let backgroundColor = backgroundColor {
      tableView.backgroundColor = backgroundColor
    }
    if let separatorColor = separatorColor {
      tableView.separatorColor = separatorColor
    }
    
    let bundle = Bundle(identifier: "Teambition.RecurrencePicker") ?? Bundle.main
    tableView.register(UINib(nibName: "DatePickerViewCell", bundle: bundle), forCellReuseIdentifier: CellID.datePickerViewCell)
    tableView.register(UINib(nibName: "EndTimesPickerViewCell", bundle: bundle), forCellReuseIdentifier: CellID.endTimesPickerViewCell)
  }
  
//  func datePickerViewCell(forIndexPath indexPath: IndexPath) -> uita
  
  func foldDatePicker() {
    guard !isShowingOnDatePickerView else {
      return
    }
    tableView.insertRows(at: [IndexPath(row: 2, section: 0)], with: .none)
    isShowingPickerView = true
  }
  
  func unfoldDatePicker() {
    tableView.deleteRows(at: [IndexPath(row: 2, section: 0)], with: .none)
    isShowingPickerView = false
  }
  
  func foldAfterTimesPicker() {
    guard !isShowingAfterTimesPickerView else {
      return
    }
    tableView.insertRows(at: [IndexPath(row: 3, section: 0)], with: .none)
    isShowingPickerView = true
  }
  
  func unfoldAfterTimesPicker() {
    tableView.deleteRows(at: [IndexPath(row: 3, section: 0)], with: .none)
    isShowingPickerView = false
  }
  
  func unfold() {
    if isShowingOnDatePickerView {
      unfoldDatePicker()
    } else if isShowingAfterTimesPickerView {
      unfoldAfterTimesPicker()
    }
  }
}

extension EndRecurrenceDateViewController: DatePickerViewCellDelegate {
  func datePickerViewCell(_ cell: DatePickerViewCell, didSelectDate date: Date) {
    endType = .onDate(date)
  }
}

extension EndRecurrenceDateViewController: EndTimesPickerViewCellDelegate {
  func endTimesViewCell(_ cell: EndTimesPickerViewCell, didSelectTimes times: Int) {
    endType = .afterTimes(times)
  }
}

protocol EndTypeTableViewCell: UITableViewCell {
  var endType: RecurrenceEndType? { get set }
}
