#include "NickelHook/nhplugin.h"

// Simple plugin that doesn't require Qt5 GUI headers
class RecapModPlugin : public QObject, public QPluginInterface {
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "nh.recapmod" FILE "nhplugin.json")

public:
    void initialize(QObject *mainWindow);
    void finalize();
};

void RecapModPlugin::initialize(QObject *mainWindow) {
    // Plugin loaded successfully - basic functionality
}

void RecapModPlugin::finalize() {}

// Required for Q_OBJECT in .cc files  
#include "recapmod.moc"
