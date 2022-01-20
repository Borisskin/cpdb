
///////////////////////////////////////////////////////////////////////////////////////////////////
// Прикладной интерфейс

Перем Лог;
Перем ИспользуемаяВерсияПлатформы;

// Интерфейсная процедура, выполняет регистрацию команды и настройку парсера командной строки
//   
// Параметры:
//   ИмяКоманды 	- Строка										- Имя регистрируемой команды
//   Парсер 		- ПарсерАргументовКоманднойСтроки (cmdline)		- Парсер командной строки
//
Процедура ЗарегистрироватьКоманду(Знач ИмяКоманды, Знач Парсер) Экспорт
	
	ОписаниеКоманды = Парсер.ОписаниеКоманды(ИмяКоманды, "Отключает конфигурацию или расширение информационной базы от хранилища конфигураций");

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, 
		"-params",
		"Файлы JSON содержащие значения параметров,
		|могут быть указаны несколько файлов разделенные "";""
		|(параметры командной строки имеют более высокий приоритет)");

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, 
		"-ib-path",
		"Строка подключения к ИБ");
	
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, 
		"-ib-user",
		"Пользователь ИБ");
	
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, 
		"-ib-pwd",
		"Пароль пользователя ИБ");

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, 
		"-extension",
		"Имя расширения, отключаемого от хранилища");

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, 
	    "-v8version",
	    "Маска версии платформы 1С");

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, 
		"-uccode",
		"Ключ разрешения запуска ИБ");

    Парсер.ДобавитьКоманду(ОписаниеКоманды);

КонецПроцедуры // ЗарегистрироватьКоманду()

// Интерфейсная процедура, выполняет текущую команду
//   
// Параметры:
//   ПараметрыКоманды 	- Соответствие						- Соответствие параметров команды и их значений
//
// Возвращаемое значение:
//	Число - код возврата команды
//
Функция ВыполнитьКоманду(Знач ПараметрыКоманды) Экспорт
    
	ЗапускПриложений.ПрочитатьПараметрыКомандыИзФайла(ПараметрыКоманды["-params"], ПараметрыКоманды);
	
	СтрокаПодключения           = ПараметрыКоманды["-ib-path"];
	Пользователь                = ПараметрыКоманды["-ib-user"];
	ПарольПользователя          = ПараметрыКоманды["-ib-pwd"];
	ИмяРасширения               = ПараметрыКоманды["-extension"];
	ИспользуемаяВерсияПлатформы = ПараметрыКоманды["-v8version"];
	КлючРазрешения              = ПараметрыКоманды["-uccode"];

	ВозможныйРезультат = МенеджерКомандПриложения.РезультатыКоманд();

	Если ПустаяСтрока(СтрокаПодключения) Тогда
		Лог.Ошибка("Не указана строка подключения к ИБ");
		Возврат ВозможныйРезультат.НеверныеПараметры;
	КонецЕсли;

	Попытка
		ОтключитьОтХранилища(СтрокаПодключения,
		                     Пользователь,
		                     ПарольПользователя,
		                     ИмяРасширения,
		                     КлючРазрешения);

		Возврат ВозможныйРезультат.Успех;
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		Лог.Ошибка(ТекстОшибки);
		Возврат ВозможныйРезультат.ОшибкаВремениВыполнения;
	КонецПопытки;

КонецФункции // ВыполнитьКоманду()

Процедура ОтключитьОтХранилища(Знач СтрокаПодключения
                             , Знач ИмяПользователя
                             , Знач ПарольПользователя
                             , Знач ИмяРасширения = ""
                             , Знач КлючРазрешения = "")

	Конфигуратор = ЗапускПриложений.НастроитьКонфигуратор(СтрокаПодключения,
	                                                      ИмяПользователя,
	                                                      ПарольПользователя,
	                                                      ИспользуемаяВерсияПлатформы);
	
	Если Не ПустаяСтрока(КлючРазрешения) Тогда
		Конфигуратор.УстановитьКлючРазрешенияЗапуска(КлючРазрешения);
	КонецЕсли;

	МенеджерХранилища = Новый МенеджерХранилищаКонфигурации(, Конфигуратор);
	
	Если ЗначениеЗаполнено(ИмяРасширения) Тогда
		МенеджерХранилища.УстановитьРасширениеХранилища(ИмяРасширения);
	КонецЕсли;

	МенеджерХранилища.ОтключитьсяОтХранилища();

КонецПроцедуры // ОтключитьОтХранилища()

Лог = Логирование.ПолучитьЛог("ktb.app.cpdb");