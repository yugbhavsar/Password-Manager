//
//  CoreDataManager.swift
//  Password Manager
//
//  Created by HariKrishna on 11/09/24.
//

import CoreData
import Foundation

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "PasswordManager")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }

    
    func fetchCredentials() -> [Creds] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Creds> = Creds.fetchRequest()
        
        do {
            let credentials = try context.fetch(fetchRequest)
            return credentials
        } catch {
            print("Failed to fetch credentials: \(error)")
            return []
        }
    }
    
    func saveCredential(username: String, accountType: String, password: String, completion: @escaping ((Bool,String)->Void)) {
        let context = persistentContainer.viewContext
        let credential = Creds(context: context)
        credential.email = username
        credential.accountType = accountType
        
        if let encodedPassword = self.encodePassword(password) {
            credential.password = encodedPassword
        }
        
        do {
            try context.save()
            completion(true,Constant.AlertMessages.addAccountSuccess)
        } catch {
            print("Failed to save credential: \(error)")
            completion(false,Constant.AlertMessages.addAccountError)
        }
    }


    func deleteCredential(credential: Creds,completion: @escaping ((Bool,String)->Void)) {
        let context = persistentContainer.viewContext
        context.delete(credential)
        do {
            try context.save()
            completion(true,Constant.AlertMessages.deleteAccountSuccess)
        } catch {
            print("Failed to delete credential: \(error)")
            completion(false,Constant.AlertMessages.deleteAccountError)
        }
    }
    
    func updateCredential(credential: Creds, newUsername: String, newAccountType: String, newPassword: String,completion: @escaping ((Bool,String)->Void)) {
        let context = persistentContainer.viewContext
        
        credential.email = newUsername
        credential.accountType = newAccountType
        if let encodedPassword = self.encodePassword(newPassword) {
            credential.password = encodedPassword
        }
        
        do {
            try context.save()
            completion(true,Constant.AlertMessages.updateAccountSuccess)
        } catch {
            print("Failed to update credential: \(error)")
            completion(false,Constant.AlertMessages.updateAccountError)
        }
    }
    
    func encodePassword(_ password: String) -> Data? {
            let passwordData = password.data(using: .utf8)
            return passwordData?.base64EncodedData()
        }
        
    func decodePassword(_ encodedData: Data) -> String {
        if let decodedData = Data(base64Encoded: encodedData),
           let decodedPassword = String(data: decodedData, encoding: .utf8) {
            return decodedPassword
        }
        return ""
    }
}
