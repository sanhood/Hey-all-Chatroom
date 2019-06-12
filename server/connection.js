var Sequelize = require('sequelize');
var sequelize = new Sequelize(undefined, undefined, undefined, {
    'dialect': 'sqlite',
    'storage': __dirname + 'database.sqlite'
});
var db = {};

db.users = sequelize.define('Users', {
    nickName: {
        type: Sequelize.STRING,
        validate: {
            len: [1, 255]
        }
    },
    email: {
        type: Sequelize.STRING,
        allowNull: false,
        unique: true,
        validate: {
            len: [1, 255],
            isEmail: true
        }
    },
    firstName: Sequelize.STRING,
    lastName: Sequelize.STRING,
    token: Sequelize.STRING,
    bio: Sequelize.TEXT,
    status: {
        type: Sequelize.BOOLEAN,
        defaultValue: 0
    }
}, {
    hooks: {
        beforeValidate: function (user, option) {
            if (typeof user.email === 'string') {
                user.email = user.email.toLowerCase();
            }
        }
    }
});

db.favorites = sequelize.define('Favorites', {
    leftID: {
        type: Sequelize.INTEGER,
        references: {
            model: 'Users',
            key: 'id'
        },
        allowNull: false
    },
    rightID: {
        type: Sequelize.INTEGER,
        references: {
            model: 'Users',
            key: 'id'
        },
        allowNull: false
    }
});

db.chatrooms = sequelize.define('Chatrooms', {
    name: {
        type: Sequelize.STRING,
        allowNull: false
    },
    status: {
        type: Sequelize.BOOLEAN,
        allowNull: false
    },
    category: {
        type: Sequelize.STRING,
        allowNull: false
    },
    population: {
        type: Sequelize.INTEGER,
        defaultValue: 0
    }
});
db.sequelize = sequelize;
db.Sequelize = Sequelize;
module.exports = db;
