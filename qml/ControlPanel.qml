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

import QtQuick 2.1
import QtQuick.Layouts 1.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import QtGraphicalEffects 1.12

Item {
    id: main
    signal seriesTypeChanged(string type)
    signal signalSourceChanged(int sampleCount);
    signal playTypeChanged(string type);
    signal yScaleChanged(string scale, int seriesIndex);

    property bool isOpen : false
    property Item optionHideItem : null
    LinearGradient {
           anchors.fill: parent
           start: Qt.point(0, 0)
           end: Qt.point(0, 300)
           gradient: Gradient {
               GradientStop { position: 0.0; color: "green" }
               GradientStop { position: 1.0; color: "black" }
           }
       }
        onIsOpenChanged: {
            if( isOpen == true ) {
                serialPortOpen.text = "close"
            }
            else {
                serialPortOpen.text = "open"
            }
        }
    ColumnLayout {
        anchors.fill: parent
        spacing: 8
        Layout.fillHeight: true


        Text {
            text: "Scope"
            font.pointSize: 18
            color: "white"
        }


        onWidthChanged: {

            if (optionHideItem !== null) {
                // if there is already a selection, delete it
                optionHideItem.destroy ();
            }
            var point = {}
            // create a new rectangle at the wanted position
            optionHideItem = optionHideComponent.createObject (parent, {
                "x" : 0,
                "y" : 0,
                "width" : gridOption.width,
                "height" : gridOption.height
            });
            point = mapFromGlobal(optionHideItem.x, optionHideItem.y)
            optionHideItem.x = point.x
            optionHideItem.y = point.y

        }


        function onZoomInClicked()
        {
            gridOption.enabled = false
        }

        function onZoomResetClicked()
        {
            gridOption.enabled = true
        }

        RowLayout{
            Button {
                id: serialPortOpen
                text: "open"
                onClicked: {

                    if( isOpen == false ){
                        dataSource.open(serialPortName.currentText);


                    }
                }


                style: ButtonStyle {
                    label: Component {
                        Text {
                            text: serialPortOpen.text
                            clip: true
                            wrapMode: Text.WordWrap
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            anchors.fill: parent
                        }
                    }
                }
            }
            Button {
                id: serialPortClose
                text: "close"
                onClicked: {
                    if( isOpen == true ){
                        dataSource.close(serialPortName.currentText);
                    }
                }

                style: ButtonStyle {
                    label: Component {
                        Text {
                            text: serialPortClose.text
                            clip: true
                            wrapMode: Text.WordWrap
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            anchors.fill: parent
                        }
                    }
                }
            }

        }


        RowLayout {
            id: rowSerialPortInfo
            ComboBox {
                id: serialPortName
                Component.onCompleted: {
                    model = dataSource.availablePorts();
                }

                enabled: !isOpen

                style: ComboBoxStyle {
                    label: Component {
                        Text {
                            text: serialPortName.currentText
                            clip: true
                            wrapMode: Text.WordWrap
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            anchors.fill: parent
                        }
                    }
                }
            }

            Button {
                id: serialPortRefresh
                text: "Refreh"
                onClicked: {
                    serialPortName.model = dataSource.availablePorts();
                }

                enabled: !isOpen
                Rectangle{
                    anchors.fill: parent
                    opacity: {
                        if( isOpen == false)
                            return 0
                        else
                            return 1
                    }
                }

                style: ButtonStyle {
                    label: Component {
                        Text {
                            text: serialPortRefresh.text
                            clip: true
                            wrapMode: Text.WordWrap
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            anchors.fill: parent
                        }
                    }
                }
            }
        }

        GridLayout {
            id: gridOption
            columns: 3
            columnSpacing:5
            rowSpacing:5

            MultiButton {
                id: playButton
                enabled: isOpen
                Rectangle{
                    anchors.fill: parent
                    opacity: {
                        if( isOpen == true)
                            return 0
                        else
                            return 1
                    }
                }

                text: "Play: "
                items: ["stop", "run"]
                currentSelection: 0
                onSelectionChanged: {
                    playTypeChanged(items[currentSelection])
                }
                Component.onCompleted: {
                    playTypeChanged(items[currentSelection])
                }

            }
            Text {
            }
            Text {
            }
            ////////////////////////////////////////////////////////////////////////////////////
            Text {
                id: smapleCountText
                text: "Samples: "
                color: "white"

            }

            ComboBox {
                id: sampleCount
                enabled: isOpen
                Rectangle{
                    anchors.fill: parent
                    opacity: {
                        if( isOpen == true)
                            return 0
                        else
                            return 1
                    }
                }

        //        text: "Samples: "
                model: ["128", "256", "512", "1024", "2048", "10000", "50000", "100000", "200000", "500000" ]

                onCurrentIndexChanged: signalSourceChanged(
                                        model[currentIndex]
                                        );
                Component.onCompleted: {
                    currentIndex = 5
                    signalSourceChanged(model[currentIndex])
                }
            }
            Text {
            }


            ////////////////////////////////////////////////////////////////////////////////////
            Text {
            }
            Text {
            }
            Text {
            }

            ////////////////////////////////////////////////////////////////////////////////////
            // header start
            Text {
                id: txtHeader1
                text: "Type"
                color: "white"
            }
            Text {
                id: txtHeader2
                text: "Scale"
                color: "white"
            }
            Text {
                id: txtHeader3
                text: "Offset"
                color: "white"
            }
            // header end


            ////////////////////////////////////////////////////////////////////////////////////
            // "Ch2 Y Scale signed: "
            Text {
                id: txtscaleCh1Yaxis
                text: "Ch1"
                color: "white"
            }
            ComboBox {
                id: scaleChA1Yaxis
                enabled: isOpen

                Rectangle{
                    anchors.fill: parent
                    opacity: {
                        if( isOpen == true)
                            return 0
                        else
                            return 1
                    }
                }
                model: ["10bit", "12bit", "14bit","15bit", "16bit", "17bit",  "18bit", "19bit", "20bit" ]
                onCurrentIndexChanged: yScaleChanged(
                                        model[currentIndex], 0
                                        );
                Component.onCompleted: {
                    currentIndex = 0
                    yScaleChanged(model[currentIndex], 0)
                }
            }
            TextInput {
                text: "0"
                maximumLength: 7
                color:"white"

                validator: IntValidator{bottom: -1000000; top: 1000000;}
                onAccepted: {
                        if( text == "" )
                            text = "0"
                        yOffsetChanged(
                                text,  0
                        );
                }
                Component.onCompleted: {
                        yOffsetChanged(
                                text,  0
                        );

                }
            }


            ////////////////////////////////////////////////////////////////////////////////////
            // "Ch2 Y Scale signed: "
            Text {
                id: txtscaleCh2Yaxis
                text: "Ch2"
                color: "white"
            }
            ComboBox {
                id: scale2Yaxis
                enabled: isOpen

                Rectangle{
                    anchors.fill: parent
                    opacity: {
                        if( isOpen == true)
                            return 0
                        else
                            return 1
                    }
                }
                model: ["10bit", "12bit", "14bit","15bit", "16bit", "17bit",  "18bit", "19bit", "20bit" ]
                onCurrentIndexChanged: yScaleChanged(
                                        model[currentIndex], 1
                                        );
                Component.onCompleted: {
                    currentIndex = 0
                    yScaleChanged(model[currentIndex], 1)
                }
            }
            TextInput {
                text: "0"
                maximumLength: 7
                color:"white"

                validator: IntValidator{bottom: -1000000; top: 1000000;}
                onAccepted: {
                        if( text == "" )
                            text = "0"
                        yOffsetChanged(
                                text,  1
                        );
                }
                Component.onCompleted: {
                        yOffsetChanged(
                                text,  1
                        );

                }
            }

            ////////////////////////////////////////////////////////////////////////////////////
            // "CH3 Y Scale signed: "
            Text {
                id: txtscaleCh3Yaxis
                text: "Ch3"
                color: "white"
            }
            ComboBox {
                id: scaleCh3Yaxis
                enabled: isOpen

                Rectangle{
                    anchors.fill: parent
                    opacity: {
                        if( isOpen == true)
                            return 0
                        else
                            return 1
                    }
                }
                model: ["10bit", "12bit", "14bit","15bit", "16bit", "17bit",  "18bit", "19bit", "20bit" ]
                onCurrentIndexChanged: yScaleChanged(
                                        model[currentIndex], 2
                                        );
                Component.onCompleted: {
                    currentIndex = 0
                    yScaleChanged(model[currentIndex], 2)
                }
            }

            TextInput {
                text: "0"
                maximumLength: 7
                color:"white"

                validator: IntValidator{bottom: -1000000; top: 1000000;}
                onAccepted: {
                        if( text == "" )
                            text = "0"
                        yOffsetChanged(
                                text,  2
                        );
                }
                Component.onCompleted: {
                        yOffsetChanged(
                                text,  2
                        );

                }
            }
            ////////////////////////////////////////////////////////////////////////////////////
            // "CH4 Y Scale signed: "
            Text {
                id: txtscaleCh4Yaxis
                text: "Ch4"
                color: "white"
            }
            ComboBox {
                id: scaleCh4Yaxis
                enabled: isOpen

                Rectangle{
                    anchors.fill: parent
                    opacity: {
                        if( isOpen == true)
                            return 0
                        else
                            return 1
                    }
                }
                model: ["10bit", "12bit", "14bit","15bit", "16bit", "17bit",  "18bit", "19bit", "20bit" ]
                onCurrentIndexChanged: yScaleChanged(
                                        model[currentIndex], 2
                                        );
                Component.onCompleted: {
                    currentIndex = 0
                    yScaleChanged(model[currentIndex], 2)
                }
            }

            TextInput {
                text: "0"
                maximumLength: 7
                color:"white"

                validator: IntValidator{bottom: -1000000; top: 1000000;}
                onAccepted: {
                        if( text == "" )
                            text = "0"
                        yOffsetChanged(
                                text,  2
                        );
                }
                Component.onCompleted: {
                        yOffsetChanged(
                                text,  2
                        );

                }
            }

        }
    }
}
