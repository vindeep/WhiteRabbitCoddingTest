//
//  Emp+CoreDataProperties.swift
//  Employee

import Foundation
import CoreData


extension Emp {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Emp> {
        return NSFetchRequest<Emp>(entityName: "Emp")
    }

    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var username: String?
    @NSManaged public var profileimage: String?
    @NSManaged public var companyname: String?
    @NSManaged public var website: String?
    @NSManaged public var phone: String?
    @NSManaged public var catchPhrase: String?
    @NSManaged public var bs: String?
    
    @NSManaged public var street: String?
    @NSManaged public var suite: String?
    @NSManaged public var city: String?
    @NSManaged public var zipcode: String?

}

extension Emp : Identifiable {

}
