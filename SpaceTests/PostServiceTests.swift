//
//  PostServiceTests.swift
//  Space
//
//  Created by Liliya Fedotova on 16/05/2017.
//  Copyright © 2017 peekaboo. All rights reserved.
//

import XCTest
@testable import Space

class PostServiceTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testSuccessUpdatePosts() {
		let apiWrapper = PostApiWrapperMock(withType: .success)
		let postService = PostService(apiWrapper: apiWrapper)
		let promise = expectation(description: "Posts update successfully")
	
		postService.updatePosts(page: 0) { (posts, error) in
			if let error = error {
				XCTFail("Error: \(error.localizedDescription)")
				return
			} else if posts != nil {
				promise.fulfill()
				if let post = posts?.first {
					XCTAssert(post == apiWrapper.successPost)
				} else {
					XCTFail("No posts")
				}
			}
		}
		
		waitForExpectations(timeout: 5, handler: nil)
	}
	
	func testEmpyUpdatePosts() {
		let apiWrapper = PostApiWrapperMock(withType: .empty)
		let postService = PostService(apiWrapper: apiWrapper)
		let promise = expectation(description: "Posts empty")
		
		postService.updatePosts(page: 0) { (posts, error) in
			if let error = error {
				XCTFail("Error: \(error.localizedDescription)")
				return
			} else if let posts = posts {
				XCTAssert(posts.count == 0, "No posts")
				promise.fulfill()
			}
		}
		
		waitForExpectations(timeout: 5, handler: nil)
	}
	
	func testErrorUpdatePosts() {
		let apiWrapper = PostApiWrapperMock(withType: .error)
		let postService = PostService(apiWrapper: apiWrapper)
		let promise = expectation(description: "Posts update with error")
		
		postService.updatePosts(page: 0) { (posts, error) in
			if error != nil {
				promise.fulfill()
				return
			} else {
				XCTFail("No error")
			}
		}
		
		waitForExpectations(timeout: 5, handler: nil)
	}
	
	func testIncorrectUpdatePosts() {
		let apiWrapper = PostApiWrapperMock(withType: .incorrect)
		let postService = PostService(apiWrapper: apiWrapper)
		let promise = expectation(description: "Posts update with error")
		
		postService.updatePosts(page: 0) { (posts, error) in
			if let error = error {
				XCTFail("Error: \(error.localizedDescription)")
				return
			} else if let posts = posts {
				XCTAssert(posts.count == 0, "No posts")
				promise.fulfill()
			}
		}
		
		waitForExpectations(timeout: 5, handler: nil)
	}

    
}
