//
//  ContentView.swift
//  Password Manager
//
//  Created by HariKrishna on 11/09/24.
//

import SwiftUI
import CoreData

struct DashboardView: View {

    @State var credentials: [Creds] = []
    @State var addCreds: Bool = false
    
    @State var isShownPopup: Bool = false
    @State var alertMessage: String = ""
    
    var body: some View {
        NavigationView {
            ZStack{
                VStack {
                    ScrollView(.vertical) {
                        LazyVStack(spacing: 25) {
                            ForEach(self.credentials, id: \.self) { i in
                                CredentialTemplate(selectedCreds: i) { isForAlert, message in
                                    if !isForAlert {
                                        fetchCredData()
                                    }
                                    self.managePopupScreen(message: message)
                                }
                            }
                        }
                        .padding(.top, 50)
                    }
                    Spacer()
                }
                
                VStack{
                    Text(alertMessage)
                        .font(.custom(Constant.Font.popSemiBold, size: 16))
                        .foregroundStyle(.white)
                        .padding([.horizontal,.vertical] , 20)
                        .background {
                            RoundedRectangle(cornerRadius: 12).fill(Color.pmBlue.opacity(0.6))
                        }
                    Spacer()
                }
                .offset(y: isShownPopup ? 0:-UIScreen.main.bounds.height/2)
            }
            .background(Color.pmBackground.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Password Manager")
                        .font(.custom(Constant.Font.popSemiBold, size: 20))
                }
            }
            .overlay(
                FloatingButton(action: {
                    self.addCreds.toggle()
                }),
                alignment: .bottomTrailing
            )
            .sheet(isPresented: $addCreds) {
                AddCredentialView(addCredentialViewAppear: $addCreds,addCompletion: { message in
                    self.fetchCredData()
                    self.managePopupScreen(message: message)
                })
                .presentationDetents([.medium,.large])
                .presentationCornerRadius(22)
            }
        }
        .onAppear(perform: {
            fetchCredData()
        })
    }

    func managePopupScreen(message: String){
        self.alertMessage = message
        withAnimation {
            self.isShownPopup = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                self.isShownPopup = false
            }
        }
    }
    
    func fetchCredData(){
        self.credentials.removeAll()
        self.credentials = CoreDataManager.shared.fetchCredentials()
    }
}


struct CredentialTemplate: View {
    
    var selectedCreds: Creds
    @State var editCreds: Bool = false
    
    var updateCompletion: ((Bool,String)->Void)?

    var body: some View {
        HStack {
            Text("\(self.selectedCreds.accountType ?? "")")
                .font(.custom(Constant.Font.popMedium, size: 18))
            Spacer()
            Image(systemName: "arrow.right")
                .resizable()
                .frame(width: 20, height: 15)
                .foregroundColor(.black)
        }
        .padding([.horizontal,.vertical], 20)
        .background(RoundedRectangle(cornerRadius: 40).fill(Color.white).shadow(radius: 2))
        .padding([.leading, .trailing ] , 20)
        .onTapGesture(perform: {
            self.editCreds.toggle()
        })
        .sheet(isPresented: $editCreds, content: {
            EditDeleteAccountView(credsDetail: selectedCreds,editDeleteViewAppear: $editCreds) { message in
                self.updateCompletion?(false,message)
            } validationErrorCompletion: {
                self.updateCompletion?(true,Constant.AlertMessages.validationError)
            }
            .presentationDetents([.medium,.large])
            .presentationCornerRadius(22)
        })
    }
}

struct FloatingButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .resizable()
                .frame(width: 30, height: 30)
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.pmBlue))
                .foregroundColor(.white)
                .shadow(radius: 5)
        }
        .frame(width: 60, height: 60)
        .padding(20)
    }
}


#Preview {
    DashboardView()
}
