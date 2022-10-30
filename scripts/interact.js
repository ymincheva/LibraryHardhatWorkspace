const { ethers } = require("hardhat");
const hre = require("hardhat");
const Library = require("../artifacts/contracts/Library.sol/Library.json");

const provider = new ethers.providers.AlchemyProvider(
  "goerli",
  process.env.GOERLI_KEY
); 

 const wallet = new hre.ethers.Wallet("af8e171fceeee3d5e1e5d9076a973e36e874db89c8666d601ac2b48bd4650fcd", provider);
 //const wallet = new hre.ethers.Wallet(process.env.PRIVATE_KEY, provider);

 const libraryAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3";
 const abi = Library.abi;
 const library = new hre.ethers.Contract(libraryAddress, abi, wallet);

  
/*  const run = async function() {
    const provider = new hre.ethers.providers.JsonRpcProvider("https://eth-goerli.alchemyapi.io/v2/g_pw19NjfqwAY_R-r4l3-smaQFMNYi4I")
    const wallet = new hre.ethers.Wallet("af8e171fceeee3d5e1e5d9076a973e36e874db89c8666d601ac2b48bd4650fcd", provider);
    const balance = await wallet.getBalance();
    console.log(hre.ethers.utils.formatEther(balance, 18))
    }
 run() */

 async function interaction() { 

  console.log("Creates a book ...................");

  let addBook = await library.addBook("test_", 2);
  (await addBook.wait())
    ? console.log(`Successfully added the book`)
    : console.log("Transaction for adding a book was not successful");  


    console.log("Checks all available books ...................");
    let availableBookTitles = await library.allAvailableBooks();
    console.log("all available book titles",availableBookTitles);

    console.log("Rents a book ....................");   
    const rentsBook = await library.borrowBook(1);
    const rentsBookStatus = await rentsBook.wait();
    if (rentsBookStatus.status != 1) {
         console.log("Rents a book transaction was not successful")
         return 
    }

    console.log("Checks that it is rented ....................");  

    console.log("Returns the book ....................");
    const returnBook = await library.returnBook(1);
    const returnBookStatus = await returnBook.wait();
    if (returnBookStatus.status != 1) {
         console.log("Returns the book transaction was not successful")
         return 
    }

    console.log("Checks the availability of the book ....................");
    let allBookTitles = await library.allAvailableBooks();
    console.log("all book titles", allBookTitles);

}

interaction();