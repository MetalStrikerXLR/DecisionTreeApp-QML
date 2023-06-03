#include "firebaseuploader.h"
#include <QDebug>
#include <QVariantMap>
#include <QNetworkRequest>
#include <QJsonObject>
#include <QThread>

FirebaseUploader::FirebaseUploader(AuthHandler *authHandler, DecisionHandler *decisionHandler, QObject *parent)
    : QObject{parent}
{
    m_authHandler = authHandler;
    m_decisionHandler = decisionHandler;

    // Initialize NetworkManager to communicate with firebase
    m_networkAccessManager = new QNetworkAccessManager(this);
}

FirebaseUploader::~FirebaseUploader()
{
    m_authHandler = nullptr;
    m_decisionHandler = nullptr;
}

void FirebaseUploader::uploadData()
{
    deleteLogs();
    deleteResult();

    QString completionTime = m_decisionHandler->getCompletionTime();
    QList<QStringList> logs = m_decisionHandler->getLogs();
    QList<QStringList> result = m_decisionHandler->getResult();

    QString parsedEmail = m_authHandler->getActiveUserEmail();
    parsedEmail = parsedEmail.replace(".", "-");

    QString endPoint = m_authHandler->getDatabaseURL() + "Users/" + parsedEmail + ".json?auth=" + m_authHandler->getUserToken();

    QVariantMap resultData;
    for(int i = 0; i < result.count(); i++) {
        resultData[result[i][0]] = result[i][1];
    }

    QVariantMap logData;
    for(int i = 0; i < logs.count(); i++) {
        logData[logs[i][0]] = logs[i][1];
    }

    QVariantMap jsonData;
    jsonData["name"] = m_authHandler->getActiveUserName();
    jsonData["completion time"] = completionTime;
    jsonData["result"] = resultData;
    jsonData["logs"] = logData;

    QJsonDocument jsonDoc = QJsonDocument::fromVariant(jsonData);

    QNetworkRequest uploadDataRequest((QUrl(endPoint)));
    uploadDataRequest.setHeader( QNetworkRequest::ContentTypeHeader, QString( "application/json"));
    m_networkReply = m_networkAccessManager->sendCustomRequest(uploadDataRequest,"PUT", jsonDoc.toJson());
    connect(m_networkReply, &QNetworkReply::readyRead, this, &FirebaseUploader::networkReplyReadyRead);
}

void FirebaseUploader::deleteLogs()
{
    QString parsedEmail = m_authHandler->getActiveUserEmail();
    parsedEmail = parsedEmail.replace(".", "-");

    QString deleteEndPoint = m_authHandler->getDatabaseURL() + "Users/" + parsedEmail + "/logs.json?auth=" + m_authHandler->getUserToken();

    QNetworkRequest deleteEntryRequest((QUrl(deleteEndPoint)));
    deleteEntryRequest.setHeader( QNetworkRequest::ContentTypeHeader, QString( "application/json"));
    m_networkReply = m_networkAccessManager->sendCustomRequest(deleteEntryRequest,"DELETE");

    QThread::sleep(1);
}

void FirebaseUploader::deleteResult()
{
    QString parsedEmail = m_authHandler->getActiveUserEmail();
    parsedEmail = parsedEmail.replace(".", "-");

    QString deleteEndPoint = m_authHandler->getDatabaseURL() + "Users/" + parsedEmail + "/result.json?auth=" + m_authHandler->getUserToken();

    QNetworkRequest deleteEntryRequest((QUrl(deleteEndPoint)));
    deleteEntryRequest.setHeader( QNetworkRequest::ContentTypeHeader, QString( "application/json"));
    m_networkReply = m_networkAccessManager->sendCustomRequest(deleteEntryRequest,"DELETE");

    QThread::sleep(1);
}

void FirebaseUploader::performPOST(const QString &url, const QJsonDocument &payload)
{
    QNetworkRequest newRequest((QUrl(url)));
    newRequest.setHeader( QNetworkRequest::ContentTypeHeader, QString( "application/json"));
    m_networkReply = m_networkAccessManager->post( newRequest, payload.toJson());
    connect(m_networkReply, &QNetworkReply::readyRead, this, &FirebaseUploader::networkReplyReadyRead);
}

void FirebaseUploader::networkReplyReadyRead()
{
    QByteArray response = m_networkReply->readAll();
    //    m_networkReply->deleteLater();

    parseResponse(response);
}

void FirebaseUploader::parseResponse(const QByteArray &response)
{
    qDebug() << "Parse:" << response;
    QJsonDocument jsonDocument = QJsonDocument::fromJson(response);

    if (jsonDocument.object().contains("error")) {
        qDebug() << "Error occured!" << response;
    }
}
