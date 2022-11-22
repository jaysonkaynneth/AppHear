//
//  FolderView.swift
//  AppHear
//
//  Created by Ganesh Ekatata Buana on 18/11/22.
//

import Foundation
import SwiftUI

struct FolderView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var files: FetchedResults<File>
    @State private var searchText = ""
    var passedFolder: RecordFolder
    
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
                        Text(passedFolder.title ?? "No title")
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
                            if (file.isdeleted == false) && (file.folder == passedFolder.title) {
                                if loweredTitle.contains(loweredText){
                                    DisclosureGroup(
                                        content: {
                                            CustomList(name: file.title ?? "Untitled", date: file.date ?? Date(), emoji: passedFolder.emoji ?? "❓", files: file)
                                        },
                                        label: {
                                            CustomList(name: file.title ?? "Untitled", date: file.date ?? Date(), emoji: passedFolder.emoji ?? "❓", files: file)
                                        }
                                    ).tint(.clear)
                                }else if searchText.isEmpty{
                                    DisclosureGroup(
                                        content: {
                                            CustomList(name: file.title ?? "Untitled", date: file.date ?? Date(), emoji: passedFolder.emoji ?? "❓", files: file)
                                        },
                                        label: {
                                            CustomList(name: file.title ?? "Untitled", date: file.date ?? Date(), emoji: passedFolder.emoji ?? "❓", files: file)
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
                .background(Color(cgColor: .screenColor))
                .padding(.trailing)
                .padding(.leading)
            }
            .background(Color(cgColor: .screenColor))
        }
        .background(Color(cgColor: .screenColor))
        .navigationBarHidden(true)
            .navigationBarTitle("")
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
