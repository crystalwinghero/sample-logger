//
//  BaseTableVC.swift
//  sample-logger
//
//  Created by Crystalwing B. on 10/10/24.
//

import UIKit

class BaseTableVC: UITableViewController {
    
    var screenTitle: String = ""
    var sections: [SectionModel] = []
    
    lazy var logger: WLogger = WLogger(subsystem: Global.subsystem, category: screenTitle)
    
    init(screenTitle: String, sections: [SectionModel] = []) {
        self.screenTitle = screenTitle
        self.sections = sections
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logger.log(#function)
        setup()
    }
    
    func setup() {
        logger.log(#function)
        view.backgroundColor = .systemBackground
        navigationItem.title = screenTitle
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.addExportButton()
        self.buildSections()
    }
    func buildSections() {
        logger.log(#function)
    }
    func addExportButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Export", style: .plain, target: self, action: #selector(exportLogs))
    }
    
    @objc func exportLogs() {
        do {
            let logs = try fetchLogs()
            guard let logs = logs, !logs.isEmpty else {
                throw NSError(domain: "Empty log", code: -1, userInfo: ["message": "No log data"])
            }
            try logs.write(to: Global.logFileUrl, atomically: true, encoding: .utf8)
            let activityVC = UIActivityViewController(activityItems: [Global.logFileUrl], applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        } catch {
            let message = (error as NSError).userInfo["message"] as? String ?? error.localizedDescription
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
}

extension BaseTableVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].rows.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = sections[indexPath.section].rows[indexPath.row]
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.text = item.title
            content.secondaryText = item.subtitle
            content.prefersSideBySideTextAndSecondaryText = true
            content.secondaryTextProperties.color = .link
            cell.contentConfiguration = content
        } else {
            // Fallback on earlier versions
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.logger.log(#function, "click", indexPath)
        Global.logger.log(#function, "log", indexPath)
        Global.logger.log(type: .debug, #function, "debug", indexPath)
        Global.logger.log(type: .default, #function, "default", indexPath)
        Global.logger.log(type: .info, #function, "info", indexPath)
        Global.logger.log(type: .error, #function, "error", indexPath)
        Global.logger.log(type: .fault, #function, "fault", indexPath)
        let item = sections[indexPath.section].rows[indexPath.row]
        guard let action = item.action else { return }
        DispatchQueue.main.async { [weak self] in
            self?.logger.log(#function, "perform", indexPath)
            action.perform()
        }
    }
}
