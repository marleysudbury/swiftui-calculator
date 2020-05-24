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
		if label == "." {
			// Add decimal part to value
			if !appData.decimal {
				appData.decimal = true
				appData.value = "\(appData.value)\(label)"
			}
		} else if label == "AC" {
			// Reset all of the appData
			ChangeValue(newValue: "0", cache: true)
			
			// Reset active of buttons
			self.ResetActive()
		} else if label == "C" {
			// Reset only the current value
			ChangeValue(newValue: "0", cache: false)
			appData.ac = true
		} else {
			// Dealing with numbers and operations
			if (Int(label) != nil) {
				// The button is a number
				// Switch AC -> C
				appData.ac = false
				if appData.value == appData.cache {
					// Overwrite value with input
					appData.value = "\(label)"
				} else {
					// Append the number to the end of value
					appData.value = "\(appData.value)\(label)"
				}
			} else {
				// The button is not a number
				if label == "=" {
					// Work it out
					Equals()
				} else if appData.active[label] != nil {
					// Make the button pressed 'active'
					NewActive(is: label)
				}
			}
		}
	}
	
	func Equals() {
		// Turn the screen value -> float
		let lValue = Float(appData.value)!
		
		// Turn the cached value -> float
		let lCache = Float(appData.cache)!
		
		// This will be used to convert back to sting
		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .decimal
		
		// This finds the key for the active operation
		// https://stackoverflow.com/a/33719772
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
			operation = "+"
		}
		
		// Stores the output of the operation
		let output: Float
		
		switch operation {
		case "+":
			// Add the numbers
			output = lCache + lValue
		case "-":
			// Subtract the numbers
			output = lCache - lValue
		case "/":
			// Divide the numbers
			output = lCache / lValue
		case "x":
			// Times the numbers
			output = lCache * lValue
		default:
			// Defaults to outputting the screen value
			output = lValue
		}
		
		// Convert to string
		let newValue = numberFormatter.string(from: NSNumber(value:output))!
		
		// Store new value
		ChangeValue(newValue: newValue, cache: true)
		
		// Reset active of buttons
		ResetActive()
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
		appData.decimal = (appData.value.contains(".") ? true : false)
		
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

