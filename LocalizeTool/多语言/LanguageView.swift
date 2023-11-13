//
//  LanguageView.swift
//  LocalizeTool
//
//  Created by aimo on 2023/10/17.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers
import CoreXLSX


struct LanguageView: View {
    @State var image = NSImage(named: "")
    @State private var dragOver = false
    @State private var importing = false
    @Binding var languages : [String: [String]]
    var body: some View {
        HStack(spacing: 1) {
            GeometryReader {geo in
                Image("folder.fill.badge.plus")
                    .onTapGesture {
                        let panel = NSOpenPanel()
                        panel.allowedFileTypes = ["xlsx"]
                        panel.allowsMultipleSelection = false
                        if panel.runModal() == .OK, let url = panel.url {
                            languages = handle(fileURL: url)
                        }
                    }
                    .position(x: geo.size.width/2, y:geo.size.height/2)
                                    
                
            }.onDrop(of: ["public.file-url"], isTargeted: $dragOver) { providers -> Bool in
                providers.first?.loadDataRepresentation(forTypeIdentifier: "public.file-url", completionHandler: { (data, error) in
                    if let data = data, let path = NSString(data: data, encoding: 4), let url = URL(string: path as String) {
                        languages = handle(fileURL: url)
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
                LanguageListView(languages: languages)
            }
            
        }
    }
}


struct LanguageListView : View {
    var languages = [String: [String]]()
    var body: some View {
        NavigationView {
            List {
                ForEach(Array(languages.keys), id: \.self){key in
                    NavigationLink(destination: TranslateView(language: key, orgContents: languages[key]!))
                        {
                            Text(key).font(.title3)
                        }
                }
            }
        }
        .listStyle(SidebarListStyle())
        
    }
}

func handle(fileURL : URL) -> [String: [String]]{
    var dict = [String: [String]]()
    
    guard let file = XLSXFile(filepath: fileURL.absoluteString.replacingOccurrences(of: "file://", with: "")) else {
        print("XLSXFile......")
        return dict
    }
    
    
    for path in try! file.parseWorksheetPaths() {
        let worksheet = try! file.parseWorksheet(at: path)
        if let sharedStrings = try! file.parseSharedStrings() {
            var lines = [[String]]() // 创建一个二维数组来保存每一行的数据
            let rows = worksheet.data?.rows ?? []
            let columnNames = Set(rows.flatMap { $0.cells }.map { $0.reference.column.value })
        
            for row in 1...rows.count {
                var line = [String]() // 创建一个数组来保存这一行的数据
                for columnName in columnNames {
                    if let columnRef = ColumnReference(columnName) {
                        let reference = CellReference(columnRef, UInt(row))
                        let cell = rows.flatMap { $0.cells }.first(where: { $0.reference == reference })
                        line.append(cell?.stringValue(sharedStrings) ?? (cell?.richStringValue(sharedStrings).first?.text ?? ""))
                    }
                }
                lines.append(line) // 添加这一行的数据到所有行的数据中
            }
            
            let csv = CSV(lines: lines)
            let languages = csv.headers.filter { header in
                header != "Key"
            }
            languages.forEach { language in
                if checkIsLanguage(language) {
                    let languageLoc = csv.columns[language]
                    let keys = csv.columns["Key"]
                    var locales = [String]()
//                    var localeContent = ""
                    for i in 0..<keys!.count {
                        if !keys![i].isEmpty {
                            locales.append("\"\(keys![i])\" = \"\(languageLoc![i])\";" + "<br>")
//                            localeContent = localeContent +
//                            "\"\(keys![i])\" = \"\(languageLoc![i])\";" + "<br>"
                        }
                    }
                    dict[language] = locales
                }
            }
        }
    }
    
    return dict
}

func checkIsLanguage(_ lan : String) -> Bool {
    return lan.contains("语") || lan.contains("文")
}
