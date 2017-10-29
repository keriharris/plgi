% PLGI port of textview_example.py in PyGObject-Tutorial.
% Copyright (C) GNU Free Documentation License 1.3
% This file is distributed under the same license as the Python GTK+ 3 Tutorial package.
% Keri Harris <keri.harris@gentoo.org>, 2015.



:- use_module(library(plgi)).

:- plgi_use_namespace('Gtk').
:- plgi_use_namespace('Pango').

:- dynamic text_view/1.

on_button_clicked(_Button, Tag) :-
	text_view(TextView),
	gtk_text_view_get_buffer(TextView, TextBuffer),
	gtk_text_buffer_get_selection_bounds(TextBuffer, Start, End, true),
	gtk_text_buffer_apply_tag(TextBuffer, Tag, Start, End).

on_clear_clicked(_Button, _UserData) :-
	text_view(TextView),
	gtk_text_view_get_buffer(TextView, TextBuffer),
	gtk_text_buffer_get_start_iter(TextBuffer, Start),
	gtk_text_buffer_get_end_iter(TextBuffer, End),
	gtk_text_buffer_remove_all_tags(TextBuffer, Start, End).

on_editable_toggled(Button, _UserData) :-
	gtk_toggle_button_get_active(Button, IsActive),
	text_view(TextView),
	gtk_text_view_set_editable(TextView, IsActive).

on_cursor_toggled(Button, _UserData) :-
	gtk_toggle_button_get_active(Button, IsActive),
	text_view(TextView),
	gtk_text_view_set_cursor_visible(TextView, IsActive).

on_wrap_toggled(_Button, WrapMode) :-
	text_view(TextView),
	gtk_text_view_set_wrap_mode(TextView, WrapMode).

on_justify_toggled(_Button, Justification) :-
	text_view(TextView),
	gtk_text_view_set_justification(TextView, Justification).

on_search_clicked(Button, Tag) :-
	gtk_dialog_new(Dialog),
	gtk_window_set_title(Dialog, 'Search'),
	gtk_widget_get_toplevel(Button, Toplevel),
	gtk_window_set_modal(Dialog, true),
	gtk_window_set_transient_for(Dialog, Toplevel),
	gtk_dialog_add_button(Dialog,
	                      'gtk-find',
	                      'GTK_RESPONSE_OK',
	                      _),
	gtk_dialog_add_button(Dialog,
	                      'gtk-cancel',
	                      'GTK_RESPONSE_CANCEL',
	                      _),

	gtk_label_new('Insert text you want to search for:', Label),
	gtk_dialog_get_content_area(Dialog, Box),
	gtk_container_add(Box, Label),

	gtk_entry_new(Entry),
	gtk_container_add(Box, Entry),
	gtk_widget_show_all(Dialog),

	gtk_dialog_run(Dialog, ResponseId),
	plgi_enum_value('GTK_RESPONSE_OK', OkId),
	plgi_enum_value('GTK_RESPONSE_CANCEL', CancelId),
	(   ResponseId == OkId
	->  gtk_entry_get_text(Entry, Text),
	    text_view(TextView),
	    gtk_text_view_get_buffer(TextView, TextBuffer),
	    gtk_text_buffer_get_insert(TextBuffer, CursorMark),
	    gtk_text_buffer_get_iter_at_mark(TextBuffer, CurPos, CursorMark),
	    gtk_text_iter_get_offset(CurPos, Offset),
	    gtk_text_buffer_get_char_count(TextBuffer, CharCount),
	    (   Offset == CharCount
	    ->  gtk_text_buffer_get_start_iter(TextBuffer, Start)
	    ;   Start = CurPos
	    ),
	    gtk_text_iter_forward_search(Start,
	                                 Text,
	                                 [],
	                                 MatchStart,
	                                 MatchEnd,
	                                 {null},
	                                 MatchFound),
	    (   MatchFound == true
	    ->  gtk_text_buffer_apply_tag(TextBuffer,
	                                  Tag,
	                                  MatchStart,
	                                  MatchEnd)
	    ;   true
	    )
	;   ResponseId == CancelId
	->  true
	;   true
	),

	gtk_widget_destroy(Dialog).

main :-
	gtk_window_new('GTK_WINDOW_TOPLEVEL', Window),
	gtk_window_set_title(Window, 'TextView Example'),
	gtk_window_set_default_size(Window, -1, 200),

	gtk_grid_new(Grid),
	gtk_container_add(Window, Grid),

	gtk_scrolled_window_new({null}, {null}, ScrolledWindow),
	gtk_widget_set_hexpand(ScrolledWindow, true),
	gtk_widget_set_vexpand(ScrolledWindow, true),
	gtk_grid_attach(Grid, ScrolledWindow, 0, 1, 3, 1),

	Text = 'This is some text inside of a Gtk.TextView. \c
	        Select text and click one of the buttons \'bold\', \c
                \'italic\', or \'underline\' to modify the text \c
                accordingly.',

	gtk_text_view_new(TextView),
	assert(text_view(TextView)),
	gtk_text_view_get_buffer(TextView, TextBuffer),
	gtk_text_buffer_set_text(TextBuffer, Text, -1),
	gtk_container_add(ScrolledWindow, TextView),

	gtk_text_buffer_get_tag_table(TextBuffer, TagTable),

	gtk_text_tag_new('bold', TagBold),
	g_object_set_property(TagBold,
	                      'weight',
	                      'PANGO_WEIGHT_BOLD'),
	gtk_text_tag_table_add(TagTable, TagBold, _),

	gtk_text_tag_new('italic', TagItalic),
	g_object_set_property(TagItalic,
	                      'style',
	                      'PANGO_STYLE_ITALIC'),
	gtk_text_tag_table_add(TagTable, TagItalic, _),

	gtk_text_tag_new('underline', TagUnderline),
	g_object_set_property(TagUnderline,
	                      'underline',
	                      'PANGO_UNDERLINE_SINGLE'),
	gtk_text_tag_table_add(TagTable, TagUnderline, _),

	gtk_text_tag_new('found', TagFound),
	g_object_set_property(TagFound,
	                      'background',
	                      'yellow'),
	gtk_text_tag_table_add(TagTable, TagFound, _),

	gtk_toolbar_new(Toolbar),
	gtk_grid_attach(Grid, Toolbar, 0, 0, 3, 1),

	gtk_tool_button_new_from_stock('gtk-bold', ButtonBold),
	gtk_toolbar_insert(Toolbar, ButtonBold, 0),

	gtk_tool_button_new_from_stock('gtk-italic', ButtonItalic),
	gtk_toolbar_insert(Toolbar, ButtonItalic, 1),

	gtk_tool_button_new_from_stock('gtk-underline', ButtonUnderline),
	gtk_toolbar_insert(Toolbar, ButtonUnderline, 2),

	g_signal_connect(ButtonBold,
	                 'clicked',
	                 on_button_clicked/2,
	                 TagBold,
	                 _),
	g_signal_connect(ButtonItalic,
	                 'clicked',
	                 on_button_clicked/2,
	                 TagItalic,
	                 _),
	g_signal_connect(ButtonUnderline,
	                 'clicked',
	                 on_button_clicked/2,
	                 TagUnderline,
	                 _),

	gtk_separator_tool_item_new(Separator1),
	gtk_toolbar_insert(Toolbar, Separator1, 3),

	gtk_radio_tool_button_new({null}, RadioJustifyLeft),
	gtk_tool_button_set_stock_id(RadioJustifyLeft, 'gtk-justify-left'),
	gtk_toolbar_insert(Toolbar, RadioJustifyLeft, 4),

	gtk_radio_tool_button_new_with_stock_from_widget(RadioJustifyLeft,
	                                                 'gtk-justify-center',
	                                                 RadioJustifyCenter),
	gtk_toolbar_insert(Toolbar, RadioJustifyCenter, 5),

	gtk_radio_tool_button_new_with_stock_from_widget(RadioJustifyLeft,
	                                                 'gtk-justify-right',
	                                                 RadioJustifyRight),
	gtk_toolbar_insert(Toolbar, RadioJustifyRight, 6),

	gtk_radio_tool_button_new_with_stock_from_widget(RadioJustifyLeft,
	                                                 'gtk-justify-fill',
	                                                 RadioJustifyFill),
	gtk_toolbar_insert(Toolbar, RadioJustifyFill, 7),

	g_signal_connect(RadioJustifyLeft,
	                 'toggled',
	                 on_justify_toggled/2,
	                 'GTK_JUSTIFY_LEFT',
	                 _),
	g_signal_connect(RadioJustifyCenter,
	                 'toggled',
	                 on_justify_toggled/2,
	                 'GTK_JUSTIFY_CENTER',
	                 _),
	g_signal_connect(RadioJustifyRight,
	                 'toggled',
	                 on_justify_toggled/2,
	                 'GTK_JUSTIFY_RIGHT',
	                 _),
	g_signal_connect(RadioJustifyFill,
	                 'toggled',
	                 on_justify_toggled/2,
	                 'GTK_JUSTIFY_FILL',
	                 _),

	gtk_separator_tool_item_new(Separator2),
	gtk_toolbar_insert(Toolbar, Separator2, 8),

	gtk_tool_button_new_from_stock('gtk-clear', ButtonClear),
	g_signal_connect(ButtonClear,
	                 'clicked',
	                 on_clear_clicked/2,
	                 {null},
	                 _),
	gtk_toolbar_insert(Toolbar, ButtonClear, 9),

	gtk_separator_tool_item_new(Separator3),
	gtk_toolbar_insert(Toolbar, Separator3, 10),

	gtk_tool_button_new_from_stock('gtk-find', ButtonSearch),
	g_signal_connect(ButtonSearch,
	                 'clicked',
	                 on_search_clicked/2,
	                 TagFound,
	                 _),
	gtk_toolbar_insert(Toolbar, ButtonSearch, 11),

	gtk_check_button_new_with_label('Editable', CheckEditable),
	gtk_toggle_button_set_active(CheckEditable, true),
	g_signal_connect(CheckEditable,
	                 'toggled',
	                 on_editable_toggled/2,
	                 {null},
	                 _),
	gtk_grid_attach(Grid, CheckEditable, 0, 2, 1, 1),

	gtk_check_button_new_with_label('Cursor Visible', CheckCursor),
	gtk_toggle_button_set_active(CheckCursor, true),
	g_signal_connect(CheckCursor,
	                 'toggled',
	                 on_cursor_toggled/2,
	                 {null},
	                 _),
	gtk_grid_attach_next_to(Grid,
	                        CheckCursor,
	                        CheckEditable,
	                        'GTK_POS_RIGHT',
	                        1,
	                        1),

	gtk_radio_button_new_with_label_from_widget({null},
	                                            'No Wrapping',
	                                            RadioWrapNone),
	gtk_grid_attach(Grid, RadioWrapNone, 0, 3, 1, 1),

	gtk_radio_button_new_with_label_from_widget(RadioWrapNone,
	                                            'Character Wrapping',
	                                            RadioWrapChar),
	gtk_grid_attach_next_to(Grid,
	                        RadioWrapChar,
	                        RadioWrapNone,
	                        'GTK_POS_RIGHT',
	                        1,
	                        1),

	gtk_radio_button_new_with_label_from_widget(RadioWrapNone,
	                                            'Word Wrapping',
	                                            RadioWrapWord),
	gtk_grid_attach_next_to(Grid,
	                        RadioWrapWord,
	                        RadioWrapChar,
	                        'GTK_POS_RIGHT',
	                        1,
	                        1),

	g_signal_connect(RadioWrapNone,
	                 'toggled',
	                 on_wrap_toggled/2,
	                 'GTK_WRAP_NONE',
	                 _),
	g_signal_connect(RadioWrapChar,
	                 'toggled',
	                 on_wrap_toggled/2,
	                 'GTK_WRAP_CHAR',
	                 _),
	g_signal_connect(RadioWrapWord,
	                 'toggled',
	                 on_wrap_toggled/2,
	                 'GTK_WRAP_WORD',
	                 _),

	g_signal_connect(Window, 'destroy', gtk_main_quit/0, {null}, _),
	gtk_widget_show_all(Window),
	gtk_main,
	halt.

:- main.
