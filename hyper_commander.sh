#!/usr/bin/env bash

echo "Hello $USER!"

show_menu() {
    cat <<EOF

------------------------------
| Hyper Commander            |
| 0: Exit                    |
| 1: OS info                 |
| 2: User info               |
| 3: File and Dir operations |
| 4: Find Executables        |
------------------------------
EOF
}

show_dir_content() {
	while true; do	
		echo -e "The list of files and directories:"
		arr=(*)	
		for item in "${arr[@]}"; do
  			if [[ -f "$item" ]]; then
    				echo "F $item"
  			elif [[ -d "$item" ]]; then
    				echo "D $item"
  			fi
		done

		    cat <<EOF
	
---------------------------------------------------
| 0 Main menu | 'up' To parent | 'name' To select |
---------------------------------------------------
EOF
		read -r input
		case $input in
       	    		0) main ;;
    			"up") cd .. && echo "" && show_dir_content ;;
    			*)
        		found=false
        		for item in "${arr[@]}"; do
            		if [[ "$item" == "$input" ]]; then
                		found=true
                		if [[ -d "$input" ]]; then
                    			cd "$input" && echo "" && show_dir_content
                		elif [[ -f "$input" ]]; then
                    			show_file_menu "$input"
                		fi
            		fi
        		done
        		if [[ $found == false ]]; then
        			echo "Invalid input!" && continue
        		fi ;;
		esac
	done
}

show_file_menu() {
	while true; do
                    cat <<EOF
---------------------------------------------------------------------
| 0 Back | 1 Delete | 2 Rename | 3 Make writable | 4 Make read-only |
---------------------------------------------------------------------
EOF
		read -r input
		case $input in
			0) show_dir_content ;;
			2) echo "Enter the new file name:" && read -r new_name && mv "$1" "$new_name"
				echo "$1 has been renamed as $new_name" && echo ""
				show_dir_content ;;
			1) rm $1 && echo -e "$1 has been deleted.\n" && show_dir_content ;;
			3) chmod 666 "$1"; echo "Permissions have been updated." && ls -l "$1" && echo "" && show_dir_content ;;
			4) chmod 664 "$1"; echo "Permissions have been updated." && ls -l "$1" && echo "" && show_dir_content ;;
			*) show_file_menu "$1" ;;
		esac
	done
}

find_executables() {
	echo "Enter an executable name:" && read -r exe
	exe_path=$(which $exe 2>/dev/null)

	if [ -z "$exe_path" ]; then
		echo "The executable with that name does not exist!"
	else
		echo -e "\nLocated in: $exe_path"
		echo -e "\nEnter arguments:" && read -r args
		eval "$exe_path $args"
	fi
}

main() {
while true; do
	show_menu && read -r choice && echo ""
	case $choice in
		0) echo -e "Farewell!" && exit 1 ;;
		1) uname -n -o ;;
		2) whoami ;;
		3) show_dir_content ;;
		4) find_executables ;;
                *) echo "Invalid option!" ;;
	esac
done
}

main
