//
//  AddCredentialView.swift
//  Password Manager
//
//  Created by HariKrishna on 11/09/24.
//

import SwiftUI

struct AddCredentialView: View {
    @State private var accountType: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var validationError: Bool = false
    
    @Binding var addCredentialViewAppear: Bool
    
    var addCompletion: ((String)->Void)?
    
    var body: some View {
        VStack(spacing:20) {
            
            PmCustomTextField(text: $accountType, placeHolder: "Account Name",isAlertShown: $validationError)
                
            
            PmCustomTextField(text: $username,
                              placeHolder: "Username/Email",
                              isAlertShown: $validationError)
                
            PmCustomTextField(text: $password,
                              placeHolder: "Password",
                              isPasswordField: true,
                              isPasswordVisiable: false,
                              isAlertShown: $validationError)
            
            Spacer()
            
            PmCustomButton(title: "Add New Account") {
                if self.isAccountDetailsValid() {
                    CoreDataManager.shared.saveCredential(username: username, accountType: accountType,password: password) { success, errorMessage in
                        
                        self.addCredentialViewAppear = false
                        self.addCompletion?(errorMessage)
                    }
                }else{
                    self.validationError = true
                }
                
            }
            .padding(.bottom, 20)
        }
        .padding(.top, 20)
        .padding(.horizontal)
        .background(Color.pmBackground)
        .cornerRadius(16)
        .shadow(radius: 10)
    }
    
    
    func isAccountDetailsValid() -> Bool {
        if self.accountType.count == 0 {
            return false
        }
        else if self.username.count == 0 {
            return false
        }
        else if self.password.count == 0 {
            return false
        }else{
            return true
        }
    }
}

#Preview {
    AddCredentialView(addCredentialViewAppear: .constant(false))
}
