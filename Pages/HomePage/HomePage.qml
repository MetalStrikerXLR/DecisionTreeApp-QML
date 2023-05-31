import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root
    property string objectName: "HomePage"

    Image {
        id: background
        anchors.fill: parent
        source: "qrc:/Assets/LandingPage/background.png"
    }

    Image {
        id: profileIcon
        source: "qrc:/Assets/HomePage/profileIcon-Male.png"
        width: respAvg(170)
        height: respAvg(170)

        visible: true
        anchors{
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            topMargin: respHeight(25)
        }
    }

    Label {
        id: userWelcome
        width: respWidth(280)
        height: respHeight(78)
        text: "Welcome!\n" + authHandler.activeUserName
        verticalAlignment: TextInput.AlignVCenter
        horizontalAlignment: TextInput.AlignHCenter
        color: "white"
        font.pixelSize: respAvg(25)
        font.bold: true
        anchors{
            top: profileIcon.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: respHeight(5)
        }
    }

    Rectangle {
        id: startBtn
        width: respWidth(330)
        height: respHeight(56)
        color: "#1E232C"
        radius: 100
        anchors{
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            topMargin: respHeight(498)
        }

        Label{
            text: "Start"
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
                mainSwipeView.setCurrentIndex(4)
                logicPage.logicTimer.running = true
                logicPage.logModel.append({ logText: "00:00 -> Evaluation Started" })
                logicPage.logListView.positionViewAtEnd()
            }

            onPressed: {
                parent.color = "#344667"
            }

            onReleased: {
                parent.color = "#1E232C"
            }
        }
    }

    Image {
        id: signoutBtn
        source: "qrc:/Assets/HomePage/signoutBtn.png"
        width: respAvg(50)
        height: respAvg(50)
        anchors{
            top: startBtn.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: respHeight(80)
        }

        Label {
            id: signoutLabel
            text: "Sign Out"
            color: "#1E232C"
            font.bold: true
            font.pixelSize: respAvg(10)
            anchors {
                top: parent.bottom
                horizontalCenter: parent.horizontalCenter
                topMargin: respHeight(5)
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                authHandler.signUserOut()
                loginPage.visible = false
                registerationPage.visible = false
                mainSwipeView.setCurrentIndex(0)
            }
        }
    }
}
