#include <QApplication>
#include <QMainWindow>
#include <QLabel>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    QMainWindow w;
    w.setWindowTitle("Smart Translator");
    QLabel *label = new QLabel("CI/CD Build Success!", &w);
    label->setAlignment(Qt::AlignCenter);
    w.setCentralWidget(label);
    w.show();
    return a.exec();
}
