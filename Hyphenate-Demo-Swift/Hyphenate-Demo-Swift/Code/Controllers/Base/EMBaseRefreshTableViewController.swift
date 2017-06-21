//
//  EMBaseRefreshTableViewController.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/6/13.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import UIKit
import MJRefresh

class EMBaseRefreshTableViewController: UITableViewController {
    
    public var defaultFooterView: UIView?
    public var _showRefreshHeader: Bool = false
    public var _showRefreshFooter: Bool = false
    
    lazy var dataArray: Array<Any>? = {()-> Array<Any> in let tempArray = Array<Any>()
        return tempArray
    }()
    
    public var page: Int = 0
    
    public var showRefreshHeader: Bool{
        get {
            return _showRefreshHeader
        }
        
        set {
            if newValue != _showRefreshHeader {
                _showRefreshHeader = newValue
                if _showRefreshHeader {
                    self.tableView.mj_header = MJRefreshNormalHeader (refreshingBlock: {
                        self.tableViewDidTriggerHeaderRefresh()
                    })
                    tableView.mj_header.accessibilityIdentifier = "refresh_header"
                } else {
                    tableView.mj_header = nil
                }
            }
        }
    }
    
    public var showRefreshFooter: Bool{
        get {
            return _showRefreshFooter
        }
        
        set {
            if newValue != _showRefreshFooter {
                _showRefreshFooter = newValue
                if _showRefreshFooter {
                    self.tableView.mj_footer = MJRefreshBackNormalFooter (refreshingBlock: {
                        
                    })
                    tableView.mj_footer.accessibilityIdentifier = "refresh_footer"
                } else {
                    tableView.mj_footer = nil
                }
            }
        }
    }
    
    
    fileprivate var footRefreshControl: UIRefreshControl?
    
    init() {
        super.init(style: UITableViewStyle.grouped)
        defaultFooterView = UIView()
    }
    
    override init(style: UITableViewStyle) {
        super.init(style:style)
        defaultFooterView = UIView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showRefreshHeader = true
        showRefreshFooter = false
        
        tableView.tableFooterView = defaultFooterView
    }
    
    // MARK: - public refresh
    func tableViewDidTriggerHeaderRefresh() {
        
    }
    
    func tableViewDidTriggerFooterRefresh() {
        
    }
    
    func tableViewDidFinishTriggerHeader(isHeader: Bool) {
        DispatchQueue.main.async {
            if isHeader {
                self.tableView.mj_header.endRefreshing()
            } else {
                self.tableView.mj_footer.endRefreshing()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}