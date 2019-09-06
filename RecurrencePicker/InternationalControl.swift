//
//  InternationalControl.swift
//  RecurrencePicker
//
//  Created by Xin Hong on 16/4/7.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import Foundation

public enum RecurrencePickerLanguage: String {
    case english = "en"
    case german = "de"
    case italian = "it"
    case russian = "ru"
    case french = "fr"
 
    internal var identifier: String {
      return rawValue
    }
}

internal func LocalizedString(_ key: String, comment: String? = nil) -> String {
    return InternationalControl.shared.localizedString(key, comment: comment)
}

public struct InternationalControl {
    public static var shared = InternationalControl()
    public var language: RecurrencePickerLanguage = .english

    internal func localizedString(_ key: String, comment: String? = nil) -> String {
        let path = Bundle(identifier: "Teambition.RecurrencePicker")?.path(forResource: language.identifier, ofType: "lproj") ?? Bundle.main.path(forResource: language.identifier, ofType: "lproj")
        guard let localizationPath = path else {
            return key
        }
        let bundle = Bundle(path: localizationPath)
        return bundle?.localizedString(forKey: key, value: nil, table: "RecurrencePicker") ?? key
    }
}
