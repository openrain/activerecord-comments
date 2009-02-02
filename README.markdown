activerecord-comments
=====================

THIS IS NOT DONE YET - THIS README IS JUST FOR HOW I HOPE THIS *WILL* WORK!
===========================================================================

Super duper simple gem.  I wanted a way to easily get to the comments 
defined in the database, via ActiveRecord.  While the underlying 
implementation may change to become faster and more database agnostic, 
the public API should remain the same.

Install
-------

    $ sudo gem install remi-activerecord-comments -s http://gems.github.com

Usage
-----

    >> require 'activerecord-comments'
    
    >> Fox.comment
    => "Represents a Fox, a creature that craves chunky bacon"

    >> Fox.columns
    => [#<ActiveRecord::...>, #<ActiveRecord::...>]

    >> Fox.column_names
    => ["id", "name", "has_had_truck_stolen"]

    >> Fox.column_comments
    => ["Primary Key", "Fox's name", "Whether or not this Fox has had his/her truck stolen"]

    >> Fox.columns.first.name
    => "id"

    >> Fox.columns.first.comment
    => "Primary Key"

We basically just add `ModelName.comment` and `@column.comment`

Database Support
----------------

For right now, I'm just supporting MySQL as it's what I'm using.  I'm not sure if SQLite3 supports 
table/column comments.  If it does, I definitely want to support it.

The gem is coded in such a way that it should be really easy to add comment support for 
your favorite database!
