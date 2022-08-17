#include <opencv2/aruco.hpp>
#include <opencv2/opencv.hpp>
# define MAXSIZE 100

using namespace cv;

int* id = (int*)malloc(MAXSIZE);
double* centerX = (double*)malloc(MAXSIZE);
double* centerY = (double*)malloc(MAXSIZE);
double* topLeftX = (double*)malloc(MAXSIZE);
double* topLeftY = (double*)malloc(MAXSIZE);
double* topRightX = (double*)malloc(MAXSIZE);
double* topRightY = (double*)malloc(MAXSIZE);
double* bottomRightX = (double*)malloc(MAXSIZE);
double* bottomRightY = (double*)malloc(MAXSIZE);
double* bottomLeftX = (double*)malloc(MAXSIZE);
double* bottomLeftY = (double*)malloc(MAXSIZE);

extern "C" {

	// Attributes to prevent 'unused' function from being removed and to make it visible
	__attribute__((visibility("default"))) __attribute__((used))
    int detect(uint8_t* str, int imgW, int imgH) {

        String path((char*) str);

        Mat inputImage = imread(path);

        // Load the dictionary that was used to generate the markers.
        Ptr<aruco::Dictionary> dictionary = aruco::getPredefinedDictionary(aruco::DICT_6X6_250);

        // Initialize the detector parameters using default values
        Ptr<aruco::DetectorParameters> parameters = aruco::DetectorParameters::create();

        // Declare the vectors that would contain the detected marker corners and the rejected marker candidates
        std::vector<std::vector<Point2f>> markerCorners, rejectedCandidates;

        // The ids of the detected markers are stored in a vector
        std::vector<int> markerIds;

        // Detect the markers in the image
        aruco::detectMarkers(inputImage, dictionary, markerCorners, markerIds, parameters, rejectedCandidates);

        if (markerIds.size() > 0) {
            for (int j = 0; j < markerCorners.size(); j++) {
                id[j] = markerIds[markerCorners.size() - j - 1];
                centerX[j] = (markerCorners[markerCorners.size() - j - 1][0].x + markerCorners[markerCorners.size() - j - 1][1].x + markerCorners[markerCorners.size() - j - 1][2].x + markerCorners[markerCorners.size() - j - 1][3].x) / 4.0;
                centerY[j] = (markerCorners[markerCorners.size() - j - 1][0].y + markerCorners[markerCorners.size() - j - 1][1].y + markerCorners[markerCorners.size() - j - 1][2].y + markerCorners[markerCorners.size() - j - 1][3].y) / 4.0;
                topLeftX[j] = markerCorners[markerCorners.size() - j - 1][0].x;
                topLeftY[j] = markerCorners[markerCorners.size() - j - 1][0].y;
                topRightX[j] = markerCorners[markerCorners.size() - j - 1][1].x;
                topRightY[j] = markerCorners[markerCorners.size() - j - 1][1].y;
                bottomRightX[j] = markerCorners[markerCorners.size() - j - 1][2].x;
                bottomRightY[j] = markerCorners[markerCorners.size() - j - 1][2].y;
                bottomLeftX[j] = markerCorners[markerCorners.size() - j - 1][3].x;
                bottomLeftY[j] = markerCorners[markerCorners.size() - j - 1][3].y;
            }
        }
        return markerIds.size();
    }

	// Attributes to prevent 'unused' function from being removed and to make it visible
	__attribute__((visibility("default"))) __attribute__((used))
    int* markerId() {
        return id;
    }

	// Attributes to prevent 'unused' function from being removed and to make it visible
	__attribute__((visibility("default"))) __attribute__((used))
    double* cX() {
        return centerX;
    }

	// Attributes to prevent 'unused' function from being removed and to make it visible
	__attribute__((visibility("default"))) __attribute__((used))
    double* cY() {
        return centerY;
    }

	// Attributes to prevent 'unused' function from being removed and to make it visible
	__attribute__((visibility("default"))) __attribute__((used))
    double* tLX() {
        return topLeftX;
    }

	// Attributes to prevent 'unused' function from being removed and to make it visible
	__attribute__((visibility("default"))) __attribute__((used))
    double* tLY() {
        return topLeftY;
    }

	// Attributes to prevent 'unused' function from being removed and to make it visible
	__attribute__((visibility("default"))) __attribute__((used))
    double* tRX() {
        return topRightX;
    }

	// Attributes to prevent 'unused' function from being removed and to make it visible
	__attribute__((visibility("default"))) __attribute__((used))
    double* tRY() {
        return topRightY;
    }

	// Attributes to prevent 'unused' function from being removed and to make it visible
	__attribute__((visibility("default"))) __attribute__((used))
    double* bRX() {
        return bottomRightX;
    }

	// Attributes to prevent 'unused' function from being removed and to make it visible
	__attribute__((visibility("default"))) __attribute__((used))
    double* bRY() {
        return bottomRightY;
    }

	// Attributes to prevent 'unused' function from being removed and to make it visible
	__attribute__((visibility("default"))) __attribute__((used))
    double* bLX() {
        return bottomLeftX;
    }

	// Attributes to prevent 'unused' function from being removed and to make it visible
	__attribute__((visibility("default"))) __attribute__((used))
    double* bLY() {
        return bottomLeftY;
    }
}