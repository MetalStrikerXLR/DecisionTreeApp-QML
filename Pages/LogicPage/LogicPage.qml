import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root
    property string objectName: "LogicPage"

    property var logicTimer: logicTimer
    property var logModel: logModel
    property var logListView: logListView
    property string currentTime: ""
    property string currentDate: ""
    property string stopwatchTime: "00:00"

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#F5F5F5"
    }

    Image {
        id: logBox
        width: respAvg(320)
        height: respAvg(80)
        source: "qrc:/Assets/LogicPage/decisionCard.png"
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            topMargin: respHeight(10)
            horizontalCenterOffset: respWidth(10)
        }

        Rectangle {
            width: respAvg(270)
            height: respAvg(65)
            anchors {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
                verticalCenterOffset: -respHeight(3)
                horizontalCenterOffset: -respWidth(7)
            }

            ListModel {
                id: logModel
            }

            ListView {
                id: logListView
                anchors.fill: parent
                clip: true
                model: logModel

                delegate: Text {
                    width: parent.width
                    text: model.logText
                    font.pixelSize: respAvg(10)
                    wrapMode: Text.WordWrap
                }

                ScrollBar.vertical: ScrollBar { }
            }
        }
    }

    Image {
        id: decisionDisplay
        width: respAvg(320)
        height: respAvg(400)
        source: "qrc:/Assets/LogicPage/decisionCard.png"
        anchors {
            top: logBox.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: respAvg(5)
            horizontalCenterOffset: respWidth(10)
        }

        Label {
            id: activeQuestion
            width: parent.width * 0.8
            height: respHeight(78)
            text: "Participant with disabilities?"
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

        Rectangle {
            id: yesBtn
            width: respWidth(120)
            height: respHeight(60)
            color: "white"
            border.color: "black"
            border.width: respAvg(2)
            radius: respAvg(20)
            anchors {
                top: activeQuestion.bottom
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
                anchors.fill: parent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    yesBtn.color = "#3b8bed"
                    noBtn.color = "white"
                    var currentTime = new Date().toLocaleTimeString()
                    logModel.append({ logText: "Log " + currentTime })
                    logListView.positionViewAtEnd()
                }
            }
        }

        Rectangle {
            id: noBtn
            width: respWidth(120)
            height: respHeight(60)
            color: "white"
            border.color: "black"
            border.width: respAvg(2)
            radius: respAvg(20)
            anchors {
                top: activeQuestion.bottom
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
                anchors.fill: parent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    yesBtn.color = "white"
                    noBtn.color = "#3b8bed"
                }
            }
        }
    }

    Button {
        id: prevQuestionBtn
        text: "Prev Question"
        width: respAvg(80)
        height: respAvg(50)
        anchors {
            top: decisionDisplay.bottom
            horizontalCenter: decisionDisplay.horizontalCenter
            horizontalCenterOffset: respWidth(70)
        }
    }

    Label {
        id: stopwatch
        text: stopwatchTime
        color: "black"
        font.pixelSize: respAvg(50)
        anchors {
            top: decisionDisplay.bottom
            horizontalCenter: decisionDisplay.horizontalCenter
            topMargin: -respHeight(20)
            horizontalCenterOffset: -respWidth(100)
        }
    }

    Timer {
        id: logicTimer
        repeat: true
        interval: 1000
        running: false

        property int totalSec: 0

        onTriggered: {

            // First Calculate current date and time
            //const days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
            //const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

            //var currentDateTime = new Date()

            //let month = months[currentDateTime.getMonth()]
            //let date = currentDateTime.getDate()
            //let year = currentDateTime.getFullYear()
            //let hours = currentDateTime.getHours()
            //let minutes = currentDateTime.getMinutes()
            //let meredian = hours > 12 ? "PM" : "AM"

            //hours = hours % 12
            //hours = hours ? hours : 12
            //hours = hours < 10 ? '0'+hours : hours;
            //minutes = minutes < 10 ? '0'+minutes : minutes

            //currentTime = hours + ":" + minutes + " " + meredian
            //currentDate = month + " " + date + ", " + year

            //Then calculate stopwatch logicTimer
            totalSec++

            let stopSec = totalSec % 60
            stopSec = stopSec < 10 ? '0' + stopSec : stopSec

            let stopMin = Math.floor(totalSec/60)
            stopMin = stopMin < 10 ? '0' + stopMin : (stopMin % 60)

            stopwatchTime = stopMin + ":" + stopSec
        }
    }
}
