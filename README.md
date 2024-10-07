# cratedig

Go+Gin web service storing my vinyl collection and serving it as a web app

The skeleton of this code is from the [golang tutorial for writing a web service
](https://go.dev/doc/tutorial/web-service-gin). It's a good tutorial, if you're
interested in this code you should read through that too.

The schema used here is a departure from the tutorial, it uses the same schema
found in Discog's API and published database snapshots.

## REST Service endpoints

<dl>
  <dt>/records</dt>
  <dd>
     * **GET** gets a list of vinyl records returned as JSON.  If no filters are
       specified, it will return the 20 most recent additions
     * **POST** adds a new album to the collection (auth required)
  </dd>

  <dt>/records/:id</dT>
  <dd>* **GET** gets the details of a vinyl record</dd>

  <dt>/artists/:id</dt>
  <dd>* **GET** gets details about an individual artist and the records they have appeared on</dd>
</dl>

## Database representation

The data is stored mostly as flat files on disk because the majority of release
information is written once and permanently set.

The collection information is also in a flat file but it will be moved into a
proper RDBMS after enough of the collection schema is defined and
after the collection data itself has been more fully populated. _(KISS principle)_

- releases/

  - 

- artists/

- instruments/

- collection/

  - releases.json
  - artists.json

## Developing and deploying

If you want to make a contribution, please run your own instance and share
screenshots of visible changes when making any pull requests.

// TODO: include build/test/deploy instructions here.
