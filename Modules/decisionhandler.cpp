#include "decisionhandler.h"

DecisionHandler::DecisionHandler(QObject *parent)
    : QObject{parent}
{
    /**
     *  All Tree Components are to be defined Here.
     *  Note: Each question text needs to be unique
     *
     *  Syntax: m_treeMap["Active Question"] = {"Next Question on Yes", "Next Question on No"};
     **/

    m_treeMap["Start"] = {"Participants with disabilities"};

    m_treeMap["Participants with disabilities"] = {"Hearing difficulty", "Cognitive difficulty"};
    m_treeMap["Hearing difficulty"]             = {"Vision difficulty(A)", "Vision difficult(B)"};
    m_treeMap["Cognitive difficult"]            = {"Age < 65", "Ambulatory difficulty"};
    m_treeMap["Vision difficulty(A)"]           = {"", ""};
    m_treeMap["Vision difficulty(B)"]           = {"", ""};
    m_treeMap["Age < 65"]                       = {"", ""};
    m_treeMap["Ambulatory difficulty"]          = {"", ""};
}

DecisionHandler::~DecisionHandler()
{
}

int DecisionHandler::getTreeElements()
{
    return m_treeMap.count();
}

QString DecisionHandler::getStartQuestion()
{
    return m_treeMap.value("Start").value(0);
}

QString DecisionHandler::getNextQuestion(QString activeQuestion, QString answer)
{
    if(answer == "yes") {
        return m_treeMap.value(activeQuestion).value(0);
    }
    else {
        return m_treeMap.value(activeQuestion).value(1);
    }
}

QString DecisionHandler::getPrevQuestion(QString activeQuestion)
{
    QMapIterator<QString, QStringList> i(m_treeMap);
    while (i.hasNext()) {
        i.next();

        if(i.value().contains(activeQuestion)) {
            return i.key();
        }
    }

    return "none";
}

QStringList DecisionHandler::getQuestionInfo(QString activeQuestion)
{
    return m_treeMap.value(activeQuestion);
}

QString DecisionHandler::getUserChoice(QString activeQuestion)
{
    return m_userChoices.value(activeQuestion);
}

void DecisionHandler::setUserChoice(QString activeQuestion, QString answer)
{
    m_userChoices.insert(activeQuestion, answer);
}
