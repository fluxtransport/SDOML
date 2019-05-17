#!/bin/csh -f

#csh script for downloading AIA and HMI data described in
#A Machine-learning Data Set Prepared from the NASA Solar Dynamics Observatory Mission
#Authors:	Galvez, Richard; Fouhey, David F.; Jin, Meng; Szenicer, Alexandre; Muñoz-Jaramillo, Andrés;
# Cheung, Mark C. M.; Wright, Paul J.; Bobra, Monica G.; Liu, Yang; Mason, James; Thomas, Rajat
# https://iopscience.iop.org/article/10.3847/1538-4365/ab1005/meta

if ($#argv < 2) then
  echo "Usage: ./download_sdoml.csh 2013 05 "
  echo "to download SDO ML data from 2013 May"
  echo "This puts tarballs in subdirectory 2013."
  exit 1
endif

set pwd = $PWD
set year  = $1
set month = $2
if ($year == 2010 && $month < 5)
  echo "No SDO data available before May 2010"
  exit 2
endif

set i = 0
@ i = $1 - 2010 + 1

#set permabase = https://purl.stanford.edu
set permabase = "https://stacks.stanford.edu/file/druid:"
set links = (vk217bh4910 jc488jb7715 dc156hp0190 km388vz4371 sr325xz9271 qw012qy2533 vf806tr8954 kp222tm1554 nk828sc2920)
set years = (2010 2011 2012 2013 2014 2015 2016 2017 2018)
#Edit next line if you only want a subset of wavelengths
set channels = (AIA_0094 AIA_0131 AIA_0171 AIA_0193 AIA_0211 AIA_0304 AIA_0335 AIA_1600 AIA_1700 HMI_Bx HMI_By HMI_Bz)
set months = (01 02 03 04 05 06 07 08 09 10 11 12)
set files = ()
mkdir $year
foreach c ($channels)
  set files = ($files ${permabase}$links[$i]/${c}_${year}$months[$month].tar)
end
# Uncomment next line if EVE MEGS-A data desired.
#set files = ($files ${permabase}$links[$i]/EVE_lines_MEGS-A.tar.gz)
echo $files

# Download files
cd $pwd/$year

if (`where parallel` != "") then
  parallel wget ::: $files
else
  foreach f ($files)
  wget $f
endif

exit 0
