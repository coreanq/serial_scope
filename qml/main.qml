
import QtQuick 2.0

//![1]
Item {
    id: main
    width: 600
    height: 400
    signal sigSerialPortError()
    signal sigSerialPortOpenSuccess()


    Component.onCompleted: {
        dataSource.sigSerialPortError.connect(sigSerialPortError)
        dataSource.sigSerialPortOpenSuccess.connect(sigSerialPortOpenSuccess)
        controlPanel.signalSourceChanged.connect(dataSource.onSourceChanged)
        controlPanel.yOffsetChanged.connect(dataSource.yOffsetChanged)
        scopeView.zoomInClicked.connect(controlPanel.onZoomInClicked)
        scopeView.zoomResetClicked.connect(controlPanel.onZoomResetClicked)

    }


    ControlPanel {
        id: controlPanel
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 10
        width: 500
//![1]

        onSignalSourceChanged: {
            scopeView.axisX().max = sampleCount;
        }
        onSeriesTypeChanged: scopeView.changeSeriesType(type);
        onPlayTypeChanged: scopeView.changePlayType(type);
        onYScaleChanged: scopeView.changeYscale(maxY, minY, seriesIndex);
    }
    onSigSerialPortError: {
        console.log("fail");
        controlPanel.isOpen = false
    }
    onSigSerialPortOpenSuccess: {
        console.log("success")
        controlPanel.isOpen = true
    }

//![2]
    ScopeView {
        id: scopeView
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: controlPanel.right
        height: main.height
        antialiasing: enabled
        openGL: enabled

    }
//![2]

}
