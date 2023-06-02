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

    property var cardComp: [cardA, cardB, cardC]
    property int cardIndex: 0

    function prepareNextCard(ans) {
        // Generate Index
        cardIndex = (cardIndex + 1) % 3

        // Update Card Info
        var nextQuestion
        var nextQuestionInfo

        if(cardIndex == 0) {
            nextQuestion = decisionHandler.getNextQuestion(cardInfoB.question, ans)
            nextQuestionInfo = decisionHandler.getQuestionInfo(nextQuestion)
            cardInfoA.question = nextQuestion
            cardInfoA.nextQuestionA = nextQuestionInfo[0]
            cardInfoA.nextQuestionB = nextQuestionInfo[1]
        }
        else {
            nextQuestion = decisionHandler.getNextQuestion(cardInfoA.question, ans)
            nextQuestionInfo = decisionHandler.getQuestionInfo(nextQuestion)
            cardInfoB.question = nextQuestion
            cardInfoB.nextQuestionA = nextQuestionInfo[0]
            cardInfoB.nextQuestionB = nextQuestionInfo[1]
        }

        // Update Card to stack
        decisionStack.moveItem(0,2)
        decisionStack.incrementCurrentIndex()
    }

    function preparePrevCard() {
        // Generate Index
        cardIndex = (cardIndex - 1) % 2
        if(cardIndex == -1) {
            cardIndex = 1;
        }

        // Update Card Info
        var prevQuestion
        var prevQuestionInfo

        if(cardIndex == 0) {
            prevQuestion = decisionHandler.getNextQuestion(cardInfoB.question, ans)
            prevQuestionInfo = decisionHandler.getQuestionInfo(nextQuestion)
            cardInfoA.question = prevQuestion
            cardInfoA.nextQuestionA = nextQuestionInfo[0]
            cardInfoA.nextQuestionB = nextQuestionInfo[1]
        }
        else {
            prevQuestion = decisionHandler.getNextQuestion(cardInfoA.question, ans)
            prevQuestionInfo = decisionHandler.getQuestionInfo(nextQuestion)
            cardInfoB.question = prevQuestion
            cardInfoB.nextQuestionA = prevQuestionInfo[0]
            cardInfoB.nextQuestionB = prevQuestionInfo[1]
        }

        // Update Card to stack
        decisionStack.setCurrentIndex(cardIndex)
    }

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

    SwipeView {
        id: decisionStack
        width: respAvg(320)
        height: respAvg(400)
        currentIndex: 1
        clip: true
        anchors {
            top: logBox.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: respAvg(5)
        }

        Item {
            id: cardA
            DecisionCard {
                id: cardInfoA
                question: "Card A"
                nextQuestionA: ""
                nextQuestionB: ""

                yesBtnArea.onClicked: {
                    var time = stopwatchTime
                    logModel.append({ logText: time + "->" + cardInfoA.question + " Yes" })
                    logListView.positionViewAtEnd()
                    prepareNextCard("yes")
                }

                noBtnArea.onClicked: {
                    var time = stopwatchTime
                    logModel.append({ logText: time + "->" + cardInfoA.question + " No" })
                    logListView.positionViewAtEnd()
                    prepareNextCard("no")
                }
            }
        }

        Item {
            id: cardB
            DecisionCard {
                id: cardInfoB
                question: "Card B"
                nextQuestionA: ""
                nextQuestionB: ""

                yesBtnArea.onClicked: {
                    var time = stopwatchTime
                    logModel.append({ logText: time + "->" + cardInfoB.question + " Yes" })
                    logListView.positionViewAtEnd()
                    prepareNextCard("yes")
                }

                noBtnArea.onClicked: {
                    var time = stopwatchTime
                    logModel.append({ logText: time + "->" + cardInfoB.question + " No" })
                    logListView.positionViewAtEnd()
                    prepareNextCard("no")
                }
            }
        }

        Item {
            id: cardC
            DecisionCard {
                id: cardInfoC
                question: "Card C"
                nextQuestionA: ""
                nextQuestionB: ""

                yesBtnArea.onClicked: {
                    var time = stopwatchTime
                    logModel.append({ logText: time + "->" + cardInfoC.question + " Yes" })
                    logListView.positionViewAtEnd()
                    prepareNextCard("yes")
                }

                noBtnArea.onClicked: {
                    var time = stopwatchTime
                    logModel.append({ logText: time + "->" + cardInfoC.question + " No" })
                    logListView.positionViewAtEnd()
                    prepareNextCard("no")
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
            bottom: decisionStack.bottom
            horizontalCenter: decisionStack.horizontalCenter
            bottomMargin: respHeight(30)
        }

        onClicked: {
            preparePrevCard()
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

    Component.onCompleted: {
        var startQuestion = decisionHandler.getStartQuestion()
        var startQuestionInfo = decisionHandler.getQuestionInfo(startQuestion)
        cardInfoA.question = startQuestion
        cardInfoA.nextQuestionA = startQuestionInfo[0]
        cardInfoA.nextQuestionB = startQuestionInfo[1]
    }
}
