//
//  ContentView.swift
//  MyCalculator
//
//  Created by marleysudbury on 23/05/2020.
//  Copyright © 2020 marleysudbury. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	let buttonSize: CGFloat = 75.0
	let spacing: CGFloat = 10.0
	@EnvironmentObject var appData: DataStoreXD
    var body: some View {
		VStack{
			// Display
			CalcScreen(value: appData.value)
				.padding(.horizontal)
			Keyboard(buttonSize: buttonSize, spacing: spacing)
		}
		.background(Color("bg"))
	}
}

final class DataStoreXD: ObservableObject {
	@Published var value: String
	@Published var decimal: Bool
	@Published var cache: String
	@Published var ac: Bool
	@Published var active = [
		"+": false,
		"-": false,
		"/": false,
		"x": false
	]
	init(value: String) {
		self.value = value
		self.decimal = false
		self.cache = "0"
		self.ac = true
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView().environmentObject(DataStoreXD(value: "0"))
			.environment(\.colorScheme, .dark)
    }
}





