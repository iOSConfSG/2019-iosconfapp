//
//  AboutViewController.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 10/11/18.
//  Copyright © 2018 Vina Melody. All rights reserved.
//

import UIKit
import SafariServices

class AboutViewController: UITableViewController {
    private struct K {
        static let codeOfConductURL: URL! = URL.init(string: "https://2020.iosconf.sg/cod/")
        static let sponsorURL: URL! = URL.init(string: "https://2020.iosconf.sg/#sponsors")
        static let slackURL: URL! = URL(string: "slack://open")
        static let faqURL: URL! = URL(string: "https://2020.iosconf.sg/faq/")
        static let feedback: URL! = URL(string: "http://bit.ly/iosconfsg2020")

        static let cellIdentifier = "AboutCell"
    }

    private var sections: [[String]] = [["Code of Conduct", "Venue", "Sponsors", "FAQ", "Feedback"], ["Open Slack"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        self.navigationItem.title = "About"
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }

        // configure tableview
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = UIEdgeInsets.zero

        // add skyline view
        let skylineView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 70))
        skylineView.image = UIImage(imageLiteralResourceName: "skyline")
        skylineView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        skylineView.contentMode = .scaleAspectFill
        tableView.tableFooterView = skylineView
    }
}


extension AboutViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: K.cellIdentifier)
            cell.textLabel?.font = UIFont.systemFont(ofSize: UIFont.largeSize)
            cell.textLabel?.numberOfLines = 1
            cell.textLabel?.textColor = UIColor.black
            cell.accessoryType = .disclosureIndicator
        }
        cell.textLabel?.text = sections[indexPath.section][indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.init(hex: 0xF3F6F7)
        return view
    }
}

extension AboutViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch (indexPath.section, indexPath.row) {
        case (0,0):
            openSafariViewController(withURL: K.codeOfConductURL)
        case (0,1):
            showVenues()
        case (0,2):
            openSafariViewController(withURL: K.sponsorURL)
        case (0,3):
            openSafariViewController(withURL: K.faqURL)
        case (0,4):
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
        safariViewController.preferredControlTintColor = .purple
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
        let viewController = VenueViewController.init(style: .plain)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
