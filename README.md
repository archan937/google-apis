## Google APIs

A thin layer on top of [Google::APIClient](https://github.com/google/google-api-ruby-client) for a more intuitive way of working (e.g. with BigQuery)

### Installation

Add `GoogleApis` in your `Gemfile`:

    gem "google-apis"

Run the following in your console to install with Bundler:

    $ bundle install

### Usage

The easiest setup is to define an application-wide Google API connection followed by instantiating an API instance.

Make sure you have created a Client ID (application type "Service account") at your projects API credentials page (https://console.developers.google.com/project/your_project_id/apiui/credential).

Do not forget to download the private key by generating a P12 key file.

```ruby
[1] pry(main)> GoogleApis.connect :email_address => "lorem@developer.gserviceaccount.com", :private_key => "/path/to/private/key.p12"
=> true
[2] pry(main)> bq = Google::BigQuery.new :projectId => "your_project_id", :datasetId => "your_dataset_id"
=> #<Google::BigQuery:0x007fc5c68647a8 v2:[datasets,jobs,projects,tabledata,tables] {projectId:"your_project_id",datasetId:"your_dataset_id"}>
[3] pry(main)> bq.tables.list
=> {"kind"=>"bigquery#tableList",
 "etag"=>"\"Fo0B4r/LoR3M-1pSuM-D0loR-s1T-AM3t\"",
 "tables"=>
  [{"kind"=>"bigquery#table",
    "id"=>"your_project_id:your_dataset_id.awesome_table_19820801",
    "tableReference"=>{"projectId"=>"your_project_id", "datasetId"=>"your_dataset_id", "tableId"=>"awesome_table_19820801"},
    "type"=>"TABLE"}],
 "totalItems"=>1}
[4] pry(main)> bq.jobs.query :query => "SELECT * FROM [your_dataset_id.awesome_table_19820801] LIMIT 5"
=> {"kind"=>"bigquery#queryResponse",
 "schema"=>
  {"fields"=>
    [{"name"=>"awesome_column1", "type"=>"STRING", "mode"=>"NULLABLE"},
     {"name"=>"awesome_column2", "type"=>"STRING", "mode"=>"NULLABLE"},
     {"name"=>"awesome_column3", "type"=>"STRING", "mode"=>"NULLABLE"},
...
```

#### Easy API discovery info

GoogleApis quickly displays the resources and methods a certain API provides.

```ruby
[5] pry(main)> bq
=> #<Google::BigQuery:0x007fc5c68647a8 v2:[datasets,jobs,projects,tabledata,tables] {projectId:"your_project_id",datasetId:"your_dataset_id"}>
[6] pry(main)> bq.jobs
=> #<Google::BigQuery::Resource:0x007f8c09c60c68 v2:jobs:[get,getQueryResults,insert,list,query]>
[7] pry(main)> bq.jobs[:query]
=> {"id"=>"bigquery.jobs.query",
 "path"=>"projects/{projectId}/queries",
 "httpMethod"=>"POST",
 "description"=>"Runs a BigQuery SQL query synchronously and returns query results if the query completes within a specified timeout.",
 "parameters"=>{"projectId"=>{"type"=>"string", "description"=>"Project ID of the project billed for the query", "required"=>true, "location"=>"path"}},
 "parameterOrder"=>["projectId"],
 "request"=>{"$ref"=>"QueryRequest"},
 "response"=>{"$ref"=>"QueryResponse"},
 "scopes"=>["https://www.googleapis.com/auth/bigquery", "https://www.googleapis.com/auth/cloud-platform"]}
```

#### Application-wide API connections (e.g. Google::BigQuery.connection)

You can also configure an application-wide API connection. Let's say you also stored the connection configuration in `config/bigquery.yml`:

```yaml
---
  email_address: lorem@developer.gserviceaccount.com
  private_key: "/path/to/private/key.p12"
  projectId: your_project_id
  datasetId: your_dataset_id
```

```ruby
[1] pry(main)> require "yaml"
=> true
[2] pry(main)> Google::BigQuery.connect YAML.load_file("config/bigquery.yml")
=> #<Google::BigQuery:0x007fdc1c6823b0 v2:[datasets,jobs,projects,tabledata,tables] {projectId:"your_project_id",datasetId:"your_dataset_id"}>
[3] pry(main)> Google::BigQuery.connection.jobs
=> #<Google::BigQuery::Resource:0x007fdc1e94d5c0 v2:jobs:[get,getQueryResults,insert,list,query]>
[4] pry(main)> Google::BigQuery.connection.select_rows "SELECT * FROM [your_dataset_id.awesome_table_19820801] LIMIT 2"
=> [["1982-08-01", "Paul is awesome", "Paul", "Engel", 19],
 ["1982-08-01", "GoogleApis is cool", "Google", "Apis", 82],
 ["1982-08-01", "Hello world!", "Foo", "Bar", 8],
 ["1982-08-01", "Try out this gem :)", "It's", "very easy", 1]]
```

### Using the console

The GoogleApis repo is provided with `script/console` which you can use for development / testing purposes.

Run the following command in your console:

```ruby
$ script/console
Loading Google APIs development environment (0.1.0)
[1] pry(main)> GoogleApis.connect :email_address => "lorem@developer.gserviceaccount.com", :private_key => "/path/to/private/key.p12"
=> true
[2] pry(main)> bq = Google::BigQuery.new :projectId => "your_project_id", :datasetId => "your_dataset_id"
=> #<Google::BigQuery:0x007f8c09a05338 v2:[datasets,jobs,projects,tabledata,tables] {projectId:"your_project_id",datasetId:"your_dataset_id"}>
```

You can also define `script/config.yml` containing the connection config:

```yaml
---
  email_address: lorem@developer.gserviceaccount.com
  private_key: "/path/to/private/key.p12"
```

And immediately start instantiating a Google API:

```ruby
$ script/console
Loading Google APIs development environment (0.1.0)
[1] pry(main)> bq = Google::BigQuery.new :projectId => "your_project_id", :datasetId => "your_dataset_id"
=> #<Google::BigQuery:0x007fa6c9cc3450 v2:[datasets,jobs,projects,tabledata,tables] {projectId:"your_project_id",datasetId:"your_dataset_id"}>
```

### Testing

Run the following command for testing:

    $ rake

You can also run a single test file:

    $ ruby test/unit/test_google_apis.rb

### Contributing

Please feel free to fork this repository and send in pull requests to help improve GoogleApis ;)

### TODO

* Add more Google API definitions (see [google-apis/lib/google_apis/api](https://github.com/archan937/google-apis/tree/master/lib/google_apis/api))
* Add more tests

### License

Copyright (c) 2015 Paul Engel, released under the MIT License

http://github.com/archan937 – http://twitter.com/archan937 – http://gettopup.com – pm_engel@icloud.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
