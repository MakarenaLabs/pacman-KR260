@echo off
rem the standard MAME ROM file names are used

set rom_path=..\pacman_roms\

romgen %rom_path%82s126.1m PACROM_1M 9 l r e > %rom_path%pacrom_1m.vhd
romgen %rom_path%82s126.3m PACROM_1M 9 l r e > %rom_path%pacrom_1m.vhd
romgen %rom_path%82s126.4a PACROM_4A_DST 8 c > %rom_path%pacrom_4a_dst.vhd
romgen %rom_path%pacman.5e PACROM_5E 12 c r e > %rom_path%pacrom_5e.vhd
romgen %rom_path%pacman.5f PACROM_5F 12 c r e > %rom_path%pacrom_5f.vhd
romgen %rom_path%pacman.6e PACROM_6E 12 c r e > %rom_path%pacrom_6e.vhd
romgen %rom_path%pacman.6f PACROM_6F 12 c r e > %rom_path%pacrom_6f.vhd
romgen %rom_path%pacman.6h PACROM_6H 12 c r e > %rom_path%pacrom_6h.vhd
romgen %rom_path%pacman.6j PACROM_6J 12 c r e > %rom_path%pacrom_6j.vhd
romgen %rom_path%82s123.7f PACROM_7F_DST 4 c > %rom_path%pacrom_7f_dst.vhd

echo done
