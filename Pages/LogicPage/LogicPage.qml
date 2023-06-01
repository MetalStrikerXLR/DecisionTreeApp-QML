import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../Components"

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

    Button {
        onClicked: {
            decisionStack.replace(prevCard)
        }
    }

    StackView {
        id: decisionStack
        width: respAvg(320)
        height: respAvg(400)
        initialItem: activeCard
        anchors {
            top: logBox.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: respAvg(5)
        }
    }

    Component {
        id: activeCard
        DecisionCard {
            id: cardA
            question: "Participant with disabilities?"
            nextQuestionA: "Hearing?"
            nextQuestionB: "Cognitive?"

            yesBtnArea.onClicked: {
                var time = stopwatchTime
                logModel.append({ logText: time + "->" + cardA.question + " Yes" })
                logListView.positionViewAtEnd()
            }

            noBtnArea.onClicked: {
                var time = stopwatchTime
                logModel.append({ logText: time + "->" + cardA.question + " No" })
                logListView.positionViewAtEnd()
            }
        }
    }

    Component {
        id: prevCard
        DecisionCard {
            id: cardB
            question: "Cognitive?"
            nextQuestionA: ""
            nextQuestionB: ""

            yesBtnArea.onClicked: {
                var time = stopwatchTime
                logModel.append({ logText: time + "->" + cardB.question + " Yes" })
                logListView.positionViewAtEnd()
            }

            noBtnArea.onClicked: {
                var time = stopwatchTime
                logModel.append({ logText: time + "->" + cardB.question + " No" })
                logListView.positionViewAtEnd()
            }
        }
    }

    Component {
        id: nextCard
        DecisionCard {
            id: cardC
            question: "Hearing?"
            nextQuestionA: ""
            nextQuestionB: ""

            yesBtnArea.onClicked: {
                var time = stopwatchTime
                logModel.append({ logText: time + "->" + cardC.question + " Yes" })
                logListView.positionViewAtEnd()
            }

            noBtnArea.onClicked: {
                var time = stopwatchTime
                logModel.append({ logText: time + "->" + cardC.question + " No" })
                logListView.positionViewAtEnd()
            }
        }
    }


    Button {
        id: prevQuestionBtn
        text: "Prev Question"
        width: respAvg(80)
        height: respAvg(50)
        anchors {
            bottom: decisionStack.bottom
            horizontalCenter: decisionStack.horizontalCenter
            bottomMargin: respHeight(30)
        }
    }

    Label {
        id: stopwatch
        text: stopwatchTime
        color: "black"
        font.pixelSize: respAvg(50)
        anchors {
            top: decisionStack.bottom
            horizontalCenter: decisionStack.horizontalCenter
            topMargin: -respHeight(20)
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
