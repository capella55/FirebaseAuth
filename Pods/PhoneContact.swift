import Contacts

class PhoneContact {
    var contactId = ""
    var firstName = ""
    var middleName = ""
    var lastName = ""
    
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
    
    static func getPhoneContactFromCNContact(_ contact: CNContact) -> PhoneContact {
        let phoneContact = PhoneContact()
        
        var firstName = contact.givenName
        if (firstName == "") {
            firstName = "First"
        }
        phoneContact.firstName = firstName
        
        var lastName = contact.familyName
        if (lastName == "") {
            lastName = "Last"
        }
        phoneContact.lastName = lastName
        phoneContact.middleName = contact.middleName
        
        return phoneContact
    }
}
