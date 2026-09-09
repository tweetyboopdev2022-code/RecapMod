#ifndef NHPLUGIN_H
#define NHPLUGIN_H

#include <qplugin.h>
#include <QMainWindow>
#include <QWidget>

class RecapModPlugin : public QObject, public QPluginInterface {
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "nh.recapmod" FILE "nhplugin.json")

public:
    void initialize(QMainWindow *mainWindow);
    void finalize();
    
private:
    QMainWindow *m_mainWindow;
};

#endif // NHPLUGIN_H
