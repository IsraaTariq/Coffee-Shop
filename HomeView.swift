//
//  ContentView.swift
//  iCoffee
//
//  Created by David Kababyan on 05/01/2020.
//  Copyright © 2020 David Kababyan. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var drinkListener = DrinkListener()
    @State private var showingBasket = false
    
    
    var categories: [String : [Drink]] {
        
        .init(
            grouping: drinkListener.drinks,
            by: {$0.category.rawValue}
        )
    }
    
    var body: some View {
        
        NavigationView {
            

            List(categories.keys.sorted(), id: \String.self) {
                key in
                
                DrinkRow(categoryName: "\(key) Drink".uppercased(), drinks: self.categories[key]!)
                    .frame(height: 320)
                    .padding(.top)
                    .padding(.bottom)
                
            }
            
            
            
            .navigationBarTitle(Text("iCoffee"))
            .navigationBarItems(leading:
                
                Button(action: {

                    FUser.logOutCurrenUser { (error) in
                        print("error loging out user, ", error?.localizedDescription)
                    }
                }, label: {
                    Text("Log Out")
                })
                
                , trailing:
            
                Button(action: {
                    self.showingBasket.toggle()
                }, label: {
                    Image("basket")
                })
                    .sheet(isPresented: $showingBasket) {

                        if FUser.currentUser() != nil && FUser.currentUser()!.onBoarding {
                            
                            OrderBasketView()
                        } else if FUser.currentUser() != nil {
                            FinishRegistrationView()
                        } else {
                            LoginView()
                        }
                }
            
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
