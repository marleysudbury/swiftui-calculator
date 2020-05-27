//
//  CalcButton.swift
//  MyCalculator
//
//  Created by marleysudbury on 23/05/2020.
//  Repo: https://github.com/marleysudbury/swiftui-calculator/
//

import SwiftUI

struct CalcButton: View {
    @EnvironmentObject var appData: DataStoreXD
    // The character limit (not including commas)
    let charLim: Int
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
        self.charLim = 9
        
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
                ChangeValue(newValue: "0.")
            } else {
                ChangeValue(newValue: "\(appData.value)\(label)")
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
            ChangeValue(newValue: "0")
        }
        
        // The index after the startIndex, used to strip the first char
        let afterIndex = appData.value.index(after: appData.value.startIndex)
        
        if appData.value[appData.value.startIndex] == "-" {
            // Go from - to +
            ChangeValue(newValue: String(appData.value[afterIndex...]))
        } else {
            // Go from + to -
            ChangeValue(newValue: "-\(appData.value)")
        }
    }
    
    func pressPercent() {
        // Divide the current value by 100
        // NOTE: I'm not sure if this is very useful
        let qValue = Float(appData.value)
        if let fValue = qValue, fValue != 0 {
            ChangeValue(newValue: String(fValue/100))
        } else {
            ChangeValue(newValue: "0")
        }
    }
    
    func pressNumber() {
        // The button is a number
        // Switch AC -> C
        appData.ac = false
        if appData.unchanged {
            appData.unchanged = false
            // Overwrite value with input
            ChangeValue(newValue: "\(label)")
        } else {
            // Append the number to the end of value
            ChangeValue(newValue: "\(appData.value)\(label)")
        }
    }
    
    func pressOperation() {
        // The button is not a number
        appData.unchanged = true
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
                print("Here?")
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
        if newValue == "0" {
            appData.unchanged = true
        }
        // Ensure the number doesn't get too big
        if newValue.count <= charLim {
            // Store new value in appData
            appData.value = newValue
            
            // Check decimal
            if newValue.contains(".") {
                appData.decimal = true
            } else {
                appData.decimal = false
            }
        } else if newValue.count == charLim + 1 {
            print(newValue)
            print("\(newValue.count) and \(charLim)")
            // The start index
            let startIndex = newValue.startIndex
            
            // The limit index
            let ttIndex = newValue.index(startIndex, offsetBy: charLim-1)
            
            // Crop the new value
            ChangeValue(newValue: String(newValue[startIndex...ttIndex]), cache: false)
        } else {
            if label == "=" {
                ChangeValue(newValue: "0", cache: true)
                appData.error = true
                appData.ac = true
                appData.value = "0"
                appData.cache = "0"
            } else {
                print("Round up old chap!")
            }
        }
        
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




