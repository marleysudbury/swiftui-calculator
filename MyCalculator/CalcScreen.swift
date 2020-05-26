//
//  CalcScreen.swift
//  MyCalculator
//
//  Created by marleysudbury on 23/05/2020.
//  Copyright © 2020 marleysudbury. All rights reserved.
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
        // TODO: Add code ref here
        let largeNumber = Double(toConvert)!
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        var formattedNumber = numberFormatter.string(from: NSNumber(value:largeNumber))!
        if toConvert.contains(".") {
            let lBound = toConvert.firstIndex(of: ".")!
            let uBound = toConvert.endIndex
            let decimalSub = toConvert[lBound..<uBound]
            let lBound2 = formattedNumber.startIndex
            let uBound2: String.Index
            if formattedNumber.contains(".") {
                uBound2 = formattedNumber.firstIndex(of: ".")!
            } else {
                uBound2 = formattedNumber.endIndex
            }
            let intSub = formattedNumber[lBound2..<uBound2]
            formattedNumber = "\(intSub)\(decimalSub)"
        }
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




