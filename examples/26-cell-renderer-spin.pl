% PLGI port of cellrendererspin_example.py in PyGObject-Tutorial.
% Copyright (C) GNU Free Documentation License 1.3
% This file is distributed under the same license as the Python GTK+ 3 Tutorial package.
% Keri Harris <keri.harris@gentoo.org>, 2015.



:- use_module(library(plgi)).

:- plgi_use_namespace('Gtk').

row_spec('Oranges', 5).
row_spec('Apples',  4).
row_spec('Bananas', 2).

on_amount_edited(_Widget, Path, Text, ListStore) :-
	atom_number(Text, Amount),
	g_value_init('gint', AmountValue),
	g_value_set_int(AmountValue, Amount),
	gtk_tree_model_get_iter_from_string(ListStore, Iter, Path, _),
	gtk_list_store_set_value(ListStore, Iter, 1, AmountValue).

main :-
	gtk_window_new('GTK_WINDOW_TOPLEVEL', Window),
	gtk_window_set_title(Window, 'CellRendererSpin Example'),
	gtk_window_set_default_size(Window, 200, 200),

	gtk_list_store_new(['gchararray', 'gint'], ListStore),

	forall(row_spec(Fruit, Amount),
	       ( gtk_list_store_append(ListStore, Iter),
	         g_value_init('gchararray', FruitValue),
	         g_value_set_string(FruitValue, Fruit),
	         gtk_list_store_set_value(ListStore, Iter, 0, FruitValue),
	         g_value_init('gint', AmountValue),
	         g_value_set_int(AmountValue, Amount),
	         gtk_list_store_set_value(ListStore, Iter, 1, AmountValue)
	       )),

	gtk_tree_view_new_with_model(ListStore, TreeView),

	gtk_cell_renderer_text_new(RendererText),
	gtk_tree_view_column_new(ColumnText),
	gtk_tree_view_column_set_title(ColumnText, 'Fruit'),
	gtk_tree_view_column_pack_start(ColumnText, RendererText, true),
	gtk_tree_view_column_add_attribute(ColumnText,
	                                   RendererText,
	                                   'text',
	                                   0),
	gtk_tree_view_append_column(TreeView, ColumnText, _),

	gtk_cell_renderer_spin_new(RendererSpin),
	g_signal_connect(RendererSpin,
	                 'edited',
	                 on_amount_edited/4,
	                 ListStore,
	                 _),
	g_object_set_property(RendererSpin, 'editable', true),
	gtk_adjustment_new(0, 0, 100, 1, 10, 0, Adjustment),
	g_object_set_property(RendererSpin, 'adjustment', Adjustment),
	gtk_tree_view_column_new(ColumnSpin),
	gtk_tree_view_column_set_title(ColumnSpin, 'Amount'),
	gtk_tree_view_column_pack_start(ColumnSpin, RendererSpin, true),
	gtk_tree_view_column_add_attribute(ColumnSpin,
	                                   RendererSpin,
	                                   'text',
	                                   1),
	gtk_tree_view_append_column(TreeView, ColumnSpin, _),

	gtk_container_add(Window, TreeView),

	g_signal_connect(Window, 'destroy', gtk_main_quit/0, {null}, _),
	gtk_widget_show_all(Window),
	gtk_main,
	halt.

:- main.
