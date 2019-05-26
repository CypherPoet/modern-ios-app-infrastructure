//
//  QuotesViewController.swift
//  Paraphrase
//
//  Created by Paul Hudson on 05/05/2018.
//  Copyright © 2018 Hacking with Swift. All rights reserved.
//

import UIKit
import SwiftyBeaver

class QuotesViewController: UITableViewController {
    // all the quotes to be shown in our table
    var viewModel: QuotesViewModel!

    // whichever row was selected; used when adjusting the data source after editing
    var selectedRow: Int?
}


// MARK: - Lifecycle

extension QuotesViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        viewModel = QuotesViewModel()
    }
}


// MARK: - Core Methods

extension QuotesViewController {
    func finishedEditing(_ quote: Quote) {
        // make sure we have a selected row
        guard let quoteIndex = selectedRow else { return }
        
        if quote.author.isEmpty && quote.text.isEmpty {
            // if no text was entered just delete the quote
            viewModel.remove(at: quoteIndex)
        } else {
            // replace our existing quote with this new one then save
            viewModel.replace(quoteAt: quoteIndex, with: quote)
        }
        
        tableView.reloadData()
        selectedRow = nil
    }
}


// MARK: - Table View Data Source

extension QuotesViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let quote = viewModel.quote(at: indexPath.row)

        cell.textLabel?.text = quote.singleLine

        return cell
    }
}


// MARK: - Table View Delegate

extension QuotesViewController {
    
    /**
     show the quote fullscreen
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let showQuoteViewController = storyboard?
            .instantiateViewController(withIdentifier: "ShowQuoteViewController") as? ShowQuoteViewController
        else {
            SwiftyBeaver.error("Unable to load ShowQuoteViewController")
            fatalError("Unable to load ShowQuoteViewController")
        }

        showQuoteViewController.quote = viewModel.quote(at: indexPath.row)

        navigationController?.pushViewController(showQuoteViewController, animated: true)
    }

    
    override func tableView(
        _ tableView: UITableView,
        editActionsForRowAt indexPath: IndexPath
    ) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] (_, indexPath) in
            self?.viewModel.remove(at: indexPath.row)
            self?.tableView.deleteRows(at: [indexPath], with: .automatic)
        }

        let edit = UITableViewRowAction(style: .normal, title: "Edit") { [weak self] (_, indexPath) in
            guard let self = self else { return }
            
            guard let editQuoteVC = self.storyboard?
                .instantiateViewController(withIdentifier: "EditQuoteViewController") as? EditQuoteViewController
            else {
                SwiftyBeaver.error("Unable to load EditQuoteViewController")
                fatalError("Unable to load EditQuoteViewController")
            }
            
            let quote = self.viewModel.quote(at: indexPath.row)
            self.selectedRow = indexPath.row

            editQuoteVC.quotesViewController = self
            editQuoteVC.editingQuote = quote
            
            self.navigationController?.pushViewController(editQuoteVC, animated: true)
        }

        edit.backgroundColor = UIColor(red: 0, green: 0.4, blue: 0.6, alpha: 1)

        return [delete, edit]
    }
}


// MARK: - Private Helper Methods

private extension QuotesViewController {
    
    @objc func addQuote() {
        // add an empty quote and mark it as selected
        let quote = Quote(author: "", text: "")
        
        viewModel.add(quote)
        selectedRow = viewModel.count - 1
        
        // now trigger editing that quote
        guard let editQuoteVC = storyboard?
            .instantiateViewController(withIdentifier: "EditQuoteViewController") as? EditQuoteViewController
        else {
            SwiftyBeaver.error("Unable to load EditQuoteViewController")
            fatalError("Unable to load EditQuoteViewController")
        }
        
        editQuoteVC.quotesViewController = self
        editQuoteVC.editingQuote = quote
        navigationController?.pushViewController(editQuoteVC, animated: true)
    }
    
    
    @objc func showRandomQuote() {
        guard let selectedQuote = viewModel.random() else { return }
        
        guard let showQuoteVC = storyboard?
            .instantiateViewController(withIdentifier: "ShowQuoteViewController") as? ShowQuoteViewController
        else {
            SwiftyBeaver.error("Unable to load ShowQuoteViewController")
            fatalError("Unable to load ShowQuoteViewController")
        }
        
        showQuoteVC.quote = selectedQuote
        
        navigationController?.pushViewController(showQuoteVC, animated: true)
    }
    
    
    func setupUI() {
        title = "Paraphrase"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addQuote)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Random",
            style: .plain,
            target: self,
            action: #selector(showRandomQuote)
        )
    }
}
