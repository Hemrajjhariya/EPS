//
//  ViewController.swift
//  EPS
//
//  Created by Hemraj on 10/07/18.
//  Copyright © 2018 Hemraj. All rights reserved.
//

import UIKit
import CoreData
import SVProgressHUD
class ViewController: UIViewController,UserInfoDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtDOB: UITextField!
    @IBOutlet weak var txtMobilenumber: UITextField!
    @IBOutlet weak var btnPhoto: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnUpdate: UIButton!
    weak var userImage :UIImageView!
    
    
    var objectNSManaged: [NSManagedObject] = []
    var userInfoData = NSMutableArray()
    var userData = NSDictionary()
    var name = String()
    var imageData = Data()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func tapPhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
     
    }
    
    @IBAction func tapSubmit(_ sender: Any) {
        
        if let string = txtName.text,string.isEmpty {
            let alertView = UIAlertController(title: "Alert", message: "Enter your name", preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alertView, animated: true, completion: nil)

            return
        }
        
        if let string = txtDOB.text,string.isEmpty {
            let alertView = UIAlertController(title: "Alert", message: "Enter your DOB", preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alertView, animated: true, completion: nil)
            
            return
        }
        let boolean = Validation.isValidDate(dateString: txtDOB.text!)
        
        if !boolean{
            let alertView = UIAlertController(title: "Alert", message: "Enter valid DOB", preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alertView, animated: true, completion: nil)
            
            return
        }
       
        if let string = txtMobilenumber.text,string.isEmpty {
            let alertView = UIAlertController(title: "Alert", message: "Enter your mobile number", preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alertView, animated: true, completion: nil)
            
            return
        }
        
        if Validation.isValidPhone(value: txtMobilenumber.text!){
            print("You Phone Number is Valid")
        }else{
            print("You Phone Number isn't Valid")
            let alert = UIAlertController(title: "Alert", message: "You Phone Number isn't Valid", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
       
        if imageData.count == 0 {
            let alertView = UIAlertController(title: "Alert", message: "Please select photo.", preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alertView, animated: true, completion: nil)
            
            return
        }
      
        SVProgressHUD.show()
        self.save(name: txtName.text!, DOB: txtDOB.text!, mobilenumber: txtMobilenumber.text!, photo: imageData)
    }
    

    func save(name: String, DOB: String, mobilenumber: String, photo: Data) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "UserInfo",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // 3
        person.setValue(name, forKeyPath: "name")
        person.setValue(DOB, forKeyPath: "dob")
        person.setValue(mobilenumber, forKeyPath: "mobilenumber")
        person.setValue(photo, forKeyPath: "photo")
        
        // 4
        do {
            try managedContext.save()
            objectNSManaged.append(person)
            let alert = UIAlertController(title: "Alert", message: "Save", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            txtName.text = ""
            txtMobilenumber.text = ""
            txtDOB.text = ""
            imageData.removeAll()
            self.btnPhoto.setBackgroundImage(nil, for: .normal)
            self.updateData()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        SVProgressHUD.dismiss()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Detail" {
            self.updateData()
            let obj = (segue.destination as! DetailViewController)
            obj.delegate = self
            obj.userInfoData = userInfoData 
            
        }
    }

    func passData(_ Data: NSDictionary) {
        btnSubmit.isEnabled = false
        btnUpdate.isEnabled = true
        userData  = Data;
        txtName.text = (Data.value(forKey: "name") as! String)
        txtMobilenumber.text = (Data.value(forKey: "mobilenumber") as! String)
        txtDOB.text = (Data.value(forKey: "dob") as! String)
        imageData = (Data.value(forKey: "photo") as! Data)
        DispatchQueue.global(qos: .userInitiated).async {
            let imageUIImage: UIImage = UIImage(data: Data.value(forKey: "photo") as! Data)!
            DispatchQueue.main.async {
                self.btnPhoto.setBackgroundImage(imageUIImage, for: .normal)
            }
        }
    }
    
    func updateData(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserInfo")
        request.returnsObjectsAsFaults = false
        do {
            userInfoData.removeAllObjects()
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                var dictionary = [String:AnyObject]()
                dictionary["name"] = data.value(forKey: "name") as AnyObject
                dictionary["mobilenumber"] = data.value(forKey: "mobilenumber") as AnyObject
                dictionary["dob"] = data.value(forKey: "dob") as AnyObject
                dictionary["photo"] = data.value(forKey: "photo") as AnyObject
                userInfoData.add(dictionary)
                
            }
        } catch {
            print("Failed")
        }
    }
    
  
    @IBAction func updateData(_ sender: Any) {
        SVProgressHUD.show()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        name = userData.value(forKey: "name") as! String
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "UserInfo")
        let predicate = NSPredicate(format: "name = '\(String(describing: name))'")
        fetchRequest.predicate = predicate
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            if test.count == 1
            {
                let objectUpdate = test[0] as! NSManagedObject
                objectUpdate.setValue(txtName.text, forKey: "name")
                objectUpdate.setValue(txtMobilenumber.text, forKey: "mobilenumber")
                objectUpdate.setValue(txtDOB.text, forKey: "dob")
                objectUpdate.setValue(imageData, forKey: "photo")
                
                do{
                   try managedContext.save()
                }
                catch
                {
                    print(error)
                }
            }
        }
        catch
        {
            print(error)
        }
        SVProgressHUD.dismiss()
    }
 
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
      //  userImage.contentMode = .scaleAspectFit
       // userImage.image = chosenImage
        imageData = UIImagePNGRepresentation(chosenImage)!
        btnPhoto.setBackgroundImage(chosenImage, for: .normal)
        dismiss(animated:true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func clearData(){
        txtName.text = ""
        txtMobilenumber.text = ""
        txtDOB.text = ""
        imageData.removeAll()
        self.btnPhoto.setBackgroundImage(nil, for: .normal)
        btnSubmit.isEnabled = true
        btnUpdate.isEnabled = false
        
    }
}
