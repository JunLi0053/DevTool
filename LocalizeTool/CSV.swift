//
//  CSV.swift
//  LocaleTool
//
//  Created by Jun on 2023/9/9.
//

import Foundation
public class CSV {
    
    let newLine: String = "\n"
    
    let csvData: String
    
    
    
    public let delimiter: String
    
    public var headers: [String]
    
    public var columns: [String: [String]]
    
    public var rows: [[String: String]]
    
    public var lines: [String]
    
    public var numberOfColumns: Int
    
    public var numberOfRows: Int
    
    
    
    // MARK: - Initialisers
    
    public init(with: String, delimiter: String = ",") {
        
        csvData = with.replacingOccurrences(of: "\r", with: "", options: NSString.CompareOptions.literal, range: nil)
        
        self.delimiter = delimiter
        
        headers = [String]()
        
        columns = [String: [String]]()
        
        rows = [[String: String]]()
        
        lines = [String]()
        
        numberOfColumns = 0
        
        numberOfRows = 0
        
        
        
        read()
        
    }
    
    
    
    public convenience init(path: String, delimiter: String = ",", encoding: String.Encoding = .utf8) throws {
        
        let contents = try String(contentsOfFile: path, encoding: encoding)
        
        self.init(with: contents, delimiter: delimiter)
        
    }
    
    func read() {
        
        processLines(csvData)
        
        numberOfColumns = lines[0].components(separatedBy: delimiter).count//获取列数
        
        numberOfRows = lines.count - 1//获取行数
        
        headers = lines[0].components(separatedBy: delimiter)//第一行为表头
        
        setRows()
        
        setColumns()
        
    }
    
    //按行分割
    
    fileprivate func processLines(_ csv: String) {
        
        lines = csv.components(separatedBy: "\n")
        
        // Remove blank lines
        
        var i = 0
        
        for line in lines {
            
            if line.isEmpty {
                
                lines.remove(at: i)
                
                i -= 1
                
            }
            
            i += 1
            
        }
        
    }
    
    //获取每一行的数据
    
    fileprivate func setRows() {
        
        var rows = [[String: String]]()
        
        for i in 1...numberOfRows {
            
            var row = [String: String]()
            
            let vals = lines[i].components(separatedBy: delimiter)
            
            var i = 0
            
            for header in headers {
                
                row[header] = vals[i]
                
                i+=1
                
            }
            
            rows.append(row)
            
        }
        
        self.rows = rows
        
    }
    
    //每一列的数据获取
    
    fileprivate func setColumns() {
        
        var columns = [String: [String]]()
        
        for header in headers {
            
            var colValue = [String]()
            
            for row in rows {
                
                colValue.append(row[header]!)
                
            }
            
            columns[header] = colValue
            
        }
        
        self.columns = columns
        
    }
    
}

