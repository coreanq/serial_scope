QT += charts quick serialport

HEADERS += \
    datasource.h

SOURCES += \
    main.cpp \
    datasource.cpp

RESOURCES += \
    resources.qrc

DISTFILES += \
    qml/qmloscilloscope/*

target.path = install
INSTALLS += target

RC_ICONS = app_icon.ico
