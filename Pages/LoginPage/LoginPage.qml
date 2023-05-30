import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root
    property string objectName: "LoginPage"

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#F5F5F5"
    }

    Label {
        id: loginWelcome
        width: respWidth(280)
        height: respHeight(78)
        text: "Welcome back!\nLets Login"
        verticalAlignment: TextInput.AlignVCenter
        color: "#1E232C"
        font.pixelSize: respAvg(25)
        font.bold: true
        anchors{
            top: parent.top
            left: loginEmail.left
            topMargin: respHeight(145)
        }
    }

    Image {
        id: backbtn
        width: respAvg(50)
        height: respAvg(50)
        source: "qrc:/Assets/Components/backBtn.png"
        anchors{
            top: parent.top
            left: parent.left
            topMargin: respHeight(55)
            leftMargin: respWidth(20)
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                emailInput.text = ""
                passInput.text = ""
                mainSwipeView.setCurrentIndex(0)
            }
        }
    }

    Rectangle {
        id: loginEmail
        width: respWidth(330)
        height: respHeight(56)
        color: "#DADADA"
        radius: 8
        border.color: "#8391A1"
        clip: true
        anchors{
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            topMargin: respHeight(280)
        }

        TextInput {
            id: emailInput
            property string placeholderText:  qsTr("Enter your Email")

            Text {
                text: emailInput.placeholderText
                color: "#aaa"
                font.family: "Urbanist"
                font.pixelSize: 15
                font.weight: 30
                font.bold: true
                verticalAlignment: TextInput.AlignVCenter
                anchors {
                    fill: parent
                }

                visible: !emailInput.text && !emailInput.activeFocus
            }

            font.family: "Urbanist"
            font.pixelSize: 15
            font.weight: 30
            font.bold: true
            verticalAlignment: TextInput.AlignVCenter
            anchors {
                fill: parent
                leftMargin: 20
            }
        }
    }

    Rectangle {
        id: loginPass
        width: respWidth(330)
        height: respHeight(56)
        color: "#DADADA"
        radius: 8
        border.color: "#8391A1"
        anchors{
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            topMargin: respHeight(351)
        }

        TextInput {
            id: passInput
            property string placeholderText:  qsTr("Enter your Password")

            Text {
                text: passInput.placeholderText
                color: "#aaa"
                font.family: "Urbanist"
                font.pixelSize: 15
                font.weight: 30
                font.bold: true
                verticalAlignment: TextInput.AlignVCenter
                anchors {
                    fill: parent
                }

                visible: !passInput.text && !passInput.activeFocus
            }

            echoMode: TextInput.Password
            font.family: "Urbanist"
            font.pixelSize: 15
            font.weight: 30
            font.bold: true
            verticalAlignment: TextInput.AlignVCenter
            anchors {
                fill: parent
                leftMargin: 20
            }
        }
    }

    Rectangle {
        id: loginBtn
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

            onPressed: {
                parent.color = "#344667"
            }

            onReleased: {
                parent.color = "#1E232C"
            }

            onClicked: {
                console.log("Loging In")
                loadingIcon.visible = true
                authHandler.checkSignInInfo(emailInput.text, passInput.text)
            }
        }
    }

    Image {
        id: loginOptionsPH
        width: respAvg(250)
        height: respAvg(75)
        source: "qrc:/Assets/Components/loginOptionPlaceholder.png"
        anchors{
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            topMargin: respHeight(583)
        }
    }

    Image {
        id: loadingIcon
        width: respAvg(40)
        height: respAvg(40)
        source: "qrc:/Assets/Components/loadingIcon.png"
        visible: false
        anchors{
            bottom: loginBtn.top
            horizontalCenter: loginBtn.horizontalCenter
            bottomMargin: respHeight(15)
        }

        RotationAnimator {
            target: loadingIcon;
            from: 0;
            to: 360;
            loops: Animation.Infinite
            duration: 2000
            running: true
        }
    }

    Connections {
        target: authHandler

        function onUserSignInInfoChecked(info) {

            if(info === "OK") {
                authHandler.signUserIn(emailInput.text, passInput.text)
            }
            else {
                console.log(info)
                loadingIcon.visible = false
            }
        }

        function onUserSignedIn() {
            emailInput.text = ""
            passInput.text = ""
            loadingIcon.visible = false
            mainSwipeView.setCurrentIndex(3)
        }
    }
}
