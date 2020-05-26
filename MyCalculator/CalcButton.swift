//
//  CalcButton.swift
//  MyCalculator
//
//  Created by marleysudbury on 23/05/2020.
//  Copyright © 2020 marleysudbury. All rights reserved.
//

import SwiftUI

struct CalcButton: View {
    @EnvironmentObject var appData: DataStoreXD
    var label: String
    var color: Int
    var width: CGFloat
    var height: CGFloat
    var foreC: Color
    var backC: Color
    var active: Bool
    
    init(label:String, color: Int, width: CGFloat, height: CGFloat, active: Bool) {
        self.label = label
        self.color = color
        self.width = width
        self.height = height
        self.active = active
        
        if color == 1 {
            self.foreC = Color("buttonText1")
            self.backC = Color("buttonBG1")
        } else if color == 2 {
            self.foreC = Color("buttonText2")
            self.backC = Color("buttonBG2")
        } else {
            self.foreC = Color("buttonText3")
            self.backC = Color("buttonBG3")
        }
    }
    
    var body: some View {
        Button(action: appendToValue) {
            Text(label)
                .font(.largeTitle)
                .foregroundColor((active ? backC: foreC))
                .multilineTextAlignment(.center)
                .frame(width: width, height: height)
                .background(active ? foreC: backC)
        }
        .clipShape(RoundedRectangle(cornerRadius: 50))
    }
    
    func appendToValue() {
        // Remove error state on button press
        appData.error = false
        
        // Determine what action to take based on label
        switch label {
        case ".":
            pressDecimal()
        case "AC":
            pressAC()
        case "C":
            pressC()
        case "+/-":
            pressToggleSign()
        case "%":
            pressPercent()
        default:
            // Dealing with numbers and operations
            if Double(label) != nil {
                pressNumber()
            } else {
                pressOperation()
            }
        }
    }
    
    func pressDecimal() {
        // Add decimal part to value
        if !appData.decimal {
            if appData.value == appData.cache {
                appData.value = "0."
            } else {
                appData.value = "\(appData.value)\(label)"
            }
            appData.decimal = true
        }
    }
    
    func pressAC() {
        // Reset all of the appData
        ChangeValue(newValue: "0", cache: true)
        
        // Reset active of buttons
        self.ResetActive()
    }
    
    func pressC() {
        // Reset only the current value
        ChangeValue(newValue: "0", cache: false)
        appData.ac = true
    }
    
    func pressToggleSign() {
        // Toggle the sign of appData.value
        // NOTE: the user can toggle 0s
        
        // In case the user presses +/- after an operation
        if appData.value == appData.cache {
            appData.value = "0"
        }
        
        // The index after the startIndex, used to strip the first char
        let afterIndex = appData.value.index(after: appData.value.startIndex)
        
        if appData.value[appData.value.startIndex] == "-" {
            // Go from - to +
            appData.value = String(appData.value[afterIndex...])
        } else {
            // Go from + to -
            appData.value = "-\(appData.value)"
        }
    }
    
    func pressPercent() {
        // Divide the current value by 100
        // NOTE: I'm not sure if this is very useful
        let qValue = Float(appData.value)
        if let fValue = qValue, fValue != 0 {
            appData.value = String(fValue/100)
        } else {
            appData.value = "0"
        }
    }
    
    func pressNumber() {
        // The button is a number
        // Switch AC -> C
        appData.ac = false
        if appData.value == appData.cache || appData.value == "0" {
            // Overwrite value with input
            appData.value = "\(label)"
            appData.decimal = false
        } else {
            // Append the number to the end of value
            appData.value = "\(appData.value)\(label)"
        }
    }
    
    func pressOperation() {
        // The button is not a number
        if label == "=" {
            // Work it out
            Equals()
        } else if appData.active[label] != nil {
            // Make the button pressed 'active'
            NewActive(is: label)
        }
    }
    
    func Equals() {
        // Turn the screen value -> double
        let qValue = Double(appData.value)
        
        // Turn the cached value -> double
        let qCache = Double(appData.cache)
        
        if let lValue = qValue, let lCache = qCache {
            // This finds the key for the active operation
            // Adapted from: https://stackoverflow.com/a/33719772
            let truth = appData.active.filter { (k, v) -> Bool in v == true }
                .map { (k, v) -> String in k }
            
            // Stores the key found above
            let operation: String
            
            // Used incase the search found none
            if truth.endIndex != 0 {
                // Unwrap the operation
                operation = truth[0]
            } else {
                // Defaults to add
                // TODO: change this to be preivous operation
                operation = "+"
            }
            
            // Stores the output of the operation
            let output: Double
            
            switch operation {
            case "+":
                // Add the numbers
                output = lCache + lValue
            case "-":
                // Subtract the numbers
                output = lCache - lValue
            case "/":
                // Divide the numbers
                
                // Handle div by 0
                if lValue == 0 {
                    appData.error = true
                    appData.ac = true
                    appData.decimal = false
                    output = 0
                } else {
                    output = lCache / lValue
                }
            case "x":
                // Times the numbers
                output = lCache * lValue
            default:
                // Defaults to outputting the screen value
                output = lValue
            }
            
            // Convert to string
            var newValue = String(output)
            
            // This is to fix decimal 'bug'
            let beforeEnd = newValue.index(before: newValue.endIndex)
            let bBeforeEnd = newValue.index(before: beforeEnd)
            if newValue[beforeEnd] == "0", newValue[bBeforeEnd] == "." {
                newValue = String(newValue[...newValue.index(before: bBeforeEnd)])
            }
            
            // Store new value
            ChangeValue(newValue: (newValue.startIndex != newValue.endIndex ? newValue : "0"), cache: true)

            // Reset active of buttons
            ResetActive()
        }
    }
    
    func NewActive(is label: String) {
        // Reset all active to false
        ResetActive()
        
        // Set specified active to true
        appData.active[label] = true
        
        // Put value in cache
        ReCache()
    }
    
    func ResetActive() {
        appData.active.keys.forEach { appData.active[$0] = false }
    }
    
    func ChangeValue(newValue: String, cache: Bool = false) {
        // Store new value in appData
        appData.value = newValue
        
        // Set decimal to true if it has decimal part
        appData.decimal = (newValue.contains(".") ? true : false)
        
        if cache {
            // Store new value in cache as well
            ReCache()
        }
    }
    
    func ReCache() {
        // Store new data in cache
        appData.cache = appData.value
    }
}

struct CalcButton_Previews: PreviewProvider {
    static let dimensions:CGFloat = 100
    static var previews: some View {
        Group {
            CalcButton(label: "1", color: 3, width: dimensions, height: dimensions, active: false)
            CalcButton(label: "%", color: 2, width: dimensions, height: dimensions, active: false)
            CalcButton(label: "+", color: 1, width: dimensions, height: dimensions, active: false)
            CalcButton(label: "+", color: 1, width: dimensions, height: dimensions, active: true)
            CalcButton(label: "0", color: 3, width: dimensions*2, height: dimensions, active: false)
            }.padding(.all).previewLayout(.sizeThatFits)
    }
}


