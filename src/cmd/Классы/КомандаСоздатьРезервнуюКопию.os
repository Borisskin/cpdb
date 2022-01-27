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
	
	Команда.Опция("d sql-db", "", "имя базы для резервного копирования")
	       .ТСтрока()
	       .Обязательный()
	       .ВОкружении("CPDB_SQL_DATABASE");
	
	Команда.Опция("p bak-path", "", "путь к файлу резервной копии")
	       .ТСтрока()
	       .Обязательный()
	       .ВОкружении("CPDB_SQL_BACKUP_PATH");
	
КонецПроцедуры // ОписаниеКоманды()

// Процедура - запускает выполнение команды устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект  описание команды
//
Процедура ВыполнитьКоманду(Знач Команда) Экспорт

	ВыводОтладочнойИнформации = Команда.ЗначениеОпции("verbose");

	ПараметрыПриложения.УстановитьРежимОтладки(ВыводОтладочнойИнформации);

	Если НЕ ПараметрыПриложения.ОбязательныеПараметрыЗаполнены(Команда) Тогда
		Команда.ВывестиСправку();
		Возврат;
	КонецЕсли;

	Сервер              = Команда.ЗначениеОпцииКомандыРодителя("sql-srvr");
	Пользователь        = Команда.ЗначениеОпцииКомандыРодителя("sql-user");
	ПарольПользователя  = Команда.ЗначениеОпцииКомандыРодителя("sql-pwd");
	База                = Команда.ЗначениеОпции("sql-db");
	ПутьКРезервнойКопии = Команда.ЗначениеОпции("bak-path");

	ПодключениеКСУБД = Новый ПодключениеКСУБД(Сервер, Пользователь, ПарольПользователя);
	
	РаботаССУБД = Новый РаботаССУБД(ПодключениеКСУБД);

	РаботаССУБД.ВыполнитьРезервноеКопирование(База, ПутьКРезервнойКопии);

КонецПроцедуры // ВыполнитьКоманду()

#КонецОбласти // СлужебныйПрограммныйИнтерфейс

#Область ОбработчикиСобытий

// Процедура - обработчик события "ПриСозданииОбъекта"
//
// BSLLS:UnusedLocalMethod-off
Процедура ПриСозданииОбъекта()

	Лог = ПараметрыПриложения.Лог();

КонецПроцедуры // ПриСозданииОбъекта()
// BSLLS:UnusedLocalMethod-on

#КонецОбласти // ОбработчикиСобытий
