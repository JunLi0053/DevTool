//
//  CSV.swift
//  LocaleTool
//
//  Created by Jun on 2023/9/9.
//

import Foundation
public class CSV {

    public var headers: [String]
    
    public var columns: [String: [String]]
    
    public var rows: [[String: String]]
    
    public var lines: [[String]]
    
    public var numberOfColumns: Int
    
    public var numberOfRows: Int
    
    public init(lines : [[String]]) {
        self.lines = lines
        
        headers = [String]()
        
        columns = [String: [String]]()
        
        rows = [[String: String]]()
        
        numberOfColumns = 0
        
        numberOfRows = 0
        
        read()
    }

    
    func read() {
        
        numberOfColumns = lines[0].count//获取列数
        
        numberOfRows = lines.count - 1//获取行数
        
        headers = lines[0]//第一行为表头
        
        setRows()
        
        setColumns()
        
    }

    
    //获取每一行的数据
    
    fileprivate func setRows() {
        
        var rows = [[String: String]]()
        
        for i in 1...numberOfRows {
            
            var row = [String: String]()
            
            let vals = lines[i]
            
            var j = 0
            
            for header in headers {
                
                row[header] = j < vals.count ? vals[j] : ""
                
                j+=1
                
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

