//
//  String+Extension.swift
//  SwiftUI-MVVM-Combine
//
//  Created by Mahmoud Ismail on 23/11/2023.
//

import Foundation

extension String {
    
    func convertDateString(to format: String = "MMMM yyyy") -> String? {
        let inputFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en") // Set the Arabic locale
        inputFormatter.dateFormat = inputFormat
        
        if let date = inputFormatter.date(from: self) {
            let outputFormatter = DateFormatter()
            outputFormatter.locale = Locale(identifier: "ar") // Set the Arabic locale
            outputFormatter.dateFormat = format // Desired output format
            
            let outputString = outputFormatter.string(from: date)
            return outputString
        } else {
            return nil // Failed to parse the input date string
        }
    }
    
}
