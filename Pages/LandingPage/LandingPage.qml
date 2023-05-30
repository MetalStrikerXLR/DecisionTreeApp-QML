import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root
    property string objectName: "LandingPage"

    Image {
        id: background
        anchors.fill: parent
        source: "qrc:/Assets/LandingPage/background.png"
    }

    Rectangle {
        id: goToLoginBtn
        width: respWidth(330)
        height: respHeight(56)
        color: "#1E232C"
        radius: 8
        anchors{
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            topMargin: respHeight(498)
        }

        Label{
            text: "Login"
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
                loginPage.visible = true
                registerationPage.visible = false
                mainSwipeView.setCurrentIndex(1)
            }

            onPressed: {
                parent.color = "#344667"
            }

            onReleased: {
                parent.color = "#1E232C"
            }
        }
    }

    Rectangle {
        id: goToRegisterBtn
        width: respWidth(330)
        height: respHeight(56)
        color: "white"
        radius: 8
        border.color: "#1E232C"
        anchors{
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            topMargin: respHeight(569)
        }

        Label{
            text: "Register"
            font.family: "Urbanist"
            font.pixelSize: respAvg(15)
            font.weight: 30
            font.bold: true
            color: "#1E232C"
            anchors{
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }
        }

        MouseArea{
            anchors.fill: parent
            onClicked: {
                loginPage.visible = false
                registerationPage.visible = true
                mainSwipeView.setCurrentIndex(2)
            }

            onPressed: {
                parent.color = "#B2D8FB"
            }

            onReleased: {
                parent.color = "white"
            }
        }
    }

}
