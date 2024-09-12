//
//  Creds+CoreDataProperties.swift
//  PasswordManager
//
//  Created by HariKrishna on 11/09/24.
//
//

import Foundation
import CoreData


extension Creds {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Creds> {
        return NSFetchRequest<Creds>(entityName: "Creds")
    }

    @NSManaged public var email: String?
    @NSManaged public var accountType: String?
    @NSManaged public var password: Data?

}

extension Creds : Identifiable {

}
