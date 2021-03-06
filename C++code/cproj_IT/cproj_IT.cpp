#include<iostream>
#include<conio.h>
#include <string>
#include <fstream>
#include <cstdlib>
#include "stdafx.h"
using namespace std;

class InputController
{
public:
	int kolvo_str = 0;//кол-во строк
	int *strl;//длинны строк
	string razdelitel = "";//символы разделителя
	string *str;//массив строк
	int kolvo = 0;//количество разделителей

	void set_str()//метод ввода строк + условие остановки ввода
	{
		string slovo1;//Последнее слово предыдущей строки
		string slovo2;//Последнее слово настоящей строки
		string word;//последнее слово каждой строки
		int wordl;//длинна последнего слова

		strl = new int[25];
		str = new string[25];
		cout << "Введите текст\n";

		cin.ignore(1, '\n'); //игнорирует символ '\n' в буфере ввода cin
							 // остановка ввода 
		for (int m = 0; m < 25; m++)
		{
			cout << "\nВведите " << m + 1 << " строку \n";
			getline(cin, str[m]);
			strl[m] = str[m].length();
			cout << "Длинна строки: " << strl[m] << endl;
			if (strl[m] > 100)
			{
				cout << "Введено более 100 символов, введите строку еще раз." << endl;
				m--;
				continue;
			}
			kolvo_str++; // увеличиваем текст на одну, введенную строку
						 //поиск и запись слова задом наперед, т.е. с конца строки
			for (int j = strl[m] - 1; j > -1; j--)
			{
				int check = 0;//индикатор, показывающий, что j элемент строки содержит разделитель
				for (int k = 0; k < kolvo; k++)
				{
					if (str[m][j] == razdelitel[k])
					{
						check = 1;
						break;
					}
				}
				if ((check == 1) && (word.length() != 0)) break;
				if (check == 1) continue;

				word += str[m][j];
			}

			//перевод слова задам наперед, исходит из предыдущего пункта( т.к. слово записывалось задом наперед)
			wordl = word.length();
			for (int i = 0; i < (wordl / 2); i++)
			{
				char A;//временное место хранение символа
				A = word[0 + i];
				word[0 + i] = word[wordl - 1 - i];
				word[wordl - 1 - i] = A;
			}


			//условие остановки ввода текста
			if (m == 0)
			{
				slovo1 = word;
				cout << "последнее слово: [" << slovo1 << "]" << endl;
			}
			if (m == 1)
			{
				slovo2 = word;
				cout << "последнее слово: [" << slovo2 << "]" << endl;
			}
			if (m > 1)
			{
				cout << "последнее слово: [" << word << "]" << endl;
				slovo1 = slovo2;
				slovo2 = word;
			}
			if (m > 0)
			{
				if (slovo1 == slovo2)
				{
					cout << "Ввод текста окончен \n";
					break;
				}

			}
			word = "";
		}
		cout << "количестов строк после остановки ввода " << kolvo_str << endl << endl;

		// освобождаем память от незаполненных строк, путем создание нового строкового массива ( текста ) с меньшим количеством строк 
		string str_izm[25];//временная строка, в которую мы запишем наши строки ( мы знаем что строк может быть не больше 25 )
		for (int m = 0; m < kolvo_str; m++)//записываем часть нашей измененной строки в временный строковый массив str_izm
		{
			str_izm[m] = str[m];
		}
		str = nullptr;    // очищаем память  (для нвого количества строк )
		str = new string[kolvo_str];
		for (int m = 0; m < kolvo_str; m++)
		{
			str[m] = str_izm[m];  //присваиваем нашей чистой строке новый строковый массив 
		}
		strl = nullptr;   //освобождение памяти под длинну строк
		strl = new int[kolvo_str];
		for (int i = 0; i < kolvo_str; i++) // запись длинны строк
		{
			strl[i] = str[i].length();
		}

	}

	void delete_str()
	{
		str = nullptr;       // указатель заменяется на нуль-указатель
		strl = nullptr;       // указатель заменяется на нуль-указатель
		kolvo_str = 0;
	}

	void set_razdelitel()//метод ввода разделителей
	{
		while (1)
		{
			cout << "Введите разделители: ";
			if (razdelitel == "")
				getline(cin, razdelitel);
			getline(cin, razdelitel);
			cout << "\n";
			kolvo = razdelitel.length();
			if ((kolvo <= 5) && (kolvo != 0))
				break;
			else
			{
				system("cls");
				cout << "Вы ввели больше 5 разделителей \n";
			}
		}
	}

	void delete_razdelitel()
	{
		razdelitel = "";       // очищаем разделители
		kolvo = 0;
	}
};

class TextProcessor :public InputController
{
public:
	int limit = 0; // заданный пользователем лимит строк

	void set_limit()
	{
		while ((limit < 1) || (limit > 25))
		{
			system("cls");
			cout << "Введите лимит строк (от 1 до 25): ";
			cin >> limit;
		}
		cout << endl;
	}

	void delete_limit()
	{
		limit = 0;
	}

	void process(InputController any)
	{
		string word;// найденное слово в строке
		int wordl;  // длинна найденного слова

					//перенос разделителей
		kolvo = any.kolvo;
		razdelitel = any.razdelitel;

		if (limit < kolvo_str)
		{
			//изменение текста
			cout << "Изменим текст." << endl;
			for (int m = 0; m < kolvo_str; m++)
			{
				cout << "Изменим (" << m + 1 << ") строку." << endl;
				cout << "Количество символов до изменения: " << strl[m] << endl;
				int sum2 = 0;//количесвто разделителей после слова ( чтобы потом удалить их)
				int sum = 0;//количество символов до слова 
				for (int j = sum; j < strl[m]; j++)//чтобы прервать когда j будет равно количеству символов в строке
				{
					for (int i = sum; i < strl[m]; i++)
					{
						int check = 0;//индикатор, показывающий, что i элемент строки содержит разделитель 
						for (int k = 0; k < kolvo; k++)
						{
							if (str[m][i] == razdelitel[k])
							{
								check = 1;
								break;
							}
						}
						if ((check == 1) && (word.length() != 0)) break;
						if (check == 1)
						{
							sum++;
							continue;
						}
						word += str[m][i];
					}

					//считает количество разделителей после слова (чтобы потом удалить их) 
					wordl = word.length();
					for (int i = (sum + wordl); i < strl[m]; i++)
					{
						int check = 0;//индикатор, показывающий, что i элемент строки содержит разделитель 
						for (int k = 0; k < kolvo; k++)
						{
							if (str[m][i] == razdelitel[k])
							{
								check = 1;
								sum2++;
								break;
							}
						}
						if (check == 0)
						{
							break;
						}
					}

					//удаляем слово и разделители после него
					if (((wordl % 2) == 0) || (wordl % 5 == 0))
					{
						if (word != "")
						{
							cout << " удаляем слово [" << word << "] так как оно кратно 2 или 5 и удаляем " << sum2 << " разделителя" << endl;
						}
						for (int i = 0; i < (strl[m] - sum - wordl - sum2); i++)    //количество сдвигов влево равно количеству элеменетов справа от элементов для удаления
						{
							str[m][sum + i] = str[m][sum + wordl + sum2 + i];
						}
						strl[m] = strl[m] - wordl - sum2;  //записываем новую длинну нашей строки

						string str_izm = "";//временная строка, изменненная.Потом ей будет равна наша новая строка.Так мы сделаем строку с новой длинной
						for (int i = 0; i < strl[m]; i++)
						{
							str_izm = str_izm + '-'; // запись строкового массива любыми символами, чтобы расширить его до длинны нашей новой строки
						}
						for (int i = 0; i < strl[m]; i++)//записываем часть нашей измененной строки в временный строковый массив str_izm
						{
							str_izm[i] = str[m][i];
						}
						str[m] = str_izm;  //присваиваем нашей старой строке новый строковый массив 
					}

					else
					{
						sum = sum + wordl;
					}
					word = "";
					strl[m] = str[m].length();//записывем новую длинну , так как она может сократиться
					sum2 = 0;
				}

				cout << "Количество символов после изменения: " << strl[m] << endl << endl;
			}
		}
		else
			cout << "Текст не изменен так как, он не превышает лимит в " << limit << " строк." << endl;
		cout << "Нажмите любую кнопку, чтобы продолжить................";
		_getch();
	}

	void set_str(InputController any)
	{
		kolvo_str = any.kolvo_str;
		strl = new int[kolvo_str];
		str = new string[kolvo_str];
		for (int i = 0; i < kolvo_str; i++)
		{
			strl[i] = any.strl[i];
			str[i] = any.str[i];
		}
	}

};

class OutputController
{
private:
	int kolvo_str = 0;
	string *str;
public:
	void get_str(TextProcessor any)
	{
		kolvo_str = any.kolvo_str;
		str = new string[kolvo_str];
		for (int i = 0; i < kolvo_str; i++)
		{
			str[i] = any.str[i];
		}

		ofstream out("Output_text.txt"); //создаем файл, в который добавим текст
		out << "Окончательный текст :" << endl;
		for (int i = 0; i < kolvo_str; i++)
		{
			out << " Строка номер " << i + 1 << ": " << endl;
			out << str[i] << endl;
		}
		out.close();
	}

};

void menu(InputController vvod, TextProcessor proc, OutputController out)
{
	int сhange = 0;//показывает  изменили ли мы текст 0 - нет 1 - да
	int i = 1;
	while (i)
	{
		system("cls");
		char  a = '\0';
		cout << "\n\n\n\n\n\n";
		cout << " ---------------------------------- " << "                        " << " ---------------------------------- " << endl;
		cout << "| <<<<<< Это меню программы >>>>>> |" << "                        " << "| <<<<<<<<<<<  Подсказка  >>>>>>>> |" << endl;
		cout << "|Нажмите:                          |" << "                        " << "|       !!!! ЖЕЛАТЕЛЬНО !!!!       |" << endl;
		cout << "|\"1\"Если хотите ввести разделители |" << "                        " << "|   ВЫПОЛНЯТЬ ОПЕРАЦИИ ПО ПОРЯДКУ  |" << endl;
		cout << "|\"2\"Если хотите ввести текст       |" << "                        " << "|       !!!! ОБЯЗАТЕЛЬНО !!!!      |" << endl;
		cout << "|\"3\"Если хотите ввести лимит строк |" << "                        " << "|       ВЕСЬ ВВОД ПРОИЗВОДИТСЯ     |" << endl;
		cout << "|\"4\"Если хотите обработать текст   |" << "                        " << "|        ЛАТИНСКИМ АЛФАВИТОМ       |" << endl;
		cout << "|\"5\"Если хотите вывести текст      |" << "                        " << " ---------------------------------- " << endl;
		cout << "|\"6\"Если хотите выйти из программы |" << endl;
		cout << " ---------------------------------- " << endl;

		cout << " ----------- " << endl;
		cout << "|Разделители|" << endl;
		cout << " ----------- " << endl;
		if (vvod.kolvo != 0)
		{
			cout << "  ";
			int j = 0;
			switch (vvod.kolvo)
			{
			case 1:
			{
				j = 1;
				break;
			}
			case 2:
			{
				j = 3;
				break;
			}
			case 3:
			{
				j = 5;
				break;
			}
			case 4:
			{
				j = 7;
				break;
			}
			case 5:
			{
				j = 9;
				break;
			}
			}
			for (int i = 1; i <= j; i++)
				cout << "-";
			cout << endl;
			cout << " ";
			for (int i = 1; i <= vvod.kolvo; i++)
				cout << "|" << i;
			cout << "|" << endl;
			cout << " ";
			for (int i = 1; i <= vvod.kolvo; i++)
				cout << "|-";
			cout << "|" << endl;
			cout << " ";
			for (int i = 0; i < vvod.kolvo; i++)
				cout << "|" << vvod.razdelitel[i];
			cout << "|" << endl;
			cout << "  ";
			for (int i = 1; i <= j; i++)
				cout << "-";
			cout << endl;
		}
		if (vvod.kolvo_str != 0)
		{
			if (vvod.kolvo == 0) for (int i = 0; i < 5; i++) cout << "\n";
			cout << "\nКоличество строк: " << vvod.kolvo_str << endl;
		}
		else
		{
			if (vvod.kolvo == 0) for (int i = 0; i < 5; i++) cout << "\n";
			cout << "\nТекст не введен " << endl;
		}
		if (proc.limit != 0)
		{
			cout << "\nЛимит строк: " << proc.limit;
		}
		if (сhange == 1)
		{
			if (proc.limit == 0)
			{
				cout << "\n";
			}
			cout << "\n";
			cout << "\nТекст обработан";
		}
		if (сhange == 0)
		{
			if (proc.limit == 0)
			{
				cout << "\n";
			}
			cout << "\n";
			cout << "\nТекст не обработан";
		}

		while ((a != '1') && (a != '2') && (a != '3') && (a != '4') && (a != '5') && (a != '6'))
		{
			if (a != '\0')
			{
				if (a != '0')
				{
					cout << "\n\n\n";
				}
				cout << " ---------------------------------- " << endl;
				cout << "|Вы ввели неверный символ,         |" << endl;
				cout << "|пожалуйста введите другой.        |" << endl;
				cout << "|----------------------------------|" << "                        " << " ---------------------------------- " << endl;
				cout << "| <<<<<< Это меню программы >>>>>> |" << "                        " << "| <<<<<<<<<<<  Подсказка  >>>>>>>> |" << endl;
				cout << "|Нажмите:                          |" << "                        " << "|       !!!! ЖЕЛАТЕЛЬНО !!!!       |" << endl;
				cout << "|\"1\"Если хотите ввести разделители |" << "                        " << "|   ВЫПОЛНЯТЬ ОПЕРАЦИИ ПО ПОРЯДКУ  |" << endl;
				cout << "|\"2\"Если хотите ввести текст       |" << "                        " << "|       !!!! ОБЯЗАТЕЛЬНО !!!!      |" << endl;
				cout << "|\"3\"Если хотите ввести лимит строк |" << "                        " << "|       ВЕСЬ ВВОД ПРОИЗВОДИТСЯ     |" << endl;
				cout << "|\"4\"Если хотите обработать текст   |" << "                        " << "|        ЛАТИНСКИМ АЛФАВИТОМ       |" << endl;
				cout << "|\"5\"Если хотите вывести текст      |" << "                        " << " ---------------------------------- " << endl;
				cout << "|\"6\"Если хотите выйти из программы |" << endl;
				cout << " ---------------------------------- " << endl;

				cout << " ----------- " << endl;
				cout << "|Разделители|" << endl;
				cout << " ----------- " << endl;
				if (vvod.kolvo != 0)
				{
					cout << "  ";
					int j = 0;
					switch (vvod.kolvo)
					{
					case 1:
					{
						j = 1;
						break;
					}
					case 2:
					{
						j = 3;
						break;
					}
					case 3:
					{
						j = 5;
						break;
					}
					case 4:
					{
						j = 7;
						break;
					}
					case 5:
					{
						j = 9;
						break;
					}
					}
					for (int i = 1; i <= j; i++)
						cout << "-";
					cout << endl;
					cout << " ";
					for (int i = 1; i <= vvod.kolvo; i++)
						cout << "|" << i;
					cout << "|" << endl;
					cout << " ";
					for (int i = 1; i <= vvod.kolvo; i++)
						cout << "|-";
					cout << "|" << endl;
					cout << " ";
					for (int i = 0; i < vvod.kolvo; i++)
						cout << "|" << vvod.razdelitel[i];
					cout << "|" << endl;
					cout << "  ";
					for (int i = 1; i <= j; i++)
						cout << "-";
					cout << endl;
				}
				if (vvod.kolvo_str != 0)
				{
					if (vvod.kolvo == 0) for (int i = 0; i < 5; i++) cout << "\n";
					cout << "\nКоличество строк: " << vvod.kolvo_str << endl;
				}
				else
				{
					if (vvod.kolvo == 0) for (int i = 0; i < 5; i++) cout << "\n";
					cout << "\nТекст не введен " << endl;
				}
				if (proc.limit != 0)
				{
					cout << "\nЛимит строк: " << proc.limit;
				}
				if (сhange == 1)
				{
					if (proc.limit == 0)
					{
						cout << "\n";
					}
					cout << "\n";
					cout << "\nТекст обработан";
				}
				if (сhange == 0)
				{
					if (proc.limit == 0)
					{
						cout << "\n";
					}
					cout << "\n";
					cout << "\nТекст не обработан";
				}
			}
			cout << "                ";
			cin >> a;
			system("cls");
			//условия икслючения ошибок
			if ((vvod.kolvo == 0) && (a == '2')) //иключение ошибок при выборе операции
			{
				cout << "Вы хотите ввести текст, но вы не ввели разделители :) " << endl;
				cout << "Исходя из условия курсовика нельзя  остановить ввод строк, пока не введены разделители" << endl;
				cout << "!!!сначала введите разделители !!!" << endl;
				a = '0';
				continue;
			}
			if ((vvod.kolvo_str == 0) && (a == '4')) //иключение ошибок при выборе операции
			{
				cout << "\nВы хотите обработать текст, который вы не ввели :) " << endl;
				cout << "!!!сначала введите разделители, текст  и лимит строк!!!" << endl;
				a = '0';
				continue;
			}
			if ((proc.limit == 0) && (a == '4')) //иключение ошибок при выборе операции
			{
				cout << "\nВы хотите обработать текст, но вы не ввели лимит строк :) " << endl;
				cout << "!!!сначала введите разделители, текст  и лимит строк!!!" << endl;
				a = '0';
				continue;
			}
			if ((vvod.kolvo_str == 0) && (a == '5'))//иключение ошибок при выборе операции
			{
				cout << "\nВы хотите вывести текст, который вы не ввели :) " << endl;
				cout << "!!!сначала введите разделители, текст  и лимит строк!!!" << endl;
				a = '0';
				continue;
			}
		}

		switch (a)
		{
		case '1':
		{
			vvod.delete_razdelitel();
			vvod.set_razdelitel();
			if (сhange == 1)
				vvod.delete_str();//удаляем старый текст,изменненный т.к. введены новые разделители
			сhange = 0;//показывает, что мы ввели новые разделители, следовательно текст можно изменить еще раз
			break;
		}
		case '2':
		{
			сhange = 0;  //показывает что мы ввели новый, не измененный текст
			vvod.delete_str();
			vvod.set_str();
			break;
		}
		case '3':
		{
			proc.delete_limit();
			proc.set_limit();
			break;
		}
		case '4':
		{
			сhange = 1; // показывает, что мы изменили текст
			proc.set_str(vvod);
			proc.process(vvod);
			break;

		}
		case '5':
		{
			if (сhange == 0)
			{
				proc.set_str(vvod);
			}
			out.get_str(proc);
			break;
		}
		default:
		{
			i = 0;
		}
		}
	}
}


int main()
{
	setlocale(LC_ALL, "Russian");

	InputController vvod;
	TextProcessor proc;
	OutputController out;

	menu(vvod, proc, out);
	return 0;
}
