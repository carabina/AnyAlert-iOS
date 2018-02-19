//
//  AnyAlertPresenter.swift
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


protocol AnyAlertPresentationLogic
{
    func displayAlert(response: AnyAlertAction.Display.Response)
    func dismissAlert(response: AnyAlertAction.Dismiss.Response)
}


// MARK: -

class AnyAlertPresenter
{
    // MARK: Instance variables
    
    weak var viewController: AnyAlertDisplayLogic?
    
    
    
    // MARK: Private methods
    
    private func hideAlert(startPositionY: Double, closeSpeed: Double, immediately: Bool)
    {
        let viewModel: AnyAlertAction.Dismiss.ViewModel = AnyAlertAction.Dismiss.ViewModel(
            closeSpeed: closeSpeed,
            startPositionY: startPositionY,
            immediately: immediately
        )
        self.viewController?.hideAlert(viewModel: viewModel)
    }
    
    private func updateStatusBar(id: String, immediately: Bool, hasNavBar: Bool, closeSpeed: Double, parentVcName: String, initialStatusBarStyle: UIStatusBarStyle)
    {
        guard !immediately else {
            return
        }
        guard !hasNavBar else {
            return
        }
        
        let twoThirds: Int = Int( (2.0 * closeSpeed / 3.333333) * 1000)
        let tempTime: DispatchTime = DispatchTime.now() + .milliseconds(twoThirds)
        DispatchQueue.main.asyncAfter(deadline: tempTime) {
            
            if let tempArray = AnyAlertManager.shared.alerts[parentVcName] {
                
                let tempStatusBarStyle: UIStatusBarStyle!
                let isLast: Bool = tempArray.count == 1 && tempArray[0].dataStore?.id == id
                let isFirst: Bool = tempArray.count > 1 && tempArray[tempArray.count - 1].dataStore?.id == id
                if isLast {
                    tempStatusBarStyle = initialStatusBarStyle
                } else if isFirst {
                    tempStatusBarStyle = (tempArray[tempArray.count - 2].dataStore?.statusBarStyle)!
                } else {
                    tempStatusBarStyle = (tempArray[tempArray.count - 1].dataStore?.statusBarStyle)!
                }
                
                let viewModel: AnyAlertAction.Display.ViewModel = AnyAlertAction.Display.ViewModel(
                    message: "",
                    backgroundColor: .white,
                    statusBarStyle: tempStatusBarStyle,
                    messageFont: UIFont.systemFont(ofSize: 12.0),
                    messageColor: .white,
                    closeButtonFont: UIFont.systemFont(ofSize: 12.0),
                    closeButtonColor: .white,
                    openSpeed: -1.0,
                    closeSpeed: -1.0,
                    shouldHideCloseButton: false,
                    endPositionY: -1.0
                )
                self.viewController?.setStatusBarStyle(viewModel: viewModel)
            }
        }
    }
    
    private func popAlert(id: String, immediately: Bool, delegate: AnyAlertDelegate, parentVcName: String, closeSpeed: Double)
    {
        let tempTime: DispatchTime = immediately ? DispatchTime.now() : DispatchTime.now() + closeSpeed
        DispatchQueue.main.asyncAfter(deadline: tempTime) {
            delegate.popAlert(id: id, parentVcName: parentVcName)
        }
    }
    
    
    
    // MARK: Fileprivate methods
    
    fileprivate func performDismissAlert(delegate: AnyAlertDelegate, id: String, parentVcName: String, hasNavBar: Bool, initialStatusBarStyle: UIStatusBarStyle, startPositionY: Double, closeSpeed: Double, immediately: Bool? = false)
    {
        hideAlert(startPositionY: startPositionY, closeSpeed: closeSpeed, immediately: immediately!)
        updateStatusBar(id: id, immediately: immediately!, hasNavBar: hasNavBar, closeSpeed: closeSpeed, parentVcName: parentVcName, initialStatusBarStyle: initialStatusBarStyle)
        popAlert(id: id, immediately: immediately!, delegate: delegate, parentVcName: parentVcName, closeSpeed: closeSpeed)
    }
}


// MARK: - 

extension AnyAlertPresenter: AnyAlertPresentationLogic
{
    // MARK: AnyAlertPresentationLogic
    
    func displayAlert(response: AnyAlertAction.Display.Response)
    {
        let viewModel: AnyAlertAction.Display.ViewModel = AnyAlertAction.Display.ViewModel(
            message: response.message,
            backgroundColor: response.backgroundColor,
            statusBarStyle: response.statusBarStyle,
            messageFont: response.messageFont,
            messageColor: response.messageColor,
            closeButtonFont: response.closeButtonFont,
            closeButtonColor: response.closeButtonColor,
            openSpeed: response.openSpeed,
            closeSpeed: -1.0,
            shouldHideCloseButton: response.doesSelfDismiss,
            endPositionY: response.endPositionY
        )
        
        viewController?.setStyle(viewModel: viewModel)
        
        viewController?.setMessage(viewModel: viewModel)
        
        viewController?.setCloseButtonVisibility(viewModel: viewModel)
        
        viewController?.showAlert(viewModel: viewModel)
        
        if !response.hasNavBar {
            let oneThird: Int = Int( (response.openSpeed / 3.333333) * 1000.0)
            let tempTime: DispatchTime = DispatchTime.now() + .milliseconds(oneThird)
            DispatchQueue.main.asyncAfter(deadline: tempTime) {
                self.viewController?.setStatusBarStyle(viewModel: viewModel)
            }
        }
        
        if response.doesSelfDismiss {
            let tempTime: DispatchTime = DispatchTime.now() + .milliseconds( Int(response.openSpeed * 1000.0) ) + .milliseconds( Int(response.showFor * 1000.0) )
            DispatchQueue.main.asyncAfter(deadline: tempTime) {
                self.performDismissAlert(
                    delegate: response.delegate,
                    id: response.id,
                    parentVcName: response.parentVcName,
                    hasNavBar: response.hasNavBar,
                    initialStatusBarStyle: response.initialStatusBarStyle,
                    startPositionY: response.startPositionY,
                    closeSpeed: response.closeSpeed
                )
            }
        }
    }
    
    func dismissAlert(response: AnyAlertAction.Dismiss.Response)
    {
        performDismissAlert(
            delegate: response.delegate,
            id: response.id,
            parentVcName: response.parentVcName,
            hasNavBar: response.hasNavBar,
            initialStatusBarStyle: response.initialStatusBarStyle,
            startPositionY: response.startPositionY,
            closeSpeed: response.closeSpeed,
            immediately: response.immediately
        )
    }
}
