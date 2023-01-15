#ifndef QMLLIVEENIGE_H
#define QMLLIVEENIGE_H
#include <QQmlApplicationEngine>
#include <DBaseFileWatcher>
#include <QtQml>
class QFileSystemWatcher;
class QTimer;
/**
 * @brief Qml 实时预览引擎
 *
 * 继承 QMLApplicattionEngine ,通过FileStytemWacther 检测文件的变动 从而实时更新
 */
class QmlLiveEngine : public QQmlApplicationEngine
{
    Q_OBJECT
    Q_PROPERTY(QString absQmlPath MEMBER m_absQmlPath)
public:
    explicit QmlLiveEngine(QObject *parent = nullptr);
    virtual ~QmlLiveEngine();
    Q_INVOKABLE inline void clearCache() { clearComponentCache(); }
    Q_INVOKABLE QString setQmlPath(QString Qmlpath);//设置监听路径 返回Qml文件所在绝对路径的绝对路径
    void hotload(QUrl url);
    static void messageHandler(QtMsgType type, const QMessageLogContext &context, const QString &msg);
private slots:
    void onFileSystemChanged();
    void onReloadRequested(); //重新加载qml
private:
    void scanfPaths(const QString& dir); //扫描 所有文件并且监视
    void unwatchAll();//取消监听

    //Dtk::Core::DBaseFileWatcher *m_watcher;
    QFileSystemWatcher *m_watcher;
    QTimer *m_timer;
    QObject *m_window;
    static QObject *Logger;
    QString m_QmlPath;    //保存用户输入路径 防止用户多次输入
    QString m_absQmlPath; // qml 绝对路径
    QString m_absQmlDir;  // qml文件所在的绝对路径
};

#endif
