//
//  SettingVC.swift
//  sample-logger
//
//  Created by Crystalwing B. on 10/10/24.
//

import UIKit

final class SettingVC: BaseTableVC {
    override func buildSections() {
        super.buildSections()
        self.sections = []
        for i in 1...10 {
            var rows: [RowModel] = []
            for j in 1...10 {
                rows.append(.init(title: "Section #\(i) + Row #\(j)", subtitle: "GO"))
            }
            sections.append(.init(title: "\(screenTitle) Section #\(i)", rows: rows))
        }
    }
}
