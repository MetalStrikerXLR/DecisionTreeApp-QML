import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    anchors.fill: parent

    property string question: "Question?"
    property string nextQuestionA: "Next A?"
    property string nextQuestionB: "Next B?"

    property alias yesBtn: yesBtn
    property alias yesBtnArea: yesBtnMouseArea
    property alias noBtn: noBtn
    property alias noBtnArea: noBtnMouseArea

    Rectangle {
        width: respAvg(320)
        height: respAvg(400)
        color: "transparent"

        Image {
            id: decisionStackBG
            anchors.fill: parent
            source: "qrc:/Assets/LogicPage/decisionCard.png"
            anchors.leftMargin: respAvg(13)
        }

        // Main Question
        Label {
            id: mainQuestion
            width: parent.width * 0.8
            height: respHeight(78)
            text: question
            verticalAlignment: TextInput.AlignVCenter
            horizontalAlignment:  TextInput.AlignHCenter
            color: "#1E232C"
            wrapMode: Text.WordWrap
            font.pixelSize: respAvg(15)
            font.bold: true
            anchors{
                top: parent.top
                horizontalCenter: parent.horizontalCenter
                topMargin: respHeight(50)
            }
        }

        // Yes Button
        Rectangle {
            id: yesBtn
            width: respAvg(80)
            height: respAvg(40)
            color: "white"
            border.color: "black"
            border.width: respAvg(2)
            radius: respAvg(20)
            anchors {
                top: mainQuestion.bottom
                right: parent.horizontalCenter
                topMargin: respHeight(40)
                rightMargin: respWidth(40)
            }

            Label {
                text: "Yes"
                verticalAlignment: TextInput.AlignVCenter
                horizontalAlignment:  TextInput.AlignHCenter
                color: "#1E232C"
                font.pixelSize: respAvg(10)
                font.bold: true
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            MouseArea {
                id: yesBtnMouseArea
                anchors.fill: parent
                onClicked: {
                    yesBtn.color = "#3b8bed"
                    noBtn.color = "white"
                }
            }
        }

        // No Button
        Rectangle {
            id: noBtn
            width: respAvg(80)
            height: respAvg(40)
            color: "white"
            border.color: "black"
            border.width: respAvg(2)
            radius: respAvg(20)
            anchors {
                top: mainQuestion.bottom
                left: parent.horizontalCenter
                topMargin: respHeight(40)
                leftMargin: respWidth(40)
            }

            Label {
                text: "No"
                verticalAlignment: TextInput.AlignVCenter
                horizontalAlignment:  TextInput.AlignHCenter
                color: "#1E232C"
                font.pixelSize: respAvg(10)
                font.bold: true
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            MouseArea {
                id: noBtnMouseArea
                anchors.fill: parent
                onClicked: {
                    yesBtn.color = "white"
                    noBtn.color = "#3b8bed"
                }
            }
        }

        // Next Question A
        Label {
            id: nextQuesA
            width: parent.width * 0.3
            height: respHeight(78)
            text: nextQuestionA
            verticalAlignment: TextInput.AlignVCenter
            horizontalAlignment:  TextInput.AlignHCenter
            color: "#1E232C"
            wrapMode: Text.WordWrap
            font.pixelSize: respAvg(15)
            font.bold: true
            opacity: 0.4
            anchors{
                top: yesBtn.bottom
                horizontalCenter: yesBtn.horizontalCenter
                topMargin: respHeight(90)
            }
        }

        // Next Question B
        Label {
            id: nextQuesB
            width: parent.width * 0.3
            height: respHeight(78)
            text: nextQuestionB
            verticalAlignment: TextInput.AlignVCenter
            horizontalAlignment:  TextInput.AlignHCenter
            color: "#1E232C"
            wrapMode: Text.WordWrap
            font.pixelSize: respAvg(15)
            font.bold: true
            opacity: 0.4
            anchors{
                top: noBtn.bottom
                horizontalCenter: noBtn.horizontalCenter
                topMargin: respHeight(90)
            }
        }

        Rectangle {
            id: branch1
            width: respWidth(5)
            height: respHeight(80)
            color: "black"
            anchors.horizontalCenter: mainQuestion.horizontalCenter
            anchors.bottom: noBtn.verticalCenter
        }

        Rectangle {
            id: branch2
            width: respWidth(5)
            height: respHeight(85)
            color: "black"
            anchors.horizontalCenter: nextQuesA.horizontalCenter
            anchors.bottom: nextQuesA.top
            anchors.bottomMargin: -respHeight(10)
        }

        Rectangle {
            id: branch3
            width: respWidth(5)
            height: respHeight(85)
            color: "black"
            anchors.horizontalCenter: nextQuesB.horizontalCenter
            anchors.bottom: nextQuesB.top
            anchors.bottomMargin: -respHeight(10)
        }
    }
}
