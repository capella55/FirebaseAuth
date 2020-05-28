import CoreData

public class Contact : NSManagedObject {
    @NSManaged var contactId: String
    @NSManaged var firstName: String
    @NSManaged var middleName: String
    @NSManaged var lastName: String
    
    func setPhoneContactData(_ phoneContact: PhoneContact) {
        contactId = phoneContact.contactId
        firstName = phoneContact.firstName
        middleName = phoneContact.middleName
        lastName = phoneContact.lastName
    }
    
    func getFirstName() -> String {
        return firstName
    }
    
    func getLastName() -> String {
        return lastName
    }
    
    func getName() -> String {
        var name = ""
        
        if (firstName != "") {
            name = firstName
        }
        
        if (name == "") {
            if (middleName != "") {
                name = middleName
            }
        }
        else {
            if (middleName != "") {
                name = name + " " + middleName
            }
        }
        
        if (name == "") {
            if (lastName != "") {
                name = lastName
            }
        }
        else {
            if (lastName != "") {
                name = name + " " + lastName
            }
        }
        
        return name
    }
    
    func getSectionKey(_ sortType: Int) -> Character {
        var filterText = ""
        switch sortType {
        case 0:
            filterText = getFirstName()
            break
        default:
            filterText = getLastName()
            break
        }
        
        var firstLetter = "["
        if (filterText.count > 0) {
            firstLetter = filterText[..<filterText.index(after: filterText.startIndex)].uppercased()
            if (firstLetter.compare("A") == .orderedAscending || firstLetter.compare("Z") == .orderedDescending) {
                firstLetter = "["
            }
        }
        
        return Character(firstLetter)
    }
    
    func getSection(_ sortType: Int) -> Int {
        var section = Int(getSectionKey(sortType).unicodeScalars.first!.value - 65)
        if (section < 0 || section > 26) {
            section = 26
        }
        
        return section
    }
}
