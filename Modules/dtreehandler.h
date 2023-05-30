#ifndef DTREEHANDLER_H
#define DTREEHANDLER_H

#include <QObject>

class DTreeHandler : public QObject
{
    Q_OBJECT
public:
    explicit DTreeHandler(QObject *parent = nullptr);
    ~DTreeHandler();

signals:

private:

};

#endif // DTREEHANDLER_H
