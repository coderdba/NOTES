=======================
USING SQL
=======================

SELECT array_to_json(array_agg(row_to_json(t))) FROM 
    (SELECT col1, col2, col3 FROM example_table) t

---
select * from schema1.products;

select to_json(id) from schema1.products;

select to_json(name) from schema1.products;

select to_jsonb(id) from schema1.products;

select to_jsonb(name) from schema1.products;

row_to_json --> each row is presented as a json. however, all of them are not made an array or nested json.
select row_to_json(*) from schema1.products; --> Does not work
select row_to_json(t) from  (select * from schema1.products) t; --> works
"{""id"":1,""name"":""again something new"",""price"":9992323.98}"
"{""id"":3,""name"":""again something new 2"",""price"":2222323.22}"
"{""id"":20,""name"":""new1"",""price"":1.22}"

array_agg(row_to_json(t)) --> array of jsons of individual rows in the form  ({"{}","{}","{}"})
Note: Array is enclosed in {}. Each element is a "{}" - note the double quotes. Inside "{}" it will be name:value pairs of jsons.
      Essentially, each row's json is treated as an array element of string type
select array_agg(row_to_json(t)) from  (select * from schema1.products) t; 
{"{\"id\":1,\"name\":\"again something new\",\"price\":9992323.98}","{\"id\":3,\"name\":\"again something new 2\",\"price\":2222323.22}","{\"id\":20,\"name\":\"new1\",\"price\":1.22}"}
{"{"id":1,"name":"again something new","price":9992323.98}","{"id":3,"name":"again something new 2","price":2222323.22}","{"id":20,"name":"new1","price":1.22}"}

array_to_json(array_agg(row_to_json(t))) --> json of jsons of individual rows in the form [{},{}]
Note: A Json is enclosed in [].  Each element in it is a {} without double quotes. json of each row is treated as an element of an outer json.
select array_to_json(array_agg(row_to_json(t))) from  (select * from schema1.products) t; 
[{"id":1,"name":"again something new","price":9992323.98},{"id":3,"name":"again something new 2","price":2222323.22},{"id":20,"name":"new1","price":1.22}]

=======================
USING PYTHON EXTENSION
=======================
https://stackoverflow.com/questions/11198625/json-output-in-postgresql

On the server install:
sudo apt-get install postgresql-plpython-9.4

Then on your Postgres server:

CREATE EXTENSION IF NOT EXISTS plpythonu;
CREATE LANGUAGE plpythonu;

CREATE OR REPLACE FUNCTION prettyprint_json(data text)
 RETURNS json
 AS $$
    import json
    return json.dumps(json.loads(data), indent=4)
 $$ LANGUAGE plpythonu;

The postgresql plpython plugin certainly lets you do this using the python json library.

You can do something like this:

CREATE OR REPLACE FUNCTION myschema.tojsonfunc()
AS $$    

   import json;
   jsonStr = json.dumps(myrecord)

$$ LANGUAGE plpythonu;
