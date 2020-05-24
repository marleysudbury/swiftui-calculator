//
//  Keyboard.swift
//  MyCalculator
//
//  Created by marleysudbury on 23/05/2020.
//  Copyright © 2020 marleysudbury. All rights reserved.
//

import SwiftUI

struct Keyboard: View {
	@EnvironmentObject var appData: DataStoreXD
	var buttonSize: CGFloat
	var spacing: CGFloat
	let buttons = [
		("AC", 2),
		("+/-", 2),
		("%", 2),
		("/", 1),
		("7", 3),
		("8", 3),
		("9", 3),
		("x", 1),
		("4", 3),
		("5", 3),
		("6", 3),
		("-", 1),
		("1", 3),
		("2", 3),
		("3", 3),
		("+", 1),
		("0", 3),
		(".", 3),
		("=", 1)
	]
    var body: some View {
		VStack(spacing: self.spacing) {
			// Buttons
			ForEach(0..<5, id: \.self) { row in
				HStack(spacing: self.spacing) {
					if row == 4 {
						self.ShowButtons(row: row, howFar: 3)
					} else {
						self.ShowButtons(row: row, howFar: 4)
					}
				}.padding(0)
			}
		}.padding(.bottom)
    }
	
	func ShowButtons(row: Int, howFar: Int) -> some View {
		ForEach(self.buttons[(row*4)..<(row*4)+howFar], id: \.self.0) { button in
			HStack {
				if button.0 == "0" {
					CalcButton(label: button.0, color: button.1, width: self.buttonSize*2+self.spacing, height: self.buttonSize, active: false)
				} else if button.0 == "AC" {
					CalcButton(label: (self.appData.ac ? "AC" : "C"), color: button.1, width: self.buttonSize, height: self.buttonSize, active: false)
				} else {
					CalcButton(label: button.0, color: button.1, width: self.buttonSize, height: self.buttonSize, active: self.appData.active[button.0] ?? false)
				}
			}
		}
	}
}

struct Keyboard_Previews: PreviewProvider {
    static var previews: some View {
		Keyboard(buttonSize: 60, spacing: 10)
			.previewLayout(.fixed(width: 300, height: 400))
    }
}
