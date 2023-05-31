#ifndef DECISIONHANDLER_H
#define DECISIONHANDLER_H

#include <QObject>
#include <QMap>
#include <QDebug>

class DecisionHandler : public QObject
{
    Q_OBJECT
public:
    explicit DecisionHandler(QObject *parent = nullptr);
    ~DecisionHandler();

    Q_INVOKABLE int getTreeElements();
    Q_INVOKABLE QString getStartQuestion();
    Q_INVOKABLE QString getNextQuestion(QString activeQuestion, QString answer);
    Q_INVOKABLE QString getPrevQuestion(QString activeQuestion);
    Q_INVOKABLE QStringList getQuestionInfo(QString activeQuestion);

    Q_INVOKABLE QString getUserChoice(QString activeQuestion);
    Q_INVOKABLE void setUserChoice(QString activeQuestion, QString answer);

signals:

private:
    QMap<QString, QStringList> m_treeMap;
    QMap<QString, QString> m_userChoices;
};

#endif // DECISIONHANDLER_H
