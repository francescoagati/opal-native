Opal support for automagical native bridging
============================================

This gem gives to Opal a standard API to implement bridges to native objects and glue-less native
access and usage with the `Native()` helper function.

```ruby
o = Native(`$opal`)

o.global.console            # this will access the global console object and return it
o.global.console.log('wut') # this will call the log function on the console object

o.to_hash # this will return the object's properties as a Hash
          # you can also treat the object as an Enumerable

# keep in mind that when using the `.` syntax if the property is a function, it will be called
# if you want the value of the function you have to use `#[]` or `#[]=`.
```
