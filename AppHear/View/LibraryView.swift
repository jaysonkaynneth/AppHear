//
//  LibraryView.swift
//  AppHear
//
//  Created by Jason Kenneth on 11/10/22.
//

import SwiftUI

struct LibraryView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var files: FetchedResults<File>
    @State private var searchText = ""
    @State private var delete: IndexSet?
    @State private var deleteAlert = false
    
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
                VStack {
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
                        Text("Semua Rekaman")
                            .font(.custom("Nunito-ExtraBold", size: 28))
                            .foregroundColor(.white)
                        Spacer()
                        
                    }
                    ZStack {
                        SearchBarView(searchText: $searchText, containerText: "Cari Rekaman")
                            .offset(y:-10)
                    }
                    Spacer()
                        if files.isEmpty {
                            VStack {
                                Spacer()
                                Image("no-rec")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 335, height: 335)
                                Text("Tidak Ada Rekaman")
                                    .font(.custom("Nunito-Bold", size: 24))
                                    .foregroundColor(Color(cgColor: .appHearBlue))
                                Spacer()
                            }
                        } else {
                            List {
                                ForEach(files) { file in
                                    let loweredText = searchText.lowercased()
                                    let loweredTitle = file.title!.lowercased()
                                    if file.isdeleted == false {
                                        if loweredTitle.contains(loweredText){
                                            DisclosureGroup(
                                                content: {
                                                    CustomList(name: file.title ?? "Untitled", date: file.date ?? Date(), emoji: file.emoji ?? "💻", files: file)
                                                },
                                                label: {
                                                    CustomList(name: file.title ?? "Untitled", date: file.date ?? Date(), emoji: file.emoji ?? "💻", files: file)
                                                }
                                            ).tint(.clear)
                                        }else if searchText.isEmpty{
                                            DisclosureGroup(
                                                content: {
                                                    CustomList(name: file.title ?? "Untitled", date: file.date ?? Date(), emoji: file.emoji ?? "💻", files: file)
                                                },
                                                label: {
                                                    CustomList(name: file.title ?? "Untitled", date: file.date ?? Date(), emoji: file.emoji ?? "💻", files: file)
                                                }
                                            ).tint(.clear)
                                        }
                                    }
                                }
                                .onDelete(perform: deleteItems)
                                .listRowSeparator(.hidden)
                                //                        .swipeActions(allowsFullSwipe: false) {
                                //                            Button {
                                //                                print("Delete")
                                //                                deleteAlert = true
                                //                            } label: {
                                //                                Image("library-trash")
                                //                                    .resizable()
                                //                                    .scaledToFit()
                                //
                                //                            }
                                //                            .tint(Color(red: 255/255, green: 59/255, blue: 48/255, opacity: 1.0))
                                //
                                //                            Button {
                                //                                print("Saved")
                                //                            } label: {
                                //                                    Image("library-folder").resizable()
                                //                                        .frame(width: 100,height: 100)
                                //                            }
                                //                            .tint(Color(red: 245/255, green: 193/255, blue: 66/255, opacity: 1.0))
                                //                        }
                            }
                            .offset(y: -20)
                            .frame(maxWidth: .infinity)
                            .edgesIgnoringSafeArea(.all)
                            .listStyle(GroupedListStyle())
                            .scrollContentBackground(.hidden)
                        }
                    
                }
                .padding(.trailing)
                .padding(.leading)
            }
            .navigationBarHidden(true)
            .navigationBarTitle("")
        }
        .preferredColorScheme(.light)
    }
    
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { files[$0].isdeleted = true }
            do {
                try moc.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}


