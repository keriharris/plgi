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

:- plgi_use_namespace_from_dir('SignalTests', '.').
:- plgi_use_namespace('GObject').



/* g_signal_connect/5 */
:- begin_tests(plgi_signals_g_signal_connect).

test(g_signal_connect) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'void-params', true/0, {null}, HandlerId),
	assertion(g_signal_handler_is_connected(Object, HandlerId, true)).

test(g_signal_connect_after) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect_after(Object, 'void-params', true/0, {null}, HandlerId),
	assertion(g_signal_handler_is_connected(Object, HandlerId, true)).

test(g_signal_connect_swapped) :-
	g_object_new('SignalTestsObject', [], Object),
	g_object_new('SignalTestsObject', [], OtherObject),
	g_signal_connect_swapped(Object, 'void-params', true/0, OtherObject, HandlerId),
	assertion(g_signal_handler_is_connected(Object, HandlerId, true)).

test(g_signal_connect_data) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect_data(Object, 'void-params', true/0, {null}, [], HandlerId),
	assertion(g_signal_handler_is_connected(Object, HandlerId, true)).

test(g_signal_connect_object) :-
	g_object_new('SignalTestsObject', [], Object),
	g_object_new('SignalTestsObject', [], OtherObject),
	g_signal_connect_data(Object, 'void-params', true/0, OtherObject, [], HandlerId),
	assertion(g_signal_handler_is_connected(Object, HandlerId, true)).

test(g_signal_disconnect) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'void-params', true/0, {null}, HandlerId),
	assertion(g_signal_handler_is_connected(Object, HandlerId, true)),
	g_signal_handler_disconnect(Object, HandlerId),
	assertion(g_signal_handler_is_connected(Object, HandlerId, false)).

/* error conditions */
test(g_signal_connect_signame_instantiation_error, [throws(error(instantiation_error, _))]) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, _, true/0, {null}, _).

test(g_signal_connect_signame_domain_error, [throws(error(domain_error('signal', _), _))]) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'x', true/0, {null}, _).

test(g_signal_connect_signame_type_error, [throws(error(type_error('atom', _), _))]) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 0, true/0, {null}, _).

test(g_signal_connect_sighandler_instantiation_error, [throws(error(instantiation_error, _))]) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'void-params', _, {null}, _).

test(g_signal_connect_sighandler_type_error, [throws(error(type_error('callback (in name/arity form)', _), _))]) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'void-params', 0, {null}, _).

test(g_signal_connect_sighandler_name_type_error, [throws(error(type_error('callback (in name/arity form)', _), _))]) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'void-params', 0/2, {null}, _).

test(g_signal_connect_sighandler_arity_type_error, [throws(error(type_error('callback (in name/arity form)', _), _))]) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'void-params', true/'x', {null}, _).

test(g_signal_connect_flags_instantiation_error, [throws(error(instantiation_error, _))]) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect_data(Object, 'void-params', true/0, {null}, _, _).

test(g_signal_connect_flags_domain_error, [throws(error(domain_error('GConnectFlags', _), _))]) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect_data(Object, 'void-params', true/0, {null}, ['x'], _).

test(g_signal_connect_flags_type_error, [throws(error(type_error('GConnectFlags', _), _))]) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect_data(Object, 'void-params', true/0, {null}, [0], _).

:- end_tests(plgi_signals_g_signal_connect).



/* g_signal_emit/4 */
:- begin_tests(plgi_signals_g_signal_emit).

user:sig_handler__succeed(_Object, _UserData) :-
	flag(signal_handled, X, X+1).

user:sig_handler__choicepoint(_Object, _UserData) :-
	( flag(signal_handled, X, X+1)
	; flag(signal_handled, X, X+1)
	).

user:sig_handler__fail(_Object, _UserData) :-
	fail.

user:sig_handler__throw(_Object, _UserData) :-
	throw(sig_handler_exception).

prolog:message(sig_handler_exception) --> [].

user:sig_handler__small_arity :-
	flag(signal_handled, X, X+1).

user:sig_handler__large_arity(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10) :-
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
	flag(signal_handled, X, X+1).

test(g_signal_emit_handler_succeeds) :-
	flag(signal_handled, X0, X0),
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'void-params', sig_handler__succeed/2, {null}, _),
	g_signal_emit(Object, 'void-params', {null}, []),
	X1 is X0 + 1,
	assertion(flag(signal_handled, X1, X1)).

test(g_signal_emit_handler_choicepoint) :-
	flag(signal_handled, X0, X0),
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'void-params', sig_handler__choicepoint/2, {null}, _),
	g_signal_emit(Object, 'void-params', {null}, []),
	X1 is X0 + 1,
	assertion(flag(signal_handled, X1, X1)).

test(g_signal_emit_handler_fails) :-
	flag(signal_handled, X0, X0),
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'void-params', sig_handler__fail/2, {null}, _),
	g_signal_emit(Object, 'void-params', {null}, []),
	assertion(flag(signal_handled, X0, X0)).

test(g_signal_emit_handler_throws) :-
	flag(signal_handled, X0, X0),
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'void-params', sig_handler__throw/2, {null}, _),
	g_signal_emit(Object, 'void-params', {null}, []),
	assertion(flag(signal_handled, X0, X0)).

test(g_signal_emit_handler_small_arity) :-
	flag(signal_handled, X0, X0),
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'inparam-string', sig_handler__small_arity/0, {null}, _),
	g_signal_emit(Object, 'inparam-string', {null}, ['const \u2665 utf8']),
	X1 is X0 + 1,
	assertion(flag(signal_handled, X1, X1)).

test(g_signal_emit_handler_large_arity) :-
	flag(signal_handled, X0, X0),
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'inparam-string', sig_handler__large_arity/10, {null}, _),
	g_signal_emit(Object, 'inparam-string', {null}, ['const \u2665 utf8']),
	X1 is X0 + 1,
	assertion(flag(signal_handled, X1, X1)).

test(g_signal_emit_handler_block) :-
	flag(signal_handled, X0, X0),
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'void-params', sig_handler__succeed/2, {null}, HandlerId),
	g_signal_handler_block(Object, HandlerId),
	g_signal_emit(Object, 'void-params', {null}, []),
	assertion(flag(signal_handled, X0, X0)).

test(g_signal_emit_handler_unblock) :-
	flag(signal_handled, X0, X0),
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'void-params', sig_handler__succeed/2, {null}, HandlerId),
	g_signal_handler_block(Object, HandlerId),
	g_signal_handler_unblock(Object, HandlerId),
	g_signal_emit(Object, 'void-params', {null}, []),
	X1 is X0 + 1,
	assertion(flag(signal_handled, X1, X1)).

/* error conditions */
test(g_signal_emit_signame_instantiation_error, [throws(error(instantiation_error, _))]) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'void-params', sig_handler__succeed/2, {null}, _),
	g_signal_emit(Object, _, {null}, []).

test(g_signal_emit_signame_domain_error, [throws(error(domain_error('signal', _), _))]) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'void-params', sig_handler__succeed/2, {null}, _),
	g_signal_emit(Object, 'x', {null}, []).

test(g_signal_emit_signame_type_error, [throws(error(type_error('atom', _), _))]) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'void-params', sig_handler__succeed/2, {null}, _),
	g_signal_emit(Object, 0, {null}, []).

test(g_signal_emit_detail_instantiation_error, [throws(error(instantiation_error, _))]) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'void-params', sig_handler__succeed/2, {null}, _),
	g_signal_emit(Object, 'void-params', _, []).

test(g_signal_emit_signame_type_error, [throws(error(type_error('atom', _), _))]) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'void-params', sig_handler__succeed/2, {null}, _),
	g_signal_emit(Object, 'void-params', 0, []).

test(g_signal_emit_params_instantiation_error, [throws(error(instantiation_error, _))]) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'void-params', sig_handler__succeed/2, {null}, _),
	g_signal_emit(Object, 'void-params', {null}, _).

test(g_signal_emit_params_arity_error, [throws(error(plgi_error('Expected 0 args, received 1 args'), _))]) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'void-params', sig_handler__succeed/2, {null}, _),
	g_signal_emit(Object, 'void-params', {null}, ['x']).

test(g_signal_emit_param_instantiation_error, [throws(error(instantiation_error, _))]) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'inparam-boolean', sig_handler__succeed/2, {null}, _),
	g_signal_emit(Object, 'inparam-boolean', {null}, [_]).

test(g_signal_emit_param_type_error, [throws(error(type_error('boolean', _), _))]) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'inparam-boolean', sig_handler__succeed/2, {null}, _),
	g_signal_emit(Object, 'inparam-boolean', {null}, ['x']).

:- end_tests(plgi_signals_g_signal_emit).



/* void signal-handler parameters */
:- begin_tests(plgi_signals_void_param).

user:sig_handler__void_void(Object, UserData) :-
	g_object_type(Object, ObjectType),
	assertion(g_type_is_a(ObjectType, 'SignalTestsObject', true)),
	assertion(UserData == {null}),
	flag(signal_handled, X, X+1).

test(signals_void_param) :-
	flag(signal_handled, X0, X0),
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'void-params', sig_handler__void_void/2, {null}, _),
	g_signal_emit(Object, 'void-params', {null}, []),
	X1 is X0 + 1,
	assertion(flag(signal_handled, X1, X1)).

:- end_tests(plgi_signals_void_param).



/* return signal-handler parameters */
:- begin_tests(plgi_signals_return_param).

user:sig_handler_return_boolean(Object, UserData, Value) :-
	g_object_type(Object, ObjectType),
	assertion(g_type_is_a(ObjectType, 'SignalTestsObject', true)),
	assertion(UserData == {null}),
	Value = true.

user:sig_handler_return_integer(Object, UserData, Value) :-
	g_object_type(Object, ObjectType),
	assertion(g_type_is_a(ObjectType, 'SignalTestsObject', true)),
	assertion(UserData == {null}),
	Value = 1.

user:sig_handler_return_float(Object, UserData, Value) :-
	g_object_type(Object, ObjectType),
	assertion(g_type_is_a(ObjectType, 'SignalTestsObject', true)),
	assertion(UserData == {null}),
	Value = 1.0.

user:sig_handler_return_enum(Object, UserData, Value) :-
	g_object_type(Object, ObjectType),
	assertion(g_type_is_a(ObjectType, 'SignalTestsObject', true)),
	assertion(UserData == {null}),
	Value = 'SIGNAL_TESTS_ENUM_VALUE2'.

user:sig_handler_return_flags(Object, UserData, Value) :-
	g_object_type(Object, ObjectType),
	assertion(g_type_is_a(ObjectType, 'SignalTestsObject', true)),
	assertion(UserData == {null}),
	Value = ['SIGNAL_TESTS_FLAGS_VALUE2'].

user:sig_handler_return_string(Object, UserData, Value) :-
	g_object_type(Object, ObjectType),
	assertion(g_type_is_a(ObjectType, 'SignalTestsObject', true)),
	assertion(UserData == {null}),
	Value = 'const \u2665 utf8'.

user:sig_handler_return_param(Object, UserData, Value) :-
	g_object_type(Object, ObjectType),
	assertion(g_type_is_a(ObjectType, 'SignalTestsObject', true)),
	assertion(UserData == {null}),
	g_param_spec_string('myparam', 'param nick', 'param blurb', 'const \u2665 utf8', ['G_PARAM_READABLE'], Value).

user:sig_handler_return_boxed(Object, UserData, Value) :-
	g_object_type(Object, ObjectType),
	assertion(g_type_is_a(ObjectType, 'SignalTestsObject', true)),
	assertion(UserData == {null}),
	plgi_struct_new('SignalTestsBoxedStruct'( 'x'=42 ), Value).

/* FIXME: add return-pointer signal hander */

user:sig_handler_return_object(Object, UserData, Value) :-
	g_object_type(Object, ObjectType),
	assertion(g_type_is_a(ObjectType, 'SignalTestsObject', true)),
	assertion(UserData == {null}),
	g_object_new('SignalTestsObject', [], ReturnObject),
	Value = ReturnObject.

user:sig_handler_return_gtype(Object, UserData, Value) :-
	g_object_type(Object, ObjectType),
	assertion(g_type_is_a(ObjectType, 'SignalTestsObject', true)),
	assertion(UserData == {null}),
	Value = 'SignalTestsObject'.

user:sig_handler_return_variant(Object, UserData, Value) :-
	g_object_type(Object, ObjectType),
	assertion(g_type_is_a(ObjectType, 'SignalTestsObject', true)),
	assertion(UserData == {null}),
	g_variant_new_string('const \u2665 utf8', Value).

test(signals_return_boolean) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'return-boolean', sig_handler_return_boolean/3, {null}, _),
	g_signal_emit(Object, 'return-boolean', {null}, [Value]),
	assertion(Value == true).

test(signals_return_char) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'return-char', sig_handler_return_integer/3, {null}, _),
	g_signal_emit(Object, 'return-char', {null}, [Value]),
	assertion(Value == 1).

test(signals_return_uchar) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'return-uchar', sig_handler_return_integer/3, {null}, _),
	g_signal_emit(Object, 'return-uchar', {null}, [Value]),
	assertion(Value == 1).

test(signals_return_int) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'return-int', sig_handler_return_integer/3, {null}, _),
	g_signal_emit(Object, 'return-int', {null}, [Value]),
	assertion(Value == 1).

test(signals_return_uint) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'return-uint', sig_handler_return_integer/3, {null}, _),
	g_signal_emit(Object, 'return-uint', {null}, [Value]),
	assertion(Value == 1).

test(signals_return_long) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'return-long', sig_handler_return_integer/3, {null}, _),
	g_signal_emit(Object, 'return-long', {null}, [Value]),
	assertion(Value == 1).

test(signals_return_ulong) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'return-ulong', sig_handler_return_integer/3, {null}, _),
	g_signal_emit(Object, 'return-ulong', {null}, [Value]),
	assertion(Value == 1).

test(signals_return_int64) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'return-int64', sig_handler_return_integer/3, {null}, _),
	g_signal_emit(Object, 'return-int64', {null}, [Value]),
	assertion(Value == 1).

test(signals_return_uint64) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'return-uint64', sig_handler_return_integer/3, {null}, _),
	g_signal_emit(Object, 'return-uint64', {null}, [Value]),
	assertion(Value == 1).

test(signals_return_float) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'return-float', sig_handler_return_float/3, {null}, _),
	g_signal_emit(Object, 'return-float', {null}, [Value]),
	assertion(Value == 1.0).

test(signals_return_double) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'return-double', sig_handler_return_float/3, {null}, _),
	g_signal_emit(Object, 'return-double', {null}, [Value]),
	assertion(Value == 1.0).

test(signals_return_enum) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'return-enum', sig_handler_return_enum/3, {null}, _),
	g_signal_emit(Object, 'return-enum', {null}, [Value]),
	assertion(Value == 'SIGNAL_TESTS_ENUM_VALUE2').

test(signals_return_flags) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'return-flags', sig_handler_return_flags/3, {null}, _),
	g_signal_emit(Object, 'return-flags', {null}, [Value]),
	assertion(Value == ['SIGNAL_TESTS_FLAGS_VALUE2']).

test(signals_return_string) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'return-string', sig_handler_return_string/3, {null}, _),
	g_signal_emit(Object, 'return-string', {null}, [Value]),
	assertion(Value == 'const \u2665 utf8').

test(signals_return_param) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'return-param', sig_handler_return_param/3, {null}, _),
	g_signal_emit(Object, 'return-param', {null}, [Value]),
	g_param_spec_get_default_value(Value, DefaultValue),
	g_value_get_string(DefaultValue, String),
	assertion(String == 'const \u2665 utf8').

/* FIXME: this test assumes pass-by-value
test(signals_return_boxed) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'return-boxed', sig_handler_return_boxed/3, {null}, _),
	g_signal_emit(Object, 'return-boxed', {null}, [Value]),
	assertion(Value == 'const \u2665 utf8').
*/
/* FIXME: add return-pointer test */

test(signals_return_object) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'return-object', sig_handler_return_object/3, {null}, _),
	g_signal_emit(Object, 'return-object', {null}, [Value]),
	g_object_type(Value, ObjectType),
	assertion(g_type_is_a(ObjectType, 'SignalTestsObject', true)).

test(signals_return_gtype) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'return-gtype', sig_handler_return_gtype/3, {null}, _),
	g_signal_emit(Object, 'return-gtype', {null}, [Value]),
	assertion(Value == 'SignalTestsObject').

/* FIXME: this test assumes pass-by-value
test(signals_return_variant) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'return-variant', sig_handler_return_variant/3, {null}, _),
	g_signal_emit(Object, 'return-variant', {null}, [Value]),
	g_variant_get_string(Value, _, String),
	assertion(String == 'const \u2665 utf8').
*/
:- end_tests(plgi_signals_return_param).



/* in signal-handler parameters */
:- begin_tests(plgi_signals_in_param).

user:sig_handler_inparam_boolean(Object, Value, UserData) :-
	g_object_type(Object, ObjectType),
	assertion(g_type_is_a(ObjectType, 'SignalTestsObject', true)),
	assertion(Value == true),
	assertion(UserData == {null}),
	flag(signal_handled, X, X+1).

user:sig_handler_inparam_integer(Object, Value, UserData) :-
	g_object_type(Object, ObjectType),
	assertion(g_type_is_a(ObjectType, 'SignalTestsObject', true)),
	assertion(Value == 1),
	assertion(UserData == {null}),
	flag(signal_handled, X, X+1).

user:sig_handler_inparam_float(Object, Value, UserData) :-
	g_object_type(Object, ObjectType),
	assertion(g_type_is_a(ObjectType, 'SignalTestsObject', true)),
	assertion(Value == 1.0),
	assertion(UserData == {null}),
	flag(signal_handled, X, X+1).

user:sig_handler_inparam_enum(Object, Value, UserData) :-
	g_object_type(Object, ObjectType),
	assertion(g_type_is_a(ObjectType, 'SignalTestsObject', true)),
	assertion(Value == 'SIGNAL_TESTS_ENUM_VALUE2'),
	assertion(UserData == {null}),
	flag(signal_handled, X, X+1).

user:sig_handler_inparam_flags(Object, Value, UserData) :-
	g_object_type(Object, ObjectType),
	assertion(g_type_is_a(ObjectType, 'SignalTestsObject', true)),
	assertion(Value == ['SIGNAL_TESTS_FLAGS_VALUE2']),
	assertion(UserData == {null}),
	flag(signal_handled, X, X+1).

user:sig_handler_inparam_string(Object, Value, UserData) :-
	g_object_type(Object, ObjectType),
	assertion(g_type_is_a(ObjectType, 'SignalTestsObject', true)),
	assertion(Value == 'const \u2665 utf8'),
	assertion(UserData == {null}),
	flag(signal_handled, X, X+1).

user:sig_handler_inparam_param(Object, Value, UserData) :-
	g_object_type(Object, ObjectType),
	assertion(g_type_is_a(ObjectType, 'SignalTestsObject', true)),
	g_param_spec_get_name(Value, Name),
	assertion(Name == 'myparam'),
	g_param_spec_get_nick(Value, Nick),
	assertion(Nick == 'param nick'),
	g_param_spec_get_blurb(Value, Blurb),
	assertion(Blurb == 'param blurb'),
	g_param_spec_get_default_value(Value, DefaultValue),
	g_value_get_string(DefaultValue, String),
	assertion(String == 'const \u2665 utf8'),
	g_param_spec_value_type(Value, ValueType),
	assertion(ValueType == 'gchararray'),
	assertion(UserData == {null}),
	flag(signal_handled, X, X+1).

user:sig_handler_inparam_boxed(Object, Value, UserData) :-
	g_object_type(Object, ObjectType),
	assertion(g_type_is_a(ObjectType, 'SignalTestsObject', true)),
	plgi_struct_term(Value, StructTerm),
	assertion(StructTerm == 'SignalTestsBoxedStruct'( 'x'=42 )),
	assertion(UserData == {null}),
	flag(signal_handled, X, X+1).

user:sig_handler_inparam_object(Object, Value, UserData) :-
	g_object_type(Object, ObjectType),
	assertion(g_type_is_a(ObjectType, 'SignalTestsObject', true)),
	g_object_type(Value, ObjectType),
	assertion(g_type_is_a(ObjectType, 'SignalTestsObject', true)),
	assertion(UserData == {null}),
	flag(signal_handled, X, X+1).

user:sig_handler_inparam_gtype(Object, Value, UserData) :-
	g_object_type(Object, ObjectType),
	assertion(g_type_is_a(ObjectType, 'SignalTestsObject', true)),
	assertion(Value == 'SignalTestsObject'),
	assertion(UserData == {null}),
	flag(signal_handled, X, X+1).

user:sig_handler_inparam_variant(Object, Value, UserData) :-
	g_object_type(Object, ObjectType),
	assertion(g_type_is_a(ObjectType, 'SignalTestsObject', true)),
	g_variant_get_string(Value, _, String),
	assertion(String == 'const \u2665 utf8'),
	assertion(UserData == {null}),
	flag(signal_handled, X, X+1).

test(signals_inparam_gboolean) :-
	flag(signal_handled, X0, X0),
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'inparam-boolean', sig_handler_inparam_boolean/3, {null}, _),
	g_signal_emit(Object, 'inparam-boolean', {null}, [true]),
	X1 is X0 + 1,
	assertion(flag(signal_handled, X1, X1)).

test(signals_inparam_char) :-
	flag(signal_handled, X0, X0),
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'inparam-char', sig_handler_inparam_integer/3, {null}, _),
	g_signal_emit(Object, 'inparam-char', {null}, [1]),
	X1 is X0 + 1,
	assertion(flag(signal_handled, X1, X1)).

test(signals_inparam_uchar) :-
	flag(signal_handled, X0, X0),
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'inparam-uchar', sig_handler_inparam_integer/3, {null}, _),
	g_signal_emit(Object, 'inparam-uchar', {null}, [1]),
	X1 is X0 + 1,
	assertion(flag(signal_handled, X1, X1)).

test(signals_inparam_int) :-
	flag(signal_handled, X0, X0),
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'inparam-int', sig_handler_inparam_integer/3, {null}, _),
	g_signal_emit(Object, 'inparam-int', {null}, [1]),
	X1 is X0 + 1,
	assertion(flag(signal_handled, X1, X1)).

test(signals_inparam_uint) :-
	flag(signal_handled, X0, X0),
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'inparam-uint', sig_handler_inparam_integer/3, {null}, _),
	g_signal_emit(Object, 'inparam-uint', {null}, [1]),
	X1 is X0 + 1,
	assertion(flag(signal_handled, X1, X1)).

test(signals_inparam_long) :-
	flag(signal_handled, X0, X0),
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'inparam-long', sig_handler_inparam_integer/3, {null}, _),
	g_signal_emit(Object, 'inparam-long', {null}, [1]),
	X1 is X0 + 1,
	assertion(flag(signal_handled, X1, X1)).

test(signals_inparam_ulong) :-
	flag(signal_handled, X0, X0),
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'inparam-ulong', sig_handler_inparam_integer/3, {null}, _),
	g_signal_emit(Object, 'inparam-ulong', {null}, [1]),
	X1 is X0 + 1,
	assertion(flag(signal_handled, X1, X1)).

test(signals_inparam_int64) :-
	flag(signal_handled, X0, X0),
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'inparam-int64', sig_handler_inparam_integer/3, {null}, _),
	g_signal_emit(Object, 'inparam-int64', {null}, [1]),
	X1 is X0 + 1,
	assertion(flag(signal_handled, X1, X1)).

test(signals_inparam_uint64) :-
	flag(signal_handled, X0, X0),
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'inparam-uint64', sig_handler_inparam_integer/3, {null}, _),
	g_signal_emit(Object, 'inparam-uint64', {null}, [1]),
	X1 is X0 + 1,
	assertion(flag(signal_handled, X1, X1)).

test(signals_inparam_float) :-
	flag(signal_handled, X0, X0),
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'inparam-float', sig_handler_inparam_float/3, {null}, _),
	g_signal_emit(Object, 'inparam-float', {null}, [1.0]),
	X1 is X0 + 1,
	assertion(flag(signal_handled, X1, X1)).

test(signals_inparam_double) :-
	flag(signal_handled, X0, X0),
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'inparam-double', sig_handler_inparam_float/3, {null}, _),
	g_signal_emit(Object, 'inparam-double', {null}, [1.0]),
	X1 is X0 + 1,
	assertion(flag(signal_handled, X1, X1)).

test(signals_inparam_enum) :-
	flag(signal_handled, X0, X0),
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'inparam-enum', sig_handler_inparam_enum/3, {null}, _),
	g_signal_emit(Object, 'inparam-enum', {null}, ['SIGNAL_TESTS_ENUM_VALUE2']),
	X1 is X0 + 1,
	assertion(flag(signal_handled, X1, X1)).

test(signals_inparam_flags) :-
	flag(signal_handled, X0, X0),
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'inparam-flags', sig_handler_inparam_flags/3, {null}, _),
	g_signal_emit(Object, 'inparam-flags', {null}, [['SIGNAL_TESTS_FLAGS_VALUE2']]),
	X1 is X0 + 1,
	assertion(flag(signal_handled, X1, X1)).

test(signals_inparam_string) :-
	flag(signal_handled, X0, X0),
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'inparam-string', sig_handler_inparam_string/3, {null}, _),
	g_signal_emit(Object, 'inparam-string', {null}, ['const \u2665 utf8']),
	X1 is X0 + 1,
	assertion(flag(signal_handled, X1, X1)).

test(signals_inparam_param) :-
	flag(signal_handled, X0, X0),
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'inparam-param', sig_handler_inparam_param/3, {null}, _),
	g_param_spec_string('myparam', 'param nick', 'param blurb', 'const \u2665 utf8', ['G_PARAM_READABLE'], Value),
	g_signal_emit(Object, 'inparam-param', {null}, [Value]),
	X1 is X0 + 1,
	assertion(flag(signal_handled, X1, X1)).

/* FIXME: this test assumes pass-by-value
test(signals_inparam_boxed) :-
	flag(signal_handled, X0, X0),
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'inparam-boxed', sig_handler_inparam_boxed/3, {null}, _),
	plgi_struct_new('SignalTestsBoxedStruct'( 'x'=42 ), Value),
	g_signal_emit(Object, 'inparam-boxed', {null}, [Value]),
	X1 is X0 + 1,
	assertion(flag(signal_handled, X1, X1)).
*/
/* FIXME: add inparam-pointer test */

test(signals_inparam_object) :-
	flag(signal_handled, X0, X0),
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'inparam-object', sig_handler_inparam_object/3, {null}, _),
	g_signal_emit(Object, 'inparam-object', {null}, [Object]),
	X1 is X0 + 1,
	assertion(flag(signal_handled, X1, X1)).

test(signals_inparam_gtype) :-
	flag(signal_handled, X0, X0),
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'inparam-gtype', sig_handler_inparam_gtype/3, {null}, _),
	g_signal_emit(Object, 'inparam-gtype', {null}, ['SignalTestsObject']),
	X1 is X0 + 1,
	assertion(flag(signal_handled, X1, X1)).

/* FIXME: this test assumes pass-by-value
test(signals_inparam_variant) :-
	flag(signal_handled, X0, X0),
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'inparam-variant', sig_handler_inparam_variant/3, {null}, _),
	g_variant_new_string('const \u2665 utf8', Value),
	g_signal_emit(Object, 'inparam-variant', {null}, [Value]),
	X1 is X0 + 1,
	assertion(flag(signal_handled, X1, X1)).
*/

:- end_tests(plgi_signals_in_param).



/* out signal-handler parameters */
:- begin_tests(plgi_signals_out_param).

user:sig_handler_outparam_boolean(Object, Value, UserData) :-
	g_object_type(Object, ObjectType),
	assertion(g_type_is_a(ObjectType, 'SignalTestsObject', true)),
	assertion(UserData == {null}),
	Value = true.

user:sig_handler_outparam_integer(Object, Value, UserData) :-
	g_object_type(Object, ObjectType),
	assertion(g_type_is_a(ObjectType, 'SignalTestsObject', true)),
	assertion(UserData == {null}),
	Value = 1.

user:sig_handler_outparam_float(Object, Value, UserData) :-
	g_object_type(Object, ObjectType),
	assertion(g_type_is_a(ObjectType, 'SignalTestsObject', true)),
	assertion(UserData == {null}),
	Value = 1.0.

user:sig_handler_outparam_enum(Object, Value, UserData) :-
	g_object_type(Object, ObjectType),
	assertion(g_type_is_a(ObjectType, 'SignalTestsObject', true)),
	assertion(UserData == {null}),
	Value = 'SIGNAL_TESTS_ENUM_VALUE2'.

user:sig_handler_outparam_flags(Object, Value, UserData) :-
	g_object_type(Object, ObjectType),
	assertion(g_type_is_a(ObjectType, 'SignalTestsObject', true)),
	assertion(UserData == {null}),
	Value = ['SIGNAL_TESTS_FLAGS_VALUE2'].

user:sig_handler_outparam_string(Object, Value, UserData) :-
	g_object_type(Object, ObjectType),
	assertion(g_type_is_a(ObjectType, 'SignalTestsObject', true)),
	assertion(UserData == {null}),
	Value = 'const \u2665 utf8'.

user:sig_handler_outparam_param(Object, Value, UserData) :-
	g_object_type(Object, ObjectType),
	assertion(g_type_is_a(ObjectType, 'SignalTestsObject', true)),
	assertion(UserData == {null}),
	g_param_spec_string('myparam', 'param nick', 'param blurb', 'const \u2665 utf8', ['G_PARAM_READABLE'], Value).

user:sig_handler_outparam_boxed(Object, Value, UserData) :-
	g_object_type(Object, ObjectType),
	assertion(g_type_is_a(ObjectType, 'SignalTestsObject', true)),
	assertion(UserData == {null}),
	plgi_struct_new('SignalTestsBoxedStruct'( 'x'=42 ), Value).

/* FIXME: add return-pointer signal hander */

user:sig_handler_outparam_object(Object, Value, UserData) :-
	g_object_type(Object, ObjectType),
	assertion(g_type_is_a(ObjectType, 'SignalTestsObject', true)),
	assertion(UserData == {null}),
	g_object_new('SignalTestsObject', [], OutObject),
	Value = OutObject.

user:sig_handler_outparam_gtype(Object, Value, UserData) :-
	g_object_type(Object, ObjectType),
	assertion(g_type_is_a(ObjectType, 'SignalTestsObject', true)),
	assertion(UserData == {null}),
	Value = 'SignalTestsObject'.

user:sig_handler_outparam_variant(Object, Value, UserData) :-
	g_object_type(Object, ObjectType),
	assertion(g_type_is_a(ObjectType, 'SignalTestsObject', true)),
	assertion(UserData == {null}),
	g_variant_new_string('const \u2665 utf8', Value).

test(signals_outparam_gboolean) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'outparam-boolean', sig_handler_outparam_boolean/3, {null}, _),
	g_signal_emit(Object, 'outparam-boolean', {null}, [Value]),
	assertion(Value == true).

test(signals_outparam_char) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'outparam-char', sig_handler_outparam_integer/3, {null}, _),
	g_signal_emit(Object, 'outparam-char', {null}, [Value]),
	assertion(Value == 1).

test(signals_outparam_uchar) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'outparam-uchar', sig_handler_outparam_integer/3, {null}, _),
	g_signal_emit(Object, 'outparam-uchar', {null}, [Value]),
	assertion(Value == 1).

test(signals_outparam_int) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'outparam-int', sig_handler_outparam_integer/3, {null}, _),
	g_signal_emit(Object, 'outparam-int', {null}, [Value]),
	assertion(Value == 1).

test(signals_outparam_uint) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'outparam-uint', sig_handler_outparam_integer/3, {null}, _),
	g_signal_emit(Object, 'outparam-uint', {null}, [Value]),
	assertion(Value == 1).

test(signals_outparam_long) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'outparam-long', sig_handler_outparam_integer/3, {null}, _),
	g_signal_emit(Object, 'outparam-long', {null}, [Value]),
	assertion(Value == 1).

test(signals_outparam_ulong) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'outparam-ulong', sig_handler_outparam_integer/3, {null}, _),
	g_signal_emit(Object, 'outparam-ulong', {null}, [Value]),
	assertion(Value == 1).

test(signals_outparam_int64) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'outparam-int64', sig_handler_outparam_integer/3, {null}, _),
	g_signal_emit(Object, 'outparam-int64', {null}, [Value]),
	assertion(Value == 1).

test(signals_outparam_uint64) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'outparam-uint64', sig_handler_outparam_integer/3, {null}, _),
	g_signal_emit(Object, 'outparam-uint64', {null}, [Value]),
	assertion(Value == 1).

test(signals_outparam_float) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'outparam-float', sig_handler_outparam_float/3, {null}, _),
	g_signal_emit(Object, 'outparam-float', {null}, [Value]),
	assertion(Value == 1.0).

test(signals_outparam_double) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'outparam-double', sig_handler_outparam_float/3, {null}, _),
	g_signal_emit(Object, 'outparam-double', {null}, [Value]),
	assertion(Value == 1.0).

test(signals_outparam_enum) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'outparam-enum', sig_handler_outparam_enum/3, {null}, _),
	g_signal_emit(Object, 'outparam-enum', {null}, [Value]),
	assertion(Value == 'SIGNAL_TESTS_ENUM_VALUE2').

test(signals_outparam_flags) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'outparam-flags', sig_handler_outparam_flags/3, {null}, _),
	g_signal_emit(Object, 'outparam-flags', {null}, [Value]),
	assertion(Value == ['SIGNAL_TESTS_FLAGS_VALUE2']).

test(signals_outparam_string) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'outparam-string', sig_handler_outparam_string/3, {null}, _),
	g_signal_emit(Object, 'outparam-string', {null}, [Value]),
	assertion(Value == 'const \u2665 utf8').

test(signals_outparam_param) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'outparam-param', sig_handler_outparam_param/3, {null}, _),
	g_signal_emit(Object, 'outparam-param', {null}, [Value]),
	g_param_spec_get_default_value(Value, DefaultValue),
	g_value_get_string(DefaultValue, String),
	assertion(String == 'const \u2665 utf8').

/* FIXME: this test assumes pass-by-value
test(signals_outparam_boxed) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'outparam-boxed', sig_handler_outparam_boxed/3, {null}, _),
	g_signal_emit(Object, 'outparam-boxed', {null}, [Value]),
	assertion(Value == 'const \u2665 utf8').
*/
/* FIXME: add outparam-pointer test */

test(signals_outparam_object) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'outparam-object', sig_handler_outparam_object/3, {null}, _),
	g_signal_emit(Object, 'outparam-object', {null}, [Value]),
	g_object_type(Value, ObjectType),
	assertion(g_type_is_a(ObjectType, 'SignalTestsObject', true)).

test(signals_outparam_gtype) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'outparam-gtype', sig_handler_outparam_gtype/3, {null}, _),
	g_signal_emit(Object, 'outparam-gtype', {null}, [Value]),
	assertion(Value == 'SignalTestsObject').

/* FIXME: this test assumes pass-by-value
test(signals_outparam_variant) :-
	g_object_new('SignalTestsObject', [], Object),
	g_signal_connect(Object, 'outparam-variant', sig_handler_outparam_variant/3, {null}, _),
	g_signal_emit(Object, 'outparam-variant', {null}, [Value]),
	g_variant_get_string(Value, _, String),
	assertion(String == 'const \u2665 utf8').
*/

:- end_tests(plgi_signals_out_param).

/* FIXME: test boolean retval with (out) arg. Will out arg be bound? */
