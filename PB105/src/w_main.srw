$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type cbx_1 from checkbox within w_main
end type
type st_2 from statictext within w_main
end type
type st_points from statictext within w_main
end type
type cb_res from commandbutton within w_main
end type
type cb_2 from commandbutton within w_main
end type
type cb_start from commandbutton within w_main
end type
type r_border from rectangle within w_main
end type
type ln_1 from line within w_main
end type
type ln_2 from line within w_main
end type
type ln_3 from line within w_main
end type
end forward

global type w_main from window
integer width = 1984
integer height = 1540
boolean titlebar = true
string title = "Build House"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
event uo_keydown pbm_keydown
cbx_1 cbx_1
st_2 st_2
st_points st_points
cb_res cb_res
cb_2 cb_2
cb_start cb_start
r_border r_border
ln_1 ln_1
ln_2 ln_2
ln_3 ln_3
end type
global w_main w_main

type prototypes
Function Long Sleep(Long ms) Library "kernel32.dll"
end prototypes

type variables
//outer border
Int ii_width = 1300,ii_height = 1300
// border coordinates
Int ii_x = 8,ii_y = 8
// drop building size
Int ii_building_width = 150,ii_building_height = 100
//limit
Int ii_right_line, ii_left_line, ii_top_line, ii_after_line

Boolean ibl_bool = True,ibl_bool_after = False
Boolean ibl_start = False

picture ip_arr_pic[],ip_arr_null[],ip_arr_pic_new[]

Dec idc_dis = 1.5

end variables
forward prototypes
public function integer wf_random (integer ai_bound)
public subroutine wf_left_right_move (integer ai_number)
public subroutine wf_after_move ()
public subroutine wf_over ()
public subroutine wf_movedown ()
public subroutine wf_thecheat ()
end prototypes

event uo_keydown;Int i
//The keycodes of the up, down, left and right keys are 38, 40, 37, 39 respectively

If ibl_start Then
	If KeyDown(38) Then
		
	End If
	
	If KeyDown(40) Then
		ibl_bool = False
		ibl_bool_after = True
		wf_after_move()
	End If
	
	If KeyDown(37) Then
		
	End If
	
	If KeyDown(39) Then
		
	End If
End If

end event

public function integer wf_random (integer ai_bound);Int li_number

li_number = Rand(ai_bound)

Return li_number


end function

public subroutine wf_left_right_move (integer ai_number);Int li_object_y, li_object_x
Int li_object_height, li_object_width
Int li_number
Long ll_cpu
picture lp_pic_new

li_number = ai_number

lp_pic_new = Create picture
lp_pic_new.Width = ii_building_width //Set properties
lp_pic_new.Height = ii_building_height
lp_pic_new.Border = True
lp_pic_new.PictureName = "Library!"// 'ApplicationIcon!'
This.OpenUserObject(lp_pic_new,'p_object', ii_width/2, ii_y + 50)

ip_arr_pic[UpperBound(ip_arr_pic) +1] = lp_pic_new

li_object_height = lp_pic_new.Height
li_object_width = lp_pic_new.Width

ibl_bool = True
ibl_start = True

//ip_arr_pic
Do While ibl_bool
	Yield()
	If Not IsValid(lp_pic_new) Then Exit
	If li_number = 1 Then // move left
		li_object_x = lp_pic_new.X - 10
		If li_object_x <= ii_left_line Then
			lp_pic_new.X = ii_left_line
			li_number = 2
		Else
			lp_pic_new.X = li_object_x
		End If
		
	Else // move to the right
		li_object_x = lp_pic_new.X + 10
		If li_object_x +li_object_width >= ii_right_line Then
			lp_pic_new.X = ii_right_line -li_object_width
			li_number = 1
		Else
			lp_pic_new.X = li_object_x
		End If
	End If
	
	ll_cpu = CPU()
	Do
		Yield()
	Loop While CPU() - ll_cpu < 10
Loop


end subroutine

public subroutine wf_after_move ();Int li_object_y,li_x1,li_x2,li_distance_new
Long ll_cpu
Int li_object_height, li_object_width
Int li_x1_norm, li_x2_norm, li_line_norm, li_distance
picture lp_pic,lp_pic_norm

//architecture
lp_pic = ip_arr_pic[UpperBound(ip_arr_pic)]
li_x1 = lp_pic.X
li_x2 = lp_pic.X + lp_pic.Width

li_object_height = lp_pic.Height
li_object_width = lp_pic.Width

// Criteria for drop position
If UpperBound(ip_arr_pic) > 1 Then
	lp_pic_norm = ip_arr_pic[UpperBound(ip_arr_pic) -1]
	li_x1_norm = lp_pic_norm.X
	li_x2_norm = lp_pic_norm.X + lp_pic_norm.Width
	li_line_norm = lp_pic_norm.Y + 4 //There is a difference of 4 pixels; blank
	li_distance = lp_pic_norm.Width / idc_dis //distance
Else
	li_line_norm = ii_after_line
	li_x1_norm = ii_x
	li_x2_norm = ii_x + ii_width
End If

//The distance between the falling building and the last building that has fallen
If li_x1_norm - li_x1 >= 0 Then
	li_distance_new = li_x1_norm - li_x1
Else
	li_distance_new = li_x2 - li_x2_norm
End If

Do While ibl_bool_after
	Yield()
	
	If li_distance_new > lp_pic_norm.Width Then
		li_line_norm = ii_after_line
	End If
	
	li_object_y = lp_pic.Y + 10
	If li_object_y + li_object_height >= li_line_norm Then
		li_object_y = li_line_norm -li_object_height
		//score; 100 points - minus interval = final score
		st_points.Text = String(Long(st_points.Text) + (100 - li_distance_new))
		ibl_bool_after = False
		// regenerate new building
		If li_distance >= li_distance_new Then
			If lp_pic.Y <= ln_1.EndY Then
				wf_movedown() //Reduce buildings
			End If
			wf_thecheat() // cheater lines
			cb_start.TriggerEvent(Clicked!)
		Else
			MessageBox("Tips", "Game Over")
			cb_res.TriggerEvent(Clicked!)
		End If
	Else
		lp_pic.Y = li_object_y
	End If
	
	ll_cpu = CPU()
	Do
		Yield()
	Loop While CPU() - ll_cpu < 10
Loop


end subroutine

public subroutine wf_over ();//wf_over p_plate
Int li_i
Long ll_cpu
picture lp_pic
For li_i = UpperBound(ip_arr_pic) To 1 Step - 1
	CloseUserObject(ip_arr_pic[li_i])
Next



end subroutine

public subroutine wf_movedown ();//wf_over p_plate
Int li_i
Long ll_cpu
picture lp_pic
ip_arr_pic_new = ip_arr_null
For li_i = UpperBound(ip_arr_pic) To 1 Step - 1
	If li_i > 3 Then
		CloseUserObject(ip_arr_pic[li_i])
	Else
		ip_arr_pic_new[li_i] = ip_arr_pic[li_i]
	End If
Next
ip_arr_pic = ip_arr_pic_new






end subroutine

public subroutine wf_thecheat ();//wf_thecheat
picture lp_pic
Int li_x1,li_x2

lp_pic = ip_arr_pic[UpperBound(ip_arr_pic)]
li_x1 = lp_pic.X
li_x2 = lp_pic.X + lp_pic.Width

ln_2.BeginX = li_x1
ln_2.EndX = li_x1

ln_3.BeginX = li_x2
ln_3.EndX = li_x2



end subroutine

on w_main.create
this.cbx_1=create cbx_1
this.st_2=create st_2
this.st_points=create st_points
this.cb_res=create cb_res
this.cb_2=create cb_2
this.cb_start=create cb_start
this.r_border=create r_border
this.ln_1=create ln_1
this.ln_2=create ln_2
this.ln_3=create ln_3
this.Control[]={this.cbx_1,&
this.st_2,&
this.st_points,&
this.cb_res,&
this.cb_2,&
this.cb_start,&
this.r_border,&
this.ln_1,&
this.ln_2,&
this.ln_3}
end on

on w_main.destroy
destroy(this.cbx_1)
destroy(this.st_2)
destroy(this.st_points)
destroy(this.cb_res)
destroy(this.cb_2)
destroy(this.cb_start)
destroy(this.r_border)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.ln_3)
end on

event open;Randomize(0)
cb_res.TriggerEvent(Clicked!)

end event

type cbx_1 from checkbox within w_main
integer x = 1403
integer y = 856
integer width = 457
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "cheat lines"
end type

event clicked;if cbx_1.checked then
	ln_2.visible=true
	ln_3.visible=true
else
	ln_2.visible=false
	ln_3.visible=false	
end if

end event

type st_2 from statictext within w_main
integer x = 1353
integer y = 708
integer width = 206
integer height = 68
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "Score:"
boolean focusrectangle = false
end type

type st_points from statictext within w_main
integer x = 1582
integer y = 708
integer width = 242
integer height = 68
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
boolean focusrectangle = false
end type

type cb_res from commandbutton within w_main
integer x = 1394
integer y = 232
integer width = 457
integer height = 128
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Refresh"
end type

event clicked;ibl_bool = False
ibl_start = False

r_border.Width = ii_width
r_border.Height = ii_height

r_border.X = ii_x
r_border.Y = ii_y

ln_1.BeginY = ii_height / 3
ln_1.EndY = ii_height / 3
ln_1.BeginX = ii_x
ln_1.EndX = ii_width

ln_2.BeginY = ii_y
ln_2.EndY = ii_height


ln_3.BeginY = ii_y
ln_3.EndY = ii_height


//Boundary line up, down, left and right
ii_top_line = ii_y
ii_after_line = ii_y+ii_height
ii_left_line = ii_x
ii_right_line = ii_x+ii_width

st_points.Text = '0'

wf_over()
ip_arr_pic = ip_arr_null

picture lp_pic_new
lp_pic_new = Create picture
lp_pic_new.Width = ii_building_width //set properties
lp_pic_new.Height = ii_building_height
lp_pic_new.Border = True
lp_pic_new.PictureName = "Library!"//'ApplicationIcon!'
Parent.OpenUserObject(lp_pic_new,'p_object', (ii_width / 2) - (lp_pic_new.Width / 2),ii_height + ii_y  - lp_pic_new.Height)
ip_arr_pic[1] = lp_pic_new

wf_thecheat()



end event

type cb_2 from commandbutton within w_main
integer x = 1394
integer y = 448
integer width = 457
integer height = 128
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Finish"
end type

event clicked;ibl_bool = False
ibl_start = False
wf_over()
cb_res.TriggerEvent(Clicked!)

end event

type cb_start from commandbutton within w_main
integer x = 1394
integer y = 16
integer width = 457
integer height = 128
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Start(&a)"
end type

event clicked;Int li_number


li_number = Rand(2)
wf_left_right_move(li_number)


end event

type r_border from rectangle within w_main
long linecolor = 33554432
integer linethickness = 4
long fillcolor = 1073741824
integer width = 1298
integer height = 1300
end type

type ln_1 from line within w_main
long linecolor = 33554432
linestyle linestyle = dot!
integer linethickness = 4
integer beginx = 5
integer beginy = 324
integer endx = 1298
integer endy = 324
end type

type ln_2 from line within w_main
boolean visible = false
long linecolor = 33554432
linestyle linestyle = dash!
integer linethickness = 4
integer beginx = 1545
integer beginy = 860
integer endx = 1545
integer endy = 1360
end type

type ln_3 from line within w_main
boolean visible = false
long linecolor = 33554432
linestyle linestyle = dash!
integer linethickness = 4
integer beginx = 1664
integer beginy = 860
integer endx = 1664
integer endy = 1360
end type

