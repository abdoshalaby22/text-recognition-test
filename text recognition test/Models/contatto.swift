//
//  contatto.swift
//  text recognition test
//
//  Created by IFTS 25 on 28/02/22.
//

import Foundation
import RealmSwift


 class Contatto  : Object, Codable  {
    
    @Persisted var email:  String?
    
     @Persisted var numero = List<String>()
    
   @Persisted var nome : String?
    
   @Persisted var sito : String?
     
   @Persisted var address : String?
     
     
     convenience init(email: String, nome : String, sito :String, address: String, numero:List<String> ){
        self.init()
        self.email = email
         self.numero = numero
         self.nome = nome
         self.sito = sito
         self.address = address
        
         
     }
    
     
}







