package main

import (
  "log"
  "fmt"
  "net/http"
  "net/url"
  "net/http/httputil"
  "github.com/gorilla/mux"
  //"encoding/json"

  "io"
  "os"
  "time"
  "strings"
  "strconv"
	//"crypto/x509/pkix"

  // local pacakges
	//"certcheck/handlers"
)

const (
  serverport = ":10003"
)

//--------------------------------
func homePage(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "Welcome to API Invoker Homepage!") // writes to httpwriter
    fmt.Println("Endpoint Hit: HomePage")
}

//--------------------------------
func getJwt(w http.ResponseWriter, r *http.Request) {

    fmt.Println("getJwt(): Entering JWT getter")

    auth_url := os.Getenv("FR_AUTH_URL")
    consumer_key := os.Getenv("FR_CONSUMER_KEY")
    consumer_secret := os.Getenv("FR_CONSUMER_SECRET")

    client := &http.Client{
      Timeout: time.Second * 10,
    }

    data := url.Values{}
    data.Set("grant_type", "client_credentials")
    data.Set("client_id", consumer_key)
    data.Set("client_secret", consumer_secret)
    //data.Add("client_secret", consumer_secret)
    encodedData := data.Encode()

    fmt.Println("DEBUG - getJwt(): Encoded Data to post to auth-url:")
    fmt.Println(encodedData)

    req, err := http.NewRequest("POST", auth_url, strings.NewReader(encodedData))
    if err != nil {
      //return fmt.Errorf("ERR - getJwt(): Got error %s", err.Error())

      fmt.Println("ERR - getJwt(): Creating request - Got error: ", err.Error())
    }

    //req.Header.Add("Content-Type", "application/x-www-form-urlencoded")
    //req.Header.Add("Content-Length", strconv.Itoa(len(data.Encode())))

    req.Header.Set("Content-Type", "application/x-www-form-urlencoded")
    req.Header.Set("Content-Length", strconv.Itoa(len(data.Encode())))
    req.Header.Set("Cache-Control", "no-cache")

    // BEGIN DEBUG ONLY
    //fmt.Println("INFO - getJwt(): Req is: ", req)
    reqDump, err := httputil.DumpRequestOut(req, true)
    if err != nil {
        log.Fatal(err)
    }
    fmt.Printf("\n\nDEBUG - getJwt(): REQUEST:\n%s \n\n", string(reqDump))
    // END DEBUG

    response, err := client.Do(req)
    if err != nil {
      //return fmt.Errorf("Got error %s", err.Error())
      fmt.Println("ERR - getJwt(): Posting request - Got error: ", err.Error())
    }
    defer response.Body.Close()
}

//--------------------------------
func getCert(w http.ResponseWriter, r *http.Request) {

    fmt.Println("getCert(): Entering Cert getter")

    //api_url := "https://mycertcheckapi-dev.azurewebsites.net"
    api_url := "https://mycertcheckapi-dev.azurewebsites.net/url/batch/query"

    client := &http.Client{
      Timeout: time.Second * 10,
    }

    //data := url.Values{}
    //encodedData := data.Encode()
    //req, err := http.NewRequest("GET", api_url, strings.NewReader(encodedData))

    req, err := http.NewRequest("GET", api_url, nil)

    if err != nil {
      fmt.Println("ERR - getCert(): Creating request - Got error: ", err.Error())
    }

    response, err := client.Do(req)
    if err != nil {
      fmt.Println("ERR - getCert(): Posting request - Got error: ", err.Error())
      w.WriteHeader(422)
    } else {
      w.WriteHeader(200)
    }

    w.Header().Set("Content-Type", "application/json")
    //json.NewEncoder(w).Encode(response)

    //fmt.Fprintf(w, response.Body)

    b, err := io.ReadAll(response.Body)
    fmt.Fprintf(w, string(b))

    defer response.Body.Close()
}

//--------------------------------
func handleRequests() {

    fmt.Println("Entering: handleRequests()")

		// set up routes
		router := mux.NewRouter().StrictSlash(true)
    router.HandleFunc("/", homePage).Methods("GET")
    router.HandleFunc("/jwt", getJwt).Methods("POST")
    router.HandleFunc("/cert", getCert).Methods("GET")
		//router.HandleFunc("/cert-check-api", handlers.CertCheckAPIHandler).Methods("GET")

    fmt.Println("handleRequests(): Invoking web server")

		// start the server
    log.Fatal(http.ListenAndServe(serverport, router))
}

//-------------------------------------
func main() {
	handleRequests()
}
