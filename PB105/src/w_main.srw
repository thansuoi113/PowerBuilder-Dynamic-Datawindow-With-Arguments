$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type cb_1 from commandbutton within w_main
end type
type cb_4 from commandbutton within w_main
end type
type dw_emp from datawindow within w_main
end type
type cb_2 from commandbutton within w_main
end type
end forward

global type w_main from window
integer width = 1801
integer height = 1420
boolean titlebar = true
string title = "Dynamic Datawindow Arguments"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_1 cb_1
cb_4 cb_4
dw_emp dw_emp
cb_2 cb_2
end type
global w_main w_main

on w_main.create
this.cb_1=create cb_1
this.cb_4=create cb_4
this.dw_emp=create dw_emp
this.cb_2=create cb_2
this.Control[]={this.cb_1,&
this.cb_4,&
this.dw_emp,&
this.cb_2}
end on

on w_main.destroy
destroy(this.cb_1)
destroy(this.cb_4)
destroy(this.dw_emp)
destroy(this.cb_2)
end on

type cb_1 from commandbutton within w_main
integer x = 585
integer y = 32
integer width = 443
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Get Arguments"
end type

event clicked;String ls_arg_name[], ls_arg_type[], ls_arg_value[]
nvo_dwgenerator ldwgen

ldwgen = Create nvo_dwgenerator
ldwgen.get_arguments(dw_emp, ls_arg_name, ls_arg_type, ls_arg_value)


end event

type cb_4 from commandbutton within w_main
integer x = 1061
integer y = 32
integer width = 667
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Create From Procedure"
end type

event clicked;/*
create or replace procedure pro_get_emp_list(p_job in varchar2,
                                             p_sal in number,
                                             emp_list out sys_refcursor) is
begin
  open emp_list for
    select empno, ename, job, mgr, hiredate, sal 
      from scott.emp 
     where job = p_job 
       and sal > p_sal;
end pro_get_emp_list;
*/
/*
nvo_dwgenerator dsgen
dsgen = Create nvo_dwgenerator

dsgen.set_procedure('execute pro_get_emp_list; p_job=:p_job ,p_sal=:p_sal')
dsgen.set_argument( 1, 'p_job', dsgen.STRING_TYPE)
dsgen.set_argument( 2, 'p_sal', dsgen.NUMBER_TYPE)
dsgen.create_datawindow( dw_emp)

dw_emp.SetTransObject(SQLCA)
dw_emp.Retrieve('CLERK', 1000)

Return 0
*/

/*
create procedure
DBA.sp_customer_products(inout customer_id integer)
result(id integer,quantity_ordered integer)
begin select product.id,sum(sales_order_items.quantity) from product,sales_order_items,sales_order
where sales_order.cust_id = customer_id and sales_order.id = sales_order_items.id
and sales_order_items.prod_id = product.id group by product.id end
*/

nvo_dwgenerator dsgen
dsgen = Create nvo_dwgenerator

dsgen.set_procedure("execute sp_customer_products; customer_id=:customer_id")
dsgen.set_argument( 1, 'customer_id', dsgen.number_type )
dsgen.create_datawindow( dw_emp)

dw_emp.SetTransObject(SQLCA)
dw_emp.Retrieve(103)

Return 0



end event

type dw_emp from datawindow within w_main
integer x = 37
integer y = 160
integer width = 1682
integer height = 1088
integer taborder = 40
string title = "none"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_2 from commandbutton within w_main
integer x = 37
integer y = 32
integer width = 485
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Create From Sql"
end type

event clicked;nvo_dwgenerator dsgen
dsgen = Create nvo_dwgenerator

dsgen.set_sql("select dept_id, dept_name, dept_head_id from department where dept_id = :as_dept_id")
dsgen.set_argument( 1, 'as_dept_id', dsgen.number_type )
dsgen.create_datawindow( dw_emp)

dw_emp.SetTransObject(SQLCA)
dw_emp.Retrieve(100)

Return 0


end event

