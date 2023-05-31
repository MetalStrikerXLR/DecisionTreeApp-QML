#ifndef AUTHHANDLER_H
#define AUTHHANDLER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>

class AuthHandler : public QObject
{
    Q_OBJECT

public:
    explicit AuthHandler(QObject *parent = nullptr);
    ~AuthHandler();

    Q_PROPERTY(QString activeUserName READ getActiveUserName WRITE setActiveUserName NOTIFY activeUserNameChanged)
    Q_PROPERTY(QString activeUserEmail READ getActiveUserEmail WRITE setActiveUserEmail NOTIFY activeUserEmailChanged)

    Q_INVOKABLE void signUserUp(const QString &userName, const QString &emailAddress, const QString &password);
    Q_INVOKABLE void signUserIn(const QString &emailAddress, const QString &password);
    Q_INVOKABLE void signUserOut();
    Q_INVOKABLE void checkSignUpInfo(const QString &userName,const QString &emailAddress, const QString &password, const QString &confirmPassword);
    Q_INVOKABLE void checkSignInInfo(const QString &emailAddress, const QString &password);

    QString getActiveUserName();
    void setActiveUserName(QString userName);

    QString getActiveUserEmail();
    void setActiveUserEmail(QString userEmail);

    QString getAPIKey();
    void setAPIKey(const QString &apiKey);

    QString getDatabaseURL();
    void setDatabaseURL(const QString &databaseURL);

public slots:
    void networkReplyReadyRead();

signals:
    void userSignedIn();
    void userSignedUp();
    void userSignInInfoChecked(QString info);
    void userSignUpInfoChecked(QString info);

    void activeUserNameChanged();
    void activeUserEmailChanged();

private:
    void performPOST(const QString & url, const QJsonDocument & payload);
    void parseResponse(const QByteArray & reponse);
    void getUserInfo();
    void createUserDatabaseEntry();

    QString m_apiKey;
    QString m_databaseURL;
    QString m_idToken;

    QString m_activeUserName;
    QString m_activeUserEmail;

    QString m_signUpEndpoint;
    QString m_signInEndpoint;

    bool m_signingUpState = false;

    QNetworkAccessManager * m_networkAccessManager;
    QNetworkReply * m_networkReply;
};

#endif // AUTHHANDLER_H
