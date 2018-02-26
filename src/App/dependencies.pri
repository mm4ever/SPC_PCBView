INCLUDEPATH += $$PWD/../../include
DEPENDPATH += $$PWD/../../include

#>>>----------------------------------------------------------------------------
# SSDK

## load library of SSDK
!contains(DEFINES, _BUILDING_SDK){

win32:CONFIG(release, debug|release): LIBS += -L$$PWD/../../lib/release/ -lSSDK
else:win32:CONFIG(debug, debug|release): LIBS += -L$$PWD/../../lib/debug/ -lSSDK
else:unix:CONFIG(release, debug|release):  LIBS += -L$$PWD/../../lib/release/ -lSSDK
else:unix:CONFIG(debug, debug|release):  LIBS += -L$$PWD/../../lib/debug/ -lSSDK

INCLUDEPATH += $$PWD/../../include/SSDK
DEPENDPATH += $$PWD/../../include/SSDK

#include(../SSDK/SSDKDependencies.pri)
}# !contains(DEFINES, _BUILDING_SDK)

#>>>----------------------------------------------------------------------------
# Job

## load library of Job
!contains(DEFINES, _BUILDING_Job){

win32:CONFIG(release, debug|release): LIBS += -L$$PWD/../../lib/release/ -lJob
else:win32:CONFIG(debug, debug|release): LIBS += -L$$PWD/../../lib/debug/ -lJob
else:unix:CONFIG(release, debug|release):  LIBS += -L$$PWD/../../lib/release/ -lJob
else:unix:CONFIG(debug, debug|release):  LIBS += -L$$PWD/../../lib/debug/ -lJob

INCLUDEPATH += $$PWD/../../include/Job
DEPENDPATH += $$PWD/../../include/Job

#include(../Job/JobDependencies.pri)
}# !contains(DEFINES, _BUILDING_Job)
