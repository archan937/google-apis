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

Enable the API at your Console API page (https://console.developers.google.com/project/your_project_id/apiui/api).

Do not forget to download the private key by generating a P12 key file.

```ruby
[1] pry(main)> GoogleApis.connect :email_address => "lorem@developer.gserviceaccount.com", :private_key => "/path/to/private/key.p12"
=> #<GoogleApis::Connection:0x007fa5a4743668 [lorem@developer.gserviceaccount.com]>
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

#### Application-wide API connections

##### Google::BigQuery.connection

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
[3] pry(main)> Google::BigQuery.jobs
=> #<Google::BigQuery::Resource:0x007fdc1e94d5c0 v2:jobs:[get,getQueryResults,insert,list,query]>
[4] pry(main)> Google::BigQuery.select_rows "SELECT * FROM [your_dataset_id.awesome_table_19820801] LIMIT 4"
=> [["1982-08-01", "Paul is awesome", "Paul", "Engel", 19],
 ["1982-08-01", "GoogleApis is cool", "Google", "Apis", 82],
 ["1982-08-01", "Hello world!", "Foo", "Bar", 8],
 ["1982-08-01", "Try out this gem :)", "It's", "very easy", 1]]
```

Please note that `Google::BigQuery.connection` is provided with several methods resembling ActiveRecord: `#select_rows`, `#select_values` and `#select_value`.

##### Google::Storage.connection

The following example demonstrates how to download a file from Google Storage:

```ruby
[1] pry(main)> Google::Storage.connect :email_address => "lorem@developer.gserviceaccount.com", :private_key => "/path/to/private/key.p12"
=> #<Google::Storage:0x007fe522024f68 v1:[bucketAccessControls,buckets,channels,defaultObjectAccessControls,objectAccessControls,objects] {}>
[2] pry(main)> metadata = Google::Storage.objects.list :bucket => "your-bucket", :prefix => "path/to/your/file/awesome.tsv"
=> {"kind"=>"storage#objects",
 "items"=>
  [{"kind"=>"storage#object",
    "id"=>"your-bucket/path/to/your/file/awesome.tsv/1425499569141000",
    "selfLink"=>"https://www.googleapis.com/storage/v1/b/your-bucket/o/path%2Fto%2Fyour%2Ffile%2Fawesome.tsv",
    "name"=>"path/to/your/file/awesome.tsv",
    "bucket"=>"your-bucket",
    "generation"=>"1425499569141000",
    "metageneration"=>"1",
    "contentType"=>"text/tab-separated-values",
    "updated"=>"2015-03-04T20:06:09.141Z",
    "storageClass"=>"STANDARD",
    "size"=>"5592792",
    "md5Hash"=>"od4vAFihlDLs1k9kgo+U4CXhQ==",
    "mediaLink"=>"https://www.googleapis.com/download/storage/v1/b/your-bucket/o/path%2Fto%2Fyour%2Ffile%2Fawesome.tsv?generation=1425499569141000&alt=media",
    "owner"=>{"entity"=>"user-00b4903a97b10389ce680ca45ba5999e068c4d0c8ccbbfbb7094238bc85a567", "entityId"=>"00b4903a97b20004ce680ca5f5aeebe068c4d0c8ccbbfbb7094266d1b9787457"},
    "crc32c"=>"P4UlsJQ==",
    "etag"=>"EN93lyNu/j8QCEAE="}]}
[3] pry(main)> Google::Storage.download metadata["items"][0]["mediaLink"]
=> 5592792
[4] pry(main)> puts `ls -l | grep awesome`
-rw-rw-r--  1 paulengel  paulengel  5592792 Apr 17 16:38 awesome.tsv
=> nil
```

Easy, huh? :)

##### Google::Drive.connection

Please make sure that you also have created a "Public API access" server key and added your IP to the allowed IPs at the [API credentials page](https://console.developers.google.com/project/your_project_id/apiui/credential).

```ruby
[1] pry(main)> Google::Drive.connect :email_address => "lorem@developer.gserviceaccount.com", :private_key => "/path/to/private/key.p12"
=> #<Google::Drive:0x007f83ee39fcc8 v2:[about,apps,changes,channels,children,comments,files,parents,permissions,properties,realtime,replies,revisions] {}>
[2] pry(main)> Google::Drive.files.list
=> {"kind"=>"drive#fileList",
 "etag"=>"\"4GaIn/LoR3M-1pSuM-D0loR-s1T-AM3t\"",
 "selfLink"=>"https://www.googleapis.com/drive/v2/files",
 "items"=>
  [{"kind"=>"drive#file",
    "id"=>"12-On3Tw0w4ntO0-0neTh0",
...
```

#### One Google API connection to rule them all

If it isn't already clear, you can specify a global Google API connection and use different APIs:

```ruby
[1] pry(main)> GoogleApis.connect :email_address => "lorem@developer.gserviceaccount.com", :private_key => "/path/to/private/key.p12"
=> #<GoogleApis::Connection:0x007ffe0aa95d70 [lorem@developer.gserviceaccount.com]>
[2] pry(main)> Google::Drive.connect
=> #<Google::Drive:0x007fcfec1265b0 v2:[about,apps,changes,channels,children,comments,files,parents,permissions,properties,realtime,replies,revisions] {}>
[3] pry(main)> Google::Drive.files.list
=> {"kind"=>"drive#fileList",
...
[4] pry(main)> Google::BigQuery.connect :projectId => "your_project_id", :datasetId => "your_dataset_id"
=> #<Google::BigQuery:0x007ffe0b1fb240 v2:[datasets,jobs,projects,tabledata,tables] {projectId:"your_project_id",datasetId:"your_dataset_id"}>
[5] pry(main)> Google::BigQuery.tables.list
=> {"kind"=>"bigquery#tableList",
...
```

### Using the console

The GoogleApis repo is provided with `script/console` which you can use for development / testing purposes.

Run the following command in your console:

```ruby
$ script/console
Loading Google APIs development environment (0.1.0)
[1] pry(main)> GoogleApis.connect :email_address => "", :private_key => "/path/to/private/key.p12"
=> #<GoogleApis::Connection:0x007ff3d356cbf0 [lorem@developer.gserviceaccount.com]>
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
