pragma solidity >=0.5.0 <0.7.0;

contract BStore {
    uint public bookCount;
    struct Book {
        uint id;
        // address publisher;
        // uint price;
        // string title;
        // bytes cover;
    }

    mapping(uint => Book) public books;

    constructor () public {
        createBook();
    }
    // address _publisher, uint _price, string memory _title, bytes memory _cover
    // , _publisher, _price, _title, _cover
    function createBook() public{
        bookCount++;
        books[bookCount] = Book(bookCount);
    }
}