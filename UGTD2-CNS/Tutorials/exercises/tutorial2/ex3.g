//genesis

create xform /form
xshow /form
create xgraph /form/graph
setfield /form/graph hgeom 50%
create xdialog /form/dialog 
	setfield /form/dialog value 1

addmsg /form/dialog /form/graph PLOT fvalue *dialog *red

create xbutton /form/RUN -script "step 10"
create xbutton /form/RESET -script "reset"
create xbutton /form/QUIT -script "quit"
