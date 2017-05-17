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

class DetailViewController: UIViewController {
	
	var viewModel: DetailViewModel!

	@IBOutlet private weak var imageView: UIImageView!
	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var textLabel: UILabel!
	@IBOutlet private weak var scrollView: UIScrollView!
	@IBOutlet private weak var shadowView: DetailShadowView!
	@IBOutlet private weak var downloadButton: UIButton!
	@IBOutlet private weak var spinnerView: UIView!
	
	@IBOutlet private weak var headerHeightConstraint: NSLayoutConstraint!
	
	private var _maxHeaderHeight: CGFloat = 0
	private var _minHeaderHeight: CGFloat = 150
	private var _previousScrollOffset: CGFloat = 0
	private let _imageRation: CGFloat = 0.7
	
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
		
		_maxHeaderHeight = _imageRation * view.bounds.height
		headerHeightConstraint.constant = _maxHeaderHeight
    
    scrollView.setNeedsLayout()
    scrollView.layoutIfNeeded()
    if scrollView.contentSize.height <= view.bounds.height - _minHeaderHeight {
      let offsetForScroll: CGFloat = 10
      _minHeaderHeight = view.bounds.height - scrollView.contentSize.height + offsetForScroll
    }
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
		let scrollDiff = scrollView.contentOffset.y - _previousScrollOffset
		
		let absoluteTop: CGFloat = 0
		let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
		
		let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
		let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom
		
		if canAnimateHeader(scrollView) {
			
			// Calculate new header height
			var newHeight = headerHeightConstraint.constant
			if isScrollingDown {
				newHeight = max(_minHeaderHeight, headerHeightConstraint.constant - abs(scrollDiff))
			} else if isScrollingUp && scrollView.contentOffset.y < 0 {
				newHeight = min(_maxHeaderHeight, headerHeightConstraint.constant + abs(scrollDiff))
			}
			
			// Header needs to animate
			if newHeight != headerHeightConstraint.constant {
				headerHeightConstraint.constant = newHeight
				updateHeader()
				setScrollPosition(_previousScrollOffset)
			}
			
			_previousScrollOffset = scrollView.contentOffset.y
		}
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
	
	fileprivate func updateHeader() {
	}
	
	fileprivate func canAnimateHeader(_ scrollView: UIScrollView) -> Bool {
		let scrollViewMinHeight = scrollView.frame.height + headerHeightConstraint.constant - _maxHeaderHeight
		return scrollView.contentSize.height > scrollViewMinHeight
	}
	
	fileprivate func setScrollPosition(_ position: CGFloat) {
		scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: position)
	}
}
