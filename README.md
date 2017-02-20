# Ryan [![Gem Version](https://badge.fury.io/rb/ryan.svg)](http://badge.fury.io/rb/ryan) [![Build Status](https://travis-ci.org/ridiculous/ryan.svg)](https://travis-ci.org/ridiculous/ryan)

A wrapper around the awesome [RubyParser](https://github.com/seattlerb/ruby_parser) gem that provides an OO interface for
reading Ruby code.

## Installation

```ruby
gem 'ryan', '~> 1.1.0'
```

## Usage

Give Ryan a Ruby file or code string to play with. Test it out in an IRB session with `bin/console`

```ruby
ryan = Ryan.new FIXTURE_ROOT.join('report.rb') # or Ryan.new("<valid ruby code here>")
ryan.name
#=> "Report"
ryan.class?
#=> true
ryan.module?
#=> false
ryan.initialization_args
#=> [:message]
ryan.funcs.length
#=> 12
ryan.funcs.reject(&:private?).length
#=> 10
ryan.funcs.first.name
#=> :enqueue
```

### Assignments

```ruby
func = ryan.func_by_name(:call)
#=> #<Ryan::InstanceFunc:0x007fd49c10d8d0 @sexp=...>
func.assignments.length
#=> 1
func.assignments.first.name
#=> :@duder
```

### Conditions

```ruby
#=> "assigns @duder"
func.conditions.length
#=> 3
condition = func.conditions.last
#=> #<Ryan::Condition:0x007fd49c10d8d0 @sexp=...>
condition.statement
#=> "report.save"
condition.full_statement
#=> "if report.save then\n  UserMailer.spam(user).deliver_now if user.wants_mail?\n  report.perform\nelse\n  ..."
condition.if_sexp
#=> s(:call, s(:call, nil, :report), :perform)
condition.if_text
#=> "returns report.perform"
condition.else_text
#=> ""
```

### Condition Parts

```ruby
# Get the parts of the current condition, which will be the any elsif's
condition.parts.length
#=> 1
part = condition.parts.first
#=> #<Ryan::Condition:0x007fd49ca5a028 @sexp=...>
part.if_text
#=> "returns report.force_perform"
part.else_text
#=> "returns report.failure"
```

### Nested Conditions

```ruby
# Find conditions nested inside this condition
condition.nested_conditions.length
#=> 1
nested_condition = condition.nested_conditions.last
#=> #<Ryan::Condition:0x007fd49ca8bbf0 @sexp=...>
nested_condition.if_sexp
#=> s(:call, s(:call, s(:const, :UserMailer), :spam, s(:call, nil, :user)), :deliver_now)
nested_condition.if_text
#=> "returns UserMailer.spam(user).deliver_now"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake` to run the tests.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ridiculous/ryan.
