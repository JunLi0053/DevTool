//
//  CreateModelTool.swift
//  LocalizeTool
//
//  Created by aimo on 2023/10/18.
//

import Foundation

private var content = [String]()

// 定义一个函数，根据 JSON 内容动态生成数据模型
func generateModel(from json: [String: Any], modelName: String? = nil) {
    
    var modelCode = "struct Model: Codable {\n"
    if let modelName = modelName {
        modelCode = "struct \(modelName): Codable {\n"
    }
    
    for (key, value) in json {
        if let stringValue = value as? String {
            modelCode += "    let \(key): String\n"
        } else if let intValue = value as? Int {
            modelCode += "    let \(key): Int\n"
        } else if let boolValue = value as? Bool {
            modelCode += "    let \(key): Bool\n"
        } else if let doubleValue = value as? Double {
            modelCode += "    let \(key): Double\n"
        } else if let arrayValue = value as? [Any] {
            if let firstElement = arrayValue.first {
                if let _ = firstElement as? [String: Any] {
                    modelCode += "    let \(key): [\(key.capitalized)]\n"
                    generateModel(from: firstElement as! [String: Any], modelName: key.capitalized)
                } else {
                    if let _ = firstElement as? String {
                        modelCode += "    let \(key): [String]\n"
                    } else if let _ = firstElement as? Int {
                        modelCode += "    let \(key): [Int]\n"
                    } else if let _ = firstElement as? Bool {
                        modelCode += "    let \(key): [Bool]\n"
                    } else if let _ = firstElement as? Double {
                        modelCode += "    let \(key): [Double]\n"
                    }
                }
            }
        } else if let nestedJson = value as? [String: Any] {
            modelCode += "    let \(key): \(key.capitalized)\n"
            generateModel(from: nestedJson, modelName: key.capitalized)
        }
    }
    
    modelCode += "}\n"
    content.append(modelCode)
}

func generateModel(from jsonString: String) -> String? {
    guard let jsonData = jsonString.data(using: .utf8) else {
        return nil
    }
    
    guard let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
        return nil
    }
    content = []
    generateModel(from: json)
    return content.reversed().joined(separator: "\n")
}

// 示例 JSON 数据
let json: [String: Any] = [
    "name": "John",
    "age": 30,
    "isStudent": true,
    "grades": [95, 85, 90],
    "address": [
        "street": "123 Main St",
        "city": "New York"
    ]
]

