const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");


describe("Library", function () {

  async function deployLibrary() {
    const [owner, otherAccount] = await ethers.getSigners();

    const Library = await ethers.getContractFactory("Library");
    const library = await Library.deploy();

    return {library, owner, otherAccount};
  }

  it("Wont allow the deployer to add the same title twice", async function () {
   const { library} = await loadFixture(deployLibrary);
   await library.addBook("test", 2);
   await expect(library.addBook("test", 2)).to.be.revertedWith(
     "This book title has already been added "
   );
  });
 

   it("Only owner of the contract to add new book", async () => {
    const { library, otherAccount} = await loadFixture(deployLibrary);
    await expect(
      library.connect(otherAccount).addBook("test", 2)
    ).to.be.revertedWith("Ownable: caller is not the owner");
  }); 

  //========================================================
  // borrowBook () testing
  //========================================================

   it("Does not allow to borrow more copies than the available", async () => {
    const { library, otherAccount} = await loadFixture(deployLibrary);
    await library.addBook("test", 2);
    await library.connect(otherAccount).borrowBook(1);
    await library.connect(otherAccount).borrowBook(1);
    await expect(library.connect(otherAccount).borrowBook(1)).to.be.revertedWith(
      "No available copies left from this book."
    );
  }); 

 /*   it("Does not allow to borrow a book twice", async () => {
    const { library, otherAccount} = await loadFixture(deployLibrary);
    await library.addBook(["test", 1]);
    await library.connect(otherAccount).borrowBook(0);
    await expect(library.connect(otherAccount).borrowBook(0)).to.be.revertedWith(
      "You  have already borrowed a copy of that book"
    );
  }); */

  it("Does not allow a user to return a book twice", async function () {
    const { library, otherAccount} = await loadFixture(deployLibrary);
    await library.addBook("test", 3);
    await library.connect(otherAccount).borrowBook(0);
    await library.connect(otherAccount).returnBook(0);
    await expect(library.connect(otherAccount).returnBook(0)).to.be.revertedWith(
      "You cannot return a book twice ."
    );
  });

  it("Does not allow a user to return a book, that he has not borrowed", async function () {
    const { library, otherAccount} = await loadFixture(deployLibrary);
    await library.addBook("test", 3);
    await library.connect(otherAccount).borrowBook(0);
    await expect(library.connect(otherAccount).returnBook(1)).to.be.revertedWith(
      "You cannot return a book that you have not borrowed."
    );
  });


});