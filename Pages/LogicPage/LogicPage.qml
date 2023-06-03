import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../Components"

Item {
    id: root
    property string objectName: "LogicPage"
    property string currentSystemTime: ""
    property string stopwatchTime: "00:00"

    property var card: [cardInfoA, cardInfoB, cardInfoC]
    property var activeCard: cardInfoB
    property int cardIndex: 1

    function loadStartQuestion() {
        var startQuestion = decisionHandler.getStartQuestion()
        var startQuestionInfo = decisionHandler.getQuestionInfo(startQuestion)
        activeCard.question = startQuestion
        activeCard.nextQuestionA = startQuestionInfo[0]
        activeCard.nextQuestionB = startQuestionInfo[1]

        resetSelection(cardInfoA)
        resetSelection(cardInfoB)
        resetSelection(cardInfoC)

        prevBtn.visible = Qt.binding(function() { return activeCard.question === decisionHandler.getStartQuestion() ? false : true })
        submitBtn.visible = Qt.binding(function() { return ((activeCard.nextQuestionA === "end") || (activeCard.nextQuestionB === "end")) ? true : false })
        doneImage.visible = false
    }

    function resetSelection(cardToReset) {
        cardToReset.yesBtn.color = "white"
        cardToReset.noBtn.color = "white"
        cardToReset.selected = false
    }

    function toggleYesSelection(cardToToggle) {
        cardToToggle.yesBtn.color = "#3b8bed"
        cardToToggle.noBtn.color = "white"
        cardToToggle.selected = true
    }

    function toggleNoSelection(cardToToggle) {
        cardToToggle.yesBtn.color = "white"
        cardToToggle.noBtn.color = "#3b8bed"
        cardToToggle.selected = true
    }

    function prepareNextCard(ans) {

        // Generate Next Index -> 0 1 2
        var nextCardIndex = (cardIndex + 1) % 3

        // Update Card Info
        var nextQuestion
        var nextQuestionInfo

        nextQuestion = decisionHandler.getNextQuestion(activeCard.question, ans)
        nextQuestionInfo = decisionHandler.getQuestionInfo(nextQuestion)
        card[nextCardIndex].question = nextQuestion
        card[nextCardIndex].nextQuestionA = nextQuestionInfo[0]
        card[nextCardIndex].nextQuestionB = nextQuestionInfo[1]

        resetSelection(card[nextCardIndex])

        if(decisionHandler.getUserChoice(nextQuestion) === "yes") {
            toggleYesSelection(card[nextCardIndex])
        }
        else if(decisionHandler.getUserChoice(nextQuestion) === "no") {
            toggleNoSelection(card[nextCardIndex])
        }
        else {
            resetSelection(card[nextCardIndex])
        }

        // Update Card to stack
        var cardToMove = decisionStack.takeItem(0)
        decisionStack.incrementCurrentIndex()
        decisionStack.insertItem(2, cardToMove)

        // Update active card
        activeCard = card[nextCardIndex]
        cardIndex = nextCardIndex
    }

    function preparePrevCard() {
        // Generate Prev Index -> 0 1 2
        var prevCardIndex = (cardIndex - 1) % 3
        if(prevCardIndex == -1) {
            prevCardIndex = 2;
        }

        // Update Card Info
        var prevQuestion
        var prevQuestionInfo

        prevQuestion = decisionHandler.getPrevQuestion(activeCard.question)
        prevQuestionInfo = decisionHandler.getQuestionInfo(prevQuestion)
        card[prevCardIndex].question = prevQuestion
        card[prevCardIndex].nextQuestionA = prevQuestionInfo[0]
        card[prevCardIndex].nextQuestionB = prevQuestionInfo[1]

        resetSelection(card[prevCardIndex])

        if(decisionHandler.getUserChoice(prevQuestion) === "yes") {
            toggleYesSelection(card[prevCardIndex])
        }
        else if(decisionHandler.getUserChoice(prevQuestion) === "no") {
            toggleNoSelection(card[prevCardIndex])
        }
        else {
            resetSelection(card[prevCardIndex])
        }

        // Update Card to stack
        var cardToMove = decisionStack.takeItem(2)
        decisionStack.decrementCurrentIndex()
        decisionStack.insertItem(0, cardToMove)

        // Update active card
        activeCard = card[prevCardIndex]
        cardIndex = prevCardIndex
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
        interactive: false
        enabled: false
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
                property bool selected: false

                yesBtnArea.onClicked: {
                    var time = stopwatchTime
                    logModel.append({ logText: time + " -> " + cardInfoA.question + ": Yes" })
                    decisionHandler.setLogs(time + " -> " + cardInfoA.question + ": Yes")
                    logListView.positionViewAtEnd()

                    // Clear oppositebranch and Store user selection
                    decisionHandler.removeElementsUserChoice(activeCard.question, "no")
                    decisionHandler.setUserChoice(activeCard.question, "yes")
                    selected = true

                    if((activeCard.nextQuestionA !== "end")) {
                        prepareNextCard("yes")
                    }
                }

                noBtnArea.onClicked: {
                    var time = stopwatchTime
                    logModel.append({ logText: time + " -> " + cardInfoA.question + ": No" })
                    decisionHandler.setLogs(time + " -> " + cardInfoA.question + ": No")
                    logListView.positionViewAtEnd()

                    // Clear oppositebranch and Store user selection
                    decisionHandler.removeElementsUserChoice(activeCard.question, "yes")
                    decisionHandler.setUserChoice(activeCard.question, "no")
                    selected = true

                    if((activeCard.nextQuestionB !== "end")) {
                        prepareNextCard("no")
                    }
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
                property bool selected: false

                yesBtnArea.onClicked: {
                    var time = stopwatchTime
                    logModel.append({ logText: time + " -> " + cardInfoB.question + ": Yes" })
                    decisionHandler.setLogs(time + " -> " + cardInfoB.question + ": Yes")
                    logListView.positionViewAtEnd()

                    // Clear oppositebranch and Store user selection
                    decisionHandler.removeElementsUserChoice(activeCard.question, "no")
                    decisionHandler.setUserChoice(activeCard.question, "yes")
                    selected = true

                    if((activeCard.nextQuestionA !== "end")) {
                        prepareNextCard("yes")
                    }
                }

                noBtnArea.onClicked: {
                    var time = stopwatchTime
                    logModel.append({ logText: time + " -> " + cardInfoB.question + ": No" })
                    decisionHandler.setLogs(time + " -> " + cardInfoB.question + ": No")
                    logListView.positionViewAtEnd()

                    // Clear oppositebranch and Store user selection
                    decisionHandler.removeElementsUserChoice(activeCard.question, "yes")
                    decisionHandler.setUserChoice(activeCard.question, "no")
                    selected = true

                    if((activeCard.nextQuestionB !== "end")) {
                        prepareNextCard("no")
                    }
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
                property bool selected: false

                yesBtnArea.onClicked: {
                    var time = stopwatchTime
                    logModel.append({ logText: time + " -> " + cardInfoC.question + ": Yes" })
                    decisionHandler.setLogs(time + " -> " + cardInfoC.question + ": Yes")
                    logListView.positionViewAtEnd()

                    // Clear oppositebranch and Store user selection
                    decisionHandler.removeElementsUserChoice(activeCard.question, "no")
                    decisionHandler.setUserChoice(activeCard.question, "yes")
                    selected = true

                    if((activeCard.nextQuestionA !== "end")) {
                        prepareNextCard("yes")
                    }
                }

                noBtnArea.onClicked: {
                    var time = stopwatchTime
                    logModel.append({ logText: time + " -> " + cardInfoC.question + ": No" })
                    decisionHandler.setLogs(time + " -> " + cardInfoC.question + ": No")
                    logListView.positionViewAtEnd()

                    // Clear oppositebranch and Store user selection
                    decisionHandler.removeElementsUserChoice(activeCard.question, "yes")
                    decisionHandler.setUserChoice(activeCard.question, "no")
                    selected = true

                    if((activeCard.nextQuestionB !== "end")) {
                        prepareNextCard("no")
                    }
                }
            }
        }
    }

    Rectangle {
        id: overlay
        width: respAvg(300)
        height: respAvg(380)
        color: "gray"
        opacity:0.1
        radius: 30
        visible: decisionStack.enabled ? false : true
        anchors {
            top: logBox.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: respAvg(5)
        }
    }

    Image {
        id: doneImage
        source: "qrc:/Assets/LogicPage/submitBtn.png"
        width: respAvg(70)
        height: respAvg(70)
        visible: false
        anchors {
            bottom: decisionStack.bottom
            horizontalCenter: decisionStack.horizontalCenter
            bottomMargin: respHeight(10)
        }
    }

    Image {
        id: prevBtn
        source: "qrc:/Assets/LogicPage/backBtn.png"
        width: respAvg(70)
        height: respAvg(70)
        visible: activeCard.question === decisionHandler.getStartQuestion() ? false : true
        anchors {
            bottom: decisionStack.bottom
            horizontalCenter: decisionStack.horizontalCenter
            bottomMargin: respHeight(10)
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                var time = stopwatchTime
                logModel.append({ logText: time + " -> " + "Back" })
                decisionHandler.setLogs(time + " -> " + "Back")
                logListView.positionViewAtEnd()
                preparePrevCard()
            }
        }
    }

    Image {
        id: submitBtn
        source: "qrc:/Assets/LogicPage/submitBtn.png"
        width: respAvg(70)
        height: respAvg(70)
        visible: ((activeCard.nextQuestionA === "end") || (activeCard.nextQuestionB === "end")) ? true : false
        anchors {
            bottom: decisionStack.bottom
            horizontalCenter: decisionStack.horizontalCenter
            bottomMargin: respHeight(10)
            horizontalCenterOffset: respWidth(60)
        }

        onVisibleChanged: {
            if(submitBtn.visible){
                prevBtn.anchors.horizontalCenterOffset = -respWidth(60)
            }
            else {
                prevBtn.anchors.horizontalCenterOffset = 0
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                var time = stopwatchTime
                var systemTime = currentSystemTime
                logModel.append({ logText: time + " -> " + "Evaluation Done! (" + systemTime + ")" })
                decisionHandler.setLogs(time + " -> " + "Evaluation Done! (" + systemTime + ")")
                logListView.positionViewAtEnd()
                logicTimerA.running = false
                logicTimerA.totalSec = 0

                prevBtn.visible = false
                submitBtn.visible = false
                doneImage.visible = true

                // Generate Results
                decisionHandler.setCompletionTime(time);
                decisionHandler.generateResult();
                decisionHandler.getResult();

                // Submit Results
                firebaseUploader.uploadData();
            }
        }
    }

    Rectangle {
        id: startHomeBtn
        width: respWidth(150)
        height: respHeight(56)
        color: "#1E232C"
        radius: 100
        anchors{
            left:stopwatch.right
            verticalCenter: stopwatch.verticalCenter
            leftMargin: respWidth(30)
        }

        Label{
            id: startBtnText
            text: decisionStack.enabled ? "Home" : "Start"
            font.family: "Urbanist"
            font.pixelSize: respAvg(15)
            font.weight: 30
            font.bold: true
            color: "white"
            anchors{
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }
        }

        MouseArea{
            anchors.fill: parent
            onClicked: {
                if(startBtnText.text === "Start") {
                    logicTimerA.running = true
                    var systemTime = currentSystemTime
                    logModel.append({ logText: "00:00 -> " + "Evaluation Started! (" + systemTime + ")" })
                    decisionHandler.setLogs("00:00 -> " + "Evaluation Started! (" + systemTime + ")")
                    logListView.positionViewAtEnd()
                    decisionStack.enabled = true
                }
                else {
                    // Reset everything and Return to Home
                    mainSwipeView.setCurrentIndex(3)
                    stopwatchTime = "00:00"
                    logModel.clear()
                    logicTimerA.running = false
                    logicTimerA.totalSec = 0

                    decisionHandler.clearResult();
                    decisionHandler.clearLogs();
                    decisionHandler.clearUserChoice();

                    prevBtn.visible = false
                    submitBtn.visible = false
                    decisionStack.enabled = false
                }
            }

            onPressed: {
                parent.color = "#344667"
            }

            onReleased: {
                parent.color = "#1E232C"
            }
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
            horizontalCenterOffset: -respHeight(100)
        }
    }

    Timer {
        id: logicTimerA
        repeat: true
        interval: 1000
        running: false

        property int totalSec: 0

        onTriggered: {
            // Calculate stopwatch time
            totalSec++

            let stopSec = totalSec % 60
            stopSec = stopSec < 10 ? '0' + stopSec : stopSec

            let stopMin = Math.floor(totalSec/60)
            stopMin = stopMin < 10 ? '0' + stopMin : (stopMin % 60)

            stopwatchTime = stopMin + ":" + stopSec
        }
    }

    Timer {
        id: logicTimerB
        repeat: true
        interval: 1000
        running: true

        onTriggered: {

            // Calculate current time
            var currentDateTime = new Date()

            let hours = currentDateTime.getHours()
            let minutes = currentDateTime.getMinutes()
            let meredian = hours > 12 ? "PM" : "AM"

            hours = hours % 12
            hours = hours ? hours : 12
            hours = hours < 10 ? '0'+hours : hours;
            minutes = minutes < 10 ? '0'+minutes : minutes

            currentSystemTime = hours + ":" + minutes + " " + meredian
        }
    }
}
