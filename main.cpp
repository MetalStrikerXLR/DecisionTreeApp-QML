#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "Modules/authhandler.h"
#include "Modules/decisionhandler.h"
#include "Modules/firebaseuploader.h"

#ifdef Q_OS_ANDROID
#include <QtCore/private/qandroidextras_p.h>
#endif

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    //****************************************************************/
    // Initialize GUI Application and QML Engine
    //****************************************************************/
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    //****************************************************************/
    // Initialize and expose backend modules here
    //****************************************************************/

    // Enter you Firebase API key and Firebase Realtime Database URL here.
    AuthHandler *authHandler = new AuthHandler();
    authHandler->setAPIKey("AIzaSyBtZpxwevk9KN3MZhW8HrCX8JUrke7Ro9U");
    authHandler->setDatabaseURL("https://qtappfirebasetest-default-rtdb.asia-southeast1.firebasedatabase.app/");
    engine.rootContext()->setContextProperty("authHandler", authHandler);

    DecisionHandler *decisionHandler = new DecisionHandler();
    engine.rootContext()->setContextProperty("decisionHandler", decisionHandler);

    FirebaseUploader *firebaseUploader = new FirebaseUploader(authHandler, decisionHandler);
    engine.rootContext()->setContextProperty("firebaseUploader", firebaseUploader);

    //****************************************************************/
    // Load QML main page
    //****************************************************************/
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
