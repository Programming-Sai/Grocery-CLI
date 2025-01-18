delete(){
    target=$(search "$1")
    if [ "$target" == "Item Not Found" ]; then
        echo "Item to be Deleted Is not in the List"
        return 0

    new_data=()
    for item in "${data[@]}"
    do
        if [ "$target" != "$item"]; then
            new_data+={"$item"}
        fi
    done
    
    read -p "Are these what you want to remove this item from the grocery list? (y/n) " confirmation
    confirmation_lower=$(echo "${confirmation}" | tr '[:upper:]' '[:lower:]')

    if [ "$confirmation_lower" == 'y' ]; then
        data=("$new_data[@]")
        insert_into_table
    else
        echo "Item not deleted."
    fi  
}