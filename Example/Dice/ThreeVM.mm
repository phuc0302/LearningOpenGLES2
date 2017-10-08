/// Include OpenCV.
#import <opencv2/opencv.hpp>
//#import "BGRAVideoFrame.h"
//#import "CameraCalibration.hpp"
//#import "MarkerDetector.hpp"
/// Project.
#import <GLKit/GLKit.h>
#import <UIKit/UIKit.h>
//#import <Accelerate/Accelerate.h>
#import "ThreeVM.h"


@interface ThreeVM () {

//    Transformation _t;
//    std::vector<cv::Point3f> corners3D_;
//    cv::Mat distorsionCoeff_;
//    cv::Mat cameraMatrix_;
}

//@property (nonatomic) MarkerDetector *markerDetector;

@end


@implementation ThreeVM


#pragma mark - Class's constructors
- (instancetype)init {
    self = [super init];
    if (self) {
//        corners3D_.push_back(cv::Point3f(-0.5f,-0.5f,0));
//        corners3D_.push_back(cv::Point3f(+0.5f,-0.5f,0));
//        corners3D_.push_back(cv::Point3f(+0.5f,+0.5f,0));
//        corners3D_.push_back(cv::Point3f(-0.5f,+0.5f,0));
    }
    return self;
}

#pragma mark - Cleanup memory
- (void)dealloc {
//    corners3D_.clear();
//    delete _markerDetector;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

#pragma mark - Class's public methods
- (void)constructCameraMatrix {
//    CameraCalibration _c = CameraCalibration(6.24860291e+02 * (_cameraWidth/352.), 6.24860291e+02 * (_cameraHeight/288.), _cameraWidth * 0.5f, _cameraHeight * 0.5f);
//    if (_markerDetector != nil) {
//        delete _markerDetector;
//    }

//    _markerDetector = new MarkerDetector();

//    float_t cameraMatrix[9] = {6.24860291e+02, 0.0, _cameraWidth * 0.5f, 0.0, 6.24860291e+02, _cameraHeight * 0.5f, 0.0, 0.0, 1.0};
//    float_t distorsionCoeff[5] = {1.61426172e-01, -5.95113218e-01, 7.10574386e-04, -1.91498715e-02, 1.66041708e+00};
//
//    distorsionCoeff_ = cv::Mat(4,1, CV_32F, distorsionCoeff);
//    cameraMatrix_ = cv::Mat(3, 3, CV_32F, cameraMatrix);
}

- (void)validateFrame:(CVImageBufferRef)frame {
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(frame);
    size_t width = CVPixelBufferGetWidth(frame);
    size_t height = CVPixelBufferGetHeight(frame);
//    size_t currSize = bytesPerRow*height*sizeof(unsigned char);
//    size_t bytesPerRowOut = 4*height*sizeof(unsigned char);

    void *srcBuff = CVPixelBufferGetBaseAddress(frame);
//    unsigned char *outBuff = (unsigned char*)malloc(currSize);
//
//    vImage_Buffer ibuff = { srcBuff, height, width, bytesPerRow};
//    vImage_Buffer ubuff = { outBuff, width, height, bytesPerRowOut};
//
//    uint8_t rotConst = 3;   // 0, 1, 2, 3 is equal to 0, 90, 180, 270 degrees rotation
//
//    uint8_t bgColor[4]                  = {0, 0, 0, 0};
//    vImage_Error err= vImageRotate90_ARGB8888(&ibuff, &ubuff, rotConst, bgColor,0);
//    if (err != kvImageNoError) NSLog(@"%ld", err);


    //    /*Get information about the image*/
    //    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
    //    size_t width = CVPixelBufferGetWidth(imageBuffer);
    //    size_t height = CVPixelBufferGetHeight(imageBuffer);
    //    size_t stride = CVPixelBufferGetBytesPerRow(imageBuffer);

//    BGRAVideoFrame videoFrame;
//    videoFrame.width = width;
//    videoFrame.height = height;
//    videoFrame.stride = bytesPerRow;
//    videoFrame.data = (unsigned char*)srcBuff;
//
////    BGRAVideoFrame frame = {height, width, bytesPerRow, srcBuff};
//    _markerDetector->processFrame(videoFrame);
//
//    if (_markerDetector->getTransformations().size() > 0) {
//        _t = _markerDetector->getTransformations()[0];
//    }
}

//- (void)buildProjectionMatrix:(Matrix33)cameraMatrix width: (int)screen_width height: (int)screen_height projectionMatrix: (Matrix44&) projectionMatrix
//{
//    float near = 0.01;  // Near clipping distance
//    float far  = 100;  // Far clipping distance
//
//    // Camera parameters
//    float f_x = cameraMatrix.data[0]; // Focal length in x axis
//    float f_y = cameraMatrix.data[4]; // Focal length in y axis (usually the same?)
//    float c_x = cameraMatrix.data[2]; // Camera primary point x
//    float c_y = cameraMatrix.data[5]; // Camera primary point y
//
//    projectionMatrix.data[0] = - 2.0 * f_x / screen_width;
//    projectionMatrix.data[1] = 0.0;
//    projectionMatrix.data[2] = 0.0;
//    projectionMatrix.data[3] = 0.0;
//
//    projectionMatrix.data[4] = 0.0;
//    projectionMatrix.data[5] = 2.0 * f_y / screen_height;
//    projectionMatrix.data[6] = 0.0;
//    projectionMatrix.data[7] = 0.0;
//
//    projectionMatrix.data[8] = 2.0 * c_x / screen_width - 1.0;
//    projectionMatrix.data[9] = 2.0 * c_y / screen_height - 1.0;
//    projectionMatrix.data[10] = -( far+near ) / ( far - near );
//    projectionMatrix.data[11] = -1.0;
//
//    projectionMatrix.data[12] = 0.0;
//    projectionMatrix.data[13] = 0.0;
//    projectionMatrix.data[14] = -2.0 * far * near / ( far - near );
//    projectionMatrix.data[15] = 0.0;
//}

- (GLKMatrix4)constructWorldPositionFromScreenPosition:(CGPoint)point {
//    cv::Mat_<float> Tvec;
//    cv::Mat Rvec;
//
//    std::vector<cv::Point2f> points;
//    points.push_back(cv::Point2f(point.x - 20, point.y - 20));
//    points.push_back(cv::Point2f(point.x + 20, point.y - 20));
//    points.push_back(cv::Point2f(point.x + 20, point.y + 20));
//    points.push_back(cv::Point2f(point.x - 20, point.y + 20));
//
//    cv::Mat raux,taux;
//    cv::solvePnP(corners3D_, points, cameraMatrix_, distorsionCoeff_,raux,taux);
//
//
//    raux.convertTo(Rvec,CV_32F);
//    taux.convertTo(Tvec ,CV_32F);
//
//    cv::Mat_<float> rotMat(3,3);
//    cv::Rodrigues(Rvec, rotMat);
//
//    // Copy to transformation matrix
//    Transformation transformation;
//    for (int8_t col = 0; col < 3; col++) {
//        for (int8_t row = 0; row < 3; row++) {
//            transformation.r().mat[row][col] = rotMat(row,col); // Copy rotation component
//        }
////        transformation.t().data[col] = Tvec(col);               // Copy translation component
//    }
//
//    // Since solvePnP finds camera location, w.r.t to marker pose, to get marker pose w.r.t to the camera we invert it.
//    transformation = transformation.getInverted();
//    Matrix44 m = _t.getMat44();
//
    GLKMatrix4 modelMatrix = GLKMatrix4Identity;
//    modelMatrix.m00 = m.mat[0][0];
//    modelMatrix.m01 = m.mat[0][1];
//    modelMatrix.m02 = m.mat[0][2];
//    modelMatrix.m03 = m.mat[0][3];
//    modelMatrix.m10 = m.mat[1][0];
//    modelMatrix.m11 = m.mat[1][1];
//    modelMatrix.m12 = m.mat[1][2];
//    modelMatrix.m13 = m.mat[1][3];
//    modelMatrix.m20 = m.mat[2][0];
//    modelMatrix.m21 = m.mat[2][1];
//    modelMatrix.m22 = m.mat[2][2];
//    modelMatrix.m23 = m.mat[2][3];
//    modelMatrix.m30 = m.mat[3][0];
//    modelMatrix.m31 = m.mat[3][1];
//    modelMatrix.m32 = m.mat[3][2];
//    modelMatrix.m33 = m.mat[3][3];
    return modelMatrix;
}

#pragma mark - Class's private methods

@end
