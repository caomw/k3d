# Setup default test variables ... 
SET(CTEST_CMAKE_COMMAND "\"${CMAKE_EXECUTABLE_NAME}\"")
SET(CTEST_COMMAND "\"${CTEST_EXECUTABLE_NAME}\" -D Continuous -E benchmark -A \"${CTEST_SCRIPT_DIRECTORY}/${CTEST_SCRIPT_NAME}\"")
SET(CTEST_SOURCE_DIRECTORY "${CTEST_SCRIPT_DIRECTORY}/../..")
#SET(CTEST_START_WITH_EMPTY_BINARY_DIRECTORY_ONCE TRUE)

SET(CTEST_INITIAL_CACHE "

BUILD_TESTING:BOOL=ON
CMAKE_BUILD_TYPE:STRING=Debug
K3D_BUILD_VIRTUAL_OFFSCREEN_MODULE:BOOL=OFF

")

SET(CTEST_CONTINUOUS_DURATION 960)
SET(CTEST_CONTINUOUS_MINIMUM_INTERVAL 10)

# Uncomment this to enable ruthless compiler warnings
#SET(CTEST_ENVIRONMENT
#  "CFLAGS=-g -O0 -Wall -W"
#  "CXXFLAGS=-g -O0 -Wall -W"
#)

# Allow the caller to override test variables ... note that the caller MUST specify CTEST_BINARY_DIRECTORY at-a-minimum.
SET(VARIABLE)
FOREACH(ARGUMENT ${CTEST_SCRIPT_ARG})
	IF(VARIABLE)
		SET(${VARIABLE} ${ARGUMENT})
		SET(VARIABLE)
	ELSE(VARIABLE)
		SET(VARIABLE ${ARGUMENT})
	ENDIF(VARIABLE)
ENDFOREACH(ARGUMENT)

