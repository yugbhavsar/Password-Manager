//
//  Component.swift
//  Password Manager
//
//  Created by HariKrishna on 11/09/24.
//

import Foundation
import SwiftUI

struct PmCustomButton:View {
   
    var title: String = ""
    var buttonColor: Color = .pmBlack
    
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom(Constant.Font.popSemiBold, size: 16))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(buttonColor)
                .cornerRadius(8)
                
        }
    }
}


struct PmCustomTextField: View {
    
    @Binding var text: String
    var placeHolder: String
    var isPasswordField: Bool = false
    var validationMessage: String = ""
    @State var isPasswordVisiable: Bool = true
    @Binding var isAlertShown: Bool
    
    var body: some View {
        VStack(alignment: .leading){
            ZStack{
                HStack{
                    if isPasswordVisiable {
                        TextField(placeHolder, text: $text)

                    }else{
                        SecureField(placeHolder, text: $text)
                    }
                    if isPasswordField {
                        Spacer()
                        Button(action: {
                            isPasswordVisiable.toggle()
                        }, label: {
                            Image(systemName: isPasswordVisiable ? "eye":"eye.slash")
                                .resizable()
                                .frame(width: 25, height: 20)
                                .foregroundStyle(Color.gray)
                        })
                    }
                }
                
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1).fill(.white))
            if self.isAlertShown && text.count == 0 {
                Text("\(placeHolder) is required!")
                    .font(.custom(Constant.Font.popMedium, size: 14))
                    .foregroundStyle(Color.pmRed)
            }
        }
    }
}
