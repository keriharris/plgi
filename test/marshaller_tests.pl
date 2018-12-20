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

:- plgi_use_namespace_from_dir('GIMarshallingTests', '.').
:- plgi_use_namespace('GObject').



/* gboolean */
:- begin_tests(plgi_marshaller_boolean).

test(gi_marshalling_tests_boolean_return_true) :-
	gi_marshalling_tests_boolean_return_true(Value),
	assertion(Value == true).

test(gi_marshalling_tests_boolean_return_false) :-
	gi_marshalling_tests_boolean_return_false(Value),
	assertion(Value == false).

test(gi_marshalling_tests_boolean_in_true) :-
	gi_marshalling_tests_boolean_in_true(true).

test(gi_marshalling_tests_boolean_in_false) :-
	gi_marshalling_tests_boolean_in_false(false).

test(gi_marshalling_tests_boolean_out_true) :-
	gi_marshalling_tests_boolean_out_true(Value),
	assertion(Value == true).

test(gi_marshalling_tests_boolean_out_false) :-
	gi_marshalling_tests_boolean_out_false(Value),
	assertion(Value == false).

test(gi_marshalling_tests_boolean_inout_true_false) :-
	gi_marshalling_tests_boolean_inout_true_false(true, Value),
	assertion(Value == false).

test(gi_marshalling_tests_boolean_inout_false_true) :-
	gi_marshalling_tests_boolean_inout_false_true(false, Value),
	assertion(Value == true).

/* error conditions */
test(gi_marshalling_tests_boolean_instantiation_error, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_boolean_in_true(_).

test(gi_marshalling_tests_boolean_type_error, [throws(error(type_error(boolean, _), _))]) :-
	gi_marshalling_tests_boolean_in_true('x').

test(gi_marshalling_tests_boolean_binding_failure, [fail]) :-
	gi_marshalling_tests_boolean_out_true('x').

:- end_tests(plgi_marshaller_boolean).



/* gint8 */
:- begin_tests(plgi_marshaller_int8).

test(gi_marshalling_tests_int8_return_max) :-
	gi_marshalling_tests_int8_return_max(Value),
	assertion(Value == 0x7F).

test(gi_marshalling_tests_int8_return_min) :-
	gi_marshalling_tests_int8_return_min(Value),
	assertion(Value == -0x80).

test(gi_marshalling_tests_int8_in_max) :-
	gi_marshalling_tests_int8_in_max(0x7F).

test(gi_marshalling_tests_int8_in_min) :-
	gi_marshalling_tests_int8_in_min(-0x80).

test(gi_marshalling_tests_int8_out_max) :-
	gi_marshalling_tests_int8_out_max(Value),
	assertion(Value == 0x7F).

test(gi_marshalling_tests_int8_out_min) :-
	gi_marshalling_tests_int8_out_min(Value),
	assertion(Value == -0x80).

test(gi_marshalling_tests_int8_inout_max_min) :-
	gi_marshalling_tests_int8_inout_max_min(0x7F, Value),
	assertion(Value == -0x80).

test(gi_marshalling_tests_int8_inout_min_max) :-
	gi_marshalling_tests_int8_inout_min_max(-0x80, Value),
	assertion(Value == 0x7F).

/* error conditions */
test(gi_marshalling_tests_int8_instantiation_error, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_int8_in_max(_).

test(gi_marshalling_tests_int8_overflow_error, [throws(error(type_error('8 bit integer', _), _))]) :-
	gi_marshalling_tests_int8_in_max(0x80).

test(gi_marshalling_tests_int8_underflow_error, [throws(error(type_error('8 bit integer', _), _))]) :-
	gi_marshalling_tests_int8_in_max(-0x81).

test(gi_marshalling_tests_int8_type_error, [throws(error(type_error('8 bit integer', _), _))]) :-
	gi_marshalling_tests_int8_in_max('x').

test(gi_marshalling_tests_int8_binding_failure, [fail]) :-
	gi_marshalling_tests_int8_out_max('x').

:- end_tests(plgi_marshaller_int8).



/* guint8 */
:- begin_tests(plgi_marshaller_uint8).

test(gi_marshalling_tests_uint8_return) :-
	gi_marshalling_tests_uint8_return(Value),
	assertion(Value == 0xFF).

test(gi_marshalling_tests_uint8_in) :-
	gi_marshalling_tests_uint8_in(0xFF).

test(gi_marshalling_tests_uint8_out) :-
	gi_marshalling_tests_uint8_out(Value),
	assertion(Value == 0xFF).

test(gi_marshalling_tests_uint8_inout) :-
	gi_marshalling_tests_uint8_inout(0xFF, Value),
	assertion(Value == 0).

/* error conditions */
test(gi_marshalling_tests_int8_instantiation_error, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_uint8_in(_).

test(gi_marshalling_tests_uint8_overflow_error, [throws(error(type_error('8 bit unsigned integer', _), _))]) :-
	gi_marshalling_tests_uint8_in(0x100).

test(gi_marshalling_tests_uint8_underflow_error, [throws(error(type_error('8 bit unsigned integer', _), _))]) :-
	gi_marshalling_tests_uint8_in(-0x1).

test(gi_marshalling_tests_uint8_type_error, [throws(error(type_error('8 bit unsigned integer', _), _))]) :-
	gi_marshalling_tests_uint8_in('x').

test(gi_marshalling_tests_uint8_binding_failure, [fail]) :-
	gi_marshalling_tests_uint8_out('x').

:- end_tests(plgi_marshaller_uint8).



/* gint16 */
:- begin_tests(plgi_marshaller_int16).

test(gi_marshalling_tests_int16_return_max) :-
	gi_marshalling_tests_int16_return_max(Value),
	assertion(Value == 0x7FFF).

test(gi_marshalling_tests_int16_return_min) :-
	gi_marshalling_tests_int16_return_min(Value),
	assertion(Value == -0x8000).

test(gi_marshalling_tests_int16_in_max) :-
	gi_marshalling_tests_int16_in_max(0x7FFF).

test(gi_marshalling_tests_int16_in_min) :-
	gi_marshalling_tests_int16_in_min(-0x8000).

test(gi_marshalling_tests_int16_out_max) :-
	gi_marshalling_tests_int16_out_max(Value),
	assertion(Value == 0x7FFF).

test(gi_marshalling_tests_int16_out_min) :-
	gi_marshalling_tests_int16_out_min(Value),
	assertion(Value == -0x8000).

test(gi_marshalling_tests_int16_inout_max_min) :-
	gi_marshalling_tests_int16_inout_max_min(0x7FFF, Value),
	assertion(Value == -0x8000).

test(gi_marshalling_tests_int16_inout_min_max) :-
	gi_marshalling_tests_int16_inout_min_max(-0x8000, Value),
	assertion(Value == 0x7FFF).

/* error conditions */
test(gi_marshalling_tests_int16_instantiation_error, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_int16_in_max(_).

test(gi_marshalling_tests_int16_overflow_error, [throws(error(type_error('16 bit integer', _), _))]) :-
	gi_marshalling_tests_int16_in_max(0x8000).

test(gi_marshalling_tests_int16_underflow_error, [throws(error(type_error('16 bit integer', _), _))]) :-
	gi_marshalling_tests_int16_in_max(-0x8001).

test(gi_marshalling_tests_int16_type_error, [throws(error(type_error('16 bit integer', _), _))]) :-
	gi_marshalling_tests_int16_in_max('x').

test(gi_marshalling_tests_int16_binding_failure, [fail]) :-
	gi_marshalling_tests_int16_out_max('x').

:- end_tests(plgi_marshaller_int16).



/* guint16 */
:- begin_tests(plgi_marshaller_uint16).

test(gi_marshalling_tests_uint16_return) :-
	gi_marshalling_tests_uint16_return(Value),
	assertion(Value == 0xFFFF).

test(gi_marshalling_tests_uint16_in) :-
	gi_marshalling_tests_uint16_in(0xFFFF).

test(gi_marshalling_tests_uint16_out) :-
	gi_marshalling_tests_uint16_out(Value),
	assertion(Value == 0xFFFF).

test(gi_marshalling_tests_uint16_inout) :-
	gi_marshalling_tests_uint16_inout(0xFFFF, Value),
	assertion(Value == 0).

/* error conditions */
test(gi_marshalling_tests_uint16_instantiation_error, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_uint16_in(_).

test(gi_marshalling_tests_uint16_overflow_error, [throws(error(type_error('16 bit unsigned integer', _), _))]) :-
	gi_marshalling_tests_uint16_in(0x10000).

test(gi_marshalling_tests_uint16_underflow_error, [throws(error(type_error('16 bit unsigned integer', _), _))]) :-
	gi_marshalling_tests_uint16_in(-0x1).

test(gi_marshalling_tests_uint16_type_error, [throws(error(type_error('16 bit unsigned integer', _), _))]) :-
	gi_marshalling_tests_uint16_in('x').

test(gi_marshalling_tests_uint16_binding_failure, [fail]) :-
	gi_marshalling_tests_uint16_out('x').

:- end_tests(plgi_marshaller_uint16).



/* gint32 */
:- begin_tests(plgi_marshaller_int32).

test(gi_marshalling_tests_int32_return_max) :-
	gi_marshalling_tests_int32_return_max(Value),
	assertion(Value == 0x7FFFFFFF).

test(gi_marshalling_tests_int32_return_min) :-
	gi_marshalling_tests_int32_return_min(Value),
	assertion(Value == -0x80000000).

test(gi_marshalling_tests_int32_in_max) :-
	gi_marshalling_tests_int32_in_max(0x7FFFFFFF).

test(gi_marshalling_tests_int32_in_min) :-
	gi_marshalling_tests_int32_in_min(-0x80000000).

test(gi_marshalling_tests_int32_out_max) :-
	gi_marshalling_tests_int32_out_max(Value),
	assertion(Value == 0x7FFFFFFF).

test(gi_marshalling_tests_int32_out_min) :-
	gi_marshalling_tests_int32_out_min(Value),
	assertion(Value == -0x80000000).

test(gi_marshalling_tests_int32_inout_max_min) :-
	gi_marshalling_tests_int32_inout_max_min(0x7FFFFFFF, Value),
	assertion(Value == -0x80000000).

test(gi_marshalling_tests_int32_inout_min_max) :-
	gi_marshalling_tests_int32_inout_min_max(-0x80000000, Value),
	assertion(Value == 0x7FFFFFFF).

/* error conditions */
test(gi_marshalling_tests_int32_instantiation_error, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_int32_in_max(_).

test(gi_marshalling_tests_int32_overflow_error, [throws(error(type_error('32 bit integer', _), _))]) :-
	gi_marshalling_tests_int32_in_max(0x80000000).

test(gi_marshalling_tests_int32_underflow_error, [throws(error(type_error('32 bit integer', _), _))]) :-
	gi_marshalling_tests_int32_in_max(-0x80000001).

test(gi_marshalling_tests_int32_type_error, [throws(error(type_error('32 bit integer', _), _))]) :-
	gi_marshalling_tests_int32_in_max('x').

test(gi_marshalling_tests_int32_binding_failure, [fail]) :-
	gi_marshalling_tests_int32_out_max('x').

:- end_tests(plgi_marshaller_int32).



/* guint32 */
:- begin_tests(plgi_marshaller_uint32).

test(gi_marshalling_tests_uint32_return) :-
	gi_marshalling_tests_uint32_return(Value),
	assertion(Value == 0xFFFFFFFF).

test(gi_marshalling_tests_uint32_in) :-
	gi_marshalling_tests_uint32_in(0xFFFFFFFF).

test(gi_marshalling_tests_uint32_out) :-
	gi_marshalling_tests_uint32_out(Value),
	assertion(Value == 0xFFFFFFFF).

test(gi_marshalling_tests_uint32_inout) :-
	gi_marshalling_tests_uint32_inout(0xFFFFFFFF, Value),
	assertion(Value == 0).

/* error conditions */
test(gi_marshalling_tests_uint32_instantiation_error, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_uint32_in(_).

test(gi_marshalling_tests_uint32_overflow_error, [throws(error(type_error('32 bit unsigned integer', _), _))]) :-
	gi_marshalling_tests_uint32_in(0x100000000).

test(gi_marshalling_tests_uint32_underflow_error, [throws(error(type_error('32 bit unsigned integer', _), _))]) :-
	gi_marshalling_tests_uint32_in(-0x1).

test(gi_marshalling_tests_uint32_type_error, [throws(error(type_error('32 bit unsigned integer', _), _))]) :-
	gi_marshalling_tests_uint32_in('x').

test(gi_marshalling_tests_uint32_binding_failure, [fail]) :-
	gi_marshalling_tests_uint32_out('x').

:- end_tests(plgi_marshaller_uint32).



/* gint64 */
:- begin_tests(plgi_marshaller_int64).

test(gi_marshalling_tests_int64_return_max) :-
	gi_marshalling_tests_int64_return_max(Value),
	assertion(Value == 0x7FFFFFFFFFFFFFFF).

test(gi_marshalling_tests_int64_return_min) :-
	gi_marshalling_tests_int64_return_min(Value),
	assertion(Value == -0x8000000000000000).

test(gi_marshalling_tests_int64_in_max) :-
	gi_marshalling_tests_int64_in_max(0x7FFFFFFFFFFFFFFF).

test(gi_marshalling_tests_int64_in_min) :-
	gi_marshalling_tests_int64_in_min(-0x8000000000000000).

test(gi_marshalling_tests_int64_out_max) :-
	gi_marshalling_tests_int64_out_max(Value),
	assertion(Value == 0x7FFFFFFFFFFFFFFF).

test(gi_marshalling_tests_int64_out_min) :-
	gi_marshalling_tests_int64_out_min(Value),
	assertion(Value == -0x8000000000000000).

test(gi_marshalling_tests_int64_inout_max_min) :-
	gi_marshalling_tests_int64_inout_max_min(0x7FFFFFFFFFFFFFFF, Value),
	assertion(Value == -0x8000000000000000).

test(gi_marshalling_tests_int64_inout_min_max) :-
	gi_marshalling_tests_int64_inout_min_max(-0x8000000000000000, Value),
	assertion(Value == 0x7FFFFFFFFFFFFFFF).

/* error conditions */
test(gi_marshalling_tests_int64_instantiation_error, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_int64_in_max(_).

test(gi_marshalling_tests_int64_overflow_error, [throws(error(type_error('64 bit integer', _), _))]) :-
	gi_marshalling_tests_int64_in_max(0x8000000000000000).

test(gi_marshalling_tests_int64_underflow_error, [throws(error(type_error('64 bit integer', _), _))]) :-
	gi_marshalling_tests_int64_in_max(-0x8000000000000001).

test(gi_marshalling_tests_int64_type_error, [throws(error(type_error('64 bit integer', _), _))]) :-
	gi_marshalling_tests_int64_in_max('x').

test(gi_marshalling_tests_int64_binding_failure, [fail]) :-
	gi_marshalling_tests_int64_out_max('x').

:- end_tests(plgi_marshaller_int64).



/* guint64 */
:- begin_tests(plgi_marshaller_uint64).

test(gi_marshalling_tests_uint64_return) :-
	gi_marshalling_tests_uint64_return(Value),
	assertion(Value == 0xFFFFFFFFFFFFFFFF).

test(gi_marshalling_tests_uint64_in) :-
	gi_marshalling_tests_uint64_in(0xFFFFFFFFFFFFFFFF).

test(gi_marshalling_tests_uint64_out) :-
	gi_marshalling_tests_uint64_out(Value),
	assertion(Value == 0xFFFFFFFFFFFFFFFF).

test(gi_marshalling_tests_uint64_inout) :-
	gi_marshalling_tests_uint64_inout(0xFFFFFFFFFFFFFFFF, Value),
	assertion(Value == 0).

/* error conditions */
test(gi_marshalling_tests_uint64_instantiation_error, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_uint64_in(_).

test(gi_marshalling_tests_uint64_overflow_error, [throws(error(type_error('64 bit unsigned integer', _), _))]) :-
	gi_marshalling_tests_uint64_in(0x10000000000000000).

test(gi_marshalling_tests_uint64_underflow_error, [throws(error(type_error('64 bit unsigned integer', _), _))]) :-
	gi_marshalling_tests_uint64_in(-0x1).

test(gi_marshalling_tests_uint64_type_error, [throws(error(type_error('64 bit unsigned integer', _), _))]) :-
	gi_marshalling_tests_uint64_in('x').

test(gi_marshalling_tests_uint64_binding_failure, [fail]) :-
	gi_marshalling_tests_uint64_out('x').

:- end_tests(plgi_marshaller_uint64).



/* gshort */
:- begin_tests(plgi_marshaller_short).

test(gi_marshalling_tests_short_return_max) :-
	gi_marshalling_tests_short_return_max(Value),
	assertion(Value == 0x7FFF).

test(gi_marshalling_tests_short_return_min) :-
	gi_marshalling_tests_short_return_min(Value),
	assertion(Value == -0x8000).

test(gi_marshalling_tests_short_in_max) :-
	gi_marshalling_tests_short_in_max(0x7FFF).

test(gi_marshalling_tests_short_in_min) :-
	gi_marshalling_tests_short_in_min(-0x8000).

test(gi_marshalling_tests_short_out_max) :-
	gi_marshalling_tests_short_out_max(Value),
	assertion(Value == 0x7FFF).

test(gi_marshalling_tests_short_out_min) :-
	gi_marshalling_tests_short_out_min(Value),
	assertion(Value == -0x8000).

test(gi_marshalling_tests_short_inout_max_min) :-
	gi_marshalling_tests_short_inout_max_min(0x7FFF, Value),
	assertion(Value == -0x8000).

test(gi_marshalling_tests_short_inout_min_max) :-
	gi_marshalling_tests_short_inout_min_max(-0x8000, Value),
	assertion(Value == 0x7FFF).

/* error conditions */
test(gi_marshalling_tests_short_instantiation_error, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_short_in_max(_).

test(gi_marshalling_tests_short_overflow_error, [throws(error(type_error('16 bit integer', _), _))]) :-
	gi_marshalling_tests_short_in_max(0x8000).

test(gi_marshalling_tests_short_underflow_error, [throws(error(type_error('16 bit integer', _), _))]) :-
	gi_marshalling_tests_short_in_max(-0x8001).

test(gi_marshalling_tests_short_type_error, [throws(error(type_error('16 bit integer', _), _))]) :-
	gi_marshalling_tests_short_in_max('x').

test(gi_marshalling_tests_short_binding_failure, [fail]) :-
	gi_marshalling_tests_short_out_max('x').

:- end_tests(plgi_marshaller_short).



/* gushort */
:- begin_tests(plgi_marshaller_ushort).

test(gi_marshalling_tests_ushort_return) :-
	gi_marshalling_tests_ushort_return(Value),
	assertion(Value == 0xFFFF).

test(gi_marshalling_tests_ushort_in) :-
	gi_marshalling_tests_ushort_in(0xFFFF).

test(gi_marshalling_tests_ushort_out) :-
	gi_marshalling_tests_ushort_out(Value),
	assertion(Value == 0xFFFF).

test(gi_marshalling_tests_ushort_inout) :-
	gi_marshalling_tests_ushort_inout(0xFFFF, Value),
	assertion(Value == 0).

/* error conditions */
test(gi_marshalling_tests_ushort_instantiation_error, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_ushort_in(_).

test(gi_marshalling_tests_ushort_overflow_error, [throws(error(type_error('16 bit unsigned integer', _), _))]) :-
	gi_marshalling_tests_ushort_in(0x10000).

test(gi_marshalling_tests_ushort_underflow_error, [throws(error(type_error('16 bit unsigned integer', _), _))]) :-
	gi_marshalling_tests_ushort_in(-0x1).

test(gi_marshalling_tests_ushort_type_error, [throws(error(type_error('16 bit unsigned integer', _), _))]) :-
	gi_marshalling_tests_ushort_in('x').

test(gi_marshalling_tests_ushort_binding_failure, [fail]) :-
	gi_marshalling_tests_ushort_out('x').

:- end_tests(plgi_marshaller_ushort).



/* gint */
:- begin_tests(plgi_marshaller_int).

test(gi_marshalling_tests_int_return_max) :-
	gi_marshalling_tests_int_return_max(Value),
	assertion(Value == 0x7FFFFFFF).

test(gi_marshalling_tests_int_return_min) :-
	gi_marshalling_tests_int_return_min(Value),
	assertion(Value == -0x80000000).

test(gi_marshalling_tests_int_in_max) :-
	gi_marshalling_tests_int_in_max(0x7FFFFFFF).

test(gi_marshalling_tests_int_in_min) :-
	gi_marshalling_tests_int_in_min(-0x80000000).

test(gi_marshalling_tests_int_out_max) :-
	gi_marshalling_tests_int_out_max(Value),
	assertion(Value == 0x7FFFFFFF).

test(gi_marshalling_tests_int_out_min) :-
	gi_marshalling_tests_int_out_min(Value),
	assertion(Value == -0x80000000).

test(gi_marshalling_tests_int_inout_max_min) :-
	gi_marshalling_tests_int_inout_max_min(0x7FFFFFFF, Value),
	assertion(Value == -0x80000000).

test(gi_marshalling_tests_int_inout_min_max) :-
	gi_marshalling_tests_int_inout_min_max(-0x80000000, Value),
	assertion(Value == 0x7FFFFFFF).

/* error conditions */
test(gi_marshalling_tests_int_instantiation_error, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_int_in_max(_).

test(gi_marshalling_tests_int_overflow_error, [throws(error(type_error('32 bit integer', _), _))]) :-
	gi_marshalling_tests_int_in_max(0x80000000).

test(gi_marshalling_tests_int_underflow_error, [throws(error(type_error('32 bit integer', _), _))]) :-
	gi_marshalling_tests_int_in_max(-0x80000001).

test(gi_marshalling_tests_int_type_error, [throws(error(type_error('32 bit integer', _), _))]) :-
	gi_marshalling_tests_int_in_max('x').

test(gi_marshalling_tests_int_binding_failure, [fail]) :-
	gi_marshalling_tests_int_out_max('x').

:- end_tests(plgi_marshaller_int).



/* guint */
:- begin_tests(plgi_marshaller_uint).

test(gi_marshalling_tests_uint_return) :-
	gi_marshalling_tests_uint_return(Value),
	assertion(Value == 0xFFFFFFFF).

test(gi_marshalling_tests_uint_in) :-
	gi_marshalling_tests_uint_in(0xFFFFFFFF).

test(gi_marshalling_tests_uint_out) :-
	gi_marshalling_tests_uint_out(Value),
	assertion(Value == 0xFFFFFFFF).

test(gi_marshalling_tests_uint_inout) :-
	gi_marshalling_tests_uint_inout(0xFFFFFFFF, Value),
	assertion(Value == 0).

/* error conditions */
test(gi_marshalling_tests_uint_instantiation_error, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_uint_in(_).

test(gi_marshalling_tests_uint_overflow_error, [throws(error(type_error('32 bit unsigned integer', _), _))]) :-
	gi_marshalling_tests_uint_in(0x100000000).

test(gi_marshalling_tests_uint_underflow_error, [throws(error(type_error('32 bit unsigned integer', _), _))]) :-
	gi_marshalling_tests_uint_in(-0x1).

test(gi_marshalling_tests_uint_type_error, [throws(error(type_error('32 bit unsigned integer', _), _))]) :-
	gi_marshalling_tests_uint_in('x').

test(gi_marshalling_tests_uint_binding_failure, [fail]) :-
	gi_marshalling_tests_uint_out('x').

:- end_tests(plgi_marshaller_uint).



/* glong */
:- begin_tests(plgi_marshaller_long).

test(gi_marshalling_tests_long_return_max) :-
	gi_marshalling_tests_long_return_max(Value),
	assertion(Value == 0x7FFFFFFFFFFFFFFF).

test(gi_marshalling_tests_long_return_min) :-
	gi_marshalling_tests_long_return_min(Value),
	assertion(Value == -0x8000000000000000).

test(gi_marshalling_tests_long_in_max) :-
	gi_marshalling_tests_long_in_max(0x7FFFFFFFFFFFFFFF).

test(gi_marshalling_tests_long_in_min) :-
	gi_marshalling_tests_long_in_min(-0x8000000000000000).

test(gi_marshalling_tests_long_out_max) :-
	gi_marshalling_tests_long_out_max(Value),
	assertion(Value == 0x7FFFFFFFFFFFFFFF).

test(gi_marshalling_tests_long_out_min) :-
	gi_marshalling_tests_long_out_min(Value),
	assertion(Value == -0x8000000000000000).

test(gi_marshalling_tests_long_inout_max_min) :-
	gi_marshalling_tests_long_inout_max_min(0x7FFFFFFFFFFFFFFF, Value),
	assertion(Value == -0x8000000000000000).

test(gi_marshalling_tests_long_inout_min_max) :-
	gi_marshalling_tests_long_inout_min_max(-0x8000000000000000, Value),
	assertion(Value == 0x7FFFFFFFFFFFFFFF).

/* error conditions */
test(gi_marshalling_tests_long_instantiation_error, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_long_in_max(_).

test(gi_marshalling_tests_long_overflow_error, [throws(error(type_error('64 bit integer', _), _))]) :-
	gi_marshalling_tests_long_in_max(0x8000000000000000).

test(gi_marshalling_tests_long_underflow_error, [throws(error(type_error('64 bit integer', _), _))]) :-
	gi_marshalling_tests_long_in_max(-0x8000000000000001).

test(gi_marshalling_tests_long_type_error, [throws(error(type_error('64 bit integer', _), _))]) :-
	gi_marshalling_tests_long_in_max('x').

test(gi_marshalling_tests_long_binding_failure, [fail]) :-
	gi_marshalling_tests_long_out_max('x').

:- end_tests(plgi_marshaller_long).



/* gulong */
:- begin_tests(plgi_marshaller_ulong).

test(gi_marshalling_tests_ulong_return) :-
	gi_marshalling_tests_ulong_return(Value),
	assertion(Value == 0xFFFFFFFFFFFFFFFF).

test(gi_marshalling_tests_ulong_in) :-
	gi_marshalling_tests_ulong_in(0xFFFFFFFFFFFFFFFF).

test(gi_marshalling_tests_ulong_out) :-
	gi_marshalling_tests_ulong_out(Value),
	assertion(Value == 0xFFFFFFFFFFFFFFFF).

test(gi_marshalling_tests_ulong_inout) :-
	gi_marshalling_tests_ulong_inout(0xFFFFFFFFFFFFFFFF, Value),
	assertion(Value == 0).

/* error conditions */
test(gi_marshalling_tests_ulong_instantiation_error, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_ulong_in(_).

test(gi_marshalling_tests_ulong_overflow_error, [throws(error(type_error('64 bit unsigned integer', _), _))]) :-
	gi_marshalling_tests_ulong_in(0x10000000000000000).

test(gi_marshalling_tests_ulong_underflow_error, [throws(error(type_error('64 bit unsigned integer', _), _))]) :-
	gi_marshalling_tests_ulong_in(-0x1).

test(gi_marshalling_tests_ulong_type_error, [throws(error(type_error('64 bit unsigned integer', _), _))]) :-
	gi_marshalling_tests_ulong_in('x').

test(gi_marshalling_tests_ulong_binding_failure, [fail]) :-
	gi_marshalling_tests_ulong_out('x').

:- end_tests(plgi_marshaller_ulong).



/* gssize */
:- begin_tests(plgi_marshaller_ssize).

test(gi_marshalling_tests_ssize_return_max) :-
	gi_marshalling_tests_ssize_return_max(Value),
	assertion(Value == 0x7FFFFFFFFFFFFFFF).

test(gi_marshalling_tests_ssize_return_min) :-
	gi_marshalling_tests_ssize_return_min(Value),
	assertion(Value == -0x8000000000000000).

test(gi_marshalling_tests_ssize_in_max) :-
	gi_marshalling_tests_ssize_in_max(0x7FFFFFFFFFFFFFFF).

test(gi_marshalling_tests_ssize_in_min) :-
	gi_marshalling_tests_ssize_in_min(-0x8000000000000000).

test(gi_marshalling_tests_ssize_out_max) :-
	gi_marshalling_tests_ssize_out_max(Value),
	assertion(Value == 0x7FFFFFFFFFFFFFFF).

test(gi_marshalling_tests_ssize_out_min) :-
	gi_marshalling_tests_ssize_out_min(Value),
	assertion(Value == -0x8000000000000000).

test(gi_marshalling_tests_ssize_inout_max_min) :-
	gi_marshalling_tests_ssize_inout_max_min(0x7FFFFFFFFFFFFFFF, Value),
	assertion(Value == -0x8000000000000000).

test(gi_marshalling_tests_ssize_inout_min_max) :-
	gi_marshalling_tests_ssize_inout_min_max(-0x8000000000000000, Value),
	assertion(Value == 0x7FFFFFFFFFFFFFFF).

/* error conditions */
test(gi_marshalling_tests_ssize_instantiation_error, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_ssize_in_max(_).

test(gi_marshalling_tests_ssize_overflow_error, [throws(error(type_error('64 bit integer', _), _))]) :-
	gi_marshalling_tests_ssize_in_max(0x8000000000000000).

test(gi_marshalling_tests_ssize_underflow_error, [throws(error(type_error('64 bit integer', _), _))]) :-
	gi_marshalling_tests_ssize_in_max(-0x8000000000000001).

test(gi_marshalling_tests_ssize_type_error, [throws(error(type_error('64 bit integer', _), _))]) :-
	gi_marshalling_tests_ssize_in_max('x').

test(gi_marshalling_tests_ssize_binding_failure, [fail]) :-
	gi_marshalling_tests_ssize_out_max('x').

:- end_tests(plgi_marshaller_ssize).



/* gsize */
:- begin_tests(plgi_marshaller_size).

test(gi_marshalling_tests_size_return) :-
	gi_marshalling_tests_size_return(Value),
	assertion(Value == 0xFFFFFFFFFFFFFFFF).

test(gi_marshalling_tests_size_in) :-
	gi_marshalling_tests_size_in(0xFFFFFFFFFFFFFFFF).

test(gi_marshalling_tests_size_out) :-
	gi_marshalling_tests_size_out(Value),
	assertion(Value == 0xFFFFFFFFFFFFFFFF).

test(gi_marshalling_tests_size_inout) :-
	gi_marshalling_tests_size_inout(0xFFFFFFFFFFFFFFFF, Value),
	assertion(Value == 0).

/* error conditions */
test(gi_marshalling_tests_size_instantiation_error, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_size_in(_).

test(gi_marshalling_tests_size_overflow_error, [throws(error(type_error('64 bit unsigned integer', _), _))]) :-
	gi_marshalling_tests_size_in(0x10000000000000000).

test(gi_marshalling_tests_size_underflow_error, [throws(error(type_error('64 bit unsigned integer', _), _))]) :-
	gi_marshalling_tests_size_in(-0x1).

test(gi_marshalling_tests_size_type_error, [throws(error(type_error('64 bit unsigned integer', _), _))]) :-
	gi_marshalling_tests_size_in('x').

test(gi_marshalling_tests_size_binding_failure, [fail]) :-
	gi_marshalling_tests_size_out('x').

:- end_tests(plgi_marshaller_size).



/* gfloat */
:- begin_tests(plgi_marshaller_float).

test(gi_marshalling_tests_float_return) :-
	gi_marshalling_tests_float_return(Value),
	assertion(Value == 3.4028234663852886e+38).

test(gi_marshalling_tests_float_in) :-
	gi_marshalling_tests_float_in(3.4028234663852886e+38).

test(gi_marshalling_tests_float_out) :-
	gi_marshalling_tests_float_out(Value),
	assertion(Value == 3.4028234663852886e+38).

test(gi_marshalling_tests_float_inout) :-
	gi_marshalling_tests_float_inout(3.4028234663852886e+38, Value),
	assertion(Value == 1.1754943508222875e-38).

/* error conditions */
test(gi_marshalling_tests_float_instantiation_error, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_float_in(_).

test(gi_marshalling_tests_float_overflow_error, [throws(error(type_error('float', _), _))]) :-
	gi_marshalling_tests_float_in(3.4028234663852889e+38).

test(gi_marshalling_tests_float_type_error, [throws(error(type_error('float', _), _))]) :-
	gi_marshalling_tests_float_in('x').

test(gi_marshalling_tests_float_binding_failure, [fail]) :-
	gi_marshalling_tests_float_out('x').

:- end_tests(plgi_marshaller_float).



/* gdouble */
:- begin_tests(plgi_marshaller_double).

test(gi_marshalling_tests_double_return) :-
	gi_marshalling_tests_double_return(Value),
	assertion(Value == 1.7976931348623157e+308).

test(gi_marshalling_tests_double_in) :-
	gi_marshalling_tests_double_in(1.7976931348623157e+308).

test(gi_marshalling_tests_double_out) :-
	gi_marshalling_tests_double_out(Value),
	assertion(Value == 1.7976931348623157e+308).

test(gi_marshalling_tests_double_inout) :-
	gi_marshalling_tests_double_inout(1.7976931348623157e+308, Value),
	assertion(Value == 2.2250738585072014e-308).

/* error conditions */
test(gi_marshalling_tests_double_instantiation_error, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_double_in(_).

test(gi_marshalling_tests_double_type_error, [throws(error(type_error('double', _), _))]) :-
	gi_marshalling_tests_double_in('x').

test(gi_marshalling_tests_double_binding_failure, [fail]) :-
	gi_marshalling_tests_double_out('x').

:- end_tests(plgi_marshaller_double).



/* time_t */
:- begin_tests(plgi_marshaller_time_t).

test(gi_marshalling_tests_time_t_return) :-
	gi_marshalling_tests_time_t_return(Value),
	assertion(Value == 1234567890).

test(gi_marshalling_tests_time_t_in) :-
	gi_marshalling_tests_time_t_in(1234567890).

test(gi_marshalling_tests_time_t_out) :-
	gi_marshalling_tests_time_t_out(Value),
	assertion(Value == 1234567890).

test(gi_marshalling_tests_time_t_inout) :-
	gi_marshalling_tests_time_t_inout(1234567890, Value),
	assertion(Value == 0).

/* error conditions */
test(gi_marshalling_tests_time_t_instantiation_error, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_time_t_in(_).

test(gi_marshalling_tests_time_t_overflow_error, [throws(error(type_error('64 bit integer', _), _))]) :-
	gi_marshalling_tests_time_t_in(0x8000000000000000).

test(gi_marshalling_tests_time_t_underflow_error, [throws(error(type_error('64 bit integer', _), _))]) :-
	gi_marshalling_tests_time_t_in(-0x8000000000000001).

test(gi_marshalling_tests_time_t_type_error, [throws(error(type_error('64 bit integer', _), _))]) :-
	gi_marshalling_tests_time_t_in('x').

test(gi_marshalling_tests_time_t_binding_failure, [fail]) :-
	gi_marshalling_tests_time_t_out('x').

:- end_tests(plgi_marshaller_time_t).



/* GType */
:- begin_tests(plgi_marshaller_gtype).

test(gi_marshalling_tests_gtype_return) :-
	gi_marshalling_tests_gtype_return(Value),
	assertion(Value == 'void').

test(gi_marshalling_tests_gtype_string_return) :-
	gi_marshalling_tests_gtype_string_return(Value),
	assertion(Value == 'gchararray').

test(gi_marshalling_tests_gtype_in) :-
	gi_marshalling_tests_gtype_in('void').

test(gi_marshalling_tests_gtype_string_in) :-
	gi_marshalling_tests_gtype_string_in('gchararray').

test(gi_marshalling_tests_gtype_out) :-
	gi_marshalling_tests_gtype_out(Value),
	assertion(Value == 'void').

test(gi_marshalling_tests_gtype_string_out) :-
	gi_marshalling_tests_gtype_string_out(Value),
	assertion(Value == 'gchararray').

test(gi_marshalling_tests_gtype_inout) :-
	gi_marshalling_tests_gtype_inout('void', Value),
	assertion(Value == 'gint').

/* error conditions */
test(gi_marshalling_tests_gtype_instantiation_error, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_gtype_in(_).

test(gi_marshalling_tests_gtype_domain_error, [throws(error(domain_error('GType', _), _))]) :-
	gi_marshalling_tests_gtype_in('x').

test(gi_marshalling_tests_gtype_type_error, [throws(error(type_error('atom', _), _))]) :-
	gi_marshalling_tests_gtype_in(0).

test(gi_marshalling_tests_gtype_binding_failure, [fail]) :-
	gi_marshalling_tests_gtype_out('x').

:- end_tests(plgi_marshaller_gtype).



/* UTF8 */
:- begin_tests(plgi_marshaller_utf8).

test(gi_marshalling_tests_utf8_none_return) :-
	gi_marshalling_tests_utf8_none_return(Atom),
	assertion(Atom == 'const \u2665 utf8').

test(gi_marshalling_tests_utf8_full_return) :-
	gi_marshalling_tests_utf8_full_return(Atom),
	assertion(Atom == 'const \u2665 utf8').

test(gi_marshalling_tests_utf8_none_in) :-
	gi_marshalling_tests_utf8_none_in('const \u2665 utf8').

test(gi_marshalling_tests_utf8_as_uint8array_in) :-
	Codes = [0x63, 0x6F, 0x6E, 0x73, 0x74, 0x20, 0xE2,
	         0x99, 0xA5, 0x20, 0x75, 0x74, 0x66, 0x38],
	gi_marshalling_tests_utf8_as_uint8array_in(Codes).

test(gi_marshalling_tests_utf8_none_out) :-
	gi_marshalling_tests_utf8_none_out(Atom),
	assertion(Atom == 'const \u2665 utf8').

test(gi_marshalling_tests_utf8_full_out) :-
	gi_marshalling_tests_utf8_full_out(Atom),
	assertion(Atom == 'const \u2665 utf8').

test(gi_marshalling_tests_utf8_dangling_out) :-
	gi_marshalling_tests_utf8_dangling_out(Atom),
	assertion(Atom == {null}).

test(gi_marshalling_tests_utf8_none_inout) :-
	gi_marshalling_tests_utf8_none_inout('const \u2665 utf8', Atom),
	assertion(Atom == '').

test(gi_marshalling_tests_utf8_full_inout) :-
	gi_marshalling_tests_utf8_full_inout('const \u2665 utf8', Atom),
	assertion(Atom == '').

/* error conditions */
test(gi_marshalling_tests_utf8_instantiation_error, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_utf8_none_in(_).

test(gi_marshalling_tests_utf8_type_error, [throws(error(type_error('atom', _), _))]) :-
	gi_marshalling_tests_utf8_none_in(0).

test(gi_marshalling_tests_utf8_binding_failure, [fail]) :-
	gi_marshalling_tests_utf8_none_out('x').

:- end_tests(plgi_marshaller_utf8).



/* Init function */
:- begin_tests(plgi_marshaller_init_function).

test(gi_marshalling_tests_init_function) :-
	gi_marshalling_tests_init_function(['-1', '0', '1', '2'], Array, Retval),
	assertion(Array == ['-1', '0', '1']),
	assertion(Retval == true).

:- end_tests(plgi_marshaller_init_function).



/* array - fixed length */
:- begin_tests(plgi_marshaller_fixed_length_array).

test(gi_marshalling_tests_array_fixed_int_return) :-
	gi_marshalling_tests_array_fixed_int_return(Array),
	assertion(Array == [-1, 0, 1, 2]).

test(gi_marshalling_tests_array_fixed_short_return) :-
	gi_marshalling_tests_array_fixed_short_return(Array),
	assertion(Array == [-1, 0, 1, 2]).

test(gi_marshalling_tests_array_fixed_int_in) :-
	gi_marshalling_tests_array_fixed_int_in([-1, 0, 1, 2]).

test(gi_marshalling_tests_array_fixed_short_in) :-
	gi_marshalling_tests_array_fixed_short_in([-1, 0, 1, 2]).

test(gi_marshalling_tests_array_fixed_out) :-
	gi_marshalling_tests_array_fixed_out(Array),
	assertion(Array == [-1, 0, 1, 2]).

test(gi_marshalling_tests_array_fixed_out_struct) :-
	gi_marshalling_tests_array_fixed_out_struct(Array),
	Array = [Struct1, Struct2],
	plgi_struct_term(Struct1, Term1),
	plgi_struct_term(Struct2, Term2),
	assertion(Term1 == 'GIMarshallingTestsSimpleStruct'( 'long_'=7, 'int8'=6 )),
	assertion(Term2 == 'GIMarshallingTestsSimpleStruct'( 'long_'=6, 'int8'=7 )).

test(gi_marshalling_tests_array_fixed_inout) :-
	gi_marshalling_tests_array_fixed_inout([-1, 0, 1, 2], Array),
	assertion(Array == [2, 1, 0, -1]).

/* error conditions */
test(gi_marshalling_tests_array_fixed_instantiation_error, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_array_fixed_int_in(_).

test(gi_marshalling_tests_array_fixed_type_error, [throws(error(type_error('list', _), _))]) :-
	gi_marshalling_tests_array_fixed_int_in(0).

test(gi_marshalling_tests_array_fixed_partial_list_type_error, [throws(error(type_error('list', _), _))]) :-
	gi_marshalling_tests_array_fixed_int_in([-1, 0, 1, 2|_]).

test(gi_marshalling_tests_array_fixed_element_type_error, [throws(error(type_error('32 bit integer', _), _))]) :-
	gi_marshalling_tests_array_fixed_int_in([-1, 0, 1, '2']).

test(gi_marshalling_tests_array_fixed_binding_failure, [fail]) :-
	gi_marshalling_tests_array_fixed_out('x').

test(gi_marshalling_tests_array_fixed_too_short_binding_failure, [fail]) :-
	gi_marshalling_tests_array_fixed_out([-1, 0, 1]).

test(gi_marshalling_tests_array_fixed_too_long_binding_failure, [fail]) :-
	gi_marshalling_tests_array_fixed_out([-1, 0, 1, 2, 3]).

test(gi_marshalling_tests_array_fixed_element_binding_failure, [fail]) :-
	gi_marshalling_tests_array_fixed_out([-1, 0, 1, 'x']).

test(gi_marshalling_tests_array_fixed_size_error, [throws(error(type_error('fixed-size list', _), _))]) :-
	gi_marshalling_tests_array_fixed_int_in([-1, 0, 1]).

:- end_tests(plgi_marshaller_fixed_length_array).



/* array - variable length */
:- begin_tests(plgi_marshaller_variable_length_array).

test(gi_marshalling_tests_array_return) :-
	gi_marshalling_tests_array_return(Array),
	assertion(Array == [-1, 0, 1, 2]).

test(gi_marshalling_tests_array_return_etc) :-
	gi_marshalling_tests_array_return_etc(-2, 3, Sum, Array),
	assertion(Sum == 1),
	assertion(Array == [-2, 0, 1, 3]).

test(gi_marshalling_tests_array_in) :-
	gi_marshalling_tests_array_in([-1, 0, 1, 2]).

test(gi_marshalling_tests_array_in_len_before) :-
	gi_marshalling_tests_array_in_len_before([-1, 0, 1, 2]).

test(gi_marshalling_tests_array_in_len_zero_terminated) :-
	gi_marshalling_tests_array_in_len_zero_terminated([-1, 0, 1, 2]).

test(gi_marshalling_tests_array_string_in) :-
	gi_marshalling_tests_array_string_in(['foo', 'bar']).

test(gi_marshalling_tests_array_uint8_in) :-
	Codes = [0x61, 0x62, 0x63, 0x64],
	gi_marshalling_tests_array_uint8_in(Codes).

test(gi_marshalling_tests_array_struct_in) :-
	StructTerm1 = 'GIMarshallingTestsBoxedStruct'( 'long_'=1, 'string_'='hello', 'g_strv'=['0', '1', '2'] ),
	StructTerm2 = 'GIMarshallingTestsBoxedStruct'( 'long_'=2, 'string_'='hello', 'g_strv'=['0', '1', '2'] ),
	StructTerm3 = 'GIMarshallingTestsBoxedStruct'( 'long_'=3, 'string_'='hello', 'g_strv'=['0', '1', '2'] ),
	plgi_struct_new(StructTerm1, Struct1),
	plgi_struct_new(StructTerm2, Struct2),
	plgi_struct_new(StructTerm3, Struct3),
	gi_marshalling_tests_array_struct_in([Struct1, Struct2, Struct3]).

test(gi_marshalling_tests_array_struct_value_in) :-
	StructTerm1 = 'GIMarshallingTestsBoxedStruct'( 'long_'=1, 'string_'='hello', 'g_strv'=[] ),
	StructTerm2 = 'GIMarshallingTestsBoxedStruct'( 'long_'=2, 'string_'='hello', 'g_strv'=[] ),
	StructTerm3 = 'GIMarshallingTestsBoxedStruct'( 'long_'=3, 'string_'='hello', 'g_strv'=[] ),
	plgi_struct_new(StructTerm1, Struct1),
	plgi_struct_new(StructTerm2, Struct2),
	plgi_struct_new(StructTerm3, Struct3),
	gi_marshalling_tests_array_struct_value_in([Struct1, Struct2, Struct3]).

test(gi_marshalling_tests_array_simple_struct_in) :-
	StructTerm1 = 'GIMarshallingTestsSimpleStruct'( 'long_'=1, 'int8'=7 ),
	StructTerm2 = 'GIMarshallingTestsSimpleStruct'( 'long_'=2, 'int8'=7 ),
	StructTerm3 = 'GIMarshallingTestsSimpleStruct'( 'long_'=3, 'int8'=7 ),
	plgi_struct_new(StructTerm1, Struct1),
	plgi_struct_new(StructTerm2, Struct2),
	plgi_struct_new(StructTerm3, Struct3),
	gi_marshalling_tests_array_simple_struct_in([Struct1, Struct2, Struct3]).

test(gi_marshalling_tests_multi_array_key_value_in) :-
	Keys = ['one', 'two', 'three'],
	g_value_init('gint', GValue1),
	g_value_set_int(GValue1, 1),
	g_value_init('gint', GValue2),
	g_value_set_int(GValue2, 2),
	g_value_init('gint', GValue3),
	g_value_set_int(GValue3, 3),
	GValues = [GValue1, GValue2, GValue3],
	gi_marshalling_tests_multi_array_key_value_in(Keys, GValues).

test(gi_marshalling_tests_array_struct_take_in) :-
	StructTerm1 = 'GIMarshallingTestsBoxedStruct'( 'long_'=1, 'string_'='hello', 'g_strv'=['0', '1', '2'] ),
	StructTerm2 = 'GIMarshallingTestsBoxedStruct'( 'long_'=2, 'string_'='hello', 'g_strv'=['0', '1', '2'] ),
	StructTerm3 = 'GIMarshallingTestsBoxedStruct'( 'long_'=3, 'string_'='hello', 'g_strv'=['0', '1', '2'] ),
	plgi_struct_new(StructTerm1, Struct1),
	plgi_struct_new(StructTerm2, Struct2),
	plgi_struct_new(StructTerm3, Struct3),
	gi_marshalling_tests_array_struct_take_in([Struct1, Struct2, Struct3]).

test(gi_marshalling_tests_array_enum_in) :-
	Array = ['GI_MARSHALLING_TESTS_ENUM_VALUE1',
	         'GI_MARSHALLING_TESTS_ENUM_VALUE2',
	         'GI_MARSHALLING_TESTS_ENUM_VALUE3'],
	gi_marshalling_tests_array_enum_in(Array).

test(gi_marshalling_tests_array_in_guint64_len) :-
	gi_marshalling_tests_array_in_guint64_len([-1, 0, 1, 2]).

test(gi_marshalling_tests_array_in_guint8_len) :-
	gi_marshalling_tests_array_in_guint8_len([-1, 0, 1, 2]).

test(gi_marshalling_tests_array_out) :-
	gi_marshalling_tests_array_out(Array),
	assertion(Array == [-1, 0, 1, 2]).

test(gi_marshalling_tests_array_out_etc) :-
	gi_marshalling_tests_array_out_etc(-2, Array, 3, Sum),
	assertion(Array == [-2, 0, 1, 3]),
	assertion(Sum == 1).

test(gi_marshalling_tests_array_inout) :-
	gi_marshalling_tests_array_inout([-1, 0, 1, 2], Array),
	assertion(Array == [-2, -1, 0, 1, 2]).

test(gi_marshalling_tests_array_inout_etc) :-
	gi_marshalling_tests_array_inout_etc(-3, [-1, 0, 1, 2], Array, 3, Sum),
	assertion(Array == [-3, -1, 0, 1, 3]),
	assertion(Sum == 0).

test(gi_marshalling_tests_array_in_nonzero_nonlen) :-
	Codes = [0x61, 0x62, 0x63, 0x64],
	gi_marshalling_tests_array_in_nonzero_nonlen(0, Codes).

/* error conditions */
test(gi_marshalling_tests_array_instantiation_error, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_array_in(_).

test(gi_marshalling_tests_array_type_error, [throws(error(type_error('list', _), _))]) :-
	gi_marshalling_tests_array_in(0).

test(gi_marshalling_tests_array_partial_list_type_error, [throws(error(type_error('list', _), _))]) :-
	gi_marshalling_tests_array_in([-1, 0, 1, 2|_]).

test(gi_marshalling_tests_array_element_type_error, [throws(error(type_error('32 bit integer', _), _))]) :-
	gi_marshalling_tests_array_in([-1, 0, 1, '2']).

test(gi_marshalling_tests_array_binding_failure, [fail]) :-
	gi_marshalling_tests_array_out('x').

test(gi_marshalling_tests_array_too_short_binding_failure, [fail]) :-
	gi_marshalling_tests_array_out([-1, 0, 1]).

test(gi_marshalling_tests_array_too_long_binding_failure, [fail]) :-
	gi_marshalling_tests_array_out([-1, 0, 1, 2, 3]).

test(gi_marshalling_tests_array_element_binding_failure, [fail]) :-
	gi_marshalling_tests_array_out([-1, 0, 1, 'x']).

:- end_tests(plgi_marshaller_variable_length_array).



/* array - zero terminated */
:- begin_tests(plgi_marshaller_zero_terminated_array).

test(gi_marshalling_tests_array_zero_terminated_return) :-
	gi_marshalling_tests_array_zero_terminated_return(Array),
	assertion(Array == ['0', '1', '2']).

test(gi_marshalling_tests_array_zero_terminated_return_null) :-
	gi_marshalling_tests_array_zero_terminated_return_null(Array),
	assertion(Array == []).

test(gi_marshalling_tests_array_zero_terminated_return_struct) :-
	gi_marshalling_tests_array_zero_terminated_return_struct(Array),
	Array = [ Struct1, Struct2, Struct3 ],
	plgi_struct_term(Struct1, StructTerm1),
	plgi_struct_term(Struct2, StructTerm2),
	plgi_struct_term(Struct3, StructTerm3),
	assertion(StructTerm1 == 'GIMarshallingTestsBoxedStruct'( 'long_'=42, 'string_'={null}, 'g_strv'=[] )),
	assertion(StructTerm2 == 'GIMarshallingTestsBoxedStruct'( 'long_'=43, 'string_'={null}, 'g_strv'=[] )),
	assertion(StructTerm3 == 'GIMarshallingTestsBoxedStruct'( 'long_'=44, 'string_'={null}, 'g_strv'=[] )).

test(gi_marshalling_tests_array_zero_terminated_in) :-
	gi_marshalling_tests_array_zero_terminated_in(['0', '1', '2']).

test(gi_marshalling_tests_array_zero_terminated_out) :-
	gi_marshalling_tests_array_zero_terminated_out(Array),
	assertion(Array == ['0', '1', '2']).

test(gi_marshalling_tests_array_zero_terminated_inout) :-
	gi_marshalling_tests_array_zero_terminated_inout(['0', '1', '2'], Array),
	assertion(Array == ['-1', '0', '1', '2']).

test(gi_marshalling_tests_array_gvariant_none_in) :-
	g_variant_new_int32(27, GVariantIn1),
	g_variant_new_string('Hello', GVariantIn2),
	ArrayIn = [GVariantIn1, GVariantIn2],
	gi_marshalling_tests_array_gvariant_none_in(ArrayIn, ArrayOut),
	ArrayOut = [GVariantOut1, GVariantOut2],
	g_variant_get_int32(GVariantOut1, Value1),
	assertion(Value1 == 27),
	g_variant_get_string(GVariantOut2, _, String),
	assertion(String == 'Hello').

test(gi_marshalling_tests_array_gvariant_container_in) :-
	g_variant_new_int32(27, GVariantIn1),
	g_variant_new_string('Hello', GVariantIn2),
	ArrayIn = [GVariantIn1, GVariantIn2],
	gi_marshalling_tests_array_gvariant_container_in(ArrayIn, ArrayOut),
	ArrayOut = [GVariantOut1, GVariantOut2],
	g_variant_get_int32(GVariantOut1, Value1),
	assertion(Value1 == 27),
	g_variant_get_string(GVariantOut2, _, String),
	assertion(String == 'Hello').

test(gi_marshalling_tests_array_gvariant_full_in) :-
	g_variant_new_int32(27, GVariantIn1),
	g_variant_new_string('Hello', GVariantIn2),
	ArrayIn = [GVariantIn1, GVariantIn2],
	gi_marshalling_tests_array_gvariant_full_in(ArrayIn, ArrayOut),
	ArrayOut = [GVariantOut1, GVariantOut2],
	g_variant_get_int32(GVariantOut1, Value1),
	assertion(Value1 == 27),
	g_variant_get_string(GVariantOut2, _, String),
	assertion(String == 'Hello').

/* error conditions */
test(gi_marshalling_tests_array_zero_terminated_instantiation_error, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_array_zero_terminated_in(_).

test(gi_marshalling_tests_array_zero_terminated_type_error, [throws(error(type_error('list', _), _))]) :-
	gi_marshalling_tests_array_zero_terminated_in(0).

test(gi_marshalling_tests_array_zero_terminated_partial_list_type_error, [throws(error(type_error('list', _), _))]) :-
	gi_marshalling_tests_array_zero_terminated_in(['0', '1', '2'|_]).

test(gi_marshalling_tests_array_zero_terminated_element_type_error, [throws(error(type_error('atom', _), _))]) :-
	gi_marshalling_tests_array_zero_terminated_in(['0', '1', 2]).

test(gi_marshalling_tests_array_zero_terminated_binding_failure, [fail]) :-
	gi_marshalling_tests_array_zero_terminated_out('x').

test(gi_marshalling_tests_array_zero_terminated_too_short_binding_failure, [fail]) :-
	gi_marshalling_tests_array_zero_terminated_out(['0', '1']).

test(gi_marshalling_tests_array_zero_terminated_too_long_binding_failure, [fail]) :-
	gi_marshalling_tests_array_zero_terminated_out(['0', '1', '2', '3']).

test(gi_marshalling_tests_array_zero_terminated_element_binding_failure, [fail]) :-
	gi_marshalling_tests_array_zero_terminated_out(['0', '1', 'x']).

:- end_tests(plgi_marshaller_zero_terminated_array).



/* GArray */
:- begin_tests(plgi_marshaller_garray).

test(gi_marshalling_tests_garray_int_none_return) :-
	gi_marshalling_tests_garray_int_none_return(GArray),
	assertion(GArray == [-1, 0, 1, 2]).

test(gi_marshalling_tests_garray_uint64_none_return) :-
	gi_marshalling_tests_garray_uint64_none_return(GArray),
	assertion(GArray == [0, 0xFFFFFFFFFFFFFFFF]).

test(gi_marshalling_tests_garray_utf8_none_return) :-
	gi_marshalling_tests_garray_utf8_none_return(GArray),
	assertion(GArray == ['0', '1', '2']).

test(gi_marshalling_tests_garray_utf8_container_return) :-
	gi_marshalling_tests_garray_utf8_container_return(GArray),
	assertion(GArray == ['0', '1', '2']).

test(gi_marshalling_tests_garray_utf8_full_return) :-
	gi_marshalling_tests_garray_utf8_full_return(GArray),
	assertion(GArray == ['0', '1', '2']).

test(gi_marshalling_tests_garray_int_none_in) :-
	gi_marshalling_tests_garray_int_none_in([-1, 0, 1, 2]).

test(gi_marshalling_tests_garray_uint64_none_in) :-
	gi_marshalling_tests_garray_uint64_none_in([0, 0xFFFFFFFFFFFFFFFF]).

test(gi_marshalling_tests_garray_utf8_none_in) :-
	gi_marshalling_tests_garray_utf8_none_in(['0', '1', '2']).

test(gi_marshalling_tests_garray_utf8_none_out) :-
	gi_marshalling_tests_garray_utf8_none_out(GArray),
	assertion(GArray == ['0', '1', '2']).

test(gi_marshalling_tests_garray_utf8_container_out) :-
	gi_marshalling_tests_garray_utf8_container_out(GArray),
	assertion(GArray == ['0', '1', '2']).

test(gi_marshalling_tests_garray_utf8_full_out) :-
	gi_marshalling_tests_garray_utf8_full_out(GArray),
	assertion(GArray == ['0', '1', '2']).

test(gi_marshalling_tests_garray_utf8_full_out_caller_allocated) :-
	gi_marshalling_tests_garray_utf8_full_out_caller_allocated(GArray),
	assertion(GArray == ['0', '1', '2']).

test(gi_marshalling_tests_garray_utf8_none_inout) :-
	gi_marshalling_tests_garray_utf8_none_inout(['0', '1', '2'], GArray),
	assertion(GArray == ['-2', '-1', '0', '1']).

test(gi_marshalling_tests_garray_utf8_container_inout) :-
	gi_marshalling_tests_garray_utf8_container_inout(['0', '1', '2'], GArray),
	assertion(GArray == ['-2', '-1', '0', '1']).

test(gi_marshalling_tests_garray_utf8_full_inout) :-
	gi_marshalling_tests_garray_utf8_full_inout(['0', '1', '2'], GArray),
	assertion(GArray == ['-2', '-1', '0', '1']).

/* error conditions */
test(gi_marshalling_tests_garray_instantiation_error, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_garray_utf8_none_in(_).

test(gi_marshalling_tests_garray_type_error, [throws(error(type_error('list', _), _))]) :-
	gi_marshalling_tests_garray_utf8_none_in('x').

test(gi_marshalling_tests_garray_partial_list_type_error, [throws(error(type_error('list', _), _))]) :-
	gi_marshalling_tests_garray_utf8_none_in(['0', '1', '2'|_]).

test(gi_marshalling_tests_garray_element_type_error, [throws(error(type_error('atom', _), _))]) :-
	gi_marshalling_tests_garray_utf8_none_in(['0', '1', 2]).

test(gi_marshalling_tests_garray_none_in_cleanup, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_garray_utf8_none_in(['0', '1', _]).

test(gi_marshalling_tests_garray_container_in_cleanup, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_garray_utf8_container_inout(['0', '1', _], _).

test(gi_marshalling_tests_garray_full_in_cleanup, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_garray_utf8_full_inout(['0', '1', _], _).

test(gi_marshalling_tests_garray_binding_failure, [fail]) :-
	gi_marshalling_tests_garray_utf8_full_out('x').

test(gi_marshalling_tests_garray_too_short_binding_failure, [fail]) :-
	gi_marshalling_tests_garray_utf8_full_out(['0', '1']).

test(gi_marshalling_tests_garray_too_long_binding_failure, [fail]) :-
	gi_marshalling_tests_garray_utf8_full_out(['0', '1', '2', '3']).

test(gi_marshalling_tests_garray_element_binding_failure, [fail]) :-
	gi_marshalling_tests_garray_utf8_full_out(['0', '1', 'x']).

:- end_tests(plgi_marshaller_garray).



/* GPtrArray */
:- begin_tests(plgi_marshaller_gptrarray).

test(gi_marshalling_tests_gptrarray_utf8_none_return) :-
	gi_marshalling_tests_gptrarray_utf8_none_return(GPtrArray),
	assertion(GPtrArray == ['0', '1', '2']).

test(gi_marshalling_tests_gptrarray_utf8_container_return) :-
	gi_marshalling_tests_gptrarray_utf8_container_return(GPtrArray),
	assertion(GPtrArray == ['0', '1', '2']).

test(gi_marshalling_tests_gptrarray_utf8_full_return) :-
	gi_marshalling_tests_gptrarray_utf8_full_return(GPtrArray),
	assertion(GPtrArray == ['0', '1', '2']).

test(gi_marshalling_tests_gptrarray_utf8_none_in) :-
	GPtrArray = ['0', '1', '2'],
	gi_marshalling_tests_gptrarray_utf8_none_in(GPtrArray).

test(gi_marshalling_tests_gptrarray_utf8_none_out) :-
	gi_marshalling_tests_gptrarray_utf8_none_out(GPtrArray),
	assertion(GPtrArray == ['0', '1', '2']).

test(gi_marshalling_tests_gptrarray_utf8_container_out) :-
	gi_marshalling_tests_gptrarray_utf8_container_out(GPtrArray),
	assertion(GPtrArray == ['0', '1', '2']).

test(gi_marshalling_tests_gptrarray_utf8_full_out) :-
	gi_marshalling_tests_gptrarray_utf8_full_out(GPtrArray),
	assertion(GPtrArray == ['0', '1', '2']).

test(gi_marshalling_tests_gptrarray_utf8_none_inout) :-
	GPtrArrayIn = ['0', '1', '2'],
	gi_marshalling_tests_gptrarray_utf8_none_inout(GPtrArrayIn, GPtrArrayOut),
	assertion(GPtrArrayOut == ['-2', '-1', '0', '1']).

test(gi_marshalling_tests_gptrarray_utf8_container_inout) :-
	GPtrArrayIn = ['0', '1', '2'],
	gi_marshalling_tests_gptrarray_utf8_container_inout(GPtrArrayIn, GPtrArrayOut),
	assertion(GPtrArrayOut == ['-2', '-1', '0', '1']).

test(gi_marshalling_tests_gptrarray_utf8_full_inout) :-
	GPtrArrayIn = ['0', '1', '2'],
	gi_marshalling_tests_gptrarray_utf8_full_inout(GPtrArrayIn, GPtrArrayOut),
	assertion(GPtrArrayOut == ['-2', '-1', '0', '1']).

/* error conditions */
test(gi_marshalling_tests_gptrarray_instantiation_error, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_gptrarray_utf8_none_in(_).

test(gi_marshalling_tests_gptrarray_type_error, [throws(error(type_error('list', _), _))]) :-
	gi_marshalling_tests_gptrarray_utf8_none_in('x').

test(gi_marshalling_tests_gptrarray_partial_list_type_error, [throws(error(type_error('list', _), _))]) :-
	gi_marshalling_tests_gptrarray_utf8_none_in(['0', '1', '2'|_]).

test(gi_marshalling_tests_gptrarray_element_type_error, [throws(error(type_error('atom', _), _))]) :-
	gi_marshalling_tests_gptrarray_utf8_none_in(['0', '1', 2]).

test(gi_marshalling_tests_gptrarray_none_in_cleanup, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_gptrarray_utf8_none_in(['0', '1', _]).

test(gi_marshalling_tests_gptrarray_container_in_cleanup, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_gptrarray_utf8_container_inout(['0', '1', _], _).

test(gi_marshalling_tests_gptrarray_full_in_cleanup, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_gptrarray_utf8_full_inout(['0', '1', _], _).

test(gi_marshalling_tests_gptrarray_binding_failure, [fail]) :-
	gi_marshalling_tests_gptrarray_utf8_full_out('x').

test(gi_marshalling_tests_gptrarray_too_short_binding_failure, [fail]) :-
	gi_marshalling_tests_gptrarray_utf8_full_out(['0', '1']).

test(gi_marshalling_tests_gptrarray_too_long_binding_failure, [fail]) :-
	gi_marshalling_tests_gptrarray_utf8_full_out(['0', '1', '2', '3']).

test(gi_marshalling_tests_gptrarray_element_binding_failure, [fail]) :-
	gi_marshalling_tests_gptrarray_utf8_full_out(['0', '1', 'x']).

:- end_tests(plgi_marshaller_gptrarray).



/* GByteArray */
:- begin_tests(plgi_marshaller_gbytearray).

test(gi_marshalling_tests_gbytearray_full_return) :-
	gi_marshalling_tests_bytearray_full_return(GByteArray),
	assertion(GByteArray == [0x0, 0x31, 0xFF, 0x33]).

test(gi_marshalling_tests_gbytearray_none_in) :-
	gi_marshalling_tests_bytearray_none_in([0x0, 0x31, 0xFF, 0x33]).

/* error conditions */
test(gi_marshalling_tests_gbytearray_instantiation_error, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_bytearray_none_in(_).

test(gi_marshalling_tests_gbytearray_type_error, [throws(error(type_error('list', _), _))]) :-
	gi_marshalling_tests_bytearray_none_in('x').

test(gi_marshalling_tests_gbytearray_partial_list_type_error, [throws(error(type_error('list', _), _))]) :-
	gi_marshalling_tests_bytearray_none_in([0x0, 0x31, 0xFF, 0x33|_]).

test(gi_marshalling_tests_gbytearray_element_type_error, [throws(error(type_error('8 bit unsigned integer', _), _))]) :-
	gi_marshalling_tests_bytearray_none_in([0x0, 0x31, 0xFF, 'x']).

test(gi_marshalling_tests_gbytearray_element_overflow_error, [throws(error(type_error('8 bit unsigned integer', _), _))]) :-
	gi_marshalling_tests_bytearray_none_in([0x100]).

test(gi_marshalling_tests_gbytearray_element_underflow_error, [throws(error(type_error('8 bit unsigned integer', _), _))]) :-
	gi_marshalling_tests_bytearray_none_in([-1]).

test(gi_marshalling_tests_gbytearray_none_in_cleanup, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_bytearray_none_in([0x0, 0x31, 0xFF, _]).

test(gi_marshalling_tests_gbytearray_binding_failure, [fail]) :-
	gi_marshalling_tests_bytearray_full_return('x').

test(gi_marshalling_tests_gbytearray_too_short_binding_failure, [fail]) :-
	gi_marshalling_tests_bytearray_full_return([0x0, 0x31, 0xFF]).

test(gi_marshalling_tests_gbytearray_too_long_binding_failure, [fail]) :-
	gi_marshalling_tests_bytearray_full_return([0x0, 0x31, 0xFF, 0x33, 0x0]).

test(gi_marshalling_tests_gbytearray_element_binding_failure, [fail]) :-
	gi_marshalling_tests_bytearray_full_return([0x0, 0x31, 0xFF, 'x']).

:- end_tests(plgi_marshaller_gbytearray).



/* GBytes */
:- begin_tests(plgi_marshaller_gbytes).

test(gi_marshalling_tests_gbytes_full_return) :-
	gi_marshalling_tests_gbytes_full_return(GBytes),
	assertion(GBytes == [0x0, 0x31, 0xFF, 0x33]).

test(gi_marshalling_tests_gbytes_none_in) :-
	gi_marshalling_tests_gbytes_none_in([0x0, 0x31, 0xFF, 0x33]).

/* error conditions */
test(gi_marshalling_tests_gbytes_instantiation_error, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_gbytes_none_in(_).

test(gi_marshalling_tests_gbytes_type_error, [throws(error(type_error('list', _), _))]) :-
	gi_marshalling_tests_gbytes_none_in('x').

test(gi_marshalling_tests_gbytes_partial_list_type_error, [throws(error(type_error('list', _), _))]) :-
	gi_marshalling_tests_gbytes_none_in([0x0, 0x31, 0xFF, 0x33|_]).

test(gi_marshalling_tests_gbytes_element_type_error, [throws(error(type_error('8 bit unsigned integer', _), _))]) :-
	gi_marshalling_tests_gbytes_none_in([0x0, 0x31, 0xFF, 'x']).

test(gi_marshalling_tests_gbytes_element_overflow_error, [throws(error(type_error('8 bit unsigned integer', _), _))]) :-
	gi_marshalling_tests_gbytes_none_in([0x100]).

test(gi_marshalling_tests_gbytes_element_underflow_error, [throws(error(type_error('8 bit unsigned integer', _), _))]) :-
	gi_marshalling_tests_gbytes_none_in([-1]).

test(gi_marshalling_tests_gbytes_none_in_cleanup, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_gbytes_none_in([0x0, 0x31, 0xFF, _]).

test(gi_marshalling_tests_gbytes_binding_failure, [fail]) :-
	gi_marshalling_tests_gbytes_full_return('x').

test(gi_marshalling_tests_gbytes_too_short_binding_failure, [fail]) :-
	gi_marshalling_tests_gbytes_full_return([0x0, 0x31, 0xFF]).

test(gi_marshalling_tests_gbytes_too_long_binding_failure, [fail]) :-
	gi_marshalling_tests_gbytes_full_return([0x0, 0x31, 0xFF, 0x33, 0x0]).

test(gi_marshalling_tests_gbytes_element_binding_failure, [fail]) :-
	gi_marshalling_tests_gbytes_full_return([0x0, 0x31, 0xFF, 'x']).

:- end_tests(plgi_marshaller_gbytes).



/* GStrv */
:- begin_tests(plgi_marshaller_gstrv).

test(gi_marshalling_tests_gstrv_return) :-
	gi_marshalling_tests_gstrv_return(GStrv),
	assertion(GStrv == ['0', '1', '2']).

test(gi_marshalling_tests_gstrv_in) :-
	GStrv = ['0', '1', '2'],
	gi_marshalling_tests_gstrv_in(GStrv).

test(gi_marshalling_tests_gstrv_out) :-
	gi_marshalling_tests_gstrv_out(GStrv),
	assertion(GStrv == ['0', '1', '2']).

test(gi_marshalling_tests_gstrv_inout) :-
	GStrvIn = ['0', '1', '2'],
	gi_marshalling_tests_gstrv_inout(GStrvIn, GStrvOut),
	assertion(GStrvOut == ['-1', '0', '1', '2']).

/* error conditions */
test(gi_marshalling_tests_gstrv_instantiation_error, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_gstrv_in(_).

test(gi_marshalling_tests_gstrv_type_error, [throws(error(type_error('list', _), _))]) :-
	gi_marshalling_tests_gstrv_in('x').

test(gi_marshalling_tests_gstrv_partial_list_type_error, [throws(error(type_error('list', _), _))]) :-
	gi_marshalling_tests_gstrv_in(['0', '1', '2'|_]).

test(gi_marshalling_tests_gstrv_element_type_error, [throws(error(type_error('atom', _), _))]) :-
	gi_marshalling_tests_gstrv_in(['0', '1', 0]).

test(gi_marshalling_tests_gstrv_none_in_cleanup, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_gstrv_in(['0', '1', _]).

test(gi_marshalling_tests_gstrv_binding_failure, [fail]) :-
	gi_marshalling_tests_gstrv_out('x').

test(gi_marshalling_tests_gstrv_too_short_binding_failure, [fail]) :-
	gi_marshalling_tests_gstrv_out(['0', '1']).

test(gi_marshalling_tests_gstrv_too_long_binding_failure, [fail]) :-
	gi_marshalling_tests_gstrv_out(['0', '1', '2', '3']).

test(gi_marshalling_tests_gstrv_element_binding_failure, [fail]) :-
	gi_marshalling_tests_gstrv_out(['0', '1', 'x']).

:- end_tests(plgi_marshaller_gstrv).



/* GList */
:- begin_tests(plgi_marshaller_glist).

test(gi_marshalling_tests_glist_int_none_return) :-
	gi_marshalling_tests_glist_int_none_return(GList),
	assertion(GList == [-1, 0, 1, 2]).

test(gi_marshalling_tests_glist_uint32_none_return) :-
	gi_marshalling_tests_glist_uint32_none_return(GList),
	assertion(GList == [0, 0xFFFFFFFF]).

test(gi_marshalling_tests_glist_utf8_none_return) :-
	gi_marshalling_tests_glist_utf8_none_return(GList),
	assertion(GList == ['0', '1', '2']).

test(gi_marshalling_tests_glist_utf8_container_return) :-
	gi_marshalling_tests_glist_utf8_container_return(GList),
	assertion(GList == ['0', '1', '2']).

test(gi_marshalling_tests_glist_utf8_full_return) :-
	gi_marshalling_tests_glist_utf8_full_return(GList),
	assertion(GList == ['0', '1', '2']).

test(gi_marshalling_tests_glist_int_none_in) :-
	gi_marshalling_tests_glist_int_none_in([-1, 0, 1, 2]).

test(gi_marshalling_tests_glist_uint32_none_in) :-
	gi_marshalling_tests_glist_uint32_none_in([0, 0xFFFFFFFF]).

test(gi_marshalling_tests_glist_utf8_none_in) :-
	gi_marshalling_tests_glist_utf8_none_in(['0', '1', '2']).

test(gi_marshalling_tests_glist_utf8_none_out) :-
	gi_marshalling_tests_glist_utf8_none_out(GList),
	assertion(GList == ['0', '1', '2']).

test(gi_marshalling_tests_glist_utf8_container_out) :-
	gi_marshalling_tests_glist_utf8_container_out(GList),
	assertion(GList == ['0', '1', '2']).

test(gi_marshalling_tests_glist_utf8_full_out) :-
	gi_marshalling_tests_glist_utf8_full_out(GList),
	assertion(GList == ['0', '1', '2']).

test(gi_marshalling_tests_glist_utf8_none_inout) :-
	gi_marshalling_tests_glist_utf8_none_inout(['0', '1', '2'], GList),
	assertion(GList == ['-2', '-1', '0', '1']).

test(gi_marshalling_tests_glist_utf8_container_inout) :-
	gi_marshalling_tests_glist_utf8_container_inout(['0', '1', '2'], GList),
	assertion(GList == ['-2', '-1', '0', '1']).

test(gi_marshalling_tests_glist_utf8_full_inout) :-
	gi_marshalling_tests_glist_utf8_full_inout(['0', '1', '2'], GList),
	assertion(GList == ['-2', '-1', '0', '1']).

/* error conditions */
test(gi_marshalling_tests_glist_instantiation_error, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_glist_utf8_none_in(_).

test(gi_marshalling_tests_glist_type_error, [throws(error(type_error('list', _), _))]) :-
	gi_marshalling_tests_glist_utf8_none_in('x').

test(gi_marshalling_tests_glist_partial_list_type_error, [throws(error(type_error('list', _), _))]) :-
	gi_marshalling_tests_glist_utf8_none_in(['0', '1', '2'|_]).

test(gi_marshalling_tests_glist_element_type_error, [throws(error(type_error('atom', _), _))]) :-
	gi_marshalling_tests_glist_utf8_none_in(['0', '1', 2]).

test(gi_marshalling_tests_glist_none_in_cleanup, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_glist_utf8_none_in(['0', '1', _]).

test(gi_marshalling_tests_glist_container_in_cleanup, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_glist_utf8_container_inout(['0', '1', _], _).

test(gi_marshalling_tests_glist_full_in_cleanup, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_glist_utf8_full_inout(['0', '1', _], _).

test(gi_marshalling_tests_glist_binding_failure, [fail]) :-
	gi_marshalling_tests_glist_utf8_full_out('x').

test(gi_marshalling_tests_glist_too_short_binding_failure, [fail]) :-
	gi_marshalling_tests_glist_utf8_full_out(['0', '1']).

test(gi_marshalling_tests_glist_too_long_binding_failure, [fail]) :-
	gi_marshalling_tests_glist_utf8_full_out(['0', '1', '2', '3']).

test(gi_marshalling_tests_glist_element_binding_failure, [fail]) :-
	gi_marshalling_tests_glist_utf8_full_out(['0', '1', 'x']).

:- end_tests(plgi_marshaller_glist).



/* GSList */
:- begin_tests(plgi_marshaller_gslist).

test(gi_marshalling_tests_gslist_int_none_return) :-
	gi_marshalling_tests_gslist_int_none_return(GSList),
	assertion(GSList == [-1, 0, 1, 2]).

test(gi_marshalling_tests_gslist_utf8_none_return) :-
	gi_marshalling_tests_gslist_utf8_none_return(GSList),
	assertion(GSList == ['0', '1', '2']).

test(gi_marshalling_tests_gslist_utf8_container_return) :-
	gi_marshalling_tests_gslist_utf8_container_return(GSList),
	assertion(GSList == ['0', '1', '2']).

test(gi_marshalling_tests_gslist_utf8_full_return) :-
	gi_marshalling_tests_gslist_utf8_full_return(GSList),
	assertion(GSList == ['0', '1', '2']).

test(gi_marshalling_tests_gslist_int_none_in) :-
	gi_marshalling_tests_gslist_int_none_in([-1, 0, 1, 2]).

test(gi_marshalling_tests_gslist_utf8_none_in) :-
	gi_marshalling_tests_gslist_utf8_none_in(['0', '1', '2']).

test(gi_marshalling_tests_gslist_utf8_none_out) :-
	gi_marshalling_tests_gslist_utf8_none_out(GSList),
	assertion(GSList == ['0', '1', '2']).

test(gi_marshalling_tests_gslist_utf8_container_out) :-
	gi_marshalling_tests_gslist_utf8_container_out(GSList),
	assertion(GSList == ['0', '1', '2']).

test(gi_marshalling_tests_gslist_utf8_full_out) :-
	gi_marshalling_tests_gslist_utf8_full_out(GSList),
	assertion(GSList == ['0', '1', '2']).

test(gi_marshalling_tests_gslist_utf8_none_inout) :-
	gi_marshalling_tests_gslist_utf8_none_inout(['0', '1', '2'], GSList),
	assertion(GSList == ['-2', '-1', '0', '1']).

test(gi_marshalling_tests_gslist_utf8_container_inout) :-
	gi_marshalling_tests_gslist_utf8_container_inout(['0', '1', '2'], GSList),
	assertion(GSList == ['-2', '-1', '0', '1']).

test(gi_marshalling_tests_gslist_utf8_full_inout) :-
	gi_marshalling_tests_gslist_utf8_full_inout(['0', '1', '2'], GSList),
	assertion(GSList == ['-2', '-1', '0', '1']).

/* error conditions */
test(gi_marshalling_tests_gslist_instantiation_error, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_gslist_utf8_none_in(_).

test(gi_marshalling_tests_gslist_type_error, [throws(error(type_error('list', _), _))]) :-
	gi_marshalling_tests_gslist_utf8_none_in('x').

test(gi_marshalling_tests_gslist_partial_list_type_error, [throws(error(type_error('list', _), _))]) :-
	gi_marshalling_tests_gslist_utf8_none_in(['0', '1', '2'|_]).

test(gi_marshalling_tests_gslist_element_type_error, [throws(error(type_error('atom', _), _))]) :-
	gi_marshalling_tests_gslist_utf8_none_in(['0', '1', 2]).

test(gi_marshalling_tests_gslist_none_in_cleanup, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_gslist_utf8_none_in(['0', '1', _]).

test(gi_marshalling_tests_gslist_container_in_cleanup, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_gslist_utf8_container_inout(['0', '1', _], _).

test(gi_marshalling_tests_gslist_full_in_cleanup, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_gslist_utf8_full_inout(['0', '1', _], _).

test(gi_marshalling_tests_gslist_binding_failure, [fail]) :-
	gi_marshalling_tests_gslist_utf8_full_out('x').

test(gi_marshalling_tests_gslist_too_short_binding_failure, [fail]) :-
	gi_marshalling_tests_gslist_utf8_full_out(['0', '1']).

test(gi_marshalling_tests_gslist_too_long_binding_failure, [fail]) :-
	gi_marshalling_tests_gslist_utf8_full_out(['0', '1', '2', '3']).

test(gi_marshalling_tests_gslist_element_binding_failure, [fail]) :-
	gi_marshalling_tests_gslist_utf8_full_out(['0', '1', 'x']).

:- end_tests(plgi_marshaller_gslist).



/* GHashTable */
:- begin_tests(plgi_marshaller_ghashtable).

test(gi_marshalling_tests_ghashtable_int_none_return) :-
	gi_marshalling_tests_ghashtable_int_none_return(HashTable),
	sort(HashTable, HashTableSorted),
	assertion(HashTableSorted == [(-1 - 1), (0 - 0), (1 - -1), (2 - -2)]).

test(gi_marshalling_tests_ghashtable_utf8_none_return) :-
	gi_marshalling_tests_ghashtable_utf8_none_return(HashTable),
	sort(HashTable, HashTableSorted),
	assertion(HashTableSorted == [('-1' - '1'), ('0' - '0'), ('1' - '-1'), ('2' - '-2')]).

test(gi_marshalling_tests_ghashtable_utf8_container_return) :-
	gi_marshalling_tests_ghashtable_utf8_container_return(HashTable),
	sort(HashTable, HashTableSorted),
	assertion(HashTableSorted == [('-1' - '1'), ('0' - '0'), ('1' - '-1'), ('2' - '-2')]).

test(gi_marshalling_tests_ghashtable_utf8_full_return) :-
	gi_marshalling_tests_ghashtable_utf8_full_return(HashTable),
	sort(HashTable, HashTableSorted),
	assertion(HashTableSorted == [('-1' - '1'), ('0' - '0'), ('1' - '-1'), ('2' - '-2')]).

test(gi_marshalling_tests_ghashtable_int_none_in) :-
	HashTable = [(-1 - 1), (0 - 0), (1 - -1), (2 - -2)],
	gi_marshalling_tests_ghashtable_int_none_in(HashTable).

test(gi_marshalling_tests_ghashtable_utf8_none_in) :-
	HashTable = [('-1' - '1'), ('0' - '0'), ('1' - '-1'), ('2' - '-2')],
	gi_marshalling_tests_ghashtable_utf8_none_in(HashTable).

test(gi_marshalling_tests_ghashtable_utf8_none_out) :-
	gi_marshalling_tests_ghashtable_utf8_none_out(HashTable),
	sort(HashTable, HashTableSorted),
	assertion(HashTableSorted == [('-1' - '1'), ('0' - '0'), ('1' - '-1'), ('2' - '-2')]).

test(gi_marshalling_tests_ghashtable_utf8_container_out) :-
	gi_marshalling_tests_ghashtable_utf8_container_out(HashTable),
	sort(HashTable, HashTableSorted),
	assertion(HashTableSorted == [('-1' - '1'), ('0' - '0'), ('1' - '-1'), ('2' - '-2')]).

test(gi_marshalling_tests_ghashtable_utf8_full_out) :-
	gi_marshalling_tests_ghashtable_utf8_full_out(HashTable),
	sort(HashTable, HashTableSorted),
	assertion(HashTableSorted == [('-1' - '1'), ('0' - '0'), ('1' - '-1'), ('2' - '-2')]).

test(gi_marshalling_tests_ghashtable_utf8_none_inout) :-
	HashTableIn = [('-1' - '1'), ('0' - '0'), ('1' - '-1'), ('2' - '-2')],
	gi_marshalling_tests_ghashtable_utf8_none_inout(HashTableIn, HashTableOut),
	sort(HashTableOut, HashTableOutSorted),
	assertion(HashTableOutSorted == [('-1' - '1'), ('0' - '0'), ('1' - '1')]).

test(gi_marshalling_tests_ghashtable_utf8_container_inout) :-
	HashTableIn = [('-1' - '1'), ('0' - '0'), ('1' - '-1'), ('2' - '-2')],
	gi_marshalling_tests_ghashtable_utf8_container_inout(HashTableIn, HashTableOut),
	sort(HashTableOut, HashTableOutSorted),
	assertion(HashTableOutSorted == [('-1' - '1'), ('0' - '0'), ('1' - '1')]).

test(gi_marshalling_tests_ghashtable_utf8_full_inout) :-
	HashTableIn = [('-1' - '1'), ('0' - '0'), ('1' - '-1'), ('2' - '-2')],
	gi_marshalling_tests_ghashtable_utf8_full_inout(HashTableIn, HashTableOut),
	sort(HashTableOut, HashTableOutSorted),
	assertion(HashTableOutSorted == [('-1' - '1'), ('0' - '0'), ('1' - '1')]).

/* error conditions */
test(gi_marshalling_tests_ghashtable_instantiation_error, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_ghashtable_utf8_none_in(_).

test(gi_marshalling_tests_ghashtable_type_error, [throws(error(type_error('list', _), _))]) :-
	gi_marshalling_tests_ghashtable_utf8_none_in('x').

test(gi_marshalling_tests_ghashtable_partial_list_type_error, [throws(error(type_error('list', _), _))]) :-
	HashTable = [('-1' - '1'), ('0' - '0'), ('1' - '-1'), ('2' - '-2')|_],
	gi_marshalling_tests_ghashtable_utf8_none_in(HashTable).

test(gi_marshalling_tests_ghashtable_key_value_type_error, [throws(error(type_error('key-value pair', _), _))]) :-
	HashTable = [('-1' - '1'), ('0' - '0'), ('1' - '-1'), 'x'],
	gi_marshalling_tests_ghashtable_utf8_none_in(HashTable).

test(gi_marshalling_tests_ghashtable_key_type_error, [throws(error(type_error('atom', _), _))]) :-
	HashTable = [('-1' - '1'), ('0' - '0'), ('1' - '-1'), (2 - '-2')],
	gi_marshalling_tests_ghashtable_utf8_none_in(HashTable).

test(gi_marshalling_tests_ghashtable_value_type_error, [throws(error(type_error('atom', _), _))]) :-
	HashTable = [('-1' - '1'), ('0' - '0'), ('1' - '-1'), ('2' - -2)],
	gi_marshalling_tests_ghashtable_utf8_none_in(HashTable).

test(gi_marshalling_tests_ghashtable_none_in_cleanup, [throws(error(instantiation_error, _))]) :-
	HashTable = [('-1' - '1'), ('0' - '0'), ('1' - '-1'), _],
	gi_marshalling_tests_ghashtable_utf8_none_in(HashTable).

test(gi_marshalling_tests_ghashtable_container_in_cleanup, [throws(error(instantiation_error, _))]) :-
	HashTable = [('-1' - '1'), ('0' - '0'), ('1' - '-1'), _],
	gi_marshalling_tests_ghashtable_utf8_container_inout(HashTable, _).

test(gi_marshalling_tests_ghashtable_full_in_cleanup, [throws(error(instantiation_error, _))]) :-
	HashTable = [('-1' - '1'), ('0' - '0'), ('1' - '-1'), _],
	gi_marshalling_tests_ghashtable_utf8_full_inout(HashTable, _).

test(gi_marshalling_tests_ghashtable_binding_failure, [fail]) :-
	gi_marshalling_tests_ghashtable_utf8_full_out('x').

test(gi_marshalling_tests_ghashtable_too_short_binding_failure, [fail]) :-
	gi_marshalling_tests_ghashtable_utf8_full_out([('-1' - '1'), ('0' - '0'), ('1' - '-1')]).

test(gi_marshalling_tests_ghashtable_too_long_binding_failure, [fail]) :-
	gi_marshalling_tests_ghashtable_utf8_full_out([('-1' - '1'), ('0' - '0'), ('1' - '-1'), ('2' - '-2'), ('3' - '-3')]).

test(gi_marshalling_tests_ghashtable_key_value_binding_failure, [fail]) :-
	gi_marshalling_tests_ghashtable_utf8_full_out([('-1' - '1'), ('0' - '0'), ('1' - '-1'), 'x']).

test(gi_marshalling_tests_ghashtable_key_binding_failure, [fail]) :-
	gi_marshalling_tests_ghashtable_utf8_full_out([('-1' - '1'), ('0' - '0'), ('1' - '-1'), ('x' - '-2')]).

test(gi_marshalling_tests_ghashtable_value_binding_failure, [fail]) :-
	gi_marshalling_tests_ghashtable_utf8_full_out([('-1' - '1'), ('0' - '0'), ('1' - '-1'), ('2' - 'x')]).

:- end_tests(plgi_marshaller_ghashtable).



/* GValue */
:- begin_tests(plgi_marshaller_gvalue).

test(gi_marshalling_tests_gvalue_return) :-
	gi_marshalling_tests_gvalue_return(GValue),
	g_value_get_int(GValue, Value),
	assertion(Value == 42).

test(gi_marshalling_tests_gvalue_in) :-
	g_value_init('gint', GValue),
	g_value_set_int(GValue, 42),
	gi_marshalling_tests_gvalue_in(GValue).

test(gi_marshalling_tests_gvalue_int64_in) :-
	g_value_init('gint64', GValue),
	g_value_set_int64(GValue, 0x7FFFFFFFFFFFFFFF),
	gi_marshalling_tests_gvalue_int64_in(GValue).

test(gi_marshalling_tests_gvalue_in_with_type) :-
	g_value_init('gint', GValue),
	g_value_set_int(GValue, 42),
	gi_marshalling_tests_gvalue_in_with_type(GValue, 'gint').

test(gi_marshalling_tests_gvalue_in_with_modification) :-
	g_value_init('gint', GValue),
	g_value_set_int(GValue, 42),
	gi_marshalling_tests_gvalue_in_with_modification(GValue),
	g_value_get_int(GValue, Value),
	assertion(Value == 24).

test(gi_marshalling_tests_gvalue_in_enum) :-
	g_value_init('GIMarshallingTestsGEnum', GValue),
	g_value_set_enum(GValue, 'GI_MARSHALLING_TESTS_GENUM_VALUE3'),
	gi_marshalling_tests_gvalue_in_enum(GValue).

test(gi_marshalling_tests_gvalue_out) :-
	gi_marshalling_tests_gvalue_out(GValue),
	g_value_get_int(GValue, Value),
	assertion(Value == 42).

test(gi_marshalling_tests_gvalue_int64_out) :-
	gi_marshalling_tests_gvalue_int64_out(GValue),
	g_value_get_int64(GValue, Value),
	assertion(Value == 0x7FFFFFFFFFFFFFFF).

test(gi_marshalling_tests_gvalue_out_caller_allocates) :-
	gi_marshalling_tests_gvalue_out_caller_allocates(GValue),
	g_value_get_int(GValue, Value),
	assertion(Value == 42).

test(gi_marshalling_tests_gvalue_inout) :-
	g_value_init('gint', GValueIn),
	g_value_set_int(GValueIn, 42),
	gi_marshalling_tests_gvalue_inout(GValueIn, GValueOut),
	g_value_get_string(GValueOut, ValueOut),
	assertion(ValueOut == '42').

test(gi_marshalling_tests_gvalue_flat_array) :-
	g_value_init('gint', GValue1),
	g_value_set_int(GValue1, 42),
	g_value_init('gchararray', GValue2),
	g_value_set_string(GValue2, '42'),
	g_value_init('gboolean', GValue3),
	g_value_set_boolean(GValue3, true),
	gi_marshalling_tests_gvalue_flat_array([GValue1, GValue2, GValue3]).

test(gi_marshalling_tests_return_gvalue_flat_array) :-
	gi_marshalling_tests_return_gvalue_flat_array(Array),
	Array = [GValue1, GValue2, GValue3],
	g_value_get_int(GValue1, Value1),
	assertion(Value1 == 42),
	g_value_get_string(GValue2, Value2),
	assertion(Value2 == '42'),
	g_value_get_boolean(GValue3, Value3),
	assertion(Value3 == true).

/* error conditions */
test(gi_marshalling_tests_gvalue_instantiation_error, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_gvalue_in(_).

test(gi_marshalling_tests_gvalue_type_error, [throws(error(type_error('GValue', _), _))]) :-
	gi_marshalling_tests_gvalue_in('x').

test(gi_marshalling_tests_gvalue_gtype_type_error, [throws(error(type_error('atom', _), _))]) :-
	g_value_init(0, _).

test(gi_marshalling_tests_gvalue_gtype_domain_error, [throws(error(domain_error('GType', _), _))]) :-
	g_value_init('x', _).

test(gi_marshalling_tests_gvalue_value_type_error, [throws(error(type_error('32 bit integer', _), _))]) :-
	g_value_init('gint', GValue),
	g_value_set_int(GValue, 'x').

test(gi_marshalling_tests_gvalue_binding_failure, [fail]) :-
	g_value_init('gint', 'x').

test(gi_marshalling_tests_gvalue_value_binding_failure, [fail]) :-
	g_value_init('gint', GValue),
	g_value_get_int(GValue, 'x').

:- end_tests(plgi_marshaller_gvalue).



/* GClosure */
:- begin_tests(plgi_marshaller_gclosure).

test(gi_marshalling_tests_gclosure_in) :-
	gi_marshalling_tests_gclosure_return(Closure),
	gi_marshalling_tests_gclosure_in(Closure).

test(gi_marshalling_tests_gclosure_return) :-
	gi_marshalling_tests_gclosure_return(Closure),
	g_value_init('gint', ReturnValue),
	g_closure_invoke(Closure, ReturnValue, [], {null}),
	g_value_get_int(ReturnValue, Value),
	assertion(Value == 42).

/* error conditions */
test(gi_marshalling_tests_gclosure_instantiation_error, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_gclosure_in(_).

test(gi_marshalling_tests_gclosure_type_error, [throws(error(type_error('GClosure', _), _))]) :-
	gi_marshalling_tests_gclosure_in('x').

test(gi_marshalling_tests_gclosure_binding_failure, [fail]) :-
	gi_marshalling_tests_gclosure_return('x').

:- end_tests(plgi_marshaller_gclosure).



/* Callback */
:- begin_tests(plgi_marshaller_callback).

user:callback_return_value_only(42).
user:callback_one_out_parameter(1.0).
user:callback_multiple_out_parameters(1.0, 2.0).
user:callback_return_value_and_one_out_parameter(1, 2).
user:callback_return_value_and_multiple_out_parameters(1, 2, 3).
user:callback_owned_boxed(_, _).

test(gi_marshalling_tests_callback_return_value_only) :-
	Callback = callback_return_value_only/1,
	gi_marshalling_tests_callback_return_value_only(Callback, Value),
	assertion(Value == 42).

test(gi_marshalling_tests_callback_one_out_parameter) :-
	Callback = callback_one_out_parameter/1,
	gi_marshalling_tests_callback_one_out_parameter(Callback, Value),
	assertion(Value == 1.0).

test(gi_marshalling_tests_callback_multiple_out_parameters) :-
	Callback = callback_multiple_out_parameters/2,
	gi_marshalling_tests_callback_multiple_out_parameters(Callback, Value1, Value2),
	assertion(Value1 == 1.0),
	assertion(Value2 == 2.0).

test(gi_marshalling_tests_callback_return_value_and_one_out_parameter) :-
	Callback = callback_return_value_and_one_out_parameter/2,
	gi_marshalling_tests_callback_return_value_and_one_out_parameter(Callback, Value1, Value2),
	assertion(Value1 == 1),
	assertion(Value2 == 2).

test(gi_marshalling_tests_callback_return_value_and_multiple_out_parameters) :-
	Callback = callback_return_value_and_multiple_out_parameters/3,
	gi_marshalling_tests_callback_return_value_and_multiple_out_parameters(Callback, Value1, Value2, Value3),
	assertion(Value1 == 1),
	assertion(Value2 == 2),
	assertion(Value3 == 3).

test(gi_marshalling_tests_callback_owned_boxed) :-
	Callback = callback_owned_boxed/2,
	gi_marshalling_tests_callback_owned_boxed(Callback, 'foo', Value1),
	gi_marshalling_tests_callback_owned_boxed(Callback, {null}, Value2),
	Value2 =:= Value1 + 1.

/* error conditions */
test(gi_marshalling_tests_callback_instantiation_error, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_callback_return_value_only(_, _).

test(gi_marshalling_tests_callback_type_error, [throws(error(type_error('callback (in name/arity form)', _), _))]) :-
	gi_marshalling_tests_callback_return_value_only(0, _).

test(gi_marshalling_tests_callback_name_type_error, [throws(error(type_error('callback (in name/arity form)', _), _))]) :-
	gi_marshalling_tests_callback_return_value_only(0/1, _).

test(gi_marshalling_tests_callback_arity_type_error, [throws(error(type_error('callback (in name/arity form)', _), _))]) :-
	Callback = callback_return_value_only/'x',
	gi_marshalling_tests_callback_return_value_only(Callback, _).

:- end_tests(plgi_marshaller_callback).



/* GEnum */
:- begin_tests(plgi_marshaller_genum).

test(gi_marshalling_tests_genum_returnv) :-
	gi_marshalling_tests_genum_returnv(Value),
	assertion(Value == 'GI_MARSHALLING_TESTS_GENUM_VALUE3').

test(gi_marshalling_tests_genum_in) :-
	Value = 'GI_MARSHALLING_TESTS_GENUM_VALUE3',
	gi_marshalling_tests_genum_in(Value).

test(gi_marshalling_tests_genum_out) :-
	gi_marshalling_tests_genum_out(Value),
	assertion(Value == 'GI_MARSHALLING_TESTS_GENUM_VALUE3').

test(gi_marshalling_tests_genum_inout) :-
	ValueIn = 'GI_MARSHALLING_TESTS_GENUM_VALUE3',
	gi_marshalling_tests_genum_inout(ValueIn, ValueOut),
	assertion(ValueOut == 'GI_MARSHALLING_TESTS_GENUM_VALUE1').

/* error conditions */
test(gi_marshalling_tests_genum_instantiation_error, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_genum_in(_).

test(gi_marshalling_tests_genum_type_error, [throws(error(type_error('GIMarshallingTestsGEnum', _), _))]) :-
	gi_marshalling_tests_genum_in(0).

test(gi_marshalling_tests_genum_domain_error, [throws(error(domain_error('GIMarshallingTestsGEnum', _), _))]) :-
	gi_marshalling_tests_genum_in('x').

test(gi_marshalling_tests_genum_binding_failure, [fail]) :-
	gi_marshalling_tests_genum_out('x').


:- end_tests(plgi_marshaller_genum).



/* Enums */
:- begin_tests(plgi_marshaller_enum).

test(gi_marshalling_tests_enum_returnv) :-
	gi_marshalling_tests_enum_returnv(Value),
	assertion(Value == 'GI_MARSHALLING_TESTS_ENUM_VALUE3').

test(gi_marshalling_tests_enum_in) :-
	Value = 'GI_MARSHALLING_TESTS_ENUM_VALUE3',
	gi_marshalling_tests_enum_in(Value).

test(gi_marshalling_tests_enum_out) :-
	gi_marshalling_tests_enum_out(Value),
	assertion(Value == 'GI_MARSHALLING_TESTS_ENUM_VALUE3').

test(gi_marshalling_tests_enum_inout) :-
	ValueIn = 'GI_MARSHALLING_TESTS_ENUM_VALUE3',
	gi_marshalling_tests_enum_inout(ValueIn, ValueOut),
	assertion(ValueOut == 'GI_MARSHALLING_TESTS_ENUM_VALUE1').

/* error conditions */
test(gi_marshalling_tests_enum_instantiation_error, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_enum_in(_).

test(gi_marshalling_tests_enum_type_error, [throws(error(type_error('GIMarshallingTestsEnum', _), _))]) :-
	gi_marshalling_tests_enum_in(0).

test(gi_marshalling_tests_enum_domain_error, [throws(error(domain_error('GIMarshallingTestsEnum', _), _))]) :-
	gi_marshalling_tests_enum_in('x').

test(gi_marshalling_tests_enum_binding_failure, [fail]) :-
	gi_marshalling_tests_enum_out('x').

:- end_tests(plgi_marshaller_enum).



/* Flags */
:- begin_tests(plgi_marshaller_flags).

test(gi_marshalling_tests_flags_returnv) :-
	gi_marshalling_tests_flags_returnv(Flags),
	assertion(Flags == ['GI_MARSHALLING_TESTS_FLAGS_VALUE2']).

test(gi_marshalling_tests_flags_in) :-
	Flags = ['GI_MARSHALLING_TESTS_FLAGS_VALUE2'],
	gi_marshalling_tests_flags_in(Flags).

test(gi_marshalling_tests_flags_in_zero) :-
	gi_marshalling_tests_flags_in_zero([]).

test(gi_marshalling_tests_flags_out) :-
	gi_marshalling_tests_flags_out(Flags),
	assertion(Flags == ['GI_MARSHALLING_TESTS_FLAGS_VALUE2']).

test(gi_marshalling_tests_flags_inout) :-
	FlagsIn = ['GI_MARSHALLING_TESTS_FLAGS_VALUE2'],
	gi_marshalling_tests_flags_inout(FlagsIn, FlagsOut),
	assertion(FlagsOut == ['GI_MARSHALLING_TESTS_FLAGS_VALUE1']).

test(gi_marshalling_tests_no_type_flags_returnv) :-
	gi_marshalling_tests_no_type_flags_returnv(Flags),
	assertion(Flags == ['GI_MARSHALLING_TESTS_NO_TYPE_FLAGS_VALUE2']).

test(gi_marshalling_tests_no_type_flags_in) :-
	Flags = ['GI_MARSHALLING_TESTS_NO_TYPE_FLAGS_VALUE2'],
	gi_marshalling_tests_no_type_flags_in(Flags).

test(gi_marshalling_tests_no_type_flags_in_zero) :-
	gi_marshalling_tests_no_type_flags_in_zero([]).

test(gi_marshalling_tests_no_type_flags_out) :-
	gi_marshalling_tests_no_type_flags_out(Flags),
	assertion(Flags == ['GI_MARSHALLING_TESTS_NO_TYPE_FLAGS_VALUE2']).

test(gi_marshalling_tests_no_type_flags_inout) :-
	FlagsIn = ['GI_MARSHALLING_TESTS_NO_TYPE_FLAGS_VALUE2'],
	gi_marshalling_tests_no_type_flags_inout(FlagsIn, FlagsOut),
	assertion(FlagsOut == ['GI_MARSHALLING_TESTS_NO_TYPE_FLAGS_VALUE1']).

/* error conditions */
test(gi_marshalling_tests_flags_instantiation_error, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_flags_in(_).

test(gi_marshalling_tests_flags_type_error, [throws(error(type_error(list, _), _))]) :-
	gi_marshalling_tests_flags_in(0).

test(gi_marshalling_tests_flags_partial_list_type_error, [throws(error(type_error('list', _), _))]) :-
	gi_marshalling_tests_flags_in(['GI_MARSHALLING_TESTS_FLAGS_VALUE2'|_]).

test(gi_marshalling_tests_flags_element_type_error, [throws(error(type_error('GIMarshallingTestsFlags', _), _))]) :-
	gi_marshalling_tests_flags_in([0]).

test(gi_marshalling_tests_flags_domain_error, [throws(error(domain_error('GIMarshallingTestsFlags', _), _))]) :-
	gi_marshalling_tests_flags_in(['x']).

test(gi_marshalling_tests_flags_binding_failure, [fail]) :-
	gi_marshalling_tests_flags_out('x').

test(gi_marshalling_tests_flags_too_short_binding_failure, [fail]) :-
	gi_marshalling_tests_flags_out([]).

test(gi_marshalling_tests_flags_too_long_binding_failure, [fail]) :-
	gi_marshalling_tests_flags_out(['GI_MARSHALLING_TESTS_FLAGS_VALUE2', 'x']).

test(gi_marshalling_tests_flags_element_binding_failure, [fail]) :-
	gi_marshalling_tests_flags_out(['x']).

:- end_tests(plgi_marshaller_flags).



/* struct */
:- begin_tests(plgi_marshaller_struct).

test(gi_marshalling_tests_simple_struct_returnv) :-
	gi_marshalling_tests_simple_struct_returnv(Struct),
	plgi_struct_term(Struct, StructTerm),
	assertion(StructTerm == 'GIMarshallingTestsSimpleStruct'( 'long_'=6, 'int8'=7 )).

test(gi_marshalling_tests_simple_struct_inv) :-
	StructTerm = 'GIMarshallingTestsSimpleStruct'( 'long_'=6, 'int8'=7 ),
	plgi_struct_new(StructTerm, Struct),
	gi_marshalling_tests_simple_struct_inv(Struct).

test(gi_marshalling_tests_simple_struct_method) :-
	StructTerm = 'GIMarshallingTestsSimpleStruct'( 'long_'=6, 'int8'=7 ),
	plgi_struct_new(StructTerm, Struct),
	gi_marshalling_tests_simple_struct_method(Struct).

test(gi_marshalling_tests_pointer_struct_get_type) :-
	gi_marshalling_tests_pointer_struct_get_type(Type),
	assertion(Type == 'GIMarshallingTestsPointerStruct').

test(gi_marshalling_tests_pointer_struct_returnv) :-
	gi_marshalling_tests_pointer_struct_returnv(Struct),
	plgi_struct_term(Struct, StructTerm),
	assertion(StructTerm == 'GIMarshallingTestsPointerStruct'( 'long_'=42 )).

test(gi_marshalling_tests_pointer_struct_inv) :-
	StructTerm = 'GIMarshallingTestsPointerStruct'( 'long_'=42 ),
	plgi_struct_new(StructTerm, Struct),
	gi_marshalling_tests_pointer_struct_inv(Struct).

test(gi_marshalling_tests_boxed_struct_new) :-
	gi_marshalling_tests_boxed_struct_new(Struct),
	plgi_struct_term(Struct, StructTerm),
	assertion(StructTerm == 'GIMarshallingTestsBoxedStruct'( 'long_'=0, 'string_'={null}, 'g_strv'=[] )).

test(gi_marshalling_tests_boxed_struct_returnv) :-
	gi_marshalling_tests_boxed_struct_returnv(Struct),
	plgi_struct_term(Struct, StructTerm),
	assertion(StructTerm == 'GIMarshallingTestsBoxedStruct'( 'long_'=42, 'string_'='hello', 'g_strv'=['0', '1', '2'] )).

test(gi_marshalling_tests_boxed_struct_inv) :-
	StructTerm = 'GIMarshallingTestsBoxedStruct'( 'long_'=42, 'string_'='hello', 'g_strv'=['0', '1', '2'] ),
	plgi_struct_new(StructTerm, Struct),
	gi_marshalling_tests_boxed_struct_inv(Struct).

test(gi_marshalling_tests_boxed_struct_out) :-
	gi_marshalling_tests_boxed_struct_out(Struct),
	plgi_struct_term(Struct, StructTerm),
	assertion(StructTerm == 'GIMarshallingTestsBoxedStruct'( 'long_'=42, 'string_'={null}, 'g_strv'=[] )).

test(gi_marshalling_tests_boxed_struct_inout) :-
	StructTermIn = 'GIMarshallingTestsBoxedStruct'( 'long_'=42, 'string_'='hello', 'g_strv'=['0', '1', '2'] ),
	plgi_struct_new(StructTermIn, StructIn),
	gi_marshalling_tests_boxed_struct_inout(StructIn, StructOut),
	plgi_struct_term(StructOut, StructOutTerm),
	assertion(StructOutTerm == 'GIMarshallingTestsBoxedStruct'( 'long_'=0, 'string_'={null}, 'g_strv'=[] )).

/* error conditions */
test(gi_marshalling_tests_struct_instantiation_error, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_simple_struct_inv(_).

test(gi_marshalling_tests_struct_type_error, [throws(error(type_error('GIMarshallingTestsSimpleStruct', _), _))]) :-
	gi_marshalling_tests_simple_struct_inv('x').

test(gi_marshalling_tests_struct_field_type_error, [throws(error(type_error('struct field', _), _))]) :-
	StructTerm = 'GIMarshallingTestsSimpleStruct'( 'long_'=6, 'x' ),
	plgi_struct_new(StructTerm, _).

test(gi_marshalling_tests_struct_field_name_type_error, [throws(error(type_error('atom', _), _))]) :-
	StructTerm = 'GIMarshallingTestsSimpleStruct'( 'long_'=6, 0=7 ),
	plgi_struct_new(StructTerm, _).

test(gi_marshalling_tests_struct_field_name_domain_error, [throws(error(domain_error('struct field name', _), _))]) :-
	StructTerm = 'GIMarshallingTestsSimpleStruct'( 'long_'=6, 'x'=7 ),
	plgi_struct_new(StructTerm, _).

test(gi_marshalling_tests_struct_field_value_type_error, [throws(error(type_error('8 bit integer', _), _))]) :-
	StructTerm = 'GIMarshallingTestsSimpleStruct'( 'long_'=6, 'int8'='x' ),
	plgi_struct_new(StructTerm, _).

test(gi_marshalling_tests_struct_binding_failure, [fail]) :-
	gi_marshalling_tests_simple_struct_returnv('x').

test(gi_marshalling_tests_struct_too_short_binding_failure, [fail]) :-
	gi_marshalling_tests_simple_struct_returnv('GIMarshallingTestsSimpleStruct'( 'long_'=6 )).

test(gi_marshalling_tests_struct_too_long_binding_failure, [fail]) :-
	gi_marshalling_tests_simple_struct_returnv('GIMarshallingTestsSimpleStruct'( 'long_'=6, 'int8'=7, 'x'=0 )).

test(gi_marshalling_tests_struct_field_binding_failure, [fail]) :-
	gi_marshalling_tests_simple_struct_returnv('GIMarshallingTestsSimpleStruct'( 'long_'=6, 'x' )).

test(gi_marshalling_tests_struct_field_name_binding_failure, [fail]) :-
	gi_marshalling_tests_simple_struct_returnv('GIMarshallingTestsSimpleStruct'( 'long_'=6, 'x'=7 )).

test(gi_marshalling_tests_struct_field_value_binding_failure, [fail]) :-
	gi_marshalling_tests_simple_struct_returnv('GIMarshallingTestsSimpleStruct'( 'long_'=6, 'int8'=0 )).

:- end_tests(plgi_marshaller_struct).



:- begin_tests(plgi_marshaller_union).

test(gi_marshalling_tests_union_returnv) :-
	gi_marshalling_tests_union_returnv(Union),
	plgi_union_get_field(Union, 'long_', Value),
	assertion(Value == 42).

test(gi_marshalling_tests_union_inv) :-
	UnionTerm = 'GIMarshallingTestsUnion'( 'long_'=42 ),
	plgi_union_new(UnionTerm, Union),
	gi_marshalling_tests_union_inv(Union).

test(gi_marshalling_tests_union_method) :-
	UnionTerm = 'GIMarshallingTestsUnion'( 'long_'=42 ),
	plgi_union_new(UnionTerm, Union),
	gi_marshalling_tests_union_method(Union).

/* error conditions */
test(gi_marshalling_tests_union_instantiation_error, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_union_inv(_).

test(gi_marshalling_tests_union_type_error, [throws(error(type_error('GIMarshallingTestsUnion', _), _))]) :-
	gi_marshalling_tests_union_inv('x').

test(gi_marshalling_tests_union_field_type_error, [throws(error(type_error('union field', _), _))]) :-
	UnionTerm = 'GIMarshallingTestsUnion'( 'x' ),
	plgi_union_new(UnionTerm, _).

test(gi_marshalling_tests_union_field_name_type_error, [throws(error(type_error('atom', _), _))]) :-
	UnionTerm = 'GIMarshallingTestsUnion'( 0=42 ),
	plgi_union_new(UnionTerm, _).

test(gi_marshalling_tests_union_field_name_domain_error, [throws(error(domain_error('union field name', _), _))]) :-
	UnionTerm = 'GIMarshallingTestsUnion'( 'x'=42 ),
	plgi_union_new(UnionTerm, _).

test(gi_marshalling_tests_union_field_value_type_error, [throws(error(type_error('64 bit integer', _), _))]) :-
	UnionTerm = 'GIMarshallingTestsUnion'( 'long_'='x' ),
	plgi_union_new(UnionTerm, _).

test(gi_marshalling_tests_union_multiple_fields_type_error, [throws(error(type_error('union', _), _))]) :-
	UnionTerm = 'GIMarshallingTestsUnion'( 'long_'=42, 'long_'=42 ),
	plgi_union_new(UnionTerm, _).

test(gi_marshalling_tests_union_binding_failure, [fail]) :-
	gi_marshalling_tests_union_returnv('x').

test(gi_marshalling_tests_union_field_binding_failure, [fail]) :-
	gi_marshalling_tests_union_returnv(Union),
	plgi_union_get_field(Union, 'long_', 'x').

:- end_tests(plgi_marshaller_union).



/* Objects */
:- begin_tests(plgi_marshaller_object).

test(gi_marshalling_tests_object_method) :-
	gi_marshalling_tests_object_new(42, Object),
	gi_marshalling_tests_object_method(Object).

test(gi_marshalling_tests_object_new) :-
	gi_marshalling_tests_object_new(42, Object),
	g_object_type(Object, ObjectType),
	assertion(g_type_is_a(ObjectType, 'GIMarshallingTestsObject', true)).

test(gi_marshalling_tests_object_method_array_in) :-
	gi_marshalling_tests_object_new(42, Object),
	gi_marshalling_tests_object_method_array_in(Object, [-1, 0, 1, 2]).

test(gi_marshalling_tests_object_method_array_out) :-
	gi_marshalling_tests_object_new(42, Object),
	gi_marshalling_tests_object_method_array_out(Object, Array),
	assertion(Array == [-1, 0, 1, 2]).

test(gi_marshalling_tests_object_method_array_inout) :-
	gi_marshalling_tests_object_new(42, Object),
	gi_marshalling_tests_object_method_array_inout(Object, [-1, 0, 1, 2], Array),
	assertion(Array == [-2, -1, 0, 1, 2]).

test(gi_marshalling_tests_object_method_array_return) :-
	gi_marshalling_tests_object_new(42, Object),
	gi_marshalling_tests_object_method_array_return(Object, Array),
	assertion(Array == [-1, 0, 1, 2]).

test(gi_marshalling_tests_object_none_return) :-
	gi_marshalling_tests_object_none_return(Object),
	g_object_type(Object, ObjectType),
	assertion(g_type_is_a(ObjectType, 'GIMarshallingTestsObject', true)).

test(gi_marshalling_tests_object_full_return) :-
	gi_marshalling_tests_object_full_return(Object),
	g_object_type(Object, ObjectType),
	assertion(g_type_is_a(ObjectType, 'GIMarshallingTestsObject', true)).

test(gi_marshalling_tests_object_none_in) :-
	gi_marshalling_tests_object_new(42, Object),
	gi_marshalling_tests_object_none_in(Object).

test(gi_marshalling_tests_object_none_out) :-
	gi_marshalling_tests_object_none_out(Object),
	g_object_type(Object, ObjectType),
	assertion(g_type_is_a(ObjectType, 'GIMarshallingTestsObject', true)).

test(gi_marshalling_tests_object_full_out) :-
	gi_marshalling_tests_object_full_out(Object),
	g_object_type(Object, ObjectType),
	assertion(g_type_is_a(ObjectType, 'GIMarshallingTestsObject', true)).

test(gi_marshalling_tests_object_none_inout) :-
	gi_marshalling_tests_object_new(42, ObjectIn),
	gi_marshalling_tests_object_none_inout(ObjectIn, ObjectOut),
	g_object_type(ObjectOut, ObjectType),
	assertion(g_type_is_a(ObjectType, 'GIMarshallingTestsObject', true)).

test(gi_marshalling_tests_object_full_inout) :-
	gi_marshalling_tests_object_new(42, ObjectIn),
	gi_marshalling_tests_object_full_inout(ObjectIn, ObjectOut),
	g_object_type(ObjectOut, ObjectType),
	assertion(g_type_is_a(ObjectType, 'GIMarshallingTestsObject', true)).

/* error conditions */
test(gi_marshalling_tests_object_instantiation_error, [throws(error(instantiation_error, _))]) :-
	gi_marshalling_tests_object_none_in(_).

test(gi_marshalling_tests_object_type_error, [throws(error(type_error('GIMarshallingTestsObject', _), _))]) :-
	gi_marshalling_tests_object_none_in('x').

test(gi_marshalling_tests_object_object_type_error, [throws(error(type_error('GIMarshallingTestsObject', _), _))]) :-
	gi_marshalling_tests_properties_object_new(Object),
	gi_marshalling_tests_object_none_in(Object).

test(gi_marshalling_tests_object_binding_failure, [fail]) :-
	gi_marshalling_tests_object_full_return('x').

:- end_tests(plgi_marshaller_object).



:- begin_tests(plgi_marshaller_interface).

test(gi_marshalling_tests_interface_test_int8_in) :-
	g_object_new('GIMarshallingTestsInterfaceImpl', [], Object),
	gi_marshalling_tests_interface_test_int8_in(Object, 42).

test(gi_marshalling_tests_test_interface_test_int8_in) :-
	g_object_new('GIMarshallingTestsInterfaceImpl', [], Object),
	gi_marshalling_tests_test_interface_test_int8_in(Object, 42).

test(gi_marshalling_tests_interface_impl_get_as_interface) :-
	g_object_new('GIMarshallingTestsInterfaceImpl', [], Object),
	gi_marshalling_tests_test_interface_test_int8_in(Object, 42),
	gi_marshalling_tests_interface_impl_get_as_interface(Object, Interface),
	g_object_type(Interface, ObjectType),
	assertion(g_type_is_a(ObjectType, 'GIMarshallingTestsInterface', true)).

/* error conditions */
/* FIXME: add error condition tests */

:- end_tests(plgi_marshaller_interface).



/* Arg Order */
:- begin_tests(plgi_marshaller_arg_order).

test(gi_marshalling_tests_int_out_out) :-
	gi_marshalling_tests_int_out_out(Value1, Value2),
	assertion(Value1 == 6),
	assertion(Value2 == 7).

test(gi_marshalling_tests_int_three_in_three_out) :-
	gi_marshalling_tests_int_three_in_three_out(-1, 0, 1, Value1, Value2, Value3),
	assertion(Value1 == -1),
	assertion(Value2 == 0),
	assertion(Value3 == 1).

test(gi_marshalling_tests_int_return_out) :-
	gi_marshalling_tests_int_return_out(Value1, Value2),
	assertion(Value1 == 7),
	assertion(Value2 == 6).

test(gi_marshalling_tests_int_two_in_utf8_two_in_with_allow_none) :-
	gi_marshalling_tests_int_two_in_utf8_two_in_with_allow_none(1, 2, '3', {null}).

test(gi_marshalling_tests_int_one_in_utf8_two_in_one_allows_none) :-
	gi_marshalling_tests_int_one_in_utf8_two_in_one_allows_none(1, {null}, '3').

test(gi_marshalling_tests_array_in_utf8_two_in) :-
	gi_marshalling_tests_array_in_utf8_two_in([-1, 0, 1, 2], '1', {null}).

test(gi_marshalling_tests_array_in_utf8_two_in_out_of_order) :-
	gi_marshalling_tests_array_in_utf8_two_in_out_of_order('1', [-1, 0, 1, 2], {null}).

:- end_tests(plgi_marshaller_arg_order).



/* GError */
:- begin_tests(plgi_marshaller_gerror).

test(gi_marshalling_tests_gerror, [throws(error(glib_error('gi-marshalling-tests-gerror-domain', 5, 'gi-marshalling-tests-gerror-message'), _))]) :-
	gi_marshalling_tests_gerror.

test(gi_marshalling_tests_gerror_array_in, [throws(error(glib_error('gi-marshalling-tests-gerror-domain', 5, 'gi-marshalling-tests-gerror-message'), _))]) :-
	gi_marshalling_tests_gerror_array_in([-1, 0, 1, 2]).

test(gi_marshalling_tests_gerror_out) :-
	gi_marshalling_tests_gerror_out(Error, Debug),
	Error = error(glib_error('gi-marshalling-tests-gerror-domain', 5, 'gi-marshalling-tests-gerror-message'), _),
	assertion(Debug == 'we got an error, life is shit').

test(gi_marshalling_tests_gerror_out_transfer_none) :-
	gi_marshalling_tests_gerror_out_transfer_none(Error, Debug),
	Error = error(glib_error('gi-marshalling-tests-gerror-domain', 5, 'gi-marshalling-tests-gerror-message'), _),
	assertion(Debug == 'we got an error, life is shit').

test(gi_marshalling_tests_gerror_return, [throws(error(glib_error('gi-marshalling-tests-gerror-domain', 5, 'gi-marshalling-tests-gerror-message'), _))]) :-
	gi_marshalling_tests_gerror_return.

/* error conditions */
/* FIXME: add error condition tests */

:- end_tests(plgi_marshaller_gerror).



:- begin_tests(plgi_marshaller_overrides).

gi_marshalling_tests_overrides_struct_new(Value, Struct) :-
	'GIMarshallingTests':gi_marshalling_tests_overrides_struct_new(Struct),
	plgi_struct_set_field(Struct, 'long_', Value).

gi_marshalling_tests_overrides_struct_method(Struct, OverridenValue) :-
	'GIMarshallingTests':gi_marshalling_tests_overrides_struct_method(Struct, Value),
	OverridenValue is Value / 7.

gi_marshalling_tests_overrides_object_new(_Value, Object) :-
	'GIMarshallingTests':gi_marshalling_tests_overrides_object_new(Object).

gi_marshalling_tests_overrides_object_method(Object, OverridenValue) :-
	'GIMarshallingTests':gi_marshalling_tests_overrides_object_method(Object, Value),
	OverridenValue is Value / 7.

test(gi_marshalling_tests_overrides_struct_new) :-
	gi_marshalling_tests_overrides_struct_new(42, Struct),
	plgi_struct_term(Struct, StructTerm),
	assertion(StructTerm == 'GIMarshallingTestsOverridesStruct'( 'long_'=42 )).

test(gi_marshalling_tests_overrides_struct_method) :-
	gi_marshalling_tests_overrides_struct_new(Struct),
	gi_marshalling_tests_overrides_struct_method(Struct, Value),
	assertion(Value == 6).

test(gi_marshalling_tests_overrides_struct_returnv) :-
	gi_marshalling_tests_overrides_struct_returnv(Struct),
	plgi_struct_term(Struct, StructTerm),
	assertion(StructTerm = 'GIMarshallingTestsOverridesStruct'( 'long_'=_ )).

test(gi_marshalling_tests_overrides_object_new) :-
	gi_marshalling_tests_overrides_object_new(42, Object),
	g_object_type(Object, ObjectType),
	assertion(g_type_is_a(ObjectType, 'GIMarshallingTestsOverridesObject', true)).

test(gi_marshalling_tests_overrides_object_method) :-
	gi_marshalling_tests_overrides_object_new(Object),
	gi_marshalling_tests_overrides_object_method(Object, Value),
	assertion(Value == 6).

test(gi_marshalling_tests_overrides_object_returnv) :-
	gi_marshalling_tests_overrides_object_returnv(Object),
	g_object_type(Object, ObjectType),
	assertion(g_type_is_a(ObjectType, 'GIMarshallingTestsOverridesObject', true)).

/* error conditions */
/* FIXME: add error condition tests */

:- end_tests(plgi_marshaller_overrides).



/* filename */
:- begin_tests(plgi_marshaller_filename).

mkdtemp(TempDir) :-
	tmp_file('plgi', TempDir),
	make_directory(TempDir).

rmtree(TempDir) :-
	format(atom(WildCard), '~w/*', [TempDir]),
	expand_file_name(WildCard, TempFiles),
	forall(member(TempFile, TempFiles),
	       delete_file(TempFile)),
	delete_directory(TempDir).

test(gi_marshalling_tests_filename_list_return) :-
	gi_marshalling_tests_filename_list_return(List),
	assertion(List == []).

test(gi_marshalling_tests_utf8_to_filename, [ setup(( setlocale(all, OldLocale, 'en_US.utf-8'),
                                                      setenv('G_FILENAME_ENCODING', 'ISO-8859-1')
                                                   )),
                                              cleanup(( setlocale(all, _, OldLocale),
                                                        unsetenv('G_FILENAME_ENCODING')
                                                     ))
                                            ]) :-
	UTF8 = 'testäø.txt',
	g_filename_from_utf8(UTF8, -1, BytesRead, BytesWritten, Filename),
	assertion(BytesRead == 12),
	assertion(BytesWritten == 10),
	atom_codes(Filename, FilenameCodes),
	assertion(FilenameCodes == [116,101,115,116,228,248,46,116,120,116]).

test(gi_marshalling_tests_filename_to_utf8, [ setup(( setlocale(all, OldLocale, 'en_US.utf-8'),
                                                      setenv('G_FILENAME_ENCODING', 'ISO-8859-1')
                                                   )),
                                              cleanup(( setlocale(all, _, OldLocale),
                                                        unsetenv('G_FILENAME_ENCODING')
                                                     ))
                                            ]) :-
	Filename = 'testäø.txt',
	g_filename_to_utf8(Filename, -1, BytesRead, BytesWritten, UTF8),
	assertion(BytesRead == 10),
	assertion(BytesWritten == 12),
	atom_codes(UTF8, UTF8Codes),
	assertion(UTF8Codes == [116,101,115,116,228,248,46,116,120,116]).

/* error conditions */
test(gi_marshalling_tests_filename_instantiation_error, [throws(error(instantiation_error, _))]) :-
	g_file_get_contents(_, _, _).

test(gi_marshalling_tests_filename_type_error, [throws(error(type_error('atom', _), _))]) :-
	g_file_get_contents(0, _, _).

:- end_tests(plgi_marshaller_filename).



:- begin_tests(plgi_marshaller_gparamspec).

test(gi_marshalling_tests_param_spec_in_bool, [condition(glib_check_version(2, 41, 1, {null}))]) :-
	g_param_spec_boolean('mybool', 'bool nick', 'bool blurb', true, ['G_PARAM_READABLE'], GParamSpec),
        gi_marshalling_tests_param_spec_in_bool(GParamSpec).

test(gi_marshalling_tests_param_spec_return) :-
	gi_marshalling_tests_param_spec_return(ParamSpec),
	g_param_spec_get_name(ParamSpec, Name),
	assertion(Name == 'test-param'),
	g_param_spec_get_nick(ParamSpec, Nick),
	assertion(Nick == 'test'),
	g_param_spec_get_blurb(ParamSpec, Blurb),
	assertion(Blurb == 'This is a test'),
	g_param_spec_get_default_value(ParamSpec, DefaultValue),
	g_value_get_string(DefaultValue, String),
	assertion(String == '42'),
	g_param_spec_value_type(ParamSpec, ValueType),
	assertion(ValueType == 'gchararray').

test(gi_marshalling_tests_param_spec_out) :-
	gi_marshalling_tests_param_spec_out(ParamSpec),
	g_param_spec_get_name(ParamSpec, Name),
	assertion(Name == 'test-param'),
	g_param_spec_get_nick(ParamSpec, Nick),
	assertion(Nick == 'test'),
	g_param_spec_get_blurb(ParamSpec, Blurb),
	assertion(Blurb == 'This is a test'),
	g_param_spec_get_default_value(ParamSpec, DefaultValue),
	g_value_get_string(DefaultValue, String),
	assertion(String == '42'),
	g_param_spec_value_type(ParamSpec, ValueType),
	assertion(ValueType == 'gchararray').

/* error conditions */
/* FIXME: add error condition tests */

:- end_tests(plgi_marshaller_gparamspec).



/* Object properties */
:- begin_tests(plgi_marshaller_object_properties).

test(gi_marshalling_tests_properties_object_get_boolean_property) :-
	gi_marshalling_tests_properties_object_new(Object),
	g_object_get_property(Object, 'some-boolean', Property),
	assertion(Property == false).

test(gi_marshalling_tests_properties_object_get_char_property) :-
	gi_marshalling_tests_properties_object_new(Object),
	g_object_get_property(Object, 'some-char', Property),
	assertion(Property == 0).

test(gi_marshalling_tests_properties_object_get_uchar_property) :-
	gi_marshalling_tests_properties_object_new(Object),
	g_object_get_property(Object, 'some-uchar', Property),
	assertion(Property == 0).

test(gi_marshalling_tests_properties_object_get_int_property) :-
	gi_marshalling_tests_properties_object_new(Object),
	g_object_get_property(Object, 'some-int', Property),
	assertion(Property == 0).

test(gi_marshalling_tests_properties_object_get_uint_property) :-
	gi_marshalling_tests_properties_object_new(Object),
	g_object_get_property(Object, 'some-uint', Property),
	assertion(Property == 0).

test(gi_marshalling_tests_properties_object_get_long_property) :-
	gi_marshalling_tests_properties_object_new(Object),
	g_object_get_property(Object, 'some-long', Property),
	assertion(Property == 0).

test(gi_marshalling_tests_properties_object_get_ulong_property) :-
	gi_marshalling_tests_properties_object_new(Object),
	g_object_get_property(Object, 'some-ulong', Property),
	assertion(Property == 0).

test(gi_marshalling_tests_properties_object_get_int64_property) :-
	gi_marshalling_tests_properties_object_new(Object),
	g_object_get_property(Object, 'some-int64', Property),
	assertion(Property == 0).

test(gi_marshalling_tests_properties_object_get_uint64_property) :-
	gi_marshalling_tests_properties_object_new(Object),
	g_object_get_property(Object, 'some-uint64', Property),
	assertion(Property == 0).

test(gi_marshalling_tests_properties_object_get_float_property) :-
	gi_marshalling_tests_properties_object_new(Object),
	g_object_get_property(Object, 'some-float', Property),
	assertion(Property == 0.0).

test(gi_marshalling_tests_properties_object_get_double_property) :-
	gi_marshalling_tests_properties_object_new(Object),
	g_object_get_property(Object, 'some-double', Property),
	assertion(Property == 0.0).

test(gi_marshalling_tests_properties_object_get_strv_property) :-
	gi_marshalling_tests_properties_object_new(Object),
	g_object_get_property(Object, 'some-strv', Property),
	assertion(Property == []).

test(gi_marshalling_tests_properties_object_get_boxed_struct_property) :-
	gi_marshalling_tests_properties_object_new(Object),
	g_object_get_property(Object, 'some-boxed-struct', Property),
	assertion(Property == {null}).

test(gi_marshalling_tests_properties_object_get_variant_property) :-
	gi_marshalling_tests_properties_object_new(Object),
	g_object_get_property(Object, 'some-variant', Property),
	assertion(Property == {null}).

test(gi_marshalling_tests_properties_object_get_boxed_glist_property) :-
	gi_marshalling_tests_properties_object_new(Object),
	g_object_get_property(Object, 'some-boxed-glist', Property),
	assertion(Property == []).

test(gi_marshalling_tests_properties_object_get_object_property) :-
	gi_marshalling_tests_properties_object_new(Object),
	g_object_get_property(Object, 'some-object', Property),
	assertion(Property == {null}).

test(gi_marshalling_tests_properties_object_set_boolean_property) :-
	gi_marshalling_tests_properties_object_new(Object),
	g_object_set_property(Object, 'some-boolean', true),
	g_object_get_property(Object, 'some-boolean', Property),
	assertion(Property == true).

test(gi_marshalling_tests_properties_object_set_char_property) :-
	gi_marshalling_tests_properties_object_new(Object),
	g_object_set_property(Object, 'some-char', 1),
	g_object_get_property(Object, 'some-char', Property),
	assertion(Property == 1).

test(gi_marshalling_tests_properties_object_set_uchar_property) :-
	gi_marshalling_tests_properties_object_new(Object),
	g_object_set_property(Object, 'some-uchar', 255),
	g_object_get_property(Object, 'some-uchar', Property),
	assertion(Property == 255).

test(gi_marshalling_tests_properties_object_set_int_property) :-
	gi_marshalling_tests_properties_object_new(Object),
	g_object_set_property(Object, 'some-int', 1),
	g_object_get_property(Object, 'some-int', Property),
	assertion(Property == 1).

test(gi_marshalling_tests_properties_object_set_uint_property) :-
	gi_marshalling_tests_properties_object_new(Object),
	g_object_set_property(Object, 'some-uint', 0xFFFFFFFF),
	g_object_get_property(Object, 'some-uint', Property),
	assertion(Property == 0xFFFFFFFF).

test(gi_marshalling_tests_properties_object_set_long_property) :-
	gi_marshalling_tests_properties_object_new(Object),
	g_object_set_property(Object, 'some-long', 1),
	g_object_get_property(Object, 'some-long', Property),
	assertion(Property == 1).

test(gi_marshalling_tests_properties_object_set_ulong_property) :-
	gi_marshalling_tests_properties_object_new(Object),
	g_object_set_property(Object, 'some-ulong', 0xFFFFFFFFFFFFFFFF),
	g_object_get_property(Object, 'some-ulong', Property),
	assertion(Property == 0xFFFFFFFFFFFFFFFF).

test(gi_marshalling_tests_properties_object_set_int64_property) :-
	gi_marshalling_tests_properties_object_new(Object),
	g_object_set_property(Object, 'some-int64', 1),
	g_object_get_property(Object, 'some-int64', Property),
	assertion(Property == 1).

test(gi_marshalling_tests_properties_object_set_uint64_property) :-
	gi_marshalling_tests_properties_object_new(Object),
	g_object_set_property(Object, 'some-uint64', 0xFFFFFFFFFFFFFFFF),
	g_object_get_property(Object, 'some-uint64', Property),
	assertion(Property == 0xFFFFFFFFFFFFFFFF).

test(gi_marshalling_tests_properties_object_set_float_property) :-
	gi_marshalling_tests_properties_object_new(Object),
	g_object_set_property(Object, 'some-float', 1.0),
	g_object_get_property(Object, 'some-float', Property),
	assertion(Property == 1.0).

test(gi_marshalling_tests_properties_object_set_double_property) :-
	gi_marshalling_tests_properties_object_new(Object),
	g_object_set_property(Object, 'some-double', 1.0),
	g_object_get_property(Object, 'some-double', Property),
	assertion(Property == 1.0).

test(gi_marshalling_tests_properties_object_set_strv_property) :-
	gi_marshalling_tests_properties_object_new(Object),
	g_object_set_property(Object, 'some-strv', ['foo', 'bar']),
	g_object_get_property(Object, 'some-strv', Property),
	assertion(Property == ['foo', 'bar']).

test(gi_marshalling_tests_properties_object_set_boxed_struct_property) :-
	gi_marshalling_tests_properties_object_new(Object),
	StructTerm = 'GIMarshallingTestsBoxedStruct'( 'long_'=42, 'string_'='hello', 'g_strv'=['0', '1', '2'] ),
	plgi_struct_new(StructTerm, Struct),
	g_object_set_property(Object, 'some-boxed-struct', Struct),
	g_object_get_property(Object, 'some-boxed-struct', Property),
	plgi_struct_term(Property, PropertyTerm),
	assertion(PropertyTerm == StructTerm).

test(gi_marshalling_tests_properties_object_set_variant_property) :-
	gi_marshalling_tests_properties_object_new(Object),
	g_variant_new_int32(1, GVariant),
	g_object_set_property(Object, 'some-variant', GVariant),
	g_object_get_property(Object, 'some-variant', Property),
	g_variant_get_int32(Property, Value),
	assertion(Value == 1).

test(gi_marshalling_tests_properties_object_set_boxed_glist_property) :-
	gi_marshalling_tests_properties_object_new(Object),
	g_object_set_property(Object, 'some-boxed-glist', [-1, 0, 1, 2]),
	g_object_get_property(Object, 'some-boxed-glist', Property),
	assertion(Property == [-1, 0, 1, 2]).

test(gi_marshalling_tests_properties_object_set_object_property) :-
	gi_marshalling_tests_properties_object_new(Object),
	gi_marshalling_tests_object_new(42, PropertyObject),
	g_object_set_property(Object, 'some-object', PropertyObject),
	g_object_get_property(Object, 'some-object', Property),
	assertion(Property == PropertyObject).

test(gi_marshalling_tests_sub_object_get_parent_property) :-
	g_object_new('GIMarshallingTestsSubObject', [], Object),
	g_object_get_property(Object, 'int', Property),
	assertion(Property == 0).

test(gi_marshalling_tests_sub_object_set_parent_property) :-
	g_object_new('GIMarshallingTestsSubObject', [], Object),
	g_object_set_property(Object, 'int', 42),
	g_object_get_property(Object, 'int', Property),
	assertion(Property == 42).

/* error conditions */
/* FIXME: add tests for error conditions */

:- end_tests(plgi_marshaller_object_properties).
