//
//  ViewController.swift
//  retro-calc
//
//  Created by Liam Nickell on 6/28/16.
//  Copyright © 2016 Liam Nickell. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Add = "+"
        case Sub = "-"
        case Empty = ""
    }
    
    @IBOutlet weak var outputLbl: UILabel!
    @IBOutlet weak var clearBtn: UIButton!
    
    var btnSound: AVAudioPlayer!
    var runningNum = "0"
    var leftValStr = ""
    var rightValStr = ""
    var currentOperation: Operation = Operation.Empty
    var result = ""
    var numEntered = false
    
    let divideByZeroError = UIAlertController(title: "Invalid Equation", message: "Cannot divide by zero.", preferredStyle: UIAlertControllerStyle.alert)
    let unknownError = UIAlertController(title: "Unknown Error", message: "An unknown error has occured.", preferredStyle: UIAlertControllerStyle.alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        divideByZeroError.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        unknownError.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        
        clearBtn.isHidden = true
        outputLbl.text = runningNum
        
        let path = Bundle.main.path(forResource: "btn", ofType: "wav")
        let soundUrl = URL(fileURLWithPath: path!)
        
        do {
            try btnSound = AVAudioPlayer(contentsOf: soundUrl)
            btnSound.prepareToPlay()
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    @IBAction func btnPressed(_ sender: UIButton!){
        playSound()
        clearBtn.isHidden = false
        
        if runningNum != "0" {
            runningNum += "\(sender.tag)"
            outputLbl.text = runningNum
            numEntered = true
        } else {
            runningNum = "\(sender.tag)"
            outputLbl.text = runningNum
            numEntered = true
        }
    }
    
    @IBAction func clearBtnPressed(){
        playSound()
        resetCalc()
    }

    @IBAction func onDividePressed(_ sender: AnyObject){
        processOperation(Operation.Divide)
    }
    
    @IBAction func onMultiplyPressed(_ sender: AnyObject){
        processOperation(Operation.Multiply)
    }
    
    @IBAction func onAddPressed(_ sender: AnyObject){
        processOperation(Operation.Add)
    }
    
    @IBAction func onSubPressed(_ sender: AnyObject){
        processOperation(Operation.Sub)
    }
    
    @IBAction func onEqualPressed(_ sender: AnyObject){
        processOperation(currentOperation)
    }
    
    func processOperation(_ op: Operation){
        playSound()
        clearBtn.isHidden = false
        
        if currentOperation != Operation.Empty {
            //run math
            if runningNum != "" {
                rightValStr = runningNum
                runningNum = ""
            
                if currentOperation != Operation.Divide || rightValStr != "0" {
                    switch currentOperation {
                    case Operation.Add:
                        result = "\(Double(leftValStr)! + Double(rightValStr)!)"
                    case Operation.Sub:
                        result = "\(Double(leftValStr)! - Double(rightValStr)!)"
                    case Operation.Multiply:
                        result = "\(Double(leftValStr)! * Double(rightValStr)!)"
                    case Operation.Divide:
                        result = "\(Double(leftValStr)! / Double(rightValStr)!)"
                    default:
                        self.present(unknownError, animated: true, completion: nil)
                    }
                
                    outputLbl.text = result
                    leftValStr = result
                } else {
                    self.present(divideByZeroError, animated: true, completion: nil)
                    resetCalc()
                }
            }
            
            currentOperation = op
        } else {
            //first time operator is pressed
            leftValStr = runningNum
            runningNum = ""
            currentOperation = op
        }
    }

    func playSound(){
        if btnSound.isPlaying {
            btnSound.stop()
        }
        
        btnSound.play()
    }
    
    func resetCalc() {
        runningNum = "0"
        outputLbl.text = runningNum
        leftValStr = ""
        rightValStr = ""
        currentOperation = Operation.Empty
        result = ""
        numEntered = false
        clearBtn.isHidden = true
    }
}
