//
//  Constant.swift
//  Password Manager
//
//  Created by HariKrishna on 11/09/24.
//

import Foundation
import SwiftUI

class Constant: NSObject {
    
    struct Font{
        static var popBold = "Poppins-Bold"
        static var popSemiBold = "Poppins-SemiBold"
        static var popMedium = "Poppins-Medium"
        static var popRegular = "Poppins-Regular"
    }
    
    struct AlertMessages {
        
        static let fetchDataError = "There was an error fetching the data. Please try again."
        static let validationError = "Please ensure all required fields are filled."
        
        static let deleteAccountSuccess = "Account deleted successfully."
        static let deleteAccountError = "There was an error deleting the account. Please try again."
        
        static let addAccountSuccess = "Account added successfully."
        static let addAccountError = "There was an error adding the account. Please try again."

        
        static let updateAccountSuccess = "Account updated successfully."
        static let updateAccountError = "There was an error updating the account. Please try again."
    }
}

extension Color {
    
    static var pmBackground = Color("PrimaryBackground")
    static var pmBlack = Color("PrimaryBlack")
    static var pmBlue = Color("PrimaryBlue")
    static var pmRed = Color("PrimaryRed")
    
}
