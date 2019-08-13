//
//  StudyGroupSelectionViewController.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 05.08.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit

class StudyGroupSelectionViewController: UITableViewController {
    
    // MARK: - Properties
    var data: [Identifiable] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var onSelect: (Identifiable?) -> Void = { _ in }
    private let visualEffectView = UIVisualEffectView(effect: nil)
    private lazy var animator: UIViewPropertyAnimator = {
        return UIViewPropertyAnimator(duration: 0.4, curve: .easeInOut, animations: {
            self.visualEffectView.effect = UIBlurEffect(style: .extraLight)
        })
    }()
    
    private var selection: Identifiable? = nil {
        didSet {
            onSelect(selection)
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.apply {
            $0.estimatedRowHeight   = 100
            $0.rowHeight            = UITableView.automaticDimension
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(170), execute: { [weak self] in
            guard let self = self else { return }
            self.animator.startAnimation()
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let top: CGFloat = max(CGFloat(view.htw.safeAreaInsets.top + 54), CGFloat((view.height - tableView.contentSize.height) - (view.htw.safeAreaInsets.bottom + 54)))
        tableView.contentInset = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
    }
   
    @objc private func onTap() {
        UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut, animations: { [weak self] in
            guard let self = self else { return }
            self.visualEffectView.effect = nil
        }).apply { $0.startAnimation() }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(170)) { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - Setup
extension StudyGroupSelectionViewController {
    
    private func setup() {
        tableView.apply {
            $0.separatorStyle   = .none
            $0.backgroundColor  = .clear
            $0.backgroundView   = visualEffectView
            $0.register(StudyGroupSelectionViewCell.self)
        }
        visualEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))
    }
}

// MARK: - TableView DataSource
extension StudyGroupSelectionViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(StudyGroupSelectionViewCell.self, for: indexPath)!
        cell.setup(with: data[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selection = data[indexPath.row]
        onTap()
    }
}
