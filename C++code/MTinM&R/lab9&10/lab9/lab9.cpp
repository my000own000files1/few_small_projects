
using namespace cv;

// Подключение заголовочного файла графического интерфейса
#include <opencv2/highgui.hpp>

int main()
{
    // Создание объекта для хранения изображения
    cv::Mat frame;
    // Создание объекта для управления камерой
    // и открытие камеры по умолчанию
    cv::VideoCapture camera(0);

    // "бесконечный" цикл получения изображения с камеры
    for(;;)
    {
        // Получение изображения с камеры
        camera >> frame;
        // Вывод изображения на экран
        cv::imshow("Frame", frame);
        // Выход из цикла если нажата клавиша
        // наклавиатуре
        if(cv::waitKey(1) >= 0) break;
    }

    return 0;
}