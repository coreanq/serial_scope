QT += charts quick serialport

HEADERS += \
    UtilBit.h \
    UtilCrc16.h \
    datasource.h

SOURCES += \
    UtilCrc16.cpp \
    main.cpp \
    datasource.cpp

RESOURCES += \
    resources.qrc

DISTFILES += \
    qml/qmloscilloscope/*

target.path = install
INSTALLS += target

RC_ICONS = app_icon.ico
