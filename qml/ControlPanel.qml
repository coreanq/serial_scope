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

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window

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

    property string ch1MaxY: "1000"
    property string ch1MinY: "-1000"
    property string ch2MaxY: "1000"
    property string ch2MinY: "-1000"
    property string ch3MaxY: "1000"
    property string ch3MinY: "-1000"
    property string ch4MaxY: "1000"
    property string ch4MinY: "-1000"
    property string ch5MaxY: "1000"
    property string ch5MinY: "-1000"
    property string ch6MaxY: "1000"
    property string ch6MinY: "-1000"

    function onZoomInClicked()
    {
//        gridOption.enabled = false
    }

    function onZoomResetClicked()
    {
//        gridOption.enabled = true
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
        yMinMaxChanged(
            ch5MaxY, ch5MinY, 4
        );
        yMinMaxChanged(
            ch6MaxY, ch6MinY, 5
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
        yScaleChanged(
                    '1', 4
        )
        yScaleChanged(
                    '1', 5
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
        yOffsetChanged(
                "0",  4
        );
        yOffsetChanged(
                "0",  5
        );
    }

    ShaderEffect {
       anchors.fill: parent
       fragmentShader: "
            varying vec2 qt_TexCoord0;
            void main() {
                vec2 uv = qt_TexCoord0;
                vec4 color1 = vec4(1.0, 0.0, 0.0, 1.0); // 빨강
                vec4 color2 = vec4(0.0, 0.0, 1.0, 1.0); // 파랑
                gl_FragColor = mix(color1, color2, uv.y);
            }
        "
    }
            // Gradient{
            //        GradientStop { position: 0.0; color: { if( isOpen == false ) { return "red" } else { return "green"} } }
            //        GradientStop { position: 1.0; color: "black" }
            //    }

    onIsOpenChanged: {
        if( isOpen == true ) {
            serialPortOpen.visible = false
            serialPortClose.visible = true
        }
        else {
            serialPortOpen.visible = true
            serialPortClose.visible = false
        }
    }

    ColumnLayout {

        id: mainPanel
//        anchors.fill: parent
        anchors.left : parent.left
        anchors.right: parent.right

        spacing: 20
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
                // contentItem: Text {
                //     text: serialPortOpen.text
                //     clip: true
                //     wrapMode: Text.WordWrap
                //     verticalAlignment: Text.AlignVCenter
                //     horizontalAlignment: Text.AlignHCenter
                //     anchors.fill: parent
                // }
            }
            Button {
                id: serialPortClose
                text: "close"
                visible: false
                onClicked: {
                    if( isOpen == true ){
                        dataSource.close(serialPortName.currentText);
                    }
                }

                // contentItem: Text {
                //     text: serialPortClose.text
                //     clip: true
                //     wrapMode: Text.WordWrap
                //     verticalAlignment: Text.AlignVCenter
                //     horizontalAlignment: Text.AlignHCenter
                //     anchors.fill: parent
                // }
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

                // contentItem:  Text {
                //     text: serialPortName.currentText
                //     clip: true
                //     wrapMode: Text.WordWrap
                //     verticalAlignment: Text.AlignVCenter
                //     horizontalAlignment: Text.AlignHCenter
                //     anchors.fill: parent
                // }

                Rectangle{
                    anchors.fill: parent

                    color: {
                        if( isOpen == false)
                            return "white"
                        else
                            return "light black"

                    }

                    opacity: {
                        if( isOpen == false)
                            return 0
                        else
                            return 0.5
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

                    color: {
                        if( isOpen == false)
                            return "white"
                        else
                            return "light black"

                    }

                    opacity: {
                        if( isOpen == false)
                            return 0
                        else
                            return 0.5
                    }
                }

                // contentItem:  Text {
                //     text: serialPortRefresh.text
                //     clip: true
                //     wrapMode: Text.WordWrap
                //     verticalAlignment: Text.AlignVCenter
                //     horizontalAlignment: Text.AlignHCenter
                //     anchors.fill: parent
                // }
            }
        }

    }

    GridLayout {
        id: gridOption

        anchors.bottom: main.bottom
        anchors.bottomMargin: 50

        anchors.left: mainPanel.right
        anchors.right: mainPanel.right
        visible: false


        states: [
            State {
                name: "opening"; when: isOpen
                AnchorChanges { target: gridOption; anchors.left: mainPanel.left }
                PropertyChanges { target: gridOption; visible: true }
             },
            State {
                name: "closing"; when: !isOpen
                AnchorChanges { target: gridOption; anchors.left: mainPanel.right }
                PropertyChanges { target: gridOption; visible: false }
             }
        ]

        transitions: Transition {
                 // smoothly reanchor myRect and move into new position
                 AnchorAnimation { duration: 500 }
                 PropertyAnimation {duration: 500 }
        }



        height: 400

        columns: 5
            columnSpacing:5
            rowSpacing:5

            MultiButton {
                id: playButton
                enabled: isOpen

                text: "Trend: "
                items: ["hidden", "show"]
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

                model: ["128", "256", "512", "1024", "2048", "10000", "50000", "100000", "200000", "500000" ]

                onCurrentIndexChanged: signalSourceChanged(
                                        model[currentIndex]
                                        );
                Component.onCompleted: {
                    currentIndex = 7
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
                color: "gray"
            }
            TextInput {
                text: ch1MaxY
                color:"white"
                validator: IntValidator{bottom: -10000000; top: 10000000;}

                onEditingFinished: {
                    ch1MaxY = text;
                    ch1MinY = '-' + text;
                    yMinMaxChanged(
                            ch1MaxY, ch1MinY, 0
                    );
                }
            }
            Text {
                text: ch1MinY
                color:"gray"
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
                color: "gray"
            }
            TextInput {
                text: ch2MaxY
                color:"white"

                validator: IntValidator{bottom: -10000000; top: 10000000;}

                onEditingFinished: {
                    ch2MaxY = text;
                    ch2MinY = '-' + text;
                    yMinMaxChanged(
                            ch2MaxY, ch2MinY, 1
                    );
                }
            }
            Text {
                text: ch2MinY
                color:"gray"
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
                color: "gray"
            }
            TextInput {
                text: ch3MaxY
                color:"white"
                validator: IntValidator{bottom: -10000000; top: 10000000;}

                onEditingFinished: {
                    ch3MaxY = text;
                    ch3MinY = '-' + text;
                    yMinMaxChanged(
                            ch3MaxY, ch3MinY, 2
                    );
                }
            }
            Text {
                text: ch3MinY
                color:"gray"
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
                color: "gray"
            }
            TextInput {
                text: ch4MaxY
                color:"white"
                validator: IntValidator{bottom: -10000000; top: 10000000;}

                onEditingFinished: {
                    ch4MaxY = text;
                    ch4MinY = '-' + text;
                    yMinMaxChanged(
                            ch4MaxY, ch4MinY, 3
                    );
                }
            }
            TextInput {
                text: ch4MinY
                color:"gray"
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

            ////////////////////////////////////////////////////////////////////////////////////
            // "Ch5 Y Scale signed:
            Text {
                text: "Ch5"
                color: "gray"
            }
            TextInput {
                text: ch5MaxY
                color:"white"
                validator: IntValidator{bottom: -10000000; top: 10000000;}

                onEditingFinished: {
                    ch5MaxY = text;
                    ch5MinY = '-' + text;
                    yMinMaxChanged(
                            ch5MaxY, ch5MinY, 4
                    );
                }
            }
            TextInput {
                text: ch6MinY
                color:"gray"
            }
            TextInput {
                text: "1"
                color:"white"

                validator: IntValidator{bottom: -1000000; top: 1000000;}
                onAccepted: {
                        if( text == "" )
                            text = "1"
                        yScaleChanged(
                                text,  4
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
                                text,  4
                        );
                }
            }

            ////////////////////////////////////////////////////////////////////////////////////
            // "Ch6 Y Scale signed:
            Text {
                text: "Ch6"
                color: "gray"
            }
            TextInput {
                text: ch6MaxY
                color:"white"
                validator: IntValidator{bottom: -10000000; top: 10000000;}

                onEditingFinished: {
                    ch6MaxY = text;
                    ch6MinY = '-' + text;
                    yMinMaxChanged(
                            ch6MaxY, ch6MinY, 5
                    );
                }
            }
            TextInput {
                text: ch6MinY
                color:"gray"
            }
            TextInput {
                text: "1"
                color:"white"

                validator: IntValidator{bottom: -1000000; top: 1000000;}
                onAccepted: {
                        if( text == "" )
                            text = "1"
                        yScaleChanged(
                                text,  5
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
                                text,  5
                        );
                }
            }


        }
}
