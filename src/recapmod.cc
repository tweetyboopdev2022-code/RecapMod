#include <NickelHook.h>
#include <QApplication>
#include <QMainWindow>
#include <QTabWidget>
#include <QWidget>
#include <QVBoxLayout>
#include <QLabel>
#include <QPushButton>
#include <QTextEdit>
#include <QDir>
#include <QFile>
#include <QTextStream>
#include <QMessageBox>

// Global variables
static QTabWidget* g_tabWidget = nullptr;
static QWidget* g_recapTab = nullptr;

// Function to create the Recap tab content
static void createRecapTabContent() {
    if (!g_recapTab) {
        g_recapTab = new QWidget();
        
        QVBoxLayout* layout = new QVBoxLayout(g_recapTab);
        
        QLabel* titleLabel = new QLabel("Recap Mod");
        titleLabel->setStyleSheet("font-size: 18px; font-weight: bold; margin: 10px;");
        
        QLabel* descriptionLabel = new QLabel("This tab shows a recap of your reading progress.");
        descriptionLabel->setWordWrap(true);
        
        QTextEdit* recapTextEdit = new QTextEdit();
        recapTextEdit->setReadOnly(true);
        recapTextEdit->setPlainText("Reading recap would appear here.\n\n"
                                    "Features:\n"
                                    "- Reading progress summary\n"
                                    "- Book statistics\n"
                                    "- Recent activity\n"
                                    "- Quick access to notes");
        
        QPushButton* refreshButton = new QPushButton("Refresh Recap");
        connect(refreshButton, &QPushButton::clicked, [recapTextEdit]() {
            recapTextEdit->setPlainText("Recap refreshed!\n\n"
                                       "Reading progress summary:\n"
                                       "- Books read this week: 2\n"
                                       "- Pages read: 156\n"
                                       "- Reading time: 3h 24m");
        });
        
        layout->addWidget(titleLabel);
        layout->addWidget(descriptionLabel);
        layout->addWidget(recapTextEdit);
        layout->addWidget(refreshButton);
        
        g_recapTab->setLayout(layout);
    }
}

// Plugin initialization
NH_INIT {
    // Create the recap tab when plugin is initialized
    createRecapTabContent();
    
    // Try to add tab to main window (this might need adjustment based on actual NickelHook API)
    if (g_tabWidget) {
        g_tabWidget->addTab(g_recapTab, "Recap");
    }
    
    return 0;
}

// Plugin cleanup
NH_FINI {
    // Cleanup code when plugin is unloaded
    if (g_recapTab) {
        delete g_recapTab;
        g_recapTab = nullptr;
    }
    
    return 0;
}
