//
//  ContentView.swift
//  Shared
//
//  Created by boncor chen on 2022/7/7.
//

import SwiftUI



struct ContentView: View {
    @State var status : Bool = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    @State var test : Bool = UserDefaults.standard.value(forKey: "test") as? Bool ?? false
    @State var label: LocalizedStringKey = "label1"
    @State var label1: LocalizedStringKey = "label2"
    var body: some View {
            NavigationView{
                VStack{
                    
                if self.status{
                        VStack{
                        SetUpView()
                        NavigationLink(destination: HistoryView(), label:{
                            Text(label)
                        } )
                        .padding(.bottom)
                        }.onAppear(perform: HistoryView().setup)
                }else{
                    Login()
                }
            }
                .navigationTitle(label1)
                .navigationBarTitleDisplayMode(.inline)
                .onAppear(){
                    NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in
                        //更改初始
                        self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                    }
                }
                }
                
                
            }
    }

  
 

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

