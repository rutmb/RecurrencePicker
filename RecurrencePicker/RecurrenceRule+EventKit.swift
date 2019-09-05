//
//  RecurrenceRule+EventKit.swift
//  RecurrencePicker
//
//  Created by Igor Rudenko on 05/09/2019.
//  Copyright © 2019 Teambition. All rights reserved.
//

import RRuleSwift
import EventKit

extension RecurrenceRule {
  func toEKRecurrenceRule() -> EKRecurrenceRule? {
    let rrule = toRRuleString()
    return EKRecurrenceRule.recurrenceRuleFromString(rrule)
  }
}
