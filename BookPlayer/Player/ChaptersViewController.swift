//
// ChaptersViewController.swift
// BookPlayer
//
// Created by Gianni Carlo on 7/23/16.
// Copyright © 2016 Tortuga Power. All rights reserved.
//

import BookPlayerKit
import MediaPlayer
import Themeable
import UIKit

class ChaptersViewController: UITableViewController {
    var currentBook: Book!
    var chapters: [Chapter] {
        return self.currentBook.chapters?.array as? [Chapter] ?? []
    }

    var didSelectChapter: ((_ selectedChapter: Chapter?) -> Void)?
    var scrolledToCurrentChapter = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView()
        setUpTheming()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard let currentChapter = self.currentBook.currentChapter,
            !self.scrolledToCurrentChapter,
            let index = self.chapters.firstIndex(of: currentChapter) else { return }

        self.scrolledToCurrentChapter = true
        let indexPath = IndexPath(row: index, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }

    @IBAction func done(_ sender: UIBarButtonItem?) {
        self.didSelectChapter?(nil)
    }

    public func setNewBook(_ book: Book) {
        self.currentBook = book
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chapters.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChapterCell", for: indexPath)
        let chapter = self.chapters[indexPath.row]

        cell.textLabel?.text = chapter.title == "" ? "Chapter \(indexPath.row + 1)" : chapter.title
        cell.detailTextLabel?.text = "Start: \(self.formatTime(chapter.start)) - Duration: \(self.formatTime(chapter.duration))"
        cell.accessoryType = .none

        if let currentChapter = self.currentBook.currentChapter, currentChapter.index == chapter.index {
            cell.accessoryType = .checkmark
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didSelectChapter?(self.chapters[indexPath.row])
    }
}

extension ChaptersViewController: Themeable {
    func applyTheme(_ theme: Theme) {
        self.view.backgroundColor = theme.backgroundColor
        self.tableView.backgroundColor = theme.backgroundColor
    }
}
