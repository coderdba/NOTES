===========================
GROOVY 'SQL' CLASS
===========================

===========================
SIMILAR TO WHAT I DID
===========================
https://www.baeldung.com/ratpack-groovy

7.2. Groovy Sql Class
We can use Groovy Sql for quick database operations, through methods like rows and executeInsert:

get('fetchUsers') {
    def db = [url:'jdbc:h2:mem:devDB']
    def sql = Sql.newInstance(db.url, db.user, db.password)
    def users = sql.rows("SELECT * FROM USER");
    render(Jackson.json(users))
}

$ curl -s localhost:5050/fetchUsers
[{"ID":1,"TITLE":"Mr","NAME":"Norman Potter","COUNTRY":"USA"},
{"ID":2,"TITLE":"Miss","NAME":"Ketty Smith","COUNTRY":"FRANCE"}]
Let's write an HTTP POST example with Sql:


post('addUser') {
    parse(Jackson.fromJson(User))
        .then { u ->
            def db = [url:'jdbc:h2:mem:devDB']
            Sql sql = Sql.newInstance(db.url, db.user, db.password)
            sql.executeInsert("INSERT INTO USER VALUES (?,?,?,?)", 
              [u.id, u.title, u.name, u.country])
            render "User $u.name inserted"
        }
}

$ curl -X POST -H 'Content-type: application/json' --data \
'{"id":3,"title":"Mrs","name":"Jiney Weiber","country":"UK"}' \
http://localhost:5050/addUser
 
User Jiney Weiber inserted
