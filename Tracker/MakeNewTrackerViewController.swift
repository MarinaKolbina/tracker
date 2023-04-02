//
//  MakeNewTrackerViewController.swift
//  Tracker
//
//  Created by Marina Kolbina on 01/04/2023.
//

import Foundation
import UIKit
import SwiftUI

struct ContentView01: View {
    
    @State var showView = false
    
    var body: some View {
        
        ZStack {
//            Color.green.ignoresSafeArea()
//
            Button {
                showView.toggle()
            } label: {
                Text("Present Screen")
                    .font(.callout)
                    .padding()
                    .padding(.horizontal)
            }
            .buttonStyle(.automatic)
       
            .sheet(isPresented: $showView) {
                SecondView()
            }
        }
    }
}

struct SecondView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            
//            Color.orange
//                .ignoresSafeArea()
            
            VStack {
                Button {
                  presentationMode.wrappedValue.dismiss()

                } label: {
                    Image(systemName: "x.circle")
                        .foregroundColor(.black)
                        .font(.largeTitle)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .trailing)
                Spacer()
            }
            
            Text("This is the second one")
                .font(.callout)
        }
    }
}
