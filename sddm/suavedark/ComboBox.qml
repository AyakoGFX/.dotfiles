/***************************************************************************
* Copyright (c) 2013 Abdurrahman AVCI <abdurrahmanavci@gmail.com>
*
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without restriction,
* including without limitation the rights to use, copy, modify, merge,
* publish, distribute, sublicense, and/or sell copies of the Software,
* and to permit persons to whom the Software is furnished to do so,
* subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included
* in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
* OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
* OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
* ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
* OR OTHER DEALINGS IN THE SOFTWARE.
*
***************************************************************************/

import QtQuick 2.0

FocusScope {
    id: container
    width: 80; height: 30

    property color color: "white"
    property color borderColor: "#ababab"
    property color focusColor: "#266294"
    property color hoverColor: "#5692c4"
    property color menuColor: "white"
    property color textColor: "black"

    property int borderWidth: 0
    property font font
    property alias model: listView.model
    property int index: 0
    property alias arrowBox: arrowBox.source
    property string backgroundNormal: ""
    property string backgroundHover: ""
    property string backgroundPressed: ""

    property Component rowDelegate: defaultRowDelegate

    signal valueChanged(int id)

    Component {
        id: defaultRowDelegate
        Text {
            anchors.fill: parent
            anchors.leftMargin: 6 + (LayoutMirroring.enabled ? arrow.width : 0)
            anchors.bottomMargin: 0
            verticalAlignment: Text.AlignVCenter
            color: container.textColor
            font: container.font

            text: parent.modelItem.name
        }
    }

    onFocusChanged: if (!container.activeFocus) close(false)

    Image {
        id: main
        anchors.fill: parent
        fillMode: Image.Stretch
        source: backgroundNormal
        states: [
            State {
                name: "hover"; when: mouseArea.containsMouse
                PropertyChanges { target: main; source: backgroundHover }
            },
            State {
                name: "focus"; when: container.activeFocus && !mouseArea.containsMouse
                PropertyChanges { target: main; source: backgroundPressed }
            }
        ]
    }

    Loader {
        id: topRow
        anchors.fill: parent
        focus: true
        clip: true

        sourceComponent: rowDelegate
        property variant modelItem
    }

    Image {
        id: arrowBox
        anchors.right: parent.right
        width: container.height
        height: container.height
        smooth: true
        fillMode: Image.Stretch
    }

    MouseArea {
        id: mouseArea
        anchors.fill: container
        hoverEnabled: true

        onEntered: if (main.state == "") main.state = "hover";
        onExited: if (main.state == "hover") main.state = "";
        onClicked: { container.focus = true; toggle() }
        onWheel: {
            if (wheel.angleDelta.y > 0)
                listView.decrementCurrentIndex()
            else
                listView.incrementCurrentIndex()
        }
    }

    Keys.onPressed: (event)=> {
        if (event.key === Qt.Key_Up) {
            listView.decrementCurrentIndex()
        } else if (event.key === Qt.Key_Down) {
            if (event.modifiers !== Qt.AltModifier)
                listView.incrementCurrentIndex()
            else
                toggle()
        } else if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
            close(true)
        } else if (event.key === Qt.Key_Escape) {
            close(false)
        }
    }

    Rectangle {
        id: dropDown
        width: container.width; height: 0
        anchors.bottom: container.top
        anchors.topMargin: 0
        color: container.menuColor
        clip: true

        Behavior on height { NumberAnimation { duration: 100 } }

        Component {
            id: myDelegate

            Rectangle {
                width: dropDown.width - 3; height: container.height - 3
                color: "transparent"

                Loader {
                    id: loader
                    anchors.fill: parent
                    sourceComponent: rowDelegate

                    property variant modelItem: model
                }

                property variant modelItem: model

                MouseArea {
                    id: delegateMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: listView.currentIndex = index
                    onClicked: close(true)
                }
            }
        }

        ListView {
            id: listView
            width: container.width; height: (container.height - 2*container.borderWidth) * count + container.borderWidth
            delegate: myDelegate
            highlight: Rectangle {
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined;
                color: container.hoverColor
            }
        }

        Rectangle {
            anchors.fill: listView
            anchors.topMargin: -container.borderWidth
            color: "transparent"
            clip: false
            border.color: hoverColor
            border.width: 1
        }

        states: [
            State {
                name: "visible";
                PropertyChanges { target: dropDown; height: (container.height - 2*container.borderWidth) * listView.count + container.borderWidth}
            }
        ]
    }

    function toggle() {
        if (dropDown.state === "visible")
            close(false)
        else
            open()
    }

    function open() {
        dropDown.state = "visible"
        listView.currentIndex = container.index
    }

    function close(update) {
        dropDown.state = ""

        if (update) {
            container.index = listView.currentIndex
            topRow.modelItem = listView.currentItem.modelItem
            valueChanged(listView.currentIndex)
        }
    }

    Component.onCompleted: {
        listView.currentIndex = container.index
        if (listView.currentItem)
            topRow.modelItem = listView.currentItem.modelItem
    }

    onIndexChanged: {
        listView.currentIndex = container.index
        if (listView.currentItem)
            topRow.modelItem = listView.currentItem.modelItem
    }

    onModelChanged: {
        listView.currentIndex = container.index
        if (listView.currentItem)
            topRow.modelItem = listView.currentItem.modelItem
    }
}
