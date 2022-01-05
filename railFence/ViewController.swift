//
//  ViewController.swift
//  railFence
//
//  Created by Rahaf Naif on 29/02/1442 AH.
//

import UIKit


class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var keyField: UITextField!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var outputLable: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "back.jpg")!)
        keyField.delegate = self
        textField.delegate = self

    }
    
    
    @IBAction func encrypt(_ sender: Any) {
        
        guard keyField.text != "" ,  textField.text != "" else {
            showFailure(title:"Error",message: "please fill out all the text fields")
            return
        } //user input validtion
       
        let key = Int(self.keyField.text!)
        var plainText = textField.text?.removeWhitespace()
        
    
        outputLable.text = ""+encrypt(plainText: plainText!, key: key!).joined()
        outputLable.textAlignment = .center
        outputLable.isHidden = false
        
    }
    
    func encrypt(plainText:String,key:Int)->[String] {
        
        var matrix = [[String]](repeating: [String](repeating: " ", count: plainText.count), count: key) //matrix in 2D array with initial values -white spaces-
        var done = true  //flag for test filling the matrix (zig-zag)
        var row = 0
        
        //looping the plainText in range from 0 to length -1
        for i in 0..<plainText.count {
            matrix[row][i] = ""+String(plainText[i]) //filling the matrix
            if (row==0){
                done = false  //not fill yet
            }else if(row==key-1){
                done = true  // we are done
            }
            
            if(!done){
                row+=1  //not fill yet
            }else{
                row-=1  //done
            }
        }
        var cipherText = [String]()
        for i in 0..<key {
            for j in 0..<plainText.count {
                if (matrix[i][j] != " "){   //i stands for row and j for coulmn
                    cipherText.append(matrix[i][j]) //once the index have character(not empty space) add it to ciphertext
                }
            }
          
        }
        return cipherText
    }
    
    @IBAction func decrypt(_ sender: Any) {
        
        guard keyField.text != "" ,  textField.text != "" else {
            showFailure(title:"Error",message: "please fill out all the text fields")
            return
        } //user input validtion
        
        let dkey = Int(self.keyField.text!)
        var cipherText = textField.text?.removeWhitespace()
        
        outputLable.text = ""+decrypt(cipherText: cipherText!, dkey: dkey!).joined()
        outputLable.textAlignment = .center
        outputLable.isHidden = false
        
    }
    
    func decrypt(cipherText:String,dkey:Int)->[String]{
        
        var dMatrix = [[String]](repeating: [String](repeating: " ", count: cipherText.count), count: dkey)
        var done = true
        var row = 0

        for i in 0..<cipherText.count {
             dMatrix[row][i]="*"  //filling matrix with stars in zig-zag form to switch it with cipher characters
             if(row==0){
                 done = false
             }else if(row==dkey-1){
                 done = true
             }
             if(!done){
                 row+=1
             }else{
                 row-=1
             }
         }
             var index=0
        for i in 0..<dkey {
            for j in 0..<cipherText.count {
                if((dMatrix[i][j]=="*")&&(index<cipherText.count)){ //switch star with character
                    dMatrix[i][j]=""+String(cipherText[index])
                         index+=1
                 }
             }
         }
         
         var plainText = [String]()
         row=0
         //to take the characters form matrix in zig-zag form
        for i in 0..<cipherText.count {
                 if(dMatrix[row][i] != "*"){
                     plainText.append(dMatrix[row][i])
                 }
                 if(row==0){
                     done = false
                 }else if(row==dkey-1){
                     done = true
                 }
                 if(!done){
                     row+=1
                 }else{
                     row-=1
                 }
             }
        return plainText
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }// for return keyboard
    
    func showFailure(title:String,message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: false, completion:nil)
    }// error message failure
    

}

extension String {//helper methods
    subscript(idx: Int) -> String {
        String(self[index(startIndex, offsetBy: idx)])
    }// spearte string into characters
    
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }// to shift string to delete whitespaces

    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }//remove whitespaces
      
}
