#include <QObject>
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

// Forward declare QMainWindow to avoid needing QMainWindow header
class QMainWindow;

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
    createRecapTab();
    
    if (m_mainWindow) {
        // Cast to QObject* to bypass incomplete QMainWindow definition
        QObject *mainObj = reinterpret_cast<QObject*>(m_mainWindow);
        QTabWidget *tabWidget = mainObj->findChild<QTabWidget*>("tabWidget");
        if (tabWidget) {
            tabWidget->addTab(m_recapTab, "Recap");
        }
    }
}

void RecapModPlugin::finalize() {}

void RecapModPlugin::createRecapTab() {
    m_recapTab = new QWidget();
    QVBoxLayout *layout = new QVBoxLayout(m_recapTab);
    
    QLabel *titleLabel = new QLabel("Recap Mod - Bookmarks");
    titleLabel->setStyleSheet("font-size: 18px; font-weight: bold;");
    
    QListWidget *bookmarksList = new QListWidget();
    QTextEdit *contentEdit = new QTextEdit();
    QPushButton *addButton = new QPushButton("Add Bookmark");
    
    QObject::connect(addButton, &QPushButton::clicked, [this, bookmarksList, contentEdit]() {
        QString content = contentEdit->toPlainText();
        if (!content.isEmpty()) {
            bookmarksList->addItem(content.left(50) + "...");
            contentEdit->clear();
            saveBookmark("Bookmark", content);
        }
    });
    
    layout->addWidget(titleLabel);
    layout->addWidget(bookmarksList);
    layout->addWidget(contentEdit);
    layout->addWidget(addButton);
    
    loadBookmarks();
}

void RecapModPlugin::loadBookmarks() {
    QString bookmarkFile = "/mnt/onboard/.kobo/recap_bookmarks.txt";
    QFile file(bookmarkFile);
    if (file.open(QIODevice::ReadOnly)) {
        QTextStream in(&file);
        QString content = in.readAll();
        file.close();
    }
}

void RecapModPlugin::saveBookmark(const QString &title, const QString &content) {
    QString bookmarkFile = "/mnt/onboard/.kobo/recap_bookmarks.txt";
    QFile file(bookmarkFile);
    if (file.open(QIODevice::WriteOnly | QIODevice::Append)) {
        QTextStream out(&file);
        out << title << ": " << content << "\n";
        file.close();
    }
}

// Required for Q_OBJECT in .cc files
#include "recapmod.moc"
