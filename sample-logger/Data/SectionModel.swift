//
//  SectionModel.swift
//  sample-logger
//
//  Created by Crystalwing B. on 10/10/24.
//
import Foundation

struct SectionModel {
    var title: String
    var rows: [RowModel]
}

struct RowModel {
    var title: String
    var subtitle: String?
    var action: DispatchWorkItem?
}
