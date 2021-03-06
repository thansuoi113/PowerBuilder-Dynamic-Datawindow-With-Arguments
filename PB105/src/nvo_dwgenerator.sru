$PBExportHeader$nvo_dwgenerator.sru
forward
global type nvo_dwgenerator from nonvisualobject
end type
type st_data_arg from structure within nvo_dwgenerator
end type
end forward

type st_data_arg from structure
	string		arg_name
	string		arg_type
end type

global type nvo_dwgenerator from nonvisualobject
end type
global nvo_dwgenerator nvo_dwgenerator

type variables
public:
	CONSTANT STRING STRING_TYPE = 'string'
	CONSTANT STRING NUMBER_TYPE = 'number'
	CONSTANT STRING DATE_TYPE = 'date'
	CONSTANT STRING TIME_TYPE = 'time'
	CONSTANT STRING DATETIME_TYPE = 'datetime'
	CONSTANT STRING DECIMAL_TYPE = 'decimal'
	CONSTANT STRING STRINGARRAY_TYPE = 'stringlist'
	CONSTANT STRING NUMBERARRAY_TYPE = 'numberlist'
	CONSTANT STRING DATEARRAY_TYPE = 'datelist'
	CONSTANT STRING TIMEARRAY_TYPE = 'timelist'
	CONSTANT STRING DATETIMEARRAY_TYPE = 'datetimelist'
	CONSTANT STRING DECIMALARRAY_TYPE = 'decimallist'

private:
	string sql_syntax
	boolean proc_flag
	st_data_arg args[]
	
	string presentation = 'style(type=grid)'
	transaction trs
end variables

forward prototypes
public function integer set_argument (integer position, string arg_name, string arg_type)
public function integer create_datastore (ref datastore ds)
public subroutine reset ()
public subroutine set_sql (string sql)
public subroutine set_procedure (string proc)
public function integer create_datawindow (datawindow dw)
public subroutine set_presentation (string p)
public subroutine set_transobject (transaction t)
public function integer create_syntax (ref string syntax)
public subroutine get_arguments (datawindow adw, ref string as_arg_name[], ref string as_arg_type[], ref string as_arg_value[])
end prototypes

public function integer set_argument (integer position, string arg_name, string arg_type);//====================================================================
// Function: nvo_dwgenerator.set_argument()
//--------------------------------------------------------------------
// Description:
//--------------------------------------------------------------------
// Arguments:
// 	value	integer	position	
// 	value	string 	arg_name	
// 	value	string 	arg_type	
//--------------------------------------------------------------------
// Returns:  integer
//--------------------------------------------------------------------
// Author:	PB.BaoGa		Date: 2021/06/23
//--------------------------------------------------------------------
// Usage: nvo_dwgenerator.set_argument ( integer position, string arg_name, string arg_type )
//--------------------------------------------------------------------
//	Copyright (c) PB.BaoGa(TM), All rights reserved.
//--------------------------------------------------------------------
// Modify History:
//
//====================================================================

st_data_arg arg

If Position < 1 Then Return -1
If Not (arg_type = STRING_TYPE Or &
	arg_type = NUMBER_TYPE Or &
	arg_type = DATE_TYPE Or &
	arg_type = TIME_TYPE Or &
	arg_type = DATETIME_TYPE Or &
	arg_type = DECIMAL_TYPE Or &
	arg_type = STRINGARRAY_TYPE Or &
	arg_type = NUMBERARRAY_TYPE Or &
	arg_type = DATEARRAY_TYPE Or &
	arg_type = TIMEARRAY_TYPE Or &
	arg_type = DATETIMEARRAY_TYPE Or &
	arg_type = DECIMALARRAY_TYPE) Then
	Return -1
End If

arg.arg_name = arg_name
arg.arg_type = arg_type
args[Position] = arg

Return 0

end function

public function integer create_datastore (ref datastore ds);//====================================================================
// Function: nvo_dwgenerator.create_datastore()
//--------------------------------------------------------------------
// Description:
//--------------------------------------------------------------------
// Arguments:
// 	reference	datastore	ds	
//--------------------------------------------------------------------
// Returns:  integer
//--------------------------------------------------------------------
// Author:	PB.BaoGa		Date: 2021/06/23
//--------------------------------------------------------------------
// Usage: nvo_dwgenerator.create_datastore ( ref datastore ds )
//--------------------------------------------------------------------
//	Copyright (c) PB.BaoGa(TM), All rights reserved.
//--------------------------------------------------------------------
// Modify History:
//
//====================================================================

String dwsyntax
If create_syntax(dwsyntax) < 0 Then Return -1

If Not IsValid(ds) Then
	ds = Create datastore
End If

Return ds.Create(dwsyntax)

end function

public subroutine reset ();//====================================================================
// Function: nvo_dwgenerator.reset()
//--------------------------------------------------------------------
// Description:
//--------------------------------------------------------------------
// Arguments:
//--------------------------------------------------------------------
// Returns:  (none)
//--------------------------------------------------------------------
// Author:	PB.BaoGa		Date: 2021/06/23
//--------------------------------------------------------------------
// Usage: nvo_dwgenerator.reset ( )
//--------------------------------------------------------------------
//	Copyright (c) PB.BaoGa(TM), All rights reserved.
//--------------------------------------------------------------------
// Modify History:
//
//====================================================================

st_data_arg empty_args[]

args = empty_args
sql_syntax = ''
presentation = 'style(type=grid)'
trs = sqlca

end subroutine

public subroutine set_sql (string sql);
sql_syntax = sql
proc_flag = False


end subroutine

public subroutine set_procedure (string proc);
sql_syntax = Proc
proc_flag = True


end subroutine

public function integer create_datawindow (datawindow dw);//====================================================================
// Function: nvo_dwgenerator.create_datawindow()
//--------------------------------------------------------------------
// Description:
//--------------------------------------------------------------------
// Arguments:
// 	value	datawindow	dw	
//--------------------------------------------------------------------
// Returns:  integer
//--------------------------------------------------------------------
// Author:	PB.BaoGa		Date: 2021/06/23
//--------------------------------------------------------------------
// Usage: nvo_dwgenerator.create_datawindow ( datawindow dw )
//--------------------------------------------------------------------
//	Copyright (c) PB.BaoGa(TM), All rights reserved.
//--------------------------------------------------------------------
// Modify History:
//
//====================================================================

If Not IsValid(dw) Then Return -1

String dwsyntax
If create_syntax(dwsyntax) < 0 Then Return -1

Return dw.Create(dwsyntax)

end function

public subroutine set_presentation (string p);presentation = p

end subroutine

public subroutine set_transobject (transaction t);trs = t

end subroutine

public function integer create_syntax (ref string syntax);//====================================================================
// Function: nvo_dwgenerator.create_syntax()
//--------------------------------------------------------------------
// Description:
//--------------------------------------------------------------------
// Arguments:
// 	reference	string	syntax	
//--------------------------------------------------------------------
// Returns:  integer
//--------------------------------------------------------------------
// Author:	PB.BaoGa		Date: 2021/06/23
//--------------------------------------------------------------------
// Usage: nvo_dwgenerator.create_syntax ( ref string syntax )
//--------------------------------------------------------------------
//	Copyright (c) PB.BaoGa(TM), All rights reserved.
//--------------------------------------------------------------------
// Modify History:
//
//====================================================================

Int i
Long ll_pos, ll_pos_start, ll_pos_end
String ls_sql
Char lc_sql[]
String param
String ls_str
Char lc_syntax[]
Long j, k
String ls_dwsyntax, ls_err
Char lc_dwsql[]
String ls_arguments

ls_sql = sql_syntax
lc_sql = ls_sql

For i = 1 To UpperBound(args)
	ll_pos_start = 1
	Do While True
		ll_pos = Pos(ls_sql, ':'+args[i].arg_name, ll_pos_start)
		If ll_pos <= 0 Then Exit
		ll_pos_end = ll_pos + Len(args[i].arg_name)
		If ll_pos_end < Len(ls_sql) Then
			If Not (lc_sql[ll_pos_end + 1] = ' ' Or &
				lc_sql[ll_pos_end + 1] = '~r' Or &
				lc_sql[ll_pos_end + 1] = '~n' Or &
				lc_sql[ll_pos_end + 1] = '~t' Or &
				lc_sql[ll_pos_end + 1] = ')') Then
				ll_pos_start = ll_pos_end + 1
				Continue
			End If
		End If
		
		Choose Case args[i].arg_type
			Case STRING_TYPE, STRINGARRAY_TYPE
				param = "'"+Space(255)+"'"
			Case NUMBER_TYPE, NUMBERARRAY_TYPE
				param = '0'
			Case DECIMAL_TYPE, DECIMALARRAY_TYPE
				param = '0.0'
			Case Else
				param = ''
		End Choose
		ls_sql = Replace(ls_sql, ll_pos, Len(args[i].arg_name) + 1, param)
		lc_sql = ls_sql
		ll_pos_start = ll_pos
	Loop
Next

//Create SyntaxFromSQL
ls_dwsyntax = trs.SyntaxFromSQL( ls_sql, presentation, ls_err)
If Len(ls_err) > 0 Then 
	Messagebox("Warning", "Create Syntax ls_error " +  ls_err)
	Return -1
End If

//Retrieve
lc_syntax = ls_dwsyntax
If proc_flag Then
	ls_str = 'procedure="'
Else
	ls_str = 'retrieve="'
End If

ll_pos = Pos(ls_dwsyntax, ls_str)
j = ll_pos + Len(ls_str)
Do While j < UpperBound(lc_syntax)
	If lc_syntax[j] = '"' Then
		ll_pos_end = j
		Exit
	End If
	If lc_syntax[j] = '~~' Then
		j += 2
		Continue
	End If
	j ++
Loop

//ls_arguments
For i = 1 To UpperBound(args)
	ls_arguments += '("' + args[i].arg_name + '", ' + args[i].arg_type + ')'
	If i < UpperBound(args) Then
		ls_arguments += ','
	End If
Next
ls_arguments = ' arguments=(' + ls_arguments + ')'
ls_dwsyntax = Replace(ls_dwsyntax, ll_pos_end + 1, 0, ls_arguments)

//Generator Syntax
lc_sql = sql_syntax
For j = 1 To UpperBound(lc_sql)
	If lc_sql[j] = '~~' Or lc_sql[j] = '"' Then
		k++
		lc_dwsql[k] = '~~'
	End If
	k++
	lc_dwsql[k] = lc_sql[j]
Next
ls_dwsyntax = Replace(ls_dwsyntax, ll_pos + Len(ls_str), ll_pos_end - ll_pos - Len(ls_str), lc_dwsql)
Syntax = ls_dwsyntax

Return 0


end function

public subroutine get_arguments (datawindow adw, ref string as_arg_name[], ref string as_arg_type[], ref string as_arg_value[]);//====================================================================
// Function: nvo_dwgenerator.get_arguments()
//--------------------------------------------------------------------
// Description:
//--------------------------------------------------------------------
// Arguments:
// 	value    	datawindow	adw          	
// 	reference	string    	as_arg_name[]	
// 	reference	string    	as_arg_type[]	
//--------------------------------------------------------------------
// Returns:  (none)
//--------------------------------------------------------------------
// Author:	PB.BaoGa		Date: 2021/06/23
//--------------------------------------------------------------------
// Usage: nvo_dwgenerator.get_arguments ( datawindow adw, ref string as_arg_name[], ref string as_arg_type[] )
//--------------------------------------------------------------------
//	Copyright (c) PB.BaoGa(TM), All rights reserved.
//--------------------------------------------------------------------
// Modify History:
//
//====================================================================

Long	ll_pos_tab, ll_pos_new_line, li_i
String	ls_arg_full_text, ls_arguments, ls_arg_name[], ls_arg_type[], ls_arg_value[]
String ls_TAB = Char(9), ls_new_line = Char(10)

ls_arg_full_text = adw.Describe("DataWindow.table.arguments")
If ls_arg_full_text = '?' Or ls_arg_full_text = '!' Then ls_arg_full_text = ''

Do While ls_arg_full_text <> ''
	li_i++
	ll_pos_tab = Pos(ls_arg_full_text, ls_TAB)
	
	ls_arg_name[li_i] = Left(ls_arg_full_text, ll_pos_tab - 1)
	ls_arg_value[li_i] = adw.Describe("Evaluate('" + ls_arg_name[li_i] + "', 0)")
	
	ll_pos_new_line = Pos(ls_arg_full_text, ls_new_line, ll_pos_tab + 1)
	If ll_pos_new_line = 0 Then ll_pos_new_line = Len(ls_arg_full_text) + 1
	ls_arg_type[li_i]  = Mid(ls_arg_full_text, ll_pos_tab + 1, ll_pos_new_line - ll_pos_tab - 1)
	
	ls_arg_full_text = Mid(ls_arg_full_text, ll_pos_new_line + 1)
	/*
	ls_arguments = 	ls_arguments + ls_new_line + Char(13) + &
		ls_arg_name[li_i] + Fill(' ', 25 - Len(ls_arg_name[li_i])) + ls_TAB + &
		ls_arg_type[li_i] + Fill(' ', 15 - Len(ls_arg_type[li_i])) + ls_TAB + &
		ls_arg_value[li_i]
		*/
Loop

as_arg_name = ls_arg_name
as_arg_type = ls_arg_type
as_arg_value = ls_arg_value

//MessageBox('Arg', ls_arguments )

//'Datawindow.Table.Arguments' = id number~r~n data_start datetime~r~n data_end datetime
//'Datawindow.Table.Procedure' = 1 execute dbo.sp_name @id = :id, @data_start = :data_start, @data_end = :data_end

end subroutine

on nvo_dwgenerator.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nvo_dwgenerator.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;trs = sqlca
end event

