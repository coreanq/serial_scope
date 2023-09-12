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
    signal yMinMaxChanged(string maxY, string minY, int seriesIndex);
    signal yScaleChanged(string scale, int seriesIndex);
    signal yOffsetChanged(string offset, int seriesIndex);

    property bool isOpen : false
    property Item optionHideItem : null

    property string ch1MaxY: "100000"
    property string ch1MinY: "-100000"
    property string ch2MaxY: "100000"
    property string ch2MinY: "-100000"
    property string ch3MaxY: "100000"
    property string ch3MinY: "-100000"
    property string ch4MaxY: "100000"
    property string ch4MinY: "-100000"

    function onZoomInClicked()
    {
        gridOption.enabled = false
    }

    function onZoomResetClicked()
    {
        gridOption.enabled = true
    }

    Component.onCompleted: {
        yMinMaxChanged(
            ch1MaxY, ch1MinY, 0
        );
        yMinMaxChanged(
            ch2MaxY, ch2MinY, 1
        );
        yMinMaxChanged(
            ch3MaxY, ch3MinY, 2
        );
        yMinMaxChanged(
            ch4MaxY, ch4MinY, 3
        );
        yScaleChanged(
                    '1', 0
        )
        yScaleChanged(
                    '1', 1
        )
        yScaleChanged(
                    '1', 2
        )
        yScaleChanged(
                    '1', 3
        )

        yOffsetChanged(
                "0",  0
        );
        yOffsetChanged(
                "0",  1
        );
        yOffsetChanged(
                "0",  2
        );
        yOffsetChanged(
                "0",  3
        );
    }

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
            columns: 5
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
            Text {
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
            Text {
            }
            Text {
            }

            ////////////////////////////////////////////////////////////////////////////////////
            // header start
            Text {
                id: txtHeader1
                text: "Chnnel"
                color: "white"
            }
            Text {
                id: txtHeader2
                text: "Max Y"
                color: "white"
            }
            Text {
                id: txtHeader3
                text: "Min Y"
                color: "white"
            }
            Text {
                id: txtHeader4
                text: "scale"
                color: "white"
            }
            Text {
                id: txtHeader5
                text: "Offset"
                color: "white"
            }
            // header end


            ////////////////////////////////////////////////////////////////////////////////////
            // "Ch1 Y Scale signed:
            Text {
                text: "Ch1"
                color: "white"
            }
            TextInput {
                text: ch1MaxY
                color:"white"
                validator: IntValidator{bottom: -10000000; top: 10000000;}

                onAccepted: {
                    ch1MaxY = text;
                    yMinMaxChanged(
                            ch1MaxY, ch1MinY, 0
                    );
                }
            }
            TextInput {
                text: ch1MinY
                color:"white"
                validator: IntValidator{bottom: -10000000; top: 10000000;}

                onAccepted: {
                    ch1MinY = text;
                    yMinMaxChanged(
                            ch1MaxY, ch1MinY, 0
                    );
                }
            }
            TextInput {
                text: "1"
                color:"white"

                validator: IntValidator{bottom: -1000000; top: 1000000;}
                onAccepted: {
                        if( text == "" )
                            text = "1"
                        yScaleChanged(
                                text,  0
                        );
                }
            }
            TextInput {
                text: "0"
                color:"white"

                validator: IntValidator{bottom: -1000000; top: 1000000;}
                onAccepted: {
                        if( text == "" )
                            text = "0"
                        yOffsetChanged(
                                text,  0
                        );
                }
            }

            ////////////////////////////////////////////////////////////////////////////////////
            // "Ch2 Y Scale signed:
            Text {
                text: "Ch2"
                color: "white"
            }
            TextInput {
                text: ch2MaxY
                color:"white"

                validator: IntValidator{bottom: -10000000; top: 10000000;}

                onAccepted: {
                    ch2MaxY = text;
                    yMinMaxChanged(
                            ch2MaxY, ch2MinY, 1
                    );
                }
            }
            TextInput {
                text: ch2MinY
                color:"white"
                validator: IntValidator{bottom: -10000000; top: 10000000;}

                onAccepted: {
                    ch2MinY = text;
                    yMinMaxChanged(
                            ch2MaxY, ch2MinY, 1
                    );
                }
            }
            TextInput {
                text: "1"
                color:"white"

                validator: IntValidator{bottom: -1000000; top: 1000000;}
                onAccepted: {
                        if( text == "" )
                            text = "1"
                        yScaleChanged(
                                text,  1
                        );
                }
            }
            TextInput {
                text: "0"
                color:"white"

                validator: IntValidator{bottom: -1000000; top: 1000000;}
                onAccepted: {
                        if( text == "" )
                            text = "0"
                        yOffsetChanged(
                                text,  1
                        );
                }
            }

            ////////////////////////////////////////////////////////////////////////////////////
            // "Ch3 Y Scale signed:
            Text {
                text: "Ch3"
                color: "white"
            }
            TextInput {
                text: ch3MaxY
                color:"white"
                validator: IntValidator{bottom: -10000000; top: 10000000;}

                onAccepted: {
                    ch3MaxY = text;
                    yMinMaxChanged(
                            ch3MaxY, ch3MinY, 2
                    );
                }
            }
            TextInput {
                text: ch3MinY
                color:"white"
                validator: IntValidator{bottom: -10000000; top: 10000000;}

                onAccepted: {
                    ch3MinY = text;
                    yMinMaxChanged(
                            ch3MaxY, ch3MinY, 2
                    );
                }
            }
            TextInput {
                text: "1"
                color:"white"

                validator: IntValidator{bottom: -1000000; top: 1000000;}
                onAccepted: {
                        if( text == "" )
                            text = "1"
                        yScaleChanged(
                                text,  2
                        );
                }
            }
            TextInput {
                text: "0"
                color:"white"

                validator: IntValidator{bottom: -1000000; top: 1000000;}
                onAccepted: {
                        if( text == "" )
                            text = "0"
                        yOffsetChanged(
                                text,  2
                        );
                }
            }

            ////////////////////////////////////////////////////////////////////////////////////
            // "Ch4 Y Scale signed:
            Text {
                text: "Ch4"
                color: "white"
            }
            TextInput {
                text: ch4MaxY
                color:"white"
                validator: IntValidator{bottom: -10000000; top: 10000000;}

                onAccepted: {
                    ch4MaxY = text;
                    yMinMaxChanged(
                            ch4MaxY, ch4MinY, 3
                    );
                }
            }
            TextInput {
                text: ch4MinY
                color:"white"
                validator: IntValidator{bottom: -10000000; top: 10000000;}

                onAccepted: {
                    ch4MinY = text;
                    yMinMaxChanged(
                            ch4MaxY, ch4MinY, 3
                    );
                }
            }
            TextInput {
                text: "1"
                color:"white"

                validator: IntValidator{bottom: -1000000; top: 1000000;}
                onAccepted: {
                        if( text == "" )
                            text = "1"
                        yScaleChanged(
                                text,  3
                        );
                }
            }
            TextInput {
                text: "0"
                color:"white"

                validator: IntValidator{bottom: -1000000; top: 1000000;}
                onAccepted: {
                        if( text == "" )
                            text = "0"
                        yOffsetChanged(
                                text,  3
                        );
                }
            }

        }
    }
}
