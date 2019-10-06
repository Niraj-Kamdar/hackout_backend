import json
from web3 import Web3, HTTPProvider, IPCProvider, WebsocketProvider


def createBook(w3, greeter, account, price, title, cover):
    tx_hash = greeter.functions.createBook(
        account, price, title, cover).transact()
    tx_receipt = w3.eth.waitForTransactionReceipt(tx_hash)
    return tx_receipt


def addBook(w3, greeter, bookid, private_key):
    book = greeter.functions.books(bookid).call()
    author = book[1]
    nonce = w3.eth.getTransactionCount(w3.eth.defaultAccount)
    tx = {
        'nonce': nonce,
        'to': author,
        'value': book[2],
        'gas': 2000000,
        'gasPrice': w3.toWei('50', 'gwei'),
    }

    signed_tx = w3.eth.account.signTransaction(tx, private_key)

    tx_hash = w3.eth.sendRawTransaction(signed_tx.rawTransaction)
    # print(w3.toHex(tx_hash))
    tx_hash = greeter.functions.addBook(bookid).transact()
    tx_receipt = w3.eth.waitForTransactionReceipt(tx_hash)
    return tx_receipt


def giveReview(w3, greeter, bookid, rate):
    tx_hash = greeter.functions.giveReview(bookid, rate).transact()
    tx_receipt = w3.eth.waitForTransactionReceipt(tx_hash)
    return tx_receipt


def getAllBooks(greeter):
    books = []
    header = ('bookid', 'author', 'price', 'title',
              'cover', 'rating', 'nReviews', 'nBuys')
    n = greeter.functions.bookCount().call() + 1
    for i in range(1, n):
        book = greeter.functions.books(i).call()
        book = dict(zip(header, book))
        books.append(book)
    return books


def getUserBooks(w3, greeter):
    books = []
    header = ('bookid', 'author', 'price', 'title',
              'cover', 'rating', 'nReviews', 'nBuys')
    n = greeter.functions.noOfBooks(w3.eth.defaultAccount).call() + 1
    for i in range(1, n):
        book = greeter.functions.ownedbooks(w3.eth.defaultAccount, i)
        book = dict(zip(header, book))
        books.append(book)
    return books


def main():
    with open('./build/contracts/BStore.json', 'r') as f:
        d = json.load(f)
        bytecode = d["bytecode"]
        abi = d["abi"]

    w3 = Web3(HTTPProvider('http://localhost:8545'))
    w3.eth.defaultAccount = w3.eth.accounts[0]
    Greeter = w3.eth.contract(abi=abi, bytecode=bytecode)
    tx_hash = Greeter.constructor().transact()
    tx_receipt = w3.eth.waitForTransactionReceipt(tx_hash)
    greeter = w3.eth.contract(
        address=tx_receipt.contractAddress,
        abi=abi
    )
    return w3, greeter


if __name__ == "__main__":
    w3, greeter = main()
    createBook(w3, greeter, w3.eth.defaultAccount, 10, "Harry Potter", "wow")
    createBook(w3, greeter, w3.eth.defaultAccount,
               13, "Harry Potter 2", "wow 2")
    createBook(w3, greeter, w3.eth.defaultAccount,
               17, "Harry Potter 3", "wow 3")
    addBook(w3, greeter, 2)
    giveReview(w3, greeter, 2, "very good", 9)
    print(getAllBooks(greeter))
