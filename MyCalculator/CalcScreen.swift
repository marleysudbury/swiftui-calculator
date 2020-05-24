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
	var value: String // The value displayed as a string
    var body: some View {
		VStack{
			Spacer()
			HStack {
				// So the number's at the bottom
				Spacer()
				Text("\(convertNumb(toConvert: value))")
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
					.onTapGesture {
						self.copyToClipboard()
					}
			}
		}
		.padding(.all)
		.background(Color("bg"))
    }
	
	func copyToClipboard() {
		let pasteboard = UIPasteboard.general
		pasteboard.string = value
	}
	
	func convertNumb(toConvert: String) -> String {
		let largeNumber = Float(toConvert)!
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
		CalcScreen(value: "10000")
			.previewLayout(.fixed(width: 100, height: 70))
    }
}




