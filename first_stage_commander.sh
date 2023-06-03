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

while true; do
	show_menu && read -r choice && echo ""
	case $choice in
		0) echo -e "Farewell!" && break ;;
		1) uname -n -o ;;
		2) whoami ;;
		[3-4]) echo "Not implemented!" ;;
                *) echo "Invalid option!" ;;
	esac
done

