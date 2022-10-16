//
//  LibraryView.swift
//  AppHear
//
//  Created by Jason Kenneth on 11/10/22.
//

import SwiftUI

struct LibraryView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var searchText = ""
    
    
    private let recordings: [Recording] = [
        Recording(name: "Fisika", date: Date(), emoji: "😀"),
        Recording(name: "Data Mining", date: Date(), emoji: "🫶"),
        Recording(name: "Algorithm Design", date: Date(), emoji: "😮"),
        Recording(name: "Mat", date: Date(), emoji: "😀"),
        Recording(name: "Biologi", date: Date(), emoji: "😀"),
        Recording(name: "Mat murni", date: Date(), emoji: "😀"),
        Recording(name: "Mat minat", date: Date(), emoji: "😀"),
        Recording(name: "Mat Wajib", date: Date(), emoji: "😀"),
    ]
    
    
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
                            .frame(width: 12.0, height: 16.0)
                            .clipped(antialiased: true)
                    }
                        Spacer()
                    }
                    
                    HStack {
                        Text("All Recordings")
                            .font(.custom("Nunito-ExtraBold", size: 28))
                            .foregroundColor(.white)
                        Spacer()
                        
                    }
                    ZStack {
                        Rectangle().foregroundColor(.white).opacity(0.5).frame(width: 354, height: 39).cornerRadius(19.5)
                        HStack{
                            Image(systemName: "magnifyingglass").foregroundColor(.white).padding(.leading)
                            Text("Search File").font(.custom("Nunito-Regular", size: 15)).foregroundColor(.white)
                            Spacer()
                        }
                    }
                    List{
                        ForEach(recordings){ item in
                            CustomList(name: item.name, date: item.date, emoji: item.emoji)
                        }
                        .listRowBackground(Image("library-card")
                            .resizable()
                            .scaledToFit()
                            .ignoresSafeArea(.all)
                            .aspectRatio(contentMode: .fit))
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .swipeActions(allowsFullSwipe: false) {
                            Button {
                                print("Delete")
                            } label: {
                                Image("library-trash")
                                    .resizable()
                                    .scaledToFit()
                            }
                            .tint(Color(red: 255/255, green: 59/255, blue: 48/255, opacity: 1.0))
                            
                            Button {
                                print("Saved")
                            } label: {
                                Image("library-folder")
                                    .resizable()
                                    .frame(width: 100.0, height: 100.0)
                            }
                            .tint(Color(red: 245/255, green: 193/255, blue: 66/255, opacity: 1.0))
                        }
                    }
                    .padding(.top, 3)
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
    }
}

struct Recording: Identifiable {
    let id = UUID()
    var name: String
    var date: Date
    var emoji: String
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
//
//extension UINavigationController {
//    override open func viewDidLoad() {
//        super.viewDidLoad()
//
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithTransparentBackground()
//        appearance.backgroundImage = UIImage(named: "library-nav-bar")
//        appearance.largeTitleTextAttributes = [.font : UIFont(name: "Nunito-ExtraBold", size: 34)!]
//
//        navigationBar.standardAppearance = appearance
//        navigationBar.compactAppearance = appearance
//        navigationBar.scrollEdgeAppearance = appearance
//    }
//}
