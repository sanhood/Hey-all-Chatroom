var express = require('express')
var app = express();
var db = require('./connection.js');
var http = require('http').Server(app);
var io = require('socket.io')(http);
var _ = require('underscore');
var body_parser = require('body-parser');
var moment = require('moment');
var PORT = process.env.PORT || 3000;

app.use(body_parser.json());
app.use(express.static(__dirname + '/public'));


function generate_token(userEmail) {
    var timestamp = moment().valueOf().toString();
    var a = (timestamp + userEmail + timestamp).split("");
    var b = [];
    for (var i = 0; i < 20; i++) {
        var j = (Math.random() * (a.length - 1)).toFixed(0);
        b[i] = a[j];
    }
    return b.join("");
}

function isTokenExist(userToken) {
    return new Promise(function (resolve, reject) {
        db.users.findOne({
            where: {
                token: userToken
            }
        }).then(function (user) {
            if (user) {
                resolve('resolve');
            } else {
                reject('reject');
            }
        }, function (err) {
            reject('reject');
        })
    })
}


//Socket part
io.on('connection', function (socket) {
    console.log('User connected via socket!');
    socket.on('message', function (message) {
        message.timeStamp = moment().valueOf();
        io.emit('message', message)
    });
    socket.on('invite', function (data) {
        io.emit('invite', data)
    });
});




//HTTP part
app.get('/getFavList', function (req, res) {
    var reqToken = _.pick(req.headers, 'auth').auth;
    var myID = _.pick(req.query,'id').id
    isTokenExist(reqToken).then(function () {
        //Token exists ....
        //find all friend IDs
        db.favorites.findAll({
            where:{
                leftID:myID
            }
        }).then(function(favs){
            var favIDs = []
            for (var i=0;i<favs.length;i++){
                favIDs.push(favs[i].rightID)
            }
            db.users.findAll({
                where:{
                    id:favIDs
                },
                attributes: ['id', 'nickName', 'firstName', 'lastName', 'bio', 'email', 'status']
            }).then(function(users){
                res.json(users)
            },function(err){
                res.status(400).send()
            })
        },function(err){
            console.log(err)
            res.status(400).send()
        })
    }, function () {
        //Token doesn't exist ....
        res.status(500).send()
    })
    
});




app.get('/getChatroomsByName', function (req, res) {
    var reqToken = _.pick(req.headers, 'auth').auth;
    isTokenExist(reqToken).then(function () {
        //Token exists ....
        var chatroomName = req.query.name
        if (chatroomName != "") {
            //find by name matching
            chatroomName = chatroomName.toLowerCase()
            var Op = db.Sequelize.Op
            db.chatrooms.findAll({
                where: {
                    name: {
                        [Op.like]: chatroomName + '%'
                    },
                    status: 1
                },
                order: [['population', 'DESC']],
                limit: 10
            }).then(function (chatrooms) {
                res.json(chatrooms)
            }, function (err) {
                res.status(400).send()
            })
        } else {
            //top 10 chatrooms
            db.chatrooms.findAll({
                where: {
                    status: 1
                },
                order: [['population', 'DESC']],
                limit: 10
            }).then(function (chatrooms) {
                res.json(chatrooms)
            }, function (err) {
                res.status(400).send()
            })
        }
    }, function () {
        //Token doesn't exist ....
        res.status(500).send()
    })
});


app.get('/getChatroomsByID', function (req, res) {
    var reqToken = _.pick(req.headers, 'auth').auth;
    isTokenExist(reqToken).then(function () {
        var chatroomIDs = req.query.IDs;
        var fields = chatroomIDs.split('-');
        db.chatrooms.findAll({
            where: {
                id: fields
            }
        }).then(function (chatrooms) {
            res.json(chatrooms);
        }, function (err) {
            console.log(err)
            res.status(404).send();
        })
    }, function () {
        res.status(500).send();
    })
});


app.get('/userInfo/:id', function (req, res) {
    var userId = parseInt(req.params.id, 10);
    db.users.findByPk(userId).then(function (user) {
        if (user) {
            res.json(user.toJSON());
        } else {
            res.status(404).send();
        }
    }, function (err) {
        res.status(500).send();
    });
});


app.post('/signup', function (req, res) {
    var body = _.pick(req.body, 'email');
    body.token = generate_token(body.email);
    db.users.create(body).then(function (user) {
        res.json(user);
    }, function (err) {
        res.status(400).json(err);
    });
});

app.post('/favUser', function (req, res) {
    var body = _.pick(req.body, 'rightID' , 'leftID');
    var reqToken = _.pick(req.headers, 'auth').auth;
    isTokenExist(reqToken).then(function () {
        //token exists...
        db.favorites.create(body).then(function(entry){
            res.json(entry)
        },function(err){
            console.log(err)
            res.status(400).send()
        })
    }, function () {
        //token doesn't exist...
        res.status(500).send();
    })
});

app.put('/editProfile', function (req, res) {
    var body = _.pick(req.body, 'nickName', 'bio','firstName','lastName');
    var reqToken = _.pick(req.headers, 'auth');
    var attr = {};
    console.log(body)
    if (body.hasOwnProperty('nickName')) {
        attr.nickName = body.nickName;
    }
    if (body.hasOwnProperty('bio')) {
        attr.bio = body.bio;
    }
    if (body.hasOwnProperty('firstName')) {
        attr.firstName = body.firstName;
    }
    if (body.hasOwnProperty('lastName')) {
        attr.lastName = body.lastName;
    }
    db.users.findAll({
        where: {
            token: reqToken.auth
        }
    }).then(function (user) {
        if (user) {
            return user[0].update(attr).then(function (user) {
                    res.json(user.toJSON(user));
                },
                function (err) {
                    console.log(err);
                    res.status(400).json(err);
                });
        } else {
            res.status(400).send();
        }
    }, function (err) {
        res.status(500).send();
    })
});

//



db.sequelize.sync().then(function () {
    http.listen(PORT, function () {
        console.log('Server started!');
    });
});
