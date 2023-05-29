import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root
    property string objectName: "LogicPage"

    property bool showLevel1: true
    property bool showLevel2: false
    property bool showLevel3: false

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#F5F5F5"
    }


    Label {
        id: q1
        width: respWidth(280)
        height: respHeight(78)
        text: "Participant with disabilities?"
        verticalAlignment: TextInput.AlignVCenter
        color: "#1E232C"
        font.pixelSize: 20
        font.bold: true
        anchors{
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            topMargin: respHeight(150)
        }
    }

    Button {
        text: "Yes"
        width: respWidth(100)
        height: respHeight(50)
        anchors {
            top: q1.bottom
            right: parent.horizontalCenter
            topMargin: respHeight(40)
            rightMargin: respWidth(40)
        }

        onClicked: {
            showLevel1 = false
            showLevel2 = true
        }
    }

    Button {
        text: "No"
        width: respWidth(100)
        height: respHeight(50)
        anchors {
            top: q1.bottom
            left: parent.horizontalCenter
            topMargin: respHeight(40)
            leftMargin: respWidth(40)
        }

        onClicked: {
            showLevel1 = false
            showLevel3 = true
        }
    }
}
