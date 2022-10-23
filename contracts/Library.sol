pragma solidity >=0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Library is Ownable{

    struct Book {
        string name;
        uint32 copies;
        uint32 ownerCount;
        mapping(uint256 => address) ownersHistory;
    }

    Book myBook;
    uint32 public bookCount;

    mapping(string => bool) private isAvailable;
    mapping(uint32 => Book) public BookLedger;
    mapping(address => mapping(uint256 => bool)) private isAlreadyIssued;

 

    modifier bookNotAvailable(string memory _name) {
        require(!isAvailable[_name], "Book is available"); 
          _; 
    }

    function addBook(string memory _name, uint32 _copies)
        external
        onlyOwner
        bookNotAvailable(_name)
    {
        require(bytes(_name).length != 0, "Name cannot be empty");
        isAvailable[_name] = true;
        uint32 _bookId = bookCount+1;
        Book storage book = BookLedger[_bookId];
        book.name = _name;
        book.copies = _copies;     

       bookCount = bookCount+1;  
    }

      function addBookCopies(uint32 _bookId, uint32 _copies)
        external
        onlyOwner
    {
        require(_copies > 0, "!zero");
        Book storage book = BookLedger[_bookId];
        require(bytes(book.name).length != 0, "Book does not exist");
        book.copies = book.copies+=1;
    }

      function borrowBook(uint32 _id) external {
        require(!isAlreadyIssued[msg.sender][_id], "Book is already issued");
        isAlreadyIssued[msg.sender][_id] = true;
        Book storage book = BookLedger[_id];
        require(book.copies >= 1);
        book.copies = book.copies -1;
        book.ownersHistory[book.ownerCount] = msg.sender;  
        book.ownerCount = book.ownerCount+1;    
    }

     function returnBook(uint32 _id) external {
        require(isAlreadyIssued[msg.sender][_id], "Book is not issued");
        Book storage book = BookLedger[_id];
        book.copies = book.copies+1;
        isAlreadyIssued[msg.sender][_id] = false;
    }

     function getAllAvailableBooks() external view returns (uint32[] memory) {
        uint32 currentIndex = 0;
        for (uint32 index = 1; index <= bookCount; index++) {
            if (!isAlreadyIssued[msg.sender][index] &&
             BookLedger[index].copies > 0) {
                currentIndex++;
            }
        }
        uint32[] memory result = new uint32[](currentIndex);
        currentIndex = 0;
        for (uint32 index = 1; index <= bookCount; index++) {
            if (!isAlreadyIssued[msg.sender][index] &&
             BookLedger[index].copies > 0) {
                result[currentIndex] = index;
                currentIndex++;
            }
        }
        return result;
    }

     function getOwnerHistoryOfBook(uint32 _id)
        public
        view
        returns (address[] memory)
    {
        address[] memory result = new address[](BookLedger[_id].ownerCount);
        for (uint32 index = 0; index < result.length; index++) {
            result[index] = BookLedger[_id].ownersHistory[index];
        }
        return result;
    }
}