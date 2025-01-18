#!/bin/bash

file_name=".grocery_db.txt"

data=()




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
    echo -e "\n\nPlease enter the name of the Item: "
    read item_name
    item_name="${item_name// /-}"

    while true; do
        echo -e "\n\nPlease enter the price of the Item: "
        read item_price
        if [[ "$item_price" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
            break
        else
            echo -e "\nInvalid Price $item_price. Enter a Valid price."
        fi 
    done
    
    while true; do
        echo -e "\n\nPlease enter the quantity of the Item: "
        read item_qty
        item_qty=${item_qty:-"-1"}
        if [[ "$item_qty" =~ ^-?[0-9]+$ ]]; then
            break
        else 
            echo -e "\nInvalid quantity $item_qty. Please Enter a valid Quantity."
        fi
    done



    echo -e "\n\nName: ${item_name},\nPrice: ${item_price},\nQty: ${item_qty}\n" 

    read -p "Are these what you want to add to the grocery list? (y/n) " confirmation
    confirmation_lower=$(echo "${confirmation}" | tr '[:upper:]' '[:lower:]')

    if [ "$confirmation_lower" == 'y' ]; then
        data+=("$item_name $item_price $item_qty")
        create_table
        insert_into_table
        echo "Item Added Successfully"
    else
        echo "Item not added."
    fi

}

display(){
    echo
    cat $file_name
    echo
}

total(){
    total=0
    for item in "${data[@]}"
    do
        read -r _ price _ <<< "$item"
        total=$(echo "$total + $price" | bc) 
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



home(){

    GREEN='\033[32m'
    YELLOW='\033[33m'
    BLUE='\033[34m'
    CYAN='\033[36m'
    MAGENTA='\033[35m'
    WHITE='\033[37m'
    RESET='\033[0m'

    # Display the menu
    echo -e "${MAGENTA}"
    echo -e "###########################################################"
    echo -e "#                                                         #"
    echo -e "#       ${YELLOW}GrocyPro: Your Grocery List Assistant${MAGENTA}             #"
    echo -e "#                                                         #"
    echo -e "###########################################################${RESET}"

    echo -e "${CYAN}✨ What would you like to do today?${RESET}"
    echo -e "${BLUE}-----------------------------------------------------------${RESET}"
    echo -e "${GREEN}[1] ${WHITE}Add an item to the grocery list"
    echo -e "${GREEN}[2] ${WHITE}View the grocery list"
    echo -e "${GREEN}[3] ${WHITE}Remove an item from the grocery list"
    echo -e "${GREEN}[4] ${WHITE}Search for an item in the grocery list"
    echo -e "${GREEN}[5] ${WHITE}Calculate the total price of items"
    echo -e "${GREEN}[6] ${WHITE}Clear Grocery List"
    echo -e "${GREEN}[7] ${WHITE}Exit the application${RESET}"
    echo -e "${BLUE}-----------------------------------------------------------${RESET}"
    echo -e "${YELLOW}🛒 GrocyPro: Simplifying your shopping experience!${RESET}"
    echo -e "${MAGENTA}###########################################################${RESET}\n"
}

get_choice(){
    while true; do
        read -p "Enter your choice (1-7): " choice
        if [[ "$choice" =~ ^-?[0-9]+$ ]] && ((choice >= 1 && choice <=7)); then
            echo "$choice"  
            return
        else 
            echo -e "\nInvalid Choice $choice. Please Enter a valid Choice."
        fi
    done
}

load_data() {
    data=()
    while IFS= read -r line; do
        [[ "$line" == *"Item Name"* || "$line" == *"----"* ]] && continue
        data+=("$line")
    done < "$file_name"
}

main_loop() {
    if [[ -f $file_name ]]; then
        load_data
    else
        create_table
        insert_into_table
    fi
    while true; do
        home
        choice=$(get_choice)
        case $choice in
            1)
                echo -e "\033c"
                echo -e "\n\033[1mAdding Item\033[0m\n"
                add ;;
            2)
                echo -e "\033c"
                echo -e "\n\033[1mView List\033[0m\n"
                display
                for i in $(seq 1 30); do
                    echo
                done ;;
            3)
                echo -e "\033c"
                echo -e "\n\033[1mDeleting Item\033[0m\n"
                read -p "What would you like to delete? " target
                delete $target;;
            4)
                echo -e "\033c"
                echo -e "\n\033[1mSearching List\033[0m\n"
                read -p "What would you like to search for? " target
                search $target 1
                for i in $(seq 1 30); do
                    echo
                done ;;
            5)
                echo -e "\033c"
                echo -e "\n\033[1mCalculating Total\033[0m\n"
                total ;;
            6)
                echo -e "\033c"
                echo -e "\n\033[1mClear List\033[0m\n"
                clear ;;
            7)
                echo "Exiting..."  
                break ;;
            *)
                echo "BYE"
                ;;
        esac
    done
}

main_loop


# TODO Add Logic to handle Double Entries
# TODO Handle Multiple search REsults for both outputs and Deletions
# TODO Make Display function versatile so that it takes in an array and shows the array, so that it would be able to show items in a search reasult.