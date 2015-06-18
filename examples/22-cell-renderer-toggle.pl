% PLGI port of cellrenderertoggle_example.py in PyGObject-Tutorial.
% Copyright (C) GNU Free Documentation License 1.3
% This file is distributed under the same license as the Python GTK+ 3 Tutorial package.
% Keri Harris <keri.harris@gentoo.org>, 2015.



:- use_module(library(plgi)).

:- plgi_use_namespace('Gtk').

on_cell_toggled(_Renderer, Path, ListStore) :-
	gtk_tree_model_get_iter_from_string(ListStore, Iter, Path, _),
	gtk_tree_model_get_value(ListStore, Iter, 1, OldValue),
	g_value_get_boolean(OldValue, WasActive),
	(   WasActive == true
	->  IsActive = false
	;   IsActive = true
	),
	g_value_init('gboolean', NewValue),
	g_value_set_boolean(NewValue, IsActive),
	gtk_list_store_set_value(ListStore, Iter, 1, NewValue).

update_radio_rows(ListStore, Iter, PathStr) :-
	(   var(Iter)
	->  gtk_tree_model_get_iter_first(ListStore, Iter, IterIsValid)
	;   gtk_tree_model_iter_next(ListStore, Iter, IterIsValid)
	),
	(   IterIsValid == true
	->  gtk_tree_model_get_path(ListStore, Iter, RowPath),
	    gtk_tree_path_to_string(RowPath, RowPathStr),
	    (   RowPathStr == PathStr
	    ->  IsActive = true
	    ;   IsActive = false
	    ),
	    g_value_init('gboolean', NewValue),
	    g_value_set_boolean(NewValue, IsActive),
	    gtk_list_store_set_value(ListStore, Iter, 2, NewValue),
	    update_radio_rows(ListStore, Iter, PathStr)
	;   true
	).

on_cell_radio_toggled(_Renderer, PathStr, ListStore) :-
	update_radio_rows(ListStore, _, PathStr).

row_spec('Debian',   false, true).
row_spec('OpenSuse', true,  false).
row_spec('Fedora',   false, false).

main :-
	gtk_window_new('GTK_WINDOW_TOPLEVEL', Window),
	gtk_window_set_title(Window, 'CellRendererToggle Example'),
	gtk_window_set_default_size(Window, 200, 200),

	gtk_list_store_new(['gchararray', 'gboolean', 'gboolean'],
	                   ListStore),

	forall(row_spec(Text, Toggle, Radio),
	       ( gtk_list_store_append(ListStore, Iter),
	         g_value_init('gchararray', TextValue),
	         g_value_set_string(TextValue, Text),
	         gtk_list_store_set_value(ListStore, Iter, 0, TextValue),
	         g_value_init('gboolean', ToggleValue),
	         g_value_set_boolean(ToggleValue, Toggle),
	         gtk_list_store_set_value(ListStore, Iter, 1, ToggleValue),
	         g_value_init('gboolean', RadioValue),
	         g_value_set_boolean(RadioValue, Radio),
	         gtk_list_store_set_value(ListStore, Iter, 2, RadioValue)
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

	gtk_cell_renderer_toggle_new(RendererToggle),
	g_signal_connect(RendererToggle,
	                 'toggled',
	                 on_cell_toggled/3,
	                 ListStore,
	                 _),
	gtk_tree_view_column_new(ColumnToggle),
	gtk_tree_view_column_set_title(ColumnToggle, 'Toggle'),
	gtk_tree_view_column_pack_start(ColumnToggle, RendererToggle, true),
	gtk_tree_view_column_add_attribute(ColumnToggle,
	                                   RendererToggle,
	                                   'active',
	                                   1),
	gtk_tree_view_append_column(TreeView, ColumnToggle, _),

	gtk_cell_renderer_toggle_new(RendererRadio),
	gtk_cell_renderer_toggle_set_radio(RendererRadio, true),
	g_signal_connect(RendererRadio,
	                 'toggled',
	                 on_cell_radio_toggled/3,
	                 ListStore,
	                 _),
	gtk_tree_view_column_new(ColumnRadio),
	gtk_tree_view_column_set_title(ColumnRadio, 'Radio'),
	gtk_tree_view_column_pack_start(ColumnRadio, RendererRadio, true),
	gtk_tree_view_column_add_attribute(ColumnRadio,
	                                   RendererRadio,
	                                   'active',
	                                   2),
	gtk_tree_view_append_column(TreeView, ColumnRadio, _),

	gtk_container_add(Window, TreeView),

	g_signal_connect(Window, 'destroy', gtk_main_quit/0, {null}, _),
	gtk_widget_show_all(Window),
	gtk_main,
	halt.

:- main.
