# 
# Synthesis run script generated by Vivado
# 

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a100tcsg324-3

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Users/Florin/Desktop/CN2/tema3/project_1/project_1.cache/wt [current_project]
set_property parent.project_path C:/Users/Florin/Desktop/CN2/tema3/project_1/project_1.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
read_verilog -library xil_defaultlib C:/Users/Florin/Desktop/CN2/tema3/project_1/project_1.srcs/sources_1/new/max16b.v
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}

synth_design -top max16b -part xc7a100tcsg324-3


write_checkpoint -force -noxdef max16b.dcp

catch { report_utilization -file max16b_utilization_synth.rpt -pb max16b_utilization_synth.pb }
