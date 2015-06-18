% PLGI port of combobox_example.py in PyGObject-Tutorial.
% Copyright (C) GNU Free Documentation License 1.3
% This file is distributed under the same license as the Python GTK+ 3 Tutorial package.
% Keri Harris <keri.harris@gentoo.org>, 2015.



:- use_module(library(plgi)).

:- plgi_use_namespace('Gtk').

on_name_combo_changed(ComboBox, _UserData) :-
	gtk_combo_box_get_active_iter(ComboBox, Iter, IterIsValid),
	(   IterIsValid == true
	->  gtk_combo_box_get_model(ComboBox, Model),
	    gtk_tree_model_get_value(Model, Iter, 0, IDValue),
	    g_value_get_int(IDValue, ID),
	    gtk_tree_model_get_value(Model, Iter, 1, NameValue),
	    g_value_get_string(NameValue, Name),
	    format('Selected: ID=~w, name=~w~n', [ID, Name])
	;   gtk_bin_get_child(ComboBox, Entry),
	    gtk_entry_get_text(Entry, Text),
	    format('Entered: ~w~n', [Text])
	).

on_country_combo_changed(ComboBox, _UserData) :-
	gtk_combo_box_get_active_iter(ComboBox, Iter, IterIsValid),
	(   IterIsValid == true
	->  gtk_combo_box_get_model(ComboBox, Model),
	    gtk_tree_model_get_value(Model, Iter, 0, CountryValue),
	    g_value_get_string(CountryValue, Country),
	    format('Selected: country=~w~n', [Country])
	;   true
	).

on_currency_combo_changed(ComboBox, _UserData) :-
	gtk_combo_box_text_get_active_text(ComboBox, Currency),
	format('Selected: currency=~w~n', [Currency]).

row_spec(1,  'Billy Bob').
row_spec(11, 'Billy Bob Junior').
row_spec(12, 'Sue Bob').
row_spec(2,  'Joey Jojo').
row_spec(3,  'Rob McRoberts').
row_spec(31, 'Xavier McRoberts').

main :-
	gtk_window_new('GTK_WINDOW_TOPLEVEL', Window),
	gtk_window_set_title(Window, 'ComboBox Example'),
	gtk_container_set_border_width(Window, 10),

	gtk_list_store_new(['gint', 'gchararray'], NameStore),

	forall(row_spec(ID, Name),
	       ( gtk_list_store_append(NameStore, Iter),
	         g_value_init('gint', IDValue),
	         g_value_set_int(IDValue, ID),
	         gtk_list_store_set_value(NameStore,
	                                  Iter,
	                                  0,
	                                  IDValue),
	         g_value_init('gchararray', NameValue),
	         g_value_set_string(NameValue, Name),
	         gtk_list_store_set_value(NameStore,
	                                  Iter,
	                                  1,
	                                  NameValue)
	       )),

	gtk_box_new('GTK_ORIENTATION_VERTICAL', 6, VBox),

	gtk_combo_box_new_with_model_and_entry(NameStore, NameCombo),
	g_signal_connect(NameCombo,
	                 'changed',
	                 on_name_combo_changed/2,
	                 {null},
	                 _),
	gtk_combo_box_set_entry_text_column(NameCombo, 1),
	gtk_box_pack_start(VBox, NameCombo, false, false, 0),

	gtk_list_store_new(['gchararray'], CountryStore),

	Countries = ['Austria',
	             'Brazil',
	             'Belgium',
	             'France',
	             'Germany',
	             'Switzerland',
	             'United Kingdom',
	             'United States of America',
	             'Uruguay'],

	forall(member(Country, Countries),
	       ( gtk_list_store_append(CountryStore, Iter),
	         g_value_init('gchararray', CountryValue),
	         g_value_set_string(CountryValue, Country),
	         gtk_list_store_set_value(CountryStore,
	                                  Iter,
	                                  0,
	                                  CountryValue)
	       )),

	gtk_combo_box_new_with_model(CountryStore, CountryCombo),
	g_signal_connect(CountryCombo,
	                 'changed',
	                 on_country_combo_changed/2,
	                 {null},
	                 _),
	gtk_cell_renderer_text_new(RendererText),
	gtk_cell_layout_pack_start(CountryCombo, RendererText, true),
	gtk_cell_layout_add_attribute(CountryCombo, RendererText, 'text', 0),
	gtk_box_pack_start(VBox, CountryCombo, false, false, 0),

	Currencies = ['Euro',
	              'US Dollars',
	              'British Pound',
	              'Japanese Yen',
	              'Russian Ruble',
	              'Mexican peso',
	              'Swiss franc'],

	gtk_combo_box_text_new(CurrencyCombo),
	gtk_combo_box_set_entry_text_column(CurrencyCombo, 0),
	g_signal_connect(CurrencyCombo,
	                 'changed',
	                 on_currency_combo_changed/2,
	                 {null},
	                 _),
	forall(member(Currency, Currencies),
	       gtk_combo_box_text_append_text(CurrencyCombo, Currency)),
	gtk_box_pack_start(VBox, CurrencyCombo, false, false, 0),

	gtk_container_add(Window, VBox),

	g_signal_connect(Window, 'destroy', gtk_main_quit/0, {null}, _),
	gtk_widget_show_all(Window),
	gtk_main,
	halt.

:- main.
