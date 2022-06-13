#Использовать fs
#Использовать "../src/core"
#Использовать "../src/cmd"

Перем ПутьКТестовомуФайлу;       //    - путь к файлу для тестов
Перем КаталогВременныхДанных;    //    - путь к каталогу временных данных
Перем Лог;                       //    - логгер
Перем РазмерФайла;               //    - размер в Байтах

#Область ОбработчикиСобытий

// Процедура выполняется после запуска теста
//
Процедура ПередЗапускомТеста() Экспорт
	
	КаталогВременныхДанных = ОбъединитьПути(ТекущийСценарий().Каталог, "..", "build", "tmpdata");
	КаталогВременныхДанных = ФС.ПолныйПуть(КаталогВременныхДанных);

	ПутьКТестовомуФайлу = ОбъединитьПути(КаталогВременныхДанных, "testFile1.tst");

	РазмерФайла = 1457280;

	Лог = ПараметрыСистемы.Лог();

КонецПроцедуры // ПередЗапускомТеста()

// Процедура выполняется после запуска теста
//
Процедура ПослеЗапускаТеста() Экспорт

КонецПроцедуры // ПослеЗапускаТеста()

#КонецОбласти // ОбработчикиСобытий

#Область Тесты

&Тест
Процедура ТестДолжен_СоздатьФайл() Экспорт

	Лог.Информация("Перед тестами: Создание тестового файла");

	ФС.ОбеспечитьПустойКаталог(КаталогВременныхДанных);

	СоздатьСлучайныйФайл(ПутьКТестовомуФайлу, РазмерФайла);

	ТекстОшибки = СтрШаблон("Ошибка создания файла ""%1""", ПутьКТестовомуФайлу);

	Утверждения.ПроверитьИстину(ФС.ФайлСуществует(ПутьКТестовомуФайлу), ТекстОшибки);

КонецПроцедуры // ТестДолжен_СоздатьФайл()

&Тест
Процедура ТестДолжен_ОтправитьФайлYandexDisk() Экспорт

	Лог.Информация("Тест: Отправка файла на сервис YandexDisk");

	OAuth_Токен = ПолучитьПеременнуюСреды("YADISK_TOKEN");

	Клиент = Новый РаботаСЯндексДиск(OAuth_Токен);

	ИмяКаталога = "testFolder1";

	ТестовыйФайл = Новый Файл(ПутьКТестовомуФайлу);

	Если НЕ ФС.ФайлСуществует(ПутьКТестовомуФайлу) Тогда
		СоздатьСлучайныйФайл(ПутьКТестовомуФайлу, РазмерФайла);
	КонецЕсли;	

	Клиент.СоздатьКаталог(ИмяКаталога);

	ТекстОшибки = СтрШаблон("Ошибка создания каталога ""%1"" в сервисе YandexDisk, с токеном ""%2""",
	                        ИмяКаталога,
	                        OAuth_Токен);

	Утверждения.ПроверитьИстину(Клиент.Существует(ИмяКаталога), ТекстОшибки);

	Клиент.ОтправитьФайл(ТестовыйФайл.ПолноеИмя, ИмяКаталога, Истина);

	ТекстОшибки = СтрШаблон("Ошибка отправки файла ""%1"" в сервисе YandexDisk, с токеном ""%2""",
	                        ТестовыйФайл.ПолноеИмя,
	                        OAuth_Токен);

	ИмяЗагружаемогоФайла = СтрШаблон("%1/%2", ИмяКаталога, ТестовыйФайл.Имя);
	Утверждения.ПроверитьИстину(Клиент.Существует(ИмяЗагружаемогоФайла), ТекстОшибки);

	Клиент.Удалить(ИмяЗагружаемогоФайла);

	ТекстОшибки = СтрШаблон("Ошибка удаления файла ""%1"" в сервисе YandexDisk, с токеном ""%2""",
							ИмяЗагружаемогоФайла,
	                        OAuth_Токен);

	Утверждения.ПроверитьЛожь(Клиент.Существует(ИмяЗагружаемогоФайла), ТекстОшибки);

	Клиент.Удалить(ИмяКаталога);

	ТекстОшибки = СтрШаблон("Ошибка удаления каталога ""%1"" в сервисе YandexDisk, с токеном ""%2""",
							ИмяКаталога,
	                        OAuth_Токен);

	Утверждения.ПроверитьЛожь(Клиент.Существует(ИмяКаталога), ТекстОшибки);

КонецПроцедуры // ТестДолжен_ОтправитьФайлYandexDisk()

&Тест
Процедура ТестДолжен_ПолучитьФайлИзYandexDisk() Экспорт

	Лог.Информация("Тест: Получение файла с сервиса YandexDisk");

	OAuth_Токен = ПолучитьПеременнуюСреды("YADISK_TOKEN");

	Клиент = Новый РаботаСЯндексДиск(OAuth_Токен);

	ИмяКаталога = "testFolder1";

	ТестовыйФайл = Новый Файл(ПутьКТестовомуФайлу);

	Если НЕ ФС.ФайлСуществует(ПутьКТестовомуФайлу) Тогда
		СоздатьСлучайныйФайл(ПутьКТестовомуФайлу, РазмерФайла);
	КонецЕсли;	

	ИмяЗагружаемогоФайла = СтрШаблон("%1/%2", ИмяКаталога, ТестовыйФайл.Имя); //Для скачивания и проверки существования

	Клиент.СоздатьКаталог(ИмяКаталога);

	ТекстОшибки = СтрШаблон("Ошибка создания каталога ""%1"" в сервисе YandexDisk, с токеном ""%2""",
	                        ИмяКаталога,
	                        OAuth_Токен);

	Утверждения.ПроверитьИстину(Клиент.Существует(ИмяКаталога), ТекстОшибки);

	Клиент.ОтправитьФайл(ТестовыйФайл.ПолноеИмя, ИмяКаталога, Истина);

	ТекстОшибки = СтрШаблон("Ошибка отправки файла ""%1"" в сервисе YandexDisk, с токеном ""%2""",
	                        ТестовыйФайл.ПолноеИмя,
	                        OAuth_Токен);

	Утверждения.ПроверитьИстину(Клиент.Существует(ИмяЗагружаемогоФайла), ТекстОшибки);

	ФС.ОбеспечитьКаталог(КаталогВременныхДанных);
	ТестовыйФайлСкачанный = Новый Файл(ОбъединитьПути(КаталогВременныхДанных,ТестовыйФайл.Имя));
	Если ФС.ФайлСуществует(ТестовыйФайлСкачанный.ПолноеИмя) Тогда
		УдалитьФайлы(ТестовыйФайлСкачанный.ПолноеИмя);
		Лог.Информация("Исходный файл %1 удален в папке приемника перед скачиванием с YandexDisk."
						, ТестовыйФайлСкачанный.ПолноеИмя);
	КонецЕсли;	

	Клиент.ПолучитьФайл(ИмяЗагружаемогоФайла, КаталогВременныхДанных, Ложь); 

	ТекстОшибки = СтрШаблон("Ошибка получения файла ""%1"" в сервисе YandexDisk, с токеном ""%2""",
							ИмяЗагружаемогоФайла,
	                        OAuth_Токен);

	Утверждения.ПроверитьИстину(ФС.ФайлСуществует(ТестовыйФайлСкачанный.ПолноеИмя), ТекстОшибки);

	Клиент.Удалить(ИмяЗагружаемогоФайла);

	ТекстОшибки = СтрШаблон("Ошибка удаления файла ""%1"" в сервисе YandexDisk, с токеном ""%2""",
							ИмяЗагружаемогоФайла,
	                        OAuth_Токен);

	Утверждения.ПроверитьЛожь(Клиент.Существует(ИмяЗагружаемогоФайла), ТекстОшибки);

	Клиент.Удалить(ИмяКаталога);

	ТекстОшибки = СтрШаблон("Ошибка удаления каталога ""%1"" в сервисе YandexDisk, с токеном ""%2""",
							ИмяКаталога,
	                        OAuth_Токен);

	Утверждения.ПроверитьЛожь(Клиент.Существует(ИмяКаталога), ТекстОшибки);

КонецПроцедуры // ТестДолжен_ПолучитьФайлИзYandexDisk()

&Тест
Процедура ТестДолжен_УдалитьТестовыйКаталог() Экспорт

	Лог.Информация("После тестов: Удаление тестового каталога");

	УдалитьФайлы(КаталогВременныхДанных);

	ТекстОшибки = СтрШаблон("Ошибка удаления каталога временных файлов ""%1""", КаталогВременныхДанных);

	Утверждения.ПроверитьЛожь(ФС.ФайлСуществует(КаталогВременныхДанных), ТекстОшибки);

КонецПроцедуры // ТестДолжен_УдалитьТестовыйКаталог()

#КонецОбласти // Тесты

#Область СлужебныеПроцедурыИФункции

Процедура СоздатьСлучайныйФайл(ПутьКФайлу, РазмерФайла)

	Если ФС.ФайлСуществует(ПутьКФайлу) Тогда
		УдалитьФайлы(ПутьКФайлу);
	КонецЕсли;

	НачальноеЧисло = 1113;
	ДлинаЧисла     = 8;
	ГраницаГСЧ     = 4294836225;
	
	ЧастейЗаписи     = 100;
	МаксПорцияЗаписи = 10485760;
	ПорцияЗаписи     = 1024;
	Если Цел(РазмерФайла / ЧастейЗаписи) <= МаксПорцияЗаписи Тогда
		ПорцияЗаписи = Цел(РазмерФайла / ЧастейЗаписи);
	Иначе
		ПорцияЗаписи = МаксПорцияЗаписи;
	КонецЕсли;

	ГСЧ = Новый ГенераторСлучайныхЧисел(НачальноеЧисло);

	ЗаписьДанных = Новый ЗаписьДанных(ПутьКФайлу);

	Записано = 0;

	Пока Записано < РазмерФайла Цикл
		Число = ГСЧ.СлучайноеЧисло(0, ГраницаГСЧ);

		ЗаписьДанных.ЗаписатьЦелое64(Число);

		Записано = Записано + ДлинаЧисла;
		Если Записано % ПорцияЗаписи = 0 Тогда
			ЗаписьДанных.СброситьБуферы();
		КонецЕсли;
	КонецЦикла;

	ЗаписьДанных.Закрыть();

КонецПроцедуры // СоздатьФайл()

#КонецОбласти // СлужебныеПроцедурыИФункции
