//
//  UpdateAndDeleteTableViewController.swift
//  text recognition test
//
//  Created by IFTS 25 on 18/03/22.
//
import RealmSwift
import UIKit

import Contacts

class UpdateAndDeleteTableViewController: UITableViewController {

    @IBOutlet weak var nameTextfielf: UITextField!
   
    var businessCardPass : Contatto?
    
    var cancellato : Bool = false
    
    @IBOutlet weak var numberTextfield2: UITextField!
    
    
    @IBOutlet weak var addressTextfield2: UITextField!
    
    @IBOutlet weak var emailTextfield2: UITextField!
    
   
    @IBOutlet weak var contactBtn: UIBarButtonItem!
   
    @IBOutlet weak var websiteTextfield: UITextField!
    
    @IBOutlet weak var otherNumberTextfield2: UITextField!
 
    override func viewDidLoad() {
        super.viewDidLoad()

        setup(contatto: businessCardPass)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        contactBtn.isEnabled = true
        contactBtn.tintColor = .link
          

           view.addGestureRecognizer(tap)
        
         self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func addContact(_ sender: UIButton) {
        
        if nameTextfielf.text == "" || nameTextfielf.text == " " || numberTextfield2.text == "" ||
            numberTextfield2.text == " " {
            let alert = UIAlertController(title: "Attenzione", message: "Inserisci almeno un nome e un numero di telefono.", preferredStyle: .alert)
            
            
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            alert.addAction(alertAction)
            
            present(alert, animated: true, completion: nil)
            
        } else {
        
            let store = CNContactStore()
            let openContact = CNMutableContact()
            openContact.contactType = .person
            openContact.givenName = nameTextfielf.text!
            openContact.phoneNumbers.append(CNLabeledValue(label: CNLabelPhoneNumberMain, value: CNPhoneNumber(stringValue: numberTextfield2.text ?? "")))
            openContact.urlAddresses.append(CNLabeledValue(label: CNLabelURLAddressHomePage, value: (websiteTextfield.text ?? "") as NSString))
            openContact.emailAddresses.append(CNLabeledValue(label: CNContactEmailAddressesKey, value: (emailTextfield2.text ?? "") as NSString))
            openContact.phoneNumbers.append(CNLabeledValue(label: CNLabelWork, value: CNPhoneNumber(stringValue: otherNumberTextfield2.text ?? "")))
            let address = CNMutablePostalAddress()
            address.street = addressTextfield2.text ?? ""
            
            openContact.postalAddresses.append(CNLabeledValue(label: CNLabelWork, value: address))
            
        
            let saveRequest = CNSaveRequest()
          
            saveRequest.add(openContact, toContainerWithIdentifier: nil)
      do{
             try store.execute(saveRequest)
                let alert = UIAlertController(title: "Salvato!", message: "Contatto salvato con successo", preferredStyle: .alert)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    alert.dismiss(animated: true, completion: nil)
                    
                    self.contactBtn.isEnabled = false
                    self.contactBtn.tintColor = UIColor.clear
                
                    
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
    
    
    @objc func dismissKeyboard() {
        
        view.endEditing(true)
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
    func setup(contatto :Contatto? ) {
        guard let contatto = contatto else {
            return
        }

        var otherNumber = ""
        var number = ""
        
        if contatto.numero[1] == "" || contatto.numero[1].isEmpty || contatto.numero.isEmpty  {
             otherNumber = ""
            
        } else {
            
             otherNumber = contatto.numero[1]
            
        }
        
        if contatto.numero[0] == "" || contatto.numero[0].isEmpty || contatto.numero.isEmpty {
            number = ""
            
        } else {
            
            number = contatto.numero[0]
            
        }
        
        
        nameTextfielf.text = contatto.nome ?? ""
        numberTextfield2.text = number
        addressTextfield2.text = contatto.address ?? ""
        emailTextfield2.text = contatto.email ?? ""
        websiteTextfield.text = contatto.sito ?? ""
        otherNumberTextfield2.text = otherNumber
        
        
    }
    
    
    @IBAction func updateAction(_ sender: Any) {
        
       cancellato = false
        salvaNota()
        let alert = UIAlertController(title: "Perfetto!", message: "Informazioni contatto aggiornate con successo", preferredStyle: .alert)
        
        present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            alert.dismiss(animated: true, completion: nil)
            
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        cancellato = true
         let alert = UIAlertController(title: "Attenzione", message: "Vuoi cancellare il biglietto da visita?", preferredStyle: .alert)
         let cancella = UIAlertAction(title: "Cancella", style: .destructive) { _ in
             self.delete()
             
         }
         
         let annulla = UIAlertAction(title: "Annulla", style: .default ) { _ in
             self.cancellato = false
         }
         
         alert.addAction(annulla)
         alert.addAction(cancella)
         present(alert, animated: true, completion: nil)
         
       
        
        
    }
    func salvaNota(){
       cancellato = false
        
        guard let businessCardPass = businessCardPass else {
            return
        }
 
        
let realm = try! Realm()
       
        
        try! realm.write{
            if nameTextfielf.text == "" || nameTextfielf.text == nil || numberTextfield2.text == "" || numberTextfield2.text == nil {
                let alert = UIAlertController(title: "errore", message: "inserire almeno nome e numero.. ", preferredStyle: .alert)
                
                let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                
                alert.addAction(alertAction)
                self.present(alert, animated: true, completion: nil)
                
            } else {
            businessCardPass.nome = nameTextfielf.text
            businessCardPass.address = addressTextfield2.text
            businessCardPass.sito = websiteTextfield.text
            businessCardPass.email = emailTextfield2.text
                businessCardPass.numero[0] = numberTextfield2.text ?? ""
            businessCardPass.numero[1] = otherNumberTextfield2.text ?? ""
            
            
            
            realm.add(businessCardPass)
            }
        }
        
    }
    
    func delete(){
        guard let businessCardPass = businessCardPass else {
            return
        }
 
        

        let realm = try! Realm()
        try! realm.write({
            
            realm.delete(businessCardPass)
            
        })
        self.navigationController?.popViewController(animated: true)
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
