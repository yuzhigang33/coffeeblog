path = require 'path'
Sequelize = require 'sequelize'

dbpath = path.join __dirname, '../blog.db'
sequelize = new Sequelize null, null, null,
  dialect:'sqlite'
  storage: dbpath

articles = sequelize.define 'articles',
  aid:
    type: Sequelize.INTEGER
    primaryKey: true
    autoIncrement: true
  title:
    type: Sequelize.STRING
  content:
    type: Sequelize.TEXT
  , updatedAt:
      type: Sequelize.DATE
    createdAt:
      type: Sequelize.DATE

# articles.sync force: true
#   .then ->
#     articles.create
#       aid: 102
#       title: "sequelize test"
#       content: "sequelize test content,text"

articles.findAll()
  .then (result) ->
    console.log result
  .catch (err) ->
    console.log err
