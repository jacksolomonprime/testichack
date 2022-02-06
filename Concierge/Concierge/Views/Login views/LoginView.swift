//
//  ContentView.swift
//  Concierge
//
//  Created by Jack A Solomon on 05/02/2022.
//

import SwiftUI
import CountryPicker

struct LoginView: View {
    @State private var country: Country? = Country(phoneCode: "44", isoCode: "GB")
    @State private var showCountryPicker = false
    @State private var phoneNumber: String = ""
    @FocusState private var keyboardOpen: Bool
    @ObservedObject var currentView: CurrentView
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(alignment: .leading){
                Text("Concierge")
                    .font(.system(size: 25, weight: .bold))
                    .padding(20)
                
                Text("Enter your number to get notified when you're close to home.")
                    .font(.system(size: 20))
                    .padding(.horizontal, 20)
            }
                        
            HStack{
                HStack(alignment: .center){
                    Button {
                        showCountryPicker = true
                    } label: {
                        Text("\(country!.isoCode.getFlag())")
                            .frame(width: 60, height: 60)
                    }.sheet(isPresented: $showCountryPicker) {
                        CountryPicker(country: $country)
                    }
                    
                    TextField("+\(country!.phoneCode)", text: $phoneNumber)
                        .frame(height: 60)
                        .focused($keyboardOpen)
                }.background(Color.light_gray)
                    .border(Color.highlight, width: keyboardOpen ? 4 : 0)
                .cornerRadius(7.5)
                .shadow(radius: 3)
                    .padding(20)
                
                Button {
                    let characterSet = CharacterSet(charactersIn: "+()-0123456789")
                    let result = phoneNumber.trimmingCharacters(in: characterSet.inverted)
                    UserDefaults.savePhoneNumber(number: result)
                    currentView.showLogin = false
                } label: {
                    ZStack{
                        Circle()
                            .foregroundColor(.highlight)
                        
                        Text("➠")
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                        
                    }.frame(width: 55, height: 55)
                        .padding(.trailing)
                        .shadow(radius: 3)
                }
            }
            
            Spacer()
            
            Image("train")
                .resizable()
                .scaledToFit()
                .offset(y: 40)
        }.edgesIgnoringSafeArea([.bottom])
    }
}
