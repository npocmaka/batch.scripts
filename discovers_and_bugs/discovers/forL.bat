:: in FOR /L command every standard delimiter can be used to 
:: separate numbers:
@echo off

echo = ; , <space> <tab> can be used as number separators in for /L
echo\
for /L %%A in (1;1=5) do echo %%A

:: everyting except first three numbers will be igonred
:: 1000 will be ignored

for /L %%A in (1;1=5,1000) do echo %%A

:: every string not containing numbers in the first three items will be taken as 0

for /l %%a in (null ; 1 ; 5) do echo %%a

:: if a string starts with figits only the starting number will be taken into accoung

set BottleRum=13DeadMen

for /l %%P in (%BottleRum% 1;%BottleRum%) do  set DevilDozen=%%P

echo %DevilDozen%
echo Yo-Ho-Ho!

:: http://ss64.org/viewtopic.php?id=1667
