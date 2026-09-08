#include <QMainWindow>
#include <QWidget>
#include <QTabWidget>
#include <QLabel>
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QPushButton>
#include <QTextEdit>
#include <QListWidget>
#include <QFileInfo>
#include <QDir>
#include <QFile>
#include <QTextStream>
#include "NickelHook/nhplugin.h"

class RecapModPlugin : public QObject, public QPluginInterface {
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "nh.recapmod" FILE "nhplugin.json")

public:
    void initialize(QMainWindow *mainWindow);
    void finalize();
    
private:
    QMainWindow *m_mainWindow;
    QWidget *m_recapTab;
    
    void createRecapTab();
    void loadBookmarks();
    void saveBookmark(const QString &title, const QString &content);
};

void RecapModPlugin::initialize(QMainWindow *mainWindow) {
    m_mainWindow = mainWindow;
    
    // Create the recap tab
    createRecapTab();
    
    // Add the tab to the main window's tab widget
    if (m_mainWindow) {
        QTabWidget *tabWidget = m_mainWindow->findChild<QTabWidget*>("tabWidget");
        if (tabWidget) {
            tabWidget->addTab(m_recapTab, "Recap");
        }
    }
}

void RecapModPlugin::finalize() {
    // Cleanup code - can be empty for simple plugins
}

void RecapModPlugin::createRecapTab() {
    m_recapTab = new QWidget();
    QVBoxLayout *layout = new QVBoxLayout(m_recapTab);
    
    QLabel *titleLabel = new QLabel("Recap Mod - Bookmarks");
    titleLabel->setStyleSheet("font-size: 18px; font-weight: bold;");
    
    QListWidget *bookmarksList = new QListWidget();
    QTextEdit *contentEdit = new QTextEdit();
    QPushButton *addButton = new QPushButton("Add Bookmark");
    
    // Connect signals
    QObject::connect(addButton, &QPushButton::clicked, [this, bookmarksList, contentEdit]() {
        QString content = contentEdit->toPlainText();
        if (!content.isEmpty()) {
            // Add to bookmarks list
            bookmarksList->addItem(content.left(50) + "...");
            contentEdit->clear();
            
            // Save bookmark (simplified)
            saveBookmark("Bookmark", content);
        }
    });
    
    // Layout
    layout->addWidget(titleLabel);
    layout->addWidget(bookmarksList);
    layout->addWidget(contentEdit);
    layout->addWidget(addButton);
    
    // Load existing bookmarks
    loadBookmarks();
}

void RecapModPlugin::loadBookmarks() {
    // Load bookmarks from file (simplified implementation)
    QString bookmarkFile = "/mnt/onboard/.kobo/recap_bookmarks.txt";
    QFile file(bookmarkFile);
    if (file.open(QIODevice::ReadOnly)) {
        QTextStream in(&file);
        QString content = in.readAll();
        // Parse and display bookmarks
        file.close();
    }
}

void RecapModPlugin::saveBookmark(const QString &title, const QString &content) {
    // Save bookmark to file (simplified implementation)
    QString bookmarkFile = "/mnt/onboard/.kobo/recap_bookmarks.txt";
    QFile file(bookmarkFile);
    if (file.open(QIODevice::WriteOnly | QIODevice::Append)) {
        QTextStream out(&file);
        out << title << ": " << content << "\n";
        file.close();
    }
}

Q_EXPORT_PLUGIN2(recapmod, RecapModPlugin)
