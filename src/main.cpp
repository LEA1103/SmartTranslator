#include <QApplication>
#include <QMainWindow>
#include <QLabel>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    QMainWindow w;
    w.setWindowTitle("Translator");
    QLabel *label = new QLabel("Build Success!", &w);
    label->setAlignment(Qt::AlignCenter);
    w.setCentralWidget(label);
    w.show();
    return a.exec();
}
