transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+G:/superEncriptador4k {G:/superEncriptador4k/superDecoder.sv}

