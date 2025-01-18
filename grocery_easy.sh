#!/bin/bash


# grocy_easy.sh: Implements the Beginner Mode with a menu-driven interface.
# grocy_dev.sh: Implements the Dev Mode with command-line argument parsing.
# Tasks for Beginner Mode (Easy Mode)
# Setup and Initialization

# Create grocy_easy.sh.
# Initialize an empty grocery list as an array or a file. ----
# Menu-Driven Options:

# Create a menu with the following options:
# Add an item.----
# View the list.----
# Remove an item.------
# Search for an item.------
# Calculate the total. -----
# Exit.
# Functionality for Each Option:

# Add an Item: Prompt the user for the item name and price, then save it (e.g., "item:price").
# View the List: Display all items and prices.
# Remove an Item: Allow the user to specify an item name to remove it.
# Search for an Item: Prompt the user for a search term and check if it exists.
# Calculate Total: Sum up all prices and display the total.
# Run the Menu Loop:

# Use a while loop to repeatedly show the menu until the user chooses "Exit."



data=(
    "'Wele' 15.00 -1"
    "'Food-Oil' 10.00 1"
    "'Food-Oil' 13.00 1"
    "'Food-Oil' 10.00 16"
    "'Fried-Fish' 4.00 1"
)

file_name=".grocery_db.txt"

# data=()

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
        data+=("'$item_name' $item_price $item_qty")
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
        if [ "'$target'" == "$name" ]; then
            echo "$i"
            return 0  # Return the index and stop further execution
        fi
        ((i++))
    done
    echo "-1"  # Return -1 if item not found
}

search(){
    result=$(search_help "$1")
    
    if [ "$result" -ne -1 ]; then 
        echo "${data[$result]}"
    else
        echo "Item Not Found"
    fi
}


delete(){
    target=$(search "$1")
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




# add
# create_table
# insert_into_table
# display
# total
# search "Food-Oil"
# delete "Food-Oil"



# echo "${data[@]}" 