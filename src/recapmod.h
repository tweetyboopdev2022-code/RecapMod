#pragma once

#include <QEvent>
#include <QLabel>
#include <QObject>
#include <QStackedWidget>

// Nickel's TouchLabel emits tapped(bool). Reaching it needs a real slot, so
// these classes are moc'd. The event filter stays as a fallback for button
// classes whose tapped signal does not resolve at runtime.
class RecapPager : public QObject {
    Q_OBJECT

public:
    RecapPager(QStackedWidget *stack, QLabel *counter, int delta, QObject *parent);
    void setButtons(QWidget *prev, QWidget *next);
    void refresh();

public Q_SLOTS:
    void step();

protected:
    bool eventFilter(QObject *obj, QEvent *ev) override;

private:
    QStackedWidget *m_stack;
    QLabel *m_counter;
    int m_delta;
    QWidget *m_prev;
    QWidget *m_next;
};

class RecapLauncher : public QObject {
    Q_OBJECT

public:
    explicit RecapLauncher(QObject *parent = nullptr) : QObject(parent) {}

public Q_SLOTS:
    void open();
};
