#include <QApplication>
#include <QMainWindow>
#include <QLabel>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);

    QMainWindow w;
    w.setWindowTitle("Smart Translator");
    w.resize(800, 500);

    QLabel label("Smart Translator 运行成功!", &w);
    label.setAlignment(Qt::AlignCenter);
    w.setCentralWidget(&label);

    w.show();
    return a.exec();
}
