
import QtQuick

//![1]
Item {
    id: main
    width: 1280
    height: 800
    signal sigSerialPortError()
    signal sigSerialPortOpenSuccess()


    Component.onCompleted: {
        dataSource.sigSerialPortError.connect(sigSerialPortError)
        dataSource.sigSerialPortOpenSuccess.connect(sigSerialPortOpenSuccess)
        controlPanel.signalSourceChanged.connect(dataSource.onSourceChanged)
        controlPanel.yOffsetChanged.connect(dataSource.yOffsetChanged)
        controlPanel.yScaleChanged.connect(dataSource.yScaleChanged)
        scopeView.zoomInClicked.connect(controlPanel.onZoomInClicked)
        scopeView.zoomResetClicked.connect(controlPanel.onZoomResetClicked)

    }


    Connections {
        target: controlPanel

        // 아래와 같이 인자 있는 시그널을 바로 사용하면 안되고 자바스크립트 처리 함
        // onSignalSourceChanged: {
        //     controlPanel.onSignalSourceChanged(sampleCount)
        // }

        function onSignalSourceChanged(sampleCount){
            scopeView.axisX().max = sampleCount;
        }
        function onSeriesTypeChanged(type) {
           scopeView.changeSeriesType(type);
        }
        function  onPlayTypeChanged(type) {
           scopeView.changePlayType(type);
        }
        function onYMinMaxChanged(maxY, minY, seriesIndex) {
            scopeView.changeYMinMax(maxY, minY, seriesIndex);
        }

    }


    ControlPanel {
        id: controlPanel
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 10
        width: 500
    }

    onSigSerialPortError: {
        console.log("fail");
        controlPanel.isOpen = false
    }
    onSigSerialPortOpenSuccess: {
        console.log("success")
        controlPanel.isOpen = true
    }

    ScopeView {
        id: scopeView
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: controlPanel.right
        height: main.height

    }
}
