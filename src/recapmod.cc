#include "NickelHook/nhplugin.h"
#include <QMainWindow>
#include <QObject>

// Forward declaration to avoid QMainWindow include issues in some cases
class QMainWindow;

// Simple plugin that doesn't require complex Qt widgets
class RecapModPlugin : public QObject, public QPluginInterface {
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "nh.recapmod" FILE "nhplugin.json")

public:
    void initialize(QMainWindow *mainWindow);
    void finalize();
    
private:
    QMainWindow *m_mainWindow;
};

void RecapModPlugin::initialize(QMainWindow *mainWindow) {
    m_mainWindow = mainWindow;
    // Simple initialization - just log that we're loaded
    if (m_mainWindow) {
        // Plugin loaded successfully - basic functionality here
    }
}

void RecapModPlugin::finalize() {}

// Required for Q_OBJECT in .cc files  
#include "recapmod.moc"
