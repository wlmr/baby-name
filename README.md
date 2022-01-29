## Baby name

Tiny web page I created in order to try out [Elm]( https://guide.elm-lang.org/ ).

In it you can add names that you like and save them. Then let your parner go through the names and click the ones that she does not like, to remove them.

To run it simply run elm reactor from root and navigate to src/Main.elm in the browser.

In order to run you need a server capable of handling and serving json objects on address http://localhost:3000/names. 
I used [json-server]( https://github.com/typicode/json-server#getting-started ) which i ran using `$ json-server --id name db.json`
