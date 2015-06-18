% PLGI port of treeview_filter_example.py in PyGObject-Tutorial.
% Copyright (C) GNU Free Documentation License 1.3
% This file is distributed under the same license as the Python GTK+ 3 Tutorial package.
% Keri Harris <keri.harris@gentoo.org>, 2015.



:- use_module(library(plgi)).

:- plgi_use_namespace('Gtk').

:- dynamic current_filter/1.

language_filter_func(Model, Iter, _UserData, IsVisible) :-
	current_filter(Filter),
	(   Filter == 'None'
	->  IsVisible = true
	;   gtk_tree_model_get_value(Model, Iter, 2, LangValue),
	    g_value_get_string(LangValue, Lang),
	    (   Lang == Filter
	    ->  IsVisible = true
	    ;   IsVisible = false
	    )
	).

on_selection_button_clicked(Button, LanguageFilter) :-
	gtk_button_get_label(Button, Lang),
	retractall(current_filter(_)),
	assert(current_filter(Lang)),
	format('~w language selected~n', [Lang]),
	gtk_tree_model_filter_refilter(LanguageFilter).

main :-
	gtk_window_new('GTK_WINDOW_TOPLEVEL', Window),
	gtk_window_set_title(Window, 'TreeView Filter Demo'),
	gtk_container_set_border_width(Window, 10),

	gtk_grid_new(Grid),
	gtk_grid_set_row_homogeneous(Grid, true),
	gtk_grid_set_column_homogeneous(Grid, true),
	gtk_container_add(Window, Grid),

	SoftwareList = [software('Firefox',      2002, 'C++'),
	                software('Eclipse',      2004, 'Java'),
	                software('Pitivi',       2004, 'Python'),
	                software('Netbeans',     1996, 'Java'),
	                software('Chrome',       2008, 'C++'),
	                software('Filezilla',    2001, 'C++'),
	                software('Bazaar',       2005, 'Python'),
	                software('Git',          2005, 'C'),
	                software('Linux Kernel', 1991, 'C'),
	                software('GCC',          1987, 'C'),
	                software('Frostwire',    2004, 'Java')],

	gtk_list_store_new(['gchararray', 'gint', 'gchararray'], ListStore),

	forall(member(software(Name, Year, Language), SoftwareList),
	       ( gtk_list_store_append(ListStore, Iter),
	         g_value_init('gchararray', NameValue),
	         g_value_set_string(NameValue, Name),
	         gtk_list_store_set_value(ListStore, Iter, 0, NameValue),
	         g_value_init('gint', YearValue),
	         g_value_set_int(YearValue, Year),
	         gtk_list_store_set_value(ListStore, Iter, 1, YearValue),
	         g_value_init('gchararray', LanguageValue),
	         g_value_set_string(LanguageValue, Language),
	         gtk_list_store_set_value(ListStore, Iter, 2, LanguageValue)
	       )),

	assert(current_filter('None')),

	gtk_tree_model_filter_new(ListStore, {null}, LanguageFilter),
	gtk_tree_model_filter_set_visible_func(LanguageFilter,
	                                       language_filter_func/4,
	                                       foo),

	gtk_tree_view_new_with_model(LanguageFilter, TreeView),

	gtk_cell_renderer_text_new(RendererSoftware),
	gtk_tree_view_column_new(ColumnSoftware),
	gtk_tree_view_column_set_title(ColumnSoftware, 'Software'),
	gtk_tree_view_column_pack_start(ColumnSoftware, RendererSoftware, true),
	gtk_tree_view_column_add_attribute(ColumnSoftware,
	                                   RendererSoftware,
	                                   'text',
	                                   0),
	gtk_tree_view_append_column(TreeView, ColumnSoftware, _),

	gtk_cell_renderer_text_new(RendererYear),
	gtk_tree_view_column_new(ColumnYear),
	gtk_tree_view_column_set_title(ColumnYear, 'Release Year'),
	gtk_tree_view_column_pack_start(ColumnYear, RendererYear, true),
	gtk_tree_view_column_add_attribute(ColumnYear,
	                                   RendererYear,
	                                   'text',
	                                   1),
	gtk_tree_view_append_column(TreeView, ColumnYear, _),

	gtk_cell_renderer_text_new(RendererLang),
	gtk_tree_view_column_new(ColumnLang),
	gtk_tree_view_column_set_title(ColumnLang, 'Programming Language'),
	gtk_tree_view_column_pack_start(ColumnLang, RendererLang, true),
	gtk_tree_view_column_add_attribute(ColumnLang,
	                                   RendererLang,
	                                   'text',
	                                   2),
	gtk_tree_view_append_column(TreeView, ColumnLang, _),

	gtk_button_new_with_label('Java', JavaButton),
	gtk_button_new_with_label('C', CButton),
	gtk_button_new_with_label('C++', CPPButton),
	gtk_button_new_with_label('Python', PythonButton),
	gtk_button_new_with_label('None', NoneButton),

	g_signal_connect(JavaButton,
	                 'clicked',
	                 on_selection_button_clicked/2,
	                 LanguageFilter,
	                 _),
	g_signal_connect(CButton,
	                 'clicked',
	                 on_selection_button_clicked/2,
	                 LanguageFilter,
	                 _),
	g_signal_connect(CPPButton,
	                 'clicked',
	                 on_selection_button_clicked/2,
	                 LanguageFilter,
	                 _),
	g_signal_connect(PythonButton,
	                 'clicked',
	                 on_selection_button_clicked/2,
	                 LanguageFilter,
	                 _),
	g_signal_connect(NoneButton,
	                 'clicked',
	                 on_selection_button_clicked/2,
	                 LanguageFilter,
	                 _),

	gtk_scrolled_window_new({null}, {null}, ScrolledWindow),
	gtk_widget_set_vexpand(ScrolledWindow, true),
	gtk_grid_attach(Grid, ScrolledWindow, 0, 0, 8, 10),
	gtk_grid_attach_next_to(Grid,
	                        JavaButton,
	                        ScrolledWindow,
	                        'GTK_POS_BOTTOM',
	                        1,
	                        1),
	gtk_grid_attach_next_to(Grid,
	                        CButton,
	                        JavaButton,
	                        'GTK_POS_RIGHT',
	                        1,
	                        1),
	gtk_grid_attach_next_to(Grid,
	                        CPPButton,
	                        CButton,
	                        'GTK_POS_RIGHT',
	                        1,
	                        1),
	gtk_grid_attach_next_to(Grid,
	                        PythonButton,
	                        CPPButton,
	                        'GTK_POS_RIGHT',
	                        1,
	                        1),
	gtk_grid_attach_next_to(Grid,
	                        NoneButton,
	                        PythonButton,
	                        'GTK_POS_RIGHT',
	                        1,
	                        1),
	gtk_container_add(ScrolledWindow, TreeView),

	g_signal_connect(Window, 'destroy', gtk_main_quit/0, {null}, _),
	gtk_widget_show_all(Window),
	gtk_main,
	halt.

:- main.
