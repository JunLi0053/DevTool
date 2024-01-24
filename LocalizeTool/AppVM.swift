//
//  AppVM.swift
//  LocalizeTool
//
//  Created by aimo on 2024/1/5.
//

import Foundation

final class AppVM: ObservableObject {
    @Published var languages = [String: [String]]()
    @Published var jsonModelStirng = ""
}
