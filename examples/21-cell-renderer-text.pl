% PLGI port of cellrenderertext_example.py in PyGObject-Tutorial.
% Copyright (C) GNU Free Documentation License 1.3
% This file is distributed under the same license as the Python GTK+ 3 Tutorial package.
% Keri Harris <keri.harris@gentoo.org>, 2015.



:- use_module(library(plgi)).

:- plgi_use_namespace('Gtk').

text_edited(_Renderer, Path, Text, ListStore) :-
	g_value_init('gchararray', TextValue),
	g_value_set_string(TextValue, Text),
	gtk_tree_model_get_iter_from_string(ListStore, Iter, Path, _),
	gtk_list_store_set_value(ListStore, Iter, 1, TextValue).

row_spec('Fedora',    'http://fedoraproject.org/').
row_spec('Slackware', 'http://www.slackware.com/').
row_spec('Sidux',     'http://sidux.com/').

main :-
	gtk_window_new('GTK_WINDOW_TOPLEVEL', Window),
	gtk_window_set_title(Window, 'CellRendererText Example'),
	gtk_window_set_default_size(Window, 200, 200),

	gtk_list_store_new(['gchararray', 'gchararray'], ListStore),

	forall(row_spec(Text, EditableText),
	       ( gtk_list_store_append(ListStore, Iter),
	         g_value_init('gchararray', TextValue),
	         g_value_set_string(TextValue, Text),
	         gtk_list_store_set_value(ListStore,
	                                  Iter,
	                                  0,
	                                  TextValue),
	         g_value_init('gchararray', EditableTextValue),
	         g_value_set_string(EditableTextValue, EditableText),
	         gtk_list_store_set_value(ListStore,
	                                  Iter,
	                                  1,
	                                  EditableTextValue)
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

	gtk_cell_renderer_text_new(RendererEditableText),
	g_object_set_property(RendererEditableText, 'editable', true),
	gtk_tree_view_column_new(ColumnEditableText),
	gtk_tree_view_column_set_title(ColumnEditableText, 'Editable Text'),
	gtk_tree_view_column_pack_start(ColumnEditableText,
	                                RendererEditableText,
	                                true),
	gtk_tree_view_column_add_attribute(ColumnEditableText,
	                                   RendererEditableText,
	                                   'text',
	                                   1),
	gtk_tree_view_append_column(TreeView, ColumnEditableText, _),

	g_signal_connect(RendererEditableText,
	                 'edited',
	                 text_edited/4,
	                 ListStore,
	                 _),

	gtk_container_add(Window, TreeView),

	g_signal_connect(Window, 'destroy', gtk_main_quit/0, {null}, _),
	gtk_widget_show_all(Window),
	gtk_main,
	halt.

:- main.
