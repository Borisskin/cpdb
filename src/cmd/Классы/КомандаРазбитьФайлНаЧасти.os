// ----------------------------------------------------------
// This Source Code Form is subject to the terms of the
// Mozilla Public License, v.2.0. If a copy of the MPL
// was not distributed with this file, You can obtain one
// at http://mozilla.org/MPL/2.0/.
// ----------------------------------------------------------
// Codebase: https://github.com/ArKuznetsov/cpdb/
// ----------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////////////////////////
// Прикладной интерфейс

Перем Лог;       // - Объект      - объект записи лога приложения

#Область СлужебныйПрограммныйИнтерфейс

// Процедура - устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект описание команды
//
Процедура ОписаниеКоманды(Команда) Экспорт
	
	Команда.Опция("s src", "", "путь к исходному локальному файлу для разбиения")
	       .ТСтрока()
	       .Обязательный()
	       .ВОкружении("CPDB_FILE_SPLIT_SRC");
	
	Команда.Опция("a arc", "", "имя файла архива (не обязательный, по умолчанию <имя исходного файла>.7z)")
	       .ТСтрока()
	       .ВОкружении("CPDB_FILE_SPLIT_ARCH");
	
	Команда.Опция("l list", "", "имя файла, списка томов архива (не обязательный, по умолчанию <имя исходного файла>.split)")
	       .ТСтрока()
	       .ВОкружении("CPDB_FILE_SPLIT_LIST");
	
	Команда.Опция("vs vol-size", "50m", "размер части {<g>, <m>, <b>} (по умолчанию 50m)")
	       .ТСтрока()
	       .ВОкружении("CPDB_FILE_SPLIT_SIZE");
	
	Команда.Опция("h hash", Ложь, "рассчитывать MD5-хеши файлов частей")
	       .Флаговый()
	       .ВОкружении("CPDB_FILE_SPLIT_HASH");
	
	Команда.Опция("hf hash-file", "", "Имя файла, списка хэшей томов архива
	                                  |(не обязательный, по умолчанию <имя исходного файла>.hash)")
	       .ТСтрока()
	       .ВОкружении("CPDB_FILE_SPLIT_HASH_FILE");
	
	Команда.Опция("ds delsrc", Ложь, "удалить исходный файл после выполнения операции")
	       .Флаговый()
	       .ВОкружении("CPDB_FILE_SPLIT_DEL_SRC");
	
	Команда.Опция("cl compress-level", "0", "уровень сжатия частей архива {0 - 9} (по умолчанию 0 - не сжимать)")
	       .ТСтрока()
	       .ВОкружении("CPDB_FILE_SPLIT_COMPRESS_LEVEL");
	
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

	ПутьКФайлу       = Команда.ЗначениеОпции("src");
	ИмяАрхива        = Команда.ЗначениеОпции("arc");
	ИмяСпискаФайлов  = Команда.ЗначениеОпции("list");
	УдалитьИсточник  = Команда.ЗначениеОпции("delsrc");
	РазбитьНаТома    = Команда.ЗначениеОпции("vol-size");
	РассчитыватьХеши = Команда.ЗначениеОпции("hash");
	ИмяФайлаХэшей    = Команда.ЗначениеОпции("hash-file");
	СтепеньСжатия    = Команда.ЗначениеОпции("compress-level");
	
	КоличествоОтправляемыхФайлов = РаботаСФайлами.ЗапаковатьВАрхив(ПутьКФайлу,
	                                                               ИмяАрхива,
	                                                               ИмяСпискаФайлов,
	                                                               РазбитьНаТома,
	                                                               РассчитыватьХеши,
	                                                               ИмяФайлаХэшей,
	                                                               СтепеньСжатия,
	                                                               УдалитьИсточник);
	
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
