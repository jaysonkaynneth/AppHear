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
//    @State private var overlay = false
    @State var overlay = false
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var files: FetchedResults<File>
    @State var recordAmount = 0
    @State var deletedAmount = 0
    @State var isPresented = false
    
    var body: some View {
        NavigationView {
            ZStack {
                
                VStack{
                    ZStack{
                        
                        Image("home-nav-bar").resizable().scaledToFit()
                        
                        HStack{
                            ZStack {
                                Rectangle().foregroundColor(.white).opacity(0.5).frame(width: 330, height: 39).cornerRadius(19.5, antialiased: true)
                                
                                HStack{
                                    Image(systemName: "magnifyingglass").foregroundColor(.white).padding(.leading, 40)
                                    Text("Search Folder").font(.custom("Nunito-Regular", size: 15)).foregroundColor(.white)
                                    
                                    Spacer()
                                }
                            }
//                            Image(" ").resizable().frame(width: 22.53, height: 28.53).padding(.trailing)
                        }.onAppear(perform: initiateIndexCounter).onAppear(perform: countRecord)
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
                                        Text("\(recordAmount) Recordings").font(.custom("Nunito-Regular", size: 12)).foregroundColor(Color(cgColor: .appHearBlue))
                                    }.padding(.leading, 15)
                                }.frame(width: 165, height: 142)
                            }
                        
                        Spacer()
                        
                        NavigationLink(destination: DeletedView()
                            .navigationBarHidden(true)
                            .navigationBarTitle("")) {
                                ZStack(){
                                    Rectangle().foregroundColor(.white).frame(width: 165, height: 142).cornerRadius(20, antialiased: true).shadow(color: Color(cgColor: .buttonShadow), radius: 5.0).overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color(cgColor: .buttonBorder), lineWidth: 2)).padding(.trailing, 40)
                                    
                                    VStack(alignment: .leading){
                                        Image("delete-icon").resizable().frame(width: 39, height: 44, alignment: .leading).padding(.bottom, 16)
                                        Text("Recently Deleted").font(.custom("Nunito-Bold", size: 15)).foregroundColor(Color(cgColor: .appHearBlue))
                                        Text("\(deletedAmount) Recordings").font(.custom("Nunito-Regular", size: 12)).foregroundColor(Color(cgColor: .appHearBlue))
                                    }.padding(.trailing,40)
                                }.frame(width: 165, height: 142)
                            }
                    }.offset(y: -130)
                    
                    
                    HStack(alignment: .top) {
                        Button(action: viewModel.createFolder) {
                            ZStack{
                                
                                Rectangle().fill(LinearGradient(gradient: Gradient(colors: [Color(cgColor: .gradient1), Color(cgColor: .gradient2)]), startPoint: .bottomLeading, endPoint: .topTrailing)).frame(width: 165, height: 142).cornerRadius(20, antialiased: true).shadow(color: Color(cgColor: .buttonShadow), radius: 5.0).overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color(cgColor: .buttonBorder), lineWidth: 2)).padding(.leading, 40)
                                
                            
                                
                                VStack(alignment: .center){
                                    Image("new-folder-icon")
                                        .resizable().frame(width: 44, height: 37, alignment: .leading).padding(.bottom, 16)
                                      
                                    Text("Create New Folder").font(.custom("Nunito-Bold", size: 15)).foregroundColor(.white)
                                        
                                }.padding(.leading, 40)
                                
                                
                            }.frame(width: 165, height: 142)      .onTapGesture {
                                isPresented.toggle()
                            }  .sheet(isPresented: $isPresented, content: NewFolderModalView.init)
                        }
                        
                        Spacer()
                        
                    }.offset(y: -120)
                        
//                    List{
//                        ForEach(files) { files in
//                            HStack{
//                                Text(files.transcript ?? "no transcript")
//                                
//                                Text(files.audio ?? "no url")
//                                
//                                Text(files.title ?? "no title")
//
//                            }
//                                .onTapGesture {
//                                    print("Tapped cell")
//                                }
//                        }.onDelete(perform: deleteItems)
//                    }
                    Spacer()
                        
                        ZStack {
                            Image("bottom-bar").resizable().scaledToFit()
                            
                                Button {
                                    overlay.toggle()
                                } label: {
                                    Image("record").resizable().frame(width: 84, height: 84, alignment: .center)
                                }
                        }
                    
                }.ignoresSafeArea().background(Color(cgColor: .screenColor))
            }.overlay(secretOverlay)
        }.preferredColorScheme(.light)
         
    }
    
    
    @ViewBuilder private var secretOverlay: some View {
        ZStack{
            if overlay {
                OverlayView().onTapGesture {
                    overlay.toggle()
                }
                
            }
        }
    }
    
    private func initiateIndexCounter(){
        let temp = UserDefaults.standard.integer(forKey: "index")
        if temp == nil{
            UserDefaults.standard.set(0, forKey: "index")
        }
    }
    
    private func countRecord(){
        if files.count != 0{
            let count = 0...(files.count-1)
            var delTemp = 0
            var recTemp = 0
            for number in count {
                if files[number].isdeleted == true{
                    delTemp += 1
                }
                else if files[number].isdeleted == false{
                    recTemp += 1
                }
            }
            deletedAmount = delTemp
            recordAmount = recTemp
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { files[$0] }.forEach(moc.delete)

            do {
                try moc.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ContentViewModel())
        //            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


//NavigationLink {
//    RecordView()
//        .navigationBarHidden(true)
//        .navigationBarTitle("")
//} label: {
//    Image("record").resizable().frame(width: 84, height: 84, alignment: .center)
//}



