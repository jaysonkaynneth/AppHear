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
    @FetchRequest(sortDescriptors: []) var folders: FetchedResults<RecordFolder>
    @State var selectedFolder : RecordFolder?
    @State private var showFolderView = false
    @State var recordAmount = 0
    @State var deletedAmount = 0
    @State var isPresented = false
    @State var recordButton = false
    @AppStorage("showOnBoarding") private var showOnBoarding = true
    @State var searchText : String = ""
    //    @State private var showOnBoarding = true
    
    var body: some View {
        NavigationView {
            ZStack {
                
                VStack{
                    ZStack{
                        Image("home-nav-bar").resizable().scaledToFit()
                        HStack{
                            ZStack {
                                SearchBarView(searchText: $searchText)
                            }.padding()
                        }.onAppear(perform: initiateIndexCounter).onAppear(perform: countRecord)
                    }
                    
                    Spacer()
                    
                    ZStack {
                        ScrollView {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2)) {
                                
                                if searchText.isEmpty{
                                    
                                    NavigationLink(destination: LibraryView() .navigationBarHidden(true)
                                        .navigationBarTitle("") ) {
                                            ZStack(){
                                                Rectangle().foregroundColor(.white).frame(width: 165, height: 142).cornerRadius(20, antialiased: true).shadow(color: Color(cgColor: .buttonShadow), radius: 5.0).overlay(
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .stroke(Color(cgColor: .buttonBorder), lineWidth: 2))
                                                
                                                VStack(alignment: .leading) {
                                                    Image("recordings-icon").resizable().frame(width: 39, height: 44, alignment: .leading).padding(.bottom, 16)
                                                    Text("Semua Rekaman").font(.custom("Nunito-Bold", size: 15)).foregroundColor(Color(cgColor: .appHearBlue))
                                                    Text("\(recordAmount) Rekaman").font(.custom("Nunito-Regular", size: 12)).foregroundColor(Color(cgColor: .appHearBlue))
                                                }.padding(.trailing)
                                            }.frame(width: 165, height: 142)
                                        }.padding(.bottom, 4)
                                    
                                    Button(action: viewModel.createFolder) {
                                        ZStack{
                                            Rectangle().fill(LinearGradient(gradient: Gradient(colors: [Color(cgColor: .gradient1), Color(cgColor: .gradient2)]), startPoint: .bottomLeading, endPoint: .topTrailing)).frame(width: 165, height: 142).cornerRadius(20, antialiased: true).shadow(color: Color(cgColor: .buttonShadow), radius: 5.0).overlay(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(Color(cgColor: .buttonBorder), lineWidth: 2))
                                            VStack(alignment: .center){
                                                Image("new-folder-icon")
                                                    .resizable().frame(width: 44, height: 37, alignment: .leading).padding(.bottom, 16)
                                                Text("Buat Folder Baru").font(.custom("Nunito-Bold", size: 15)).foregroundColor(.white)
                                            }
                                        }.frame(width: 165, height: 142)      .onTapGesture {
                                            isPresented.toggle()
                                        }  .sheet(isPresented: $isPresented, content: NewFolderModalView.init)
                                    }
                                    
                                    ForEach(folders) { folders in
                                        Button {
                                            folderSelected(folder: folders)
                                            showFolderView.toggle()
                                        } label: {
                                            ZStack{
                                                Rectangle().foregroundColor(.white).frame(width: 165, height: 142).cornerRadius(20, antialiased: true).shadow(color: Color(cgColor: .buttonShadow), radius: 5.0).overlay(
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .stroke(Color(cgColor: .buttonBorder), lineWidth: 2))
                                                
                                                VStack(alignment: .leading){
                                                    if folders.emoji == "placeholder-emoji"{
                                                        Image("placeholder-emoji")
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: 60, height: 60, alignment: .leading)
                                                            .padding(.bottom, 16)
                                                            .offset(y: 8)
                                                    }
                                                    else{
                                                        Text(folders.emoji!)
                                                            .font(.system(size: 46))
                                                            .scaledToFit()
                                                            .frame(width: 50, height: 50, alignment: .leading)
                                                            .padding(.bottom, 16)
                                                    }
                                                    Text(folders.title!).font(.custom("Nunito-Bold", size: 15)).foregroundColor(Color(cgColor: .appHearBlue))
                                                    Text("\(folders.count) Rekaman").font(.custom("Nunito-Regular", size: 12)).foregroundColor(Color(cgColor: .appHearBlue))
                                                }.padding(.trailing, 50)
                                            }
                                        }
                                    }
                                    
                                    NavigationLink(destination: DeletedView()
                                        .navigationBarHidden(true)
                                        .navigationBarTitle("")) {
                                            ZStack(){
                                                Rectangle().foregroundColor(.white).frame(width: 165, height: 142).cornerRadius(20, antialiased: true).shadow(color: Color(cgColor: .buttonShadow), radius: 5.0).overlay(
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .stroke(Color(cgColor: .buttonBorder), lineWidth: 2))
                                                
                                                VStack(alignment: .leading){
                                                    Image("delete-icon").resizable().frame(width: 39, height: 44, alignment: .leading).padding(.bottom, 16)
                                                    Text("Baru Dihapus").font(.custom("Nunito-Bold", size: 15)).foregroundColor(Color(cgColor: .appHearBlue))
                                                    Text("\(deletedAmount) Rekaman").font(.custom("Nunito-Regular", size: 12)).foregroundColor(Color(cgColor: .appHearBlue))
                                                }
                                            }.frame(width: 165, height: 142)
                                        }.padding(.bottom, 4)
                                    
                                }
                                
                                else{
                                    ForEach(folders) { folders in
                                        let loweredText = searchText.lowercased()
                                        let loweredTitle = folders.title!.lowercased()
                                        if loweredTitle.contains(loweredText){
                                            Button {
                                                folderSelected(folder: folders)
                                                showFolderView.toggle()
                                            } label: {
                                                ZStack{
                                                    Rectangle().foregroundColor(.white).frame(width: 165, height: 142).cornerRadius(20, antialiased: true).shadow(color: Color(cgColor: .buttonShadow), radius: 5.0).overlay(
                                                        RoundedRectangle(cornerRadius: 20)
                                                            .stroke(Color(cgColor: .buttonBorder), lineWidth: 2))
                                                    
                                                    VStack(alignment: .leading){
                                                        if folders.emoji == "placeholder-emoji"{
                                                            Image("placeholder-emoji")
                                                                .resizable()
                                                                .scaledToFit()
                                                                .frame(width: 60, height: 60, alignment: .leading)
                                                                .padding(.bottom, 16)
                                                                .offset(y: 8)
                                                        }
                                                        else{
                                                            Text(folders.emoji!)
                                                                .font(.system(size: 46))
                                                                .scaledToFit()
                                                                .frame(width: 50, height: 50, alignment: .leading)
                                                                .padding(.bottom, 16)
                                                        }
                                                        Text(folders.title!).font(.custom("Nunito-Bold", size: 15)).foregroundColor(Color(cgColor: .appHearBlue))
                                                        Text("\(folders.count) Rekaman").font(.custom("Nunito-Regular", size: 12)).foregroundColor(Color(cgColor: .appHearBlue))
                                                    }.padding(.trailing, 50)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                if !folders.isEmpty {
                                    NavigationLink("", destination:  FolderView(passedFolder: selectedFolder ?? folders[0]), isActive: $showFolderView)
                                }
                                
                            }.padding(.top, 6)
                            
                        }.frame(width: 360).offset(y: -20)
                        
                        Spacer()
                        VStack{
                            Spacer()
                            ZStack {
                                
                                
                                Image("bottom-bar").resizable().scaledToFit()
                                
                                Button {
                                    overlay.toggle()
                                    recordButton = true
                                } label: {
                                    Image("record")
                                        .resizable()
                                        .frame(width: 84, height: 84, alignment: .center)
                                        
                                }
                                .padding(.bottom, 5)
                                .padding(.leading, 0.5)
//                                .fullScreenCover(isPresented: $recordButton, content: RecordView.init)
                                
                                
                            }
                        }
                    }
                    
                }.ignoresSafeArea().background(Color(cgColor: .screenColor))
            }.overlay(secretOverlay)
        }
        .preferredColorScheme(.light)
        .fullScreenCover(isPresented: $showOnBoarding, content: {
            OnBoardingView(showOnBoarding: $showOnBoarding)
        })
        
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
    
    private func folderSelected(folder: RecordFolder){
        selectedFolder = folder
        print(selectedFolder!.title!)
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
    }
}
