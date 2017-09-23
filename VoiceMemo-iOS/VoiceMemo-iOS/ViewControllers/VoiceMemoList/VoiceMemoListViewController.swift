//
//  VoiceMemoListViewController.swift
//  VoiceMemo-iOS
//
//  Created by ROC Zhang on 2017/9/23.
//  Copyright © 2017年 Roc Zhang. All rights reserved.
//

import UIKit
import CoreData

class VoiceMemoListViewController: UIViewController {
    
    // MARK: Data Elements
    
    private var memos: [VoiceMemo] = []
    
    private var fetchResultsController: NSFetchedResultsController<LocalMemo>?
    
    private var currentPlayingIndexPath: IndexPath? {
        didSet {
            handlePlayState(old: oldValue, new: currentPlayingIndexPath)
        }
    }
    
    private var isPlaying: Bool = false
    
    
    // MARK: UI Elements
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.register(VoiceMemoListCell.self)
        view.separatorColor = UIColor.white.withAlphaComponent(0.15)
        view.separatorInset = UIEdgeInsets(top: 0, left: Configs.UI.basicLeading, bottom: 0, right: 0)
        view.backgroundColor = .voiceMemoBackgroundColor
        
        return view
    }()
    
    
    // MARK: Life-Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
        makeLayout()
        loadData()
        configDelegate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        AudioManager.stopPlay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Private Methods
    
    private func makeUI() {
        title = "List"
        view.backgroundColor = .voiceMemoBackgroundColor
        view.addSubview(tableView)
    }
    
    private func makeLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    private func loadData() {
        let request: NSFetchRequest<LocalMemo> = LocalMemo.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: LocalMemo.Keys.name.rawValue, ascending: false)
        request.sortDescriptors = [sortDescriptor]
        let context = CoreDataManager.shared.persistentContainer.viewContext
        fetchResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultsController?.delegate = self
        
        do {
            try fetchResultsController?.performFetch()
            guard let objects = fetchResultsController?.fetchedObjects else { return }
            memos = objects.map({ VoiceMemo(name: $0.name ?? "") })
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func configDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func playItem(of indexPath: IndexPath) {
        do {
            let memo = memos[indexPath.row]
            
            try AudioManager.play(with: memo, completion: { [weak self] (flag) in
                guard let strongSelf = self else { return }
                guard let cell = strongSelf.tableView.cellForRow(at: indexPath) as? VoiceMemoListCell else { return }
                
                strongSelf.isPlaying = false
                
                printLog("Excute Play Completion Block: \(indexPath), name:\(cell.titleLabel.text), state: \(cell.state)")
                
                cell.state = .tapToPlay
                
                printLog("After State:\(cell.state)")
            })
            isPlaying = true
            if let cell = tableView.cellForRow(at: indexPath) as? VoiceMemoListCell {
                cell.state = .tapToStop
            }
            
        } catch {
            printLog(error.localizedDescription)
        }
    }
    
    private func handlePlayState(old lastIndexPath: IndexPath?, new currentIndexPath: IndexPath?) {
        guard let currentIndexPath = currentPlayingIndexPath else { return }
        
        if let lastIndexPath = lastIndexPath, lastIndexPath == currentIndexPath {
            if isPlaying {
                AudioManager.stopPlay()
            } else {
                playItem(of: currentIndexPath)
            }
        } else {
            AudioManager.stopPlay()
            playItem(of: currentIndexPath)
        }
        
        printLog("\(lastIndexPath?.row), \(currentIndexPath.row), \(isPlaying)")
    }

}


// MARK: - UITableView Delegate & DataSource Methods

extension VoiceMemoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    enum Sections: Int {
        case memo
        
        var rowDefaultHeight: CGFloat {
            get {
                switch self {
                case .memo:
                    return 100
                }
            }
        }
        
        static let allValues = [memo]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.allValues.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Sections(rawValue: section) else { return 0 }
        switch section {
        case .memo:
            return memos.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Sections(rawValue: indexPath.section) else { return UITableViewCell() }
        switch section {
        case .memo:
            let cell: VoiceMemoListCell = tableView.dequeueReusableCell()
            let item = memos[indexPath.row]
            
            cell.configCell(with: item)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let section = Sections(rawValue: indexPath.section) else { return }
        switch section {
        case .memo:
            guard indexPath == currentPlayingIndexPath, let cell = cell as? VoiceMemoListCell else { break }
            cell.state = isPlaying ? .tapToStop : .tapToPlay
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = Sections(rawValue: indexPath.section) else { return 0 }
        return section.rowDefaultHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentPlayingIndexPath = indexPath
    }
    
}


// MARK: - NSFetchedResultsController Delegate Methods

extension VoiceMemoListViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard let indexPath = indexPath else { break }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .insert:
            guard let newIndexPath = newIndexPath else { break }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { break }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .fade)
        }
    }
}
