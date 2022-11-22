//
//  DeletedView.swift
//  AppHear
//
//  Created by Ganesh Ekatata Buana on 15/11/22.
//

import SwiftUI

struct DeletedView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var files: FetchedResults<File>
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Image("library-nav-bar")
                        .resizable()
                        .scaledToFit()
                        .ignoresSafeArea(.all)
                    Spacer()
                }
                VStack{
                    HStack {
                        Button{
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    label: {
                        Image("back-chevron")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 12, height: 16)
                            .clipped(antialiased: true)
                    }
                        Spacer()
                    }
                    
                    HStack {
                        Text("Recently Deleted")
                            .font(.custom("Nunito-ExtraBold", size: 28))
                            .foregroundColor(.white)
                        Spacer()
                        
                    }
                    ZStack {
                        SearchBarView(searchText: $searchText, containerText: "Cari Rekaman")
                            .offset(y:-10)
                    }
                    
                    List {
                        ForEach(files){ file in
                            let loweredText = searchText.lowercased()
                            let loweredTitle = file.title!.lowercased()
                            if file.isdeleted == true {
                                if loweredTitle.contains(loweredText){
                                    DisclosureGroup(
                                        content: {
                                            CustomList(name: file.title ?? "Untitled", date: file.date ?? Date(), emoji: "💻", files: file)
                                        },
                                        label: {
                                            CustomList(name: file.title ?? "Untitled", date: file.date ?? Date(), emoji: "💻", files: file)
                                        }
                                    ).tint(.clear)
                                }else if searchText.isEmpty{
                                    DisclosureGroup(
                                        content: {
                                            CustomList(name: file.title ?? "Untitled", date: file.date ?? Date(), emoji: "💻", files: file)
                                        },
                                        label: {
                                            CustomList(name: file.title ?? "Untitled", date: file.date ?? Date(), emoji: "💻", files: file)
                                        }
                                    ).tint(.clear)
                                }
                            }
                        }
                        .onDelete(perform: deleteItems)
                        .listRowSeparator(.hidden)

                    }
                    .padding(.top)
                    .offset(y: -20)
                    .frame( maxWidth: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .listStyle(GroupedListStyle())
                    .scrollContentBackground(.hidden)
                }
                .padding(.trailing)
                .padding(.leading)
            }
            .background(Color(cgColor: .screenColor))
            .navigationBarHidden(true)
            .navigationBarTitle("")
        }
        .background(Color(cgColor: .screenColor))
        .preferredColorScheme(.light)
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

struct Recording: Identifiable {
    let id = UUID()
    var name: String
    var date: Date
    var emoji: String
}
