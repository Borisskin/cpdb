
///////////////////////////////////////////////////////////////////////////////////////////////////
// Прикладной интерфейс

Перем Лог;
Перем ИспользуемаяВерсияПлатформы;

Процедура ЗарегистрироватьКоманду(Знач ИмяКоманды, Знач Парсер) Экспорт
	
	ОписаниеКоманды = Парсер.ОписаниеКоманды(ИмяКоманды, "Подключить информационную базу к хранилищу конфигураций");

	Парсер.ДобавитьПозиционныйПараметрКоманды(ОписаниеКоманды, "СтрокаПодключения", "Строка подключения к ИБ");
	Парсер.ДобавитьПозиционныйПараметрКоманды(ОписаниеКоманды, "АдресХранилища", "Адрес хранилища конфигурации");

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, 
		"-params",
		"Файлы JSON содержащие значения параметров,
		|могут быть указаны несколько файлов разделенные "";""
		|(параметры командной строки имеют более высокий приоритет)");

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, 
		"-db-user",
		"Пользователь ИБ");
	
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, 
		"-db-pwd",
		"Пароль пользователя ИБ");

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, 
		"-storage-user",
		"Пользователь хранилища конфигурации");
	
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, 
		"-storage-pwd",
		"Пароль пользователя хранилища конфигурации");

    Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, 
    	"-v8version",
    	"Маска версии платформы 1С");

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, 
		"-uccode",
		"Ключ разрешения запуска ИБ");

    Парсер.ДобавитьКоманду(ОписаниеКоманды);

КонецПроцедуры

Функция ВыполнитьКоманду(Знач ПараметрыКоманды) Экспорт
    
	ЗапускПриложений.ПрочитатьПараметрыКомандыИзФайла(ПараметрыКоманды["-params"], ПараметрыКоманды);
	
	СтрокаПодключения				= ПараметрыКоманды["СтрокаПодключения"];
	АдресХранилища					= ПараметрыКоманды["АдресХранилища"];
	Пользователь					= ПараметрыКоманды["-db-user"];
	ПарольПользователя				= ПараметрыКоманды["-db-pwd"];
	Хранилище_Пользователь			= ПараметрыКоманды["-storage-user"];
	Хранилище_ПарольПользователя	= ПараметрыКоманды["-storage-pwd"];
	ИспользуемаяВерсияПлатформы		= ПараметрыКоманды["-v8version"];
	КлючРазрешения					= ПараметрыКоманды["-uccode"];

	ВозможныйРезультат = МенеджерКомандПриложения.РезультатыКоманд();

	Если ПустаяСтрока(СтрокаПодключения) Тогда
		Лог.Ошибка("Не указана строка подключения к ИБ");
		Возврат ВозможныйРезультат.НеверныеПараметры;
	КонецЕсли;

	Если ПустаяСтрока(АдресХранилища) Тогда
		Лог.Ошибка("Не указан адрес хранилища конфигурации");
		Возврат ВозможныйРезультат.НеверныеПараметры;
	КонецЕсли;

	Если ПустаяСтрока(Хранилище_Пользователь) Тогда
		Лог.Ошибка("Не указан пользователь хранилища конфигурации");
		Возврат ВозможныйРезультат.НеверныеПараметры;
	КонецЕсли;

	Попытка
		ПодключитьКХранилищу(СтрокаПодключения
						   , АдресХранилища
						   , Пользователь
						   , ПарольПользователя
						   , Хранилище_Пользователь
						   , Хранилище_ПарольПользователя
						   , КлючРазрешения);

		Возврат ВозможныйРезультат.Успех;
	Исключение
		Лог.Ошибка(ОписаниеОшибки());
		Возврат ВозможныйРезультат.ОшибкаВремениВыполнения;
	КонецПопытки;

КонецФункции

Процедура ПодключитьКХранилищу(Знач СтрокаПодключения
							 , Знач АдресХранилища
							 , Знач ИмяПользователя
							 , Знач ПарольПользователя
							 , Знач Хранилище_ИмяПользователя
							 , Знач Хранилище_ПарольПользователя
							 , Знач КлючРазрешения)

	Конфигуратор = ЗапускПриложений.НастроитьКонфигуратор(
														, СтрокаПодключения
														, ИмяПользователя
														, ПарольПользователя
														, ИспользуемаяВерсияПлатформы);
	
	Если Не ПустаяСтрока(КлючРазрешения) Тогда
		Конфигуратор.УстановитьКлючРазрешенияЗапуска(КлючРазрешения);
	КонецЕсли;

	Конфигуратор.ПодключитьсяКХранилищу(АдресХранилища
									  , Хранилище_ИмяПользователя
									  , Хранилище_ПарольПользователя
									  , Истина);

КонецПроцедуры

Лог = Логирование.ПолучитьЛог("ktb.app.cpdb");