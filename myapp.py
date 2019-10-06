from flask import Flask, jsonify
from flask_cors import CORS
from book import *
app = Flask(__name__)
CORS(app)

@app.route('/getbooks')
def bookgetter():
    global greeter
    books = getAllBooks(greeter)
    return jsonify(books)


@app.route('/getuserbooks')
def bookgetterbyuser():
    global greeter
    global w3
    books = getUserBooks(w3, greeter)
    return jsonify(books)


@app.route('/createbook/<author>/<price>/<title>/<cover>')
def create_book(author, price, title, cover):
    global greeter
    global w3
    createBook(w3, greeter, author, int(price), title, cover)
    return "ok!"


@app.route('/addbook/<bid>/<private_key>')
def add_book(bid, private_key):
    global greeter
    global w3
    if addBook(w3, greeter, int(bid), private_key):
        return "ok!"
    else:
        return "error!"


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