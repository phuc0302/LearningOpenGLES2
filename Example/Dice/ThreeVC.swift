//  Project name: Dice
//  File name   : ThreeVC.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 8/21/17
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright © 2017 BurtK. All rights reserved.
//  --------------------------------------------------------------

import GLKit
import FwiOpenGLES


final class ThreeVC: GLKViewController, FwiShaderLoader, FwiTextureLoader, FwiPixelBufferLoader {


    @IBOutlet var glView: FwiEAGLView!
    /// View model
    @IBOutlet var viewModel: ThreeVM!

    // MARK: Class's properties
    var textureCache: CVOpenGLESTextureCache?

    fileprivate var capture: CaptureManager?
    /// Meshs.
    fileprivate var modelMatrix = GLKMatrix4MakeTranslation(0, 0, -9)
    fileprivate var background: BackgroundMesh?
    fileprivate var cube: CubeMesh?

    deinit {
        flush()

        cube?.releaseShader()
        background?.releaseShader()
    }

    // MARK: View's lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        visualize()

        glView.applyContext()
        defer { glView.restoreContext() }

        let (p, v, f) = compile(vertexShader: "TextureVertexShader.vsh", fragmentShader: "TextureFragmentShader.fsh", fromBundle: Bundle(identifier: "com.fiision.lib.FwiOpenGLES"))

        background = BackgroundMesh()
        background?.program = p
        background?.vertexShader = v
        background?.fragmentShader = f

        cube = CubeMesh()
        cube?.program = p
        cube?.vertexShader = v
        cube?.fragmentShader = f
        cube?.texture = loadTexture(filename: "dice.png")
        cube?.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(85.0),
                                                           GLfloat(self.view.bounds.size.width / self.view.bounds.size.height),
                                                           0.000001,
                                                           1000)

        // Initialize texture cache
        let err = CVOpenGLESTextureCacheCreate(kCFAllocatorDefault, nil, glView.context, nil, &textureCache)
        if err != noErr {
            debugPrint("There was an error during initializing CVOpenGLESTextureCache! (\(err))")
        }

        // Get capture output
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            let height = 1080
            let width = 1920
        #else
            // Initialize capture
            capture = CaptureManager()
            capture?.delegate = self

            guard
                let settings = capture?.captureOutput?.videoSettings as? [String:Any],
                let height = settings["Height"] as? Int,
                let width = settings["Width"] as? Int
                else {
                    return
            }
        #endif

        viewModel.cameraHeight = Float(height)
        viewModel.cameraWidth = Float(width)
        viewModel.constructCameraMatrix()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        localize()

        isPaused = false
        preferredFramesPerSecond = 60
        capture?.session.startRunning()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        isPaused = true
        capture?.session.stopRunning()
    }

    // MARK: View's orientation handler
    open override var shouldAutorotate: Bool {
        return true
    }
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            return .all
        } else {
            return [.portrait, .portraitUpsideDown]
        }
    }
    
    // MARK: View's status handler
    open override var prefersStatusBarHidden: Bool {
        return false
    }
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: View's transition event handler
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // TODO: Transfer data between views during presentation here.
    }

    // MARK: Class's public methods
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glView.applyContext()
        defer { glView.restoreContext() }

//        glView.applyFrameBuffer()
//        defer { glView.applyRenderBuffer() }

        glClearColor(0.0, 0.0, 0.0, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
        glViewport(GLint(0.0), GLint(0.0), GLsizei(glView.drawableWidth), GLsizei(glView.drawableHeight))

        glEnable(GLenum(GL_DEPTH_TEST))
        glEnable(GLenum(GL_CULL_FACE))
        glEnable(GLenum(GL_BLEND))
        glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA))

        
//        let h = -2.0 / Float(view.bounds.height)
//        let w = -2.0 / Float(view.bounds.width)
//        let proj = [
//            Float(0.0),          w, Float(0.0), Float(0.0),
//                     h, Float(0.0), Float(0.0), Float(0.0),
//            Float(0.0), Float(0.0), Float(1.0), Float(0.0),
//            Float(1.0), Float(1.0), Float(0.0), Float(1.0)
//        ]
//
//        glMatrixMode(GLenum(GL_PROJECTION))
//        glLoadMatrixf(proj)
//
//        let squareVertices: [GLfloat] = [
//            0, 0,
//            w, 0,
//            0, h,
//            w, h
//        ]
//        let textureVertices: [GLfloat] = [
//            1, 0,
//            1, 1,
//            0, 0,
//            0, 1
//        ]
//
//        if let t = background?.texture, let p = background?.program, let u = background?.textureUniform {
//            glMatrixMode(GLenum(GL_MODELVIEW))
//            glLoadIdentity()
//
//            glDepthMask(GLboolean(GL_FALSE))
//            glDisable(GLenum(GL_COLOR_MATERIAL))
//            glUseProgram(p)
//
//            glActiveTexture(GLenum(GL_TEXTURE0))
//            glBindTexture(CVOpenGLESTextureGetTarget(t), CVOpenGLESTextureGetName(t))
//            glUniform1i(u, 0)
//
//            // Update attribute values.
//            glVertexPointer(2, GLenum(GL_FLOAT), 0, squareVertices)
//            glEnableClientState(GLenum(GL_VERTEX_ARRAY))
//            glTexCoordPointer(2, GLenum(GL_FLOAT), 0, textureVertices)
//            glEnableClientState(GLenum(GL_TEXTURE_COORD_ARRAY))
//
//            glColor4f(1,1,1,1)
//            glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, 4)
//        }

//        background?.projectionMatrix = buildProjectionMatrix()
        background?.renderModel()
//
//        cube?.update(withDelta: 0.1)
//        let viewMatrix = GLKMatrix4Multiply(modelMatrix, GLKMatrix4MakeTranslation(0, 0, -2))
////
//        cube?.projectionMatrix = buildProjectionMatrix()
        cube?.renderModel(withParentMatrix: modelMatrix)


//        glView.context.presentRenderbuffer(Int(GL_RENDERBUFFER))
    }
}

// MARK: View's key pressed event handlers
fileprivate extension ThreeVC {

    @IBAction func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let touch = gesture.location(in: view)

        switch gesture.state {
        case .began:
            modelMatrix = viewModel.constructWorldPosition(fromScreenPosition: touch)

        case .changed:
            modelMatrix = viewModel.constructWorldPosition(fromScreenPosition: touch)

        case .cancelled, .ended:
            modelMatrix = viewModel.constructWorldPosition(fromScreenPosition: touch)

        default:
            // Do nothing.
            break
        }
    }

    fileprivate func buildProjectionMatrix() -> GLKMatrix4 {
        var projectionMatrix = cube?.projectionMatrix ?? GLKMatrix4Identity
        let near: GLfloat = 0.01
        let far: GLfloat = 100

        // Camera parameters
        let f_x: GLfloat = 6.24860291e+02
        let f_y: GLfloat = 6.24860291e+02
        let c_x: GLfloat = viewModel.cameraWidth * 0.5
        let c_y: GLfloat = viewModel.cameraHeight * 0.5

        projectionMatrix.m00 = -2.0 * f_x / GLfloat(view.bounds.width)
//        projectionMatrix.m01 = 0.0
//        projectionMatrix.m02 = 0.0
//        projectionMatrix.m03 = 0.0

//        projectionMatrix.m10 = 0.0
        projectionMatrix.m11 = 2.0 * f_y / GLfloat(view.bounds.height)
//        projectionMatrix.m12 = 0.0
//        projectionMatrix.m13 = 0.0

        projectionMatrix.m20 = 2.0 * c_x / GLfloat(view.bounds.width) - 1.0
        projectionMatrix.m21 = 2.0 * c_y / GLfloat(view.bounds.height) - 1.0
        projectionMatrix.m22 = -(far + near) / (far - near)
        projectionMatrix.m23 = -1.0

//        projectionMatrix.m30 = 0.0
//        projectionMatrix.m31 = 0.0
        projectionMatrix.m32 = -2.0 * far * near / (far - near)
//        projectionMatrix.m33 = 0.0
        return projectionMatrix
    }
}

// MARK: Class's private methods
fileprivate extension ThreeVC {

    fileprivate func localize() {
        // TODO: Localize view's here.
    }
    fileprivate func visualize() {
        // TODO: Visualize view's here.
    }
}

// MARK: `CaptureManagerDelegate`'s members
extension ThreeVC: CaptureManagerDelegate {

    // MARK: Class's public methods
    func onFrameReady(frame: CVImageBuffer) {
        viewModel.validateFrame(frame)

        // Bind buffer
        DispatchQueue.main.sync {
            background?.texture = bind(pixelBuffer: frame)
        }
    }
}
