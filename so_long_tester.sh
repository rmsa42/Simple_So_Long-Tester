INVALID_MAPS=$(find map/invalid -name "*.ber")
VALID_MAPS=$(find map/valid -name "*.ber")
GREEN='\033[0;32m'
RED='\033[0;31m'

make > /dev/null
clear

echo -e "\n                                        MAP TESTER               \n"
echo -e "Test Invalid Maps with Valgrind (Press 1)\nRun Valid Maps with Valgrind (Press 2)\nQuit (Press 3)"
read input
if [ -z "$input" ]
then
	exit 130
fi
printf "\n"
if [ $input == '1' ]
then
	echo -e "Test Invalid Maps with Valgrind:\n"
	for i in $INVALID_MAPS; do
		map_basename="${i##*/}"
    	valgrind ./so_long $i &> Valgrind_Result.txt
		PRID=$(expr ${#BASHPID} + 6)
		RESULT=$(cat Valgrind_Result.txt | grep "All heap blocks" | cut -b $PRID-61)
		ERROR_RESULT=$(cat Valgrind_Result.txt | grep "Error")
		if [ "$RESULT" == "All heap blocks were freed -- no leaks are possible" ] && [ "$ERROR_RESULT" == "Error" ]
		then
			printf "${GREEN}[OK] Map: $map_basename\n"
		else
			printf "${RED}[KO] Map: $map_basename\n"
		fi
	done
	rm Valgrind_Result.txt
elif [ $input == '2' ]
then
	echo -e "Run Valid Maps with Valgrind:\n"
	for i in $VALID_MAPS; do
		map_basename="${i##*/}"
    	valgrind ./so_long $i &> Valgrind_Result.txt
		PRID=$(expr ${#BASHPID} + 6)
		RESULT=$(cat Valgrind_Result.txt | grep "All heap blocks" | cut -b $PRID-61)
		if [ "$RESULT" == "All heap blocks were freed -- no leaks are possible" ]
		then
			printf "${GREEN}[OK] Map: $map_basename\n"
		else
			printf "${RED}[KO] Map: $map_basename\n"
		fi
	done
	rm Valgrind_Result.txt
else
	exit 130
fi