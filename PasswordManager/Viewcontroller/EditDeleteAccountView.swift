//
//  EditDeleteAccountView.swift
//  Password Manager
//
//  Created by HariKrishna on 11/09/24.
//

import SwiftUI
import UIKit

struct EditDeleteAccountView: View {
    
    var credsDetail: Creds?
    @State var isEditAllow: Bool = false
    @State var accountType: String = ""
    @State var email: String = ""
    @State var password: String = ""
    
    @Binding var editDeleteViewAppear: Bool
    
    var updateCompletion: ((String)->Void)?
    var validationErrorCompletion: (()->Void)?
    
    var body: some View {
        VStack(spacing:20) {
            
            HStack{
                Text(isEditAllow ? "Update Account Details":"Account Details")
                    .font(.custom(Constant.Font.popSemiBold, size: 22))
                    .foregroundStyle(Color.pmBlue)
                
                Spacer()
            }
            .padding(.top, 20)
            
            AccountDetailContainer(containerTitle: "Account Type",
                                   content: $accountType,
                                   isAllowEdit: isEditAllow
            )
            
            AccountDetailContainer(containerTitle: "Username/Email", 
                                   content: $email,
                                   isAllowEdit: isEditAllow
            )
            
            AccountDetailContainer(containerTitle: "Password",
                                   content: $password,
                                   isAllowEdit: isEditAllow,
                                   isPasswordField: true
            )
            
            Spacer()
            
            if isEditAllow {
                PmCustomButton(title: "Save") {
                    if isAccountDetailsValid() {
                        CoreDataManager.shared.updateCredential(credential: credsDetail ?? Creds(), 
                                                                newUsername: email,
                                                                newAccountType: accountType,
                                                                newPassword: password) { success, message in
                            self.editDeleteViewAppear = false
                            self.updateCompletion?(message)
                        }
                    }else{
                        self.validationErrorCompletion?()
                    }
                }
            }else{
                HStack{
                    PmCustomButton(title: "Edit") {
                        self.isEditAllow = true
                    }
                    
                    PmCustomButton(title: "Delete",buttonColor:.pmRed) {
                        CoreDataManager.shared.deleteCredential(credential: credsDetail!) { success, message in
                            self.updateCompletion?(message)
                        }
                    }
                    
                }
                .padding(.bottom, 20)
            }
        }
        .padding(.horizontal)
        .background(Color.pmBackground.ignoresSafeArea())
        .cornerRadius(16)
        .shadow(radius: 10)
        .onAppear(perform: {
            self.fillAccountDetails()
        })
    }
    
    func fillAccountDetails(){
        self.accountType = self.credsDetail?.accountType ?? "-"
        self.email = self.credsDetail?.email ?? "-"
        self.password = CoreDataManager.shared.decodePassword(self.credsDetail?.password ?? Data())
    }
    
    func isAccountDetailsValid() -> Bool {
        if self.accountType.count == 0 {
            return false
        }
        else if self.email.count == 0 {
            return false
        }
        else if self.password.count == 0 {
            return false
        }
        else{
            return true
        }
    }
    
}

struct AccountDetailContainer: View {
    
    var containerTitle: String = ""
    @Binding var content: String
    @State var isPasswordVisable: Bool = false
    
    var isAllowEdit: Bool = false
    var isPasswordField: Bool = false
    
    var body: some View {
        VStack(alignment:.leading){
            Text(containerTitle)
                .font(.custom(Constant.Font.popSemiBold, size: 16))
                .foregroundStyle(Color.gray)
            
            if isAllowEdit {
                PmCustomTextField(text: $content,
                                  placeHolder: containerTitle,
                                  isPasswordField: isPasswordField,
                                  isAlertShown: .constant(false)
                )
            }else{
                HStack{
                    Text(isPasswordField ? (isPasswordVisable ? content:obscurePassword(password: content)):content)
                        .font(.custom(Constant.Font.popSemiBold, size: 18))
                        .foregroundStyle(Color.pmBlack)
                    
                    if isPasswordField {
                        Button(action: {
                            self.copyToClipboard(text: content)
                        }, label: {
                            Image(systemName: "doc.on.doc")
                                .resizable()
                                .frame(width: 15, height: 20)
                                .foregroundStyle(Color.gray)
                        })
                    }
                    Spacer()
                    
                    if isPasswordField {
                        Button(action: {
                            isPasswordVisable.toggle()
                        }, label: {
                            Image(systemName: isPasswordVisable ? "eye":"eye.slash")
                                .resizable()
                                .frame(width: 25, height: 20)
                                .foregroundStyle(Color.gray)
                        })
                    }
                }
            }
        }
    }
    
    func obscurePassword(password:String) -> String {
      return String(repeating: "*", count: password.count)
    }
    
    func copyToClipboard(text: String) {
        UIPasteboard.general.string = text
        
        let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        impactFeedbackGenerator.prepare()
        impactFeedbackGenerator.impactOccurred()
    }
}

#Preview {
    EditDeleteAccountView(editDeleteViewAppear: .constant(false))
}
