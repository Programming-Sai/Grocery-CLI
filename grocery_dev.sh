#!/bin/bash

file_name=".grocery_db.txt"





create_table(){
    echo -e "\t\tItem Name\tItem Quantity\tItem Price\n\t\t--------------------------------------------" > $file_name
}

insert_into_table(){
    for item in "${data[@]}"
    do
        read -r name price qty <<< "$item"
        printf  "\t\t%-18s %-12s %-10s\n" "$name" "$qty" "$price" >> $file_name

    done
}

add(){
    item_name=$1 
    item_name="${item_name// /-}"
    item_price=$2
    item_qty=${3:-"N/A"}

    if [[ ! "$item_price" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        echo -e "\nInvalid Price: $item_price. Enter a valid price."
        return 1 
    fi 

    if [[ ! "$item_qty" =~ ^[0-9]+$ && "$item_qty" != "N/A" ]]; then
        echo -e "\nInvalid Quantity: $item_qty. Please enter a valid quantity."
        return 1  
    fi

    data+=("$item_name $item_price $item_qty")
    create_table
    insert_into_table
    echo "Items Added Successfully"
}

display(){
    echo
    cat $file_name
    echo
}

total(){
    total=0
    for item in "${data[@]}"; do
        item_price=$(echo "$item" | awk '{print $3}')
        if [[ "$item_price" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; then
            total=$(echo "$total + $item_price" | bc)
        fi
    done
    echo $total
}



search_help(){
    target=$1
    i=0
    for item in "${data[@]}"
    do
        read -r name _ _ <<< "$item"
        if [[ "$name" == *"$target"* ]]; then
            echo "$i"
            return 0  
        fi
        ((i++))
    done
    echo "-1"  
}

search(){
    result=$(search_help "$1")
    mode=${2:-0}
    if [ "$result" -ne -1 ]; then 
        if [ "$mode" -ne 1 ]; then
            show_search_result "${data[result]}"
        else
            echo "${data[$result]}"
        fi
    else
        echo "Item Not Found"
    fi
}

show_search_result(){
    result=$1
    echo -e "\n\n\t\tItem Name\tItem Quantity\tItem Price\n\t\t--------------------------------------------" 
    read -r name price qty <<< "$result"
    printf  "\t\t%-18s %-12s %-10s\n" "$name" "$qty" "$price" 
}


delete(){
    target=$(search "$1" 1)
    echo "$1"
    if [ "$target" == "Item Not Found" ]; then
        echo "Item to be Deleted is not in the List"
        return 0
    fi

    new_data=()
    for item in "${data[@]}"
    do
        if [ "$target" != "$item" ]; then
            new_data+=("$item")  
        fi
    done
    
    read -p "Are these what you want to remove this item from the grocery list? (y/n) " confirmation
    confirmation_lower=$(echo "${confirmation}" | tr '[:upper:]' '[:lower:]')

    if [ "$confirmation_lower" == 'y' ]; then
        data=("${new_data[@]}")  
        create_table
        insert_into_table
        echo "Item successfully deleted."
    else
        echo "Item not deleted."
    fi  
}

clear(){
    read -p "Are you sure that you want to clear the storage? (y/n) " confirmation
    confirmation_lower=$(echo "${confirmation}" | tr '[:upper:]' '[:lower:]')

    if [ "$confirmation_lower" == 'y' ]; then
        echo > $file_name
        echo "Storage Cleared"
    else
        echo "Storage Intact."
    fi  
}

load_data() {
    data=()
    while IFS= read -r line; do
        [[ "$line" == *"Item Name"* || "$line" == *"----"* ]] && continue
        data+=("$line")
    done < "$file_name"
}

print_help() {
    # Check if color should be enabled
    local enable_color=$1
    local normal="\033[0m"
    local green="\033[32m"
    local blue="\033[34m"
    local yellow="\033[33m"
    local red="\033[31m"

    echo

    # Conditionally apply color
    if [ "$enable_color" == "true" ]; then
        echo -e "${green}Usage: $0 <command> [options]${normal}\n"
        echo -e "${yellow}Available commands:${normal}"
        echo -e "\n  ${blue}add <item_name> <item_price> <item_quantity}${normal}\n    Add a new item to the grocery list."
        echo -e "\n  ${blue}display${normal}\n    Display all items in the grocery list."
        echo -e "\n  ${blue}search <item_name>${normal}\n    Search for an item by name."
        echo -e "\n  ${blue}delete <item_name>${normal}\n    Delete an item from the grocery list."
        echo -e "\n  ${blue}total${normal}\n    Display the total cost of all items."
        echo -e "\n  ${blue}clear${normal}\n    Clear all items from the grocery list."
        echo -e "\n  ${red}-h | --help${normal}\n    Show this help message and exit."
    else
        echo -e "Usage: $0 <command> [options]\n"
        echo "Available commands:"
        echo -e "\n  add <item_name> <item_price> <item_quantity>\n    Add a new item to the grocery list."
        echo -e "\n  display\n    Display all items in the grocery list."
        echo -e "\n  search <item_name>\n    Search for an item by name."
        echo -e "\n  delete <item_name>\n    Delete an item from the grocery list."
        echo -e "\n  total\n    Display the total cost of all items."
        echo -e "\n  clear\n    Clear all items from the grocery list."
        echo -e "\n  -h | --help\n    Show this help message and exit."
    fi
    echo
}




main() {
    if [ $# -lt 1 ]; then
        print_help true
        exit 1
    fi
    load_data

    case $1 in 
        add)
            if [ $# -lt 4 ]; then  
                item_qty=-1 
            else
                item_qty="$4"  
            fi

            if [ $# -lt 3 ]; then
                echo "Usage: $0 add <item_name> <item_price> [item_quantity]"
                exit 1
            fi

            add "$2" "$3" "$item_qty"
            ;;
        
        display)
            display
            ;;
        
        clear)
            clear
            ;;

        total)
            total
            echo
            ;;
            
        delete)
            if [ $# -ne 2 ]; then  
                echo "Usage: $0 delete <target>"
                exit 1
            fi
            delete "$2" 
            ;;
        
        search)
            if [ $# -ne 2 ]; then  
                echo "Usage: $0 search <target>"
                exit 1
            fi
            search "$2" 
            echo
            ;;
        -h|--help)
            print_help false
            ;;
        *)
            echo "Invalid command"
            exit 1
            ;;
    esac
}


main "$@"
