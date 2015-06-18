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

:- plgi_use_namespace_from_dir('Regress', '.').
:- plgi_use_namespace('GObject').
:- plgi_use_namespace('Gio').



/* gboolean */
:- begin_tests(plgi_regress_gboolean).

test(regress_test_boolean) :-
	regress_test_boolean(true, Value1),
	assertion(Value1 == true),
	regress_test_boolean(false, Value2),
	assertion(Value2 == false).

test(regress_test_boolean_true) :-
	regress_test_boolean_true(true, Value),
	assertion(Value == true).

test(regress_test_boolean_false) :-
	regress_test_boolean_false(false, Value),
	assertion(Value == false).

/* error conditions */
test(regress_test_boolean_type_error, [throws(error(type_error(boolean, _), _))]) :-
	regress_test_boolean('x', _).

:- end_tests(plgi_regress_gboolean).



/* gint8 */
:- begin_tests(plgi_regress_gint8).

test(regress_test_int8_max) :-
	regress_test_int8(0x7F, Value),
	assertion(Value == 0x7F).

test(regress_test_int8_positive) :-
	regress_test_int8(1, Value),
	assertion(Value == 1).

test(regress_test_int8_zero) :-
	regress_test_int8(0, Value),
	assertion(Value == 0).

test(regress_test_int8_negative) :-
	regress_test_int8(-1, Value),
	assertion(Value == -1).

test(regress_test_int8_min) :-
	regress_test_int8(-0x80, Value),
	assertion(Value == -0x80).

/* error conditions */
test(regress_test_int8_overflow_error, [throws(error(type_error('8 bit integer', _), _))]) :-
	regress_test_int8(0x80, _).

test(regress_test_int8_underflow_error, [throws(error(type_error('8 bit integer', _), _))]) :-
	regress_test_int8(-0x81, _).

:- end_tests(plgi_regress_gint8).



/* guint8 */
:- begin_tests(plgi_regress_guint8).

test(regress_test_uint8_max) :-
	regress_test_uint8(0xFF, Value),
	assertion(Value == 0xFF).

test(regress_test_uint8_positive) :-
	regress_test_uint8(1, Value),
	assertion(Value == 1).

test(regress_test_uint8_zero) :-
	regress_test_uint8(0, Value),
	assertion(Value == 0).

/* error conditions */
test(regress_test_uint8_overflow_error, [throws(error(type_error('8 bit unsigned integer', _), _))]) :-
	regress_test_uint8(0x100, _).

test(regress_test_uint8_underflow_error, [throws(error(type_error('8 bit unsigned integer', _), _))]) :-
	regress_test_uint8(-1, _).

:- end_tests(plgi_regress_guint8).



/* gint16 */
:- begin_tests(plgi_regress_gint16).

test(regress_test_int16_max) :-
	regress_test_int16(0x7FFF, Value),
	assertion(Value == 0x7FFF).

test(regress_test_int16_positive) :-
	regress_test_int16(1, Value),
	assertion(Value == 1).

test(regress_test_int16_zero) :-
	regress_test_int16(0, Value),
	assertion(Value == 0).

test(regress_test_int16_negative) :-
	regress_test_int16(-1, Value),
	assertion(Value == -1).

test(regress_test_int16_min) :-
	regress_test_int16(-0x8000, Value),
	assertion(Value == -0x8000).

/* error conditions */
test(regress_test_int16_overflow_error, [throws(error(type_error('16 bit integer', _), _))]) :-
	regress_test_int16(0x8000, _).

test(regress_test_int16_underflow_error, [throws(error(type_error('16 bit integer', _), _))]) :-
	regress_test_int16(-0x8001, _).

:- end_tests(plgi_regress_gint16).



/* guint16 */
:- begin_tests(plgi_regress_guint16).

test(regress_test_uint16_max) :-
	regress_test_uint16(0xFFFF, Value),
	assertion(Value == 0xFFFF).

test(regress_test_uint16_positive) :-
	regress_test_uint16(1, Value),
	assertion(Value == 1).

test(regress_test_uint16_zero) :-
	regress_test_uint16(0, Value),
	assertion(Value == 0).

/* error conditions */
test(regress_test_uint16_overflow_error, [throws(error(type_error('16 bit unsigned integer', _), _))]) :-
	regress_test_uint16(0x10000, _).

test(regress_test_uint16_underflow_error, [throws(error(type_error('16 bit unsigned integer', _), _))]) :-
	regress_test_uint16(-1, _).

:- end_tests(plgi_regress_guint16).



/* gint32 */
:- begin_tests(plgi_regress_gint32).

test(regress_test_int32_max) :-
	regress_test_int32(0x7FFFFFFF, Value),
	assertion(Value == 0x7FFFFFFF).

test(regress_test_int32_positive) :-
	regress_test_int32(1, Value),
	assertion(Value == 1).

test(regress_test_int32_zero) :-
	regress_test_int32(0, Value),
	assertion(Value == 0).

test(regress_test_int32_negative) :-
	regress_test_int32(-1, Value),
	assertion(Value == -1).

test(regress_test_int32_min) :-
	regress_test_int32(-0x80000000, Value),
	assertion(Value == -0x80000000).

/* error conditions */
test(regress_test_int32_overflow_error, [throws(error(type_error('32 bit integer', _), _))]) :-
	regress_test_int32(0x80000000, _).

test(regress_test_int32_underflow_error, [throws(error(type_error('32 bit integer', _), _))]) :-
	regress_test_int32(-0x80000001, _).

:- end_tests(plgi_regress_gint32).



/* guint32 */
:- begin_tests(plgi_regress_guint32).

test(regress_test_uint32_max) :-
	regress_test_uint32(0xFFFFFFFF, Value),
	assertion(Value == 0xFFFFFFFF).

test(regress_test_uint32_positive) :-
	regress_test_uint32(1, Value),
	assertion(Value == 1).

test(regress_test_uint32_zero) :-
	regress_test_uint32(0, Value),
	assertion(Value == 0).

/* error conditions */
test(regress_test_uint32_overflow_error, [throws(error(type_error('32 bit unsigned integer', _), _))]) :-
	regress_test_uint32(0x100000000, _).

test(regress_test_uint32_underflow_error, [throws(error(type_error('32 bit unsigned integer', _), _))]) :-
	regress_test_uint32(-1, _).

:- end_tests(plgi_regress_guint32).



/* gint64 */
:- begin_tests(plgi_regress_gint64).

test(regress_test_int64_max) :-
	regress_test_int64(0x7FFFFFFFFFFFFFFF, Value),
	assertion(Value == 0x7FFFFFFFFFFFFFFF).

test(regress_test_int64_positive) :-
	regress_test_int64(1, Value),
	assertion(Value == 1).

test(regress_test_int64_zero) :-
	regress_test_int64(0, Value),
	assertion(Value == 0).

test(regress_test_int64_negative) :-
	regress_test_int64(-1, Value),
	assertion(Value == -1).

test(regress_test_int64_min) :-
	regress_test_int64(-0x8000000000000000, Value),
	assertion(Value == -0x8000000000000000).

/* error conditions */
test(regress_test_int64_overflow_error, [throws(error(type_error('64 bit integer', _), _))]) :-
	regress_test_int64(0x8000000000000000, _).

test(regress_test_int64_underflow_error, [throws(error(type_error('64 bit integer', _), _))]) :-
	regress_test_int64(-0x8000000000000001, _).

:- end_tests(plgi_regress_gint64).



/* guint64 */
:- begin_tests(plgi_regress_guint64).

test(regress_test_uint64_max) :-
	regress_test_uint64(0xFFFFFFFFFFFFFFFF, Value),
	assertion(Value == 0xFFFFFFFFFFFFFFFF).

test(regress_test_uint64_positive) :-
	regress_test_uint64(1, Value),
	assertion(Value == 1).

test(regress_test_uint64_zero) :-
	regress_test_uint64(0, Value),
	assertion(Value == 0).

/* error conditions */
test(regress_test_uint64_overflow_error, [throws(error(type_error('64 bit unsigned integer', _), _))]) :-
	regress_test_uint64(0x10000000000000000, _).

test(regress_test_uint64_underflow_error, [throws(error(type_error('64 bit unsigned integer', _), _))]) :-
	regress_test_uint64(-1, _).

:- end_tests(plgi_regress_guint64).



/* gshort */
:- begin_tests(plgi_regress_gshort).

test(regress_test_short_max) :-
	regress_test_short(0x7FFF, Value),
	assertion(Value == 0x7FFF).

test(regress_test_short_positive) :-
	regress_test_short(1, Value),
	assertion(Value == 1).

test(regress_test_short_zero) :-
	regress_test_short(0, Value),
	assertion(Value == 0).

test(regress_test_short_negative) :-
	regress_test_short(-1, Value),
	assertion(Value == -1).

test(regress_test_short_min) :-
	regress_test_short(-0x8000, Value),
	assertion(Value == -0x8000).

/* error conditions */
test(regress_test_short_overflow_error, [throws(error(type_error('16 bit integer', _), _))]) :-
	regress_test_short(0x8000, _).

test(regress_test_short_underflow_error, [throws(error(type_error('16 bit integer', _), _))]) :-
	regress_test_short(-0x8001, _).

:- end_tests(plgi_regress_gshort).



/* gushort */
:- begin_tests(plgi_regress_gushort).

test(regress_test_ushort_max) :-
	regress_test_ushort(0xFFFF, Value),
	assertion(Value == 0xFFFF).

test(regress_test_ushort_positive) :-
	regress_test_ushort(1, Value),
	assertion(Value == 1).

test(regress_test_ushort_zero) :-
	regress_test_ushort(0, Value),
	assertion(Value == 0).

/* error conditions */
test(regress_test_ushort_overflow_error, [throws(error(type_error('16 bit unsigned integer', _), _))]) :-
	regress_test_ushort(0x10000, _).

test(regress_test_ushort_underflow_error, [throws(error(type_error('16 bit unsigned integer', _), _))]) :-
	regress_test_ushort(-1, _).

:- end_tests(plgi_regress_gushort).



/* gint */
:- begin_tests(plgi_regress_gint).

test(regress_test_int_max) :-
	regress_test_int(0x7FFFFFFF, Value),
	assertion(Value == 0x7FFFFFFF).

test(regress_test_int_positive) :-
	regress_test_int(1, Value),
	assertion(Value == 1).

test(regress_test_int_zero) :-
	regress_test_int(0, Value),
	assertion(Value == 0).

test(regress_test_int_negative) :-
	regress_test_int(-1, Value),
	assertion(Value == -1).

test(regress_test_int_min) :-
	regress_test_int(-0x80000000, Value),
	assertion(Value == -0x80000000).

/* error conditions */
test(regress_test_int_overflow_error, [throws(error(type_error('32 bit integer', _), _))]) :-
	regress_test_int(0x80000000, _).

test(regress_test_int_underflow_error, [throws(error(type_error('32 bit integer', _), _))]) :-
	regress_test_int(-0x80000001, _).

:- end_tests(plgi_regress_gint).



/* guint */
:- begin_tests(plgi_regress_guint).

test(regress_test_uint_max) :-
	regress_test_uint(0xFFFFFFFF, Value),
	assertion(Value == 0xFFFFFFFF).

test(regress_test_uint_positive) :-
	regress_test_uint(1, Value),
	assertion(Value == 1).

test(regress_test_uint_zero) :-
	regress_test_uint(0, Value),
	assertion(Value == 0).

/* error conditions */
test(regress_test_uint_overflow_error, [throws(error(type_error('32 bit unsigned integer', _), _))]) :-
	regress_test_uint(0x100000000, _).

test(regress_test_uint_underflow_error, [throws(error(type_error('32 bit unsigned integer', _), _))]) :-
	regress_test_uint(-1, _).

:- end_tests(plgi_regress_guint).



/* glong */
:- begin_tests(plgi_regress_glong).

test(regress_test_long_max) :-
	regress_test_long(0x7FFFFFFFFFFFFFFF, Value),
	assertion(Value == 0x7FFFFFFFFFFFFFFF).

test(regress_test_long_positive) :-
	regress_test_long(1, Value),
	assertion(Value == 1).

test(regress_test_long_zero) :-
	regress_test_long(0, Value),
	assertion(Value == 0).

test(regress_test_long_negative) :-
	regress_test_long(-1, Value),
	assertion(Value == -1).

test(regress_test_long_min) :-
	regress_test_long(-0x8000000000000000, Value),
	assertion(Value == -0x8000000000000000).

/* error conditions */
test(regress_test_long_overflow_error, [throws(error(type_error('64 bit integer', _), _))]) :-
	regress_test_long(0x8000000000000000, _).

test(regress_test_long_underflow_error, [throws(error(type_error('64 bit integer', _), _))]) :-
	regress_test_long(-0x8000000000000001, _).

:- end_tests(plgi_regress_glong).



/* gulong */
:- begin_tests(plgi_regress_gulong).

test(regress_test_ulong_max) :-
	regress_test_ulong(0xFFFFFFFFFFFFFFFF, Value),
	assertion(Value == 0xFFFFFFFFFFFFFFFF).

test(regress_test_ulong_positive) :-
	regress_test_ulong(1, Value),
	assertion(Value == 1).

test(regress_test_ulong_zero) :-
	regress_test_ulong(0, Value),
	assertion(Value == 0).

/* error conditions */
test(regress_test_ulong_overflow_error, [throws(error(type_error('64 bit unsigned integer', _), _))]) :-
	regress_test_ulong(0x10000000000000000, _).

test(regress_test_ulong_underflow_error, [throws(error(type_error('64 bit unsigned integer', _), _))]) :-
	regress_test_ulong(-1, _).

:- end_tests(plgi_regress_gulong).



/* gssize */
:- begin_tests(plgi_regress_gssize).

test(regress_test_ssize_max) :-
	regress_test_ssize(0x7FFFFFFFFFFFFFFF, Value),
	assertion(Value == 0x7FFFFFFFFFFFFFFF).

test(regress_test_ssize_positive) :-
	regress_test_ssize(1, Value),
	assertion(Value == 1).

test(regress_test_ssize_zero) :-
	regress_test_ssize(0, Value),
	assertion(Value == 0).

test(regress_test_ssize_negative) :-
	regress_test_ssize(-1, Value),
	assertion(Value == -1).

test(regress_test_ssize_min) :-
	regress_test_ssize(-0x8000000000000000, Value),
	assertion(Value == -0x8000000000000000).

/* error conditions */
test(regress_test_ssize_overflow_error, [throws(error(type_error('64 bit integer', _), _))]) :-
	regress_test_ssize(0x8000000000000000, _).

test(regress_test_ssize_underflow_error, [throws(error(type_error('64 bit integer', _), _))]) :-
	regress_test_ssize(-0x8000000000000001, _).

:- end_tests(plgi_regress_gssize).



/* gsize */
:- begin_tests(plgi_regress_gsize).

test(regress_test_size_max) :-
	regress_test_size(0xFFFFFFFFFFFFFFFF, Value),
	assertion(Value == 0xFFFFFFFFFFFFFFFF).

test(regress_test_size_positive) :-
	regress_test_size(1, Value),
	assertion(Value == 1).

test(regress_test_size_zero) :-
	regress_test_size(0, Value),
	assertion(Value == 0).

/* error conditions */
test(regress_test_size_overflow_error, [throws(error(type_error('64 bit unsigned integer', _), _))]) :-
	regress_test_size(0x10000000000000000, _).

test(regress_test_size_underflow_error, [throws(error(type_error('64 bit unsigned integer', _), _))]) :-
	regress_test_size(-1, _).

:- end_tests(plgi_regress_gsize).



/* gfloat */
:- begin_tests(plgi_regress_gfloat).

test(regress_test_float_positive_max) :-
	regress_test_float(3.4028234663852886e+38, Value),
	assertion(Value == 3.4028234663852886e+38).

test(regress_test_float_positive) :-
	regress_test_float(1.0, Value),
	assertion(Value == 1.0).

test(regress_test_float_positive_min) :-
	regress_test_float(1.40129846432481707e-45, Value),
	assertion(Value == 1.40129846432481707e-45).

test(regress_test_float_zero) :-
	regress_test_float(0.0, Value),
	assertion(Value == 0.0).

test(regress_test_float_negative_min) :-
	regress_test_float(-1.40129846432481707e-45, Value),
	assertion(Value == -1.40129846432481707e-45).

test(regress_test_float_negative) :-
	regress_test_float(-1.0, Value),
	assertion(Value == -1.0).

test(regress_test_float_negative_max) :-
	regress_test_float(-3.4028234663852886e+38, Value),
	assertion(Value == -3.4028234663852886e+38).

/* error conditions */
test(regress_test_float_overflow_error, [throws(error(type_error('float', _), _))]) :-
	regress_test_float(3.4028234663852889e+38, _).

test(regress_test_float_underflow_error, [throws(error(type_error('float', _), _))]) :-
	regress_test_float(-3.4028234663852889e+38, _).

:- end_tests(plgi_regress_gfloat).



/* gdouble */
:- begin_tests(plgi_regress_gdouble).

test(regress_test_double_positive_max) :-
	regress_test_double(1.7976931348623157e+308, Value),
	assertion(Value == 1.7976931348623157e+308).

test(regress_test_double_positive) :-
	regress_test_double(1.0, Value),
	assertion(Value == 1.0).

test(regress_test_double_positive_min) :-
	regress_test_double(4.94065645841246544e-324, Value),
	assertion(Value == 4.94065645841246544e-324).

test(regress_test_double_zero) :-
	regress_test_double(0.0, Value),
	assertion(Value == 0.0).

test(regress_test_double_negative_min) :-
	regress_test_double(-4.94065645841246544e-324, Value),
	assertion(Value == -4.94065645841246544e-324).

test(regress_test_double_negative) :-
	regress_test_double(-1.0, Value),
	assertion(Value == -1.0).

test(regress_test_double_negative_max) :-
	regress_test_double(-1.7976931348623157e+308, Value),
	assertion(Value == -1.7976931348623157e+308).

/* error conditions */
/* FIXME: can we test overflow?
test(regress_test_double_overflow_error, [throws(error(type_error('double', _), _))]) :-
	regress_test_double(1.7976931348623159e+308, _).

test(regress_test_double_underflow_error, [throws(error(type_error('double', _), _))]) :-
	regress_test_double(-1.7976931348623159e+308, _).
*/
:- end_tests(plgi_regress_gdouble).



/* gunichar */
:- begin_tests(plgi_regress_gunichar).

test(regress_test_unichar_ascii) :-
	regress_test_unichar(0x41, Value),
	assertion(Value == 0x41).

test(regress_test_unichar_unicode) :-
	Unichar = '\u2665',
	atom_codes(Unichar, [ValueIn]),
	regress_test_unichar(ValueIn, ValueOut),
	assertion(ValueOut == ValueIn).

test(regress_test_unichar_zero) :-
	regress_test_unichar(0, Value),
	assertion(Value == 0).

/* error conditions */
test(regress_test_unichar_overflow_error, [throws(error(type_error('unicode character code', _), _))]) :-
	regress_test_unichar(0x100000000, _).

test(regress_test_unichar_underflow_error, [throws(error(type_error('unicode character code', _), _))]) :-
	regress_test_unichar(-1, _).

test(regress_test_unichar_invalid_code, [throws(error(domain_error('unicode character code', _), _))]) :-
	regress_test_unichar(0xFFFFFFFF, _).

:- end_tests(plgi_regress_gunichar).



/* time_t */
:- begin_tests(plgi_regress_time_t).

test(regress_test_time_t_max) :-
	regress_test_size(0xFFFFFFFFFFFFFFFF, Value),
	assertion(Value == 0xFFFFFFFFFFFFFFFF).

test(regress_test_time_t_positive) :-
	regress_test_size(1, Value),
	assertion(Value == 1).

test(regress_test_time_t_zero) :-
	regress_test_size(0, Value),
	assertion(Value == 0).

/* error conditions */
test(regress_test_time_t_overflow_error, [throws(error(type_error('64 bit unsigned integer', _), _))]) :-
	regress_test_size(0x10000000000000000, _).

test(regress_test_time_t_underflow_error, [throws(error(type_error('64 bit unsigned integer', _), _))]) :-
	regress_test_size(-1, _).

:- end_tests(plgi_regress_time_t).



/* GType */
:- begin_tests(plgi_regress_gtype).

test(regress_test_gtype_fundamental_type) :-
	regress_test_gtype('gchararray', Value),
	assertion(Value == 'gchararray').

test(regress_test_gtype_object_type) :-
	regress_test_gtype('GObject', Value),
	assertion(Value == 'GObject').

test(regress_test_gtype_object_type) :-
	regress_test_gtype('GParam', Value),
	assertion(Value == 'GParam').

test(regress_test_gtype_value_type) :-
	regress_test_gtype('GValue', Value),
	assertion(Value == 'GValue').

test(regress_test_gtype_boxed_type) :-
	regress_test_gtype('GBoxed', Value),
	assertion(Value == 'GBoxed').

test(regress_test_gtype_enum_type) :-
	regress_test_gtype('RegressTestEnum', Value),
	assertion(Value == 'RegressTestEnum').

test(regress_test_gtype_flags_type) :-
	regress_test_gtype('RegressTestFlags', Value),
	assertion(Value == 'RegressTestFlags').

test(regress_test_gtype_unregistered_type) :-
	regress_test_gtype('RegressTestStructA', Value),
	assertion(Value == 'void').

:- end_tests(plgi_regress_gtype).



/* GValue */
:- begin_tests(plgi_regress_gvalue).

test(regress_test_value_arg) :-
	g_value_init('gint', GValue),
	g_value_set_int(GValue, 42),
	regress_test_int_value_arg(GValue, Integer),
	assertion(Integer == 42).

test(regress_test_value_return) :-
	regress_test_value_return(42, GValue),
	assertion(g_is_value(GValue)),
	assertion(g_value_holds(GValue, 'gint')),
	g_value_get_int(GValue, Integer),
	assertion(Integer == 42).

test(regress_test_date_in_gvalue) :-
	regress_test_date_in_gvalue(GValue),
	assertion(g_is_value(GValue)),
	assertion(g_value_holds(GValue, 'GDate')),
	g_value_get_boxed(GValue, GDate),
	assertion(g_date_valid(GDate, true)),
	g_date_get_year(GDate, Year),
	g_date_get_month(GDate, Month),
	g_date_get_day(GDate, Day),
	assertion(Year == 1984),
	assertion(Month == 'G_DATE_DECEMBER'),
	assertion(Day == 5).

test(regress_test_strv_in_gvalue) :-
	regress_test_strv_in_gvalue(GValue),
	g_value_get_boxed(GValue, GStrv),
	assertion(GStrv == ['one', 'two', 'three']).

:- end_tests(plgi_regress_gvalue).



/* FIXME: support cairo foreign struct tests
:- end_tests(plgi_regress_foreign_struct).
:- end_tests(plgi_regress_foreign_struct).
*/



/* GVariant */
:- begin_tests(plgi_regress_gvariant).

test(regress_test_gvariant_i) :-
	regress_test_gvariant_i(GVariant),
	g_variant_get_type_string(GVariant, Type),
	assertion(Type == 'i'),
	g_variant_get_int32(GVariant, Value),
	assertion(Value == 1).

test(regress_test_gvariant_s) :-
	regress_test_gvariant_s(GVariant),
	g_variant_get_type_string(GVariant, Type),
	assertion(Type == 's'),
	g_variant_get_string(GVariant, _, Value),
	assertion(Value == 'one').

test(regress_test_gvariant_v) :-
	regress_test_gvariant_v(GVariant),
	g_variant_get_type_string(GVariant, Type),
	assertion(Type == 'v'),
	g_variant_get_variant(GVariant, NestedGVariant),
	g_variant_get_type_string(NestedGVariant, NestedType),
	assertion(NestedType == 's'),
	g_variant_get_string(NestedGVariant, _, Value),
	assertion(Value == 'contents').

test(regress_test_gvariant_as) :-
	regress_test_gvariant_as(GVariant),
	g_variant_get_type_string(GVariant, Type),
	assertion(Type == 'as'),
	g_variant_get_strv(GVariant, Value),
	assertion(Value == ['one', 'two', 'three']).

test(regress_test_gvariant_asv) :-
	regress_test_gvariant_asv(GVariant),
	g_variant_get_type_string(GVariant, Type),
	assertion(Type == 'a{sv}'),
	g_variant_lookup_value(GVariant, 'name', {null}, NameGVariant),
	g_variant_get_string(NameGVariant, _, NameValue),
	assertion(NameValue == 'foo'),
	g_variant_lookup_value(GVariant, 'timeout', {null}, TimeoutGVariant),
	g_variant_get_int32(TimeoutGVariant, TimeoutValue),
	assertion(TimeoutValue == 10).

:- end_tests(plgi_regress_gvariant).



/* time_t */
:- begin_tests(plgi_regress_utf8).

test(regress_test_utf8_const_return) :-
	regress_test_utf8_const_return(Atom),
	assertion(Atom == 'const \u2665 utf8').

test(regress_test_utf8_nonconst_return) :-
	regress_test_utf8_nonconst_return(Atom),
	assertion(Atom == 'nonconst \u2665 utf8').

test(regress_test_utf8_const_in) :-
	regress_test_utf8_const_in('const \u2665 utf8').

test(regress_test_utf8_out) :-
	regress_test_utf8_out(Atom),
	assertion(Atom == 'nonconst \u2665 utf8').

test(regress_test_utf8_inout) :-
	regress_test_utf8_inout('const \u2665 utf8', Atom),
	assertion(Atom == 'nonconst \u2665 utf8').

test(regress_test_filename_return) :-
	regress_test_filename_return(Atoms),
	assertion(Atoms == ['åäö', '/etc/fstab']).

test(regress_test_int_out_utf8) :-
	regress_test_int_out_utf8(Length, 'const \u2665 utf8'),
	assertion(Length == 12).

test(regress_test_int_out_utf8_empty) :-
	regress_test_int_out_utf8(Length, ''),
	assertion(Length == 0).

test(regress_test_utf8_null_in) :-
	regress_test_utf8_null_in({null}).

test(regress_test_utf8_null_out) :-
	regress_test_utf8_null_out(Value),
	assertion(Value == {null}).

:- end_tests(plgi_regress_utf8).



/* multiple output args */
:- begin_tests(plgi_regress_multiple_output_args).

test(regress_test_multi_double_args) :-
	regress_test_multi_double_args(2.5, Value1, Value2),
	assertion(Value1 == 5.0),
	assertion(Value2 == 7.5).

test(regress_test_utf8_out_out) :-
	regress_test_utf8_out_out(Atom1, Atom2),
	assertion(Atom1 == 'first'),
	assertion(Atom2 == 'second').

test(regress_test_utf8_out_nonconst_return) :-
	regress_test_utf8_out_nonconst_return(Atom1, Atom2),
	assertion(Atom1 == 'second'),
	assertion(Atom2 == 'first').

:- end_tests(plgi_regress_multiple_output_args).



/* array */
:- begin_tests(plgi_regress_array).

test(regress_test_array_int_in) :-
	regress_test_array_int_in([1, 2, 3], Value),
	assertion(Value == 6).

test(regress_test_array_int_in_empty) :-
	regress_test_array_int_in([], Value),
	assertion(Value == 0).

test(regress_test_array_int_out) :-
	regress_test_array_int_out(List),
	assertion(List == [0, 1, 2, 3, 4]).

test(regress_test_array_int_inout) :-
	regress_test_array_int_inout([0, 1, 2, 3, 4], List),
	assertion(List == [2, 3, 4, 5]).

test(regress_test_array_int_inout_empty) :-
	regress_test_array_int_inout([], List),
	assertion(List == []).

test(regress_test_array_gint8_in) :-
	regress_test_array_gint8_in([-1, 0, 1, 2, 3], Value),
	assertion(Value == 5).

test(regress_test_array_gint16_in) :-
	regress_test_array_gint16_in([-1, 0, 1, 2, 3], Value),
	assertion(Value == 5).

test(regress_test_array_gint32_in) :-
	regress_test_array_gint32_in([-1, 0, 1, 2, 3], Value),
	assertion(Value == 5).

test(regress_test_array_gint64_in) :-
	regress_test_array_gint64_in([-1, 0, 1, 2, 3], Value),
	assertion(Value == 5).

test(regress_test_strv_in) :-
	regress_test_strv_in(['1', '2', '3'], Value),
	assertion(Value == true).

test(regress_test_array_gtype_in) :-
	regress_test_array_gtype_in(['gchararray', 'guint64', 'GVariant'], Value),
	assertion(Value == '[gchararray,guint64,GVariant,]').

test(regress_test_strv_out) :-
	regress_test_strv_out(List),
	assertion(List == ['thanks', 'for', 'all', 'the', 'fish']).

test(regress_test_strv_out_container) :-
	regress_test_strv_out_container(List),
	assertion(List == ['1', '2', '3']).

test(regress_test_strv_outarg) :-
	regress_test_strv_outarg(List),
	assertion(List == ['1', '2', '3']).

test(regress_test_array_fixed_size_int_in) :-
	regress_test_array_fixed_size_int_in([-1, 0, 1, 2, 3], Value),
	assertion(Value == 5).

test(regress_test_array_fixed_size_int_out) :-
	regress_test_array_fixed_size_int_out(List),
	assertion(List == [0, 1, 2, 3, 4]).

test(regress_test_array_fixed_size_int_return) :-
	regress_test_array_fixed_size_int_return(List),
	assertion(List == [0, 1, 2, 3, 4]).

test(regress_test_strv_out_c) :-
	regress_test_strv_out_c(List),
	assertion(List == ['thanks', 'for', 'all', 'the', 'fish']).

test(regress_test_array_int_full_out) :-
	regress_test_array_int_full_out(List),
	assertion(List == [0, 1, 2, 3, 4]).

test(regress_test_array_int_none_out) :-
	regress_test_array_int_none_out(List),
	assertion(List == [1, 2, 3, 4, 5]).

test(regress_test_array_int_null_in) :-
	regress_test_array_int_null_in({null}).

test(regress_test_array_int_null_in_empty) :-
	regress_test_array_int_null_in([]).

test(regress_test_array_int_null_out) :-
	regress_test_array_int_null_out(List),
	assertion(List == []).

:- end_tests(plgi_regress_array).



/* GList */
:- begin_tests(plgi_regress_glist).

test(regress_test_glist_nothing_return) :-
	regress_test_glist_nothing_return(List),
	assertion(List == ['1', '2', '3']).

test(regress_test_glist_nothing_return2) :-
	regress_test_glist_nothing_return2(List),
	assertion(List == ['1', '2', '3']).

test(regress_test_glist_container_return) :-
	regress_test_glist_container_return(List),
	assertion(List == ['1', '2', '3']).

test(regress_test_glist_everything_return) :-
	regress_test_glist_everything_return(List),
	assertion(List == ['1', '2', '3']).

test(regress_test_glist_nothing_in) :-
	regress_test_glist_nothing_in(['1', '2', '3']).

test(regress_test_glist_nothing_in2) :-
	regress_test_glist_nothing_in2(['1', '2', '3']).

test(regress_test_glist_null_in) :-
	regress_test_glist_null_in({null}).

test(regress_test_glist_null_in_empty) :-
	regress_test_glist_null_in([]).

test(regress_test_glist_null_out) :-
	regress_test_glist_null_out(List),
	assertion(List == []).

:- end_tests(plgi_regress_glist).



/* GSList */
:- begin_tests(plgi_regress_gslist).

test(regress_test_gslist_nothing_return) :-
	regress_test_gslist_nothing_return(List),
	assertion(List == ['1', '2', '3']).

test(regress_test_gslist_nothing_return2) :-
	regress_test_gslist_nothing_return2(List),
	assertion(List == ['1', '2', '3']).

test(regress_test_gslist_container_return) :-
	regress_test_gslist_container_return(List),
	assertion(List == ['1', '2', '3']).

test(regress_test_gslist_everything_return) :-
	regress_test_gslist_everything_return(List),
	assertion(List == ['1', '2', '3']).

test(regress_test_gslist_nothing_in) :-
	regress_test_gslist_nothing_in(['1', '2', '3']).

test(regress_test_gslist_nothing_in2) :-
	regress_test_gslist_nothing_in2(['1', '2', '3']).

test(regress_test_gslist_null_in) :-
	regress_test_gslist_null_in({null}).

test(regress_test_gslist_null_in_empty) :-
	regress_test_gslist_null_in([]).

test(regress_test_gslist_null_out) :-
	regress_test_gslist_null_out(List),
	assertion(List == []).

:- end_tests(plgi_regress_gslist).



/* GHashTable */
:- begin_tests(plgi_regress_ghashtable).

test(regress_test_ghash_null_return) :-
	regress_test_ghash_null_return(List),
	assertion(List == []).

test(regress_test_ghash_nothing_return) :-
	regress_test_ghash_nothing_return(List),
	sort(List, ListSorted),
	assertion(ListSorted == ['baz'-'bat', 'foo'-'bar', 'qux'-'quux']).

test(regress_test_ghash_nothing_return2) :-
	regress_test_ghash_nothing_return2(List),
	sort(List, ListSorted),
	assertion(ListSorted == ['baz'-'bat', 'foo'-'bar', 'qux'-'quux']).

test(regress_test_ghash_gvalue_return) :-
	regress_test_ghash_gvalue_return(List),
	sort(List, ListSorted),
	ListSorted = ['boolean'-BooleanGValue,
                      'enum'-EnumGValue,
                      'flags'-FlagsGValue,
                      'integer'-IntegerGValue,
                      'string'-StringGValue,
                      'strings'-StringsGValue],
	assertion(g_is_value(BooleanGValue)),
	assertion(g_value_holds(BooleanGValue, 'gboolean')),
	g_value_get_boolean(BooleanGValue, Boolean),
	assertion(Boolean == true),
	assertion(g_is_value(EnumGValue)),
	assertion(g_value_holds(EnumGValue, 'RegressTestEnum')),
	g_value_get_enum(EnumGValue, EnumValue),
	plgi_enum_value('REGRESS_TEST_VALUE2', RegressTestValue2),
	assertion(EnumValue == RegressTestValue2),
	assertion(g_is_value(FlagsGValue)),
	assertion(g_value_holds(FlagsGValue, 'RegressTestFlags')),
	g_value_get_flags(FlagsGValue, FlagValue),
	plgi_enum_value('TEST_FLAG1', RegressTestFlag1),
	plgi_enum_value('TEST_FLAG3', RegressTestFlag3),
	assertion(FlagValue =:= RegressTestFlag1 \/ RegressTestFlag3),
	assertion(g_is_value(IntegerGValue)),
	assertion(g_value_holds(IntegerGValue, 'gint')),
	g_value_get_int(IntegerGValue, Integer),
	assertion(Integer == 12),
	assertion(g_is_value(StringGValue)),
	assertion(g_value_holds(StringGValue, 'gchararray')),
	g_value_get_string(StringGValue, String),
	assertion(String == 'some text'),
	assertion(g_is_value(StringsGValue)),
	assertion(g_value_holds(StringsGValue, 'GStrv')),
	g_value_get_boxed(StringsGValue, Strings),
	assertion(Strings == ['first', 'second', 'third']).

test(regress_test_ghash_gvalue_in) :-
	g_value_init('gint', IntegerGValue),
	g_value_set_int(IntegerGValue, 12),
	g_value_init('gboolean', BooleanGValue),
	g_value_set_boolean(BooleanGValue, true),
	g_value_init('gchararray', StringGValue),
	g_value_set_string(StringGValue, 'some text'),
	g_value_init('GStrv', StringsGValue),
	g_value_set_boxed(StringsGValue, ['first', 'second', 'third']),
	g_value_init('RegressTestFlags', FlagsGValue),
	g_value_set_flags(FlagsGValue, ['TEST_FLAG1', 'TEST_FLAG3']),
	g_value_init('RegressTestEnum', EnumGValue),
	g_value_set_enum(EnumGValue, 'REGRESS_TEST_VALUE2'),
	List = ['integer'-IntegerGValue,
                'boolean'-BooleanGValue,
                'string'-StringGValue,
                'strings'-StringsGValue,
                'flags'-FlagsGValue,
                'enum'-EnumGValue],
	regress_test_ghash_gvalue_in(List).

test(regress_test_ghash_container_return) :-
	regress_test_ghash_container_return(List),
	sort(List, ListSorted),
	assertion(ListSorted == ['baz'-'bat', 'foo'-'bar', 'qux'-'quux']).

test(regress_test_ghash_everything_return) :-
	regress_test_ghash_everything_return(List),
	sort(List, ListSorted),
	assertion(ListSorted == ['baz'-'bat', 'foo'-'bar', 'qux'-'quux']).

test(regress_test_ghash_null_in) :-
	regress_test_ghash_null_in({null}).

/* FIXME: we need to translate [] -> NULL in hashtable_term_to_arg */
/*
test(regress_test_ghash_null_in_empty) :-
	regress_test_ghash_null_in([]).
*/
test(regress_test_ghash_null_out) :-
	regress_test_ghash_null_out(List),
	assertion(List == []).

test(regress_test_ghash_nothing_in) :-
	regress_test_ghash_nothing_in(['baz'-'bat', 'foo'-'bar', 'qux'-'quux']).

test(regress_test_ghash_nothing_in2) :-
	regress_test_ghash_nothing_in2(['baz'-'bat', 'foo'-'bar', 'qux'-'quux']).

test(regress_test_ghash_nested_everything_return) :-
	regress_test_ghash_nested_everything_return(List),
	List = ['wibble'-NestedList],
	sort(NestedList, SortedList),
	assertion(SortedList == ['baz'-'bat', 'foo'-'bar', 'qux'-'quux']).

test(regress_test_ghash_nested_everything_return2) :-
	regress_test_ghash_nested_everything_return2(List),
	List = ['wibble'-NestedList],
	sort(NestedList, SortedList),
	assertion(SortedList == ['baz'-'bat', 'foo'-'bar', 'qux'-'quux']).

:- end_tests(plgi_regress_ghashtable).



/* GPtrArray */
:- begin_tests(plgi_regress_garray).

test(regress_test_garray_container_return) :-
	regress_test_garray_container_return(List),
	assertion(List == ['regress']).

test(regress_test_garray_full_return) :-
	regress_test_garray_full_return(List),
	assertion(List == ['regress']).

:- end_tests(plgi_regress_garray).



/* Enums */
:- begin_tests(plgi_regress_enum).

test(regress_test_enum_param_value1) :-
	regress_test_enum_param('REGRESS_TEST_VALUE1', Param),
	plgi_enum_value('REGRESS_TEST_VALUE1', Value),
	assertion(Param == 'value1'),
	assertion(Value == 0).

test(regress_test_enum_param_value2) :-
	regress_test_enum_param('REGRESS_TEST_VALUE2', Param),
	plgi_enum_value('REGRESS_TEST_VALUE2', Value),
	assertion(Param == 'value2'),
	assertion(Value == 1).

test(regress_test_enum_param_value3) :-
	regress_test_enum_param('REGRESS_TEST_VALUE3', Param),
	plgi_enum_value('REGRESS_TEST_VALUE3', Value),
	assertion(Param == 'value3'),
	assertion(Value == -1).

test(regress_test_enum_param_value4) :-
	regress_test_enum_param('REGRESS_TEST_VALUE4', Param),
	plgi_enum_value('REGRESS_TEST_VALUE4', Value),
	assertion(Param == 'value4'),
	assertion(Value == 48).

test(regress_test_unsigned_enum_param_value1) :-
	regress_test_unsigned_enum_param('REGRESS_TEST_UNSIGNED_VALUE1', Param),
	plgi_enum_value('REGRESS_TEST_UNSIGNED_VALUE1', Value),
	assertion(Param == 'value1'),
	assertion(Value == 1).

test(regress_test_unsigned_enum_param_value2) :-
	regress_test_unsigned_enum_param('REGRESS_TEST_UNSIGNED_VALUE2', Param),
	plgi_enum_value('REGRESS_TEST_UNSIGNED_VALUE2', Value),
	assertion(Param == 'value2'),
	assertion(Value == 0x80000000).

:- end_tests(plgi_regress_enum).



/* Flags */
:- begin_tests(plgi_regress_flags).

test(regress_global_get_flags_out) :-
	regress_global_get_flags_out(Flags),
	assertion(Flags == ['TEST_FLAG1', 'TEST_FLAG3']).

:- end_tests(plgi_regress_flags).



/* Structs */
:- begin_tests(plgi_regress_struct).

test(regress_test_struct_a) :-
	StructTerm = 'RegressTestStructA'( 'some_int'=42, 'some_int8'=12, 'some_double'=2.0, 'some_enum'='REGRESS_TEST_VALUE2' ),
	plgi_struct_new(StructTerm, Struct),
	plgi_struct_term(Struct, StructTermCopy),
	assertion(StructTermCopy == StructTerm).
	
test(regress_test_struct_a_clone) :-
	StructTerm = 'RegressTestStructA'( 'some_int'=42, 'some_int8'=12, 'some_double'=2.0, 'some_enum'='REGRESS_TEST_VALUE2' ),
	plgi_struct_new(StructTerm, Struct),
	regress_test_struct_a_clone(Struct, StructClone),
	assertion(Struct \== StructClone),
	plgi_struct_term(StructClone, StructCloneTerm),
	assertion(StructCloneTerm == StructTerm).

test(regress_test_struct_a_parse) :-
	regress_test_struct_a_parse(Struct, 'ignored'),
	plgi_struct_term(Struct, StructTerm),
	assertion(StructTerm == 'RegressTestStructA'( 'some_int'=23, 'some_int8'=0, 'some_double'=0.0, 'some_enum'='REGRESS_TEST_VALUE1' )).

test(regress_test_struct_b) :-
	StructATerm = 'RegressTestStructA'( 'some_int'=42, 'some_int8'=12, 'some_double'=2.0, 'some_enum'='REGRESS_TEST_VALUE2' ),
	plgi_struct_new(StructATerm, StructA),
	StructBTerm = 'RegressTestStructB'( 'some_int8'=21, 'nested_a'=StructA ),
	plgi_struct_new(StructBTerm, StructB),
	plgi_struct_get_field(StructB, 'some_int8', SomeInt8),
	assertion(SomeInt8 == 21),
	plgi_struct_get_field(StructB, 'nested_a', NestedA),
	assertion(NestedA \== StructA),
	plgi_struct_term(NestedA, NestedATerm),
	assertion(NestedATerm == StructATerm).
	
test(regress_test_struct_b_clone) :-
	StructATerm = 'RegressTestStructA'( 'some_int'=42, 'some_int8'=12, 'some_double'=2.0, 'some_enum'='REGRESS_TEST_VALUE2' ),
	plgi_struct_new(StructATerm, StructA),
	StructBTerm = 'RegressTestStructB'( 'some_int8'=21, 'nested_a'=StructA ),
	plgi_struct_new(StructBTerm, StructB),
	regress_test_struct_b_clone(StructB, StructBClone),
	assertion(StructB \== StructBClone),
	plgi_struct_get_field(StructB, 'some_int8', SomeInt8),
	assertion(SomeInt8 == 21),
	plgi_struct_get_field(StructB, 'nested_a', NestedA),
	assertion(NestedA \== StructA),
	plgi_struct_term(NestedA, NestedATerm),
	assertion(NestedATerm == StructATerm).

test(regress_test_simple_boxed_a_copy) :-
	BoxedTerm = 'RegressTestSimpleBoxedA'( 'some_int'=42, 'some_int8'=12, 'some_double'=2.0, 'some_enum'='REGRESS_TEST_VALUE2' ),
	plgi_struct_new(BoxedTerm, Boxed),
	regress_test_simple_boxed_a_copy(Boxed, BoxedCopy),
	assertion(BoxedCopy \== Boxed),
	plgi_struct_term(BoxedCopy, BoxedCopyTerm),
	assertion(BoxedCopyTerm == BoxedTerm).

test(regress_test_simple_boxed_a_equals) :-
	Boxed1Term = 'RegressTestSimpleBoxedA'( 'some_int'=42, 'some_int8'=12, 'some_double'=2.0, 'some_enum'='REGRESS_TEST_VALUE2' ),
	plgi_struct_new(Boxed1Term, Boxed1),
	Boxed2Term = 'RegressTestSimpleBoxedA'( 'some_int'=42, 'some_int8'=12, 'some_double'=2.0, 'some_enum'='REGRESS_TEST_VALUE2' ),
	plgi_struct_new(Boxed2Term, Boxed2),
	assertion(regress_test_simple_boxed_a_equals(Boxed1, Boxed2, true)).

test(regress_test_simple_boxed_a_const_return) :-
	regress_test_simple_boxed_a_const_return(Boxed),
	plgi_struct_term(Boxed, BoxedTerm),
	assertion(BoxedTerm == 'RegressTestSimpleBoxedA'( 'some_int'=5, 'some_int8'=6, 'some_double'=7.0, 'some_enum'='REGRESS_TEST_VALUE1' )).

test(regress_test_simple_boxed_b_copy) :-
	BoxedATerm = 'RegressTestSimpleBoxedA'( 'some_int'=42, 'some_int8'=12, 'some_double'=2.0, 'some_enum'='REGRESS_TEST_VALUE2' ),
	plgi_struct_new(BoxedATerm, BoxedA),
	BoxedBTerm = 'RegressTestSimpleBoxedB'( 'some_int8'=21, 'nested_a'=BoxedA ),
	plgi_struct_new(BoxedBTerm, BoxedB),
	regress_test_simple_boxed_b_copy(BoxedB, BoxedBCopy),
	assertion(BoxedBCopy \== BoxedB),
	plgi_struct_get_field(BoxedBCopy, 'some_int8', SomeInt8),
	assertion(SomeInt8 == 21),
	plgi_struct_get_field(BoxedBCopy, 'nested_a', NestedA),
	plgi_struct_term(NestedA, NestedATerm),
	assertion(NestedATerm == BoxedATerm).

test(regress_test_boxed_new) :-
	regress_test_boxed_new(Boxed),
	%plgi_struct_term(Boxed, BoxedTerm),
	plgi_struct_get_field(Boxed, 'some_int8', SomeInt8),
	assertion(SomeInt8 == 0),
	plgi_struct_get_field(Boxed, 'nested_a', NestedA),
	plgi_struct_term(NestedA, NestedATerm),
	assertion(NestedATerm == 'RegressTestSimpleBoxedA'( 'some_int'=0, 'some_int8'=0, 'some_double'=0.0, 'some_enum'='REGRESS_TEST_VALUE1' )),
	plgi_struct_get_field(Boxed, 'priv', _Private),
	% FIXME: add pred to get type of 'Private',
	true.

test(regress_test_boxed_new_alternative_constructor1) :-
	regress_test_boxed_new_alternative_constructor1(42, Boxed),
	%plgi_struct_term(Boxed, BoxedTerm),
	plgi_struct_get_field(Boxed, 'some_int8', SomeInt8),
	assertion(SomeInt8 == 42),
	plgi_struct_get_field(Boxed, 'nested_a', NestedA),
	plgi_struct_term(NestedA, NestedATerm),
	assertion(NestedATerm == 'RegressTestSimpleBoxedA'( 'some_int'=0, 'some_int8'=0, 'some_double'=0.0, 'some_enum'='REGRESS_TEST_VALUE1' )),
	plgi_struct_get_field(Boxed, 'priv', _Private),
	% FIXME: add pred to get type of 'Private',
	true.

test(regress_test_boxed_new_alternative_constructor2) :-
	regress_test_boxed_new_alternative_constructor2(42, 24, Boxed),
	%plgi_struct_term(Boxed, BoxedTerm),
	plgi_struct_get_field(Boxed, 'some_int8', SomeInt8),
	assertion(SomeInt8 == 66),
	plgi_struct_get_field(Boxed, 'nested_a', NestedA),
	plgi_struct_term(NestedA, NestedATerm),
	assertion(NestedATerm == 'RegressTestSimpleBoxedA'( 'some_int'=0, 'some_int8'=0, 'some_double'=0.0, 'some_enum'='REGRESS_TEST_VALUE1' )),
	plgi_struct_get_field(Boxed, 'priv', _Private),
	% FIXME: add pred to get type of 'Private',
	true.

test(regress_test_boxed_new_alternative_constructor3) :-
	regress_test_boxed_new_alternative_constructor3('42', Boxed),
	%plgi_struct_term(Boxed, BoxedTerm),
	plgi_struct_get_field(Boxed, 'some_int8', SomeInt8),
	assertion(SomeInt8 == 42),
	plgi_struct_get_field(Boxed, 'nested_a', NestedA),
	plgi_struct_term(NestedA, NestedATerm),
	assertion(NestedATerm == 'RegressTestSimpleBoxedA'( 'some_int'=0, 'some_int8'=0, 'some_double'=0.0, 'some_enum'='REGRESS_TEST_VALUE1' )),
	plgi_struct_get_field(Boxed, 'priv', _Private),
	% FIXME: add pred to get type of 'Private',
	true.

test(regress_test_boxed_copy) :-
	regress_test_boxed_new_alternative_constructor1(42, Boxed),
	regress_test_boxed_copy(Boxed, BoxedCopy),
	assertion(BoxedCopy \== Boxed),
	%plgi_struct_term(Boxed, BoxedTerm),
	plgi_struct_get_field(BoxedCopy, 'some_int8', SomeInt8),
	assertion(SomeInt8 == 42),
	plgi_struct_get_field(BoxedCopy, 'nested_a', NestedA),
	plgi_struct_term(NestedA, NestedATerm),
	assertion(NestedATerm == 'RegressTestSimpleBoxedA'( 'some_int'=0, 'some_int8'=0, 'some_double'=0.0, 'some_enum'='REGRESS_TEST_VALUE1' )),
	plgi_struct_get_field(BoxedCopy, 'priv', _Private),
	% FIXME: add pred to get type of 'Private',
	true.

test(regress_test_boxed_equals) :-
	regress_test_boxed_new_alternative_constructor1(42, Boxed1),
	regress_test_boxed_new_alternative_constructor1(24, Boxed2),
	regress_test_boxed_new_alternative_constructor2(24, 18, Boxed3),
	assertion(regress_test_boxed_equals(Boxed1, Boxed1, true)),
	assertion(regress_test_boxed_equals(Boxed1, Boxed3, true)),
	assertion(regress_test_boxed_equals(Boxed3, Boxed1, true)),
	assertion(regress_test_boxed_equals(Boxed1, Boxed2, false)).

test(regress_test_boxed_b_new) :-
	regress_test_boxed_b_new(24, 42, Boxed),
	plgi_struct_term(Boxed, BoxedTerm),
	assertion(BoxedTerm == 'RegressTestBoxedB'( 'some_int8'=24, 'some_long'=42 )).

test(regress_test_boxed_b_copy) :-
	BoxedTerm = 'RegressTestBoxedB'( 'some_int8'=24, 'some_long'=42 ),
	plgi_struct_new(BoxedTerm, Boxed),
	regress_test_boxed_b_copy(Boxed, BoxedCopy),
	assertion(BoxedCopy \== Boxed),
	plgi_struct_term(BoxedCopy, BoxedCopyTerm),
	assertion(BoxedCopyTerm == BoxedTerm).

test(regress_test_boxed_c_new) :-
	regress_test_boxed_c_new(Boxed),
	plgi_struct_term(Boxed, BoxedTerm),
	assertion(BoxedTerm == 'RegressTestBoxedC'( 'refcount'=1, 'another_thing'=42 )).

test(regress_test_boxed_d_new) :-
	regress_test_boxed_d_new('foo', 42, Boxed),
	regress_test_boxed_d_get_magic(Boxed, Magic),
	assertion(Magic == 45).

test(regress_test_boxed_d_copy) :-
	regress_test_boxed_d_new('foo', 42, Boxed),
	regress_test_boxed_d_copy(Boxed, BoxedCopy),
	assertion(BoxedCopy \== Boxed),
	regress_test_boxed_d_get_magic(BoxedCopy, Magic),
	assertion(Magic == 45).

test(regress_test_struct_fixed_array_frob) :-
	plgi_struct_new('RegressTestStructFixedArray'(), Struct),
	regress_test_struct_fixed_array_frob(Struct),
	plgi_struct_term(Struct, StructTerm),
	assertion(StructTerm == 'RegressTestStructFixedArray'( 'just_int'=7, 'array'=[42,43,44,45,46,47,48,49,50,51] )).

test(regress_like_xkl_config_item_set_name) :-
	plgi_struct_new('RegressLikeXklConfigItem'(), Struct),
	regress_like_xkl_config_item_set_name(Struct, 'const \u2665 utf8'),
	plgi_struct_term(Struct, StructTerm),
	assertion(StructTerm == 'RegressLikeXklConfigItem'( name=[99,111,110,115,116,32,-30,-103,-91,32,117,116,102,56,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0] )).

:- end_tests(plgi_regress_struct).



/* GObject */
:- begin_tests(plgi_regress_object).

test(regress_test_obj_new) :-
	regress_constructor(Object0),
	regress_test_obj_new(Object0, Object),
	assertion(g_object_type(Object, 'RegressTestObj')).

test(regress_constructor) :-
	regress_constructor(Object),
	assertion(g_object_type(Object, 'RegressTestObj')).

test(regress_test_obj_new_from_file) :-
	regress_test_obj_new_from_file('/path/to/file', Object),
	assertion(g_object_type(Object, 'RegressTestObj')).

test(regress_test_obj_set_bare) :-
	regress_constructor(Object1),
	regress_constructor(Object2),
	regress_test_obj_set_bare(Object1, Object2),
	g_object_get_property(Object1, 'bare', Value),
	assertion(Value == Object2).

user:sig_handler__void(_Object, _UserData) :-
	flag(sig_handled, X, X+1).

user:sig_handler__int64(_Object, Int, _UserData, Ret) :-
	assertion(Int == 0x7FFFFFFFFFFFFFFF),
	Ret = Int,
	flag(sig_handled, X, X+1).

user:sig_handler__uint64(_Object, Int, _UserData, Ret) :-
	assertion(Int == 0xFFFFFFFFFFFFFFFF),
	Ret = Int,
	flag(sig_handled, X, X+1).

user:sig_handler__boxed(_Object, Boxed, _UserData) :-
	plgi_struct_term(Boxed, BoxedTerm),
	assertion(BoxedTerm == 'RegressTestSimpleBoxedA'( 'some_int'=42, 'some_int8'=12, 'some_double'=2.0, 'some_enum'='REGRESS_TEST_VALUE2' )),
	flag(sig_handled, X, X+1).

user:sig_handler__array(_Object, List, _UserData) :-
	assertion(List == [0, 1, 2, 3, 4]),
	flag(sig_handled, X, X+1).

user:sig_handler__array_ret(_Object, Int, _UserData, List) :-
	assertion(Int == 42),
	List = [0, 1, 2, 3, 4],
	flag(sig_handled, X, X+1).

user:sig_handler__hashtable(_Object, List, _UserData) :-
	sort(List, ListSorted),
	ListSorted = ['boolean'-BooleanGValue,
                      'enum'-EnumGValue,
                      'flags'-FlagsGValue,
                      'integer'-IntegerGValue,
                      'string'-StringGValue,
                      'strings'-StringsGValue],
	assertion(g_is_value(BooleanGValue)),
	assertion(g_value_holds(BooleanGValue, 'gboolean')),
	g_value_get_boolean(BooleanGValue, Boolean),
	assertion(Boolean == true),
	assertion(g_is_value(EnumGValue)),
	assertion(g_value_holds(EnumGValue, 'RegressTestEnum')),
	g_value_get_enum(EnumGValue, EnumValue),
	plgi_enum_value('REGRESS_TEST_VALUE2', RegressTestValue2),
	assertion(EnumValue == RegressTestValue2),
	assertion(g_is_value(FlagsGValue)),
	assertion(g_value_holds(FlagsGValue, 'RegressTestFlags')),
	g_value_get_flags(FlagsGValue, FlagValue),
	plgi_enum_value('TEST_FLAG1', RegressTestFlag1),
	plgi_enum_value('TEST_FLAG3', RegressTestFlag3),
	assertion(FlagValue =:= RegressTestFlag1 \/ RegressTestFlag3),
	assertion(g_is_value(IntegerGValue)),
	assertion(g_value_holds(IntegerGValue, 'gint')),
	g_value_get_int(IntegerGValue, Integer),
	assertion(Integer == 12),
	assertion(g_is_value(StringGValue)),
	assertion(g_value_holds(StringGValue, 'gchararray')),
	g_value_get_string(StringGValue, String),
	assertion(String == 'some text'),
	assertion(g_is_value(StringsGValue)),
	assertion(g_value_holds(StringsGValue, 'GStrv')),
	g_value_get_boxed(StringsGValue, Strings),
	assertion(Strings == ['first', 'second', 'third']),
	flag(sig_handled, X, X+1).

user:sig_handler__strv(_Object, List, _UserData) :-
	assertion(List == ['one', 'two', 'three']),
	flag(sig_handled, X, X+1).

user:sig_handler__object(_Object, Object, _UserData) :-
	assertion(g_is_object(Object)),
	g_object_get_property(Object, 'int', Value),
	assertion(Value == 3),
	flag(sig_handled, X, X+1).

user:sig_handler__run_type(Object, ExpectedRunType) :-
	g_signal_get_invocation_hint(Object, InvocationHint),
	plgi_struct_get_field(InvocationHint, 'run_type', RunType),
	assertion(RunType == [ExpectedRunType]),
	flag(sig_handled, X, X+1).

test(regress_test_obj_emit_sig_with_void) :-
	flag(sig_handled, X0, X0),
	regress_constructor(Object),
	g_signal_connect(Object, 'test', sig_handler__void/2, {null}, _),
	g_signal_emit(Object, 'test', {null}, []),
	X1 is X0 + 1,
	assertion(flag(sig_handled, X1, X1)).

test(regress_test_obj_emit_sig_with_int64) :-
	flag(sig_handled, X0, X0),
	regress_constructor(Object),
	g_signal_connect(Object, 'sig-with-int64-prop', sig_handler__int64/4, {null}, _),
	regress_test_obj_emit_sig_with_int64(Object),
	X1 is X0 + 1,
	assertion(flag(sig_handled, X1, X1)).

test(regress_test_obj_emit_sig_with_uint64) :-
	flag(sig_handled, X0, X0),
	regress_constructor(Object),
	g_signal_connect(Object, 'sig-with-uint64-prop', sig_handler__uint64/4, {null}, _),
	regress_test_obj_emit_sig_with_uint64(Object),
	X1 is X0 + 1,
	assertion(flag(sig_handled, X1, X1)).

test(regress_test_obj_emit_sig_with_boxed, [throws(error(plgi_error('cannot pass-by-value interface types'), _))]) :-
	flag(sig_handled, X0, X0),
	regress_constructor(Object),
	g_signal_connect(Object, 'test-with-static-scope-arg', sig_handler__boxed/3, {null}, _),
	BoxedTerm = 'RegressTestSimpleBoxedA'( 'some_int'=42, 'some_int8'=12, 'some_double'=2.0, 'some_enum'='REGRESS_TEST_VALUE2' ),
	plgi_struct_new(BoxedTerm, Boxed),
	g_signal_emit(Object, 'test-with-static-scope-arg', {null}, [Boxed]),
	assertion(flag(sig_handled, X0, X0)).

test(regress_test_obj_emit_sig_with_array) :-
	flag(sig_handled, X0, X0),
	regress_constructor(Object),
	g_signal_connect(Object, 'sig-with-array-prop', sig_handler__array/3, {null}, _),
	List = [0, 1, 2, 3, 4],
	g_signal_emit(Object, 'sig-with-array-prop', {null}, [List]),
	X1 is X0 + 1,
	assertion(flag(sig_handled, X1, X1)).

test(regress_test_obj_emit_sig_with_array_len) :-
	flag(sig_handled, X0, X0),
	regress_constructor(Object),
	g_signal_connect(Object, 'sig-with-array-len-prop', sig_handler__array/3, {null}, _),
	List = [0, 1, 2, 3, 4],
	g_signal_emit(Object, 'sig-with-array-len-prop', {null}, [List]),
	X1 is X0 + 1,
	assertion(flag(sig_handled, X1, X1)).

test(regress_test_obj_emit_sig_with_intarray_ret) :-
	flag(sig_handled, X0, X0),
	regress_constructor(Object),
	g_signal_connect(Object, 'sig-with-intarray-ret', sig_handler__array_ret/4, {null}, _),
	g_signal_emit(Object, 'sig-with-intarray-ret', {null}, [42, List]),
	assertion(List == [0, 1, 2, 3, 4]),
	X1 is X0 + 1,
	assertion(flag(sig_handled, X1, X1)).

test(regress_test_obj_emit_sig_with_hash) :-
	flag(sig_handled, X0, X0),
	regress_constructor(Object),
	g_signal_connect(Object, 'sig-with-hash-prop', sig_handler__hashtable/3, {null}, _),
	g_value_init('gint', IntegerGValue),
	g_value_set_int(IntegerGValue, 12),
	g_value_init('gboolean', BooleanGValue),
	g_value_set_boolean(BooleanGValue, true),
	g_value_init('gchararray', StringGValue),
	g_value_set_string(StringGValue, 'some text'),
	g_value_init('GStrv', StringsGValue),
	g_value_set_boxed(StringsGValue, ['first', 'second', 'third']),
	g_value_init('RegressTestFlags', FlagsGValue),
	g_value_set_flags(FlagsGValue, ['TEST_FLAG1', 'TEST_FLAG3']),
	g_value_init('RegressTestEnum', EnumGValue),
	g_value_set_enum(EnumGValue, 'REGRESS_TEST_VALUE2'),
	List = ['integer'-IntegerGValue,
                'boolean'-BooleanGValue,
                'string'-StringGValue,
                'strings'-StringsGValue,
                'flags'-FlagsGValue,
                'enum'-EnumGValue],
	g_signal_emit(Object, 'sig-with-hash-prop', {null}, [List]),
	X1 is X0 + 1,
	assertion(flag(sig_handled, X1, X1)).

test(regress_test_obj_emit_sig_with_strv) :-
	flag(sig_handled, X0, X0),
	regress_constructor(Object),
	g_signal_connect(Object, 'sig-with-strv', sig_handler__strv/3, {null}, _),
	List = ['one', 'two', 'three'],
	g_signal_emit(Object, 'sig-with-strv', {null}, [List]),
	X1 is X0 + 1,
	assertion(flag(sig_handled, X1, X1)).

test(regress_test_obj_emit_sig_with_obj) :-
	flag(sig_handled, X0, X0),
	regress_constructor(Object),
	g_signal_connect(Object, 'sig-with-obj', sig_handler__object/3, {null}, _),
	regress_test_obj_emit_sig_with_obj(Object),
	X1 is X0 + 1,
	assertion(flag(sig_handled, X1, X1)).

/* FIXME: add test for cairo foreign struct */

test(regress_test_obj_emit_sig_run_first) :-
	flag(sig_handled, X0, X0),
	regress_constructor(Object),
	g_signal_connect(Object, 'first', sig_handler__run_type/2, 'G_SIGNAL_RUN_FIRST', _),
	g_signal_emit(Object, 'first', {null}, []),
	X1 is X0 + 1,
	assertion(flag(sig_handled, X1, X1)).

test(regress_test_obj_emit_sig_all) :-
	flag(sig_handled, X0, X0),
	regress_constructor(Object),
	g_signal_connect(Object, 'all', sig_handler__run_type/2, 'G_SIGNAL_RUN_FIRST', _),
	g_signal_emit(Object, 'all', {null}, []),
	X1 is X0 + 1,
	assertion(flag(sig_handled, X1, X1)).

test(regress_test_obj_instance_method) :-
	regress_constructor(Object),
	regress_test_obj_instance_method(Object, Value),
	assertion(Value == -1).

/* FIXME: Object should not become invalid */
/* knowing instance-parameter transfer relies on gobjection-introspection >=1.41.4 */
test(regress_test_obj_instance_method_full) :-
	regress_constructor(Object),
	regress_test_obj_instance_method_full(Object),
	assertion(g_is_object(Object)).

test(regress_test_obj_static_method) :-
	regress_test_obj_static_method(42, Value),
	assertion(Value == 42.0).

test(regress_forced_method) :-
	regress_constructor(Object),
	regress_forced_method(Object),
	assertion(g_is_object(Object)).

test(regress_test_obj_skip_return_val) :-
	regress_constructor(Object),
	regress_test_obj_skip_return_val(Object, 42, B, 2.0, 24, DOut, Sum, 1, 2),
	assertion(B == 43),
	assertion(DOut == 25),
	assertion(Sum == 21).

test(regress_test_obj_skip_return_val_no_out) :-
	regress_constructor(Object),
	regress_test_obj_skip_return_val_no_out(Object, 42).

test(regress_test_obj_skip_return_val_no_out, [throws(error(glib_error('g-io-error-quark', 0, 'a is zero'), _))]) :-
	regress_constructor(Object),
	regress_test_obj_skip_return_val_no_out(Object, 0).

test(regress_test_obj_skip_param) :-
	regress_constructor(Object),
	regress_test_obj_skip_param(Object, 42, B, 24, DOut, Sum, 1, 2, true),
	assertion(B == 43),
	assertion(DOut == 25),
	assertion(Sum == 21).

test(regress_test_obj_skip_out_param) :-
	regress_constructor(Object),
	regress_test_obj_skip_out_param(Object, 42, 2.0, 24, DOut, Sum, 1, 2, true),
	assertion(DOut == 25),
	assertion(Sum == 21).

test(regress_test_obj_skip_inout_param) :-
	regress_constructor(Object),
	regress_test_obj_skip_inout_param(Object, 42, B, 2.0, Sum, 1, 2, true),
	assertion(B == 43),
	assertion(Sum == 21).

test(regress_test_obj_do_matrix) :-
	regress_constructor(Object),
	regress_test_obj_do_matrix(Object, 'foo', Value),
	assertion(Value == 42).

test(regress_func_obj_null_in) :-
	regress_func_obj_null_in({null}).

test(regress_test_obj_null_out) :-
	regress_test_obj_null_out(Object),
	assertion(Object == {null}).

test(regress_test_array_fixed_out_objects) :-
	regress_test_array_fixed_out_objects(Objects),
	Objects = [Object1, Object2],
	assertion(g_is_object(Object1)),
	assertion(g_is_object(Object2)).

:- end_tests(plgi_regress_object).



/* GObject properties */
:- begin_tests(plgi_regress_object_properties).

test(plgi_regress_object_get_property_bare) :-
	regress_constructor(Object),
	g_object_get_property(Object, 'bare', Value),
	assertion(Value == {null}).

test(plgi_regress_object_set_property_bare) :-
	regress_constructor(Object),
	regress_constructor(PropertyObject),
	g_object_set_property(Object, 'bare', PropertyObject),
	g_object_get_property(Object, 'bare', Value),
	assertion(Value == PropertyObject).

test(plgi_regress_object_get_property_boxed) :-
	regress_constructor(Object),
	g_object_get_property(Object, 'boxed', Value),
	assertion(Value == {null}).

test(plgi_regress_object_set_property_boxed) :-
	regress_constructor(Object),
	regress_test_boxed_new(Boxed),
	plgi_struct_set_field(Boxed, 'some_int8', 42),
	g_object_set_property(Object, 'boxed', Boxed),
	g_object_get_property(Object, 'boxed', Value),
	assertion(Value \== Boxed),
	plgi_struct_get_field(Boxed, 'some_int8', Int1),
	plgi_struct_get_field(Value, 'some_int8', Int2),
	assertion(Int2 == Int1).

test(plgi_regress_object_get_property_hash_table) :-
	regress_constructor(Object),
	g_object_get_property(Object, 'hash-table', Value),
	assertion(Value == []).

test(plgi_regress_object_set_property_hash_table) :-
	regress_constructor(Object),
	HashTable = ['foo'-1, 'bar'-2, 'qux'-3],
	g_object_set_property(Object, 'hash-table', HashTable),
	g_object_get_property(Object, 'hash-table', Value),
	sort(HashTable, HashTableSorted),
	sort(Value, ValueSorted),
	assertion(ValueSorted == HashTableSorted).

test(plgi_regress_object_get_property_list) :-
	regress_constructor(Object),
	g_object_get_property(Object, 'list', Value),
	assertion(Value == []).

test(plgi_regress_object_set_property_list) :-
	regress_constructor(Object),
	List = ['one', 'two', 'three'],
	g_object_set_property(Object, 'list', List),
	g_object_get_property(Object, 'list', Value),
	assertion(Value == List).

test(plgi_regress_object_get_property_int) :-
	regress_constructor(Object),
	g_object_get_property(Object, 'int', Value),
	assertion(Value == 0).

test(plgi_regress_object_set_property_int) :-
	regress_constructor(Object),
	g_object_set_property(Object, 'int', 42),
	g_object_get_property(Object, 'int', Value),
	assertion(Value == 42).

test(plgi_regress_object_get_property_float) :-
	regress_constructor(Object),
	g_object_get_property(Object, 'float', Value),
	assertion(Value == 0.0).

test(plgi_regress_object_set_property_float) :-
	regress_constructor(Object),
	g_object_set_property(Object, 'float', 2.0),
	g_object_get_property(Object, 'float', Value),
	assertion(Value == 2.0).

test(plgi_regress_object_get_property_double) :-
	regress_constructor(Object),
	g_object_get_property(Object, 'double', Value),
	assertion(Value == 0.0).

test(plgi_regress_object_set_property_double) :-
	regress_constructor(Object),
	g_object_set_property(Object, 'double', 2.0),
	g_object_get_property(Object, 'double', Value),
	assertion(Value == 2.0).

test(plgi_regress_object_get_property_string) :-
	regress_constructor(Object),
	g_object_get_property(Object, 'string', Value),
	assertion(Value == {null}).

test(plgi_regress_object_set_property_string) :-
	regress_constructor(Object),
	g_object_set_property(Object, 'string', 'foo'),
	g_object_get_property(Object, 'string', Value),
	assertion(Value == 'foo').

test(plgi_regress_object_get_property_gtype) :-
	regress_constructor(Object),
	g_object_get_property(Object, 'gtype', Value),
	assertion(Value == {null}).

test(plgi_regress_object_set_property_gtype) :-
	regress_constructor(Object),
	g_object_set_property(Object, 'gtype', 'RegressTestSubObj'),
	g_object_get_property(Object, 'gtype', Value),
	assertion(Value == 'RegressTestSubObj').

:- end_tests(plgi_regress_object_properties).



/* GObject inheritence */
:- begin_tests(plgi_regress_object_inheritence).

test(regress_test_sub_obj_new) :-
	regress_test_sub_obj_new(Object),
	assertion(g_object_type(Object, 'RegressTestSubObj')).

test(regress_test_sub_obj_set_bare) :-
	regress_test_sub_obj_new(Object1),
	regress_constructor(Object2),
	regress_test_obj_set_bare(Object1, Object2),
	g_object_get_property(Object1, 'bare', Value),
	assertion(Value == Object2).

test(regress_test_sub_obj_unset_bare) :-
	regress_test_sub_obj_new(Object1),
	regress_constructor(Object2),
	regress_test_obj_set_bare(Object1, Object2),
	regress_test_sub_obj_unset_bare(Object1),
	g_object_get_property(Object1, 'bare', Value),
	assertion(Value == {null}).

test(regress_test_sub_obj_instance_method) :-
	regress_test_sub_obj_new(Object),
	regress_test_obj_instance_method(Object, Value1),
	assertion(Value1 == -1),
	regress_test_sub_obj_instance_method(Object, Value2),
	assertion(Value2 == 0).

:- end_tests(plgi_regress_object_inheritence).



/* Callbacks */
:- begin_tests(plgi_regress_callbacks).

user:callback__void :-
	flag(callback_handled, X, X+1).

user:callback__int(42) :-
	flag(callback_handled, X, X+1).

user:callback__array(Ints, Strings, 42) :-
	assertion(Ints == [-1, 0, 1, 2]),
	assertion(Strings == ['one', 'two', 'three']),
	flag(callback_handled, X, X+1).

user:callback__user_data(UserData, OutValue) :-
	OutValue is UserData * 2,
	flag(callback_handled, X, X+1).

user:callback__g_main_loop(_Source, _Result, _UserData) :-
	user:regress_test_g_main_loop(Loop),
	g_main_loop_quit(Loop),
	flag(callback_handled, X, X+1).

user:callback__hashtable(List) :-
	retractall(user:callback_user_data(_)),
	append(List, ['qux'-42], NewList),
	assert(user:callback_user_data(NewList)),
	flag(callback_handled, X, X+1).

user:callback__gerror(Error) :-
	assertion(Error = error(glib_error('g-io-error-quark', _, _), _)),
	flag(callback_handled, X, X+1).

user:callback__null(Error) :-
	assertion(Error == {null}),
	flag(callback_handled, X, X+1).

test(regress_test_callback) :-
	flag(callback_handled, X0, X0),
	regress_test_callback(user:callback__int/1, Value),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)),
	assertion(Value == 42).

test(regress_test_callback_null) :-
	flag(callback_handled, X0, X0),
	regress_test_callback({null}, Value),
	assertion(flag(callback_handled, X0, X0)),
	assertion(Value == 0).

test(regress_test_multi_callback) :-
	flag(callback_handled, X0, X0),
	regress_test_multi_callback(user:callback__int/1, Value),
	X1 is X0 + 2,
	assertion(flag(callback_handled, X1, X1)),
	assertion(Value == 84).

test(regress_test_array_callback) :-
	flag(callback_handled, X0, X0),
	regress_test_array_callback(user:callback__array/3, Value),
	X1 is X0 + 2,
	assertion(flag(callback_handled, X1, X1)),
	assertion(Value == 84).

test(regress_test_simple_callback) :-
	flag(callback_handled, X0, X0),
	regress_test_simple_callback(user:callback__void/0),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(regress_test_callback_user_data) :-
	flag(callback_handled, X0, X0),
	regress_test_callback_user_data(user:callback__user_data/2, 42, Value),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)),
	assertion(Value == 84).

test(regress_test_callback_user_data_multi) :-
	flag(callback_handled, X0, X0),
	forall(between(1, 1000, N),
	       ( regress_test_callback_user_data(user:callback__user_data/2, N, Value),
	         assertion(Value =:= N*2)
	       )),
	X1 is X0 + 1000,
	assertion(flag(callback_handled, X1, X1)).

test(regress_test_callback_destroy_notify) :-
	flag(callback_handled, X0, X0),
	forall(between(1, 1000, N),
	       ( regress_test_callback_destroy_notify(user:callback__user_data/2, N, Value),
	         assertion(Value =:= N*2)
	       )),
	X1 is X0 + 1000,
	assertion(flag(callback_handled, X1, X1)).

test(regress_test_callback_thaw_notifications) :-
	flag(callback_handled, X0, X0),
	regress_test_callback_thaw_notifications(Value),
	X1 is X0 + 1000,
	assertion(flag(callback_handled, X1, X1)),
	assertion(Value == 1001000).

test(regress_test_callback_destroy_notify_no_user_data) :-
	flag(callback_handled, X0, X0),
	regress_test_callback_destroy_notify(user:callback__user_data/2, {null}, _),
	assertion(flag(callback_handled, X0, X0)).

test(regress_test_callback_async) :-
	flag(callback_handled, X0, X0),
	regress_test_callback_async(user:callback__user_data/2, 42),
	assertion(flag(callback_handled, X0, X0)).

test(regress_test_callback_thaw_async) :-
	flag(callback_handled, X0, X0),
	regress_test_callback_thaw_async(Value),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)),
	assertion(Value == 84).

test(regress_test_async_ready_callback) :-
	flag(callback_handled, X0, X0),
	retractall(user:regress_test_g_main_loop(_)),
	g_main_loop_new({null}, false, Loop),
	assert(user:regress_test_g_main_loop(Loop)),
	regress_test_async_ready_callback(user:callback__g_main_loop/3),
	g_main_loop_run(Loop),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(regress_test_obj_instance_method_callback) :-
	flag(callback_handled, X0, X0),
	regress_constructor(Object),
	regress_test_obj_instance_method_callback(Object, user:callback__int/1),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(regress_test_obj_static_method_callback) :-
	flag(callback_handled, X0, X0),
	regress_test_obj_static_method_callback(user:callback__int/1),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(regress_test_obj_new_callback) :-
	flag(callback_handled, X0, X0),
	regress_test_obj_new_callback(user:callback__user_data/2, 42, Object),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)),
	assertion(g_object_type(Object, 'RegressTestObj')),
	regress_test_callback_thaw_notifications(Value),
	X2 is X1 + 1,
	assertion(flag(callback_handled, X2, X2)),
	assertion(Value == 84).

test(regress_test_hash_table_callback) :-
	flag(callback_handled, X0, X0),
	List = ['foo'-1, 'bar'-2],
	assert(user:callback_user_data(List)),
	regress_test_hash_table_callback(List, user:callback__hashtable/1),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)),
	user:callback_user_data(NewList),
	assertion(NewList = ['foo'-1, 'bar'-2, 'qux'-42]).

test(regress_test_gerror_callback) :-
	flag(callback_handled, X0, X0),
	regress_test_gerror_callback(user:callback__gerror/1),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(regress_test_null_gerror_callback) :-
	flag(callback_handled, X0, X0),
	regress_test_null_gerror_callback(user:callback__null/1),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

test(regress_test_owned_gerror_callback) :-
	flag(callback_handled, X0, X0),
	regress_test_owned_gerror_callback(user:callback__gerror/1),
	X1 is X0 + 1,
	assertion(flag(callback_handled, X1, X1)).

:- end_tests(plgi_regress_callbacks).



/* Non-standard GObject prefix */
:- begin_tests(plgi_regress_non_standard_prefix).

test(regress_test_wi_802_1x_new) :-
	regress_test_wi_802_1x_new(Object),
	assertion(g_is_object(Object)),
	assertion(g_object_type(Object, 'RegressTestWi8021x')).

test(regress_test_wi_802_1x_set_testbool) :-
	regress_test_wi_802_1x_new(Object),
	regress_test_wi_802_1x_set_testbool(Object, false),
	g_object_get_property(Object, 'testbool', Value),
	assertion(Value == false).

test(regress_test_wi_802_1x_get_testbool) :-
	regress_test_wi_802_1x_new(Object),
	regress_test_wi_802_1x_get_testbool(Object, true),
	g_object_get_property(Object, 'testbool', Value),
	assertion(Value == true).

test(regress_test_wi_802_1x_static_method) :-
	regress_test_wi_802_1x_static_method(42, Value),
	assertion(Value == 84).

:- end_tests(plgi_regress_non_standard_prefix).



/* GObject floating refcount */
:- begin_tests(plgi_regress_floating_object).

test(regress_test_floating_new) :-
	regress_test_floating_new(Object),
	assertion(g_is_object(Object)).

test(regress_test_floating_g_object_new) :-
	g_object_new('RegressTestFloating', [], Object),
	assertion(g_is_object(Object)).

:- end_tests(plgi_regress_floating_object).



/* Torture profiling */
:- begin_tests(plgi_regress_torture_profile).

test(regress_test_torture_signature_0) :-
	forall(between(1, 10000, M),
	       ( regress_test_torture_signature_0(1000, Y, Z, 'foo', Q, M),
	         assertion(Y == 1000.0),
	         assertion(Z == 2000),
	         assertion(Q =:= 3+M)
	       )),
	garbage_collect_atoms.

test(regress_test_torture_signature_1) :-
	forall(between(1, 10000, M),
	       (   M mod 2 =:= 0
	       ->  regress_test_torture_signature_1(1000, Y, Z, 'foo', Q, M, true),
	           assertion(Y == 1000.0),
	           assertion(Z == 2000),
	           assertion(Q =:= 3+M)
	       ;   catch(regress_test_torture_signature_1(1000, _, _, 'foo', _, M, _),
	                 E,
	                 ( E = error(glib_error('g-io-error-quark', 0, 'm is odd'), _)
	                 ->  true
	                 ;   throw(E)
	                 )
	                )
	       )),
	garbage_collect_atoms.

user:torture_callback :-
	flag(torture_flag, X, X+1).

test(regress_test_torture_signature_2) :-
	flag(torture_flag, _, 0),
	forall(between(1, 10000, M),
	       ( regress_test_torture_signature_2(1000, user:torture_callback/0, {null}, Y, Z, 'foo', Q, M),
	         assertion(Y == 1000.0),
	         assertion(Z == 2000),
	         assertion(Q =:= 3+M)
	       )),
	assertion(flag(torture_flag, 10000, 10000)),
	garbage_collect_atoms.

test(regress_test_obj_torture_signature_0) :-
	forall(between(1, 10000, M),
	       ( regress_constructor(Object),
	         regress_test_obj_torture_signature_0(Object, 1000, Y, Z, 'foo', Q, M),
	         assertion(Y == 1000.0),
	         assertion(Z == 2000),
	         assertion(Q =:= 3+M)
	       )),
	garbage_collect_atoms.

test(regress_test_obj_torture_signature_1) :-
	forall(between(1, 10000, M),
	       (   M mod 2 =:= 0
	       ->  regress_constructor(Object),
	           regress_test_obj_torture_signature_1(Object, 1000, Y, Z, 'foo', Q, M, true),
	           assertion(Y == 1000.0),
	           assertion(Z == 2000),
	           assertion(Q =:= 3+M)
	       ;   regress_constructor(Object),
	           catch(regress_test_obj_torture_signature_1(Object, 1000, _, _, 'foo', _, M, _),
	                 E,
	                 ( E = error(glib_error('g-io-error-quark', 0, 'm is odd'), _)
	                 ->  true
	                 ;   throw(E)
	                 )
	                )
	       )),
	garbage_collect_atoms.

:- end_tests(plgi_regress_torture_profile).
