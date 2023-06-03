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
    Q_INVOKABLE void removeElementsUserChoice(QString activeQuestion, QString answer);
    Q_INVOKABLE void clearUserChoice();

    Q_INVOKABLE void generateResult();
    Q_INVOKABLE void clearResult();
    Q_INVOKABLE QList<QStringList> getResult();

    Q_INVOKABLE QList<QStringList> getLogs();
    Q_INVOKABLE void setLogs(QString logEntry);
    Q_INVOKABLE void clearLogs();

    Q_INVOKABLE QString getCompletionTime();
    Q_INVOKABLE void setCompletionTime(QString time);

signals:

private:
    QMap<QString, QStringList> m_treeMap;
    QMap<QString, QString> m_userChoices;
    QList<QStringList> m_result;
    QList<QStringList> m_logs;
    QString m_completionTime;
};

#endif // DECISIONHANDLER_H
