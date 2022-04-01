//
//  ScannedTextTableViewController.swift
//  text recognition test
//
//  Created by IFTS 25 on 16/03/22.
//

import UIKit
import Contacts
import RealmSwift


class ScannedTextTableViewController: UITableViewController {

    @IBOutlet weak var nameTextfield: UITextField!
    
    @IBOutlet weak var numberTextfield: UITextField!
    
    @IBOutlet weak var addressTextfield: UITextField!
    
    @IBOutlet weak var othernumberTextfield: UITextField!
    
    @IBOutlet weak var websiteTextfield: UITextField!
  
    @IBOutlet weak var contactBtn2: UIBarButtonItem!
    @IBOutlet weak var emailTextfield: UITextField!
    
    var contattoPassato: Contatto?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactBtn2.tintColor = .link
        contactBtn2.isEnabled = true
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

          

           view.addGestureRecognizer(tap)
        
        
        DispatchQueue.main.async {
            
            
            self.checking()
            
           
        }
       

         
         self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
       return 6
        
        
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
   
    @objc func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    @IBAction func saveAction(_ sender: Any) {
      
        
        if nameTextfield.text == nil || nameTextfield.text == "" || numberTextfield.text == nil || numberTextfield.text == "" {
            let alert = UIAlertController(title: "Errore", message: "Prima di salvare inserire nome e numero di telefono..", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default)
            
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
            
        } else {
        
            
            
            
        let realm = try! Realm()
            
        let numero = List<String>()
       
            
            
            numero.append(numberTextfield.text ?? "")
            numero.append(othernumberTextfield.text ?? "")
        
            let contatto = Contatto(email: emailTextfield.text ?? "", nome: nameTextfield.text!, sito: websiteTextfield.text ?? "", address: addressTextfield.text ?? "", numero: numero )
        
        
         
           

            
        try! realm.write {
           
           
           realm.add(contatto)
        }
           
        let alert = UIAlertController(title: "Salvato", message: "Salvato correttamente", preferredStyle: .alert)
            
         
        self.present(alert, animated: true, completion: nil)
            
        
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                alert.dismiss(animated: true, completion: nil)
            self.navigationController?.popToRootViewController(animated: true
            )
            
            }
            
        }
         
        
    }
   
    
    @IBAction func backButton(_ sender: Any) {
       contattoPassato = Contatto()
        
        nameTextfield.text = ""
        numberTextfield.text = ""
        emailTextfield.text = ""
        addressTextfield.text = ""
        websiteTextfield.text = ""
        
        
        
        
        
        navigationController?.popViewController(animated: true)
    }
    

    @IBAction func add(_ sender: UIButton) {
      
        if nameTextfield.text == "" || nameTextfield.text == " " || numberTextfield.text == "" ||
            numberTextfield.text == " " {
            let alert = UIAlertController(title: "Attenzione", message: "Inserisci almeno un nome e un numero di telefono.", preferredStyle: .alert)
            
            
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            alert.addAction(alertAction)
            
            present(alert, animated: true, completion: nil)
            
        } else {
        
            let store = CNContactStore()
            let openContact = CNMutableContact()
            openContact.contactType = .person
            openContact.givenName = nameTextfield.text!
            openContact.phoneNumbers.append(CNLabeledValue(label: CNLabelPhoneNumberMain, value: CNPhoneNumber(stringValue: numberTextfield.text ?? "")))
            openContact.urlAddresses.append(CNLabeledValue(label: CNLabelURLAddressHomePage, value: (websiteTextfield.text ?? "") as NSString))
            openContact.emailAddresses.append(CNLabeledValue(label: CNContactEmailAddressesKey, value: (emailTextfield.text ?? "") as NSString))
            openContact.phoneNumbers.append(CNLabeledValue(label: CNLabelWork, value: CNPhoneNumber(stringValue: othernumberTextfield.text ?? "")))
            let address = CNMutablePostalAddress()
            address.street = addressTextfield.text ?? ""
            
            openContact.postalAddresses.append(CNLabeledValue(label: CNLabelWork, value: address))
            
        
            let saveRequest = CNSaveRequest()
          
            saveRequest.add(openContact, toContainerWithIdentifier: nil)
      do{
             try store.execute(saveRequest)
                let alert = UIAlertController(title: "Salvato!", message: "Contatto salvato con successo", preferredStyle: .alert)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    alert.dismiss(animated: true, completion: nil)
                    self.contactBtn2.isEnabled = false
                    self.contactBtn2.tintColor = UIColor.clear
                   // self.navigationController?.popToRootViewController(animated: true)
                })
                
               
                
                self.present(alert, animated: true, completion: nil)
           
            } catch let error{
                let alert = UIAlertController(title: "Errore", message: error.localizedDescription, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Ok" , style: .cancel)
                
                alert.addAction(alertAction)
                self.present(alert, animated: true, completion: nil)
                
            }
            
        }
        
    }
    
    func checking(){
        
        
        if contattoPassato?.nome != nil {
            
            nameTextfield.placeholder = "Name"
            nameTextfield.text = contattoPassato?.nome!
           
            
            
        } else {
            nameTextfield.text = ""
            nameTextfield.placeholder = "Name"
            
            
        }
        if contattoPassato?.address != nil {
            
            addressTextfield.text = contattoPassato?.address!
            addressTextfield.placeholder = "Address"
        } else {
            addressTextfield.text = ""
            
            addressTextfield.placeholder = "Address"
        }
        
        if let numeri = contattoPassato?.numero {
            
        
            if  numeri.count > 1 {
                if numeri[0].hasPrefix("0") || numeri[1].hasPrefix("3") {
                    numberTextfield.text = numeri[1]
                    othernumberTextfield.text = numeri[0]
                    othernumberTextfield.placeholder = "Other number"
                    numberTextfield.placeholder = "Number"
                
                } else {
                    numberTextfield.text = numeri[0]
                        othernumberTextfield.text = numeri[1]
                        othernumberTextfield.placeholder = "Other number"
                    numberTextfield.placeholder = "Number"
                }
            
            
            } else if numeri.count == 1 {
                numberTextfield.text = numeri[0]
                othernumberTextfield.text = ""
                othernumberTextfield.placeholder = "Other number"
            numberTextfield.placeholder = "Number"
            } else {
                othernumberTextfield.placeholder = "Other number"
                numberTextfield.placeholder = "Number"
                numberTextfield.text = ""
                othernumberTextfield.text = ""
                
            }
        }
        
        if contattoPassato?.email != nil {
            emailTextfield.text = contattoPassato?.email!.lowercased()
            emailTextfield.placeholder = "Email"
            
        } else {
            
            emailTextfield.text = ""
            emailTextfield.placeholder = "Email"
        }
        if contattoPassato?.sito != nil {
            websiteTextfield.text = contattoPassato?.sito!
            websiteTextfield.placeholder = "Web site"
            
            
        } else {
            websiteTextfield.text = ""
            websiteTextfield.placeholder = "Web site"
            
            
        }
        
        
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

    
