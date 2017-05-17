//
//  DetailViewController.swift
//  Space
//
//  Created by Liliya Fedotova on 13/05/2017.
//  Copyright © 2017 peekaboo. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Kingfisher

class DetailViewController: UIViewController, ViewControllerWithAnimateHeader {
	
	var viewModel: DetailViewModel!

	@IBOutlet private weak var imageView: UIImageView!
	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var textLabel: UILabel!
	@IBOutlet private weak var scrollView: UIScrollView!
	@IBOutlet private weak var shadowView: DetailShadowView!
	@IBOutlet private weak var downloadButton: UIButton!
	@IBOutlet private weak var spinnerView: UIView!
	
	@IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
	
	var maxHeaderHeight: CGFloat = 0
	var minHeaderHeight: CGFloat = 150
	var previousScrollOffset: CGFloat = 0
	var headerRation: CGFloat {
		return 0.7
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.titleLabel.text = viewModel.title
		self.textLabel.text = viewModel.text
		
		updateImageView(viewModel.imageUrl)
	
		viewModel.isDataLoaded.producer.startWithValues { [weak self] (isLoaded) -> () in
			if isLoaded {
				self?.updateImageView(self?.viewModel.imageUrl)
			}
		}
		
		viewModel.imageSaveState.producer.skipRepeats().startWithValues { [weak self](state) in
			switch state {
			case .startDownloading:
				self?.spinnerView.visible(isHidden: false, withAnimation: true)
				self?.downloadButton.isEnabled = false
				break
			case .error:
				self?.spinnerView.visible(isHidden: true, withAnimation: true)
				self?.downloadButton.isEnabled = true
				self?.showAlertIfNeeded()
				break
			case .imageSaved:
				self?.spinnerView.visible(isHidden: true, withAnimation: true)
				self?.showAlertIfNeeded()
				break
			default:
				break
			}
		}
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		maxHeaderHeight = headerRation * view.bounds.height
		headerHeightConstraint.constant = maxHeaderHeight
    
    scrollView.setNeedsLayout()
    scrollView.layoutIfNeeded()
		
    updateMinConstantIfNeeded()
	}
  
  override func viewDidAppear(_ animated: Bool) {
    modalPresentationCapturesStatusBarAppearance = true
    setNeedsStatusBarAppearanceUpdate()
    super.viewDidAppear(animated)
  }
  
  override var prefersStatusBarHidden : Bool {
    return true
  }
	
	//MARK: ScrollViewDelegate
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		self.animateHeaderView(scrollView)
	}

	//MARK: - ViewControllerWithAnimateHeader
	func updateHeader(_ currentHeaderHeight: CGFloat) {
		//print("Update")
	}
	
	//MARK: Actions
	
	@IBAction func swipeHeaderDown(sender: AnyObject) {
		close()
	}
	
	@IBAction func tapCloseBtn(_ sender: Any) {
		close()
	}
	
	@IBAction func tapDownloadBtn(_ sender: Any) {
		viewModel.downloadImage()
	}
	
	func close() {
		dismiss(animated: true, completion: nil)
	}
	
	func showAlertIfNeeded() {
		guard let item = viewModel.alertItem else {
			return
		}
		let ac = UIAlertController(title: item.title, message: item.text, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: item.buttonText, style: .default))
		present(ac, animated: true)
	}
	
	//MARK: Private
	fileprivate func updateMinConstantIfNeeded() {
		if scrollView.contentSize.height <= view.bounds.height - minHeaderHeight {
			let offsetForScroll: CGFloat = 10
			minHeaderHeight = view.bounds.height - scrollView.contentSize.height + offsetForScroll
		}
	}
	
	fileprivate func isContentFitAlreadyInScrollView() -> Bool {
		return scrollView.contentSize.height < scrollView.bounds.height
	}
	
	fileprivate func updateImageView(_ imageUrl: URL?) {
		guard let imageUrl = imageUrl else {
			return
		}
		let option: KingfisherOptionsInfo? = (imageView.image == nil) ? [.transition(.fade(0.3))] : nil
		let placeholder = imageView.image
		imageView.kf.setImage(with: imageUrl, placeholder: placeholder,  options: option) { [weak self] _ in
			self?.shadowView.addShadow()
		}
	}
}
