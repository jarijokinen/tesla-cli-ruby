# tesla-cli-ruby

Control your Tesla Model 3/S/X from the command line.

## Usage

Use **tesla login** to log in to your Tesla Account.

Use **tesla help** to get list of available commands.

## Commands

```
tesla acoff           # Turns off the climate control (HVAC) system
tesla acon            # Turns on the climate control (HVAC) system
tesla help [COMMAND]  # Describe available commands or one specific command
tesla login           # Log in to your Tesla Account
tesla raw             # Show vehicle information in raw format
tesla temp            # Show temperature information
```

### Example

```
$ tesla temp
Current
  Inside:    12.5
  Outside:   12.5
Settings
  Driver:    20.0
  Passenger: 20.0

$ tesla acon
Climate control is ON

$ tesla acoff
Climate control is OFF
```

## License

MIT License. Copyright (c) 2019 [Jari Jokinen](https://jarijokinen.com).  See
[LICENSE](https://github.com/jarijokinen/tesla-cli-ruby/blob/master/LICENSE.txt)
for further details.
