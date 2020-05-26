//
//  ContentView.swift
//  MyCalculator
//
//  Created by marleysudbury on 23/05/2020.
//  Repo: https://github.com/marleysudbury/swiftui-calculator/
//

import SwiftUI

struct ContentView: View {
    // The size of the buttons
    let buttonSize: CGFloat = 75.0
    
    // The spacing between buttons
    let spacing: CGFloat = 10.0
    
    // Global data store
    @EnvironmentObject var appData: DataStoreXD
    
    // This is what is shown on screen
    var body: some View {
        VStack{
            // The 'screen'
            CalcScreen()
                .padding(.horizontal)
            
            // The keyboard
            Keyboard(buttonSize: buttonSize, spacing: spacing)
        }
        // Use the background colour defined in Colos.xcassets
        .background(Color("bg"))
    }
}

// Global data store
final class DataStoreXD: ObservableObject {
    // The value displayed on the screen
    @Published var value: String
    
    // Whether there is a decimal point in the value
    @Published var decimal: Bool
    
    // Cached version of the value
    @Published var cache: String
    
    // Whether the clear button is AC (true) or C (false)
    @Published var ac: Bool
    
    // Whether 'ERROR' should be displayed on screen
    @Published var error: Bool
    
    // Which, if any, of the operation buttons is active
    @Published var active = [
        "+": false,
        "-": false,
        "/": false,
        "x": false
    ]
    
    // Initialise the values
    init(value: String) {
        self.value = value
        self.decimal = false
        self.cache = "0"
        self.ac = true
        self.error = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(DataStoreXD(value: "0"))
            .environment(\.colorScheme, .dark)
    }
}

