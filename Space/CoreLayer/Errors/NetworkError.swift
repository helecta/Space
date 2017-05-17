//
//  NetworkError.swift
//  Hello
//
//  Created by Liliya on 04/05/16.
//  Copyright © 2016 Peekaboo. All rights reserved.
//

import Foundation

let wrongDataNetworkErrorCode = 400

class NetworkError: AppError {
	static let NoConnection = AppError(description: "NoConnectionError".localized(), code: 1)
	static let IncorrectDataReturned = AppError(description: "IncorrectDataReturnedError".localized(), code: 2)
	static let NotReachedServer = AppError(description: "NotReachedServerError".localized(), code: 3)
	static let ConnectionLost = AppError(description: "ConnectionLostError".localized(), code: 4)
	static let InternationalRoamingOff = AppError(description: "InternationalRoamingOffError".localized(), code: 5)
	static let NotConnectedToInternet = AppError(description: "NotConnectedToInternetError".localized(), code: 6)
	static let UnauthorizedUser = AppError(description: "NotAuthorizedError".localized(), code: 401)
	
	init(userInfo: [AnyHashable: Any]?, nCode: Int) {
		super.init()
		code = nCode
		switch(code) {
		case 401:
			description = NetworkError.UnauthorizedUser.description
			return
		default:
			break
		}
	}
	
	override init() {
		super.init()
		self.domain = "NetworkErrorDomain"
	}
	
	override init(error: NSError) {
		super.init(error: error)
		
		switch(error.code) {
		case 401:
			update(NetworkError.UnauthorizedUser)
			return
		default:
			break
		}
		
		if error.domain == NSURLErrorDomain {
			switch error.code {
			case NSURLErrorUnknown:
				update(NetworkError.Unknown)
			case NSURLErrorCancelled:
				update(NetworkError.Unknown)
			case NSURLErrorBadURL:
				update(NetworkError.IncorrectDataReturned) // Because it is caused by a bad URL returned in a JSON response from the server.
			case NSURLErrorTimedOut:
				update(NetworkError.NotReachedServer)
			case NSURLErrorUnsupportedURL:
				update(NetworkError.IncorrectDataReturned)
			case NSURLErrorCannotFindHost, NSURLErrorCannotConnectToHost:
				update(NetworkError.NotReachedServer)
			case NSURLErrorDataLengthExceedsMaximum:
				update(NetworkError.IncorrectDataReturned)
			case NSURLErrorNetworkConnectionLost:
				update(NetworkError.ConnectionLost)
			case NSURLErrorDNSLookupFailed:
				update(NetworkError.NotReachedServer)
			case NSURLErrorHTTPTooManyRedirects:
				update(NetworkError.Unknown)
			case NSURLErrorResourceUnavailable:
				update(NetworkError.IncorrectDataReturned)
			case NSURLErrorNotConnectedToInternet:
				update(NetworkError.NotConnectedToInternet)
			case NSURLErrorRedirectToNonExistentLocation, NSURLErrorBadServerResponse:
				update(NetworkError.IncorrectDataReturned)
			case NSURLErrorUserCancelledAuthentication, NSURLErrorUserAuthenticationRequired:
				update(NetworkError.Unknown)
			case NSURLErrorZeroByteResource, NSURLErrorCannotDecodeRawData, NSURLErrorCannotDecodeContentData:
				update(NetworkError.IncorrectDataReturned)
			case NSURLErrorCannotParseResponse:
				update(NetworkError.IncorrectDataReturned)
			case NSURLErrorInternationalRoamingOff:
				update(NetworkError.InternationalRoamingOff)
			case NSURLErrorCallIsActive, NSURLErrorDataNotAllowed, NSURLErrorRequestBodyStreamExhausted:
				update(NetworkError.Unknown)
			case NSURLErrorFileDoesNotExist, NSURLErrorFileIsDirectory:
				update(NetworkError.IncorrectDataReturned)
			case
			NSURLErrorNoPermissionsToReadFile,
			NSURLErrorSecureConnectionFailed,
			NSURLErrorServerCertificateHasBadDate,
			NSURLErrorServerCertificateUntrusted,
			NSURLErrorServerCertificateHasUnknownRoot,
			NSURLErrorServerCertificateNotYetValid,
			NSURLErrorClientCertificateRejected,
			NSURLErrorClientCertificateRequired,
			NSURLErrorCannotLoadFromNetwork,
			NSURLErrorCannotCreateFile,
			NSURLErrorCannotOpenFile,
			NSURLErrorCannotCloseFile,
			NSURLErrorCannotWriteToFile,
			NSURLErrorCannotRemoveFile,
			NSURLErrorCannotMoveFile,
			NSURLErrorDownloadDecodingFailedMidStream,
			NSURLErrorDownloadDecodingFailedToComplete:
				update(NetworkError.Unknown)
			default:
				update(NetworkError.Unknown)
			}
		}
		else {
			update(NetworkError.Unknown)
		}
	}
}
