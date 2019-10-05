pragma solidity >=0.5.0 <0.7.0;

contract BStore {
    uint public bookCount;
    address public user;
    struct Book {
        uint id;
        address publisher;
        uint price;
        string title;
        bytes cover;
    }

    mapping(uint => Book) public books;
    mapping(address => Book[]) public ownedbooks;
    mapping(address => uint)public noOfBooks;

    constructor () public {
        bookCount = 0;
        user = msg.sender;
        noOfBooks[msg.sender] = 0;
    }
    function createBook(address _publisher, uint _price, string memory _title, bytes memory _cover) public{
        require(msg.sender == user);
        bookCount++;
        books[bookCount] = Book(bookCount, _publisher, _price, _title, _cover);
    }
    function addBook(uint _id) public{
        require(msg.sender == user);
        noOfBooks[msg.sender]++;
        ownedbooks[msg.sender][noOfBooks[msg.sender]] = books[_id];
    }
}