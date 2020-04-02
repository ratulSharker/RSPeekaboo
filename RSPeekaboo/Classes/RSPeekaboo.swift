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
        case cannotGetKeyWindow
    }

    public static let shared : RSPeekaboo = RSPeekaboo()
    private var mPeekabooState: RSPeekabooState = .hidden
    private var mLastShownView: UIView? = nil

    private init() {

    }

    public func peek(view: UIView, height: CGFloat) throws {
        guard self.mPeekabooState == .hidden else {
            throw RSPeekabooError.alreadyShowingAPeekaboo
        }

        guard let window = getKeyWindow() else {
            throw RSPeekabooError.cannotGetKeyWindow
        }

        self.mPeekabooState = .animating
        self.mLastShownView = view

        //Add the view as a subview to key window and attach it to the bottom of window
        window.addSubview(view)
        view.topAnchor.constraint(equalTo: window.bottomAnchor, constant: 0).isActive = true
        view.leftAnchor.constraint(equalTo: window.leftAnchor, constant: 0).isActive = true
        view.rightAnchor.constraint(equalTo: window.rightAnchor, constant: 0).isActive = true
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        window.layoutIfNeeded()

        //Shrink window to reveal the bottom attached view
        UIView.animate(withDuration: 0.5, animations: {
            window.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height - height)
            window.layoutIfNeeded()
        }) { [weak self] (_) in
            self?.mPeekabooState = .shown
        }
    }

    public func hide() throws {
        guard self.mPeekabooState == .shown else {
            throw RSPeekabooError.showingNone
        }

        guard let window = getKeyWindow() else {
            throw RSPeekabooError.cannotGetKeyWindow
        }

        self.mPeekabooState = .animating

        UIView.animate(withDuration: 0.5, animations: {
            window.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: UIScreen.main.bounds.height)
            window.layoutIfNeeded()
        }) { [weak self] (_) in
            self?.mLastShownView?.removeFromSuperview()
            self?.mPeekabooState = .hidden
        }
    }

    private func getKeyWindow() -> UIWindow? {
        return UIApplication.shared.keyWindow
    }
}
