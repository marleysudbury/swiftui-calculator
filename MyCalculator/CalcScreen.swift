//
//  CalcScreen.swift
//  MyCalculator
//
//  Created by marleysudbury on 23/05/2020.
//  Repo: https://github.com/marleysudbury/swiftui-calculator/
//

import SwiftUI

struct CalcScreen: View {
    // This is the 'screen' that displays the current value
    
    @EnvironmentObject var appData: DataStoreXD
    
    // This is what is returned to the screen
    var body: some View {
        // Vertical stack to allow spacer
        VStack{
            // Spacer so it stays at the bottom
            // of available space
            Spacer()
            
            // Horizontal stack to allow spacer
            HStack {
                // So the number's at the right
                Spacer()
                
                // The actual text
                Text("\((appData.error ? "ERROR" : convertNumb(toConvert: appData.value)))")
                    // I like mono ok?
                    .font(.system(size: 100, design: .monospaced))
                    
                    // Right aligned
                    .multilineTextAlignment(.trailing)
                    
                    // Color
                    .foregroundColor(Color("displayText"))
                    
                    // All on one line baby
                    .lineLimit(1)
                    
                    // Text can get smoller
                    .minimumScaleFactor(0.01)
                    
                    // Allows the user to copy
                    // TODO: Improve this it's bad
                    .onTapGesture {
                        self.copyToClipboard()
                    }
            }
        }
        .padding(.all)
        .background(Color("bg"))
    }
    
    // Function allows copying value to clipboard
    func copyToClipboard() {
        // Adapted from: https://www.hackingwithswift.com/example-code/system/how-to-copy-text-to-the-clipboard-using-uipasteboard
        let pasteboard = UIPasteboard.general
        pasteboard.string = appData.value
    }
    
    // String -> Number -> String
    // This adds the commas to the number
    func convertNumb(toConvert: String) -> String {
        // TODO: Make this more elegant, it is a bit chonky
        // TODO: Add code ref here
        
        // Converts the input to a double
        let largeNumber = Double(toConvert)!
        
        // Used to format the number
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        var formattedNumber = numberFormatter.string(from: NSNumber(value:largeNumber))!
        
        // Check if the input has a decimal
        // Useful if the user has just typed a decimal point
        if toConvert.contains(".") {
            // The index of the decimal point
            let lBound = toConvert.firstIndex(of: ".")!
            
            // The end index
            let uBound = toConvert.endIndex
            
            // Substring of the decimal part of the value
            // Includes the decimal point
            let decimalSub = toConvert[lBound..<uBound]
            
            // Doing the same thing again but for the integer part
            let lBound2 = formattedNumber.startIndex
            let uBound2: String.Index
            
            // Check if the formatted number already contains a decimal point
            if formattedNumber.contains(".") {
                // Use the index of the decimal as the upper bound
                uBound2 = formattedNumber.firstIndex(of: ".")!
            } else {
                // Use the end index as the upper bound
                uBound2 = formattedNumber.endIndex
            }
            
            // Substring of the integer part of the value
            let intSub = formattedNumber[lBound2..<uBound2]
            
            // Combine the two parts into a string
            formattedNumber = "\(intSub)\(decimalSub)"
        }
        
        // Return the stringified number
        return formattedNumber
    }
}

struct CalcScreen_Previews: PreviewProvider {
    static var previews: some View {
        CalcScreen()
            .environmentObject(DataStoreXD(value: "0"))
            .previewLayout(.fixed(width: 100, height: 70))
    }
}




