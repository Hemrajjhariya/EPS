

//MARK:- Validation file in Swift.

import UIKit
class Validation: NSObject {
    // PhoneNumber Validation
    class func isValidPhone(value: String) -> Bool {

        let PHONE_REGEX = "(?:(?:\\+|0{0,2})91(\\s*[\\- ]\\s*)?|[0 ]?)?[789]\\d{9}|(\\d[ -]?){10}\\d"

        // let PHONE_REGEX = "^[7-9][0-9]{9}$"
            
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
   class func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
   class func isValidDate(dateString: String) -> Bool {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd-MM-yyyy"
        if let _ = dateFormatterGet.date(from: dateString) {
            //date parsing succeeded, if you need to do additional logic, replace _ with some variable name i.e date
            return true
        } else {
            // Invalid date
            return false
        }
    }

   
}



//
//// Use above Validation.Swift file in another ViewController.Swift file as below.
//
//if Validation.isValidPhone(value: "123569874563"){
//    print("You Phone Number is Valid")
//}else{
//    print("You Phone Number isn't Valid")
//}
