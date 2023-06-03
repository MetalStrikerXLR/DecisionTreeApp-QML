#include "decisionhandler.h"

DecisionHandler::DecisionHandler(QObject *parent) : QObject{parent} {
    /**
   *  All Tree Components are to be defined Here.
   *  Note1: Each question text needs to be unique
   *  Note2: Ensure that for each entry, there are no spelling mistakes,
   *         this can break the link between the tree.
   *  Note3: If there are no further questions in a branch, set entry to "end"
   *
   *  Syntax: m_treeMap["Main Question"] = {"Next Question on Yes", "Next Question on No"};
   **/

    m_treeMap["Start"] = {"Participants with disabilities"};

    m_treeMap["Participants with disabilities"]     = {"Hearing difficulty", "Cognitive difficulty"};
    m_treeMap["Hearing difficulty"]                 = {"Vision difficulty(A)", "Vision difficulty(B)"};
    m_treeMap["Cognitive difficulty"]               = {"Age < 65", "Ambulatory difficulty"};
    m_treeMap["Vision difficulty(A)"]               = {"end", "end"};
    m_treeMap["Vision difficulty(B)"]               = {"end", "end"};
    m_treeMap["Age < 65"]                           = {"end", "end"};
    m_treeMap["Ambulatory difficulty"]              = {"end", "end"};
}

DecisionHandler::~DecisionHandler() {}

int DecisionHandler::getTreeElements() { return m_treeMap.count(); }

QString DecisionHandler::getStartQuestion() {
    return m_treeMap.value("Start").value(0);
}

QString DecisionHandler::getNextQuestion(QString activeQuestion,
                                         QString answer) {
    if (answer == "yes") {
        return m_treeMap.value(activeQuestion).value(0);
    } else {
        return m_treeMap.value(activeQuestion).value(1);
    }
}

QString DecisionHandler::getPrevQuestion(QString activeQuestion) {
    QMapIterator<QString, QStringList> i(m_treeMap);
    while (i.hasNext()) {
        i.next();
        if (i.value().contains(activeQuestion)) {
            return i.key();
        }
    }

    return "none";
}

QStringList DecisionHandler::getQuestionInfo(QString activeQuestion) {
    return m_treeMap.value(activeQuestion);
}

QString DecisionHandler::getUserChoice(QString activeQuestion) {
    return m_userChoices.value(activeQuestion);
}

void DecisionHandler::setUserChoice(QString activeQuestion, QString answer) {
    m_userChoices.insert(activeQuestion, answer);
}

void DecisionHandler::removeElementsUserChoice(QString activeQuestion, QString answer)
{
    if (!m_userChoices.contains(activeQuestion))
    {
        return;
    }

    m_userChoices.remove(activeQuestion);

    QString nextChildQuestion = getNextQuestion(activeQuestion, answer);
    removeElementsUserChoice(nextChildQuestion, "yes");
    removeElementsUserChoice(nextChildQuestion, "no");
}

void DecisionHandler::clearUserChoice()
{
    m_userChoices.clear();
}

void DecisionHandler::generateResult()
{
    QString currentQuestion = getStartQuestion();
    QString nextQuestion = "";
    QString answer = "";

    while(nextQuestion != "end") {
        answer = m_userChoices.value(currentQuestion);
        m_result.append({currentQuestion, answer});

        nextQuestion = getNextQuestion(currentQuestion, answer);
        currentQuestion = nextQuestion;
    }
}

QList<QStringList> DecisionHandler::getResult()
{
    return m_result;
}

void DecisionHandler::clearResult()
{
    m_result.clear();
}

QList<QStringList> DecisionHandler::getLogs()
{
    return m_logs;
}

void DecisionHandler::setLogs(QString logEntry)
{
    QStringList parsedLog = logEntry.split(" -> ");
    m_logs.append(parsedLog);
}

void DecisionHandler::clearLogs()
{
    m_logs.clear();
}

QString DecisionHandler::getCompletionTime()
{
    return m_completionTime;
}

void DecisionHandler::setCompletionTime(QString time)
{
    m_completionTime = time;
}


