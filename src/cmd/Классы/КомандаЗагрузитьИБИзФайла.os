// ----------------------------------------------------------
// This Source Code Form is subject to the terms of the
// Mozilla Public License, v.2.0. If a copy of the MPL
// was not distributed with this file, You can obtain one
// at http://mozilla.org/MPL/2.0/.
// ----------------------------------------------------------
// Codebase: https://github.com/ArKuznetsov/cpdb/
// ----------------------------------------------------------

#Использовать "../../core"

Перем Лог;       // - Объект      - объект записи лога приложения

#Область СлужебныйПрограммныйИнтерфейс

// Процедура - устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект описание команды
//
Процедура ОписаниеКоманды(Команда) Экспорт
	
	Команда.Опция("pp params", "", "Файлы JSON содержащие значения параметров,
	                               | могут быть указаны несколько файлов разделенные "";""")
	       .ТСтрока()
	       .ВОкружении("CPDB_PARAMS");

	Команда.Опция("C ib-path ibconnection", "", "строка подключения к ИБ")
	       .ТСтрока()
	       .Обязательный()
	       .ВОкружении("CPDB_IB_CONNECTION");
	
	Команда.Опция("U ib-user", "", "пользователь ИБ")
	       .ТСтрока()
	       .ВОкружении("CPDB_IB_USER");
	
	Команда.Опция("P ib-pwd", "", "пароль пользователя ИБ")
	       .ТСтрока()
	       .ВОкружении("CPDB_IB_PWD");
	
	Команда.Опция("dp dt-path", "", "путь к DT-файлу для загрузки ИБ")
	       .ТСтрока()
	       .Обязательный()
	       .ВОкружении("CPDB_IB_DT_PATH");
	
	Команда.Опция("uc uccode", "", "ключ разрешения запуска ИБ")
	       .ТСтрока()
	       .ВОкружении("CPDB_IB_UC_CODE");
	
	Команда.Опция("ds delsrc", Ложь, "удалить DT-файл после загрузки")
	       .Флаговый()
	       .ВОкружении("CPDB_IB_DT_DEL_SRC");

КонецПроцедуры // ОписаниеКоманды()

// Процедура - запускает выполнение команды устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект  описание команды
//
Процедура ВыполнитьКоманду(Знач Команда) Экспорт

	ЧтениеОпций = Новый ЧтениеОпцийКоманды(Команда);

	ВыводОтладочнойИнформации = ЧтениеОпций.ЗначениеОпции("verbose");

	ПараметрыСистемы.УстановитьРежимОтладки(ВыводОтладочнойИнформации);

	ПараметрыИБ        = Новый Структура();

	ПараметрыИБ.Вставить("СтрокаПодключения", ЧтениеОпций.ЗначениеОпции("ib-path"));
	ПараметрыИБ.Вставить("Пользователь",      ЧтениеОпций.ЗначениеОпции("ib-user"));
	ПараметрыИБ.Вставить("Пароль",            ЧтениеОпций.ЗначениеОпции("ib-pwd"));

	ПутьКФайлу                  = ЧтениеОпций.ЗначениеОпции("dt-path");
	КлючРазрешения              = ЧтениеОпций.ЗначениеОпции("uccode");
	УдалитьИсточник             = ЧтениеОпций.ЗначениеОпции("delsrc");
	ИспользуемаяВерсияПлатформы = ЧтениеОпций.ЗначениеОпции("v8version", Истина);
	
	РаботаСИБ.ЗагрузитьИнформационнуюБазуИзФайла(ПараметрыИБ,
	                                             ПутьКФайлу,
	                                             ИспользуемаяВерсияПлатформы,
	                                             КлючРазрешения);

	Если УдалитьИсточник Тогда
		УдалитьФайлы(ПутьКФайлу);
		Лог.Информация("Исходный файл %1 удален", ПутьКФайлу);
	КонецЕсли;

КонецПроцедуры // ВыполнитьКоманду()

#КонецОбласти // СлужебныйПрограммныйИнтерфейс

#Область ОбработчикиСобытий

// Процедура - обработчик события "ПриСозданииОбъекта"
//
// BSLLS:UnusedLocalMethod-off
Процедура ПриСозданииОбъекта()

	Лог = ПараметрыСистемы.Лог();

КонецПроцедуры // ПриСозданииОбъекта()
// BSLLS:UnusedLocalMethod-on

#КонецОбласти // ОбработчикиСобытий
