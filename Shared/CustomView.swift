//
//  CustomView.swift
//  webview
//
//  Created by boncor chen on 2022/7/9.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift


struct CustomView: View {
    @State var newname : String = SetUpView().newname
    @State var change = false
    @State var label: LocalizedStringKey = "label1"
    @FirestoreQuery(collectionPath: "urls", predicates: [
        .order(by: "name")
    ]) var histories: [History]
    func setup(){
        $histories.path = newname
        
    }
    var body: some View {

            
            List {
                ForEach(histories) { History in
                            HStack {
                                Button(action:{
                                    change.toggle()
                                }){
                                    Text(History.name)
                                }.sheet(isPresented: $change){
                                    WebView(url: URL(string : History.url)!)
                                }
                                Spacer()

                            }
                        } .onAppear(perform: setup)
                    }
            .navigationTitle(label)
            .navigationBarTitleDisplayMode(.inline)

        }

    }


struct CustomView_Previews: PreviewProvider {
    static var previews: some View {
        CustomView()
    }
}
