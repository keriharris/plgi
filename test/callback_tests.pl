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

:- plgi_use_namespace_from_dir('CallbackTests', '.').

:- dynamic user:callback_user_data/1.



user:callback__succeed :-
	flag(callback_handled, X, X+1).

user:callback__choicepoint :-
	( flag(callback_handled, X, X+1)
	; flag(callback_handled, X, X+1)
	).

user:callback__fail :-
	fail.

user:callback__throw :-
	throw(callback_exception).

prolog:message(callback_exception) --> [].

user:callback__user_data(UserData) :-
	assert(user:callback_user_data(UserData)),
	flag(callback_handled, X, X+1).

user:callback__small_arity :-
	flag(callback_handled, X, X+1).

user:callback__large_arity(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10) :-
	( A1 = foo -> true ; true ),
	( A2 = foo -> true ; true ),
	( A3 = foo -> true ; true ),
	( A4 = foo -> true ; true ),
	( A5 = foo -> true ; true ),
	( A6 = foo -> true ; true ),
	( A7 = foo -> true ; true ),
	( A8 = foo -> true ; true ),
	( A9 = foo -> true ; true ),
	( A10 = foo -> true ; true ),
	flag(callback_handled, X, X+1).



/* callback handler */
:- begin_tests(plgi_callback_handler).

test(callback_handler_succeeds) :-
	flag(callback_handled, X0, X0),
	callback_tests_scope_call(callback__succeed/0),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(callback_handler_choicepoint) :-
	flag(callback_handled, X0, X0),
	callback_tests_scope_call(callback__choicepoint/0),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(callback_handler_fails) :-
	flag(callback_handled, X0, X0),
	callback_tests_scope_call(callback__fail/0),
	assertion(flag(callback_handled, X0, X0)).

test(callback_handler_throws) :-
	flag(callback_handled, X0, X0),
	callback_tests_scope_call(callback__throw/0),
	assertion(flag(callback_handled, X0, X0)).

test(callback_handler_small_arity) :-
	flag(callback_handled, X0, X0),
	callback_tests_arity_one(callback__small_arity/0),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(callback_handler_large_arity) :-
	flag(callback_handled, X0, X0),
	callback_tests_arity_one(callback__large_arity/10),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

/* error conditions */
test(callback_handler_instantiation_error, [throws(error(instantiation_error, _))]) :-
	callback_tests_scope_call(_).

test(callback_handler_type_error, [throws(error(type_error('callback (in name/arity form)', _), _))]) :-
	callback_tests_scope_call(0).

test(callback_handler_name_type_error, [throws(error(type_error('callback (in name/arity form)', _), _))]) :-
	callback_tests_scope_call(0/0).

test(callback_handler_arity_type_error, [throws(error(type_error('callback (in name/arity form)', _), _))]) :-
	callback_tests_scope_call(callback__succeed/'x').

:- end_tests(plgi_callback_handler).



/* callback scope */
:- begin_tests(plgi_callback_scope).

test(callback_scope_call) :-
	flag(callback_handled, X0, X0),
	callback_tests_scope_call(callback__succeed/0),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(callback_scope_call_multiple_invocations) :-
	flag(callback_handled, X0, X0),
	callback_tests_scope_call_multiple_invocations(callback__succeed/0),
	X1 is X0 + 3,
	assertion(flag(callback_handled, X1, X1)).

test(callback_scope_async) :-
	flag(callback_handled, X0, X0),
	callback_tests_scope_async(callback__succeed/0),
	assertion(flag(callback_handled, X0, X0)),
	callback_tests_invoke_async_callback,
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(callback_scope_notified) :-
	flag(callback_handled, X0, X0),
	callback_tests_scope_notified(callback__succeed/0, {null}),
	assertion(flag(callback_handled, X0, X0)),
	callback_tests_invoke_notified_callback,
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(callback_scope_notified_multiple_invocations) :-
	flag(callback_handled, X0, X0),
	callback_tests_invoke_notified_callback,
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)),
	callback_tests_invoke_notified_callback,
	X2 is X1 + 1,
	assertion(flag(callback_handled, X2, X2)),
	callback_tests_invoke_notified_callback,
	X3 is X2 + 1,
	assertion(flag(callback_handled, X3, X3)).

test(callback_scope_notified_destroy) :-
	callback_tests_destroy_notified_callback.

:- end_tests(plgi_callback_scope).



/* callback user_data */
:- begin_tests(plgi_callback_user_data).

test(callback_user_data_unbound) :-
	UserData = _,
	flag(callback_handled, X0, X0),
	retractall(user:callback_user_data(_)),
	callback_tests_scope_notified(callback__user_data/1, UserData),
	callback_tests_invoke_notified_callback,
	callback_tests_destroy_notified_callback,
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)),
	user:callback_user_data(CallbackUserData),
	assertion(var(CallbackUserData)).

test(callback_user_data_atom) :-
	UserData = 'const \u2665 utf8',
	flag(callback_handled, X0, X0),
	retractall(user:callback_user_data(_)),
	callback_tests_scope_notified(callback__user_data/1, UserData),
	callback_tests_invoke_notified_callback,
	callback_tests_destroy_notified_callback,
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)),
	user:callback_user_data(CallbackUserData),
	assertion(CallbackUserData == UserData).

test(callback_user_data_integer) :-
	UserData = 1,
	flag(callback_handled, X0, X0),
	retractall(user:callback_user_data(_)),
	callback_tests_scope_notified(callback__user_data/1, UserData),
	callback_tests_invoke_notified_callback,
	callback_tests_destroy_notified_callback,
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)),
	user:callback_user_data(CallbackUserData),
	assertion(CallbackUserData == UserData).

test(callback_user_data_float) :-
	UserData = 1.0,
	flag(callback_handled, X0, X0),
	retractall(user:callback_user_data(_)),
	callback_tests_scope_notified(callback__user_data/1, UserData),
	callback_tests_invoke_notified_callback,
	callback_tests_destroy_notified_callback,
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)),
	user:callback_user_data(CallbackUserData),
	assertion(CallbackUserData == UserData).

test(callback_user_data_list) :-
	UserData = ['foo', 'bar', 'baz'],
	flag(callback_handled, X0, X0),
	retractall(user:callback_user_data(_)),
	callback_tests_scope_notified(callback__user_data/1, UserData),
	callback_tests_invoke_notified_callback,
	callback_tests_destroy_notified_callback,
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)),
	user:callback_user_data(CallbackUserData),
	assertion(CallbackUserData == UserData).

test(callback_user_data_compound) :-
	UserData = foo(bar(baz, ['qux']), 1),
	flag(callback_handled, X0, X0),
	retractall(user:callback_user_data(_)),
	callback_tests_scope_notified(callback__user_data/1, UserData),
	callback_tests_invoke_notified_callback,
	callback_tests_destroy_notified_callback,
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)),
	user:callback_user_data(CallbackUserData),
	assertion(CallbackUserData == UserData).

test(callback_user_data_blob) :-
	plgi_struct_new('CallbackTestsStruct'( 'x'=42 ), UserData),
	flag(callback_handled, X0, X0),
	retractall(user:callback_user_data(_)),
	callback_tests_scope_notified(callback__user_data/1, UserData),
	callback_tests_invoke_notified_callback,
	callback_tests_destroy_notified_callback,
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)),
	user:callback_user_data(CallbackUserData),
	assertion(CallbackUserData == UserData).

:- end_tests(plgi_callback_user_data).



/* void callback parameters */
:- begin_tests(plgi_callback_tests_nullfunc).

user:callback_void :- flag(callback_handled, X, X+1).

test(callback_tests_nullfunc) :-
	flag(callback_handled, X0, X0),
	callback_tests_nullfunc(callback_void/0),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

:- end_tests(plgi_callback_tests_nullfunc).



/* return callback parameters */
:- begin_tests(plgi_callback_tests_return).

user:callback_return_boolean(true).
user:callback_return_integer(1).
user:callback_return_float(1.0).
user:callback_return_gtype('GObject').
user:callback_return_string('const \u2665 utf8').
user:callback_return_filename('filename').
user:callback_return_struct(Struct) :- plgi_struct_new('CallbackTestsStruct'( 'x'=42 ), Struct).
user:callback_return_enum('CALLBACK_TESTS_ENUM_VALUE2').
user:callback_return_flags(['CALLBACK_TESTS_FLAGS_VALUE2']).
user:callback_return_list([1, 2, 3]).
user:callback_return_list2(['foo', 'bar', 'baz']).

test(callback_tests_return_gboolean) :-
	callback_tests_return_gboolean(callback_return_boolean/1, Value),
	assertion(Value == true).

test(callback_tests_return_gint8) :-
	callback_tests_return_gint8(callback_return_integer/1, Value),
	assertion(Value == 1).

test(callback_tests_return_guint8) :-
	callback_tests_return_guint8(callback_return_integer/1, Value),
	assertion(Value == 1).

test(callback_tests_return_gint16) :-
	callback_tests_return_gint16(callback_return_integer/1, Value),
	assertion(Value == 1).

test(callback_tests_return_guint16) :-
	callback_tests_return_guint16(callback_return_integer/1, Value),
	assertion(Value == 1).

test(callback_tests_return_gint32) :-
	callback_tests_return_gint32(callback_return_integer/1, Value),
	assertion(Value == 1).

test(callback_tests_return_guint32) :-
	callback_tests_return_guint32(callback_return_integer/1, Value),
	assertion(Value == 1).

test(callback_tests_return_gint64) :-
	callback_tests_return_gint64(callback_return_integer/1, Value),
	assertion(Value == 1).

test(callback_tests_return_guint64) :-
	callback_tests_return_guint64(callback_return_integer/1, Value),
	assertion(Value == 1).

test(callback_tests_return_gchar) :-
	callback_tests_return_gchar(callback_return_integer/1, Value),
	assertion(Value == 1).

test(callback_tests_return_gshort) :-
	callback_tests_return_gshort(callback_return_integer/1, Value),
	assertion(Value == 1).

test(callback_tests_return_gushort) :-
	callback_tests_return_gushort(callback_return_integer/1, Value),
	assertion(Value == 1).

test(callback_tests_return_gint) :-
	callback_tests_return_gint(callback_return_integer/1, Value),
	assertion(Value == 1).

test(callback_tests_return_guint) :-
	callback_tests_return_guint(callback_return_integer/1, Value),
	assertion(Value == 1).

test(callback_tests_return_glong) :-
	callback_tests_return_glong(callback_return_integer/1, Value),
	assertion(Value == 1).

test(callback_tests_return_gulong) :-
	callback_tests_return_gulong(callback_return_integer/1, Value),
	assertion(Value == 1).

test(callback_tests_return_gsize) :-
	callback_tests_return_gsize(callback_return_integer/1, Value),
	assertion(Value == 1).

test(callback_tests_return_gssize) :-
	callback_tests_return_gssize(callback_return_integer/1, Value),
	assertion(Value == 1).

test(callback_tests_return_gintptr) :-
	callback_tests_return_gintptr(callback_return_integer/1, Value),
	assertion(Value == 1).

test(callback_tests_return_guintptr) :-
	callback_tests_return_guintptr(callback_return_integer/1, Value),
	assertion(Value == 1).

test(callback_tests_return_gfloat) :-
	callback_tests_return_gfloat(callback_return_float/1, Value),
	assertion(Value == 1.0).

test(callback_tests_return_gdouble) :-
	callback_tests_return_gdouble(callback_return_float/1, Value),
	assertion(Value == 1.0).

test(callback_tests_return_gunichar) :-
	callback_tests_return_gunichar(callback_return_integer/1, Value),
	assertion(Value == 1).

test(callback_tests_return_GType) :-
	callback_tests_return_GType(callback_return_gtype/1, Value),
	assertion(Value == 'GObject').

test(callback_tests_return_utf8) :-
	callback_tests_return_utf8(callback_return_string/1, Value),
	assertion(Value == 'const \u2665 utf8').

test(callback_tests_return_filename) :-
	callback_tests_return_filename(callback_return_filename/1, Value),
	assertion(Value == 'filename').

test(callback_tests_return_struct) :-
	callback_tests_return_struct(callback_return_struct/1, Value),
	plgi_struct_term(Value, StructTerm),
	assertion(StructTerm == 'CallbackTestsStruct'( 'x'=42 )).

test(callback_tests_return_enum) :-
	callback_tests_return_enum(callback_return_enum/1, Value),
	assertion(Value == 'CALLBACK_TESTS_ENUM_VALUE2').

test(callback_tests_return_flags) :-
	callback_tests_return_flags(callback_return_flags/1, Value),
	assertion(Value == ['CALLBACK_TESTS_FLAGS_VALUE2']).

test(callback_tests_return_array) :-
	callback_tests_return_array(callback_return_list/1, Value),
	assertion(Value == [1, 2, 3]).

test(callback_tests_return_list) :-
	callback_tests_return_list(callback_return_list/1, Value),
	assertion(Value == [1, 2, 3]).

test(callback_tests_return_transfer_none) :-
	callback_tests_return_transfer_none(callback_return_string/1, Value),
	assertion(Value == 'const \u2665 utf8').

test(callback_tests_return_transfer_full) :-
	callback_tests_return_transfer_full(callback_return_string/1, Value),
	assertion(Value == 'const \u2665 utf8').

test(callback_tests_return_transfer_container) :-
	callback_tests_return_transfer_container(callback_return_list2/1, Value),
	assertion(Value == ['foo', 'bar', 'baz']).

:- end_tests(plgi_callback_tests_return).



/* in callback parameters */
:- begin_tests(plgi_callback_tests_inparam).

user:callback_in_boolean(Value) :-
	assertion(Value == true),
	flag(callback_handled, X, X+1).

user:callback_in_integer(Value) :-
	assertion(Value == 1),
	flag(callback_handled, X, X+1).

user:callback_in_float(Value) :-
	assertion(Value == 1.0),
	flag(callback_handled, X, X+1).

user:callback_in_gtype(Value) :-
	assertion(Value == 'GObject'),
	flag(callback_handled, X, X+1).

user:callback_in_string(Value) :-
	assertion(Value == 'const \u2665 utf8'),
	flag(callback_handled, X, X+1).

user:callback_in_filename(Value) :-
	assertion(Value == 'filename'),
	flag(callback_handled, X, X+1).

user:callback_in_struct(Value) :-
	plgi_struct_term(Value, StructTerm),
	assertion(StructTerm == 'CallbackTestsStruct'( 'x'=42 )),
	flag(callback_handled, X, X+1).

user:callback_in_enum(Value) :-
	assertion(Value == 'CALLBACK_TESTS_ENUM_VALUE2'),
	flag(callback_handled, X, X+1).

user:callback_in_flags(Value) :-
	assertion(Value == ['CALLBACK_TESTS_FLAGS_VALUE2']),
	flag(callback_handled, X, X+1).

user:callback_in_list(Value) :-
	assertion(Value == [1, 2, 3]),
	flag(callback_handled, X, X+1).

user:callback_in_list2(Value) :-
	assertion(Value == ['foo', 'bar', 'baz']),
	flag(callback_handled, X, X+1).

test(callback_tests_inparam_gboolean) :-
	flag(callback_handled, X0, X0),
	callback_tests_inparam_gboolean(callback_in_boolean/1, true),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(callback_tests_inparam_gint8) :-
	flag(callback_handled, X0, X0),
	callback_tests_inparam_gint8(callback_in_integer/1, 1),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(callback_tests_inparam_guint8) :-
	flag(callback_handled, X0, X0),
	callback_tests_inparam_guint8(callback_in_integer/1, 1),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(callback_tests_inparam_gint16) :-
	flag(callback_handled, X0, X0),
	callback_tests_inparam_gint16(callback_in_integer/1, 1),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(callback_tests_inparam_guint16) :-
	flag(callback_handled, X0, X0),
	callback_tests_inparam_guint16(callback_in_integer/1, 1),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(callback_tests_inparam_gint32) :-
	flag(callback_handled, X0, X0),
	callback_tests_inparam_gint32(callback_in_integer/1, 1),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(callback_tests_inparam_guint32) :-
	flag(callback_handled, X0, X0),
	callback_tests_inparam_guint32(callback_in_integer/1, 1),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(callback_tests_inparam_gint64) :-
	flag(callback_handled, X0, X0),
	callback_tests_inparam_gint64(callback_in_integer/1, 1),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(callback_tests_inparam_guint64) :-
	flag(callback_handled, X0, X0),
	callback_tests_inparam_guint64(callback_in_integer/1, 1),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(callback_tests_inparam_gchar) :-
	flag(callback_handled, X0, X0),
	callback_tests_inparam_gchar(callback_in_integer/1, 1),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(callback_tests_inparam_gshort) :-
	flag(callback_handled, X0, X0),
	callback_tests_inparam_gshort(callback_in_integer/1, 1),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(callback_tests_inparam_gushort) :-
	flag(callback_handled, X0, X0),
	callback_tests_inparam_gushort(callback_in_integer/1, 1),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(callback_tests_inparam_gint) :-
	flag(callback_handled, X0, X0),
	callback_tests_inparam_gint(callback_in_integer/1, 1),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(callback_tests_inparam_guint) :-
	flag(callback_handled, X0, X0),
	callback_tests_inparam_guint(callback_in_integer/1, 1),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(callback_tests_inparam_glong) :-
	flag(callback_handled, X0, X0),
	callback_tests_inparam_glong(callback_in_integer/1, 1),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(callback_tests_inparam_gulong) :-
	flag(callback_handled, X0, X0),
	callback_tests_inparam_gulong(callback_in_integer/1, 1),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(callback_tests_inparam_gsize) :-
	flag(callback_handled, X0, X0),
	callback_tests_inparam_gsize(callback_in_integer/1, 1),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(callback_tests_inparam_gssize) :-
	flag(callback_handled, X0, X0),
	callback_tests_inparam_gssize(callback_in_integer/1, 1),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(callback_tests_inparam_gintptr) :-
	flag(callback_handled, X0, X0),
	callback_tests_inparam_gintptr(callback_in_integer/1, 1),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(callback_tests_inparam_guintptr) :-
	flag(callback_handled, X0, X0),
	callback_tests_inparam_guintptr(callback_in_integer/1, 1),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(callback_tests_inparam_gfloat) :-
	flag(callback_handled, X0, X0),
	callback_tests_inparam_gfloat(callback_in_float/1, 1.0),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(callback_tests_inparam_gdouble) :-
	flag(callback_handled, X0, X0),
	callback_tests_inparam_gdouble(callback_in_float/1, 1.0),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(callback_tests_inparam_gunichar) :-
	flag(callback_handled, X0, X0),
	callback_tests_inparam_gunichar(callback_in_integer/1, 1),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(callback_tests_inparam_GType) :-
	flag(callback_handled, X0, X0),
	callback_tests_inparam_GType(callback_in_gtype/1, 'GObject'),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(callback_tests_inparam_utf8) :-
	flag(callback_handled, X0, X0),
	callback_tests_inparam_utf8(callback_in_string/1, 'const \u2665 utf8'),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(callback_tests_inparam_filename) :-
	flag(callback_handled, X0, X0),
	callback_tests_inparam_filename(callback_in_filename/1, 'filename'),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(callback_tests_inparam_struct) :-
	flag(callback_handled, X0, X0),
	plgi_struct_new('CallbackTestsStruct'( 'x'=42 ), Struct),
	callback_tests_inparam_struct(callback_in_struct/1, Struct),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(callback_tests_inparam_enum) :-
	flag(callback_handled, X0, X0),
	callback_tests_inparam_enum(callback_in_enum/1, 'CALLBACK_TESTS_ENUM_VALUE2'),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(callback_tests_inparam_flags) :-
	flag(callback_handled, X0, X0),
	callback_tests_inparam_flags(callback_in_flags/1, ['CALLBACK_TESTS_FLAGS_VALUE2']),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(callback_tests_inparam_array) :-
	flag(callback_handled, X0, X0),
	callback_tests_inparam_array(callback_in_list/1, [1, 2, 3]),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(callback_tests_inparam_list) :-
	flag(callback_handled, X0, X0),
	callback_tests_inparam_list(callback_in_list/1, [1, 2, 3]),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(callback_tests_inparam_transfer_none) :-
	flag(callback_handled, X0, X0),
	callback_tests_inparam_transfer_none(callback_in_string/1, 'const \u2665 utf8'),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(callback_tests_inparam_transfer_full) :-
	flag(callback_handled, X0, X0),
	callback_tests_inparam_transfer_full(callback_in_string/1, 'const \u2665 utf8'),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(callback_tests_inparam_transfer_container) :-
	flag(callback_handled, X0, X0),
	callback_tests_inparam_transfer_container(callback_in_list2/1, ['foo', 'bar', 'baz']),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

:- end_tests(plgi_callback_tests_inparam).



/* out callback parameters */
:- begin_tests(plgi_callback_tests_outparam).

user:callback_out_boolean(true).
user:callback_out_integer(1).
user:callback_out_float(1.0).
user:callback_out_gtype('GObject').
user:callback_out_string('const \u2665 utf8').
user:callback_out_filename('filename').
user:callback_out_struct(Struct) :- plgi_struct_new('CallbackTestsStruct'( 'x'=42 ), Struct).
user:callback_out_enum('CALLBACK_TESTS_ENUM_VALUE2').
user:callback_out_flags(['CALLBACK_TESTS_FLAGS_VALUE2']).
user:callback_out_list([1, 2, 3]).
user:callback_out_list2(['foo', 'bar', 'baz']).

test(callback_tests_outparam_gboolean) :-
	callback_tests_outparam_gboolean(callback_out_boolean/1, Value),
	assertion(Value == true).

test(callback_tests_outparam_gint8) :-
	callback_tests_outparam_gint8(callback_out_integer/1, Value),
	assertion(Value == 1).

test(callback_tests_outparam_guint8) :-
	callback_tests_outparam_guint8(callback_out_integer/1, Value),
	assertion(Value == 1).

test(callback_tests_outparam_gint16) :-
	callback_tests_outparam_gint16(callback_out_integer/1, Value),
	assertion(Value == 1).

test(callback_tests_outparam_guint16) :-
	callback_tests_outparam_guint16(callback_out_integer/1, Value),
	assertion(Value == 1).

test(callback_tests_outparam_gint32) :-
	callback_tests_outparam_gint32(callback_out_integer/1, Value),
	assertion(Value == 1).

test(callback_tests_outparam_guint32) :-
	callback_tests_outparam_guint32(callback_out_integer/1, Value),
	assertion(Value == 1).

test(callback_tests_outparam_gint64) :-
	callback_tests_outparam_gint64(callback_out_integer/1, Value),
	assertion(Value == 1).

test(callback_tests_outparam_guint64) :-
	callback_tests_outparam_guint64(callback_out_integer/1, Value),
	assertion(Value == 1).

test(callback_tests_outparam_gchar) :-
	callback_tests_outparam_gchar(callback_out_string/1, Value),
	assertion(Value == 'const \u2665 utf8').

test(callback_tests_outparam_gshort) :-
	callback_tests_outparam_gshort(callback_out_integer/1, Value),
	assertion(Value == 1).

test(callback_tests_outparam_gushort) :-
	callback_tests_outparam_gushort(callback_out_integer/1, Value),
	assertion(Value == 1).

test(callback_tests_outparam_gint) :-
	callback_tests_outparam_gint(callback_out_integer/1, Value),
	assertion(Value == 1).

test(callback_tests_outparam_guint) :-
	callback_tests_outparam_guint(callback_out_integer/1, Value),
	assertion(Value == 1).

test(callback_tests_outparam_glong) :-
	callback_tests_outparam_glong(callback_out_integer/1, Value),
	assertion(Value == 1).

test(callback_tests_outparam_gulong) :-
	callback_tests_outparam_gulong(callback_out_integer/1, Value),
	assertion(Value == 1).

test(callback_tests_outparam_gsize) :-
	callback_tests_outparam_gsize(callback_out_integer/1, Value),
	assertion(Value == 1).

test(callback_tests_outparam_gssize) :-
	callback_tests_outparam_gssize(callback_out_integer/1, Value),
	assertion(Value == 1).

test(callback_tests_outparam_gintptr) :-
	callback_tests_outparam_gintptr(callback_out_integer/1, Value),
	assertion(Value == 1).

test(callback_tests_outparam_guintptr) :-
	callback_tests_outparam_guintptr(callback_out_integer/1, Value),
	assertion(Value == 1).

test(callback_tests_outparam_gfloat) :-
	callback_tests_outparam_gfloat(callback_out_float/1, Value),
	assertion(Value == 1.0).

test(callback_tests_outparam_gdouble) :-
	callback_tests_outparam_gdouble(callback_out_float/1, Value),
	assertion(Value == 1.0).

test(callback_tests_outparam_gunichar) :-
	callback_tests_outparam_gunichar(callback_out_integer/1, Value),
	assertion(Value == 1).

test(callback_tests_outparam_GType) :-
	callback_tests_outparam_GType(callback_out_gtype/1, Value),
	assertion(Value == 'GObject').

test(callback_tests_outparam_utf8) :-
	callback_tests_outparam_utf8(callback_out_string/1, Value),
	assertion(Value == 'const \u2665 utf8').

test(callback_tests_outparam_filename) :-
	callback_tests_outparam_filename(callback_out_filename/1, Value),
	assertion(Value == 'filename').

test(callback_tests_outparam_struct) :-
	callback_tests_outparam_struct(callback_out_struct/1, Value),
	plgi_struct_term(Value, StructTerm),
	assertion(StructTerm == 'CallbackTestsStruct'( 'x'=42 )).

test(callback_tests_outparam_enum) :-
	callback_tests_outparam_enum(callback_out_enum/1, Value),
	assertion(Value == 'CALLBACK_TESTS_ENUM_VALUE2').

test(callback_tests_outparam_flags) :-
	callback_tests_outparam_flags(callback_out_flags/1, Value),
	assertion(Value == ['CALLBACK_TESTS_FLAGS_VALUE2']).

test(callback_tests_outparam_array) :-
	callback_tests_outparam_array(callback_out_list/1, Value),
	assertion(Value == [1, 2, 3]).

test(callback_tests_outparam_list) :-
	callback_tests_outparam_list(callback_out_list/1, Value),
	assertion(Value == [1, 2, 3]).

test(callback_tests_outparam_transfer_none) :-
	callback_tests_outparam_transfer_none(callback_out_string/1, Value),
	assertion(Value == 'const \u2665 utf8').

test(callback_tests_outparam_transfer_full) :-
	callback_tests_outparam_transfer_full(callback_out_string/1, Value),
	assertion(Value == 'const \u2665 utf8').

test(callback_tests_outparam_transfer_container) :-
	callback_tests_outparam_transfer_container(callback_out_list2/1, Value),
	assertion(Value == ['foo', 'bar', 'baz']).

:- end_tests(plgi_callback_tests_outparam).



/* inout callback parameters */
:- begin_tests(plgi_callback_tests_inoutparam).

user:callback_inout_boolean(ValueIn, ValueOut) :-
	assertion(ValueIn == true),
	ValueOut = false.

user:callback_inout_integer(ValueIn, ValueOut) :-
	assertion(ValueIn == 1),
	ValueOut = 2.

user:callback_inout_float(ValueIn, ValueOut) :-
	assertion(ValueIn == 1.0),
	ValueOut = 2.0.

user:callback_inout_gtype(ValueIn, ValueOut) :-
	assertion(ValueIn == 'GObject'),
	ValueOut = 'GObject'.

user:callback_inout_string(ValueIn, ValueOut) :-
	assertion(ValueIn == 'const \u2665 utf8 1'),
	ValueOut = 'const \u2665 utf8 2'.

user:callback_inout_filename(ValueIn, ValueOut) :-
	assertion(ValueIn == 'filename1'),
	ValueOut = 'filename2'.

user:callback_inout_struct(ValueIn, ValueOut) :-
	plgi_struct_term(ValueIn, StructTerm),
	assertion(StructTerm == 'CallbackTestsStruct'( 'x'=42 )),
	plgi_struct_set_field(ValueIn, 'x', 24),
	ValueOut = ValueIn.

user:callback_inout_enum(ValueIn, ValueOut) :-
	assertion(ValueIn == 'CALLBACK_TESTS_ENUM_VALUE2'),
	ValueOut = 'CALLBACK_TESTS_ENUM_VALUE3'.

user:callback_inout_flags(ValueIn, ValueOut) :-
	assertion(ValueIn == ['CALLBACK_TESTS_FLAGS_VALUE2']),
	ValueOut = ['CALLBACK_TESTS_FLAGS_VALUE3'].

user:callback_inout_list(ValueIn, ValueOut) :-
	assertion(ValueIn == [1, 2, 3]),
	ValueOut = [-1, 0, 1, 2, 3, 4].

user:callback_inout_list2(ValueIn, ValueOut) :-
	assertion(ValueIn == ['foo', 'bar', 'baz']),
	ValueOut = ['foo', 'bar', 'baz', 'qux'].

test(callback_tests_inoutparam_gboolean) :-
	callback_tests_inoutparam_gboolean(callback_inout_boolean/2, true, Value),
	assertion(Value == false).

test(callback_tests_inoutparam_gint8) :-
	callback_tests_inoutparam_gint8(callback_inout_integer/2, 1, Value),
	assertion(Value == 2).

test(callback_tests_inoutparam_guint8) :-
	callback_tests_inoutparam_guint8(callback_inout_integer/2, 1, Value),
	assertion(Value == 2).

test(callback_tests_inoutparam_gint16) :-
	callback_tests_inoutparam_gint16(callback_inout_integer/2, 1, Value),
	assertion(Value == 2).

test(callback_tests_inoutparam_guint16) :-
	callback_tests_inoutparam_guint16(callback_inout_integer/2, 1, Value),
	assertion(Value == 2).

test(callback_tests_inoutparam_gint32) :-
	callback_tests_inoutparam_gint32(callback_inout_integer/2, 1, Value),
	assertion(Value == 2).

test(callback_tests_inoutparam_guint32) :-
	callback_tests_inoutparam_guint32(callback_inout_integer/2, 1, Value),
	assertion(Value == 2).

test(callback_tests_inoutparam_gint64) :-
	callback_tests_inoutparam_gint64(callback_inout_integer/2, 1, Value),
	assertion(Value == 2).

test(callback_tests_inoutparam_guint64) :-
	callback_tests_inoutparam_guint64(callback_inout_integer/2, 1, Value),
	assertion(Value == 2).

test(callback_tests_inoutparam_gchar) :-
	callback_tests_inoutparam_gchar(callback_inout_string/2, 'const \u2665 utf8 1', Value),
	assertion(Value == 'const \u2665 utf8 2').

test(callback_tests_inoutparam_gshort) :-
	callback_tests_inoutparam_gshort(callback_inout_integer/2, 1, Value),
	assertion(Value == 2).

test(callback_tests_inoutparam_gushort) :-
	callback_tests_inoutparam_gushort(callback_inout_integer/2, 1, Value),
	assertion(Value == 2).

test(callback_tests_inoutparam_gint) :-
	callback_tests_inoutparam_gint(callback_inout_integer/2, 1, Value),
	assertion(Value == 2).

test(callback_tests_inoutparam_guint) :-
	callback_tests_inoutparam_guint(callback_inout_integer/2, 1, Value),
	assertion(Value == 2).

test(callback_tests_inoutparam_glong) :-
	callback_tests_inoutparam_glong(callback_inout_integer/2, 1, Value),
	assertion(Value == 2).

test(callback_tests_inoutparam_gulong) :-
	callback_tests_inoutparam_gulong(callback_inout_integer/2, 1, Value),
	assertion(Value == 2).

test(callback_tests_inoutparam_gsize) :-
	callback_tests_inoutparam_gsize(callback_inout_integer/2, 1, Value),
	assertion(Value == 2).

test(callback_tests_inoutparam_gssize) :-
	callback_tests_inoutparam_gssize(callback_inout_integer/2, 1, Value),
	assertion(Value == 2).

test(callback_tests_inoutparam_gintptr) :-
	callback_tests_inoutparam_gintptr(callback_inout_integer/2, 1, Value),
	assertion(Value == 2).

test(callback_tests_inoutparam_guintptr) :-
	callback_tests_inoutparam_guintptr(callback_inout_integer/2, 1, Value),
	assertion(Value == 2).

test(callback_tests_inoutparam_gfloat) :-
	callback_tests_inoutparam_gfloat(callback_inout_float/2, 1.0, Value),
	assertion(Value == 2.0).

test(callback_tests_inoutparam_gdouble) :-
	callback_tests_inoutparam_gdouble(callback_inout_float/2, 1.0, Value),
	assertion(Value == 2.0).

test(callback_tests_inoutparam_gunichar) :-
	callback_tests_inoutparam_gunichar(callback_inout_integer/2, 1, Value),
	assertion(Value == 2).

test(callback_tests_inoutparam_GType) :-
	callback_tests_inoutparam_GType(callback_inout_gtype/2, 'GObject', Value),
	assertion(Value == 'GObject').

test(callback_tests_inoutparam_utf8) :-
	callback_tests_inoutparam_utf8(callback_inout_string/2, 'const \u2665 utf8 1', Value),
	assertion(Value == 'const \u2665 utf8 2').

test(callback_tests_inoutparam_filename) :-
	callback_tests_inoutparam_filename(callback_inout_filename/2, 'filename1', Value),
	assertion(Value == 'filename2').

test(callback_tests_inoutparam_struct) :-
	plgi_struct_new('CallbackTestsStruct'( 'x'=42 ), Struct),
	callback_tests_inoutparam_struct(callback_inout_struct/2, Struct, Value),
	plgi_struct_term(Value, StructTerm),
	assertion(StructTerm == 'CallbackTestsStruct'( 'x'=24 )).

test(callback_tests_inoutparam_enum) :-
	callback_tests_inoutparam_enum(callback_inout_enum/2, 'CALLBACK_TESTS_ENUM_VALUE2', Value),
	assertion(Value == 'CALLBACK_TESTS_ENUM_VALUE3').

test(callback_tests_inoutparam_flags) :-
	callback_tests_inoutparam_flags(callback_inout_flags/2, ['CALLBACK_TESTS_FLAGS_VALUE2'], Value),
	assertion(Value == ['CALLBACK_TESTS_FLAGS_VALUE3']).

test(callback_tests_inoutparam_array) :-
	callback_tests_inoutparam_array(callback_inout_list/2, [1, 2, 3], Value),
	assertion(Value == [-1, 0, 1, 2, 3, 4]).

test(callback_tests_inoutparam_list) :-
	callback_tests_inoutparam_list(callback_inout_list/2, [1, 2, 3], Value),
	assertion(Value == [-1, 0, 1, 2, 3, 4]).

test(callback_tests_inoutparam_transfer_none) :-
	callback_tests_inoutparam_transfer_none(callback_inout_string/2, 'const \u2665 utf8 1', Value),
	assertion(Value == 'const \u2665 utf8 2').

test(callback_tests_inoutparam_transfer_full) :-
	callback_tests_inoutparam_transfer_full(callback_inout_string/2, 'const \u2665 utf8 1', Value),
	assertion(Value == 'const \u2665 utf8 2').

test(callback_tests_inoutparam_transfer_container) :-
	callback_tests_inoutparam_transfer_container(callback_inout_list2/2, ['foo', 'bar', 'baz'], Value),
	assertion(Value == ['foo', 'bar', 'baz', 'qux']).

:- end_tests(plgi_callback_tests_inoutparam).

/* FIXME: check for memory leaks */
