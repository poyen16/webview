//
//  SetUpView.swift
//  webview
//
//  Created by boncor chen on 2022/7/8.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
extension LocalizedStringKey {

    /**
     Return localized value of thisLocalizedStringKey
     */
    public func toString() -> String {
        //use reflection
        let mirror = Mirror(reflecting: self)
        
        //try to find 'key' attribute value
        let attributeLabelAndValue = mirror.children.first { (arg0) -> Bool in
            let (label, _) = arg0
            if(label == "key"){
                return true;
            }
            return false;
        }
        
        if(attributeLabelAndValue != nil) {
            //ask for localization of found key via NSLocalizedString
            return String.localizedStringWithFormat(NSLocalizedString(attributeLabelAndValue!.value as! String, comment: ""));
        }
        else {
            return "Swift LocalizedStringKey signature must have changed. @see Apple documentation."
        }
    }
}


struct Person: Codable, Identifiable{
    var id: String?
    let email : String
    let username : String
    let password : String
}

struct History: Codable, Identifiable {
    @DocumentID var id: String?
    let name: String
    let url: String
    let date: String
}
struct SetUpView: View {
    @State private var showWebview = false
    @State private var a: String = ""
    @State var name: String = ""
    @State private var date: String = ""
    @State var username = UserDefaults.standard.string(forKey:"username") ?? ""
    @State var newname = "History_" + (UserDefaults.standard.string(forKey:"username") ?? "")
    @State var label: LocalizedStringKey = "label4"
    @State var label1: LocalizedStringKey = "label5"
    @State var label2: LocalizedStringKey = "label6"
    @State var label3: LocalizedStringKey = "label7"
    func createHistory(username: String){
        let today = Date.now
        let db = Firestore.firestore()
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "MM-dd-YYYY"
        date = formatter1.string(from: today)
        let his = History(id:name, name: name, url: a, date: date)
        do {
            let documentReference = try db.collection(newname).addDocument(from: his)
            print(documentReference.documentID)
        } catch {
            print(error)
        }
    }


    var body: some View {
        VStack{
        Text(label)
        Text(username)
                .padding()
        TextField(label1, text: $name)
                .keyboardType(.default)
        TextField(label2, text: $a)
                .keyboardType(.URL)
        Button(action:{
                showWebview.toggle()
                createHistory(username: username)
            }){ Text(label3)
            }.padding().sheet(isPresented: $showWebview){
                WebView(url: URL(string: a)!)
            }
        }.onAppear(perform: HistoryView().setup)
}
}
struct SignUp:View{

    @State var username : String = ""
    @State var email : String = ""
    @State var password : String = ""
    @State var label1 : LocalizedStringKey = "label8"
    @State var label2 : LocalizedStringKey = "label9"
    @State var label3 : LocalizedStringKey = "label10"
    @State var label4 : LocalizedStringKey = "label11"
    @State var label5 : LocalizedStringKey = "label12"
    func createPerson(){
        let new = Person(email: email, username: username, password: password)
        let db = Firestore.firestore()
        do {
            let documentReference = try db.collection("persons").addDocument(from: new)
            print(documentReference.documentID)
        } catch {
            print(error)
        }
    }
    var body: some View{
        Text(label1)
            .font(.title)
        TextField(label2, text: $username)
            .padding()
        TextField(label3, text: $email)
            .padding()
        TextField(label4, text: $password)
            .padding()
        Button(action:{
            createPerson()
            Auth.auth().createUser(withEmail: self.email, password: self.password)
        }){
            Text(label5)
        }.padding()
        
    }
}
struct Login:View{
    @State var hide : Bool = false
    @State var username : String = ""
    @State var email : String = ""
    @State var password : String = ""
    @State var create : Bool = false
    @State var alert : Bool = false
    @State var error : String = ""
    @State var label1 : LocalizedStringKey = "label8"
    @State var label2 : LocalizedStringKey = "label9"
    @State var label3 : LocalizedStringKey = "label10"
    @State var label4 : LocalizedStringKey = "label11"
    @State var label5 : LocalizedStringKey = "label12"
    @State var label6 : LocalizedStringKey = "label13"
    @State var label7 : LocalizedStringKey = "label14"
    func verify(){
        
        if self.email != "" && self.password != ""{
            
            Auth.auth().signIn(withEmail: self.email, password: self.password) { (res, err) in
                
                if err != nil{
                    
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                UserDefaults.standard.set(username, forKey: "username")
                UserDefaults.standard.set(true, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                
            }
        }
        else{
            
            self.error = label7.toString()
            self.alert.toggle()
        }
    }
    var body: some View{
        VStack{
            Text(label6)
                .font(.title)
            TextField(label2, text: $username)
                .padding()
            TextField(label3, text: $email)
                .padding()
            HStack{
                if self.hide{
                    SecureField(label4, text: $password)
                    Button(action:{
                        self.hide.toggle()
                    }){
                        Image(systemName: "eye.fill")
                    }
                }else{
                    TextField(label4, text: $password)
                    
                    Button(action:{
                        self.hide.toggle()
                    }){
                        Image(systemName: "eye.slash.fill")
                    }
                }

            }.padding()

            Button(action:{
                self.verify()
            }){
                Text(label5)
            }.padding()
            Button(action:{
                create.toggle()
            }){
                Text(label1)
            }.sheet(isPresented: $create){
                SignUp()
            }.padding()
        }

        
    }
}
struct SetUpView_Previews: PreviewProvider {
    static var previews: some View {
        SetUpView()
    }
}
