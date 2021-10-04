transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+G:/arquiProyecto2 {G:/arquiProyecto2/ram.v}
vlog -sv -work work +incdir+G:/arquiProyecto2 {G:/arquiProyecto2/superRam.sv}

