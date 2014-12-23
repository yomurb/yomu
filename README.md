[![Travis Build Status](http://img.shields.io/travis/Erol/yomu.svg?style=flat)](https://travis-ci.org/Erol/yomu)
[![Code Climate Score](http://img.shields.io/codeclimate/github/Erol/yomu.svg?style=flat)](https://codeclimate.com/github/Erol/yomu)
[![Gem Version](http://img.shields.io/gem/v/yomu.svg?style=flat)](#)

# Yomu 読む

[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/Erol/yomu?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

[Yomu](http://erol.github.com/yomu) is a library for extracting text and metadata from files and documents using the [Apache Tika](http://tika.apache.org/) content analysis toolkit.

Here are some of the formats supported:

- Microsoft Office OLE 2 and Office Open XML Formats (.doc, .docx, .xls, .xlsx,
  .ppt, .pptx)
- OpenOffice.org OpenDocument Formats (.odt, .ods, .odp)
- Apple iWorks Formats
- Rich Text Format (.rtf)
- Portable Document Format (.pdf)

For the complete list of supported formats, please visit the Apache Tika
[Supported Document Formats](http://tika.apache.org/0.9/formats.html) page.

## Usage

Text, metadata and MIME type information can be extracted by calling `Yomu.read` directly:

```ruby
require 'yomu'

data = File.read 'sample.pages'
text = Yomu.read :text, data
metadata = Yomu.read :metadata, data
mimetype = Yomu.read :mimetype, data
```

### Reading text from a given filename

Create a new instance of Yomu and pass a filename.

```ruby
yomu = Yomu.new 'sample.pages'
text = yomu.text
```

### Reading text from a given URL

This is useful for reading remote files, like documents hosted on Amazon S3.

```ruby
yomu = Yomu.new 'http://svn.apache.org/repos/asf/poi/trunk/test-data/document/sample.docx'
text = yomu.text
```

### Reading text from a stream

Yomu can also read from a stream or any object that responds to `read`, including file uploads from Ruby on Rails or Sinatra.

```ruby
post '/:name/:filename' do
  yomu = Yomu.new params[:data][:tempfile]
  yomu.text
end
```

### Reading metadata

Metadata is returned as a hash.

```ruby
yomu = Yomu.new 'sample.pages'
yomu.metadata['Content-Type'] #=> "application/vnd.apple.pages"
```

### Reading MIME types

MIME type is returned as a MIME::Type object.

```ruby
yomu = Yomu.new 'sample.docx'
yomu.mimetype.content_type #=> "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
yomu.mimetype.extensions #=> ['docx']
```

## Installation and Dependencies

### Java Runtime

Yomu packages the Apache Tika application jar and requires a working JRE for it to work.

### Gem

Add this line to your application's Gemfile:

    gem 'yomu'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yomu

## Contributing

1. Fork it
2. Create your feature branch ( `git checkout -b my-new-feature` )
3. Create tests and make them pass ( `rake test` )
4. Commit your changes ( `git commit -am 'Added some feature'` )
5. Push to the branch ( `git push origin my-new-feature` )
6. Create a new Pull Request
