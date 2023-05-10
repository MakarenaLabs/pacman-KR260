
################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2022.1
set current_vivado_version [version -short]

# change here rom paths
set rom_path "../roms"

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# PACMAN

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 pacman_kr260 -part xck26-sfvc784-2LV-c
   set_property BOARD_PART xilinx.com:kr260_som:part0:1.0 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name design_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
make_wrapper -files [get_files pacman_kr260/project_1.srcs/sources_1/bd/design_1/design_1.bd] -top
add_files -norecurse pacman_kr260/project_1.gen/sources_1/bd/design_1/hdl/design_1_wrapper.v
update_compile_order -fileset sources_1

add_files {../sources/pkg_pacman.vhd ../sources/dac.vhd ../sources/T80_Reg.vhd ../sources/pacman_audio.vhd ../sources/pacman_video.vhd ../sources/T80_RegX.vhd ../sources/T80.vhd ../sources/pacman_rams.vhd ../sources/pacman_mul4.vhd ../sources/pacman_vram_addr.vhd ../sources/T80_Pack.vhd ../sources/pacman_dblscan.vhd ../sources/pacman_program_rom.vhd ../sources/T80_MCode.vhd ../sources/pacman_debounce.vhd ../sources/T80_ALU.vhd ../sources/T80sed.vhd ../sources/pacman.vhd ../sources/pacman_clocks_xilinx.vhd}
update_compile_order -fileset sources_1
add_files ${rom_path}/pacrom_7f_dst.vhd ${rom_path}/pacrom_6j.vhd ${rom_path}/pacrom_6e.vhd ${rom_path}/pacrom_4a_dst.vhd ${rom_path}/pacrom_1m.vhd ${rom_path}/pacrom_6h.vhd ${rom_path}/pacrom_5e.vhd ${rom_path}/pacrom_5f.vhd ${rom_path}/pacrom_6f.vhd
update_compile_order -fileset sources_1
add_files -fileset constrs_1 -norecurse ../xdc/kria.xdc

set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:util_vector_logic:2.0\
xilinx.com:ip:xlconstant:1.1\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
PACMAN\
"

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set BLUE [ create_bd_port -dir O -from 3 -to 0 BLUE ]
  set CLK_IN_gem [ create_bd_port -dir I -type clk -freq_hz 25000000 CLK_IN_gem ]
  set CLOCK_PAC [ create_bd_port -dir O CLOCK_PAC ]
  set GREEN [ create_bd_port -dir O -from 3 -to 0 GREEN ]
  set HSYNC [ create_bd_port -dir O -from 0 -to 0 HSYNC ]
  set I_BUTTON_0 [ create_bd_port -dir I -from 3 -to 0 I_BUTTON_0 ]
  set I_SW_0 [ create_bd_port -dir I -from 3 -to 0 I_SW_0 ]
  set O_AUDIO [ create_bd_port -dir O O_AUDIO ]
  set RED [ create_bd_port -dir O -from 3 -to 0 RED ]
  set VSYNC [ create_bd_port -dir O -from 0 -to 0 VSYNC ]

  # Create instance: PACMAN_0, and set properties
  set block_name PACMAN
  set block_cell_name PACMAN_0
  if { [catch {set PACMAN_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $PACMAN_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKIN1_JITTER_PS {400.0} \
   CONFIG.CLKOUT1_JITTER {175.029} \
   CONFIG.CLKOUT1_PHASE_ERROR {222.305} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {200} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {48.000} \
   CONFIG.MMCM_CLKIN1_PERIOD {40.000} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {6.000} \
   CONFIG.PRIM_IN_FREQ {25} \
   CONFIG.USE_LOCKED {false} \
   CONFIG.USE_RESET {false} \
 ] $clk_wiz_0

  # Create instance: util_vector_logic_3, and set properties
  set util_vector_logic_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_3 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_3

  # Create instance: util_vector_logic_4, and set properties
  set util_vector_logic_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_4 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_4

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {1} \
 ] $xlconstant_0

  # Create port connections
  connect_bd_net -net CLK_IN_gem_1 [get_bd_ports CLK_IN_gem] [get_bd_pins clk_wiz_0/clk_in1]
  connect_bd_net -net I_BUTTON_0_1 [get_bd_ports I_BUTTON_0] [get_bd_pins PACMAN_0/I_BUTTON]
  connect_bd_net -net I_SW_0_1 [get_bd_ports I_SW_0] [get_bd_pins PACMAN_0/I_SW]
  connect_bd_net -net PACMAN_0_O_AUDIO [get_bd_ports O_AUDIO] [get_bd_pins PACMAN_0/O_AUDIO]
  connect_bd_net -net PACMAN_0_O_CLK_25 [get_bd_ports CLOCK_PAC] [get_bd_pins PACMAN_0/O_CLK_25]
  connect_bd_net -net PACMAN_0_O_HSYNC [get_bd_pins PACMAN_0/O_HSYNC] [get_bd_pins util_vector_logic_3/Op1]
  connect_bd_net -net PACMAN_0_O_VIDEO_B [get_bd_ports BLUE] [get_bd_pins PACMAN_0/O_VIDEO_B]
  connect_bd_net -net PACMAN_0_O_VIDEO_G [get_bd_ports GREEN] [get_bd_pins PACMAN_0/O_VIDEO_G]
  connect_bd_net -net PACMAN_0_O_VIDEO_R [get_bd_ports RED] [get_bd_pins PACMAN_0/O_VIDEO_R]
  connect_bd_net -net PACMAN_0_O_VSYNC [get_bd_pins PACMAN_0/O_VSYNC] [get_bd_pins util_vector_logic_4/Op1]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins PACMAN_0/I_CLK_REF] [get_bd_pins clk_wiz_0/clk_out1]
  connect_bd_net -net util_vector_logic_3_Res [get_bd_ports HSYNC] [get_bd_pins util_vector_logic_3/Res]
  connect_bd_net -net util_vector_logic_4_Res [get_bd_ports VSYNC] [get_bd_pins util_vector_logic_4/Res]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins PACMAN_0/I_RESET] [get_bd_pins xlconstant_0/dout]

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


common::send_gid_msg -ssname BD::TCL -id 2053 -severity "WARNING" "This Tcl script was generated from a block design that has not been validated. It is possible that design <$design_name> may result in errors during validation."

