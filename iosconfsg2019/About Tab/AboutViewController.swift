//
//  AboutViewController.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 10/11/18.
//  Copyright © 2018 Vina Melody. All rights reserved.
//

import UIKit
import SafariServices

class AboutViewController: BaseViewController {
    private var tableView: UITableView!
    private struct K {
        static let codeOfConductURL: URL! = URL.init(string: "https://iosconf.sg/coc")
        static let sponsorURL: URL! = URL.init(string: "https://iosconf.sg/#sponsorship")
        static let slackURL: URL! = URL(string: "slack://open")
        static let faqURL: URL! = URL(string: "https://iosconf.sg/faq")
        static let feedback: URL! = URL(string: "https://bit.ly/iosconfsg2023")

        static let cellIdentifier = "AboutCell"
    }

    private var sections: [[String]] = [["Code of Conduct", "Sponsors", "FAQ", "Feedback"], ["Open iOSConfSG Slack"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustFooterView()
    }

    private func setupViews() {
        self.navigationItem.title = "About"

        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: isDarkMode ? UIColor.white : UIColor.black]
        }
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: isDarkMode ? UIColor.orange : UIColor.black]

        // configure tableview
        tableView = UITableView(frame: view.frame, style: .plain)

        view.addSubview(tableView)
        view.addConstraintsWithFormat("V:|[v0]|", views: tableView)
        view.addConstraintsWithFormat("H:|[v0]|", views: tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.tableFooterView = UIView()
    }

    private func adjustFooterView() {
        if let tableFooterView = tableView.tableFooterView {
            let minHeight = tableFooterView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            let currentFooterHeight = tableFooterView.frame.height

            var fitHeight: CGFloat
            if #available(iOS 11.0, *) {
                fitHeight = tableView.frame.height - tableView.adjustedContentInset.top - tableView.contentSize.height + currentFooterHeight
            } else {
                fitHeight = tableView.frame.height - tableView.contentInset.top - tableView.contentSize.height + currentFooterHeight
            }
            let nextHeight = (fitHeight > minHeight) ? fitHeight : minHeight

            // No height change needed ?
            guard round(nextHeight) != round(currentFooterHeight) else { return }

            // Pinning skyline to bottom
            let skylineImageView = UIImageView()
            if isDarkMode {
                skylineImageView.image = UIImage(imageLiteralResourceName: "skyline-orange")
            } else {
                skylineImageView.image = UIImage(imageLiteralResourceName: "skyline")
            }
            skylineImageView.contentMode = .scaleAspectFit
            skylineImageView.translatesAutoresizingMaskIntoConstraints = false

            let skylineView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: nextHeight))
            skylineView.addSubview(skylineImageView)
            skylineView.backgroundColor = StyleSheet.shared.theme.secondaryBackgroundColor         
            NSLayoutConstraint.activate([
                skylineImageView.leftAnchor.constraint(equalTo: skylineView.leftAnchor),
                skylineImageView.rightAnchor.constraint(equalTo: skylineView.rightAnchor),
                skylineImageView.bottomAnchor.constraint(equalTo: skylineView.bottomAnchor, constant: 5)
            ])
            self.tableView.tableFooterView = skylineView
        }
    }
}


extension AboutViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: K.cellIdentifier)
            cell.textLabel?.font = UIFont.systemFont(ofSize: UIFont.largeSize)
            cell.textLabel?.numberOfLines = 1
            cell.textLabel?.textColor = StyleSheet.shared.theme.secondaryLabelColor
            cell.accessoryType = .disclosureIndicator
        }
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = StyleSheet.shared.theme.primaryBackgroundColor
        } else {
            cell.backgroundColor = StyleSheet.shared.theme.secondaryBackgroundColor
        }
        cell.textLabel?.text = sections[indexPath.section][indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = StyleSheet.shared.theme.secondaryBackgroundColor
        return view
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            openSafariViewController(withURL: K.codeOfConductURL)
        case (0,1):
            openSafariViewController(withURL: K.sponsorURL)
        case (0,2):
            openSafariViewController(withURL: K.faqURL)
        case (0,3):
            openSafariViewController(withURL: K.feedback)
        case (1,0):
            openSlack()
        default:
            break
        }
    }
}

// MARK: - SFSafariViewControllerDelegate
extension AboutViewController: SFSafariViewControllerDelegate {
    func openSafariViewController(withURL url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.preferredControlTintColor = StyleSheet.shared.theme.primaryLabelColor
        safariViewController.delegate = self
        present(safariViewController, animated: true, completion: nil)
    }

    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Private
extension AboutViewController {
    private func openSlack() {
        let application = UIApplication.shared
        if application.canOpenURL(K.slackURL) {
            application.open(K.slackURL, options: [:], completionHandler: nil)
        } else {
            let url = URL(string: "https://iosconfsg.slack.com")!
            openSafariViewController(withURL: url)
        }
    }

    private func showVenues() {
        let viewController = VenueViewController.init()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
