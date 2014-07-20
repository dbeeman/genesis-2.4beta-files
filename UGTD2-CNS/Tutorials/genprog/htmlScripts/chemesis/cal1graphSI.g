//chemesis2.0
//cal1graphSI.g
float plotunits=1e3*quantUnits
create xform /graph1 [10,20,600,400]
create xgraph /graph1/ca -title "cal" -hgeom 50% -wgeom 50%
setfield ^ XUnits Sec YUnits uM xmax 10e-3 ymin 0 ymax {0.001*{plotunits}}
create xgraph /graph1/buf -title "buf" -hgeom 50% -wgeom 50%
setfield ^ XUnits Sec YUnits uM xmax  10e-3 ymin 0 ymax {CaBufInit*{plotunits}}

addmsg somaCa /graph1/ca PLOTSCALE Conc *somaca *blue {plotunits} 0
addmsg somaCabuf /graph1/buf PLOTSCALE Conc *somaCabuf *blue {plotunits} 0 
addmsg somabuf /graph1/buf PLOTSCALE Conc *somabuf *red {plotunits} 0 

xshow /graph1
useclock /graph1/# 1
