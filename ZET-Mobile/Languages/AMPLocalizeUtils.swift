//
//  AMPLocalizeUtils.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/16/21.
//

import Foundation

import UIKit

enum LanguageType: String {
    case en = "en"
    case ru = "ru"
    case tj = "tg"
}

class AMPLocalizeUtils: NSObject {
    static let defaultLocalizer: AMPLocalizeUtils = {
        AMPLocalizeUtils()
    }()
    
    var appbundle = Bundle.main
    var currentLanguage: LanguageType = .ru
    
    func setSelectedLanguage(lang: LanguageType) {
        guard let langPath = Bundle.main.path(forResource: lang.rawValue, ofType: "lproj") else {
            appbundle = Bundle.main
            return
        }
        appbundle = Bundle(path: langPath)!
        currentLanguage = lang
    }
    
    func stringForKey(key: String) -> String {
        return appbundle.localizedString(forKey: key, value: "", table: nil)
    }
}
