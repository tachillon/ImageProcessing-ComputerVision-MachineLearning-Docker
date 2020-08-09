// C++ includes
#include <stdio.h>
#include <iostream>
// OpenCV includes
#include "opencv4/opencv2/opencv.hpp"
#if USE_CUDA
    #include "opencv4/opencv2/cudaimgproc.hpp"
    #include "opencv4/opencv2/cudaarithm.hpp"
    #include "opencv4/opencv2/cudawarping.hpp"
#endif
// Because we are lazy...
using namespace std;
using namespace cv;

int main(int argc, char *argv[])
{
#if USE_CUDA
    std::cout << "Testing OpenCV CUDA support installation..." << std::endl;
#else
    std::cout << "Testing OpenCV installation..." << std::endl;
#endif
    cv::Mat img = cv::imread("/opt/img.png");
    cv::Mat out;
#if USE_CUDA 
    cv::cuda::GpuMat gpu_img;
    cv::cuda::GpuMat gpu_out;
    gpu_img.upload(img);
    cv::cuda::resize(gpu_img,gpu_out,cv::Size(),0.5,0.5,cv::INTER_CUBIC);
    gpu_out.download(out);
#else
    cv::resize(img,out,cv::Size(),0.5,0.5,cv::INTER_CUBIC);
#endif
    std::cout << "... All is ok!" << std::endl;
    return 0;
}
