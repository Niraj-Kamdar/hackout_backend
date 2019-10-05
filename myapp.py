from flask import Flask, jsonify
from book import *
app = Flask(__name__)


@app.route('/getbooks')
def bookgetter():
    global greeter
    books = getAllBooks(greeter)
    return jsonify(books)


@app.route('/getbooksby/<user>')
def bookgetterbyuser(user):
    global greeter
    books = getUserBooks(greeter, int(user))
    return jsonify(books)


@app.route('/createbook/<price>/<title>/<cover>')
def create_book(price, title, cover):
    global greeter
    global w3
    createBook(w3, greeter, w3.eth.defaultAccount, int(price), title, cover)
    return "ok!"


@app.route('/addbook/<bid>')
def add_book(bid):
    global greeter
    global w3
    addBook(w3, greeter, int(bid))
    return "ok!"


@app.route('/rate/<bid>/<rate>')
def rate_book(bid, rate):
    global greeter
    global w3
    giveReview(w3, greeter, int(bid), int(rate))
    return "ok!"


if __name__ == '__main__':
    global greeter
    global w3
    w3, greeter = main()
    app.run(debug=True)