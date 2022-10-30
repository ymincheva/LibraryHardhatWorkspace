// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

contract Library is Ownable{

    struct Book {
        string name;
        uint256 copies;
        uint256 ownerCount;
        mapping(uint256 => address) ownersHistory;
    }

    Book myBook;
   
    mapping(string => bool) private isAvailable;
    mapping(uint256 => Book) public BookLedger;
    mapping(address => mapping(uint256 => bool)) private isAlreadyIssued;

    using Counters for Counters.Counter; 
    Counters.Counter currentBookId;  
    string[] public bookTitles;

    modifier bookNotAvailable(string memory _name) {
        require(!isAvailable[_name], "Book is available"); 
          _; 
    }

    function addBook(string memory _name, uint32 _copies)
        external
        onlyOwner
    {
        require(bytes(_name).length != 0, "Name cannot be empty");
        require( _copies > 0, "Copies cannot be zero");

        for (uint i; i<bookTitles.length; i++ ){

        require (keccak256(abi.encodePacked(_name))
         != keccak256(abi.encodePacked(bookTitles[i])),
         "This book title has already been added ");
        }

        uint256 _bookId = currentBookId.current();   
 
        Book storage book = BookLedger[_bookId];
        book.name = _name;
        book.copies = _copies;    

        bookTitles.push(book.name);
        currentBookId.increment();
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

     function getAllAvailableBooks() external view returns (uint256[] memory) {
        
        uint256 currentIndex = 0;
        for (uint256 index = 1; index <= currentBookId.current(); index++) {
            if (!isAlreadyIssued[msg.sender][index] &&
             BookLedger[index].copies > 0) {
                currentIndex++;
            }
        }
        uint256[] memory result = new uint256[](currentIndex);
        currentIndex = 0;
        for (uint256 index = 1; index <= currentBookId.current(); index++) {
            if (!isAlreadyIssued[msg.sender][index] &&
             BookLedger[index].copies > 0) {
                result[currentIndex] = index;
                 console.log("index",index);
                currentIndex++;
            }
        }
       
        return result;
    }

     function getOwnerHistoryOfBook(uint256 _id)
        public
        view
        returns (address[] memory)
    {
        address[] memory result = new address[](BookLedger[_id].ownerCount);
        for (uint256 index = 0; index < result.length; index++) {
            result[index] = BookLedger[_id].ownersHistory[index];
        }
        return result;
    }

    function allAvailableBooks() external view returns (string[] memory) {
    string[] memory  m_bookTitles=bookTitles;
    return m_bookTitles;    
}
}