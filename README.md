# Grocery-CLI

A command-line tool for managing your grocery list, featuring an interactive Beginner Mode and a somewhat powerful Dev Mode for advanced users.

Here's a simplified setup guide tailored for a shell script:

---

## Setup Instructions

To get started with the **Grocery-CLI**, follow these simple steps:

### 1. **Download the Script**

- Clone the repository.

  ```
  git clone https://github.com/Programming-Sai/Grocery-CLI.git
  ```

- Navigate into it.

  ```bash
    cd Grocery-CLI
  ```

### 2. **Make the Script Executable**

Before running the script, you need to give it executable permissions.

In your terminal, navigate to the directory where the `grocery_easy.sh` file is located, then run:

```
chmod +x grocery_easy.sh
```

### 3. **Run the Script**

Once the script is executable, you can run it directly in your terminal:

```
./grocery_easy.sh
```

The script will start, and you will be guided through the available commands.

---

## Easy Section (Beginner Mode)

![Welcome Screen](./img/welcome.png)

The **Easy Section** is designed for users who prefer a simple and intuitive interface to manage their grocery list. It guides you step-by-step through the process of adding, displaying, searching, and deleting items from your list, all without needing any prior technical knowledge. Here's how it works:

> [!NOTE]
> Make sure to select an Option from the welcome screen in order to use the functions.

### Available funcitons

- **add**: Adds a new item to your grocery list. You will be prompted to enter the name, price, and quantity of the item.
  - Example: `add`
- **display**: Shows all items in your grocery list in a formatted table.
  - Example: `display`
- **search**: Search for an item by its name. You will be asked to enter a search term, and the tool will display matching items.
  - Example: `search <item_name>`
- **delete**: Deletes an item from the list. After searching for an item, you'll be asked to confirm deletion.

  - Example: `delete <item_name>`

- **total**: Displays the total cost of all items in your grocery list.

  - Example: `total`

- **clear**: Clears all items from the grocery list after confirming the action.
  - Example: `clear`

### Example Usage

1. **Adding an Item**

   ```
   add

   Please enter the name of the Item: Apples
   Please enter the price of the Item: 1.99
   Please enter the quantity of the Item: 2
   Are these what you want to add to the grocery list? (y/n) y
   Item Added Successfully
   ```

2. **Displaying Items**

   ```
   display

   Item Name      Item Quantity    Item Price
   --------------------------------------------
   Apples         2                1.99
   ```

3. **Searching for an Item**

   ```
   search Apples

   Item Name      Item Quantity    Item Price
   --------------------------------------------
   Apples         2                1.99
   ```

4. **Deleting an Item**

   ```
   delete Apples

   Are you sure you want to remove this item from the grocery list? (y/n) y
   Item successfully deleted.
   ```

5. **Getting the Total**

   ```
   total

   Total: 1.99
   ```

6. **Clearing the List**

   ```
   clear

   Are you sure you want to clear the storage? (y/n) y
   Storage Cleared
   ```

This section makes it easy for beginners to quickly start managing their grocery lists without getting into the complexities of the more advanced features.
