//  Project name: Dice
//  File name   : EAGLView.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 8/21/17
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright © 2017 BurtK. All rights reserved.
//  --------------------------------------------------------------

import GLKit


public final class FwiEAGLView: GLKView {

    // MARK: Class's properties
    fileprivate var currentContext: EAGLContext?

    // MARK: Class's constructors
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    // MARK: Class's public methods
    /// Apply current context to global EAGLContext.
    public func applyContext() {
        guard currentContext == nil else {
            return
        }

        currentContext = EAGLContext.current()
        if currentContext != context {
            EAGLContext.setCurrent(context)
        }
    }

    /// Restore global EAGLContext to previous context.
    public func restoreContext() {
        guard let c = currentContext, c != context else {
            return
        }
        EAGLContext.setCurrent(c)
        currentContext = nil
    }

    // MARK: Class's private methods
    fileprivate func initialize() {
        // Initialize OpenGLES3
        guard let c = EAGLContext(api: .openGLES3) else {
            debugPrint("There was an error during initializing EAGLContext!")
            return
        }
        context = c

        // Set scale factor to native scale
        contentScaleFactor = UIScreen.main.nativeScale

        // Define drawable
        drawableColorFormat = GLKViewDrawableColorFormat.RGBA8888
        drawableDepthFormat = GLKViewDrawableDepthFormat.format24
        drawableStencilFormat = GLKViewDrawableStencilFormat.format8
        drawableMultisample = GLKViewDrawableMultisample.multisample4X

        // Define render buffer storage
        guard let eaglLayer = layer as? CAEAGLLayer else {
            debugPrint("There was an error during initializing CAEAGLLayer!")
            return
        }

        eaglLayer.isOpaque = true
        eaglLayer.drawableProperties = [kEAGLDrawablePropertyColorFormat:kEAGLColorFormatRGBA8,
                                        kEAGLDrawablePropertyRetainedBacking:NSNumber(value: false)]
    }
}

// MARK: Class's static properties
public extension FwiEAGLView {

    public override class var layerClass: AnyClass {
        return CAEAGLLayer.self
    }
}
