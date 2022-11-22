//
//  OverlayView.swift
//  AppHear
//
//  Created by Jason Kenneth on 20/10/22.
//

import SwiftUI

struct OverlayView: View {
    
    @State private var isPresented = false
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var files: FetchedResults<File>
    
    @Binding var recordAmount: Int
    @Binding var deletedAmount: Int
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.primary.opacity(0.5))
                .ignoresSafeArea()
            
            VStack {
                
                Spacer()
                ZStack {
                    Image("lang-popup")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 197, height: 68)
                    HStack {
                        Button {
                            isPresented.toggle()
                            UserDefaults.standard.set("id", forKey: "lang")
                        } label: {
                            Image("id-lang-icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 34, height: 31)
                                .padding(.leading)
                                .padding(.bottom)
                        }
//                        .fullScreenCover(isPresented: $isPresented, content: RecordView.init)
                        .fullScreenCover(isPresented: $isPresented, onDismiss: {
                           countRecord()
                          }, content: {
                              RecordView()
                          })
                        
                        Button {
                            isPresented.toggle()
                            UserDefaults.standard.set("en", forKey: "lang")
                        } label: {
                            Image("en-lang-icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 34, height: 31)
                                .padding(.leading, 60)
                                .padding(.bottom)
                        }
                        .fullScreenCover(isPresented: $isPresented, content: RecordView.init)                    }
                }
                
                ZStack {
                    
                    Rectangle().fill(.clear).frame(width: 390, height: 144, alignment: .center).offset(y: 4)
                }
            }
        }
        .ignoresSafeArea()
        .preferredColorScheme(.light)
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
}
