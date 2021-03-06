//
//  AnyAlertInteractor.swift
//  AnyApp
//
//  Created by Chris Allinson on 2018-01-20.
//  Copyright (c) 2018 Chris Allinson. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit


protocol AnyAlertBusinessLogic
{
    func displayAlert(request: AnyAlertAction.Display.Request)
    func dismissAlert(request: AnyAlertAction.Dismiss.Request)
}

protocol AnyAlertDataStore
{
    var delegate: AnyAlertDelegate! { get set }
    
    var id: String { get set }
    var message: String { get set }
    var backgroundColor: UIColor! { get set }
    var messageFont: UIFont! { get set }
    var messageColor: UIColor! { get set }
    var closeButtonFont: UIFont! { get set }
    var closeButtonColor: UIColor! { get set }
    var parentVcName: String { get set }
    var initialStatusBarStyle: UIStatusBarStyle! { get set }
    var doesSelfDismiss: Bool! { get set }
    
    var height: Double! { get set }
    
    var statusBarStyle: UIStatusBarStyle! { get set }
    
    var hasNavBar: Bool! { get set }
    var startPositionY: Double! { get set }
    var endPositionY: Double! { get set }
    
    var openSpeed: Double! { get set }
    var closeSpeed: Double! { get set }
    var showFor: Double! { get set }
    
    var tapHandler: (() -> Void)? { get set }
}


// MARK: -

class AnyAlertInteractor: AnyAlertDataStore
{
    // MARK: Instance variables
    
    var presenter: AnyAlertPresentationLogic?
    
    
    
    // MARK: AnyAlertDataStore
    
    var delegate: AnyAlertDelegate!
    
    var id: String = ""
    var message: String = ""
    var backgroundColor: UIColor!
    var messageFont: UIFont!
    var messageColor: UIColor!
    var closeButtonFont: UIFont!
    var closeButtonColor: UIColor!
    var parentVcName: String = ""
    var initialStatusBarStyle: UIStatusBarStyle!
    var doesSelfDismiss: Bool!
    
    var height: Double!
    
    var statusBarStyle: UIStatusBarStyle!
    
    var hasNavBar: Bool!
    var startPositionY: Double!
    var endPositionY: Double!
    
    var openSpeed: Double!
    var closeSpeed: Double!
    var showFor: Double!
    
    var tapHandler: (() -> Void)?
}


// MARK: -

extension AnyAlertInteractor: AnyAlertBusinessLogic
{
    // MARK: AnyAlertBusinessLogic
    
    func displayAlert(request: AnyAlertAction.Display.Request)
    {
        let tempResponse: AnyAlertAction.Display.Response = AnyAlertAction.Display.Response(
            delegate: request.delegate,
            id: request.id,
            message: request.message,
            backgroundColor: request.backgroundColor,
            statusBarStyle: request.statusBarStyle,
            messageFont: request.messageFont,
            messageColor: request.messageColor,
            closeButtonFont: request.closeButtonFont,
            closeButtonColor: request.closeButtonColor,
            openSpeed: request.openSpeed,
            closeSpeed: request.closeSpeed,
            doesSelfDismiss: request.doesSelfDismiss,
            showFor: request.showFor,
            hasNavBar: request.hasNavBar,
            parentVcName: request.parentVcName,
            initialStatusBarStyle: request.initialStatusBarStyle,
            startPositionY: request.startPositionY,
            endPositionY: request.endPositionY
        )
        presenter?.displayAlert(response: tempResponse)
    }
    
    func dismissAlert(request: AnyAlertAction.Dismiss.Request)
    {
        let tempResponse: AnyAlertAction.Dismiss.Response = AnyAlertAction.Dismiss.Response(
            delegate: request.delegate,
            id: request.id,
            closeSpeed: request.closeSpeed,
            hasNavBar: request.hasNavBar,
            parentVcName: request.parentVcName,
            initialStatusBarStyle: request.initialStatusBarStyle,
            startPositionY: request.startPositionY,
            immediately: request.immediately
        )
        presenter?.dismissAlert(response: tempResponse)
    }
}
