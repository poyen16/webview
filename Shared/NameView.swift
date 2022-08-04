//
//  NameView.swift
//  webview
//
//  Created by boncor chen on 2022/7/7.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct NameView: View {
    @State var sortname = false
    @State var sortdate = false
    @FirestoreQuery(collectionPath: "urls", predicates: [
        .order(by: "name")
    ]) var histories: [History]

    var body: some View {
        VStack{
            HStack{
                Button(action:{
                    sortname.toggle()
                }){
                    Text("Sort by Name")
                }.sheet(isPresented: $sortname){
                    NameView()
                }
                Button(action:{
                    sortdate.toggle()
                }){
                    Text("Sort by Date")
                }.sheet(isPresented: $sortdate){
                    HistoryView()
                }
            }
            
            List {
                ForEach(histories) { History in
                            HStack {
                                Text(History.name)
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text(History.url)
                                    Text(History.date)
                                }
                            }
                        }
                    }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.inline)
        }

          }
        }



