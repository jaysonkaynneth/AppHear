//
//  ContentView.swift
//  AppHear
//
//  Created by Jason Kenneth on 11/10/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        NavigationView {
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
                    NavigationLink(destination: LibraryView() .navigationBarHidden(true)   
                        .navigationBarTitle("") ) {
                        ZStack(){
                            Rectangle().foregroundColor(.white).frame(width: 165, height: 142).cornerRadius(20, antialiased: true).shadow(color: Color(cgColor: .buttonShadow), radius: 5.0).overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color(cgColor: .buttonBorder), lineWidth: 2)).padding(.leading, 40)
                            
                            VStack(alignment: .leading){
                                Image("recordings-icon").resizable().frame(width: 39, height: 44, alignment: .leading).padding(.bottom, 16)
                                Text("All Recordings").font(.custom("Nunito-Bold", size: 15)).foregroundColor(Color(cgColor: .appHearBlue))
                                Text("3 Recordings").font(.custom("Nunito-Regular", size: 12)).foregroundColor(Color(cgColor: .appHearBlue))
                            }.padding(.leading, 15)
                        }.frame(width: 165, height: 142)
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: LibraryView()
                        .navigationBarHidden(true)
                        .navigationBarTitle("")) {
                        ZStack(){
                            Rectangle().foregroundColor(.white).frame(width: 165, height: 142).cornerRadius(20, antialiased: true).shadow(color: Color(cgColor: .buttonShadow), radius: 5.0).overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color(cgColor: .buttonBorder), lineWidth: 2)).padding(.trailing, 40)
                            
                            VStack(alignment: .leading){
                                Image("delete-icon").resizable().frame(width: 39, height: 44, alignment: .leading).padding(.bottom, 16)
                                Text("Recently Deleted").font(.custom("Nunito-Bold", size: 15)).foregroundColor(Color(cgColor: .appHearBlue))
                                Text("2 Recordings").font(.custom("Nunito-Regular", size: 12)).foregroundColor(Color(cgColor: .appHearBlue))
                            }.padding(.trailing,40)
                        }.frame(width: 165, height: 142)
                    }
                }.offset(y: -130)
                
                
                HStack(alignment: .top) {
                    Button(action: viewModel.createFolder) {
                        ZStack(){
                            Rectangle().fill(LinearGradient(gradient: Gradient(colors: [Color(cgColor: .gradient1), Color(cgColor: .gradient2)]), startPoint: .bottomLeading, endPoint: .topTrailing)).frame(width: 165, height: 142).cornerRadius(20, antialiased: true).shadow(color: Color(cgColor: .buttonShadow), radius: 5.0).overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color(cgColor: .buttonBorder), lineWidth: 2)).padding(.leading, 40)
                            
                            VStack(alignment: .center){
                                Image("new-folder-icon").resizable().frame(width: 44, height: 37, alignment: .leading).padding(.bottom, 16)
                                Text("Create New Folder").font(.custom("Nunito-Bold", size: 15)).foregroundColor(.white)
                            }.padding(.leading, 40)
                        }.frame(width: 165, height: 142)
                    }
                    
                    Spacer()
                    
                }.offset(y: -120)
                
                Spacer()
                
                    ZStack {
                        Image("bottom-bar").resizable().frame(width: 390, height: 144, alignment: .center).offset(y: 4)
                        NavigationLink {
                            RecordView()
                                .navigationBarHidden(true)
                                .navigationBarTitle("")
                        } label: {
                            Image("record").resizable().frame(width: 84, height: 84, alignment: .center)
                        }

                        
//                        Image("bottom-bar").resizable().frame(width: 390, height: 144, alignment: .center).offset(y: 4)
//                        Button(action: viewModel.startRecording) {
//                            Image("record").resizable().frame(width: 84, height: 84, alignment: .center)
//                        }
                        
                    }
            }.ignoresSafeArea().background(Color(cgColor: .screenColor))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ContentViewModel())
//            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
