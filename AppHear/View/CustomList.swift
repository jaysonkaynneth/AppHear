//
//  LibraryView.swift
//  AppHear
//
//  Created by Jason Kenneth on 14/10/22.
//

import SwiftUI

struct CustomList: View {
    @State var name: String
    @State var date = Date()
    @State var emoji: String
        
//        static let dateFormatter: DateFormatter = {
//            let formatter = DateFormatter()
//            formatter.dateFormat = "dd-mm-yyyy"
//            formatter.dateStyle = .long
//            return formatter
//        }()
    
//    var newDate: String
//    let dateFormatter: DateFormatter
//    dateFormatter.dateStyle = .short
//    newDate = dateFormatter.string(from: date)

    
    var body: some View {
        
        ZStack(alignment: .leading){
            RoundedRectangle(cornerRadius: 10.0)
                .fill(Color.white)
                .frame(height: 70)
                .shadow(radius: 5)
            HStack {
                VStack(alignment: .leading){
                    Text(name)
                        .foregroundColor(Color(red: 66/255, green: 84/255, blue: 182/255, opacity: 1.0))
                        .font(.custom("Nunito-ExtraBold", size: 25))
//                    Text("\(date, format: Date.FormatStyle().year().month().day())")
                    Text("\(date)")
                        .foregroundColor(Color(red: 139/255, green: 139/255, blue: 139/255, opacity: 1.0))
                        .font(.custom("Nunito-ExtraBold", size: 19))
                }
                
                Spacer()
                
                Text(emoji)
                    .foregroundColor(.black)
                    .font(.title2)
            }.padding()
        }
    }
    
    func dateFormatter() {

    }
}



