# Yomu 読む
[Yomu](http://erol.github.com/yomu) is a library for extracting text and metadata from files and documents using the [Apache TIKA](http://tika.apache.org/) content analysis toolkit.

Here are some of the formats supported:

- Microsoft Office OLE 2 and Office Open XML Formats (.doc, .docx, .xls, .xlsx,
  .ppt, .pptx)
- OpenOffice.org OpenDocument Formats (.odt, .ods, .odp)
- Apple iWorks Formats
- Rich Text Format (.rtf)
- Portable Document Format (.pdf)

For the complete list of supported formats, please visit the Apache TIKA
[Supported Document Formats](http://tika.apache.org/0.9/formats.html) page.

## Installation and Dependencies

Add this line to your application's Gemfile:

    gem 'yomu'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yomu

Yomu packages the Apache TIKA application jar and thus requires a working JRE for it to work.

## Usage

If you're not using Bundler, you will need to require Yomu in your application:

    require 'yomu'

You can extract text by calling `Yomu.read` directly:

    data = File.read 'sample.pages'
    text = Yomu.read :text, data

### Reading text from a given filename

You can also make a new instance of Yomu and pass a filename.

    yomu = Yomu.new 'sample.pages'
    text = yomu.text

### Reading text from a given URL

This is useful for reading remote files, like documents hosted on Amazon S3.

    yomu = Yomu.new 'http://svn.apache.org/repos/asf/poi/trunk/test-data/document/sample.docx'
    text = yomu.text

### Reading text from a stream

Yomu can also read from a stream or any object that responds to `read`, including Ruby on Rails' and Sinatra's file uploads:

    post '/:name/:filename' do
      yomu = Yomu.new params[:data]
      yomu.text
    end

## Contributing

1. Fork it
2. Create your feature branch ( `git checkout -b my-new-feature` )
3. Create tests and make them pass ( `rake test` )
4. Commit your changes ( `git commit -am 'Added some feature'` )
5. Push to the branch ( `git push origin my-new-feature` )
6. Create a new Pull Request