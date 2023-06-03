#include "authhandler.h"
#include <QDebug>
#include <QVariantMap>
#include <QNetworkRequest>
#include <QJsonObject>

AuthHandler::AuthHandler(QObject *parent)
    : QObject(parent)
    , m_apiKey( QString() )
{
    // Define Endpoint URLs
    m_signUpEndpoint = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=";
    m_signInEndpoint = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=";

    // Initialize NetworkManager to communicate with firebase
    m_networkAccessManager = new QNetworkAccessManager(this);
}

AuthHandler::~AuthHandler()
{
    m_networkAccessManager->deleteLater();
}

QString AuthHandler::getActiveUserName()
{
    return m_activeUserName;
}

void AuthHandler::setActiveUserName(QString userName)
{
    m_activeUserName = userName;
    emit activeUserNameChanged();
}

QString AuthHandler::getActiveUserEmail()
{
    return m_activeUserEmail;
}

void AuthHandler::setActiveUserEmail(QString userEmail)
{
    m_activeUserEmail = userEmail;
    emit activeUserNameChanged();
}

QString AuthHandler::getAPIKey()
{
    return m_apiKey;
}

void AuthHandler::setAPIKey(const QString &apiKey)
{
    m_apiKey = apiKey;
}

QString AuthHandler::getDatabaseURL()
{
    return m_databaseURL;
}

void AuthHandler::setDatabaseURL(const QString &databaseURL)
{
    m_databaseURL = databaseURL;
}

QString AuthHandler::getUserToken()
{
    return m_idToken;
}

void AuthHandler::signUserUp(const QString &userName, const QString &emailAddress, const QString &password)
{
    m_signingUpState = true;
    setActiveUserName(userName);
    setActiveUserEmail(emailAddress);

    QString signUpEndpointAPI = m_signUpEndpoint + m_apiKey;

    QVariantMap credentialPayload;
    credentialPayload["email"] = emailAddress;
    credentialPayload["password"] = password;
    credentialPayload["returnSecureToken"] = true;

    QJsonDocument jsonPayload = QJsonDocument::fromVariant(credentialPayload);
    performPOST(signUpEndpointAPI, jsonPayload);
}

void AuthHandler::signUserIn(const QString &emailAddress, const QString &password)
{
    m_signingUpState = false;
    setActiveUserEmail(emailAddress);

    QString signInEndpointAPI = m_signInEndpoint + m_apiKey;

    QVariantMap credentialPayload;
    credentialPayload["email"] = emailAddress;
    credentialPayload["password"] = password;
    credentialPayload["returnSecureToken"] = true;

    QJsonDocument jsonPayload = QJsonDocument::fromVariant( credentialPayload );
    performPOST(signInEndpointAPI, jsonPayload);
}

void AuthHandler::signUserOut()
{
    m_idToken = "";
}

void AuthHandler::checkSignUpInfo(const QString &userName, const QString &emailAddress, const QString &password, const QString &confirmPassword)
{
    QRegularExpression regex("\\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}\\b");
    QRegularExpressionMatch match = regex.match(emailAddress);

    if(userName == "") {
        emit userSignUpInfoChecked("Please Enter Username");
    }
    else if(emailAddress == "") {
        emit userSignUpInfoChecked("Please Enter Email");
    }
    else if(match.hasMatch() == false) {
        emit userSignUpInfoChecked("Please Enter valid Email");
    }
    else if(password == "") {
        emit userSignUpInfoChecked("Please Enter Password");
    }
    else if(confirmPassword == "") {
        emit userSignUpInfoChecked("Please Confirm Password");
    }
    else if(password != confirmPassword) {
        emit userSignUpInfoChecked("Confirmation Password Incorrect");
    }
    else if(password.length() < 6) {
        emit userSignUpInfoChecked("Password should be at least 6 characters");
    }
    else {
        emit userSignUpInfoChecked("OK");
    }
}

void AuthHandler::checkSignInInfo(const QString &emailAddress, const QString &password)
{
    QRegularExpression regex("\\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}\\b");
    QRegularExpressionMatch match = regex.match(emailAddress);

    if(emailAddress == "") {
        emit userSignInInfoChecked("Please Enter Email");
    }
    else if(match.hasMatch() == false) {
        emit userSignInInfoChecked("Please Enter valid Email");
    }
    else if(password == "") {
        emit userSignInInfoChecked("Please Enter Password");
    }
    else {
        emit userSignInInfoChecked("OK");
    }
}

void AuthHandler::performPOST(const QString &url, const QJsonDocument &payload)
{
    QNetworkRequest newRequest((QUrl(url)));
    newRequest.setHeader( QNetworkRequest::ContentTypeHeader, QString( "application/json"));
    //    m_networkReply = m_networkAccessManager->post( newRequest, payload.toJson());
    m_networkReply = m_networkAccessManager->sendCustomRequest(newRequest,"POST", payload.toJson());
    connect(m_networkReply, &QNetworkReply::readyRead, this, &AuthHandler::networkReplyReadyRead);
}

void AuthHandler::getUserInfo()
{
    QString parsedEmail = getActiveUserEmail();
    parsedEmail = parsedEmail.replace(".", "-");

    QString endPoint = m_databaseURL + "Users/" + parsedEmail + ".json?auth=" + m_idToken;
    m_networkReply = m_networkAccessManager->get( QNetworkRequest(QUrl(endPoint)));
    connect( m_networkReply, &QNetworkReply::readyRead, this, &AuthHandler::networkReplyReadyRead );
}

void AuthHandler::createUserDatabaseEntry()
{
    QString parsedEmail = getActiveUserEmail();
    parsedEmail = parsedEmail.replace(".", "-");

    QString endPoint = m_databaseURL + "Users/" + parsedEmail + ".json?auth=" + m_idToken;

    QVariantMap newUser;
    newUser["name"] = getActiveUserName();

    QJsonDocument jsonDoc = QJsonDocument::fromVariant(newUser);

    QNetworkRequest newUserEntryRequest((QUrl(endPoint)));
    newUserEntryRequest.setHeader( QNetworkRequest::ContentTypeHeader, QString( "application/json"));
    m_networkReply = m_networkAccessManager->sendCustomRequest(newUserEntryRequest,"PUT", jsonDoc.toJson());
    connect(m_networkReply, &QNetworkReply::readyRead, this, &AuthHandler::networkReplyReadyRead);
}

void AuthHandler::networkReplyReadyRead()
{
    QByteArray response = m_networkReply->readAll();
    m_networkReply->deleteLater();

    parseResponse(response);
}

void AuthHandler::parseResponse(const QByteArray &response)
{
//    qDebug() << response;
    QJsonDocument jsonDocument = QJsonDocument::fromJson(response);

    if (jsonDocument.object().contains("error")) {
        qDebug() << "Error occured!" << response;

        if(m_signingUpState) {
            setActiveUserName("");
            setActiveUserEmail("");
            m_signingUpState = false;
        }
    }
    else if (jsonDocument.object().contains("kind")) {
        QString idToken = jsonDocument.object().value("idToken").toString();
        m_idToken = idToken;

        qDebug() << "User sign in successfull!";

        if(m_signingUpState) {
            createUserDatabaseEntry();
        }
        else {
            getUserInfo();
        }
    }
    else {
//        qDebug() << "The response was: " << response;
        if(m_signingUpState) {
            m_signingUpState = false;
            emit userSignedUp();
        }
        else{
            if (jsonDocument.object().contains("name")) {
                setActiveUserName(jsonDocument.object().value("name").toString());
                emit userSignedIn();
            }
        }
    }
}
