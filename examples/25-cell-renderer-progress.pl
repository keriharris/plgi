% PLGI port of cellrendererprogress_example.py in PyGObject-Tutorial.
% Copyright (C) GNU Free Documentation License 1.3
% This file is distributed under the same license as the Python GTK+ 3 Tutorial package.
% Keri Harris <keri.harris@gentoo.org>, 2015.



:- use_module(library(plgi)).

:- plgi_use_namespace('Gtk').

on_inverted_toggled(_Renderer, Path, ListStore) :-
	gtk_tree_model_get_iter_from_string(ListStore, Iter, Path, _),
	gtk_tree_model_get_value(ListStore, Iter, 2, OldValue),
	g_value_get_boolean(OldValue, WasActive),
	(   WasActive == true
	->  IsActive = false
	;   IsActive = true
	),
	g_value_init('gboolean', NewValue),
	g_value_set_boolean(NewValue, IsActive),
	gtk_list_store_set_value(ListStore, Iter, 2, NewValue).

:- dynamic current_iter/1.

on_timeout(ListStore, true) :-
	current_iter(Iter),
	gtk_tree_model_get_value(ListStore, Iter, 1, OldValue),
	g_value_get_int(OldValue, OldPercent),
	NewPercent is OldPercent + 1,

	(   NewPercent > 100
	->  gtk_tree_model_iter_next(ListStore, Iter, IterIsValid),
	    (   IterIsValid == true
	    ->  true
	    ;   gtk_tree_model_get_iter_first(ListStore,
	                                      IterFirst,
	                                      IterFirstIsValid),
	        reset_progress_rows(ListStore, IterFirst, IterFirstIsValid)
	    )
	;   g_value_init('gint', NewValue),
	    g_value_set_int(NewValue, NewPercent),
	    gtk_list_store_set_value(ListStore, Iter, 1, NewValue)
	).

reset_progress_rows(ListStore, Iter, IterIsValid0) :-
	(   IterIsValid0 == true
	->  g_value_init('gint', NewValue),
	    g_value_set_int(NewValue, 0),
	    gtk_list_store_set_value(ListStore, Iter, 1, NewValue),
	    gtk_tree_model_iter_next(ListStore, Iter, IterIsValid1),
	    reset_progress_rows(ListStore, Iter, IterIsValid1)
	;   gtk_tree_model_get_iter_first(ListStore, IterFirst, _),
	    retractall(current_iter(_)),
	    assert(current_iter(IterFirst))
	).

row_spec('Sabayon',     0, false).
row_spec('Zenwalk',     0, false).
row_spec('SimplyMepis', 0, false).

main :-
	gtk_window_new('GTK_WINDOW_TOPLEVEL', Window),
	gtk_window_set_title(Window, 'CellRendererProgress Example'),
	gtk_window_set_default_size(Window, 200, 200),

	gtk_list_store_new(['gchararray', 'gint', 'gboolean'], ListStore),

	forall(row_spec(Text, Progress, Inverted),
	       ( gtk_list_store_append(ListStore, Iter),
	         g_value_init('gchararray', TextValue),
	         g_value_set_string(TextValue, Text),
	         gtk_list_store_set_value(ListStore, Iter, 0, TextValue),
	         g_value_init('gint', ProgressValue),
	         g_value_set_int(ProgressValue, Progress),
	         gtk_list_store_set_value(ListStore, Iter, 1, ProgressValue),
	         g_value_init('gboolean', InvertedValue),
	         g_value_set_boolean(InvertedValue, Inverted),
	         gtk_list_store_set_value(ListStore, Iter, 2, InvertedValue)
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

	gtk_cell_renderer_progress_new(RendererProgress),
	gtk_tree_view_column_new(ColumnProgress),
	gtk_tree_view_column_set_title(ColumnProgress, 'Progress'),
	gtk_tree_view_column_pack_start(ColumnProgress,
	                                RendererProgress,
	                                true),
	gtk_tree_view_column_add_attribute(ColumnProgress,
	                                   RendererProgress,
	                                   'value',
	                                   1),
	gtk_tree_view_column_add_attribute(ColumnProgress,
	                                   RendererProgress,
	                                   'inverted',
	                                   2),
	gtk_tree_view_append_column(TreeView, ColumnProgress, _),

	gtk_cell_renderer_toggle_new(RendererToggle),
	g_signal_connect(RendererToggle,
	                 'toggled',
	                 on_inverted_toggled/3,
	                 ListStore,
	                 _),
	gtk_tree_view_column_new(ColumnToggle),
	gtk_tree_view_column_set_title(ColumnToggle, 'Inverted'),
	gtk_tree_view_column_pack_start(ColumnToggle, RendererToggle, true),
	gtk_tree_view_column_add_attribute(ColumnToggle,
	                                   RendererToggle,
	                                   'active',
	                                   2),
	gtk_tree_view_append_column(TreeView, ColumnToggle, _),

	gtk_container_add(Window, TreeView),

	gtk_tree_model_get_iter_first(ListStore, Iter, _),
	assert(current_iter(Iter)),
	g_timeout_add(100, on_timeout/2, ListStore, _),

	g_signal_connect(Window, 'destroy', gtk_main_quit/0, {null}, _),
	gtk_widget_show_all(Window),
	gtk_main,
	halt.

:- main.
