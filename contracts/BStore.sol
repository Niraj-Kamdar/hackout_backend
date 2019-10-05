pragma solidity >=0.5.0 <0.7.0;

contract BStore {
    uint public bookCount;
    address public user;
    struct Rate{
        string comment;
        uint rating;
        address uid;
    }
    struct Book {
        uint id;
        address publisher;
        uint price;
        string title;
        string cover;
        Rate[] reviews;
        uint avg_rating;
        uint total_reviews;
    }

    mapping(uint => Book) public books;
    mapping(address => Book[]) public ownedbooks;
    mapping(address => uint)public noOfBooks;

    constructor () public {
        bookCount = 0;
        user = msg.sender;
        noOfBooks[msg.sender] = 0;
    }
    function createBook(address _publisher, uint _price, string memory _title, string memory _cover) public{
        require(msg.sender == user);
        bookCount++;
        Book storage bk = books[bookCount];
        bk.id = bookCount;
        bk.publisher = _publisher;
        bk.price = _price;
        bk.title = _title;
        bk.cover = _cover;
        bk.avg_rating = 0;
        bk.total_reviews = 0;
    }
    function addBook(uint _id) public{
        require(msg.sender == user);
        noOfBooks[msg.sender]++;
        ownedbooks[msg.sender].push(books[_id]);
    }
    function giveReview(uint _id, string memory _comment, uint _rate) public{
        for(uint i = 0; i < noOfBooks[msg.sender]; i++){
            if(ownedbooks[msg.sender][i].id == _id){
                Rate memory temp;
                temp.comment = _comment;
                temp.rating = _rate;
                temp.uid = msg.sender;
                books[_id].reviews.push(temp);
                uint prev = books[_id].total_reviews*books[_id].avg_rating;
                books[_id].total_reviews++;
                books[_id].avg_rating = (prev + _rate)/books[_id].total_reviews;
            }
        }
    }
}