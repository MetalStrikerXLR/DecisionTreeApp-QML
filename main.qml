import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import "./Pages/LandingPage"
import "./Pages/LoginPage"
import "./Pages/RegisterationPage"
import "./Pages/HomePage"
import "./Pages/LogicPage"
//import "./Pages/Components"

ApplicationWindow {
    id: appRoot
    width: 450
    height: 800
    visible: true
    title: qsTr("DecisionTreeApp")

    property int baseWidth: 450
    property int baseHeight: 800
    property real baseAvg: 917.88

    function respWidth(w) {
        return appRoot.width * (w/baseWidth);
    }

    function respHeight(h) {
        return appRoot.height * (h/baseHeight);
    }

    function respAvg(a) {
        var assetAvg = Math.sqrt(Math.pow(a, 2) + Math.pow(a, 2));
        return Math.round(Math.sqrt(Math.pow(appRoot.height, 2) + Math.pow(appRoot.width, 2)) * (assetAvg / baseAvg));
    }

    // Create a swipe view for App Pages
    Rectangle {
        id: swipeViewHolder
        anchors.fill: parent
        color: "transparent"
        clip: true

        SwipeView {
            id: mainSwipeView
            currentIndex: 0
            anchors.fill: parent
            interactive: false

            LandingPage{
                id: landingPage
                visible: true
            }

            LoginPage{
                id: loginPage
                visible: true
            }

            RegisterationPage{
                id: registerationPage
                visible: true
            }

            HomePage{
                id: homePage
                visible: true
            }

            LogicPage{
                id: logicPage
                visible: true
            }
        }
    }

    onClosing: {
        console.log("Exiting QML...")
    }
}
