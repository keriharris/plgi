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

:- plgi_use_namespace_from_dir('Everything', '.').

:- begin_tests(plgi_parameters_nullfunc).

test(everything_nullfunc) :-
	everything_nullfunc.

:- end_tests(plgi_parameters_nullfunc).

:- begin_tests(plgi_parameters_const_return).

test(everything_const_return_gboolean) :-
	everything_const_return_gboolean(Value),
	assertion(Value == false).

test(everything_const_return_gint8) :-
	everything_const_return_gint8(Value),
	assertion(Value == 0).

test(everything_const_return_guint8) :-
	everything_const_return_guint8(Value),
	assertion(Value == 0).

test(everything_const_return_gint16) :-
	everything_const_return_gint16(Value),
	assertion(Value == 0).

test(everything_const_return_guint16) :-
	everything_const_return_guint16(Value),
	assertion(Value == 0).

test(everything_const_return_gint32) :-
	everything_const_return_gint32(Value),
	assertion(Value == 0).

test(everything_const_return_guint32) :-
	everything_const_return_guint32(Value),
	assertion(Value == 0).

test(everything_const_return_gint64) :-
	everything_const_return_gint64(Value),
	assertion(Value == 0).

test(everything_const_return_guint64) :-
	everything_const_return_guint64(Value),
	assertion(Value == 0).

test(everything_const_return_gchar) :-
	everything_const_return_gchar(Value),
	assertion(Value == 0).

test(everything_const_return_gshort) :-
	everything_const_return_gshort(Value),
	assertion(Value == 0).

test(everything_const_return_gushort) :-
	everything_const_return_gushort(Value),
	assertion(Value == 0).

test(everything_const_return_gint) :-
	everything_const_return_gint(Value),
	assertion(Value == 0).

test(everything_const_return_guint) :-
	everything_const_return_guint(Value),
	assertion(Value == 0).

test(everything_const_return_glong) :-
	everything_const_return_glong(Value),
	assertion(Value == 0).

test(everything_const_return_gulong) :-
	everything_const_return_gulong(Value),
	assertion(Value == 0).

test(everything_const_return_gsize) :-
	everything_const_return_gsize(Value),
	assertion(Value == 0).

test(everything_const_return_gssize) :-
	everything_const_return_gssize(Value),
	assertion(Value == 0).

test(everything_const_return_gintptr) :-
	everything_const_return_gintptr(Value),
	assertion(Value == 0).

test(everything_const_return_guintptr) :-
	everything_const_return_guintptr(Value),
	assertion(Value == 0).

test(everything_const_return_gfloat) :-
	everything_const_return_gfloat(Value),
	assertion(Value == 0.0).

test(everything_const_return_gdouble) :-
	everything_const_return_gdouble(Value),
	assertion(Value == 0.0).

test(everything_const_return_gunichar) :-
	everything_const_return_gunichar(Value),
	assertion(Value == 0).

test(everything_const_return_GType) :-
	everything_const_return_GType(Value),
	assertion(Value == 'GObject').

test(everything_const_return_utf8) :-
	everything_const_return_utf8(Value),
	assertion(Value == '').

test(everything_const_return_filename) :-
	everything_const_return_filename(Value),
	assertion(Value == '').

:- end_tests(plgi_parameters_const_return).

:- begin_tests(plgi_parameters_oneparam).

test(everything_oneparam_gboolean) :-
	everything_oneparam_gboolean(true).

test(everything_oneparam_gint8) :-
	everything_oneparam_gint8(1).

test(everything_oneparam_guint8) :-
	everything_oneparam_guint8(1).

test(everything_oneparam_gint16) :-
	everything_oneparam_gint16(1).

test(everything_oneparam_guint16) :-
	everything_oneparam_guint16(1).

test(everything_oneparam_gint32) :-
	everything_oneparam_gint32(1).

test(everything_oneparam_guint32) :-
	everything_oneparam_guint32(1).

test(everything_oneparam_gint64) :-
	everything_oneparam_gint64(1).

test(everything_oneparam_guint64) :-
	everything_oneparam_guint64(1).

test(everything_oneparam_gchar) :-
	everything_oneparam_gchar(1).

test(everything_oneparam_gshort) :-
	everything_oneparam_gshort(1).

test(everything_oneparam_gushort) :-
	everything_oneparam_gushort(1).

test(everything_oneparam_gint) :-
	everything_oneparam_gint(1).

test(everything_oneparam_guint) :-
	everything_oneparam_guint(1).

test(everything_oneparam_glong) :-
	everything_oneparam_glong(1).

test(everything_oneparam_gulong) :-
	everything_oneparam_gulong(1).

test(everything_oneparam_gsize) :-
	everything_oneparam_gsize(1).

test(everything_oneparam_gssize) :-
	everything_oneparam_gssize(1).

test(everything_oneparam_gintptr) :-
	everything_oneparam_gintptr(1).

test(everything_oneparam_guintptr) :-
	everything_oneparam_guintptr(1).

test(everything_oneparam_gfloat) :-
	everything_oneparam_gfloat(1.0).

test(everything_oneparam_gdouble) :-
	everything_oneparam_gdouble(1.0).

test(everything_oneparam_gunichar) :-
	everything_oneparam_gunichar(1).

test(everything_oneparam_GType) :-
	everything_oneparam_GType('GObject').

test(everything_oneparam_utf8) :-
	everything_oneparam_utf8('utf8').

test(everything_oneparam_filename) :-
	everything_oneparam_filename('filename').

:- end_tests(plgi_parameters_oneparam).

:- begin_tests(plgi_parameters_one_outparam).

test(everything_one_outparam_gboolean) :-
	everything_one_outparam_gboolean(Value),
	assertion(Value == false).

test(everything_one_outparam_gint8) :-
	everything_one_outparam_gint8(Value),
	assertion(Value == 0).

test(everything_one_outparam_guint8) :-
	everything_one_outparam_guint8(Value),
	assertion(Value == 0).

test(everything_one_outparam_gint16) :-
	everything_one_outparam_gint16(Value),
	assertion(Value == 0).

test(everything_one_outparam_guint16) :-
	everything_one_outparam_guint16(Value),
	assertion(Value == 0).

test(everything_one_outparam_gint32) :-
	everything_one_outparam_gint32(Value),
	assertion(Value == 0).

test(everything_one_outparam_guint32) :-
	everything_one_outparam_guint32(Value),
	assertion(Value == 0).

test(everything_one_outparam_gint64) :-
	everything_one_outparam_gint64(Value),
	assertion(Value == 0).

test(everything_one_outparam_guint64) :-
	everything_one_outparam_guint64(Value),
	assertion(Value == 0).

test(everything_one_outparam_gchar) :-
	everything_one_outparam_gchar(Value),
	assertion(Value == {null}).

test(everything_one_outparam_gshort) :-
	everything_one_outparam_gshort(Value),
	assertion(Value == 0).

test(everything_one_outparam_gushort) :-
	everything_one_outparam_gushort(Value),
	assertion(Value == 0).

test(everything_one_outparam_gint) :-
	everything_one_outparam_gint(Value),
	assertion(Value == 0).

test(everything_one_outparam_guint) :-
	everything_one_outparam_guint(Value),
	assertion(Value == 0).

test(everything_one_outparam_glong) :-
	everything_one_outparam_glong(Value),
	assertion(Value == 0).

test(everything_one_outparam_gulong) :-
	everything_one_outparam_gulong(Value),
	assertion(Value == 0).

test(everything_one_outparam_gsize) :-
	everything_one_outparam_gsize(Value),
	assertion(Value == 0).

test(everything_one_outparam_gssize) :-
	everything_one_outparam_gssize(Value),
	assertion(Value == 0).

test(everything_one_outparam_gintptr) :-
	everything_one_outparam_gintptr(Value),
	assertion(Value == 0).

test(everything_one_outparam_guintptr) :-
	everything_one_outparam_guintptr(Value),
	assertion(Value == 0).

test(everything_one_outparam_gfloat) :-
	everything_one_outparam_gfloat(Value),
	assertion(Value == 0.0).

test(everything_one_outparam_gdouble) :-
	everything_one_outparam_gdouble(Value),
	assertion(Value == 0.0).

test(everything_one_outparam_gunichar) :-
	everything_one_outparam_gunichar(Value),
	assertion(Value == 0).

test(everything_one_outparam_GType) :-
	everything_one_outparam_GType(Value),
	assertion(Value == {null}).

test(everything_one_outparam_utf8) :-
	everything_one_outparam_utf8(Value),
	assertion(Value == {null}).

test(everything_one_outparam_filename) :-
	everything_one_outparam_filename(Value),
	assertion(Value == {null}).

:- end_tests(plgi_parameters_one_outparam).

:- begin_tests(plgi_parameters_passthrough_one).

test(everything_passthrough_one_gboolean) :-
	everything_passthrough_one_gboolean(true, Value),
	assertion(Value == true).

test(everything_passthrough_one_gint8) :-
	everything_passthrough_one_gint8(1, Value),
	assertion(Value == 1).

test(everything_passthrough_one_guint8) :-
	everything_passthrough_one_guint8(1, Value),
	assertion(Value == 1).

test(everything_passthrough_one_gint16) :-
	everything_passthrough_one_gint16(1, Value),
	assertion(Value == 1).

test(everything_passthrough_one_guint16) :-
	everything_passthrough_one_guint16(1, Value),
	assertion(Value == 1).

test(everything_passthrough_one_gint32) :-
	everything_passthrough_one_gint32(1, Value),
	assertion(Value == 1).

test(everything_passthrough_one_guint32) :-
	everything_passthrough_one_guint32(1, Value),
	assertion(Value == 1).

test(everything_passthrough_one_gint64) :-
	everything_passthrough_one_gint64(1, Value),
	assertion(Value == 1).

test(everything_passthrough_one_guint64) :-
	everything_passthrough_one_guint64(1, Value),
	assertion(Value == 1).

test(everything_passthrough_one_gchar) :-
	everything_passthrough_one_gchar(1, Value),
	assertion(Value == 1).

test(everything_passthrough_one_gshort) :-
	everything_passthrough_one_gshort(1, Value),
	assertion(Value == 1).

test(everything_passthrough_one_gushort) :-
	everything_passthrough_one_gushort(1, Value),
	assertion(Value == 1).

test(everything_passthrough_one_gint) :-
	everything_passthrough_one_gint(1, Value),
	assertion(Value == 1).

test(everything_passthrough_one_guint) :-
	everything_passthrough_one_guint(1, Value),
	assertion(Value == 1).

test(everything_passthrough_one_glong) :-
	everything_passthrough_one_glong(1, Value),
	assertion(Value == 1).

test(everything_passthrough_one_gulong) :-
	everything_passthrough_one_gulong(1, Value),
	assertion(Value == 1).

test(everything_passthrough_one_gsize) :-
	everything_passthrough_one_gsize(1, Value),
	assertion(Value == 1).

test(everything_passthrough_one_gssize) :-
	everything_passthrough_one_gssize(1, Value),
	assertion(Value == 1).

test(everything_passthrough_one_gintptr) :-
	everything_passthrough_one_gintptr(1, Value),
	assertion(Value == 1).

test(everything_passthrough_one_guintptr) :-
	everything_passthrough_one_guintptr(1, Value),
	assertion(Value == 1).

test(everything_passthrough_one_gfloat) :-
	everything_passthrough_one_gfloat(1.0, Value),
	assertion(Value == 1.0).

test(everything_passthrough_one_gdouble) :-
	everything_passthrough_one_gdouble(1.0, Value),
	assertion(Value == 1.0).

test(everything_passthrough_one_gunichar) :-
	everything_passthrough_one_gunichar(1, Value),
	assertion(Value == 1).

test(everything_passthrough_one_GType) :-
	everything_passthrough_one_GType('GObject', Value),
	assertion(Value == 'GObject').

test(everything_passthrough_one_utf8) :-
	everything_passthrough_one_utf8('utf8', Value),
	assertion(Value == 'utf8').

test(everything_passthrough_one_filename) :-
	everything_passthrough_one_filename('filename', Value),
	assertion(Value == 'filename').

:- end_tests(plgi_parameters_passthrough_one).
