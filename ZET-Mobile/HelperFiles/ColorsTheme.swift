//
//  ColorsTheme.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 04/05/22.
//

import UIKit

// #BDBDBD in dark  and darkgrey in light
var darkGrayLight = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00) : UIColor.darkGray)

// #828282 in dark  and ECECEC in light
var colorLine = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00) : UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00))

// #404040 in dark  and white in light
var colorGrayWhite = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.00) : UIColor.white)

// white view in light and #303133 in dark
var contentColor = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor(red: 0.19, green: 0.19, blue: 0.20, alpha: 1.00) : UIColor.white)

// white view in light and #303133 in dark
var alertColor = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor(red: 0.26, green: 0.26, blue: 0.26, alpha: 1) : UIColor.white)

// #303133 in dark and #ECECEC
var toolbarColor = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor(red: 0.20, green: 0.20, blue: 0.21, alpha: 1.00) : UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00))

var colorBlackWhite = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor.white : UIColor.black)

// #404040 in dark  and #F5F5F5 in light
var colorLightDarkGray = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.00) : UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00))

// #303133 in dark  and #F5F5F5 in light
var colorLightDarkGray2 = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 1.00) : UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00))

// #2B2B2B in dark  and #F5F5F5 in light
var colorGrayandDark = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 1.00) : UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00))

// #404040 in dark and #F5F5F5 in light

    // another toolbar
var toolbarColorGradient: UIColor = {
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [UIColor(red: 1, green: 0.949, blue: 0.89, alpha: 1).cgColor,
                            UIColor(red: 0.942, green: 0.84, blue: 0.72, alpha: 1).cgColor]
    gradientLayer.startPoint = CGPoint(x: 0, y: 0)
    gradientLayer.endPoint = CGPoint(x: 1, y: 0)
    gradientLayer.frame = UIScreen.main.bounds
    
    let gradientImage = UIGraphicsImageRenderer(bounds: gradientLayer.bounds).image { context in
        gradientLayer.render(in: context.cgContext)
    }
    
    return UIColor(patternImage: gradientImage)
}()
