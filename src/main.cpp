#include <QApplication>
#include <QLabel>

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);
    QLabel label("Smart Translator - 构建成功！");
    label.show();
    return app.exec();
}
