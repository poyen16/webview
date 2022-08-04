//
//  SwiftUIView.swift
//  webview
//
//  Created by boncor chen on 2022/7/7.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift


struct HistoryView: View {
    @State var state = UserDefaults.standard.bool(forKey: "test")
    @State var name : String = SetUpView().name
    @State var newname : String = SetUpView().newname
    @State var label: LocalizedStringKey = "label1"
    @State var label1: LocalizedStringKey = "label15"
    @State var label2: LocalizedStringKey = "label16"
    @State var ids = Array(repeating: "", count: 100)
    @State var num : Int = 0
    @State var entries : String = ""
    @State var entrynum : Int = 0
    @State var setupstat : Bool = false
   
    @FirestoreQuery(collectionPath: "urls", predicates: [
        .order(by: "name")])  var histories: [History]
    
    @State var duplicate : [History] = [History(id: "", name: "", url: "", date: "")]
    
    func makeduplicate(){
        $histories.path = newname
        duplicate.removeAll()
        duplicate = histories
        print("Yo")
    }

    

    func getid (){
        let db = Firestore.firestore()
        let mydb = db.collection(newname).order(by: "name", descending: false)
        mydb.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    ids.remove(at: num)
                    let id = document.documentID
                    ids.insert(id, at: num)

                }
            }
        }
    }
    
    func delete(deleteID : String) {
        let db = Firestore.firestore()
        db.collection(newname).document(deleteID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func deleteitem(at Offsets : IndexSet){
        duplicate.remove(atOffsets: Offsets)
        let index = Offsets[Offsets.startIndex]
        entrynum = index
        delete(deleteID: ids[entrynum])
    }
    
    func setup(){
        makeduplicate()
        getid()
    }

    var body: some View {

        VStack{
 

                List{
                    ForEach(duplicate){ History in
                        HStack {
                            Text(History.name)
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text(History.url)
                                Text(History.date)
                            }
                        }
                    }.onDelete(perform: deleteitem)
                    
                }
                
                .refreshable(action: {setup()})
                .toolbar{
                    EditButton()
                }
                .navigationTitle(label)
                .navigationBarTitleDisplayMode(.inline)


        }


    }


}
struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}

        


