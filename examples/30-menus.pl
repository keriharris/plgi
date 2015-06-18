% PLGI port of menu_example.py in PyGObject-Tutorial.
% Copyright (C) GNU Free Documentation License 1.3
% This file is distributed under the same license as the Python GTK+ 3 Tutorial package.
% Keri Harris <keri.harris@gentoo.org>, 2015.



:- use_module(library(plgi)).

:- plgi_use_namespace('Gtk').

on_button_clicked(_Button, Window) :-
	gtk_dialog_new(Dialog),
	gtk_window_set_title(Dialog, 'My Dialog'),
	gtk_window_set_transient_for(Dialog, Window),
	gtk_dialog_add_button(Dialog,
	                      'gtk-cancel',
	                      'GTK_RESPONSE_CANCEL',
	                      _),
	gtk_dialog_add_button(Dialog,
	                      'gtk-ok',
	                      'GTK_RESPONSE_OK',
	                      _),

	gtk_window_set_default_size(Dialog, 150, 100),

	gtk_label_new('This is a dialog to display additional information',
	              Label),

	gtk_dialog_get_content_area(Dialog, Box),
	gtk_container_add(Box, Label),
	gtk_widget_show_all(Dialog),

	gtk_dialog_run(Dialog, ResponseId),
	plgi_enum_value('GTK_RESPONSE_OK', OkId),
	plgi_enum_value('GTK_RESPONSE_CANCEL', CancelId),
	(   ResponseId == OkId
	->  writeln('The OK button was clicked')
	;   ResponseId == CancelId
	->  writeln('The Cancel button was clicked')
	;   true
	),

	gtk_widget_destroy(Dialog).

on_menu_file_new_generic(_Action, _UserData) :-
	writeln('A File|New menu item was selected.').

on_menu_file_quit(_Action ,_UserData) :-
	gtk_main_quit.

on_menu_others(Action, _UserData) :-
	gtk_action_get_name(Action, Name),
	format('Menu item ~w was selected~n', [Name]).

on_menu_choices_changed(_Action, Current, _UserData) :-
	gtk_action_get_name(Current, Name),
	format('~w was selected.~n', [Name]).

on_menu_choices_toggled(Action, _UserData) :-
	gtk_action_get_name(Action, Name),
	gtk_toggle_action_get_active(Action, IsActive),
	(   IsActive == true
	->  format('~w activated~n', [Name])
	;   format('~w deactivated~n', [Name])
	).

on_button_press_event(_Button, Event, Popup, true) :-
	gdk_event_get_event_type(Event, Type),
	(   Type == 'GDK_BUTTON_PRESS',
	    gdk_event_get_button(Event, 3, true)
	->  gdk_event_get_time(Event, Time),
	    gtk_menu_popup(Popup, {null}, {null}, {null}, {null}, 3, Time)
	;   true
	).

main :-
	gtk_window_new('GTK_WINDOW_TOPLEVEL', Window),
	gtk_window_set_title(Window, 'Menu Example'),
	gtk_window_set_default_size(Window, 200, 200),

	gtk_action_group_new('my_actions', ActionGroup),

	gtk_action_new('FileMenu', 'File', {null}, {null}, ActionFileMenu),
	gtk_action_group_add_action(ActionGroup, ActionFileMenu),

	gtk_action_new('FileNew',
	               {null},
	               {null},
	               'gtk-new',
	               ActionFileNewMenu),
	gtk_action_group_add_action(ActionGroup, ActionFileNewMenu),

	gtk_action_new('FileNewStandard',
	               '_New',
	               'Create a new file',
	               'gtk-new',
	               ActionNew),
	g_signal_connect(ActionNew,
	                 'activate',
	                 on_menu_file_new_generic/2,
	                 {null},
	                 _),
	gtk_action_group_add_action_with_accel(ActionGroup,
	                                       ActionNew,
	                                       {null}),

	gtk_action_new('FileNewFoo',
	               'New Foo',
	               'Create new foo',
	               {null},
	               ActionNewFoo),
	g_signal_connect(ActionNewFoo,
	                 'activate',
	                 on_menu_file_new_generic/2,
                         {null},
	                 _),
	gtk_action_group_add_action(ActionGroup, ActionNewFoo),

	gtk_action_new('FileNewGoo',
	               '_New Goo',
	               'Create new goo',
	               {null},
	               ActionNewGoo),
	g_signal_connect(ActionNewGoo,
	                 'activate',
	                 on_menu_file_new_generic/2,
	                 {null},
	                 _),
	gtk_action_group_add_action(ActionGroup, ActionNewGoo),

	gtk_action_new('FileQuit',
	               {null},
	               {null},
	               'gtk-quit',
	               ActionFileQuit),
	g_signal_connect(ActionFileQuit,
	                 'activate',
	                 on_menu_file_quit/2,
	                 {null},
	                 _),
	gtk_action_group_add_action(ActionGroup, ActionFileQuit),

	gtk_action_new('EditMenu', 'Edit', {null}, {null}, ActionEditMenu),
	gtk_action_group_add_action(ActionGroup, ActionEditMenu),

	gtk_action_new('EditCopy',
	               {null},
	               {null},
	               'gtk-copy',
	               ActionEditCopy),
	g_signal_connect(ActionEditCopy,
	                 'activate',
	                 on_menu_others/2,
	                 {null},
	                 _),
	gtk_action_group_add_action(ActionGroup, ActionEditCopy),

	gtk_action_new('EditPaste',
	               {null},
	               {null},
	               'gtk-paste',
	               ActionEditPaste),
	g_signal_connect(ActionEditPaste,
	                 'activate',
	                 on_menu_others/2,
	                 {null},
	                 _),
	gtk_action_group_add_action(ActionGroup, ActionEditPaste),

	gtk_action_new('EditSomething',
	               'Something',
	               {null},
	               {null},
	               ActionEditSomething),
	g_signal_connect(ActionEditSomething,
	                 'activate',
	                 on_menu_others/2,
	                 {null},
	                 _),
	gtk_action_group_add_action_with_accel(ActionGroup,
	                                       ActionEditSomething,
	                                       '<control><alt>S'),

	gtk_action_new('ChoicesMenu',
	               'Choices',
	               {null},
	               {null},
	               ActionChoicesMenu),
	gtk_action_group_add_action(ActionGroup, ActionChoicesMenu),

	gtk_radio_action_new('ChoiceOne',
	                     'One',
	                     {null},
	                     {null},
	                     1,
	                     ActionChoiceOne),
	gtk_toggle_action_set_active(ActionChoiceOne, true),
	g_signal_connect(ActionChoiceOne,
	                 'changed',
	                 on_menu_choices_changed/3,
	                 {null},
	                 _),
	gtk_action_group_add_action(ActionGroup, ActionChoiceOne),

	gtk_radio_action_new('ChoiceTwo',
	                     'Two',
	                     {null},
	                     {null},
	                     2,
	                     ActionChoiceTwo),
	gtk_radio_action_join_group(ActionChoiceTwo, ActionChoiceOne),
	gtk_action_group_add_action(ActionGroup, ActionChoiceTwo),

	gtk_toggle_action_new('ChoiceThree',
	                      'Three',
	                      {null},
	                      {null},
	                      ActionChoiceThree),
	g_signal_connect(ActionChoiceThree,
	                 'activate',
	                 on_menu_choices_toggled/2,
	                 {null},
	                 _),
	gtk_action_group_add_action(ActionGroup, ActionChoiceThree),

	atomic_list_concat(['<ui>',
	                    '  <menubar name=\'MenuBar\'>',
	                    '    <menu action=\'FileMenu\'>',
	                    '      <menu action=\'FileNew\'>',
	                    '        <menuitem action=\'FileNewStandard\' />',
	                    '        <menuitem action=\'FileNewFoo\' />',
	                    '        <menuitem action=\'FileNewGoo\' />',
	                    '      </menu>',
	                    '      <separator />',
	                    '      <menuitem action=\'FileQuit\' />',
	             	    '    </menu>',
	                    '    <menu action=\'EditMenu\'>',
	                    '      <menuitem action=\'EditCopy\' />',
	                    '      <menuitem action=\'EditPaste\' />',
	                    '      <menuitem action=\'EditSomething\' />',
	                    '    </menu>',
	                    '    <menu action=\'ChoicesMenu\'>',
	                    '      <menuitem action=\'ChoiceOne\'/>',
	                    '      <menuitem action=\'ChoiceTwo\'/>',
	                    '      <separator />',
	                    '      <menuitem action=\'ChoiceThree\'/>',
	                    '    </menu>',
	                    '  </menubar>',
	                    '  <toolbar name=\'ToolBar\'>',
	                    '    <toolitem action=\'FileNewStandard\' />',
	                    '    <toolitem action=\'FileQuit\' />',
	                    '  </toolbar>',
	                    '  <popup name=\'PopupMenu\'>',
	                    '    <menuitem action=\'EditCopy\' />',
	                    '    <menuitem action=\'EditPaste\' />',
	                    '    <menuitem action=\'EditSomething\' />',
	                    '  </popup>',
	                    '</ui>'], UIInfo),

	gtk_ui_manager_new(UIManager),
	gtk_ui_manager_insert_action_group(UIManager, ActionGroup, 0),
	gtk_ui_manager_add_ui_from_string(UIManager, UIInfo, -1, _),
	gtk_ui_manager_get_accel_group(UIManager, AccelGroup),
	gtk_window_add_accel_group(Window, AccelGroup),

	gtk_box_new('GTK_ORIENTATION_VERTICAL', 0, VBox),

	gtk_ui_manager_get_widget(UIManager, '/MenuBar', Menubar),
	gtk_box_pack_start(VBox, Menubar, false, false, 0),

	gtk_ui_manager_get_widget(UIManager, '/ToolBar', Toolbar),
	gtk_box_pack_start(VBox, Toolbar, false, false, 0),

	gtk_ui_manager_get_widget(UIManager, '/PopupMenu', Popup),
	gtk_event_box_new(EventBox),
	g_signal_connect(EventBox,
	                 'button-press-event',
	                 on_button_press_event/4,
	                 Popup,
	                 _),
	gtk_box_pack_start(VBox, EventBox, true, true, 0),

	gtk_label_new('Right-click to see the popup menu.', Label),
	gtk_container_add(EventBox, Label),

	gtk_container_add(Window, VBox),

	g_signal_connect(Window, 'destroy', gtk_main_quit/0, {null}, _),
	gtk_widget_show_all(Window),
	gtk_main,
	halt.

:- main.
