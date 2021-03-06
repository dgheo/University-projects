# 
# Synthesis run script generated by Vivado
# 

set_msg_config -id {Common 17-41} -limit 10000000
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7k70tfbv676-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Users/Florin/Desktop/CN2/tema2/project_2/project_2.cache/wt [current_project]
set_property parent.project_path C:/Users/Florin/Desktop/CN2/tema2/project_2/project_2.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
read_verilog -library xil_defaultlib {
  C:/Users/Florin/Desktop/CN2/tema2/project_2/project_2.srcs/sources_1/new/H2.v
  C:/Users/Florin/Desktop/CN2/tema2/project_2/project_2.srcs/sources_1/new/X74_194.v
  C:/Users/Florin/Desktop/CN2/tema2/project_2/project_2.srcs/sources_1/new/OR2.v
  C:/Users/Florin/Desktop/CN2/tema2/project_2/project_2.srcs/sources_1/new/INV.v
  C:/Users/Florin/Desktop/CN2/tema2/project_2/project_2.srcs/sources_1/new/H1.v
  C:/Users/Florin/Desktop/CN2/tema2/project_2/project_2.srcs/sources_1/new/FDRSE.v
  C:/Users/Florin/Desktop/CN2/tema2/project_2/project_2.srcs/sources_1/new/FDCE.v
  C:/Users/Florin/Desktop/CN2/tema2/project_2/project_2.srcs/sources_1/new/CB4CLE.v
  C:/Users/Florin/Desktop/CN2/tema2/project_2/project_2.srcs/sources_1/new/AND4.v
  C:/Users/Florin/Desktop/CN2/tema2/project_2/project_2.srcs/sources_1/new/AND2.v
  C:/Users/Florin/Desktop/CN2/tema2/project_2/project_2.srcs/sources_1/new/TOP.v
}
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}

synth_design -top TOP -part xc7k70tfbv676-1


write_checkpoint -force -noxdef TOP.dcp

catch { report_utilization -file TOP_utilization_synth.rpt -pb TOP_utilization_synth.pb }
