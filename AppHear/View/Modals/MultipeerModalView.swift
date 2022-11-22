//
//  MultipeerModalView.swift
//  AppHear
//
//  Created by Ganesh Ekatata Buana on 19/11/22.
//

import SwiftUI
import os

struct MultipeerModalView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var rpsSession: MultipeerSessionManager
    var logger = Logger()
    @State var isAlerted = true
    @State var isShowing = false

    
    var body: some View {
        VStack {
            Text("Live Transcript Sharing").font(.custom("Nunito-Bold", size: 20)).foregroundColor(.black).padding(.bottom, 10)
            
            Text("Make sure the other device has opened the sharing session.").font(.custom("Nunito-Regular", size: 14)).foregroundColor(.black).multilineTextAlignment(.center)
            
            Spacer()
            
            if (!rpsSession.paired) {
                ScrollView{
                    LazyVStack{
                        ForEach(rpsSession.availablePeers, id: \.self){peer in
                            Button {
                                rpsSession.serviceBrowser.invitePeer(peer, to: rpsSession.session, withContext: nil, timeout: 30)
                            }
                        label: {
                            ZStack{
                                Rectangle().foregroundColor(.white).frame(width: 312, height: 38).cornerRadius(10, antialiased: true).shadow(color: Color(cgColor: .buttonShadow), radius: 5.0).overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(cgColor: .buttonBorder), lineWidth: 2))
                                
                                Text(peer.displayName).font(.custom("Nunito-SemiBold", size: 15)).foregroundColor(.black)
                            }
                        }.padding(.top, 15)
                        }
                    }.padding(.top, 20)
                }.shadow(color: Color(cgColor: .buttonShadow), radius: 6.0).overlay(
                    RoundedRectangle(cornerRadius: 10)
                .stroke(Color(cgColor: .buttonBorder), lineWidth: 3))
                .background(.white)
                .padding(.top, 20)
                .alert("Received an invite from \(rpsSession.recvdInviteFrom?.displayName ?? "ERR")!", isPresented: $rpsSession.recvdInvite) {
                Button("Accept") {
                    if (rpsSession.invitationHandler != nil) {
                        rpsSession.invitationHandler!(true, rpsSession.session)
                    }
                }
                Button("Reject") {
                    if (rpsSession.invitationHandler != nil) {
                        rpsSession.invitationHandler!(false, nil)
                    }
                }
            }
                
//                    List(rpsSession.availablePeers, id: \.self) { peer in
//                        Button {
//                            rpsSession.serviceBrowser.invitePeer(peer, to: rpsSession.session, withContext: nil, timeout: 30)
//                        }
//                    label: {
//                        ZStack{
//                            Rectangle().foregroundColor(.white).frame(width: 312, height: 38).cornerRadius(10, antialiased: true).shadow(color: Color(cgColor: .buttonShadow), radius: 5.0).overlay(
//                                RoundedRectangle(cornerRadius: 10)
//                                    .stroke(Color(cgColor: .buttonBorder), lineWidth: 2))
//
//                            Text(peer.displayName).font(.custom("Nunito-SemiBold", size: 15)).foregroundColor(.black)
//                        }
//                    }
//                    }
//                    .shadow(color: Color(cgColor: .buttonShadow), radius: 5.0).overlay(
//                        RoundedRectangle(cornerRadius: 10)
//                    .stroke(Color(cgColor: .buttonBorder), lineWidth: 3))
//                    .padding(.top, 10)
//                    .alert("Received an invite from \(rpsSession.recvdInviteFrom?.displayName ?? "ERR")!", isPresented: $rpsSession.recvdInvite) {
//                    Button("Accept") {
//                        if (rpsSession.invitationHandler != nil) {
//                            rpsSession.invitationHandler!(true, rpsSession.session)
//                        }
//                    }
//                    Button("Reject") {
//                        if (rpsSession.invitationHandler != nil) {
//                            rpsSession.invitationHandler!(false, nil)
//                        }
//                    }
//                }
            
            } else {
                VStack{}
                .alert("Paired successfully!", isPresented: $isAlerted) {
                    Button("OK", role: .cancel) {
                        
                        isShowing.toggle()
                    }
                }.sheet(isPresented: $isShowing){
                    SharedRecordView().environmentObject(rpsSession)
                }

            }
            
        }
        .background(Color(cgColor: .screenColor))
        .padding()
    }
}

struct MultipeerModalView_Previews: PreviewProvider {
    static var previews: some View {
        MultipeerModalView()
    }
}
