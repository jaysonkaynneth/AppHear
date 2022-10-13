//
//  ContentView.swift
//  AppHear
//
//  Created by Jason Kenneth on 11/10/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    
    var body: some View {
        VStack{
            ZStack{
                Image("home-nav-bar").resizable().scaledToFit()
                            
                HStack{
                    ZStack {
                        Rectangle().foregroundColor(.white).opacity(0.5).frame(width: 302, height: 39).cornerRadius(19.5, antialiased: true)
                        
                        HStack{
                            Image(systemName: "magnifyingglass").foregroundColor(.white).padding(.leading, 40)
                            Text("Search Folder").font(.custom("Nunito-Regular", size: 15)).foregroundColor(.white)
                            
                            Spacer()
                        }
                    }
                    Image("no-device").resizable().frame(width: 22.53, height: 28.53).padding(.trailing)
                    }
            }
            
            Spacer()
            
            HStack(alignment: .top) {
                ZStack(){
                    Rectangle().foregroundColor(.white).frame(width: 165, height: 142).cornerRadius(20, antialiased: true).shadow(color: Color(cgColor: .buttonShadow), radius: 5.0).overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(cgColor: .buttonBorder), lineWidth: 2)).padding(.leading, 50)
                    
                    VStack{
                        Image("recordings-icon").resizable().frame(width: 40, height: 45, alignment: .leading)
                    }
                }.frame(width: 165, height: 142)
                
                Spacer()
                
                ZStack(){
                    Rectangle().foregroundColor(.white).frame(width: 165, height: 142).cornerRadius(20, antialiased: true).shadow(color: Color(cgColor: .buttonShadow), radius: 5.0).overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(cgColor: .buttonBorder), lineWidth: 2)).padding(.trailing, 20)
                }
            }
            
            Spacer()
            Spacer()
            
        }.ignoresSafeArea().background(Color(cgColor: .screenColor))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
