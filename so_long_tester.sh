INVALID_MAPS=$(find map/invalid -name "*.ber")
VALID_MAPS=$(find map/valid -name "*.ber")
GREEN='\033[0;32m'
RED='\033[0;31m'

make re > /dev/null 2>&1

echo -e "\n                            MAP TESTER               \n"
echo -e "Valgrind Test (1)\nInvalid Map Test (2)\nValgrind Valid Map Test (3)\nValid Map Test (4)\nQuit (5)"
read input
if [ $input == '1' ]
then
	for i in $INVALID_MAPS; do
    	echo -e '\n'
		map_basename="${i##*/}"
    	valgrind ./so_long $i &> Valgrind_Result.txt
		RESULT=$(cat Valgrind_Result.txt | grep "All heap blocks" | cut -b 11-61)
		if [ "$RESULT" == "All heap blocks were freed -- no leaks are possible" ]
		then
			printf "${GREEN}Map: $map_basename"
		else
			printf "${RED}Map: $map_basename"
		fi
	done
	rm Valgrind_Result.txt
	make fclean > /dev/null
elif [ $input == '2' ]
then
	for i in $INVALID_MAPS; do
    	echo -e '\n'
		map_basename="${i##*/}"
    	./so_long $i &> Map_Error_Message.txt
		printf "Map: $map_basename\n"
		cat Map_Error_Message.txt
	done
	rm Map_Error_Message.txt
	make fclean > /dev/null
elif [ $input == '3' ]
then
	for i in $VALID_MAPS; do
    	echo -e '\n'
		map_basename="${i##*/}"
    	valgrind ./so_long $i &> Valgrind_Result.txt
		RESULT=$(cat Valgrind_Result.txt | grep "All heap blocks" | cut -b 11-61)
		if [ "$RESULT" == "All heap blocks were freed -- no leaks are possible" ]
		then
			printf "${GREEN}Map: $map_basename"
		else
			printf "${RED}Map: $map_basename"
		fi
	done
	rm Valgrind_Result.txt
	make fclean > /dev/null
elif [ $input == '4' ]
then
	for i in $VALID_MAPS; do
    	echo -e '\n'
		map_basename="${i##*/}"
    	./so_long $i
	done
	make fclean > /dev/null
else
	make fclean > /dev/null
	exit 130
fi
