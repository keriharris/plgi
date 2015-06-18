% PLGI port of cellrenderercombo_example.py in PyGObject-Tutorial.
% Copyright (C) GNU Free Documentation License 1.3
% This file is distributed under the same license as the Python GTK+ 3 Tutorial package.
% Keri Harris <keri.harris@gentoo.org>, 2015.



:- use_module(library(plgi)).

:- plgi_use_namespace('Gtk').

on_combo_changed(_Widget, Path, Text, ListStore) :-
	g_value_init('gchararray', TextValue),
	g_value_set_string(TextValue, Text),
	gtk_tree_model_get_iter_from_string(ListStore, Iter, Path, _),
	gtk_list_store_set_value(ListStore, Iter, 1, TextValue).

row_spec('Television',   'Samsung').
row_spec('Mobile Phone', 'LG').
row_spec('DVD Player',   'Sony').

main :-
	gtk_window_new('GTK_WINDOW_TOPLEVEL', Window),
	gtk_window_set_title(Window, 'CellRendererCombo Example'),
	gtk_window_set_default_size(Window, 200, 200),

	gtk_list_store_new(['gchararray'], ListStoreManufacturers),

	Manufacturers = ['Sony',
	                 'LG',
	                 'Panasonic',
	                 'Toshiba',
	                 'Nokia',
	                 'Samsung'],

	forall(member(Manufacturer, Manufacturers),
	       ( gtk_list_store_append(ListStoreManufacturers, Iter),
	         g_value_init('gchararray', Value),
	         g_value_set_string(Value, Manufacturer),
	         gtk_list_store_set_value(ListStoreManufacturers,
	                                  Iter,
	                                  0,
	                                  Value)
	       )),

	gtk_list_store_new(['gchararray', 'gchararray'], ListStoreHardware),

	forall(row_spec(Text, Combo),
	       ( gtk_list_store_append(ListStoreHardware, Iter),
	         g_value_init('gchararray', TextValue),
	         g_value_set_string(TextValue, Text),
	         gtk_list_store_set_value(ListStoreHardware,
	                                  Iter,
	                                  0,
	                                  TextValue),
	         g_value_init('gchararray', ComboValue),
	         g_value_set_string(ComboValue, Combo),
	         gtk_list_store_set_value(ListStoreHardware,
	                                  Iter,
	                                  1,
	                                  ComboValue)
	       )),

	gtk_tree_view_new_with_model(ListStoreHardware, TreeView),

	gtk_cell_renderer_text_new(RendererText),
	gtk_tree_view_column_new(ColumnText),
	gtk_tree_view_column_set_title(ColumnText, 'Text'),
	gtk_tree_view_column_pack_start(ColumnText, RendererText, true),
	gtk_tree_view_column_add_attribute(ColumnText,
	                                   RendererText,
	                                   'text',
	                                   0),
	gtk_tree_view_append_column(TreeView, ColumnText, _),

	gtk_cell_renderer_combo_new(RendererCombo),
	g_object_set_property(RendererCombo,
	                      'editable',
	                      true),
	g_object_set_property(RendererCombo,
	                      'model',
	                      ListStoreManufacturers),
	g_object_set_property(RendererCombo,
	                      'text-column',
	                      0),
	g_object_set_property(RendererCombo,
	                      'has-entry',
	                      false),
	g_signal_connect(RendererCombo,
	                 'edited',
	                 on_combo_changed/4,
	                 ListStoreHardware,
	                 _),
	gtk_tree_view_column_new(ColumnCombo),
	gtk_tree_view_column_set_title(ColumnCombo, 'Combo'),
	gtk_tree_view_column_pack_start(ColumnCombo, RendererCombo, true),
	gtk_tree_view_column_add_attribute(ColumnCombo,
	                                   RendererCombo,
	                                   'text',
	                                   1),
	gtk_tree_view_append_column(TreeView, ColumnCombo, _),

	gtk_container_add(Window, TreeView),

	g_signal_connect(Window, 'destroy', gtk_main_quit/0, {null}, _),
	gtk_widget_show_all(Window),
	gtk_main,
	halt.

:- main.
