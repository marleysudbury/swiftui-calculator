//
//  Keyboard.swift
//  MyCalculator
//
//  Created by marleysudbury on 23/05/2020.
//  Repo: https://github.com/marleysudbury/swiftui-calculator/
//

import SwiftUI

struct Keyboard: View {
    // Global data store
    @EnvironmentObject var appData: DataStoreXD
    
    // The size of the buttons
    var buttonSize: CGFloat
    
    // The spacing between buttons
    var spacing: CGFloat
    
    // Array of tuples describing the label and colour scheme for each button
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
    
    // This is what is returned to the screen
    var body: some View {
        VStack(spacing: self.spacing) {
            // Create/display the buttons
            ForEach(0..<5, id: \.self) { row in
                // For each row of the keyboard, create a HStack
                // containing the buttons of that row
                HStack(spacing: self.spacing) {
                    if row == 4 {
                        // Row 4 only has 3 buttons because the '0' is twice as long
                        self.ShowButtons(row: row, howFar: 3)
                    } else {
                        self.ShowButtons(row: row, howFar: 4)
                    }
                }.padding(0)
            }
        }.padding(.bottom)
    }
    
    // Display the buttons of the given row
    func ShowButtons(row: Int, howFar: Int) -> some View {
        ForEach(self.buttons[(row*4)..<(row*4)+howFar], id: \.self.0) { button in
            HStack {
                if button.0 == "0" {
                    // As mentioned before, '0' is twice as long
                    CalcButton(label: button.0, color: button.1, width: self.buttonSize*2+self.spacing, height: self.buttonSize, active: false)
                } else if button.0 == "AC" {
                    // AC or C depends on appData.ac
                    CalcButton(label: (self.appData.ac ? "AC" : "C"), color: button.1, width: self.buttonSize, height: self.buttonSize, active: false)
                } else {
                    // Every other button
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
