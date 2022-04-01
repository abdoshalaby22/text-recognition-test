//
//  ViewController.swift
//  text recognition test
//
//  Created by IFTS 25 on 25/02/22.
//

import UIKit
import Vision
import Photos
import PhotosUI
import VisionKit
import SwiftUI
import RealmSwift



class ViewController: UIViewController, PHPickerViewControllerDelegate, VNDocumentCameraViewControllerDelegate {
    
    
    
    
    @IBOutlet weak var button : UIButton!
    
    var contatto = Contatto()
    
    
    var imagePronta : UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    
   
   
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
       
        contatto = Contatto()
        
   
    }
    
  
    
    @IBAction func scanning(_ sender: Any) {
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = self
        
        present(documentCameraViewController, animated: true)
        
    }
    func parseTextContents(text: String) {
        
        
        
        
        do {
            // Any line could contain the name on the business card.
            var potentialNames = text.components(separatedBy: .newlines)
            
            // Create an NSDataDetector to parse the text, searching for various fields of interest.
            let detector = try NSDataDetector(types: NSTextCheckingAllTypes)
            let matches = detector.matches(in: text, options: .init()  , range: NSRange(location: 0, length: text.count))
            
           
            for match in matches {
                let matchStartIdx = text.index(text.startIndex, offsetBy: match.range.location)
                let matchEndIdx = text.index(text.startIndex, offsetBy: match.range.location + match.range.length)
                let matchedString = String(text[matchStartIdx..<matchEndIdx])
                
                // This line has been matched so it doesn't contain the name on the business card.
                while !potentialNames.isEmpty && (matchedString.contains(potentialNames[0]) || potentialNames[0].contains(matchedString)) {
                    potentialNames.remove(at: 0)
                }
            
                switch match.resultType {
                
                
                case .address:
                    contatto.address  = matchedString
             //       contatto.address = matchedString
                
                    
                case .phoneNumber:
                    
                    contatto.numero.append(matchedString)
                    
                case .link:
                    if (match.url?.absoluteString.contains("mailto"))! {
                        contatto.email = matchedString
                       
                    } else {
                        contatto.sito = matchedString
                      
                    }
                    
                
                default:
                    print("\(matchedString) type:\(match.resultType)")
                }
            }
            if !potentialNames.isEmpty {
               
                contatto.nome = potentialNames.first!
            }
//            DispatchQueue.main.async {
//                if self.contatto.numero.isEmpty || self.contatto.numero[0].isEmpty {
//                    self.contatto.numero = []
//                } else {
//                    
//                    print(self.contatto)
//                }
//                
//            }
           
            
           
        } catch  {
            print(error)
            
        }
        
        
       
    }
    
    func recognizeText(image: UIImage? ){
        guard let cgImage = image?.cgImage else {return}
       
        // handler
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        // request
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let self = self else {return}
            
            guard let observations = request.results as? [VNRecognizedTextObservation], error == nil  else {
                
                print(error!.localizedDescription)
                return
                
                
            }
          
          
                // Create a full transcript to run analysis on.
               var fullText = ""
                let maximumCandidates = 1
                for observation in observations {
                    guard let candidate = observation.topCandidates(maximumCandidates).first else { continue }
                    fullText.append(candidate.string + "\n")
                }
            print(fullText)
           
           
                
            self.parseTextContents(text: fullText)
                
            
             
            
            
            print(self.contatto)
            
                
            }
            
            
       
            
            
        
        
    
    request.recognitionLevel = .accurate
    request.usesLanguageCorrection = true
    
    
    
    // process request
    do {
        
        try handler.perform([request])
        
        print("ok")
    }
    catch {
        print(error.localizedDescription)
        
    }
    
}



    
    
    



@IBAction func cameraButton(_ sender: Any) {
    setupGallery()
    
}






@IBAction func scanButton(_ sender: Any) {
    
    
  
    
        self.recognizeText(image: self.imagePronta)
        
        self.performSegue(withIdentifier: "ciao", sender: contatto )
    
    
    
    
    
    
}

func setupGallery(){
    
    var config = PHPickerConfiguration(photoLibrary: .shared())
    config.selectionLimit = 1
    config.filter = .images
    let vc = PHPickerViewController(configuration: config)
    vc.delegate = self
    present(vc, animated: true, completion: nil)
    
    
    
    
}

func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    picker.dismiss(animated: true, completion: nil)
    results.forEach { results in
        
        results.itemProvider.loadObject(ofClass: UIImage.self) {[weak self] reading, error in
         
           
            
            guard let image = reading as? UIImage, error == nil else {return}
            
            DispatchQueue.main.async {
                
                self?.imagePronta = image
                
                self?.imageView.image = self?.imagePronta
                
                
                
                self?.button.isHidden = false
                
                // self?.recognizeText(image: image)
                
            }
            
        }
    }
}




func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
    
    let image =  scan.imageOfPage(at: 0)
    
    
    
    imageView.image = image
    imagePronta = image
    button.isHidden = false
    controller.dismiss(animated: true, completion: nil)
}
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ciao" {
            guard let destination = segue.destination as? ScannedTextTableViewController else {return}
            
            
                destination.contattoPassato = contatto
            
          
             
            
                    
            
        }
    }

}









