/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt Charts module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:GPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 or (at your option) any later version
** approved by the KDE Free Qt Foundation. The licenses are as published by
** the Free Software Foundation and appearing in the file LICENSE.GPL3
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0
import QtCharts 2.1
import QtQuick.Layouts 1.0

//![1]
ChartView {
    id: chartView
    signal zoomInClicked()
    signal zoomResetClicked()

    animationOptions: ChartView.NoAnimation
    theme: ChartView.ChartThemeDark
    antialiasing: true
    property bool openGL: true
    property bool openGLSupported: true
    property rect zoomArea
    property point currentMousePoint
    property Item  chartCoodinateItem : null
    property Item highlightItem : null


    Component.onCompleted: {
        series("Ch 1").useOpenGL = openGL;
        series("Ch 2").useOpenGL = openGL;
        series("Ch 3").useOpenGL = openGL;
        series("Ch 4").useOpenGL = openGL;
        series("Ch 5").useOpenGL = openGL;
        series("Ch 6").useOpenGL = openGL;
    }

    Component {
        id: highlightComponent

        Rectangle {
            color: "yellow"
            opacity: 0.35
        }
    }

    Component {
        id: chartCoodinateComponent


        Rectangle
        {
            property string da1_str
            property string da2_str
            property string da3_str
            property string da4_str
            property string da5_str
            property string da6_str

            color: "dark gray"
            width: da1_value.width * 1.5
            height: da1_value.height * 9

            ColumnLayout  {

                Text{
                    id: da1_value
                    text: "Ch1: " + da1_str
                    color: "dodgerblue"
                    font.bold: true
                }
                Text{
                    id: da2_value
                    text: "Ch2: " + da2_str
                    color: "red"
                    font.bold: true
                }
                Text{
                    id: da3_value
                    text: "Ch3: " + da3_str
                    color: "green"
                    font.bold: true
                }
                Text{
                    id: da4_value
                    text: "Ch4: " + da4_str
                    color: "yellow"
                    font.bold: true
                }
                Text{
                    id: da5_value
                    text: "Ch5: " + da5_str
                    color: "magenta"
                    font.bold: true
                }
                Text{
                    id: da6_value
                    text: "Ch6: " + da6_str
                    color: "orange"
                    font.bold: true
                }
            }

        }

    }
    MouseArea{
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        hoverEnabled: true
        onPressed: {
            if (mouse.button == Qt.LeftButton)
            {
                if (highlightItem !== null) {
                    // if there is already a selection, delete it
                    highlightItem.destroy ();
                }
                // create a new rectangle at the wanted position
                highlightItem = highlightComponent.createObject (parent, {
                    "x" : mouseX,
                    "y" : mouseY
                });
                zoomArea.x = mouseX
                zoomArea.y = mouseY
            }
        }

        onPositionChanged: {
            // on move, update the width of rectangle
            if (highlightItem !== null) {
                highlightItem.width = (Math.abs (mouseX - highlightItem.x));
                highlightItem.height = (Math.abs (mouseY - highlightItem.y));
            }

            if( chartCoodinateItem !== null ){
                chartCoodinateItem.destroy();
            }

            chartCoodinateItem = chartCoodinateComponent.createObject(parent, { "x": mouseX + 15, "y" : mouseY + 15 } );

            currentMousePoint.x = mouseX
            currentMousePoint.y = mouseY

            var da1 = chartView.mapToValue(currentMousePoint, lineSeries1)
            var da2 = chartView.mapToValue(currentMousePoint, lineSeries2)
            var da3 = chartView.mapToValue(currentMousePoint, lineSeries3)
            var da4 = chartView.mapToValue(currentMousePoint, lineSeries4)
            var da5 = chartView.mapToValue(currentMousePoint, lineSeries5)
            var da6 = chartView.mapToValue(currentMousePoint, lineSeries6)
//            console.log( da1.x)
//            console.log( lineSeries1.at( da1.x).y )

            // 소숫점 2자리로 끊어냄
            chartCoodinateItem.da1_str =  ( Math.round(lineSeries1.at( da1.x).y * 100 ) /100).toString()
            chartCoodinateItem.da2_str =  ( Math.round(lineSeries2.at( da2.x).y * 100 ) /100).toString()
            chartCoodinateItem.da3_str =  ( Math.round(lineSeries3.at( da3.x).y * 100 ) /100).toString()
            chartCoodinateItem.da4_str =  ( Math.round(lineSeries4.at( da4.x).y * 100 ) /100).toString()
            chartCoodinateItem.da5_str =  ( Math.round(lineSeries5.at( da5.x).y * 100 ) /100).toString()
            chartCoodinateItem.da6_str =  ( Math.round(lineSeries6.at( da6.x).y * 100 ) /100).toString()
        }
        onReleased: {
        // here you can add you zooming stuff if you want
            if (mouse.button == Qt.LeftButton)
            {
                zoomArea.width = Math.abs(zoomArea.x - mouseX)
                zoomArea.height = Math.abs(zoomArea.y - mouseY)
                console.log(zoomArea)
                chartView.zoomIn(zoomArea)
                zoomInClicked()
            }
            if (highlightItem !== null) {
                // if there is already a selection, delete it
                highlightItem.destroy()
            }
        }

        onClicked: {
            if (mouse.button == Qt.RightButton)
            {
                chartView.zoomReset()
                zoomResetClicked()
            }

            if (mouse.button == Qt.LeftButton)
            {
            }
        }

        onExited: {
            if( chartCoodinateItem !== null ){
                chartCoodinateItem.destroy();
            }
            if (highlightItem !== null) {
                // if there is already a selection, delete it
                highlightItem.destroy ();
            }

        }
    }
    ValueAxis {
        id: axisY1
    }

    ValueAxis {
        id: axisY2
    }
    ValueAxis {
        id: axisY3
    }
    ValueAxis {
        id: axisY4
    }
    ValueAxis {
        id: axisY5
    }
    ValueAxis {
        id: axisY6
    }

    ValueAxis {
        id: axisX
    }

    LineSeries {
        id: lineSeries1
        name: "Ch 1"
        axisX: axisX
        axisY: axisY1
        useOpenGL: chartView.openGL
        color: "dodgerblue"
    }
    LineSeries {
        id: lineSeries2
        name: "Ch 2"
        axisX: axisX
        axisYRight: axisY2
        useOpenGL: chartView.openGL
        color: "red"
    }
    LineSeries {
        id: lineSeries3
        name: "Ch 3"
        axisX: axisX
        axisYRight: axisY3
        useOpenGL: chartView.openGL
        color: "green"
    }
    LineSeries {
        id: lineSeries4
        name: "Ch 4"
        axisX: axisX
        axisYRight: axisY4
        useOpenGL: chartView.openGL
        color: "yellow"
    }
    LineSeries {
        id: lineSeries5
        name: "Ch 5"
        axisX: axisX
        axisYRight: axisY5
        useOpenGL: chartView.openGL
        color: "magenta"
    }
    LineSeries {
        id: lineSeries6
        name: "Ch 6"
        axisX: axisX
        axisYRight: axisY6
        useOpenGL: chartView.openGL
        color: "orange"
    }

//![1]

    //![2]
    Timer {
        id: refreshTimer
        interval: 100
        running: true
        repeat: true
        onTriggered: {
            dataSource.update(chartView.series(0), 0);
            dataSource.update(chartView.series(1), 1);
            dataSource.update(chartView.series(2), 2);
            dataSource.update(chartView.series(3), 3);
            dataSource.update(chartView.series(4), 4);
            dataSource.update(chartView.series(5), 5);
        }
    }
    //![2]

    //![3]
    function changeSeriesType(type) {
        chartView.removeAllSeries();

        // Create two new series of the correct type. Axis x is the same for both of the series,
        // but the series have their own y-axes to make it possible to control the y-offset
        // of the "signal sources".
        var series1;
        var series2;
        var series3;
        var series4;

        if (type === "line") {
            series1 = chartView.createSeries(ChartView.SeriesTypeLine, "Ch 1",
                                                 axisX, axisY1);

            series2 = chartView.createSeries(ChartView.SeriesTypeLine, "Ch 2",
                                                 axisX, axisY2);

            series3 = chartView.createSeries(ChartView.SeriesTypeLine, "Ch 3",
                                                 axisX, axisY3);

            series4 = chartView.createSeries(ChartView.SeriesTypeLine, "Ch 4",
                                                 axisX, axisY4);

            series5 = chartView.createSeries(ChartView.SeriesTypeLine, "Ch 5",
                                                 axisX, axisY5);

            series6 = chartView.createSeries(ChartView.SeriesTypeLine, "Ch 6",
                                                 axisX, axisY6);
        }
    }

    function changePlayType(type) {

        if (type === "hidden") {
            refreshTimer.running = false
        } else {
            refreshTimer.running = true
        }
    }
    function changeYMinMax(maxY, minY, seriesIndex) {

        switch( seriesIndex )
        {
        case 0:
            axisY1.max = parseInt(maxY)
            axisY1.min = parseInt(minY)
            break;
        case 1:
            axisY2.max = parseInt(maxY)
            axisY2.min = parseInt(minY)
           break;
        case 2:
            axisY3.max = parseInt(maxY)
            axisY3.min = parseInt(minY)
            break;
        case 3:
            axisY4.max = parseInt(maxY)
            axisY4.min = parseInt(minY)
           break;
        case 4:
            axisY5.max = parseInt(maxY)
            axisY5.min = parseInt(minY)
           break;
        case 5:
            axisY6.max = parseInt(maxY)
            axisY6.min = parseInt(minY)
           break;

        }
    }

    function createAxis(min, max) {
        // The following creates a ValueAxis object that can be then set as a x or y axis for a series
        return Qt.createQmlObject("import QtQuick 2.0; import QtCharts 2.0; ValueAxis { min: "
                                  + min + "; max: " + max + " }", chartView);
    }
    //![3]

    function setAnimations(enabled) {
        if (enabled)
            chartView.animationOptions = ChartView.SeriesAnimations;
        else
            chartView.animationOptions = ChartView.NoAnimation;
    }

    function changeRefreshRate(rate) {
        refreshTimer.interval = 1 / Number(rate) * 1000;
    }
}
