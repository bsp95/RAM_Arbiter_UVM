vlib work
vlog ../tb/pkg/config_pkg.sv
vlog ../rtl/master_if.sv
vlog ../rtl/ram_if.sv
vlog ../tb/pkg/tb_pkg.sv
vlog ../rtl/rr_arbiter.sv
vlog ../rtl/ram.sv
vlog ../tb/top/tb_top.sv
vsim -coverage tb_top -voptargs=+acc
view wave
add wave -r sim:/tb_top/*
run -all
