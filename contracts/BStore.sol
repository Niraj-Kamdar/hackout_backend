pragma solidity >=0.5.0 <0.7.0;

contract BStore {
    uint public bookCount;
    address public user;
    uint startTime;
    // enum Genre {Action, Adventure, Comic, Crime, Fairytale, Horror, SciFi, NonFiction}

    struct Book {
        uint id;
        address publisher;
        uint price;
        string title;
        string cover;
        address[] reviews;
        uint avg_rating;
        uint total_reviews;
        uint noOfBuys;
    }

    mapping(uint => Book) public books;
    mapping(address => Book[]) public ownedbooks;
    mapping(address => uint)public noOfBooks;

    constructor () public {
        bookCount = 0;
        user = msg.sender;
        noOfBooks[msg.sender] = 0;
        startTime = now;
    }
    function createBook(address _publisher, uint _price, string memory _title, string memory _cover) public{
        require(msg.sender == user);
        bookCount++;
        // books[bookCount] = Book(bookCount, _publisher, _price, _title, _cover, _reviews, 0, 0, 0);
        Book storage bk = books[bookCount];
        bk.id = bookCount;
        bk.publisher = _publisher;
        bk.price = _price;
        bk.title = _title;
        bk.cover = _cover;
        bk.avg_rating = 0;
        bk.total_reviews = 0;
        bk.noOfBuys = 0;
    }
    function addBook(uint _id) public{
        require(msg.sender == user);
        noOfBooks[msg.sender]++;
        ownedbooks[msg.sender].push(books[_id]);
        books[_id].noOfBuys++;
    }
    function giveReview(uint _id, uint _rate) public{
        for(uint i = 0; i < noOfBooks[msg.sender]; i++){
            if(ownedbooks[msg.sender][i].id == _id){
                uint prev = books[_id].total_reviews*books[_id].avg_rating;
                books[_id].total_reviews++;
                books[_id].avg_rating = (prev + _rate)/books[_id].total_reviews;
            }
        }
    }
}