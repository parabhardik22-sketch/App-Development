// CRUD operations on an array in JavaScript

let arr = []; // empty array

// CREATE - insert elements
function create(value) {
    arr.push(value);
    console.log(`Inserted ${value}`);
}

// READ - display array
function read() {
    console.log("Array:", arr);
}

// UPDATE - change element at position
function update(index, newValue) {
    if (index >= 0 && index < arr.length) {
        console.log(`Updated ${arr[index]} to ${newValue}`);
        arr[index] = newValue;
    } else {
        console.log("Invalid index");
    }
}

// DELETE - remove element at position
function remove(index) {
    if (index >= 0 && index < arr.length) {
        console.log(`Deleted ${arr[index]}`);
        arr.splice(index, 1);
    } else {
        console.log("Invalid index");
    }
}

// Example usage
create(10);
create(20);
create(30);
read();

update(1, 25);  // update element at index 1
read();

remove(0);      // delete element at index 0
read();