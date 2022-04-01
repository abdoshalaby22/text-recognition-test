//
//  SavedCardsViewController.swift
//  text recognition test
//
//  Created by IFTS 25 on 17/03/22.
//

import UIKit
import RealmSwift

class SavedCardsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var array : [Contatto] = []
    @IBOutlet weak var SavedcardsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        SavedcardsTableView.layer.cornerRadius = 20
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reload()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func reload(){
        
        let realm = try! Realm()
        array = Array(realm.objects(Contatto.self))
       
        SavedcardsTableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return array.count
 
        
      //  return arrayNote.count  //arrayNote.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ciao", for: indexPath) as! SavedCardsTableViewCell
      
      
        
        
        
        cell.setup(with:   array[indexPath.row])
      //  cell.numeroLabel.text = array[0]
        
       // cell.nomeLabel.text = array[1]
      
        return cell
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "eccoci" {
            guard let indexPath = SavedcardsTableView.indexPathForSelectedRow else {return}
            guard let destination = segue.destination as? UpdateAndDeleteTableViewController else {return}
            destination.businessCardPass = array[indexPath.row]
            
            
        }
    }
}
