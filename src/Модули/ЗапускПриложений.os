
// Добавляет к строке отрывающую и закрывающую кавычки при их отсутствии
//   
// Параметры:
//   Строка 	- Строка - Строка для обработки
//
// Возвращаемое значение:
//		Строка	- Обработанная строка
//
Функция ОбернутьВКавычки(Знач Строка) Экспорт
	Если Лев(Строка, 1) = """" и Прав(Строка, 1) = """" Тогда
		Возврат Строка;
	Иначе
		Возврат """" + Строка + """";
	КонецЕсли;
КонецФункции //ОбернутьВКавычки()

Функция НастроитьКонфигуратор(КаталогСборки = Неопределено
							, СтрокаПодключения = Неопределено
							, ИмяПользователя = Неопределено
							, ПарольПользователя = Неопределено
							, ИспользуемаяВерсияПлатформы = Неопределено) Экспорт
	
	Конфигуратор = Новый УправлениеКонфигуратором;

	Если НЕ ЗначениеЗаполнено(КаталогСборки) Тогда
		КаталогСборки = КаталогВременныхФайлов();
	КонецЕсли;

	Конфигуратор.КаталогСборки(КаталогСборки);

	Если ЗначениеЗаполнено(СтрокаПодключения) Тогда
		Конфигуратор.УстановитьКонтекст(СтрокаПодключения, ИмяПользователя, ПарольПользователя);
	КонецЕсли;

	Если НЕ ИспользуемаяВерсияПлатформы = Неопределено Тогда
		Конфигуратор.ИспользоватьВерсиюПлатформы(ИспользуемаяВерсияПлатформы);
	КонецЕсли;

	Возврат Конфигуратор;
КонецФункции //НастроитьКонфигуратор()

//***************************************
// Функция поиска архиватора
//***************************************
Функция Найти7ZIP() Экспорт
	// Предполагаем, что для X64_86 7-Zip будет 64-битный
	//	ПутьПрограмм = ПолучитьПеременнуюСреды("PROGRAMFILESW6432");
	//	Если НЕ ЗначениеЗаполнено(ПутьПрограмм) Тогда
	//		ПутьПрограмм = ПолучитьПеременнуюСреды("PROGRAMFILES");
	//	КонецЕсли;
	
	//	Сообщить("Путь поиска: " + ПутьПрограмм);
	Массив7ZIP = НайтиФайлы("C:\Program Files", "7z.exe", True);
	Если Массив7ZIP.Количество() = 0 Тогда
		Возврат Неопределено;
	Иначе
		Возврат Массив7ZIP[0].ПолноеИмя;
	КонецЕсли;
КонецФункции //Найти7ZIP()()

// Выполняет чтение параметров из списка JSON-файлов
//   
// Параметры:
//   ФайлыПараметров 	- Строка		- Список путей к JSON-файлам параметров, разделенных ";"
//   ПараметрыКоманды 	- Соответствие	- Соответствие 
//   ОшибкиЧтения	 	- Соответствие	- Ошибки чтения параметров
//
// Возвращаемое значение:
//   Соответствие - Параметры указанные в файлах (Ключ - Имя параметра, Значение - значение параметра)
//
Процедура ПрочитатьПараметрыКомандыИзФайла(ФайлыПараметров, ПараметрыКоманды, ОшибкиЧтения = Неопределено) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ФайлыПараметров) Тогда
		Возврат;
	КонецЕсли;
	
	МассивФайловПараметров = Новый Массив;
	МассивФайловПараметров.Добавить(Неопределено);

	Для Каждого ТекФайл Из СтрРазделить(ФайлыПараметров, ";") Цикл
		МассивФайловПараметров.Добавить(ТекФайл);
	КонецЦикла;

	Параметры = ЧтениеПараметров.Прочитать(МассивФайловПараметров, ОшибкиЧтения);
	
	Для Каждого	ТекПараметр Из Параметры Цикл
		Если ПараметрыКоманды.Получить(ТекПараметр.Значение) = Неопределено Тогда
			ПараметрыКоманды.Вставить(ТекПараметр.Ключ, ТекПараметр.Значение);
		КонецЕсли;
	КонецЦикла;	

КонецПроцедуры //ПрочитатьПараметрыКомандыИзФайла()
	
