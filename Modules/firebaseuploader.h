#ifndef FIREBASEUPLOADER_H
#define FIREBASEUPLOADER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include "Modules/authhandler.h"
#include "Modules/decisionhandler.h"

class FirebaseUploader : public QObject
{
    Q_OBJECT
public:
    explicit FirebaseUploader(AuthHandler *authHandler, DecisionHandler *decisionHandler, QObject *parent = nullptr);
    ~FirebaseUploader();

    Q_INVOKABLE void uploadData();
    Q_INVOKABLE void deleteLogs();
    Q_INVOKABLE void deleteResult();

public slots:
    void networkReplyReadyRead();

signals:
private:
    void performPOST(const QString & url, const QJsonDocument & payload);
    void parseResponse(const QByteArray & response);

    AuthHandler *m_authHandler;
    DecisionHandler *m_decisionHandler;

    QNetworkAccessManager * m_networkAccessManager;
    QNetworkReply * m_networkReply;
};

#endif // FIREBASEUPLOADER_H
