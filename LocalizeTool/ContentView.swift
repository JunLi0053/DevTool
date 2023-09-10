//
//  ContentView.swift
//  LocalizeTool
//
//  Created by Jun on 2023/9/10.
//

import SwiftUI
import UniformTypeIdentifiers


struct ContentView: View {
    @State var image = NSImage(named: "")
    @State private var dragOver = false
    @State private var importing = false
    @State var languages = [String: String]()
    var body: some View {
        
        HStack(spacing: 1) {
            GeometryReader {geo in
                
                Image("folder.fill.badge.plus")
                    .onTapGesture {
                        importing = true
                    }
                    .position(x: geo.size.width/2, y:geo.size.height/2)
                    .fileImporter(
                        isPresented: $importing,
                        allowedContentTypes: [.plainText, UTType("com.microsoft.excel.xls")!]
                    ) { result in
                        switch result {
                        case .success(let file):
                            print(file.absoluteString)
                            languages = handle(file: file)
                            
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                
            }.onDrop(of: ["public.file-url"], isTargeted: $dragOver) { providers -> Bool in
                providers.first?.loadDataRepresentation(forTypeIdentifier: "public.file-url", completionHandler: { (data, error) in
                    if let data = data, let path = NSString(data: data, encoding: 4), let url = URL(string: path as String) {
                        languages = handle(file: url)
                    }
                })
                return true
            }
            .onDrag {
                let provider =  NSItemProvider()
                return provider
            }
            .frame(width: 200)
            
            Divider().background(Color.black)
            
            GeometryReader { geo in
                NavList(languages: languages)
            }
            
        }
        
    }
}

struct NavList : View {
    var languages = [String: String]()
    var body: some View {
        NavigationView {
            List {
                ForEach(Array(languages.keys), id: \.self){key in
                    NavigationLink(destination: LocateView(content: languages[key]!)
                        .navigationTitle(key)){
                        Text(key).font(.title3)
                    }
                }
            }
        }
        .listStyle(SidebarListStyle())
        
    }
}


func handle(file : URL) -> [String: String]{
    let content = try! NSString(contentsOf: file, encoding: 4)
    let CSV = CSV(with: content as String)
    let languages = CSV.headers.filter { header in
        header != "key"
    }
    
    var dict = [String: String]()
    languages.forEach { language in
        let languageLoc = CSV.columns[language]
        let keys = CSV.columns["key"]
        var localeContent = ""
        for i in 0..<keys!.count {
            localeContent = localeContent +
            "\"\(keys![i])\" = \"\(languageLoc![i])\"" + "\n"
        }
        dict[language] = localeContent
    }
    
    return dict
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
    
}

