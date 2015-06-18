% PLGI port of cellrendererpixbuf_example.py in PyGObject-Tutorial.
% Copyright (C) GNU Free Documentation License 1.3
% This file is distributed under the same license as the Python GTK+ 3 Tutorial package.
% Keri Harris <keri.harris@gentoo.org>, 2015.



:- use_module(library(plgi)).

:- plgi_use_namespace('Gtk').

row_spec('New',  'gtk-new').
row_spec('Open', 'gtk-open').
row_spec('Save', 'gtk-save').

main :-
	gtk_window_new('GTK_WINDOW_TOPLEVEL', Window),
	gtk_window_set_title(Window, 'CellRendererPixbuf Example'),
	gtk_window_set_default_size(Window, 200, 200),

	gtk_list_store_new(['gchararray', 'gchararray'], ListStore),

	forall(row_spec(Text, StockId),
	       ( gtk_list_store_append(ListStore, Iter),
	         g_value_init('gchararray', TextValue),
	         g_value_set_string(TextValue, Text),
	         gtk_list_store_set_value(ListStore, Iter, 0, TextValue),
	         g_value_init('gchararray', StockIdValue),
	         g_value_set_string(StockIdValue, StockId),
	         gtk_list_store_set_value(ListStore, Iter, 1, StockIdValue)
	       )),

	gtk_tree_view_new_with_model(ListStore, TreeView),

	gtk_cell_renderer_text_new(RendererText),
	gtk_tree_view_column_new(ColumnText),
	gtk_tree_view_column_set_title(ColumnText, 'Text'),
	gtk_tree_view_column_pack_start(ColumnText, RendererText, true),
	gtk_tree_view_column_add_attribute(ColumnText,
	                                   RendererText,
	                                   'text',
	                                   0),
	gtk_tree_view_append_column(TreeView, ColumnText, _),

	gtk_cell_renderer_pixbuf_new(RendererPixbuf),
	gtk_tree_view_column_new(ColumnPixbuf),
	gtk_tree_view_column_set_title(ColumnPixbuf, 'Image'),
	gtk_tree_view_column_pack_start(ColumnPixbuf, RendererPixbuf, true),
	gtk_tree_view_column_add_attribute(ColumnPixbuf,
	                                   RendererPixbuf,
	                                   'stock_id',
	                                   1),
	gtk_tree_view_append_column(TreeView, ColumnPixbuf, _),

	gtk_container_add(Window, TreeView),

	g_signal_connect(Window, 'destroy', gtk_main_quit/0, {null}, _),
	gtk_widget_show_all(Window),
	gtk_main,
	halt.

:- main.
