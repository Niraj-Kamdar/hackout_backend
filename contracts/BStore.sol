pragma solidity >=0.5.0 <0.7.0;

contract BStore {
    uint public bookCount;
    struct Book {
        uint id;
        address publisher;
        uint price;
        string title;
        bytes cover;
    }

    mapping(uint => Book) public books;

    constructor () public {
        bookCount = 0;
    }
    function createBook(address _publisher, uint _price, string memory _title, bytes memory _cover) public{
        bookCount++;
        books[bookCount] = Book(bookCount, _publisher, _price, _title, _cover);
    }
}