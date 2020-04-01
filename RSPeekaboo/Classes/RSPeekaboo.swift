//
//
//  Created by Ratul Sharker on 2/4/20.
//

import Foundation
import UIKit


public class RSPeekaboo {
    
    public enum RSPeekabooState {
        case hidden
        case animating
        case shown
    }
    
    public enum RSPeekabooError: Error {
        case alreadyShowingAPeekaboo
        case showingNone
        case cannotGetRootView
    }
    
    public static let shared : RSPeekaboo = RSPeekaboo()
    private var mPeekabooState: RSPeekabooState = .hidden
    private var mLastShownView: UIView? = nil
    
    private init() {
        
    }

    public func peek(view: UIView, height: CGFloat) throws {
        guard mPeekabooState == .hidden else {
            throw RSPeekabooError.alreadyShowingAPeekaboo
        }

        guard let rootView = getRootViewControllerView() else {
            throw RSPeekabooError.cannotGetRootView
        }
        
        // log
        mPeekabooState = .animating
        mLastShownView = view
        
        let initialRootViewFrame = rootView.frame
        let finalRootViewSize = CGSize(width: initialRootViewFrame.width, height: initialRootViewFrame.height - height)
        let finalRootViewFrame = CGRect(origin: initialRootViewFrame.origin, size: finalRootViewSize)
        
        
        view.frame = CGRect(x: 0, y: initialRootViewFrame.maxY, width: initialRootViewFrame.width, height: height)
        let finalViewFrame = CGRect(x: 0, y: initialRootViewFrame.maxY - height, width: initialRootViewFrame.width, height: height)
        
        // added as subview
        rootView.superview?.addSubview(view)

        rootView.setNeedsLayout()
        
        UIView.animate(withDuration: 0.5, animations: { // Allow customizing times
            rootView.frame = finalRootViewFrame
            view.frame = finalViewFrame
            rootView.layoutIfNeeded()
        }) { (finished) in
            // Use weak reference
            self.mPeekabooState = .shown
        }
    }
    
    public func hide() throws {
        guard mPeekabooState == .shown else {
            throw RSPeekabooError.showingNone
        }

        guard let rootView = getRootViewControllerView() else {
            throw RSPeekabooError.cannotGetRootView
        }
        
        mPeekabooState = .animating
        
        let finalRootViewFrame = rootView.superview?.bounds ?? .zero
        
        let finalViewOrigin = CGPoint(x: 0, y: finalRootViewFrame.maxY)
        let finalViewFrame = CGRect(origin: finalViewOrigin, size: mLastShownView?.frame.size ?? CGSize.zero)
        
        rootView.setNeedsLayout()
        
        UIView.animate(withDuration: 0.5,
                       animations: {
                        rootView.frame = finalRootViewFrame
                        self.mLastShownView?.frame = finalViewFrame // Use weak reference
                        rootView.layoutIfNeeded()
        }) { (finished) in
            // Use weak reference
            self.mLastShownView?.removeFromSuperview()
            self.mPeekabooState = .hidden
        }
    }
    
    private func getRootViewControllerView() -> UIView? {
        return UIApplication.shared.delegate?.window??.rootViewController?.view
    }
}

