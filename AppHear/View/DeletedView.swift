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
                        Rectangle().foregroundColor(.white).opacity(0.5).frame(width: 354, height: 39).cornerRadius(19)
                        HStack{
                            Image(systemName: "magnifyingglass").foregroundColor(.white).padding(.leading)
                            Text("Search File").font(.custom("Nunito-Regular", size: 15)).foregroundColor(.white)
                            Spacer()
                        }
                    }
                    
                    List {
                        ForEach(files){ file in
                            if file.isdeleted == true {
                                DisclosureGroup(
                                content: {
                                    CustomList(name: file.title!, date: file.date!, emoji: "💻", files: file)
                                },
                                label: {
                                    CustomList(name: file.title!, date: file.date!, emoji: "💻", files: file)
                                }
                            ).tint(.clear)
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
            .navigationBarHidden(true)
            .navigationBarTitle("")
        }
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
