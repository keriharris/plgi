/*  This file is part of PLGI.

    Copyright (C) 2015 Keri Harris <keri@gentoo.org>

    PLGI is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as
    published by the Free Software Foundation, either version 2.1
    of the License, or (at your option) any later version.

    PLGI is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with PLGI.  If not, see <http://www.gnu.org/licenses/>.
*/

:- module('GObject_overrides',
          [
            g_is_object/1,
            g_is_value/1,
            g_object_new/3,
            g_object_get_property/3,
            g_object_set_property/3,
            g_object_type/2,
            g_param_spec_value_type/2,
            g_signal_connect/5,
            g_signal_connect_after/5,
            g_signal_connect_data/6,
            g_signal_connect_swapped/5,
            g_signal_emit/4,
            g_value_get_boxed/2,
            g_value_holds/2,
            g_value_init/2,
            g_value_set_boxed/2
          ]).



/* GObject */
g_is_object(Object) :-
	plgi:plgi_g_is_object(Object).

g_object_new(ObjectType, Properties, Object) :-
	plgi:plgi_object_new(ObjectType, Properties, Object).

g_object_get_property(Object, PropertyName, PropertyValue) :-
	plgi:plgi_object_get_property(Object, PropertyName, PropertyValue).

g_object_set_property(Object, PropertyName, PropertyValue) :-
	plgi:plgi_object_set_property(Object, PropertyName, PropertyValue).

g_object_type(Object, Type) :-
	plgi:plgi_g_object_type(Object, Type).



/* GParamSpec */
g_param_spec_value_type(GParamSpec, ValueType) :-
	plgi:plgi_g_param_spec_value_type(GParamSpec, ValueType).



/* GSignal */
g_signal_connect(Object, Signal, Handler, UserData, HandlerId) :-
	g_signal_connect_data(Object, Signal, Handler, UserData, [], HandlerId).

g_signal_connect_after(Object, Signal, Handler, UserData, HandlerId) :-
	g_signal_connect_data(Object, Signal, Handler, UserData, ['G_CONNECT_AFTER'], HandlerId).

g_signal_connect_swapped(Object, Signal, Handler, UserData, HandlerId) :-
	g_signal_connect_data(Object, Signal, Handler, UserData, ['G_CONNECT_SWAPPED'], HandlerId).

g_signal_connect_data(Object, Signal, Handler, UserData, ConnectFlags, HandlerId) :-
	plgi:plgi_signal_connect_data(Object, Signal, Handler, UserData, ConnectFlags, HandlerId).

g_signal_emit(Object, Signal, Detail, Args) :-
	plgi:plgi_signal_emit(Object, Signal, Detail, Args).



/* GValue */
g_value_init(GType, GValue) :-
	plgi:plgi_struct_new('GValue'(), EmptyGValue),
	'GObject':g_value_init(EmptyGValue, GType, GValue).

g_value_get_boxed(GValue, Boxed) :-
	plgi:plgi_g_value_get_boxed(GValue, Boxed).

g_value_set_boxed(GValue, Boxed) :-
	plgi:plgi_g_value_set_boxed(GValue, Boxed).

g_is_value(GValue) :-
	plgi:plgi_g_is_value(GValue).

g_value_holds(GValue, GType) :-
	plgi:plgi_g_value_holds(GValue, GType).
