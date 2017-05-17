//
//  FeedViewController.swift
//  Space
//
//  Created by Liliya Fedotova on 12/05/2017.
//  Copyright © 2017 peekaboo. All rights reserved.
//

/**
	Design: https://dribbble.com/shots/3216948-Stock-Image-Website
*/

import UIKit
import ReactiveCocoa

class FeedViewController: UIViewController {
	
	var viewModel = FeedViewModel()
	
	@IBOutlet fileprivate weak var spinner: UIActivityIndicatorView!
	@IBOutlet fileprivate weak var tableView: UITableView!
	@IBOutlet fileprivate weak var emptyView: EmptyView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		bindViewModel()
	}
  
  override var prefersStatusBarHidden : Bool {
    return false
  }
	
	fileprivate func bindViewModel() {
		viewModel.dataState.producer.skipRepeats().startWithValues { [weak self] (state) -> () in
			guard let viewModel = self?.viewModel else {
				return
			}
			self?.emptyView.labelText = viewModel.emptyLabelText
			self?.emptyView.isHidden = viewModel.isEmptyViewHidden
			self?.spinner.visible(isHidden: viewModel.isSpinnerViewHidden, withAnimation: true)
			self?.tableView.visible(isHidden: viewModel.isTableViewHidden,
			                        withAnimation: viewModel.shouldAnimateTableViewHidden)
			if viewModel.shouldReloadTable {
				DispatchQueue.main.async {  [weak self] _ in
					self?.tableView.reloadData()
				}
			}
		}
	}
	
	fileprivate func presentDetail(post: Post) {
		if presentedViewController != nil {
			return
		}
		guard let detailVC = UIStoryboard(name: StoryboardName.Details.rawValue, bundle: nil).instantiateViewController(withIdentifier: ViewControllerIdentifier.DetailViewController.rawValue) as? DetailViewController else { return }
		detailVC.modalPresentationStyle = .overCurrentContext
		//detailVC.transitioningDelegate = self
		detailVC.viewModel = DetailViewModel(post: post)
    DispatchQueue.main.async { [weak self, detailVC] _ in
      self?.present(detailVC, animated: true, completion: nil)
    }
	}
}

//MARK: Table
extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return self.viewModel.numberOfSections()
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.viewModel.numberOfItemsAtSection(section)
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
	
	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return 300.0
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return UITableViewAutomaticDimension
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cellItem = viewModel.cellItemAtIndexPath(indexPath) else {
      return UITableViewCell()
    }
		guard let cell = tableView.dequeueReusableCell(withIdentifier: cellItem.cellReuseIdentifier) as? BaseCell else {
			return UITableViewCell()
		}
		cell.cellItem = cellItem
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let cellItem = viewModel.cellItemAtIndexPath(indexPath), let post = cellItem.relatedObject as? Post  else {
			return
		}
		presentDetail(post: post)
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if viewModel.shouldLoadNext(indexPath) {
			viewModel.loadData()
		}
	}
}

