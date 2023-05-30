import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root
    property string objectName: "RegisterationPage"

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#F5F5F5"
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
                usernameInput.text = ""
                emailInput.text = ""
                passInput.text = ""
                passConfirmInput.text = ""
                mainSwipeView.setCurrentIndex(0)
            }
        }
    }

    Label {
        id: loginWelcome
        width: respWidth(280)
        height: respHeight(78)
        text: "Lets Begin!\nSignUp Here"
        verticalAlignment: TextInput.AlignVCenter
        color: "#1E232C"
        font.pixelSize: respAvg(25)
        font.bold: true
        anchors{
            top: parent.top
            left: registerableUsername.left
            topMargin: respHeight(145)
        }
    }

    Rectangle {
        id: registerableUsername
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
            id: usernameInput
            property string placeholderText:  qsTr("Username")

            Text {
                text: usernameInput.placeholderText
                color: "#aaa"
                font.family: "Urbanist"
                font.pixelSize: 15
                font.weight: 30
                font.bold: true
                verticalAlignment: TextInput.AlignVCenter
                anchors {
                    fill: parent
                }

                visible: !usernameInput.text && !usernameInput.activeFocus
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
        id: registerableEmail
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
            id: emailInput
            property string placeholderText:  qsTr("Email")

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
        id: registerablePass
        width: respWidth(330)
        height: respHeight(56)
        color: "#DADADA"
        radius: 8
        border.color: "#8391A1"
        anchors{
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            topMargin: respHeight(422)
        }

        TextInput {
            id: passInput
            property string placeholderText:  qsTr("Password")

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
        id: passConfirmation
        width: respWidth(330)
        height: respHeight(56)
        color: "#DADADA"
        radius: 8
        border.color: "#8391A1"
        anchors{
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            topMargin: respHeight(493)
        }

        TextInput {
            id: passConfirmInput
            property string placeholderText:  qsTr("Confirm Password")

            Text {
                text: passConfirmInput.placeholderText
                color: "#aaa"
                font.family: "Urbanist"
                font.pixelSize: 15
                font.weight: 30
                font.bold: true
                verticalAlignment: TextInput.AlignVCenter
                anchors {
                    fill: parent
                }

                visible: !passConfirmInput.text && !passConfirmInput.activeFocus // <----------- ;-)
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
        id: registerBtn
        width: respWidth(330)
        height: respHeight(56)
        color: "#1E232C"
        radius: 8
        anchors{
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            topMargin: respHeight(650)
        }

        Label{
            text: "Agree and Register"
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
                console.log("Registering")
                loadingIcon.visible = true
                authHandler.checkSignUpInfo(usernameInput.text, emailInput.text, passInput.text, passConfirmInput.text)
            }
        }
    }

    Image {
        id: loadingIcon
        width: respAvg(40)
        height: respAvg(40)
        source: "qrc:/Assets/Components/loadingIcon.png"
        visible: false
        anchors{
            bottom: registerBtn.top
            horizontalCenter: registerBtn.horizontalCenter
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

        function onUserSignUpInfoChecked(info) {

            if(info === "OK") {
                authHandler.signUserUp(usernameInput.text, emailInput.text, passInput.text)
            }
            else {
                console.log(info)
                loadingIcon.visible = false
            }
        }

        function onUserSignedUp() {
            usernameInput.text = ""
            emailInput.text = ""
            passInput.text = ""
            passConfirmInput.text = ""
            loadingIcon.visible = false
            mainSwipeView.setCurrentIndex(3)
        }
    }
}
